// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env1.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by envystic and you are not supposed to need it nor use it.');

const String _encodedEntries =
    'eyJrZXkwIjpudWxsLCJrZXkxIjoiVmNoZWtBelM5VjNTMlkvTEtPcFVDUT09Iiwia2V5MiI6IjZsYkJlYlNqSVZuTHZScmphcXNNZlE9PSIsInNwZWNpYWxLZXkiOiI2bGJCZWJTaklWbkx2UnJqYXFzTWZRPT0iLCJ0ZXN0IjoiMUwvTjNDQ1hEVmZ2OS9sejU4b0VxZz09IiwidGVzdDIiOm51bGwsIm5vdEV4aXN0cyI6bnVsbH0=';
const String _encodedKeysFields =
    'eyJLRVkwIjoia2V5MCIsIktFWTEiOiJrZXkxIiwiRk9PIjoia2V5MiIsIk1ZX1NQRUNJQUxfS0VZIjoic3BlY2lhbEtleSIsIlRFU1QiOiJ0ZXN0IiwiVEVTVDIiOiJ0ZXN0MiIsIk5PVF9FWElTVFMiOiJub3RFeGlzdHMifQ==';

abstract class _$Env1 with IEnvystic {
  const _$Env1();

  @override
  String get encodedEntries$ => _encodedEntries;
  @override
  String get encodedKeysFields$ => _encodedKeysFields;
  @override
  ValuesPriority get valuesPriority$ => ValuesPriority();

  String get key0 => throw _privateConstructorUsedError;
  String get key1 => throw _privateConstructorUsedError;
  int? get key2 => throw _privateConstructorUsedError;
  int? get specialKey => throw _privateConstructorUsedError;
  e.TestEnum get test => throw _privateConstructorUsedError;
  TestEnum2? get test2 => throw _privateConstructorUsedError;
  dynamic get notExists => throw _privateConstructorUsedError;

  Env1 copyWith({required ValuesPriority valuesPriority}) =>
      throw _privateConstructorUsedError;
}

class _Env1 extends Env1 {
  @override
  final String? encryptionKey$;
  @override
  final ValuesPriority valuesPriority$;
  const _Env1({
    String? encryptionKey,
    ValuesPriority? valuesPriority,
  })  : encryptionKey$ = encryptionKey,
        valuesPriority$ = valuesPriority ?? const ValuesPriority(),
        super._();

  @override
  String get key0 => getForField('key0');
  @override
  String get key1 => getForField('key1');
  @override
  int? get key2 => getForField('key2');
  @override
  int? get specialKey => getForField('specialKey');
  @override
  e.TestEnum get test =>
      getForField('test', fromString: e.TestEnum.values.byName);
  @override
  TestEnum2? get test2 =>
      getForField('test2', fromString: TestEnum2.values.byName);
  @override
  dynamic get notExists => getForField('notExists');

  @override
  Map<String, CustomLoader?> get customLoaders$ =>
      {'specialKey': specialKeyLoader42};

  @override
  Env1 copyWith({required ValuesPriority valuesPriority}) => _Env1(
        encryptionKey: encryptionKey$,
        valuesPriority: valuesPriority,
      );
}

class _Env1Define extends Env1 {
  const _Env1Define({
    required this.key0,
    required this.key1,
    this.key2,
    this.specialKey,
    required this.test,
    this.test2,
    this.notExists,
  }) : super._();

  @override
  final String key0;
  @override
  final String key1;
  @override
  final int? key2;
  @override
  final int? specialKey;
  @override
  final e.TestEnum test;
  @override
  final TestEnum2? test2;
  @override
  final dynamic notExists;
}
