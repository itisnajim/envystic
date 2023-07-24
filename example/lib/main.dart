import 'endec.dart';
import 'env1.dart';
import 'env_all.dart';

void main(List<String> arguments) {
  final start = DateTime.now();

  // Always add the key files to .gitignore
  // In this example, we should add `example/env_encryption_output.key` and `example/example.key` to .gitignore.
  // Then, inject the keys using the commands below:

  /*
export ENCRYPTION_ENV1_KEY=$(dart run lib/endec.dart 'S0djUmw4VzVuSU00Nk5DNA==') &&
export ENCRYPTION_ENV_ALL_KEY=$(dart run lib/endec.dart 'SWtUem9IdGJiWGZNejVsdQ==') &&
dart --define=ENCRYPTION_ENV1_KEY=$ENCRYPTION_ENV1_KEY --define=ENCRYPTION_ENV_ALL_KEY=$ENCRYPTION_ENV_ALL_KEY lib/main.dart
   */

  // If you want to run on a specific platform, use the following commands:

  /*
export ENCRYPTION_ENV1_KEY=$(dart run lib/endec.dart 'S0djUmw4VzVuSU00Nk5DNA==') &&
export ENCRYPTION_ENV_ALL_KEY=$(dart run lib/endec.dart 'SWtUem9IdGJiWGZNejVsdQ==') &&
flutter run --dart-define ENCRYPTION_ENV1_KEY=$ENCRYPTION_ENV1_KEY --dart-define ENCRYPTION_ENV_ALL_KEY=$ENCRYPTION_ENV_ALL_KEY
   */

  // Get and decode the ENCRYPTION_ENV1_KEY
  const env1Key = String.fromEnvironment('ENCRYPTION_ENV1_KEY');
  print('env1Key: $env1Key');

  final key1 = endec(env1Key);
  print('key1: $key1');
  final env1 = Env1(encryptionKey: key1);
  print('env1.key1 ${env1.key1}');
  print('env1.key2 ${env1.key2}');
  print('env1.isKeyExists("FOO") ${env1.isKeyExists('FOO')}');
  print('env1.tryGet("FOO") ${env1.tryGet('FOO')}');
  print('env1.isKeyExists("BAR") ${env1.isKeyExists('BAR')}');
  print('env1.tryGet("BAR") ${env1.tryGet('BAR')}');
  print('env1.specialKey ${env1.specialKey}');
  print('env1.test ${env1.test}');
  print('env1.test2 ${env1.test2}');
  print('env1.drink ${env1.drink}');

  print('\n');

  // Get and decode the ENCRYPTION_ENV_ALL_KEY
  const envAllKey = String.fromEnvironment('ENCRYPTION_ENV_ALL_KEY');
  print('envAllKey: $envAllKey');
  final allKey = endec(envAllKey);
  print('allKey: $allKey');
  final envAll = EnvAll(encryptionKey: allKey);
  print('envAll.specialKey ${envAll.specialKey}');
  print('envAll.key1 ${envAll.key1}');
  print('envAll.foo ${envAll.foo}');
  print('envAll.testString ${envAll.testString}');
  print('envAll.testString2 ${envAll.testString2}');
  print('envAll.testInt ${envAll.testInt}');
  print('envAll.testDouble ${envAll.testDouble}');
  print('envAll.testBool ${envAll.testBool}');
  print('envAll.testDynamic ${envAll.testDynamic}');
  print('envAll.drink ${envAll.drink}');

  final end = DateTime.now();

  // Calculate and print the total execution time
  print('\ntotal time: ${end.difference(start).inMilliseconds} ms');
}
