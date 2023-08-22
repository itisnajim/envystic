import 'package:envystic/envystic.dart';

import 'test_enum.dart' as e;

part 'env1.g.dart';

enum TestEnum2 {
  foo,
  bar,
  baz,
  qux,
}

int? specialKeyLoader42() => 42;

@Envystic(path: '.env.example')
class Env1 extends _$Env1 {
  const Env1._();

  // you can omit `encryptionKey` if no encryption is needed!
  factory Env1({
    String? encryptionKey,
    ValuesPriority? valuesPriority,
  }) = _Env1;

  factory Env1.define({
    required String key0,
    required String key1,
    // The value from 'FOO' in .env will be used
    @EnvysticField(name: 'FOO') int? key2,
    @EnvysticField(name: 'MY_SPECIAL_KEY', customLoader: specialKeyLoader42)
    int? specialKey,
    required e.TestEnum test,
    TestEnum2? test2,
    dynamic notExists,
  }) = _Env1Define;

  // ignored
  String get drink => 'Coffee';
}
