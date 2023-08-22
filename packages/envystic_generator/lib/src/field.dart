import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import 'imports.dart';

class Field {
  Field({
    required this.element,
    required this.name,
    this.customLoader,
    required this.type,
    this.dartType,
    required this.isNullable,
    required this.typeDisplayName,
    required this.envKey,
    this.value,
  }) {
    _validateField();
  }

  final Element element;
  final String name;
  final String? customLoader;
  final Type type;
  final DartType? dartType;
  final String typeDisplayName;
  final bool isNullable;
  final String envKey;
  final String? value;

  void _validateField() {
    /*if (value == null && !isNullable && type != dynamic) {
      throw InvalidGenerationSourceError(
        "Environment variable not found for field `$name`.",
        element: element,
      );
    }*/

    final parsedValue = _parseValue();
    if ((value?.isNotEmpty ?? false) &&
        !isNullable &&
        type != Enum &&
        parsedValue.runtimeType != type) {
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
    if (dartType != null && element.library != null) {
      return _resolveFullTypeStringFrom(
        element.library!,
        dartType!,
        withNullability: withNullability,
      );
    } else {
      return '$typeDisplayName${(withNullability && isNullable) ? '?' : ''}';
    }
  }

  /// Returns the [Element] for a given [DartType]
  ///
  /// this is usually type.element, except if it is a typedef then it is
  /// type.alias.element
  Element? _getElementForType(DartType type) {
    if (type is InterfaceType) {
      return type.element;
    }
    if (type is FunctionType) {
      return type.alias?.element;
    }
    return null;
  }

  String _resolveFullTypeStringFrom(
    LibraryElement originLibrary,
    DartType type, {
    required bool withNullability,
  }) {
    final owner = originLibrary.prefixes.where((e) {
      return e.imports.any((l) {
        return l.importedLibrary!.anyTransitiveExport((library) {
          return library.id == _getElementForType(type)?.library?.id;
        });
      });
    }).firstOrNull;

    String? displayType =
        type.getDisplayString(withNullability: withNullability);

    // The parameter is a typedef in the form of
    // SomeTypedef typedef
    //
    // In this case the analyzer would expand that typedef using getDisplayString
    // For example for:
    //
    // typedef SomeTypedef = Function(String);
    //
    // it would generate:
    // 'dynamic Function(String)'
    //
    // Instead of 'SomeTypedef'
    if (type is FunctionType && type.alias?.element != null) {
      displayType = type.alias!.element.name;
      if (type.alias!.typeArguments.isNotEmpty) {
        displayType += '<${type.alias!.typeArguments.join(', ')}>';
      }
      if (type.nullabilitySuffix == NullabilitySuffix.question) {
        displayType += '?';
      }
    }

    // The parameter is a Interface with a Type Argument that is not yet generated
    // In this case analyzer would set its type to InvalidType
    //
    // For example for:
    // List<ToBeGenerated> values,
    //
    // it would generate:  List<InvalidType>
    // instead of          List<dynamic>
    //
    // This a regression in analyzer 5.13.0
    if (type is InterfaceType &&
        type.typeArguments.any((e) => e is InvalidType)) {
      final dynamicType = type.element.library.typeProvider.dynamicType;
      var modified = type;
      modified.typeArguments.map((DartType type) {
        if (type is InvalidType) {
          return dynamicType;
        } else {
          return type;
        }
      }).toList();

      displayType = modified.getDisplayString(withNullability: withNullability);
    }

    if (owner != null) {
      return '${owner.name}.$displayType';
    }

    return displayType;
  }

  String? valueAsString() => _parseValue()?.toString();

  String getterDefinition() =>
      '${typeWithPrefix(withNullability: true)} get $name';

  String propertyDefinition({String keyword = 'final'}) =>
      '$keyword ${typeWithPrefix(withNullability: true)} $name';

  static bool isGetterDefinitionNullable(String definition) {
    return definition.contains('? ') || definition.contains('dynamic ');
  }

  String getterValue() {
    final extras = type != Enum
        ? ''
        : ", fromString: ${typeWithPrefix(withNullability: false)}.values.byName";
    return "getForField('$name'$extras)";
  }

  String generate() {
    return """
      ${getterDefinition()} => ${getterValue()};
    """;
  }
}

class ParameterInfo {
  const ParameterInfo({
    this.name,
    this.defaultValue,
    this.customLoader,
  });

  final String? name;
  final DartObject? defaultValue;
  final String? customLoader;
}

ParameterInfo? getParameterInfo(DartObject? obj) {
  if (obj == null) return null;

  final customLoader =
      obj.getField('customLoader')?.toFunctionValue()?.displayName;

  return ParameterInfo(
    name: obj.getField('name')?.toStringValue(),
    defaultValue: obj.getField('defaultValue'),
    customLoader: customLoader?.toString(),
  );
}
