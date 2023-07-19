## 0.1.0

- Introduced `EnvysticInterface`, an interface that provides a contract for generated classes. The generated class implements this interface, ensuring support for equality comparison using == and hash code computation.
- Equality Comparison (==) and Hash Code Computation: The generated class now fully supports equality comparison and hash code computation. Instances of the generated class are considered equal if they have the same field keys, field values, and encryption key. 

## 0.0.2

- Pulls variable from Platform.environment if it doesn't exist in the .env file.

## 0.0.1

- Initial version.
