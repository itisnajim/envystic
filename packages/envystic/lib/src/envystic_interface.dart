import 'helper/utils.dart';

/// A parent class for all Envystic generated classes.
/// Used to add support for equality comparison using `==`,
/// computing hash codes and to add support methods.
class EnvysticInterface {
  const EnvysticInterface({this.encryptionKey});
  final String? encryptionKey;

  String get encodedEntries => throw UnimplementedError();
  String get encodedKeysFields => throw UnimplementedError();

  /// Retrieves the value associated with the given [fieldName] from the loaded environment entries.
  /// The type of the returned value is inferred based on the specified generic type [T].
  ///
  /// Throws an exception if the [fieldName] does not exist in the loaded environment entries
  /// or if the value cannot be cast to the specified type [T].
  ///
  /// Example:
  /// ```
  /// final myValue = env.getForField<int>('specialKey');
  /// ```
  /// In this example, `specialKey` is retrieved from the loaded environment entries as an integer.
  /// If the field does not exist or the value cannot be cast to an integer,
  /// this method will throw an exception.
  T getForField<T>(String fieldName) =>
      getEntryValue(fieldName, encodedEntries, encryptionKey);

  /// Checks if the provided [envKey] exists in the loaded environment keys.
  /// Returns `true` if the key exists, `false` otherwise.
  bool isKeyExists(String envKey) => isEnvKeyExists(envKey, encodedKeysFields);

  /// Gets the field name associated with the provided [envKey].
  /// If the [envKey] exists, returns the corresponding field name; otherwise, returns `null`.
  String? getFieldName(String envKey) =>
      getFieldNameForKey(envKey, encodedKeysFields);

  /// Retrieves the value associated with the given [envKey] from the loaded environment entries.
  /// The type of the returned value is inferred based on the actual field type.
  ///
  /// Example:
  /// ```
  /// final myValue = env.get<int>('specialKey');
  /// ```
  /// In this example, `specialKey` is retrieved from the loaded environment entries as an integer.
  /// If the key does not exist or the value cannot be cast to the specified type,
  /// this method will throw an exception.
  T get<T>(String envKey) => getForField(getFieldName(envKey)!);

  /// Tries to retrieve the value associated with the given [envKey] from the loaded environment entries.
  /// If the key does not exist or the value cannot be cast to the specified type,
  /// this method will return `null` instead of throwing an exception.
  ///
  /// Example:
  /// ```
  /// final myValue = env.tryGet<int>('specialKey');
  /// ```
  /// In this example, `specialKey` is retrieved from the loaded environment entries as an integer.
  /// If the key does not exist or the value cannot be cast to the specified type,
  /// `myValue` will be `null`.
  T? tryGet<T>(String envKey) {
    try {
      return !isKeyExists(envKey) ? null : getForField(getFieldName(envKey)!);
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvysticInterface &&
          encryptionKey == other.encryptionKey &&
          encodedEntries == other.encodedEntries;

  @override
  int get hashCode => encryptionKey.hashCode ^ encodedEntries.hashCode;
}
