import 'package:envystic/envystic.dart';

part 'env_all.g.dart';

int? specialKeyFetch({
  // required RemoteConfig remoteConfig,
  int defaultVal = 42,
}) {
  //int remoteVal = remoteConfig.getInt("specialKey");
  //remoteVal = remoteVal == 0 ? defaultVal : remoteVal;
  //return remoteVal;
  return defaultVal;
}

int? specialKeyLoader() =>
    specialKeyFetch(/*remoteConfig: getRemoteConfigInstance()*/);

@EnvysticAll(
  path: '.env.example',
  encryptionKeyOutput: 'example.key',
)
class EnvAll extends _$EnvAll {
  const EnvAll._();

  // you can omit `encryptionKey` if no encryption is needed!
  factory EnvAll({
    String? encryptionKey,
    ValuesPriority? valuesPriority,
  }) = _EnvAll;

  factory EnvAll.define({
    @EnvysticField(name: 'MY_SPECIAL_KEY', customLoader: specialKeyLoader)
    int? specialKey,
  }) = _EnvAllDefine;

  String get drink => 'Coffee';
}
