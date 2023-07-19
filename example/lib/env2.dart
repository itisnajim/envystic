import 'package:envystic/envystic.dart';

part 'env2.g.dart';

@Envystic(path: '.env.example', keyFormat: KeyFormat.none)
abstract class Env2 {
  const factory Env2() = _$Env2;

  const Env2._();

  @EnvysticField()
  String get testString;
  @EnvysticField()
  int get testInt;
  @EnvysticField()
  double get testDouble;
  @EnvysticField()
  bool get testBool;
  @EnvysticField()
  get testDynamic;
}
