import 'dart:convert';

/// Encrypts or decrypts the input string using a simple XOR encryption method.
///
/// The `endec` function takes an `input` string and performs a basic XOR
/// encryption or decryption on its bytes.
///
/// Note: This encryption/decryption method is intended for basic obfuscation
/// purposes only and should not be used for sensitive data.
///
/// Example:
/// ```dart
/// String originalText = "Hello, World!";
///
/// // Encryption
/// String encrypted = endec(originalText, isEncrypt: true);
/// print(encrypted); // Output: "S2hvb3IsIFpydW9nIQ=="
///
/// // Decryption (using the same key)
/// String decrypted = endec(encrypted);
/// print(decrypted); // Output: Hello, World!
/// ```
///
/// Parameters:
/// [input] The input string to be encrypted or decrypted.
/// [isEncrypt] If set to `true`, the output will an encryption of [input]
/// else it's a decryption! default to `false`.
///
/// Returns:
/// The encrypted or decrypted [String] from the value [input].
String endec(String input, {bool isEncrypt = false}) {
  return isEncrypt
      ? base64Encode(encrypt(input, 3).codeUnits)
      : decrypt(String.fromCharCodes(base64Decode(input)), 3);
}

String encrypt(String input, int shift) {
  StringBuffer encrypted = StringBuffer();

  for (int i = 0; i < input.length; i++) {
    int charCode = input.codeUnitAt(i);
    if (charCode >= 65 && charCode <= 90) {
      charCode = ((charCode - 65 + shift) % 26) + 65;
    } else if (charCode >= 97 && charCode <= 122) {
      charCode = ((charCode - 97 + shift) % 26) + 97;
    }
    encrypted.writeCharCode(charCode);
  }

  return encrypted.toString();
}

String decrypt(String encrypted, int shift) {
  return encrypt(
    encrypted,
    26 - shift,
  ); // Decrypting is just shifting in the opposite direction
}

/// to use in the command line:
/// echo $(dart run lib/endec.dart 'InputStringExample')
void main(List<String> args) {
  print(endec(args.first, isEncrypt: true));
}
