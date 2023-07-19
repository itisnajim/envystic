import 'package:envystic/envystic.dart';

part 'env_test.g.dart';

@Envystic(path: 'test/.env.example')
abstract class EnvTest {
  const factory EnvTest() = _$EnvTest;

  const EnvTest._();

  @EnvysticField()
  String? get testString;
  @EnvysticField()
  int? get testInt;
  @EnvysticField()
  double? get testDouble;
  @EnvysticField()
  bool? get testBool;
  @EnvysticField()
  get testDynamic;
}
