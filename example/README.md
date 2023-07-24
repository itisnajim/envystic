# Envystic Example

This repository serves as the main example code for the [Envystic](https://pub.dev/packages/envystic) package, showcasing the simplified management of environment variables in Dart and Flutter projects. Envystic provides an intuitive way to define, access, and secure environment variables, making your code cleaner and more secure.

While Envystic supports **`optional`** encryption for environment variables, this example repository demonstrates how to utilize encryption to protect sensitive information in your application. 


## Installation

To run this example, ensure that you have Dart and Flutter (for Flutter projects) installed on your machine.

1. Clone this repository to your local machine:

```bash
git clone https://github.com/itisnajim/envystic.git
```

2. Navigate to the cloned repository:

```bash
cd envystic/example
```

3. Install the required dependencies using `dart pub get` for Dart projects or `flutter pub get` for Flutter projects:

```bash
dart pub get
```

4. Generate the necessary code based on the annotations in the environment variable classes using `build_runner`:

```bash
dart run build_runner build
```

This command will automatically generate the files `example.key` and `env_encryption_output.key` according to the settings specified in the `build.yaml` example directory.

## Running the Example

The `main.dart` file contains the entry point of the example code. It demonstrates how to use the environment variable classes `Env1` and `EnvAll`, which are defined using **annotations** provided by the Envystic package.

To run the example, follow these steps:

Define the encryption `keys` necessary to access the values in the `Env1` and `EnvAll` values. The required encryption keys are available in the generated files `example.key` and `env_encryption_output.key`.

```bash
export ENCRYPTION_ENV1_KEY=$(dart run lib/endec.dart 'S0djUmw4VzVuSU00Nk5DNA==') &&
export ENCRYPTION_ENV_ALL_KEY=$(dart run lib/endec.dart 'SWtUem9IdGJiWGZNejVsdQ==') &&
dart --define=ENCRYPTION_ENV1_KEY=$ENCRYPTION_ENV1_KEY --define=ENCRYPTION_ENV_ALL_KEY=$ENCRYPTION_ENV_ALL_KEY lib/main.dart
```

If you want to run the example on a specific platform (e.g., Android or iOS), you can use the following commands instead:

```bash
export ENCRYPTION_ENV1_KEY=$(dart run lib/endec.dart 'S0djUmw4VzVuSU00Nk5DNA==') &&
export ENCRYPTION_ENV_ALL_KEY=$(dart run lib/endec.dart 'SWtUem9IdGJiWGZNejVsdQ==') &&
flutter run --dart-define ENCRYPTION_ENV1_KEY=$ENCRYPTION_ENV1_KEY --dart-define ENCRYPTION_ENV_ALL_KEY=$ENCRYPTION_ENV_ALL_KEY
```

Alternatively, you can define the keys using **Visual Studio Code** `launch.json` launch configuration file. For more information following:

[Using dart-define in Flutter](https://dartcode.org/docs/using-dart-define-in-flutter/)

[Using define in Dart](https://dartcode.org/docs/using-define-in-dart/)

[launch.example.json](https://github.com/itisnajim/envystic/blob/main/example/launch.example.json)

By following these steps, you will have successfully defined in **compile-time** the required encryption `keys` for the `Env1` and `EnvAll` environment variable classes, enabling you to run the example code. The demonstration will exhibit secure access and display of environment variable values defined in these classes. The console output will showcase the retrieved values, including the decrypted keys and environment variable values from the specified classes.

## Important Note

Remember not to commit the encryption key files (in this example: `example.key` and `env_encryption_output.key`) to version control. These files contain sensitive information and should be kept secure. Include them in your `.gitignore` file to prevent accidental commits.


## Customization

Feel free to explore the `env1.dart` and `env_all.dart` files to see how you can define environment variable classes using the annotations provided by Envystic. Customize the environment variable classes according to your application's specific needs.

## License

The code in this example repository is available under the MIT license. See the LICENSE file for more information.
