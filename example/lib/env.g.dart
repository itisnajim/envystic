// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String _encryptionKey = 'RW5jcnlwdE1vcmVQbGVhc2U=';
const String _encodedEntries =
    'eyJrZXkxIjoiMXovRDNMUXpNdisvVnhBNlQ1TVhVUT09Iiwia2V5MiI6IkNzRHdUR24xSnJBa25mNnhZUk5ma2c9PSIsInNwZWNpYWxLZXkiOiJDc0R3VEduMUpyQWtuZjZ4WVJOZmtnPT0ifQ==';

class _$Env extends Env implements EnvysticInterface {
  const _$Env() : super._();
  @override
  String get pairKeyEncodedEntries$ => _encryptionKey + _encodedEntries;

  @override
  String get key1 => getEntryValue('key1', _encodedEntries, _encryptionKey);

  @override
  int? get key2 => getEntryValue('key2', _encodedEntries, _encryptionKey);

  @override
  int? get specialKey =>
      getEntryValue('specialKey', _encodedEntries, _encryptionKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvysticInterface &&
          pairKeyEncodedEntries$ == other.pairKeyEncodedEntries$;

  @override
  int get hashCode => pairKeyEncodedEntries$.hashCode;
}
