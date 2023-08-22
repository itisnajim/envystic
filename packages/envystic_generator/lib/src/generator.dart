import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

import 'package:logging/logging.dart';
import 'package:build/build.dart';
import 'package:envystic/envystic.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'field.dart';
import 'helpers.dart';
import 'key_info.dart';
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
  final BuilderOptions? options;

  String? optionsEncryptionKey;
  Map<String, KeyInfo> elementsKeys = {};
  EnvysticGenerator({
    this.options,
  }) : optionsEncryptionKey = options.tryGetOrGenerateKey;

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final annotatedClasses = library.annotatedWith(typeChecker);

    for (var annotatedElement in annotatedClasses) {
      final annotation = annotatedElement.annotation;
      final element = annotatedElement.element;
      final className = element.name ?? '';
      final keyInfo = KeyInfo(
        annotation.encryptionKeyOutput(options),
        annotation.tryGetOrGenerateKey(options),
      );
      elementsKeys.addAll({className: keyInfo});
    }

    final result = super.generate(library, buildStep);

    return options
        .writeEncryptionKeyIfNeeded(optionsEncryptionKey)
        .then((_) => result);
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

    List<ParameterElement> parametersFromConstructors(
        Iterable<ConstructorElement> constructors) {
      return constructors
          .where((c) => c.name == "define")
          .map((e) => e.parameters)
          .expand((p) => p)
          .toList();
    }

    final classesParameters = parametersFromConstructors(
      [
        ...element.allSupertypes
            .expand((e) => e.constructors.where((c) => c.isFactory)),
        ...element.constructors.where((c) => c.isFactory)
      ],
    );

    Set<String> uniqueNames = <String>{};
    final List<ParameterElement> parameters = [];
    for (ParameterElement parameter in classesParameters) {
      if (!uniqueNames.contains(parameter.name)) {
        uniqueNames.add(parameter.name);
        parameters.add(parameter);
      }
    }

    /*final classFields = [
      ...element.allSupertypes.expand((e) => e.element.fields).where(
          (element) =>
              !element.isStatic &&
              !element.isPrivate &&
              element.kind == ElementKind.FIELD &&
              element.name != 'hashCode' &&
              element.name != 'runtimeType'),
      ...element.fields,
    ];*/

    final fieldEnumType = <String, String>{};

    final fields = <Field>[];
    final definedFields = <Field>[];

    try {
      for (final indexedParameterElement in parameters.indexed) {
        final parameterElement = indexedParameterElement.$2;
        //if (annotation == null) continue;
        //final isAbstract = parameterElement.isAbstract || parameterElement.getter?.isAbstract == true;
        final annotation = parameterElement.metadata
            .map(
              (a) => a.element == null
                  ? null
                  : getParameterInfo(a.computeConstantValue()),
            )
            .toList()
            .firstOrNull;
        final nameOverride = annotation?.name;
        final defaultValue = annotation?.defaultValue;
        final customLoader = annotation?.customLoader;

        final typeDisplayName =
            parameterElement.type.getDisplayString(withNullability: false);

        final type = getType(parameterElement.type);

        final isNullable = parameterElement.type.nullabilitySuffix ==
            NullabilitySuffix.question;

        final name = parameterElement.name;

        final envKey = getEnvKey(name, keyFormat, nameOverride);

        final value = values[envKey] ??
            Platform.environment[envKey] ??
            defaultValue?.toStringValue();

        final field = Field(
          element: parameterElement,
          name: name,
          customLoader: customLoader,
          type: type,
          dartType: parameterElement.type,
          isNullable: isNullable,
          envKey: envKey,
          value: value,
          typeDisplayName: typeDisplayName,
        );

        fields.add(field);
        definedFields.add(field);

        if (parameterElement.type.isEnum) {
          fieldEnumType.addAll({
            escapeDartString(parameterElement.name):
                field.typeWithPrefix(withNullability: false),
          });
        }
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
        if (fields.where((f) => f.name == name).isNotEmpty) {
          name = incrementLastInt(name);
        }

        final type = getTypeFromString(value);
        final typeDisplayName = type.toString().replaceAll('?', '');

        final field = Field(
          element: element,
          name: name,
          type: type,
          envKey: key,
          isNullable: value.isEmpty,
          value: value,
          typeDisplayName: typeDisplayName,
        );

        fields.add(field);

        if (isEnum(type)) {
          fieldEnumType.addAll({
            escapeDartString(name):
                field.typeWithPrefix(withNullability: false),
          });
        }
      });
    }

    final keyInfo = elementsKeys[className];

    final List<MapEntry<String, dynamic>> entries = [];
    final List<MapEntry<String, String>> envKeyFieldPairs = [];
    final Map<String, String> fieldsValues = {};

    for (final field in fields) {
      final name = field.name;
      final envKey = field.envKey;
      final value = field.valueAsString();

      entries.add(MapEntry(
        name,
        encodeValue(value, keyInfo?.key ?? optionsEncryptionKey),
      ));
      envKeyFieldPairs.add(MapEntry(envKey, name));
      fieldsValues.addAll({field.getterDefinition(): field.getterValue()});
    }

    final entriesJsonStr = jsonEncode(Map.fromEntries(entries));
    final encodedJson = base64.encode(entriesJsonStr.codeUnits);
    final envKeyFieldPairsJsonStr =
        jsonEncode(Map.fromEntries(envKeyFieldPairs));
    final encodedKeysFieldsJson =
        base64.encode(envKeyFieldPairsJsonStr.codeUnits);

    final Map<String, String> definedFieldsValues = Map.fromEntries(
      definedFields.map(
        (f) => MapEntry(f.getterDefinition(), f.getterValue()),
      ),
    );

    final buffer = StringBuffer();
    buffer.writeln("""
      final _privateConstructorUsedError = UnsupportedError(
          'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by envystic and you are not supposed to need it nor use it.');

      const String _encodedEntries = ${escapeDartString(encodedJson)};
      const String _encodedKeysFields = ${escapeDartString(encodedKeysFieldsJson)};

      abstract class _\$$className with IEnvystic {
        const _\$$className();

        @override
        String get encodedEntries\$ => _encodedEntries;
        @override
        String get encodedKeysFields\$ => _encodedKeysFields;
        @override
        ValuesPriority get valuesPriority\$ => ValuesPriority();

        ${fieldsValues.keys.map((key) => '$key => throw _privateConstructorUsedError;').join('\n')}

        $className copyWith({required ValuesPriority valuesPriority}) =>
              throw _privateConstructorUsedError;
      }
      
      
      class _$className extends $className {
        @override
        final String? encryptionKey\$;
        @override
        final ValuesPriority valuesPriority\$;
        const _$className({
          String? encryptionKey,
          ValuesPriority? valuesPriority,
        })  : encryptionKey\$ = encryptionKey,
              valuesPriority\$ = valuesPriority ?? const ValuesPriority(),
              super._();

        ${fieldsValues.entries.map((entry) => '@override\n${entry.key} => ${entry.value};').join('\n')}

        @override
        Map<String, CustomLoader?> get customLoaders\$ => {
          ${fields.where((e) => e.customLoader != null).map((e) => "'${e.name}': ${e.customLoader}").join('\n')}
        };

        @override
        $className copyWith({required ValuesPriority valuesPriority}) => _$className(
          encryptionKey: encryptionKey\$,
          valuesPriority: valuesPriority,
        );
      }

      class _${className}Define extends $className {
        const _${className}Define(
          ${definedFieldsValues.isEmpty ? '' : '{\n ${definedFieldsValues.keys.indexed.map((indexKey) => '${!Field.isGetterDefinitionNullable(indexKey.$2) ? 'required ' : ''}this.${definedFields[indexKey.$1].name},').join('\n')}}'}
          ) : super._();


        ${definedFields.map((e) => '@override\n${e.propertyDefinition()};').join('\n')}
      }
      """);

    return annotation
        .writeEncryptionKeyIfNeeded(
          keyInfo?.key ?? optionsEncryptionKey,
          options,
        )
        .then((_) => buffer.toString());
  }
}

