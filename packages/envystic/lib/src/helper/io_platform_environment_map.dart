import 'dart:io' show Platform;

import 'platform_environment_map.dart';

class IoPlatformEnvironmentMap implements PlatformEnvironmentMap {
  @override
  Map<String, String> getMap() => Platform.environment;
}

PlatformEnvironmentMap getPlatformEnvironmentMap() =>
    IoPlatformEnvironmentMap();
