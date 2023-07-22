import 'envystic.dart';

/// Annotation used to automatically load all fields from the environment file
/// (e.g., `.env` file) without the need to specify them using getters.
const envysticAll = EnvysticAll();

/// Annotation used to automatically load all fields from the environment file
/// (e.g., `.env` file) without the need to specify them using getters.
class EnvysticAll extends Envystic {
  /// Creates an instance of [EnvysticAll].
  ///
  /// [path] specifies the path to the environment variables file.
  /// If not provided, the default is '.env'.
  /// [generateEncryption] determines whether to generate the [encryptionKeyOutput] if it does not already exist.
  /// [encryptionKeyOutput] specifies the file path to use and save the encryption key.
  /// If set to `null`, a `base64` encoding is applied to the values for a basic level of protection.
  /// [keyFormat] specifies the format of key names in the environment file (e.g., `.env` file).
  /// Defaults to [KeyFormat.none].
  const EnvysticAll({
    super.path,
    super.generateEncryption,
    super.encryptionKeyOutput,
    super.keyFormat,
  });
}
