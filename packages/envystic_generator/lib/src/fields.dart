import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:envystic/envystic.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

abstract class Field<T> {
  const Field(
    this.name,
    this.type,
    this.isNullable,
    this.envKey,
    this.value,
    this.typePrefix,
  );

  static Field<dynamic> of({
    required Element element,
    required String name,
    required Type type,
    required bool isNullable,
    required KeyFormat keyFormat,
    String? nameOverride,
    DartObject? defaultValue,
    Map<String, String>? values,
    String? typePrefix,
  }) {
    final envKey = getEnvKey(name, keyFormat, nameOverride);
    final value = values?[envKey] ??
        Platform.environment[envKey] ??
        defaultValue?.toStringValue();

    if (value == null && !isNullable && !(type == dynamic || type == Object)) {
      throw InvalidGenerationSourceError(
        "Environment variable not found for field `$name`.",
        element: element,
      );
    }

    void throwInvalid() => throw InvalidGenerationSourceError(
          'Type `$type` does not align with value `$value`.',
          element: element,
        );

    if (value == null && !isNullable && (values ?? {}).containsKey(envKey)) {
      throwInvalid();
    }

    if (type == String) {
      if (!isNullable && value == null) throwInvalid();
      return StringField(name, type, isNullable, envKey, value, typePrefix);
    } else if (type == int) {
      if (!isNullable && int.tryParse(value ?? 'null') == null) throwInvalid();
      return IntField(name, type, isNullable, envKey, value, typePrefix);
    } else if (type == num) {
      if (!isNullable && num.tryParse(value ?? 'null') == null) throwInvalid();
      return NumField(name, type, isNullable, envKey, value, typePrefix);
    } else if (type == double) {
      if (!isNullable && double.tryParse(value ?? 'null') == null) {
        throwInvalid();
      }
      return DoubleField(name, type, isNullable, envKey, value, typePrefix);
    } else if (type == bool) {
      if (!isNullable && bool.tryParse(value ?? 'null') == null) throwInvalid();
      return BoolField(name, type, isNullable, envKey, value, typePrefix);
    } else if (type == dynamic) {
      return LikeDynamicField(
          name, type, isNullable, envKey, value, typePrefix);
    }
    /*else if (type is EnumType) {
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

  final String name;
  final Type type;
  final bool isNullable;
  final String envKey;
  final String? value;
  final String? typePrefix;

  String typeWithPrefix({required bool withNullability}) {
    final typePrefix = this.typePrefix;
    return '${typePrefix != null ? '$typePrefix.' : ''}$type${isNullable ? '?' : ''}';
  }

  T? parseValue();

  String? valueAsString() => parseValue()?.toString();

  String generate() {
    return """
      ${typeWithPrefix(withNullability: true)} get $name => getForField('$name');
    """;
  }
}

class StringField extends Field<String> {
  StringField(super.name, super.type, super.isNullable, super.envKey,
      super.value, super.typePrefix);

  @override
  String? parseValue() => value;

  @override
  String? valueAsString() {
    return parseValue();
  }
}

class NumField extends Field<num> {
  NumField(super.name, super.type, super.isNullable, super.envKey, super.value,
      super.typePrefix);

  @override
  num? parseValue() {
    if (value == null) return null;
    return num.parse(value!);
  }
}

class IntField extends Field<int> {
  IntField(super.name, super.type, super.isNullable, super.envKey, super.value,
      super.typePrefix);

  @override
  int? parseValue() {
    if (value == null) return null;
    return int.parse(value!);
  }
}

class DoubleField extends Field<double> {
  DoubleField(super.name, super.type, super.isNullable, super.envKey,
      super.value, super.typePrefix);

  @override
  double? parseValue() {
    if (value == null) return null;
    return double.parse(value!);
  }
}

class BoolField extends Field<bool> {
  BoolField(super.name, super.type, super.isNullable, super.envKey, super.value,
      super.typePrefix);

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
  LikeDynamicField(super.name, super.type, super.isNullable, super.envKey,
      super.value, super.typePrefix);

  @override
  parseValue() => value;
}

class EnumField extends Field<String> {
  EnumField(super.name, super.type, super.isNullable, super.envKey, super.value,
      super.typePrefix);

  @override
  String? parseValue() {
    //if (value == null)
    return null;

    /*final values = (type as InterfaceType)
        .accessors
        .where((e) => e.returnType.isAssignableTo(type))
        .map((e) => e.name);
    if (!values.contains(value)) {
      throw Exception('Invalid enum value for $type: $value');
    }

    return values.firstWhere((e) => e == value!.split('.').last);*/
  }

  @override
  String generate() {
    /*final value = parseValue();
    bool nullable = type.nullabilitySuffix != NullabilitySuffix.none;
    if (value == null && !nullable) {
      throw Exception('generate: No environment variable found for: $name');
    }*/

    return "";
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
