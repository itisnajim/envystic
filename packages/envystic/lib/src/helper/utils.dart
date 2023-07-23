import 'dart:convert';

import 'encrypter.dart';

bool _isNullable<T>() => null is T;

T _parseValue<T>(
  String? strValue, {
  Enum Function(String)? fromString,
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
  } else if (fromString != null) {
    // is Enum type
    try {
      final parsedValue = fromString(strValue!.split('.').last);
      return parsedValue as T;
    } catch (e) {
      throw Exception(
          'Type `${T.toString()}` does not align with value `$strValue`.');
    }
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
      ? Encrypter(encryptionKey).encrypt(value)
      : value.codeUnits;

  return base64.encode(encryptedBytes);
}

/// **Ignore This Method** Used by the package
String? decodeValue(String? encodedValue, String? encryptionKey) {
  if (encodedValue == null) return null;

  final decodedBytes = base64.decode(encodedValue);
  final decryptedBytes = encryptionKey != null
      ? Encrypter(encryptionKey).decrypt(decodedBytes).codeUnits
      : decodedBytes;

  return String.fromCharCodes(decryptedBytes);
}

/// **Ignore This Method** Used by the package
T getEntryValue<T>(
  String key,
  String encodedEntries,
  String? encryptionKey, {
  Enum Function(String)? fromString,
}) {
  final bytes = base64.decode(encodedEntries);
  final stringDecoded = String.fromCharCodes(bytes);
  final jsonMap = json.decode(stringDecoded) as Map<String, dynamic>;
  if (!jsonMap.containsKey(key)) {
    throw Exception('Key $key not found in .env file');
  }
  final encryptedValue = jsonMap[key] as String?;
  String? decryptedValue;
  try {
    decryptedValue = decodeValue(encryptedValue, encryptionKey);
  } catch (e) {
    throw ArgumentError.value(
      encryptionKey,
      "encryptionKey",
      "Invalid encryption key, $e",
    );
  }
  return _parseValue(decryptedValue, fromString: fromString);
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
