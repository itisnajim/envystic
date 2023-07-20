import 'package:envystic/envystic.dart';

part 'env1.g.dart';

@Envystic(path: '.env.example', encryptionKey: 'EncryptMorePlease')
class Env1 with _$Env1 {
  const Env1();

  @override
  @envysticField // Default env key name assigned: 'KEY1'
  String get key1;

  @override
  @EnvysticField(name: 'FOO') // The value from 'FOO' in .env will be used
  int? get key2;

  @override
  @EnvysticField(
      name: 'MY_SPECIAL_KEY') // Pulled from system environment variables
  int get specialKey;

  // ignored
  String get drink => 'Coffee';
}
