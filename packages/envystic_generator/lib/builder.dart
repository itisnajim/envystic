library envystic.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator.dart';

/// Primary builder to build the generated code from the `EnvysticGenerator`
Builder envysticBuilder(BuilderOptions options) => SharedPartBuilder(
      [EnvysticGenerator(options: options)],
      'envystic',
    );
