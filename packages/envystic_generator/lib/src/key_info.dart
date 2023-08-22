/// Represents information about a key, including its output and key value.
class KeyInfo {
  /// The output of the key, representing the file path or location where the key is saved.
  final String? output;

  /// The actual key value.
  final String? key;

  /// Creates a new instance of [KeyInfo].
  ///
  /// [output] is the path or location where the key is saved.
  /// [key] is the actual value of the key.
  const KeyInfo(this.output, this.key);

  @override
  String toString() {
    return "KeyInfo: { output: $output, key: $key }";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyInfo &&
          runtimeType == other.runtimeType &&
          output == other.output &&
          key == other.key;

  @override
  int get hashCode => output.hashCode ^ key.hashCode;
}
