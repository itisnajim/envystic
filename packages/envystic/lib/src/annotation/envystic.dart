import 'key_format.dart';

/// Annotation used to specify the class that contains environment variables
/// generated from an environment file (e.g., `.env` file).
const envystic = Envystic();

/// Annotation used to specify the class that contains environment variables
/// generated from an environment file (e.g., `.env` file).
class Envystic {
  /// The path to the environment variables file.
  final String path;

  /// Determines whether to generate the [encryptionKeyOutput] if it does not already exist.
  final bool? generateEncryption;

  /// File path to use and to save the encryption key.
  /// If set to `null`, the values will be subjected to a `base64` encoding
  /// for a basic level of protection.
  final String? encryptionKeyOutput;

  /// The format of key names in the environment file (e.g., `.env` file).
  /// Defaults to [KeyFormat.none].
  final KeyFormat? keyFormat;

  /// Creates an instance of [Envystic].
  ///
  /// [path] specifies the path to the environment variables file.
  /// If not provided, the default is '.env'.
  /// [generateEncryption] determines whether to generate the [encryptionKeyOutput] if it does not already exist.
  /// [encryptionKeyOutput] specifies the file path to use and save the encryption key.
  /// If set to `null`, a `base64` encoding is applied to the values for a basic level of protection.
  /// [keyFormat] specifies the format of key names in the environment file (e.g., `.env` file).
  /// Defaults to [KeyFormat.none].
  const Envystic({
    String? path,
    this.generateEncryption,
    this.encryptionKeyOutput,
    this.keyFormat,
  }) : path = path ?? '.env';
}
