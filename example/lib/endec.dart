import 'dart:convert';

/// Encrypts or decrypts the input string using a simple XOR encryption method.
///
/// The `endec` function takes an `input` string and performs a basic XOR encryption or decryption on its bytes, using a fixed integer value called `life`.
///
/// The `life` value is XORed with each byte of the input string to produce the encrypted or decrypted result.
///
/// Note: This encryption/decryption method is intended for basic obfuscation purposes only and should not be used for sensitive data.
///
/// Example:
/// ```dart
/// String originalText = "Hello, World!";
///
/// // Encryption
/// String encrypted = endec(originalText);
/// print(encrypted); // Output: ÍÈÈÒÇÒÅWÈÇ
///
/// // Decryption (using the same key)
/// String decrypted = endec(encrypted);
/// print(decrypted); // Output: Hello, World!
/// ```
///
/// Parameters:
/// - `input`: The input string to be encrypted or decrypted.
/// - `escaped`: (Optional) If set to `true`, the output will be returned as a JSON-encoded string.
///
/// Returns:
/// - The encrypted or decrypted string, depending on the `input` and `life` values.
String endec(String input, {bool escaped = false}) {
  final int life = 42;

  final List<int> inputBytes = input.codeUnits.toList();
  for (int i = 0; i < inputBytes.length; i++) {
    inputBytes[i] ^= life;
  }

  final output = String.fromCharCodes(inputBytes);

  if (escaped) return jsonEncode(output);

  return output;
}

/// to use in the command line:
/// echo $(dart run lib/endec.dart 'Input String Example'
void main(List<String> args) {
  print(endec('S0djUmw4VzVuSU00Nk5DNA==', escaped: true));
}
