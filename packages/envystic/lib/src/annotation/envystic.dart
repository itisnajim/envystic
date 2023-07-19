import 'key_format.dart';

/// Annotation used to specify the class that contains environment variables
/// generated from an environment file (e.g., `.env` file).
const envystic = Envystic();

/// Annotation used to specify the class that contains environment variables
/// generated from an environment file (e.g., `.env` file).
class Envystic {
  /// The path to the environment variables file.
  final String path;

  /// The encryption key used to encrypt the variable values.
  /// If [encryptionKey] is `null`, a `base64` encoding is applied to the values for a simple level of protection.
  final String? encryptionKey;

  /// The format of key names in the environment file (e.g., `.env` file).
  /// Defaults to [KeyFormat.none].
  final KeyFormat? keyFormat;

  /// Creates an instance of [Envystic].
  ///
  /// [path] specifies the path to the environment variables file.
  /// If not provided, the default is '.env'.
  /// [encryptionKey] specifies the encryption key used to encrypt the values.
  /// If `null`, a `base64` encoding is applied to the values for a simple level of protection.
  const Envystic({
    String? path,
    this.encryptionKey,
    this.keyFormat,
  }) : path = path ?? '.env';
}
