import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

import 'package:logging/logging.dart';
import 'package:build/build.dart';
import 'package:envystic/envystic.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'fields.dart';
import 'helpers.dart';
import 'load_envs.dart';
import 'types.dart';
import 're_case.dart';
import 'encryption_key_file.dart';

final logger = Logger('EnvysticGenerator:');

/// Generate code for classes annotated with the `@Envystic()`.
///
/// Will throw an [InvalidGenerationSourceError] if the annotated
/// element is not a [classElement].
class EnvysticGenerator extends GeneratorForAnnotation<Envystic> {
  String? encryptionKey;
  EnvysticGenerator({
    this.options,
  }) : encryptionKey = EncryptionKeyFile(options.encryptionKeyOutput).read();

  final BuilderOptions? options;

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    if (options.generateEncryption && encryptionKey == null) {
      encryptionKey = generateRandomEncryptionKey(16);
    }

    final result = super.generate(library, buildStep);

    if (encryptionKey != null) {
      Future.value(result).then((_) {
        return EncryptionKeyFile(options.encryptionKeyOutput)
            .write(encryptionKey!);
      }).onError(
          (error, stackTrace) => throw error ?? "Unknown error ocurred.");
    }

    return result;
  }

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final isAll = annotation.instanceOf(TypeChecker.fromRuntime(EnvysticAll));
    final annotationType = isAll ? EnvysticAll : Envystic;
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@$annotationType` can only be used on classes.',
        element: element,
      );
    }

    final className = element.name;

    final envPath = annotation.read('path').stringValue;
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

    final fieldAnnotations = getAccessors(interface, element.library);

    try {
      for (final field in classFields) {
        final annotation =
            fieldAnnotations.where((e) => e.name == field.name).firstOrNull;
        if (annotation == null) continue;
        //final isAbstract = field.isAbstract || field.getter?.isAbstract == true;

        final nameOverride = annotation.nameOverride;
        final defaultValue = annotation.defaultValue;

        fields.add(Field.of(
          element: field,
          name: field.name,
          type: getType(field.type),
          isNullable:
              field.type.nullabilitySuffix == NullabilitySuffix.question,
          keyFormat: keyFormat,
          nameOverride: nameOverride,
          defaultValue: defaultValue,
          values: values,
          typePrefix: field.typePrefix,
        ));
      }
    } catch (e) {
      if (e is InvalidGenerationSourceError) rethrow;
      throw InvalidGenerationSourceError(e.toString(), element: element);
    }

    if (isAll) {
      final remainingValues = Map<String, String>.from(values)
        ..removeWhere((key, _) => fields.map((e) => e.envKey).contains(key));
      remainingValues.forEach((key, value) {
        var name = key.camelCase;
        // print('remainingValues: key $key, value: $value, fieldName: $name');
        if (fields.where((f) => f.name == name).isNotEmpty) {
          name = incrementLastInt(name);
        }
        fields.add(Field.of(
          element: element,
          name: name,
          nameOverride: key,
          type: getTypeFromString(value),
          isNullable: value.isEmpty,
          keyFormat: keyFormat,
          values: values,
          typePrefix: null,
        ));
      });
    }

    final List<MapEntry<String, dynamic>> entries = [];
    final List<MapEntry<String, String>> envKeyFieldPairs = [];
    final List<String> fieldsValues = [];
    for (final field in fields) {
      final name = field.name;
      final envKey = field.envKey;
      final value = field.valueAsString();

      entries.add(MapEntry(name, encodeValue(value, encryptionKey)));
      envKeyFieldPairs.add(MapEntry(envKey, name));
      fieldsValues.add(field.generate());
    }

    final entriesJsonStr = jsonEncode(Map.fromEntries(entries));
    final encodedJson = base64.encode(entriesJsonStr.codeUnits);
    final envKeyFieldPairsJsonStr =
        jsonEncode(Map.fromEntries(envKeyFieldPairs));
    final encodedKeysFieldsJson =
        base64.encode(envKeyFieldPairsJsonStr.codeUnits);

    final buffer = StringBuffer();

    buffer.writeln("""
      const String _encodedEntries = ${escapeDartString(encodedJson)};
      const String _encodedKeysFields = ${escapeDartString(encodedKeysFieldsJson)};

      class _\$$className extends EnvysticInterface {
        const _\$$className({super.encryptionKey});

        @override
        String get encodedEntries => _encodedEntries;
        @override
        String get encodedKeysFields => _encodedKeysFields;

        ${fieldsValues.join('\n')}

      }""");

    return buffer.toString();
  }
}

/// Extension for [BuilderOptions] to add custom getters.
extension BuilderOptionsExtension on BuilderOptions? {
  /// Returns the value of the 'encryption_key_output' configuration as a String,
  /// or null if it's not available or not a String.
  String get encryptionKeyOutput =>
      this?.config['encryption_key_output'] as String? ??
      EncryptionKeyFile.defaultPath;

  /// Parses the 'generate_encryption' configuration value as a boolean.
  /// If the value is not a valid boolean representation, it defaults to false.
  bool get generateEncryption =>
      bool.tryParse(this?.config['generate_encryption'].toString() ?? '') ??
      false;
}
