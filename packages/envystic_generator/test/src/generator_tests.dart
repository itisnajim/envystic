import 'package:envystic/envystic.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('`@Envystic` can only be used on classes.')
@Envystic()
const foo = 'bar';

@ShouldThrow(
  "@Envystic annotation requires a const Env0._() or private constructor",
)
@Envystic()
abstract class Env0 {}

@ShouldThrow("Environment variable file doesn't exist at `.env`.")
@Envystic()
abstract class Env1 {
  const Env1._();
}

@ShouldThrow('Environment variable not found for field `foo`.')
@Envystic(path: 'test/.env.example')
abstract class Env2 {
  const Env2._();

  @EnvysticField()
  String get foo;
}

@ShouldThrow(
  'Type `Symbol?` not supported',
)
@Envystic(path: 'test/.env.example')
abstract class Env3 {
  const Env3._();

  @EnvysticField()
  Symbol? get testString;
}

@ShouldThrow('Type `int` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env4 {
  const Env4._();

  @EnvysticField()
  int get testString;
}

@ShouldThrow('Type `double` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env5 {
  const Env5._();

  @EnvysticField()
  double get testString;
}

@ShouldThrow('Type `num` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env6 {
  const Env6._();

  @EnvysticField()
  num get testString;
}

@ShouldThrow('Type `bool` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env7 {
  const Env7._();

  @EnvysticField()
  bool get testString;
}

@ShouldGenerate('''
class _\$Env8 extends Env8 {
  const _\$Env8() : super._();

  static const String? _encryptionKey = null;
  static const String _encodedEntries =
      'eyJ0ZXN0U3RyaW5nIjoiZEdWemRGTjBjbWx1Wnc9PSIsInRlc3RJbnQiOiJNVEl6IiwidGVzdERvdWJsZSI6Ik1TNHlNdz09IiwidGVzdEJvb2wiOiJkSEoxWlE9PSIsInRlc3REeW5hbWljIjoiTVRJellXSmoifQ==';
  @override
  String? get testString =>
      getEntryValue('testString', _encodedEntries, _encryptionKey);

  @override
  int? get testInt => getEntryValue('testInt', _encodedEntries, _encryptionKey);

  @override
  double? get testDouble =>
      getEntryValue('testDouble', _encodedEntries, _encryptionKey);

  @override
  bool? get testBool =>
      getEntryValue('testBool', _encodedEntries, _encryptionKey);

  @override
  dynamic get testDynamic =>
      getEntryValue('testDynamic', _encodedEntries, _encryptionKey);
}
''')
@Envystic(path: 'test/.env.example')
abstract class Env8 {
  const Env8._();

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
