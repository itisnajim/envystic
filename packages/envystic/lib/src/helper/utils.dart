import 'dart:convert';

import 'package:meta/meta.dart';

import '../annotation/envystic_field.dart';
import '../values_priority.dart';
import 'encrypter.dart';
import 'platform_environment_map.dart';

bool _isNullable<T>() => null is T;

bool _isSubtype<S, T>() => <S>[] is List<T>;

T _parseValue<T>(
  String? strValue, {
  T Function(String)? fromString,
}) {
  final isNullable = _isNullable<T>();
  final isSubtypeEnum = _isSubtype<T, Enum>();

  if (strValue == null && !['dynamic', 'Object?'].contains(T.toString())) {
    if (isNullable) return null as T;
    throw Exception('Type `${T.toString()}` does not align with value `null`.');
  }

  if (['String', 'String?'].contains(T.toString())) {
    return strValue as T;
  }

  if (['int', 'int?'].contains(T.toString())) {
    final parsedValue =
        isNullable ? int.tryParse(strValue!) : int.parse(strValue!);
    return parsedValue as T;
  }

  if (['double', 'double?'].contains(T.toString())) {
    final parsedValue =
        isNullable ? double.tryParse(strValue!) : double.parse(strValue!);
    return parsedValue as T;
  }

  if (['num', 'num?'].contains(T.toString())) {
    final parsedValue =
        isNullable ? num.tryParse(strValue!) : num.parse(strValue!);
    return parsedValue as T;
  }

  if (['bool', 'bool?'].contains(T.toString())) {
    final parsedValue = strValue!.toLowerCase() == 'true';
    return parsedValue as T;
  }

  if (isSubtypeEnum && strValue != null) {
    if (fromString == null) {
      throw Exception(
          'A valid fromString method must be provided to parse `$strValue`.');
    }
    try {
      return fromString(strValue);
    } catch (e) {
      throw Exception(
          'Type `${T.toString()}` does not align with value `$strValue`.');
    }
  }

  // For dynamic and other unsupported types, a simpler conversion can be used.
  return (
    strValue == null
        ? null
        : (
            int.tryParse(strValue) ??
                double.tryParse(strValue) ??
                num.tryParse(strValue) ??
                bool.tryParse(strValue) ??
                strValue,
          ),
  ) as T;
}

/// **Ignore This Method** Used by the package
String? encodeValue(String? value, String? encryptionKey) {
  if (value == null) return null;

  final encryptedBytes = encryptionKey != null
      ? Encrypter(encryptionKey).encrypt(value)
      : value.codeUnits;

  return base64.encode(encryptedBytes);
}

/// **Ignore This Method** Used by the package
@internal
String? decodeValue(String? encodedValue, String? encryptionKey) {
  if (encodedValue == null) return null;

  final decodedBytes = base64.decode(encodedValue);
  final decryptedBytes = encryptionKey != null
      ? Encrypter(encryptionKey).decrypt(decodedBytes).codeUnits
      : decodedBytes;

  return String.fromCharCodes(decryptedBytes);
}

/// **Ignore This Method** Used by the package
@internal
T getEntryValue<T>(
  String key, {
  String? encryptionKey,
  required String encodedEntries,
  required ValuesPriority priority,
  T Function(String)? fromString,
  Map<String, CustomLoader?> customLoaders = const {},
}) {
  final bytes = base64.decode(encodedEntries);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map<String, dynamic>;
  String? decryptedValue;
  if (jsonMap.containsKey(key)) {
    final encryptedValue = jsonMap[key] as String?;
    try {
      decryptedValue = decodeValue(encryptedValue, encryptionKey);
    } catch (e) {
      throw ArgumentError.value(
        encryptionKey,
        "encryptionKey",
        "Invalid encryption key, $e",
      );
    }
  }

  final systemPairs = PlatformEnvironmentMap().getMap();
  final value = priority.getValue(
    key,
    systemPairs: systemPairs,
    storedPairs: {key: decryptedValue},
    customLoader: customLoaders[key],
  );

  return _parseValue(value, fromString: fromString);
}

/// **Ignore This Method** Used by the package
@internal
String? getFieldNameForKey(
  String envKey,
  String encodedKeysFields,
) {
  final bytes = base64.decode(encodedKeysFields);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map;
  return jsonMap[envKey];
}

/// **Ignore This Method** Used by the package
@internal
String? getKeyForFieldName(
  String fieldName,
  String encodedKeysFields,
) {
  final bytes = base64.decode(encodedKeysFields);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map;
  return jsonMap.entries
      .where((entry) => entry.value == fieldName)
      .firstOrNull
      ?.key;
}

/// **Ignore This Method** Used by the package
@internal
bool isEnvKeyExists(
  String envKey,
  String encodedKeysFields,
) {
  final bytes = base64.decode(encodedKeysFields);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map;
  return jsonMap.containsKey(envKey);
}
