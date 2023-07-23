import 'package:example/env1.dart';

import 'env_all.dart';

void main() {
  final start = DateTime.now();

  const env1 = Env1(encryptionKey: "Ymo3ZnlPMXJOeUZuRUtQcA==");
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

  const envAll = EnvAll(encryptionKey: "Ymo3ZnlPMXJOeUZuRUtQcA==");
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

  print('\ntotal time: ${end.difference(start).inMilliseconds} ms');
}
