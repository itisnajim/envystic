import 'package:envystic/envystic.dart';

part 'env.g.dart';

@Envystic(path: '.env.example', encryptionKey: 'EncryptMorePlease')
abstract class Env {
  const factory Env() = _$Env;

  const Env._();

  @envysticField // Default key name assigned: 'KEY1'
  String get key1;

  @EnvysticField(name: 'FOO') // The value from 'FOO' in .env will be used
  int? get key2;

  @EnvysticField(
      name: 'MY_SPECIAL_KEY') // Test from System environment variables
  int? get specialKey;

  // ignored
  String get drink => 'Coffee';
}
