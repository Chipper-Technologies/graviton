/// Platform channel names for native platform integration.
class PlatformChannelConstants {
  /// Private constructor to prevent instantiation.
  PlatformChannelConstants._();

  /// Channel name for navigation between Flutter and native platform.
  static const String navigation = 'io.chipper.graviton/navigation';

  /// Channel name for simulation control from native platform.
  static const String simulation = 'io.chipper.graviton/simulation';
}
