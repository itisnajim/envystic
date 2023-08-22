import 'package:envystic/envystic.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('`@Envystic` can only be used on classes.')
@Envystic()
const foo = 'bar';

@ShouldThrow(
  'Type `Symbol?` not supported',
)
@Envystic(path: 'test/.env.example')
abstract class Env1 {
  const Env1._();
  factory Env1.define({
    Symbol? testString,
  }) = _Env1Define;
}

class _Env1Define extends Env1 {
  final Symbol? testString;
  const _Env1Define({this.testString}) : super._();
}

@ShouldThrow('Type `int` does not align with value `testString`.')
@Envystic(path: 'test/.env.example')
abstract class Env2 {
  const Env2._();
  factory Env2.define({
    required int testString,
  }) = _Env2Define;
}

class _Env2Define extends Env2 {
  final int testString;
  const _Env2Define({required this.testString}) : super._();
}

@ShouldGenerate(
  '',
  contains: true,
  expectedLogItems: [],
)
@envystic
abstract class AstractClass {
  const factory AstractClass() = _AstractClass;
}

class _AstractClass implements AstractClass {
  const _AstractClass();
}
