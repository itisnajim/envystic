// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env2.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String? _encryptionKey = null;
const String _encodedEntries =
    'eyJ0ZXN0U3RyaW5nIjoiZEdWemRGTjBjbWx1Wnc9PSIsInRlc3RJbnQiOiJNVEl6IiwidGVzdERvdWJsZSI6Ik1TNHlNdz09IiwidGVzdEJvb2wiOiJkSEoxWlE9PSIsInRlc3REeW5hbWljIjoiTVRJeiJ9';

class _$Env2 extends Env2 implements EnvysticInterface {
  const _$Env2() : super._();
  @override
  String get pairKeyEncodedEntries$ => _encodedEntries;

  @override
  String get testString =>
      getEntryValue('testString', _encodedEntries, _encryptionKey);

  @override
  int get testInt => getEntryValue('testInt', _encodedEntries, _encryptionKey);

  @override
  double get testDouble =>
      getEntryValue('testDouble', _encodedEntries, _encryptionKey);

  @override
  bool get testBool =>
      getEntryValue('testBool', _encodedEntries, _encryptionKey);

  @override
  dynamic get testDynamic =>
      getEntryValue('testDynamic', _encodedEntries, _encryptionKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvysticInterface &&
          pairKeyEncodedEntries$ == other.pairKeyEncodedEntries$;

  @override
  int get hashCode => pairKeyEncodedEntries$.hashCode;
}
