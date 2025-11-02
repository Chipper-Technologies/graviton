import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/enums/version_status.dart';
import 'package:graviton/models/platform_version_config.dart';
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

  // Platform-specific configurations
  PlatformVersionConfig? _androidConfig;
  PlatformVersionConfig? _iosConfig;

  /// Get the configuration for the current platform
  PlatformVersionConfig get _currentPlatformConfig {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosConfig ?? _getLegacyConfig();
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidConfig ?? _getLegacyConfig();
    }
    return _getLegacyConfig();
  }

  /// Create a legacy configuration from old-style values
  PlatformVersionConfig _getLegacyConfig() {
    return PlatformVersionConfig.legacy(
      currentVersion: _currentVersion ?? '',
      minimumEnforcedVersion: _minimumEnforcedVersion ?? '',
      minimumPreferredVersion: _minimumPreferredVersion ?? '',
      storeUrl: _getLegacyStoreUrl(),
    );
  }

  /// Get the legacy store URL based on platform
  String _getLegacyStoreUrl() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _appStoreUrl ?? '';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return _playStoreUrl ?? '';
    }
    return '';
  }

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

      // Set defaults for both legacy and new platform-specific structure
      await remoteConfig.setDefaults({
        'current_version': '',
        // Legacy fallbacks
        'minimum_enforced_version': '',
        'minimum_preferred_version': '',
        'app_store_url': '',
        'play_store_url': '',
        // New platform-specific structure
        'android': '',
        'ios': '',
      });

      // Fetch and activate
      await remoteConfig.fetchAndActivate();

      // Load current version
      _currentVersion = remoteConfig.getString('current_version');

      // Load platform-specific configurations
      _loadPlatformConfigs(remoteConfig);

      // Load legacy values as fallback
      _loadLegacyConfig(remoteConfig);

      debugPrint(
        'Remote config loaded: current=$_currentVersion, '
        'android=${_androidConfig?.toString()}, '
        'ios=${_iosConfig?.toString()}, '
        'legacy: enforced=$_minimumEnforcedVersion, preferred=$_minimumPreferredVersion',
      );
    } catch (e) {
      debugPrint('Failed to load remote config: $e');
    }
  }

  /// Load platform-specific configurations from Remote Config
  void _loadPlatformConfigs(FirebaseRemoteConfig remoteConfig) {
    try {
      // Load Android configuration from JSON data type
      final androidConfigValue = remoteConfig.getValue('android');
      if (androidConfigValue.source != ValueSource.valueStatic) {
        try {
          // Parse JSON from the string value
          final androidJsonString = androidConfigValue.asString();
          if (androidJsonString.isNotEmpty) {
            final androidJson =
                jsonDecode(androidJsonString) as Map<String, dynamic>;
            _androidConfig = PlatformVersionConfig.fromJson(androidJson);
            debugPrint('Loaded Android config: $_androidConfig');
          }
        } catch (e) {
          debugPrint('Failed to parse Android JSON config: $e');
        }
      }

      // Load iOS configuration from JSON data type
      final iosConfigValue = remoteConfig.getValue('ios');
      if (iosConfigValue.source != ValueSource.valueStatic) {
        try {
          // Parse JSON from the string value
          final iosJsonString = iosConfigValue.asString();
          if (iosJsonString.isNotEmpty) {
            final iosJson = jsonDecode(iosJsonString) as Map<String, dynamic>;
            _iosConfig = PlatformVersionConfig.fromJson(iosJson);
            debugPrint('Loaded iOS config: $_iosConfig');
          }
        } catch (e) {
          debugPrint('Failed to parse iOS JSON config: $e');
        }
      }
    } catch (e) {
      debugPrint('Failed to load platform-specific configs: $e');
    }
  }

  /// Load legacy configuration values as fallback
  void _loadLegacyConfig(FirebaseRemoteConfig remoteConfig) {
    try {
      _minimumEnforcedVersion = remoteConfig.getString(
        'minimum_enforced_version',
      );
      _minimumPreferredVersion = remoteConfig.getString(
        'minimum_preferred_version',
      );
      _appStoreUrl = remoteConfig.getString('app_store_url');
      _playStoreUrl = remoteConfig.getString('play_store_url');
    } catch (e) {
      debugPrint('Failed to load legacy config: $e');
    }
  }

  /// Get the current app version
  /// Get the current version for the platform (platform-specific or legacy fallback)
  String? get currentVersion {
    final currentPlatform = _currentPlatformConfig;

    // Use platform-specific config if available and has current version
    if (currentPlatform.isValid && currentPlatform.currentVersion.isNotEmpty) {
      return currentPlatform.currentVersion;
    }

    // Fall back to legacy global current version
    return _currentVersion;
  }

  /// Get the app version
  String get appVersion => _packageInfo?.version ?? '1.0.0';

  /// Get the current build number
  String get buildNumber => _packageInfo?.buildNumber ?? '1';

  /// Get the full version string
  String get fullVersion => '$appVersion+$buildNumber';

  /// Check the version status of the current app
  VersionStatus getVersionStatus() {
    final platformCurrentVersion = currentVersion;
    if (platformCurrentVersion == null || platformCurrentVersion.isEmpty) {
      return VersionStatus.current; // Default to current if no remote config
    }

    final currentAppVersion = _parseVersion(appVersion);
    final latestVersion = _parseVersion(platformCurrentVersion);
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
    final currentPlatform = _currentPlatformConfig;
    String? targetVersion;

    // Use platform-specific config if available
    if (currentPlatform.isValid) {
      targetVersion = currentPlatform.minimumEnforcedVersion;
    } else {
      // Fall back to legacy config
      targetVersion = _minimumEnforcedVersion;
    }

    if (targetVersion == null || targetVersion.isEmpty) {
      return true; // No minimum enforced version requirement
    }

    final currentAppVersion = _parseVersion(appVersion);
    final minimumRequired = _parseVersion(targetVersion);
    return _compareVersions(currentAppVersion, minimumRequired) >= 0;
  }

  /// Check if the app version meets the preferred minimum version (recommended)
  bool meetsPreferredVersion() {
    final currentPlatform = _currentPlatformConfig;
    String? targetVersion;

    // Use platform-specific config if available
    if (currentPlatform.isValid) {
      targetVersion = currentPlatform.minimumPreferredVersion;
    } else {
      // Fall back to legacy config
      targetVersion = _minimumPreferredVersion;
    }

    if (targetVersion == null || targetVersion.isEmpty) {
      return true; // No preferred version requirement
    }

    final currentAppVersion = _parseVersion(appVersion);
    final preferredMinimum = _parseVersion(targetVersion);
    return _compareVersions(currentAppVersion, preferredMinimum) >= 0;
  }

  /// Get the appropriate store URL for the current platform
  String? getStoreUrl() {
    final currentPlatform = _currentPlatformConfig;

    // Use platform-specific config if available and has a store URL
    if (currentPlatform.isValid && currentPlatform.storeUrl.isNotEmpty) {
      return currentPlatform.storeUrl;
    }

    // Fall back to legacy platform-specific URLs
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
