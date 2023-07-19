// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_test2.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String? _encryptionKey = null;
const String _encodedEntries =
    'eyJ0ZXN0U3RyaW5nIjpudWxsLCJ0ZXN0SW50IjpudWxsfQ==';

class _$EnvTest2 extends EnvTest2 implements EnvysticInterface {
  const _$EnvTest2() : super._();
  @override
  String get pairKeyEncodedEntries$ => _encodedEntries;

  @override
  String? get testString =>
      getEntryValue('testString', _encodedEntries, _encryptionKey);

  @override
  int? get testInt => getEntryValue('testInt', _encodedEntries, _encryptionKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvysticInterface &&
          pairKeyEncodedEntries$ == other.pairKeyEncodedEntries$;

  @override
  int get hashCode => pairKeyEncodedEntries$.hashCode;
}
