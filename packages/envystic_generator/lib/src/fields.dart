import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:envystic/envystic.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

abstract class Field<T> {
  const Field(
    this._element,
    this.fieldKey,
    this.envKey,
    this.value,
  );

  static Field<dynamic> of({
    required FieldElement element,
    required KeyFormat keyFormat,
    required String? nameOverride,
    DartObject? defaultValue,
    Map<String, String>? values,
  }) {
    final type = element.type;
    final fieldKey = element.name;
    final envKey = getEnvKey(fieldKey, keyFormat, nameOverride);
    final value = values?[envKey] ??
        Platform.environment[envKey] ??
        defaultValue?.toStringValue();
    final nullable = type.isNullableType;

    if (value == null && !nullable && !type.isLikeDynamic) {
      throw InvalidGenerationSourceError(
        "Environment variable not found for field `$fieldKey`.",
        element: element,
      );
    }

    void throwInvalid() => throw InvalidGenerationSourceError(
          'Type `$type` does not align with value `$value`.',
          element: element,
        );

    if (value == null && !nullable && (values ?? {}).containsKey(envKey)) {
      throwInvalid();
    }

    if (type.isDartCoreString) {
      if (!nullable && value == null) throwInvalid();
      return StringField(element, fieldKey, envKey, value);
    } else if (type.isDartCoreInt) {
      if (!nullable && int.tryParse(value ?? 'null') == null) throwInvalid();
      return IntField(element, fieldKey, envKey, value);
    } else if (type.isDartCoreNum) {
      if (!nullable && num.tryParse(value ?? 'null') == null) throwInvalid();
      return NumField(element, fieldKey, envKey, value);
    } else if (type.isDartCoreDouble) {
      if (!nullable && double.tryParse(value ?? 'null') == null) throwInvalid();
      return DoubleField(element, fieldKey, envKey, value);
    } else if (type.isDartCoreBool) {
      if (!nullable && bool.tryParse(value ?? 'null') == null) throwInvalid();
      return BoolField(element, fieldKey, envKey, value);
    } else if (type.isLikeDynamic) {
      return LikeDynamicField(element, fieldKey, envKey, value);
    }
    /*else if (type.isEnum) {
      final name = defaultValue?.getField('_name')?.toStringValue();
      return EnumField(element, fieldKey, envKey, value ?? name);
    }*/

    throw InvalidGenerationSourceError(
      "Type `$type` not supported",
      element: element,
    );
  }

  static String getEnvKey(
    String fieldKey,
    KeyFormat format,
    String? nameOverride,
  ) {
    if (nameOverride != null) return nameOverride;

    String envKey;

    switch (format) {
      case KeyFormat.none:
        envKey = fieldKey;
        break;
      case KeyFormat.pascal:
        envKey = fieldKey.pascal;
        break;
      case KeyFormat.snake:
        envKey = fieldKey.snake;
        break;
      case KeyFormat.kebab:
        envKey = fieldKey.kebab;
        break;
      case KeyFormat.screamingSnake:
        envKey = fieldKey.snake.toUpperCase();
        break;
    }

    return envKey;
  }

  final FieldElement _element;
  final String fieldKey;
  final String envKey;
  final String? value;

  DartType get type => _element.type;

  String? get typePrefix {
    final identifier = type.element?.library?.identifier;
    if (identifier == null) return null;

    for (final e in _element.library.libraryImports) {
      if (e.importedLibrary?.identifier != identifier) continue;
      return e.prefix?.element.name;
    }
    return null;
  }

  String typeWithPrefix({required bool withNullability}) {
    final typePrefix = this.typePrefix;
    final type = this.type.getDisplayString(withNullability: withNullability);
    return '${typePrefix != null ? '$typePrefix.' : ''}$type';
  }

  T? parseValue();

  String? valueAsString() => parseValue()?.toString();

  String generate() {
    return """
      @override
      ${typeWithPrefix(withNullability: true)} get ${_element.name} => getEntryValue('$fieldKey', _encodedEntries, _encryptionKey);
    """;
  }
}

class StringField extends Field<String> {
  const StringField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  String? parseValue() => value;

  @override
  String? valueAsString() {
    return parseValue();
  }
}

class NumField extends Field<num> {
  const NumField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  num? parseValue() {
    if (value == null) return null;
    return num.parse(value!);
  }
}

class IntField extends Field<int> {
  const IntField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  int? parseValue() {
    if (value == null) return null;
    return int.parse(value!);
  }
}

class DoubleField extends Field<double> {
  const DoubleField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  double? parseValue() {
    if (value == null) return null;
    return double.parse(value!);
  }
}

class BoolField extends Field<bool> {
  const BoolField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  bool? parseValue() {
    switch (value?.toLowerCase()) {
      case null:
        return null;
      case 'true':
      case '1':
      case 'yes':
        return true;
      case 'false':
      case '0':
      case 'no':
      case '':
        return false;
      default:
        throw Exception('Invalid boolean value: $value');
    }
  }
}

class LikeDynamicField extends Field {
  LikeDynamicField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  parseValue() => value;
}

class EnumField extends Field<String> {
  const EnumField(
    super.element,
    super.fieldKey,
    super.envKey,
    super.value,
  );

  @override
  String? parseValue() {
    if (value == null) return null;

    final values = (type as InterfaceType)
        .accessors
        .where((e) => e.returnType.isAssignableTo(type))
        .map((e) => e.name);
    if (!values.contains(value)) {
      throw Exception('Invalid enum value for $type: $value');
    }

    return values.firstWhere((e) => e == value!.split('.').last);
  }

  @override
  String generate() {
    final value = parseValue();
    bool nullable = type.nullabilitySuffix != NullabilitySuffix.none;
    if (value == null && !nullable) {
      throw Exception('generate: No environment variable found for: $fieldKey');
    }

    return """
      @override
      ${typeWithPrefix(withNullability: true)} get ${_element.name} => _get(
        '$fieldKey',
        fromString: ${typeWithPrefix(withNullability: false)}.values.byName,
      );
    """;
  }

  @override
  String? valueAsString() {
    final value = parseValue();
    if (value == null) return null;
    return '${typeWithPrefix(withNullability: false)}.$value';
  }
}

class FieldInfo {
  FieldInfo(
    this.name,
    this.defaultValue,
  );

  final String? name;
  final DartObject? defaultValue;
}

FieldInfo? getFieldAnnotation(Element element) {
  final envysticFieldChecker = const TypeChecker.fromRuntime(EnvysticField);

  var obj = envysticFieldChecker.firstAnnotationOfExact(element);
  if (obj == null) return null;

  return FieldInfo(
    obj.getField('name')?.toStringValue(),
    obj.getField('defaultValue'),
  );
}
