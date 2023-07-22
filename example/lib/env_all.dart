import 'package:envystic/envystic.dart';

part 'env_all.g.dart';

@EnvysticAll(
  path: '.env.example',
  encryptionKeyOutput: 'example.key',
)
class EnvAll extends _$EnvAll {
  const EnvAll({super.encryptionKey});

  @override
  @EnvysticField(
      name:
          'MY_SPECIAL_KEY') // This will be pulled from System environment variables if not exists in .env.example
  int? get specialKey;

  String get drink => 'Coffee';
}
