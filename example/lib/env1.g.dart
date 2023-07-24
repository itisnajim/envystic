// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env1.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

const String _encodedEntries =
    'eyJrZXkxIjoiVmNoZWtBelM5VjNTMlkvTEtPcFVDUT09Iiwia2V5MiI6IjZsYkJlYlNqSVZuTHZScmphcXNNZlE9PSIsInNwZWNpYWxLZXkiOiI2bGJCZWJTaklWbkx2UnJqYXFzTWZRPT0iLCJ0ZXN0IjoiMUwvTjNDQ1hEVmZ2OS9sejU4b0VxZz09IiwidGVzdDIiOm51bGwsIm5vdEV4aXN0cyI6bnVsbH0=';
const String _encodedKeysFields =
    'eyJLRVkxIjoia2V5MSIsIkZPTyI6ImtleTIiLCJNWV9TUEVDSUFMX0tFWSI6InNwZWNpYWxLZXkiLCJURVNUIjoidGVzdCIsIlRFU1QyIjoidGVzdDIiLCJOT1RfRVhJU1RTIjoibm90RXhpc3RzIn0=';

class _$Env1 extends EnvysticInterface {
  const _$Env1({super.encryptionKey});

  @override
  String get encodedEntries => _encodedEntries;
  @override
  String get encodedKeysFields => _encodedKeysFields;

  String get key1 => getForField('key1');

  int? get key2 => getForField('key2');

  int? get specialKey => getForField('specialKey');

  e.TestEnum get test => getForField('test');

  TestEnum2? get test2 => getForField('test2');

  dynamic get notExists => getForField('notExists');

  @override
  T getForField<T>(String fieldName) => getEntryValue(
        fieldName,
        encodedEntries,
        encryptionKey,
        fromString: fieldEnumValues[fieldName]?.byName,
      );

  Map<String, List<Enum>> get fieldEnumValues =>
      {'test': e.TestEnum.values, 'test2': TestEnum2.values};
}
