# Envystic
[![pub package](https://img.shields.io/pub/v/envystic.svg)](https://pub.dartlang.org/packages/envystic) [![GitHub license](https://img.shields.io/github/license/itisnajim/envystic)](https://github.com/itisnajim/envystic/blob/main/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/itisnajim/envystic)](https://github.com/itisnajim/envystic/issues)


Envystic is a Dart/Flutter package that simplifies the management of environment variables (dotenv) and provides an extra layer of security. With Envystic, you can effortlessly handle environment variables in your Dart and Flutter projects, ensuring cleaner and more secure code.

## Features
1. **Easy Environment Variable Management**: Envystic simplifies the management of environment variables by providing a convenient and structured way to define and access them in your Dart and Flutter projects.

2. **Secure Variable Storage**: Envystic allows you to provide an optional encryption key to obfuscate or encrypt the values of your environment variables, enhancing the security of sensitive information.

3. **Annotation-Based Configuration**: Defining environment variables is straightforward with the use of annotations. The Envystic and EnvysticField annotations help generate the necessary code for accessing your environment variables.

4. **Custom Key Names**: You can specify custom key names for your environment variables in the .env file, making it easy to reference them in your code.

5. **Flutter and Dart Support**: Envystic is designed to work seamlessly with both Flutter and Dart projects, allowing you to manage environment variables consistently across different types of applications.

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
abstract class Env {
  const factory Env() = _$Env;

  const Env._();

  @envysticField // Default key name assigned: 'KEY1'
  String get key1;

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
  final env = Env(); // Provide an encryption key (optional)
  // Access environment variables
  print(env.key1); 
  print(env.key2);
}
```

## Configuration

The `Envystic` annotation supports the following optional parameters:

* `path`: The path to the environment variables file. By default, it is set to `.env`'.
* `encryptionKey`: If provided, this encryption key will be used to obfuscate / encrypt the values. If not provided, a `base64` encoding is applied to the values for a simple level of protection.
* `keyFormat`: Specifies the format of key names in the environment file (e.g., .env). Defaults to [KeyFormat.screamingSnake].


## Example
Here's an example of using the Envystic package:

```dart
import 'package:envystic/envystic.dart';

part 'env.g.dart';

@envystic
abstract class Env {
  const factory Env() = _$Env;

  const Env._();

  @envysticField // Default key name assigned: 'KEY1'
  String get key1;

  @EnvysticField(name: 'FOO') // The value from 'FOO' in .env will be used
  int? get key2;

  // ignored
  String get drink => 'Coffee';
}


void main() {
  final env = Env();
  // Access environment variables
  print(env.key1); 
  print(env.key2);
  print(env.drink); // "Coffee"
}
```

## Author

itisnajim, itisnajim@gmail.com

## License

Envystic is available under the MIT license. See the LICENSE file for more info.