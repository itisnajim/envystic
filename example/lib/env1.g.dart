// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env1.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String _encryptionKey = 'RW5jcnlwdE1vcmVQbGVhc2U=';
const String _encodedEntries =
    'eyJrZXkxIjoiMXovRDNMUXpNdisvVnhBNlQ1TVhVUT09Iiwia2V5MiI6IkNzRHdUR24xSnJBa25mNnhZUk5ma2c9PSIsInNwZWNpYWxLZXkiOiJDc0R3VEduMUpyQWtuZjZ4WVJOZmtnPT0ifQ==';
const String _encodedKeysFields =
    'eyJLRVkxIjoia2V5MSIsIkZPTyI6ImtleTIiLCJNWV9TUEVDSUFMX0tFWSI6InNwZWNpYWxLZXkifQ==';

mixin _$Env1 implements EnvysticInterface {
  @override
  String get pairKeyEncodedEntries$ => _encryptionKey + _encodedEntries;

  String get key1 => getForField('key1');

  int? get key2 => getForField('key2');

  int get specialKey => getForField('specialKey');

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
