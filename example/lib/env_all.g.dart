// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_all.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String _encryptionKey = 'RW5jcnlwdE1vcmVQbGVhc2U=';
const String _encodedEntries =
    'eyJzcGVjaWFsS2V5IjoiQ3NEd1RHbjFKckFrbmY2eFlSTmZrZz09Iiwia2V5MSI6IjF6L0QzTFF6TXYrL1Z4QTZUNU1YVVE9PSIsImZvbyI6IkNzRHdUR24xSnJBa25mNnhZUk5ma2c9PSIsInRlc3RTdHJpbmciOiJsSDI1ODhSMVhQSTY2eDR3Wm42djRRPT0iLCJ0ZXN0U3RyaW5nMiI6ImdMSE1qUmJNeU9Sc3dTNFdMMmE4dkE9PSIsInRlc3RJbnQiOiJDc0R3VEduMUpyQWtuZjZ4WVJOZmtnPT0iLCJ0ZXN0RG91YmxlIjoicUhvRHBlL3RVcllpeVBSc3J1Qml3QT09IiwidGVzdEJvb2wiOiJlejJKU0xRbDNESCtXNC9QU3d1bThBPT0iLCJ0ZXN0RHluYW1pYyI6ImI2d081MXhMZHNzZUUxWEJlWlIrV3c9PSJ9';
const String _encodedKeysFields =
    'eyJNWV9TUEVDSUFMX0tFWSI6InNwZWNpYWxLZXkiLCJLRVkxIjoia2V5MSIsIkZPTyI6ImZvbyIsInRlc3Rfc3RyaW5nIjoidGVzdFN0cmluZyIsInRlc3RTdHJpbmciOiJ0ZXN0U3RyaW5nMiIsInRlc3RJbnQiOiJ0ZXN0SW50IiwidGVzdERvdWJsZSI6InRlc3REb3VibGUiLCJ0ZXN0Qm9vbCI6InRlc3RCb29sIiwidGVzdER5bmFtaWMiOiJ0ZXN0RHluYW1pYyJ9';

mixin _$EnvAll implements EnvysticInterface {
  @override
  String get pairKeyEncodedEntries$ => _encryptionKey + _encodedEntries;

  int? get specialKey => getForField('specialKey');

  String get key1 => getForField('key1');

  int get foo => getForField('foo');

  String get testString => getForField('testString');

  String get testString2 => getForField('testString2');

  int get testInt => getForField('testInt');

  double get testDouble => getForField('testDouble');

  bool get testBool => getForField('testBool');

  String get testDynamic => getForField('testDynamic');

  @override
  T getForField<T>(String fieldName) =>
      getEntryValue(fieldName, _encodedEntries, _encryptionKey);

  @override
  bool isKeyExists(String envKey) => isEnvKeyExists(envKey, _encodedKeysFields);

  @override
  String? getFieldName(String envKey) =>
      getFieldNameForKey(envKey, _encodedKeysFields);

  @override
  T get<T>(String envKey) => getForField(getFieldName(envKey)!);

  @override
  T? tryGet<T>(String envKey) {
    try {
      return !isKeyExists(envKey) ? null : getForField(getFieldName(envKey)!);
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvysticInterface &&
          pairKeyEncodedEntries$ == other.pairKeyEncodedEntries$;

  @override
  int get hashCode => pairKeyEncodedEntries$.hashCode;
}
