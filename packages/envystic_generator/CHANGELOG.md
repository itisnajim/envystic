## 0.3.3

- Fix issue when using `dynamic` type, 
- Add more documentation for encryption usage in the example folder.


## 0.3.2

- Support Type `Enum`: Introduces the capability to handle fields with `Enum` data types.


## 0.3.1

- Allows each annotated item to have its own encryption generation options, providing better security and customization options compared to a single global options.


## 0.3.0

- Enhanced Encryption Control: The encryption key is now handled via the constructor of the annotated class, offering more control over the encryption process. You can pass the encryption key as needed during the instantiation of your environment variable class.
- Automatic Encryption Key Generation: If no encryption key is provided and the `generate_encryption` build flag is set to `true`, running `build_runner` will automatically generate an encryption key to be used in the instantiation of the Envystic annotated class, enabling access to its properties securely.


## 0.2.0

#### Annotations
- Introducing `EnvysticAll` Annotation: With this annotation, you can now automatically load all fields from the environment file (e.g., .env file) without the need to specify them individually using getters.

#### Methods
- `T get<T>(String envKey)`: Method to retrieve the value associated with a given `envKey` from the loaded environment entries. Throws an exception if the key `envKey` does not exist or the value cannot be cast to the specified type `T`.
- `T? tryGet<T>(String envKey)`: Method is a safe way to retrieve the value associated with a given `envKey` from the loaded environment entries. It returns `null` if the key does not exist or the value cannot be cast to the specified type T, preventing exceptions.
- `T getForField<T>(String fieldName)`: Method to retrieve the value associated with a specific fieldName from the loaded environment entries.
- `bool isKeyExists(String envKey)`: Method to check if the provided `envKey` exists in the loaded environment keys. It returns true if the key exists and false otherwise.
- `String? getFieldName(String envKey)`: Method to get the field name associated with the provided `envKey`. If the `envKey` exists, it returns the corresponding field name; otherwise, it returns `null`.

## 0.1.0

- Introduced `EnvysticInterface`, an interface that provides a contract for generated classes. The generated class implements this interface, ensuring support for equality comparison using == and hash code computation.
- Equality Comparison (==) and Hash Code Computation: The generated class now fully supports equality comparison and hash code computation. Instances of the generated class are considered equal if they have the same field keys, field values, and encryption key. 

## 0.0.2

- Pulls variable from Platform.environment if it doesn't exist in the .env file.

## 0.0.1

- Initial version.
