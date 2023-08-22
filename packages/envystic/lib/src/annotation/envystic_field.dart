/// Annotation used to specify an environment variable how should be generated.
const envysticField = EnvysticField();

typedef CustomLoader = Object? Function();

/// Annotation used to specify an environment variable how should be generated.
class EnvysticField {
  /// The key name of the field.
  final String? name;

  /// The default value for the field.
  /// will be used if null value found in the 3 levels:
  /// `system`, `.env file` and [customLoader]
  final Object? defaultValue;

  /// Additional (to `system` and `.env file`) a custom way to load the value
  /// of this field. [customLoader] Can be used to load the value from a
  /// remote source, e.g: Rest Api, Firebase Remote Config, etc..,
  final CustomLoader? customLoader;

  /// Creates an instance of [EnvysticField].
  ///
  /// [name] specifies the name of the field.
  /// [defaultValue] specifies the default value for the field.
  const EnvysticField({
    this.name,
    this.defaultValue,
    this.customLoader,
  });
}
