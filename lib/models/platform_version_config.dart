import 'dart:convert';

/// Configuration model for platform-specific version requirements
class PlatformVersionConfig {
  final String currentVersion;
  final String minimumEnforcedVersion;
  final String minimumPreferredVersion;
  final String storeUrl;

  const PlatformVersionConfig({
    required this.currentVersion,
    required this.minimumEnforcedVersion,
    required this.minimumPreferredVersion,
    required this.storeUrl,
  });

  /// Create configuration from JSON map
  factory PlatformVersionConfig.fromJson(Map<String, dynamic> json) {
    return PlatformVersionConfig(
      currentVersion: json['current_version'] as String? ?? '',
      minimumEnforcedVersion: json['minimum_enforced_version'] as String? ?? '',
      minimumPreferredVersion:
          json['minimum_preferred_version'] as String? ?? '',
      storeUrl: json['store_url'] as String? ?? '',
    );
  }

  /// Create empty configuration
  const PlatformVersionConfig.empty()
    : currentVersion = '',
      minimumEnforcedVersion = '',
      minimumPreferredVersion = '',
      storeUrl = '';

  /// Create configuration from legacy values
  const PlatformVersionConfig.legacy({
    required this.currentVersion,
    required this.minimumEnforcedVersion,
    required this.minimumPreferredVersion,
    required this.storeUrl,
  });

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'current_version': currentVersion,
      'minimum_enforced_version': minimumEnforcedVersion,
      'minimum_preferred_version': minimumPreferredVersion,
      'store_url': storeUrl,
    };
  }

  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Check if configuration has valid enforced version
  bool get hasEnforcedVersion => minimumEnforcedVersion.isNotEmpty;

  /// Check if configuration has valid preferred version
  bool get hasPreferredVersion => minimumPreferredVersion.isNotEmpty;

  /// Check if configuration has valid store URL
  bool get hasStoreUrl => storeUrl.isNotEmpty;

  /// Check if configuration has valid (non-empty) version data
  bool get isValid =>
      currentVersion.isNotEmpty ||
      minimumEnforcedVersion.isNotEmpty ||
      minimumPreferredVersion.isNotEmpty;

  /// Check if configuration is completely empty
  bool get isEmpty =>
      currentVersion.isEmpty &&
      minimumEnforcedVersion.isEmpty &&
      minimumPreferredVersion.isEmpty &&
      storeUrl.isEmpty;

  @override
  String toString() {
    return 'PlatformVersionConfig('
        'current: $currentVersion, '
        'enforced: $minimumEnforcedVersion, '
        'preferred: $minimumPreferredVersion, '
        'storeUrl: $storeUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlatformVersionConfig &&
        other.currentVersion == currentVersion &&
        other.minimumEnforcedVersion == minimumEnforcedVersion &&
        other.minimumPreferredVersion == minimumPreferredVersion &&
        other.storeUrl == storeUrl;
  }

  @override
  int get hashCode {
    return currentVersion.hashCode ^
        minimumEnforcedVersion.hashCode ^
        minimumPreferredVersion.hashCode ^
        storeUrl.hashCode;
  }
}
