import 'env.dart';
import 'env2.dart';

void main() {
  const env = Env();
  print('env.key1 ${env.key1}');
  print('env.key2 ${env.key2}');
  print('env.specialKey ${env.specialKey}');
  print('env.drink ${env.drink}');

  const env2 = Env2();
  print(
      'env2.testString ${env2.testString}, type: ${env2.testString.runtimeType}');
  print('env2.testInt ${env2.testInt}, type: ${env2.testInt.runtimeType}');
  print(
      'env2.testDouble ${env2.testDouble}, type: ${env2.testDouble.runtimeType}');
  print('env2.testBool ${env2.testBool}, type: ${env2.testBool.runtimeType}');
  print(
      'env2.testDynamic ${env2.testDynamic}, type: ${env2.testDynamic.runtimeType}');
}
