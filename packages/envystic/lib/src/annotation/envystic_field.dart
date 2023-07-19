/// Annotation used to specify an environment variable that should be generated
/// from the `.env` file specified in the [Envystic] path parameter.
const envysticField = EnvysticField();

/// Annotation used to specify an environment variable that should be generated
/// from the `.env` file specified in the [Envystic] path parameter.
class EnvysticField {
  /// The key name of the field.
  final String? name;

  /// The default value for the field.
  final Object? defaultValue;

  /// Creates an instance of [EnvysticField].
  ///
  /// [name] specifies the name of the field.
  /// [defaultValue] specifies the default value for the field.
  const EnvysticField({
    this.name,
    this.defaultValue,
  });
}
