# Envystic - Simplified Environment Variable Management for Dart/Flutter

[![pub package](https://img.shields.io/pub/v/envystic.svg)](https://pub.dartlang.org/packages/envystic) [![GitHub license](https://img.shields.io/github/license/itisnajim/envystic)](https://github.com/itisnajim/envystic/blob/main/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/itisnajim/envystic)](https://github.com/itisnajim/envystic/issues)


Envystic is a Dart/Flutter package that simplifies the management of environment variables (dotenv) and provides an extra layer of security. With Envystic, you can effortlessly handle environment variables in your Dart and Flutter projects, ensuring cleaner and more secure code.

## Features
* **Easy Environment Variable Management**: Envystic simplifies the management of environment variables by providing a convenient and structured way to define and access them in your Dart and Flutter projects.

* **Secure Variable Storage**: Envystic allows you to provide an optional encryption key to encrypt the values of your environment variables, enhancing the security of sensitive information.

* **Annotation-Based Configuration**: Defining environment variables is straightforward with the use of annotations. The Envystic and EnvysticField annotations help generate the necessary code for accessing your environment variables.

* **Custom Key Names**: You can specify custom key names for your environment variables in the .env file, making it easy to reference them in your code.

* **Flutter and Dart Support**: Envystic is designed to work seamlessly with both Flutter and Dart projects, allowing you to manage environment variables consistently across different types of applications.

## Installation

### Flutter Project
```console
flutter pub add envystic && flutter pub add --dev envystic_generator build_runner
```

### Dart Project
```console
dart pub add envystic && dart pub add --dev envystic_generator build_runner
```


## Usage
1. Import the envystic package into your Dart/Flutter file:

```dart
import 'package:envystic/envystic.dart';
```

2. Define an environment variable class using the `Envystic` annotation and the `EnvysticField` annotation for each desired variable:

```dart
part 'env.g.dart';

@envystic
class Env extends _$Env {
  // If no encryption, you can omit `super.encryptionKey`
  // make it like: `const Env();`
  const Env({super.encryptionKey});

  @override
  @envysticField
  String get key1;

  @override
  @EnvysticField(name: 'FOO') // The value from 'FOO' in .env will be used
  int? get key2;

  // ignored
  String get drink => 'Coffee';
}
```

3. Generate the environment variable class using `build_runner`:

```console
dart run build_runner build
```
This will generate the necessary code based on the annotations in your codebase.

4. Access the environment variables in your Dart/Flutter code:

```dart
void main() {
  final env = Env();
  // Access environment variables
  print(env.key1); 
  print(env.key2);
  print(env.drink); // "Coffee"
}
```

## Configuration

The `Envystic` annotation supports the following optional parameters:

* `path`: Specifies the path to the environment variables file. If not provided, the default path is `.env`.
* `keyFormat`: Specifies the format of key names in the environment file (e.g., .env file). You can choose from different naming conventions such as kebab-case, snake_case, PascalCase, or SCREAMING_SNAKE_CASE.
* `generateEncryption`: Determines whether to generate the `encryptionKeyOutput` if it does not already exist. Set this to `true` if you want Envystic to create an `encryption` key automatically for enhanced security.
* `encryptionKeyOutput`: Specifies the file path to use and save the `encryption` key. If `generateEncryption` is set to `true` and this parameter is `null`, the default path `env_encryption.key` will be used to store the encryption key. Alternatively, if you set `encryptionKeyOutput` to `null` and `generateEncryption` is not `true`, No encryption will be applied, and the values will be subjected to a `base64` encoding for a basic level of protection.

These configuration options for efficient environment variable management. Customize file paths, key naming conventions, and enhance security with encryption as needed.

## EnvysticAll Annotation
The `EnvysticAll` annotation provides an automatic way to load all keys from the environment file without the need to specify them individually using getters.

#### Example:
```dart
import 'package:envystic/envystic.dart';

part 'env_all.g.dart';

@EnvysticAll(path: '.env.example')
class EnvAll extends _$EnvAll {
  const Env({super.encryptionKey});

  @override
  @EnvysticField(
      name:
          'MY_SPECIAL_KEY') // This will be pulled from System environment variables if not exists in .env.example
  int? get specialKey;
}

void main() {
  final envAll = EnvAll(encryptionKey: encryptionKey);
  // Access all loaded environment variables
  print(envAll.specialKey); 
  print(envAll.key1);
  print(envAll.key2);
  print(envAll.foo);
  print(envAll.bar);
  ...
}
```

It is recommended to use the `@Envystic` annotation instead of `@EnvysticAll`. Using `@Envystic` allows you to specify only the fields needed, reducing class overload and ensuring better maintainability.

## Global Configuration

To override `null` parameters in each annotated class, you can use the `build.yaml` file or specify `command` line options when running `build_runner`. Here's how you can configure the options:

### Method 1: Via `build.yaml`
1. Open your `build.yaml` file or create one if it doesn't exist.
2. Look for the `targets` section and locate the `$default` target.
3. Under the `$default` target, find or add the `envystic_generator|envystic` builder and modify the options as follows:

```yaml
targets:
  $default:
    builders:
      envystic_generator|envystic:
        options:
          # Choose the desired format for the keys: none, kebab, snake, pascal, or screamingSnake
          key_format: screamingSnake
          # Determine whether to generate the encryption_key_output if it doesn't already exist
          # Set this to true to enable generation of the encryption key for dotenv values.
          generate_encryption: true
          # `encryption_key_output` File path to use and save the encryption key.
          # If `generate_encryption` is true and `encryption_key_output` is not set, the default
          # value 'env_encryption.key' will be used.
          # Comment out the line below and set generate_encryption to false
          # to exclude encryption from dotenv values.
          encryption_key_output: env_encryption_output.key
```

### Method 2: Via Command Line
1. Open your terminal or command prompt.
2. Use the following command to specify the desired configuration:

```console
dart run build_runner build --define envystic_generator:envystic=generate_encryption=true --define envystic_generator:envystic=encryption_key_output=env_encryption_output.key
```

With these configuration options, you can customize how Envystic handles your environment variables. The `key_format` allows you to choose the desired naming convention for the keys (e.g., kebab-case, snake_case, PascalCase, SCREAMING_SNAKE_CASE, etc.). The `generate_encryption` option lets you decide whether to generate an encryption key for enhanced security, and you can specify the file path using `encryption_key_output`.

By setting these global options, you can ensure consistent behavior across all your annotated classes, making it easier to manage and maintain your environment variables in Dart and Flutter projects with Envystic.


## Methods

#### `T get<T>(String envKey)`

Retrieves the value associated with the given envKey from the loaded environment entries.
The type of the returned value is inferred based on the actual field type.

Example:

```dart
final myValue = env.get<int>('MY_SPECIAL_KEY');
```

In this example, `MY_SPECIAL_KEY` is retrieved from the loaded environment entries as specified: `integer`.
If the key does not exist or the value cannot be cast to the specified type, this method will throw an exception.

#### `T? tryGet<T>(String envKey)`

Tries to retrieve the value associated with the given envKey from the loaded environment entries.
If the key does not exist or the value cannot be cast to the specified type,
this method will return `null` instead of throwing an exception.

#### `T getForField<T>(String fieldName)`

Retrieves the value associated with the given `fieldName` from the loaded environment entries.
The type of the returned value is inferred based on the specified generic type `T`.

Throws an exception if the `fieldName` does not exist in the loaded environment entries
or if the value cannot be cast to the specified type `T`.

Example:

```dart
final myValue = env.getForField<int>('specialKey');
```

#### `bool isKeyExists(String envKey)`

Checks if the provided envKey exists in the loaded environment keys.
Returns true if the key exists, false otherwise.

#### `String? getFieldName(String envKey)`

Gets the field name associated with the provided `envKey`.
If the `envKey` exists, returns the corresponding field name; otherwise, returns `null`.

## Important

When using the Envystic package for environment variable management in your Dart/Flutter projects, there are a few crucial points to keep in mind:

1. Envystic uses the build_runner tool to generate the necessary code based on the annotations in your environment variable class. Whenever you make changes to the annotated environment class or modify the .env file, you must run the following command to regenerate the required code:

``` console
dart run build_runner build
```

Failing to run this command after making changes may result in outdated or incorrect code, leading to unexpected behavior in your application.

2. Secure Encryption Key Management: If you choose to use encryption for your environment variables, it is essential to handle the encryption key securely. The encryption key is a sensitive piece of information that should never be committed to version control or exposed in any way. Make sure to add the encryption key file (e.g., `env_encryption.key`) to your `.gitignore` or equivalent version control ignore file to prevent accidental commits.

3. Separate Environments: Consider using different .env files for different environments (e.g., development, staging, production). This helps manage different configurations effectively and reduces the risk of using incorrect values in different environments.


## Author

itisnajim, itisnajim@gmail.com

## License

Envystic is available under the MIT license. See the LICENSE file for more info.