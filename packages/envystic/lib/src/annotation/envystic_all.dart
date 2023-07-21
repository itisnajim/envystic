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
  /// [encryptionKey] specifies the encryption key used to encrypt the values.
  /// If `null`, a `base64` encoding is applied to the values for a simple level of protection.
  /// [keyFormat] specifies the format of key names in the environment file (e.g., `.env` file).
  /// Defaults to [KeyFormat.none].
  const EnvysticAll({
    super.path,
    //super.encryptionKey,
    super.keyFormat,
  });
}
