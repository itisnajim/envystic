import 'platform_environment_map_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'io_platform_environment_map.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'web_platform_environment_map.dart';

abstract class PlatformEnvironmentMap {
  Map<String, String> getMap();

  factory PlatformEnvironmentMap() => getPlatformEnvironmentMap();
}
