import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:envystic/envystic.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

class Field {
  Field({
    required this.element,
    required this.name,
    required this.type,
    this.dartType,
    required this.isNullable,
    required this.typeDisplayName,
    required this.envKey,
    this.value,
    this.typePrefix,
  }) {
    _validateField();
  }

  final Element element;
  final String name;
  final Type type;
  final DartType? dartType;
  final String typeDisplayName;
  final bool isNullable;
  final String envKey;
  final String? value;
  final String? typePrefix;

  void _validateField() {
    if (value == null && !isNullable && type != dynamic) {
      throw InvalidGenerationSourceError(
        "Environment variable not found for field `$name`.",
        element: element,
      );
    }

    final parsedValue = _parseValue();
    if (!isNullable && parsedValue == null) {
      throw InvalidGenerationSourceError(
        "Type `$type` does not align with value `$value`.",
        element: element,
      );
    }
  }

  dynamic _parseValue() {
    if (type == String) {
      return value;
    } else if (type == int) {
      return value != null ? int.tryParse(value!) : null;
    } else if (type == num) {
      return value != null ? num.tryParse(value!) : null;
    } else if (type == double) {
      return value != null ? double.tryParse(value!) : null;
    } else if (type == bool) {
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
          throw InvalidGenerationSourceError(
            'Type `bool` does not align with value `$value`.',
            element: element,
          );
      }
    } else if (type == dynamic || type == Object) {
      return value;
    } else if (type == Enum) {
      if (value == null) return null;

      final values = (dartType as InterfaceType)
          .accessors
          .where((e) => e.returnType.isAssignableTo(dartType!))
          .map((e) => e.name);
      if (!values.map((e) => e.toLowerCase()).contains(value?.toLowerCase())) {
        throw InvalidGenerationSourceError(
          'Invalid enum value for `$dartType`: `$value`.',
          element: element,
        );
      }

      return values.firstWhere(
          (e) => e.toLowerCase() == value?.toLowerCase().split('.').last);
    }

    throw InvalidGenerationSourceError(
      "Type '$type' not supported",
      element: element,
    );
  }

  String typeWithPrefix({required bool withNullability}) {
    final typePrefix = this.typePrefix;
    return '${typePrefix != null ? '$typePrefix.' : ''}$typeDisplayName${(withNullability && isNullable) ? '?' : ''}';
  }

  String? valueAsString() => _parseValue()?.toString();

  String generate() {
    return """
      ${typeWithPrefix(withNullability: true)} get $name => getForField('$name');
    """;
  }
}

class FieldInfo {
  const FieldInfo(this.name, this.defaultValue);

  final String? name;
  final DartObject? defaultValue;
}

FieldInfo? getFieldAnnotation(Element element) {
  final envysticFieldChecker = const TypeChecker.fromRuntime(EnvysticField);

  final obj = envysticFieldChecker.firstAnnotationOfExact(element);
  if (obj == null) return null;

  return FieldInfo(
    obj.getField('name')?.toStringValue(),
    obj.getField('defaultValue'),
  );
}
