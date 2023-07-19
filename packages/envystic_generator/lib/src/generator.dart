import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:logging/logging.dart';
import 'package:build/build.dart';
import 'package:envystic/envystic.dart';
import 'package:source_gen/source_gen.dart';

import 'fields.dart';
import 'helpers.dart';
import 'load_envs.dart';

final logger = Logger('EnvysticGenerator:');

/// Generate code for classes annotated with the `@Envystic()`.
///
/// Will throw an [InvalidGenerationSourceError] if the annotated
/// element is not a [classElement].
class EnvysticGenerator extends GeneratorForAnnotation<Envystic> {
  const EnvysticGenerator({this.options});

  final BuilderOptions? options;

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@Envystic` can only be used on classes.',
        element: element,
      );
    }

    final className = element.name;
    final constructors =
        element.constructors.where((e) => e.isPrivate && e.isConst);
    final constructor = constructors.isEmpty ? null : constructors.first;
    if (constructor == null) {
      throw InvalidGenerationSourceError(
        '@Envystic annotation requires a const $className._() or private constructor',
        element: element,
      );
    }

    final envPath = annotation.read('path').stringValue;
    final encryptionKey = annotation.read('encryptionKey').isNull
        ? null
        : base64.encode(annotation.read('encryptionKey').stringValue.codeUnits);

    final keyFormatStr = annotation.read('keyFormat').isNull
        ? options?.config['key_format'] as String?
        : annotation.read('keyFormat').revive().accessor.split('.').last;
    final keyFormat =
        KeyFormat.values.where((v) => v.name == keyFormatStr).firstOrNull ??
            KeyFormat.none;

    final Map<String, String> values;
    try {
      values = await loadEnvs(envPath);
    } catch (e) {
      throw InvalidGenerationSourceError(
        e.toString(),
        element: element,
      );
    }
    final fields = <Field<dynamic>>[];

    final classFields = [
      ...element.allSupertypes.expand((e) => e.element.fields).where(
          (element) =>
              !element.isStatic &&
              !element.isPrivate &&
              element.kind == ElementKind.FIELD &&
              element.name != 'hashCode' &&
              element.name != 'runtimeType'),
      ...element.fields,
    ];
    final interface = getInterface(element);

    final library = element.library;

    //final library = await buildStep.inputLibrary;
    final fieldAnnotations = getAccessors(interface, library);

    for (final field in classFields) {
      final annotation =
          fieldAnnotations.where((e) => e.name == field.name).firstOrNull;
      if (annotation == null) continue;

      //final isAbstract = field.isAbstract || field.getter?.isAbstract == true;

      final nameOverride = annotation.nameOverride;
      final defaultValue = annotation.defaultValue;

      fields.add(Field.of(
        element: field,
        keyFormat: keyFormat,
        nameOverride: nameOverride,
        defaultValue: defaultValue,
        values: values,
      ));
    }

    final List<MapEntry<String, dynamic>> entries = [];
    final List<String> fieldsValues = [];
    for (final field in fields) {
      final key = field.fieldKey;
      final value = field.valueAsString();

      entries.add(MapEntry(key, encodeValue(value, encryptionKey)));
      fieldsValues.add(field.generate());
    }

    final jsonString = jsonEncode(Map.fromEntries(entries));
    final encodedJson = base64.encode(jsonString.codeUnits);

    String encodedEntries;
    if (encodedJson.contains("'")) {
      encodedEntries = 'static const String _encodedEntries = "$encodedJson";';
    } else {
      encodedEntries = "static const String _encodedEntries = '$encodedJson';";
    }

    final buffer = StringBuffer();

    buffer.writeln("""
      class _\$$className extends $className {
        const _\$$className() : super.${constructor.name}();

        static const String${encryptionKey == null ? '?' : ''} _encryptionKey = ${encryptionKey == null ? null : '"$encryptionKey"'};
        $encodedEntries
        ${fieldsValues.join('\n')}

      }""");

    return buffer.toString();
  }
}
