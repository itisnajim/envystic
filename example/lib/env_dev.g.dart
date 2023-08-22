// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_dev.dart';

// **************************************************************************
// EnvysticGenerator
// **************************************************************************

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by envystic and you are not supposed to need it nor use it.');

const String _encodedEntries =
    'eyJiYXNlVXJsIjpudWxsLCJhcGlLZXkiOiJDN3BnSFoxZ1NNaGdhM1U5Y0dHYXJWS3VvWjJ3bEtiY0hTUTlpY3QxZEZ4cW1qODVsTXJFd1NaQkRLU1R3TUE4In0=';
const String _encodedKeysFields =
    'eyJCQVNFX1VSTCI6ImJhc2VVcmwiLCJBUElfS0VZIjoiYXBpS2V5In0=';

abstract class _$EnvDev with IEnvystic {
  const _$EnvDev();

  @override
  String get encodedEntries$ => _encodedEntries;
  @override
  String get encodedKeysFields$ => _encodedKeysFields;
  @override
  ValuesPriority get valuesPriority$ => ValuesPriority();

  String get baseUrl => throw _privateConstructorUsedError;
  String get apiKey => throw _privateConstructorUsedError;

  EnvDev copyWith({required ValuesPriority valuesPriority}) =>
      throw _privateConstructorUsedError;
}

class _EnvDev extends EnvDev {
  @override
  final String? encryptionKey$;
  @override
  final ValuesPriority valuesPriority$;
  const _EnvDev({
    String? encryptionKey,
    ValuesPriority? valuesPriority,
  })  : encryptionKey$ = encryptionKey,
        valuesPriority$ = valuesPriority ?? const ValuesPriority(),
        super._();

  @override
  String get baseUrl => getForField('baseUrl');
  @override
  String get apiKey => getForField('apiKey');

  @override
  Map<String, CustomLoader?> get customLoaders$ => {};

  @override
  EnvDev copyWith({required ValuesPriority valuesPriority}) => _EnvDev(
        encryptionKey: encryptionKey$,
        valuesPriority: valuesPriority,
      );
}

class _EnvDevDefine extends EnvDev {
  const _EnvDevDefine({
    required this.baseUrl,
    required this.apiKey,
  }) : super._();

  @override
  final String baseUrl;
  @override
  final String apiKey;
}
