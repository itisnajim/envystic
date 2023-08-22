import 'package:envystic/envystic.dart';

part 'env_dev.g.dart';

enum TestEnum2 {
  foo,
  bar,
  baz,
  qux,
}

int? specialKeyLoader42() => 42;

@Envystic(path: '.env.dev')
class EnvDev extends _$EnvDev {
  const EnvDev._();

  // you can omit `encryptionKey` if no encryption is needed!
  factory EnvDev({
    String? encryptionKey,
    ValuesPriority? valuesPriority,
  }) = _EnvDev;

  factory EnvDev.define({
    required String baseUrl,
    @EnvysticField(defaultValue: "exAMPlE.0imfnc8mVLWwsAawjYr4Rx-Af50DDqtlx")
    required String apiKey,
  }) = _EnvDevDefine;
}
