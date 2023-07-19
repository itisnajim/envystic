/// An interface defining the contract for Envystic generated classes.
/// Classes that implement this interface provide encryption key + encoded entries
/// Used to add support for equality comparison using `==` and computing hash codes.
interface class EnvysticInterface {
  /// This getter method implementation should returns the encryption key and
  /// encoded entries used for comparison and hashing.
  String get pairKeyEncodedEntries$ => throw UnimplementedError();
}
