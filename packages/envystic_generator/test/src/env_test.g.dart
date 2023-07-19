// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_test.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String? _encryptionKey = null;
const String _encodedEntries =
    'eyJ0ZXN0U3RyaW5nIjpudWxsLCJ0ZXN0SW50IjpudWxsLCJ0ZXN0RG91YmxlIjpudWxsLCJ0ZXN0Qm9vbCI6bnVsbCwidGVzdER5bmFtaWMiOm51bGx9';

class _$EnvTest extends EnvTest implements EnvysticInterface {
  const _$EnvTest() : super._();
  @override
  String get pairKeyEncodedEntries$ => _encodedEntries;

  @override
  String? get testString =>
      getEntryValue('testString', _encodedEntries, _encryptionKey);

  @override
  int? get testInt => getEntryValue('testInt', _encodedEntries, _encryptionKey);

  @override
  double? get testDouble =>
      getEntryValue('testDouble', _encodedEntries, _encryptionKey);

  @override
  bool? get testBool =>
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
