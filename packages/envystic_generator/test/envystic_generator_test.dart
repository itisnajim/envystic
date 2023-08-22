import 'package:envystic_generator/envystic_generator.dart';
import 'package:source_gen_test/source_gen_test.dart';

Future<void> main() async {
  // for annotated elements
  initializeBuildLogTracking();
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'generator_tests.dart',
  );

  testAnnotatedElements(
    reader,
    EnvysticGenerator(),
  );
}
