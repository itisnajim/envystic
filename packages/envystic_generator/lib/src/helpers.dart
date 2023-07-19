import 'package:analyzer/dart/element/element.dart';

import 'environment_field.dart';
import 'fields.dart';

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