/// Extension for [BuilderOptions] to add custom getters.
extension BuilderOptionsExtension on BuilderOptions? {
  /// Returns the value of the 'encryption_key_output' configuration as a String,
  /// or null if it's not available or not a String.
  String? get encryptionKeyOutput =>
      this?.config['encryption_key_output'] as String? ??
      (mustGenerateEncryption ? EncryptionKeyFile.defaultPath : null);

  /// Parses the 'generate_encryption' configuration value as a boolean.
  /// If the value is not a valid boolean representation, it defaults to false.
  bool get mustGenerateEncryption =>
      bool.tryParse(this?.config['generate_encryption'].toString() ?? '') ??
      false;

  String? get tryGetOrGenerateKey {
    var encryptionKey =
        !mustGenerateEncryption ? null : generateRandomEncryptionKey(16);
    if (encryptionKeyOutput != null) {
      encryptionKey =
          EncryptionKeyFile(encryptionKeyOutput).readSync() ?? encryptionKey;
    }
    return encryptionKey;
  }

  Future<File?> writeEncryptionKeyIfNeeded(String? encryptionKey) {
    if (encryptionKey == null) return Future.value(null);
    if (encryptionKeyOutput == null) return Future.value(null);
    return EncryptionKeyFile(encryptionKeyOutput).write(encryptionKey);
  }
}

extension ConstantReaderExt on ConstantReader {
  bool mustGenerateEncryption(BuilderOptions? options) =>
      !read('generateEncryption').isNull
          ? read('generateEncryption').boolValue
          : options.mustGenerateEncryption;

  String? encryptionKeyOutput(BuilderOptions? options) =>
      !read('encryptionKeyOutput').isNull
          ? read('encryptionKeyOutput').stringValue
          : mustGenerateEncryption(options)
              ? options.encryptionKeyOutput ?? EncryptionKeyFile.defaultPath
              : null;

  bool isEncrypted(BuilderOptions? options) =>
      mustGenerateEncryption(options) || encryptionKeyOutput(options) != null;

  String? tryGetOrGenerateKey(BuilderOptions? options) {
    final String? keyOutput = encryptionKeyOutput(options);
    var encryptionKey = !mustGenerateEncryption(options)
        ? null
        : generateRandomEncryptionKey(16);

    if (keyOutput != null) {
      encryptionKey = EncryptionKeyFile(keyOutput).readSync() ?? encryptionKey;
    }
    return encryptionKey;
  }

  Future<File?> writeEncryptionKeyIfNeeded(
    String? encryptionKey,
    BuilderOptions? options,
  ) {
    if (encryptionKey == null) return Future.value(null);
    final String? optionsEncryptionKeyOutput = options.encryptionKeyOutput;
    final filePath = encryptionKeyOutput(options);

    if (filePath == null) return Future.value(null);
    if (optionsEncryptionKeyOutput == filePath) {
      return Future.value(null);
    }

    return EncryptionKeyFile(filePath).write(encryptionKey);
  }
}
