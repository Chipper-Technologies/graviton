import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/enums/version_status.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for checking app version status and handling updates
class VersionService {
  static VersionService? _instance;
  static VersionService get instance => _instance ??= VersionService._();

  VersionService._();

  PackageInfo? _packageInfo;
  String? _currentVersion;
  String? _minimumEnforcedVersion;
  String? _minimumPreferredVersion;
  String? _appStoreUrl;
  String? _playStoreUrl;

  /// Initialize the version service
  Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      await _loadRemoteConfig();
    } catch (e) {
      debugPrint('Version service initialization failed: $e');
    }
  }

  /// Load version configuration from Firebase Remote Config
  Future<void> _loadRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      // Set defaults
      await remoteConfig.setDefaults({
        'current_version': '',
        'minimum_enforced_version': '',
        'minimum_preferred_version': '',
        'app_store_url': '',
        'play_store_url': '',
      });

      // Fetch and activate
      await remoteConfig.fetchAndActivate();

      // Load values
      _currentVersion = remoteConfig.getString('current_version');
      _minimumEnforcedVersion = remoteConfig.getString('minimum_enforced_version');
      _minimumPreferredVersion = remoteConfig.getString('minimum_preferred_version');
      _appStoreUrl = remoteConfig.getString('app_store_url');
      _playStoreUrl = remoteConfig.getString('play_store_url');

      debugPrint(
        'Remote config loaded: current=$_currentVersion, enforced=$_minimumEnforcedVersion, preferred=$_minimumPreferredVersion',
      );
    } catch (e) {
      debugPrint('Failed to load remote config: $e');
    }
  }

  /// Get the current app version
  String get appVersion => _packageInfo?.version ?? '1.0.0';

  /// Get the current build number
  String get buildNumber => _packageInfo?.buildNumber ?? '1';

  /// Get the full version string
  String get fullVersion => '$appVersion+$buildNumber';

  /// Check the version status of the current app
  VersionStatus getVersionStatus() {
    if (_currentVersion == null || _currentVersion!.isEmpty) {
      return VersionStatus.current; // Default to current if no remote config
    }

    final currentAppVersion = _parseVersion(appVersion);
    final latestVersion = _parseVersion(_currentVersion!);
    final comparison = _compareVersions(currentAppVersion, latestVersion);
    if (comparison > 0) {
      return VersionStatus.beta; // App version is higher than current
    } else if (comparison < 0) {
      return VersionStatus.outdated; // App version is lower than current
    } else {
      return VersionStatus.current; // Versions match
    }
  }

  /// Check if the app version meets the minimum enforced version (mandatory)
  bool meetsMinimumVersion() {
    if (_minimumEnforcedVersion == null || _minimumEnforcedVersion!.isEmpty) {
      return true; // No minimum enforced version requirement
    }

    final currentAppVersion = _parseVersion(appVersion);
    final minimumRequired = _parseVersion(_minimumEnforcedVersion!);
    return _compareVersions(currentAppVersion, minimumRequired) >= 0;
  }

  /// Check if the app version meets the preferred minimum version (recommended)
  bool meetsPreferredVersion() {
    if (_minimumPreferredVersion == null || _minimumPreferredVersion!.isEmpty) {
      return true; // No preferred version requirement
    }

    final currentAppVersion = _parseVersion(appVersion);
    final preferredMinimum = _parseVersion(_minimumPreferredVersion!);
    return _compareVersions(currentAppVersion, preferredMinimum) >= 0;
  }

  /// Get the appropriate store URL for the current platform
  String? getStoreUrl() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _appStoreUrl;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return _playStoreUrl;
    }

    return null;
  }

  /// Launch the appropriate store for updates
  Future<bool> launchStore() async {
    final url = getStoreUrl();
    if (url == null || url.isEmpty) {
      debugPrint('No store URL configured for this platform');
      return false;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      debugPrint('Failed to launch store URL: $e');
    }

    return false;
  }

  /// Parse version string into comparable format
  List<int> _parseVersion(String version) {
    return version.split('.').map((part) {
      // Extract numeric part (ignore any alpha/beta suffixes)
      final match = RegExp(r'(\d+)').firstMatch(part);
      return match != null ? int.parse(match.group(1)!) : 0;
    }).toList();
  }

  /// Compare two version lists
  /// Returns: -1 if v1 < v2, 0 if equal, 1 if v1 > v2
  int _compareVersions(List<int> v1, List<int> v2) {
    final maxLength = [v1.length, v2.length].reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxLength; i++) {
      final part1 = i < v1.length ? v1[i] : 0;
      final part2 = i < v2.length ? v2[i] : 0;

      if (part1 < part2) return -1;
      if (part1 > part2) return 1;
    }

    return 0;
  }
}
