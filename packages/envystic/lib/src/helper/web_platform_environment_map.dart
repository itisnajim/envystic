import 'dart:js' show context;

import 'platform_environment_map.dart';

class WebPlatformEnvironmentMap implements PlatformEnvironmentMap {
  @override
  Map<String, String> getMap() => context['env'];
}

PlatformEnvironmentMap getPlatformEnvironmentMap() =>
    WebPlatformEnvironmentMap();
