import 'package:envystic/envystic.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('`@Envystic` can only be used on classes.')
@Envystic()
const foo = 'bar';

@ShouldThrow("Environment variable file doesn't exist at `.env`.")
@Envystic()
abstract class Env1 {}

@ShouldThrow('Environment variable not found for field `foo`.')
@Envystic(path: 'test/.env.example')
abstract class Env2 {
  @envysticField
  int get foo;
}

@ShouldThrow(
  'Type `Symbol?` not supported',
)
@Envystic(path: 'test/.env.example')
abstract class Env3 {
  @envysticField
  Symbol? get testString;
}

@ShouldThrow('Type `int` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env4 {
  @envysticField
  int get testString;
}

@ShouldThrow('Type `double` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env5 {
  @envysticField
  double get testString;
}

@ShouldThrow('Type `num` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env6 {
  @envysticField
  num get testString;
}

@ShouldThrow('Type `bool` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env7 {
  @envysticField
  bool get testString;
}

@ShouldGenerate('''
const String? _encryptionKey = null;
const String _encodedEntries =
    'eyJ0ZXN0U3RyaW5nIjoiZEdWemRGTjBjbWx1Wnc9PSIsInRlc3RJbnQiOiJNVEl6IiwidGVzdERvdWJsZSI6Ik1TNHlNdz09IiwidGVzdEJvb2wiOiJkSEoxWlE9PSIsInRlc3REeW5hbWljIjoiTVRJellXSmoifQ==';
const String _encodedKeysFields =
    'eyJ0ZXN0U3RyaW5nIjoidGVzdFN0cmluZyIsInRlc3RJbnQiOiJ0ZXN0SW50IiwidGVzdERvdWJsZSI6InRlc3REb3VibGUiLCJ0ZXN0Qm9vbCI6InRlc3RCb29sIiwidGVzdER5bmFtaWMiOiJ0ZXN0RHluYW1pYyJ9';

mixin _\$Env8 implements EnvysticInterface {
  @override
  String get pairKeyEncodedEntries\$ => _encodedEntries;

  String? get testString => getForField('testString');

  int? get testInt => getForField('testInt');

  double? get testDouble => getForField('testDouble');

  bool? get testBool => getForField('testBool');

  dynamic get testDynamic => getForField('testDynamic');

  @override
  T getForField<T>(String fieldName) =>
      getEntryValue(fieldName, _encodedEntries, _encryptionKey);

  @override
  bool isKeyExists(String envKey) => isEnvKeyExists(envKey, _encodedKeysFields);

  @override
  String? getFieldName(String envKey) =>
      getFieldNameForKey(envKey, _encodedKeysFields);

  @override
  T get<T>(String envKey) => getForField(getFieldName(envKey)!);

  @override
  T? tryGet<T>(String envKey) {
    try {
      return !isKeyExists(envKey) ? null : getForField(getFieldName(envKey)!);
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvysticInterface &&
          pairKeyEncodedEntries\$ == other.pairKeyEncodedEntries\$;

  @override
  int get hashCode => pairKeyEncodedEntries\$.hashCode;
}
''')
@Envystic(path: 'test/.env.example')
abstract class Env8 {
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
