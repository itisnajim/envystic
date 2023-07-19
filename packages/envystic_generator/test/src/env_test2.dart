import 'package:envystic/envystic.dart';

part 'env_test2.g.dart';

@Envystic(path: '.env.example')
abstract class EnvTest2 {
  const factory EnvTest2() = _$EnvTest2;

  const EnvTest2._();

  @EnvysticField()
  String? get testString;
  @EnvysticField()
  int? get testInt;
}
