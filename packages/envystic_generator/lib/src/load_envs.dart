import 'dart:io' show File;

import 'parser.dart';

enum LoadEnvsError {
  notExists,
  unknown;
}

/// Load the environment variables from the supplied [path],
/// using the `dotenv` parser.
///
/// If file doesn't exist, an error will be thrown through the
/// [onError] function.
Future<Map<String, String>> loadEnvs(
  String path,
) async {
  const parser = Parser();

  final file = File.fromUri(Uri.file(path));

  var lines = <String>[];
  if (await file.exists()) {
    lines = await file.readAsLines();
  } else {
    print("Environment variable file doesn't exist at `$path`.");
    return {};
  }

  final envs = parser.parse(lines);

  return envs;
}
