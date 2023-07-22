import 'dart:io';

class EncryptionKeyFile {
  static const defaultPath = 'env_encryption.key';
  final String path;

  const EncryptionKeyFile(
    String? path,
  ) : path = path ?? defaultPath;

  void writeSync(String key) {
    File(path).writeAsStringSync(key);
  }

  String? readSync() {
    final key = _readFileContentSync(path);
    return (key?.trim().isEmpty ?? true) ? null : key;
  }

  Future<File> write(String key) {
    return File(path).writeAsString(key);
  }

  Future<String?> read() async {
    final key = await _readFileContent(path);
    return (key?.trim().isEmpty ?? true) ? null : key;
  }

  /// Read file content as String synchronously.
  String? _readFileContentSync(String filePath) {
    File file = File(filePath);
    try {
      return file.readAsStringSync();
    } catch (e) {
      return null;
    }
  }

  /// Read file content as String.
  Future<String>? _readFileContent(String filePath) {
    File file = File(filePath);
    try {
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
