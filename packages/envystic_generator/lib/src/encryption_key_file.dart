import 'helpers.dart';

class EncryptionKeyFile {
  static const defaultPath = 'env_encryption.key';
  final String path;

  const EncryptionKeyFile(
    String? path,
  ) : path = path ?? defaultPath;

  void write(String key) {
    saveContentToFileSync(key, path);
  }

  String? read() {
    final key = readFileContentSync(path)?.trim();
    return (key?.isEmpty ?? true) ? null : key;
  }
}
