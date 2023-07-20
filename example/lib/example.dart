import 'package:example/env1.dart';

import 'env_all.dart';

void main() {
  final env1 = Env1();
  print('env1.key1 ${env1.key1}');
  print('env1.key2 ${env1.key2}');
  print('env1.isKeyExists("FOO") ${env1.isKeyExists('FOO')}');
  print('env1.tryGet("FOO") ${env1.tryGet('FOO')}');
  print('env1.isKeyExists("BAR") ${env1.isKeyExists('BAR')}');
  print('env1.tryGet("BAR") ${env1.tryGet('BAR')}');
  print('env1.specialKey ${env1.specialKey}');
  print('env1.drink ${env1.drink}');

  print('\n');

  final envAll = EnvAll();
  print(
      'envAll.specialKey ${envAll.specialKey}, type: ${envAll.specialKey.runtimeType}');
  print('envAll.key1 ${envAll.key1}, type: ${envAll.key1.runtimeType}');
  print('envAll.foo ${envAll.foo}, type: ${envAll.foo.runtimeType}');
  print(
      'envAll.testString ${envAll.testString}, type: ${envAll.testString.runtimeType}');
  print(
      'envAll.testString2 ${envAll.testString2}, type: ${envAll.testString2.runtimeType}');
  print(
      'envAll.testInt ${envAll.testInt}, type: ${envAll.testInt.runtimeType}');
  print(
      'envAll.testDouble ${envAll.testDouble}, type: ${envAll.testDouble.runtimeType}');
  print(
      'envAll.testBool ${envAll.testBool}, type: ${envAll.testBool.runtimeType}');
  print(
      'envAll.testDynamic ${envAll.testDynamic}, type: ${envAll.testDynamic.runtimeType}');
  print('envAll.drink ${envAll.drink}');
}
