import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:envystic/envystic.dart';

import 're_case.dart';

String getEnvKey(
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
      envKey = fieldKey.pascalCase;
      break;
    case KeyFormat.snake:
      envKey = fieldKey.snakeCase;
      break;
    case KeyFormat.kebab:
      envKey = fieldKey.pascalCase;
      break;
    case KeyFormat.screamingSnake:
      envKey = fieldKey.snakeCase.toUpperCase();
      break;
  }

  return envKey;
}

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

bool isEnum(Type type) {
  TypeMirror typeMirror = reflectType(type);
  return typeMirror is ClassMirror && typeMirror.isEnum;
}

/// Generates a random encryption key of the specified [length].
/// The encryption key is encoded in Base64 format.
///
/// Example usage:
/// ```dart
/// int keyLength = 16;
/// String encryptionKey = generateRandomEncryptionKey(keyLength);
/// print("Generated Encryption Key: $encryptionKey");
/// ```
String generateRandomEncryptionKey(int length) {
  const String validChars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  final Random secureRandom = Random.secure();
  final buffer = StringBuffer();

  for (var i = 0; i < length; i++) {
    buffer.write(validChars[secureRandom.nextInt(validChars.length)]);
  }

  String key = buffer.toString();
  List<int> bytes = utf8.encode(key);
  String base64Key = base64.encode(bytes);
  return base64Key;
}

/// Saves the provided [content] to a file at the given [filePath].
/// If the file already exists, its contents will be overwritten.
Future<File> saveContentToFile(String content, String filePath) {
  File file = File(filePath);

  // Create the file if it doesn't exist, and overwrite if it does.
  return file.writeAsString(content);
}
