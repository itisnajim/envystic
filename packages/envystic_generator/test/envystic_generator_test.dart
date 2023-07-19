import 'package:envystic_generator/envystic_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';

import 'src/env_test.dart';
import 'src/env_test2.dart';

Future<void> main() async {
  // for annotated elements
  initializeBuildLogTracking();
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'generator_tests.dart',
  );

  // print(Platform.environment['SYSTEM_VAR']);

  testAnnotatedElements(
    reader,
    EnvysticGenerator(),
  );

  test('Equality comparison', () {
    // Create instances of the generated class to be compared
    final env1 = EnvTest();
    final env2 = EnvTest();

    // Test whether both instances are equal
    expect(env1, equals(env2));

    // Create another instance with different values
    final env3 =
        EnvTest2(); // This instance should be different from env1 and env2

    // Test whether the newly created instance is not equal to env1 and env2
    expect(env3, isNot(equals(env1)));
    expect(env3, isNot(equals(env2)));
  });
}
