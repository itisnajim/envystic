import 'dart:convert';

import 'encrypter.dart';

bool _isNullable<T>() => null is T;

T _parseValue<T>(
  String? strValue, {
  T Function(String)? fromString,
}) {
  final isNullable = _isNullable<T>();

  if (strValue == null && !['dynamic', 'Object?'].contains(T.toString())) {
    if (isNullable) return null as T;
    throw Exception('Type `${T.toString()}` does not align with value `null`.');
  }

  if (['String', 'String?'].contains(T.toString())) {
    return strValue as T;
  } else if (['int', 'int?'].contains(T.toString())) {
    return (isNullable ? int.tryParse(strValue!) : int.parse(strValue!)) as T;
  } else if (['double', 'double?'].contains(T.toString())) {
    return (isNullable ? double.tryParse(strValue!) : double.parse(strValue!))
        as T;
  } else if (['num', 'num?'].contains(T.toString())) {
    return (isNullable ? num.tryParse(strValue!) : num.parse(strValue!)) as T;
  } else if (['bool', 'bool?'].contains(T.toString())) {
    return (strValue!.toLowerCase() == 'true') as T;
  } else if (T == Enum || fromString != null) {
    if (fromString == null) {
      throw Exception('fromString is required for Enum');
    }
    final parsedValue = fromString(strValue!.split('.').last);
    if (parsedValue == null) {
      throw Exception(
          'Type `${T.toString()}` does not align with value `$strValue`.');
    }
    return parsedValue;
  } else if (['dynamic', 'Object?'].contains(T.toString())) {
    return (strValue == null
        ? null
        : (int.tryParse(strValue) ??
            double.tryParse(strValue) ??
            num.tryParse(strValue) ??
            bool.tryParse(strValue) ??
            strValue)) as T;
  } else {
    throw Exception('Type `${T.toString()}` not supported');
  }
}

/// **Ignore This Method** Used by the package
String? encodeValue(String? value, String? encryptionKey) {
  if (value == null) return null;

  final encryptedBytes = encryptionKey != null
      ? Encrypter(String.fromCharCodes(base64.decode(encryptionKey)))
          .encrypt(value)
      : value.codeUnits;

  return base64.encode(encryptedBytes);
}

/// **Ignore This Method** Used by the package
String? decodeValue(String? encodedValue, String? encryptionKey) {
  if (encodedValue == null) return null;

  final decodedBytes = base64.decode(encodedValue);
  final decryptedBytes = encryptionKey != null
      ? utf8.encode(
          Encrypter(String.fromCharCodes(base64.decode(encryptionKey)))
              .decrypt(decodedBytes))
      : decodedBytes;

  return String.fromCharCodes(decryptedBytes);
}

/// **Ignore This Method** Used by the package
T getEntryValue<T>(
  String key,
  String encodedEntries,
  String? encryptionKey, {
  T Function(String)? fromString,
}) {
  final bytes = base64.decode(encodedEntries);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map<String, dynamic>;
  if (!jsonMap.containsKey(key)) {
    throw Exception('Key $key not found in .env file');
  }
  final encryptedValue = jsonMap[key] as String?;
  final decryptedValue = decodeValue(encryptedValue, encryptionKey);
  return _parseValue(decryptedValue);
}

/// **Ignore This Method** Used by the package
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
bool isEnvKeyExists(
  String envKey,
  String encodedKeysFields,
) {
  final bytes = base64.decode(encodedKeysFields);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map;
  return jsonMap.containsKey(envKey);
}
