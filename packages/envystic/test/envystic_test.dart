import 'package:envystic/envystic.dart';
import 'package:test/test.dart';

void main() {
  group('Envystic Test Group', () {
    test('Empty constructor', () {
      final envystic = Envystic();
      expect(envystic.path, '.env');
      expect(envystic.encryptionKey, null);
    });

    test('Specified path', () {
      final envystic = Envystic(path: '.env.test');
      expect(envystic.path, '.env.test');
    });

    test('Specified encryptionKey', () {
      final encryptionKey = 'ThisIsAPassword';
      final envystic = Envystic(encryptionKey: encryptionKey);
      expect(envystic.encryptionKey, encryptionKey);
    });

    test('Specified keyFormat', () {
      final envystic = Envystic(keyFormat: KeyFormat.kebab);
      expect(envystic.keyFormat, KeyFormat.kebab);
    });
  });

  group('EnvysticField Test Group', () {
    test('Empty constructor', () {
      final envysticField = EnvysticField();
      expect(envysticField.name, null);
      expect(envysticField.defaultValue, null);
    });

    test('Specified name', () {
      final envysticField = EnvysticField(name: 'key');
      expect(envysticField.name, 'key');
    });

    test('Specified defaultValue', () {
      final envysticField = EnvysticField(defaultValue: 'test');
      expect(envysticField.defaultValue, 'test');
    });
  });
}
