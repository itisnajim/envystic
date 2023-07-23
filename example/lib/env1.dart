import 'package:envystic/envystic.dart';

import 'test_enum.dart' as e;

part 'env1.g.dart';

enum TestEnum2 {
  foo,
  bar,
  baz,
  qux,
}

@Envystic(path: '.env.example')
class Env1 extends _$Env1 {
  const Env1({super.encryptionKey});

  @override
  @envysticField // Default env key name assigned: 'KEY1'
  String get key1;

  @override
  @EnvysticField(name: 'FOO') // The value from 'FOO' in .env will be used
  int? get key2;

  @override
  @EnvysticField(
      name: 'MY_SPECIAL_KEY') // Pulled from system environment variables
  int? get specialKey;

  @override
  @EnvysticField()
  e.TestEnum get test;

  @override
  @EnvysticField()
  TestEnum2? get test2;

  @override
  @envysticField
  get notExists;

  // ignored
  String get drink => 'Coffee';
}
