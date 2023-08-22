import 'annotation/envystic_field.dart';
import 'helper/utils.dart';
import 'values_priority.dart';

mixin IEnvystic {
  String? get encryptionKey$ => null;
  ValuesPriority get valuesPriority$ => ValuesPriority();

  String get encodedEntries$ => throw UnimplementedError();
  String get encodedKeysFields$ => throw UnimplementedError();
  Map<String, CustomLoader?> get customLoaders$ => {};

  /// Retrieves the value associated with the given [fieldName] from the loaded environment entries.
  /// The type of the returned value is inferred based on the specified generic type [T].
  ///
  /// Throws an exception if the [fieldName] does not exist in the loaded environment entries
  /// or if the value cannot be cast to the specified type [T].
  ///
  /// [fromString] used to finds the enum value in enum list with name [String].
  /// If this is an enum just pass: fromString: TheEnum.values.byName
  ///
  /// Example:
  /// ```
  /// final myValue = env.getForField<int>('specialKey');
  /// ```
  /// In this example, `specialKey` is retrieved from the loaded environment entries as an integer.
  /// If the field does not exist or the value cannot be cast to an integer,
  /// this method will throw an exception.
  T getForField<T>(
    String fieldName, {
    T Function(String)? fromString,
  }) =>
      getEntryValue(
        fieldName,
        encryptionKey: encryptionKey$,
        encodedEntries: encodedEntries$,
        priority: valuesPriority$,
        fromString: fromString,
        customLoaders: customLoaders$,
      );

  /// Checks if the provided [envKey] exists in the loaded environment keys.
  /// Returns `true` if the key exists, `false` otherwise.
  bool isKeyExists(String envKey) => isEnvKeyExists(envKey, encodedKeysFields$);

  /// Gets the field name associated with the provided [envKey].
  /// If the [envKey] exists, returns the corresponding field name; otherwise, returns `null`.
  String? getFieldName(String envKey) =>
      getFieldNameForKey(envKey, encodedKeysFields$);

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
      other is IEnvystic &&
          encryptionKey$ == other.encryptionKey$ &&
          encodedKeysFields$ == other.encodedKeysFields$;

  @override
  int get hashCode => encryptionKey$.hashCode ^ encodedKeysFields$.hashCode;
}
