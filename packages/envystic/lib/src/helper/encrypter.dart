import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

/// **Ignore This Class** Used by the package
class Encrypter {
  final Uint8List key;

  Encrypter(String password) : key = generateKeyFromPassword(password);

  Uint8List encrypt(String value) {
    final cipher = createCipher(true);
    final encryptedValue =
        cipher.process(Uint8List.fromList(utf8.encode(value)));
    return encryptedValue;
  }

  String decrypt(Uint8List encryptedValue) {
    final cipher = createCipher(false);
    final decryptedValue = cipher.process(encryptedValue);
    return utf8.decode(decryptedValue);
  }

  static Uint8List generateKeyFromPassword(String password) {
    final salt = utf8.encode(
      'RU5WeXN0aWMgc3BhcmssIHdoZXJlIGZhbnRhc2llcyBlbWJhcmsu',
    );
    final iterations = 1000;
    final derivedKeyLength = 32; // 256-bit key
    final passwordBytes = utf8.encode(password);

    final pbkdf2Parameters = Pbkdf2Parameters(
      Uint8List.fromList(salt),
      iterations,
      derivedKeyLength,
    );

    final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    keyDerivator.init(pbkdf2Parameters);
    final key = keyDerivator.process(Uint8List.fromList(passwordBytes));

    return key;
  }

  BlockCipher createCipher(bool forEncryption) {
    final cipher = AESEngine();
    final cbcCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    final params = PaddedBlockCipherParameters(KeyParameter(key), null);
    cbcCipher.init(forEncryption, params);
    return cbcCipher;
  }
}
