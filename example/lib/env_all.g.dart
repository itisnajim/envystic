// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_all.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by envystic and you are not supposed to need it nor use it.');

const String _encodedEntries =
    'eyJzcGVjaWFsS2V5IjoidlJSb0Q0dUdySVBtVVZCSHZhVWFxZz09Iiwia2V5MSI6ImE1YUMrbDJkNGJ1Qnk5SzEvOXhwMVE9PSIsImZvbyI6InZSUm9ENHVHcklQbVVWQkh2YVVhcWc9PSIsInRlc3QiOiJPdG9mQytuOHpOMkw5dkMyTDdOUkJRPT0iLCJ0ZXN0U3RyaW5nIjoicGFTYXVZSFppNWlrMVNqc3hPdE1LZz09IiwidGVzdFN0cmluZzIiOiI3dDZPdDZZcnJZR3dPZE4vY1pZZGNBPT0iLCJ0ZXN0SW50IjoidlJSb0Q0dUdySVBtVVZCSHZhVWFxZz09IiwidGVzdERvdWJsZSI6Ik8vNURlaUhHZG1TWjdHNHNZOFRTQWc9PSIsInRlc3RCb29sIjoiRHpTeFA4YjJDajV1ZzB5NnNFdlA5QT09IiwidGVzdER5bmFtaWMiOiJtTmJWZTNXK01PSXREUzhFMVhGNURnPT0ifQ==';
const String _encodedKeysFields =
    'eyJNWV9TUEVDSUFMX0tFWSI6InNwZWNpYWxLZXkiLCJLRVkxIjoia2V5MSIsIkZPTyI6ImZvbyIsIlRFU1QiOiJ0ZXN0IiwidGVzdF9zdHJpbmciOiJ0ZXN0U3RyaW5nIiwidGVzdFN0cmluZyI6InRlc3RTdHJpbmcyIiwidGVzdEludCI6InRlc3RJbnQiLCJ0ZXN0RG91YmxlIjoidGVzdERvdWJsZSIsInRlc3RCb29sIjoidGVzdEJvb2wiLCJ0ZXN0RHluYW1pYyI6InRlc3REeW5hbWljIn0=';

abstract class _$EnvAll with IEnvystic {
  const _$EnvAll();

  @override
  String get encodedEntries$ => _encodedEntries;
  @override
  String get encodedKeysFields$ => _encodedKeysFields;
  @override
  ValuesPriority get valuesPriority$ => ValuesPriority();

  int? get specialKey => throw _privateConstructorUsedError;
  String get key1 => throw _privateConstructorUsedError;
  int get foo => throw _privateConstructorUsedError;
  String get test => throw _privateConstructorUsedError;
  String get testString => throw _privateConstructorUsedError;
  String get testString2 => throw _privateConstructorUsedError;
  int get testInt => throw _privateConstructorUsedError;
  double get testDouble => throw _privateConstructorUsedError;
  bool get testBool => throw _privateConstructorUsedError;
  String get testDynamic => throw _privateConstructorUsedError;

  EnvAll copyWith({required ValuesPriority valuesPriority}) =>
      throw _privateConstructorUsedError;
}

class _EnvAll extends EnvAll {
  @override
  final String? encryptionKey$;
  @override
  final ValuesPriority valuesPriority$;
  const _EnvAll({
    String? encryptionKey,
    ValuesPriority? valuesPriority,
  })  : encryptionKey$ = encryptionKey,
        valuesPriority$ = valuesPriority ?? const ValuesPriority(),
        super._();

  @override
  int? get specialKey => getForField('specialKey');
  @override
  String get key1 => getForField('key1');
  @override
  int get foo => getForField('foo');
  @override
  String get test => getForField('test');
  @override
  String get testString => getForField('testString');
  @override
  String get testString2 => getForField('testString2');
  @override
  int get testInt => getForField('testInt');
  @override
  double get testDouble => getForField('testDouble');
  @override
  bool get testBool => getForField('testBool');
  @override
  String get testDynamic => getForField('testDynamic');

  @override
  Map<String, CustomLoader?> get customLoaders$ =>
      {'specialKey': specialKeyLoader};

  @override
  EnvAll copyWith({required ValuesPriority valuesPriority}) => _EnvAll(
        encryptionKey: encryptionKey$,
        valuesPriority: valuesPriority,
      );
}

class _EnvAllDefine extends EnvAll {
  const _EnvAllDefine({
    this.specialKey,
  }) : super._();

  @override
  final int? specialKey;
}
