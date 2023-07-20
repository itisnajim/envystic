import 'package:analyzer/dart/element/element.dart';

import 'environment_field.dart';
import 'fields.dart';

/// An extension method for the `FieldElement` class.
extension FieldElementExt on FieldElement {
  /// Retrieves the type prefix of the `FieldElement`.
  ///
  /// This method returns the prefix of the library that defines the `FieldElement`
  /// type, if it is imported in the current library where this extension is used.
  /// If the type is not imported, it returns `null`.
  String? get typePrefix {
    final identifier = type.element?.library?.identifier;
    if (identifier == null) return null;

    for (final e in library.libraryImports) {
      if (e.importedLibrary?.identifier != identifier) continue;
      return e.prefix?.element.name;
    }
    return null;
  }
}

InterfaceElement getInterface(Element element) {
  //assert(
  //  element.kind == ElementKind.CLASS || element.kind == ElementKind.ENUM,
  //  'Only classes or enums are allowed to be annotated with @Envystic.',
  //);

  assert(
    element.kind == ElementKind.CLASS,
    'Only classes are allowed to be annotated with @Envystic.',
  );

  return element as InterfaceElement;
}

Set<String> getAllAccessorNames(InterfaceElement interface) {
  var accessorNames = <String>{};

  var supertypes = interface.allSupertypes.map((it) => it.element);
  for (var type in [interface, ...supertypes]) {
    for (var accessor in type.accessors) {
      if (accessor.isSetter) {
        var name = accessor.name;
        accessorNames.add(name.substring(0, name.length - 1));
      } else {
        accessorNames.add(accessor.name);
      }
    }
  }

  return accessorNames;
}

List<EnvironmentField> getAccessors(
  InterfaceElement interface,
  LibraryElement library,
) {
  var accessorNames = getAllAccessorNames(interface);

  var getters = <EnvironmentField>[];
  var setters = <EnvironmentField>[];
  for (var name in accessorNames) {
    var getter = interface.lookUpGetter(name, library);
    if (getter != null) {
      var getterAnn =
          getFieldAnnotation(getter.variable) ?? getFieldAnnotation(getter);
      if (getterAnn != null) {
        var field = getter.variable;
        getters.add(EnvironmentField(
          field.name,
          getterAnn.name,
          field.type,
          getterAnn.defaultValue,
        ));
      }
    }

    var setter = interface.lookUpSetter('$name=', library);
    if (setter != null) {
      var setterAnn =
          getFieldAnnotation(setter.variable) ?? getFieldAnnotation(setter);
      if (setterAnn != null) {
        var field = setter.variable;
        setters.add(EnvironmentField(
          field.name,
          setterAnn.name,
          field.type,
          setterAnn.defaultValue,
        ));
      }
    }
  }

  return [...getters, ...setters];
}

String incrementLastInt(String input) {
  if (input.trim().isEmpty) return input;
  RegExp regex = RegExp(
      r'\d+$'); // Regular expression to find the last integer in the string
  Match? match = regex.firstMatch(input);

  if (match != null) {
    int lastInt = int.parse(match.group(0)!);
    String prefix = input.substring(0, match.start);
    String newInt = (lastInt + 1).toString();
    return prefix + newInt;
  } else {
    return '${input}2';
  }
}
