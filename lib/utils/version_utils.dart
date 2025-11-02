/// Utility functions for semantic version handling and comparison
class VersionUtils {
  /// Compare two semantic version strings
  /// Returns -1 if version1 < version2, 0 if equal, 1 if version1 > version2
  static int compareVersions(String version1, String version2) {
    final v1Parts = version1
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    final v2Parts = version2
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    // Pad with zeros to ensure same length
    while (v1Parts.length < 3) {
      v1Parts.add(0);
    }
    while (v2Parts.length < 3) {
      v2Parts.add(0);
    }

    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }

    return 0;
  }

  /// Calculate the next minor version from a given version
  /// For example: 1.1.1 -> 1.2.0, 1.0.5 -> 1.1.0
  static String getNextMinorVersion(String currentVersion) {
    try {
      final versionParts = currentVersion.split('.');
      if (versionParts.length < 2) {
        return '1.1.0'; // Fallback for invalid format
      }

      final major = int.tryParse(versionParts[0]) ?? 1;
      final minor = int.tryParse(versionParts[1]) ?? 0;

      return '$major.${minor + 1}.0';
    } catch (e) {
      return '1.1.0'; // Fallback for any parsing errors
    }
  }

  /// Parse a version string into major, minor, and patch components
  /// Returns a map with 'major', 'minor', and 'patch' keys
  static Map<String, int> parseVersion(String version) {
    try {
      final parts = version.split('.');
      if (parts.isEmpty) return {'major': 0, 'minor': 0, 'patch': 0};

      // Check if all parts are valid integers
      for (final part in parts) {
        if (int.tryParse(part) == null) {
          return {'major': 0, 'minor': 0, 'patch': 0};
        }
      }

      return {
        'major': int.tryParse(parts.isNotEmpty ? parts[0] : '0') ?? 0,
        'minor': int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
        'patch': int.tryParse(parts.length > 2 ? parts[2] : '0') ?? 0,
      };
    } catch (e) {
      return {'major': 0, 'minor': 0, 'patch': 0};
    }
  }

  /// Check if a version string is valid semantic version format
  static bool isValidVersion(String version) {
    if (version.isEmpty) return false;

    final parts = version.split('.');
    if (parts.length < 2 || parts.length > 3) return false;

    for (final part in parts) {
      if (int.tryParse(part) == null) return false;
    }

    return true;
  }

  /// Normalize a version string to major.minor.patch format
  /// For example: "1.0" -> "1.0.0"
  static String normalizeVersion(String version) {
    if (!isValidVersion(version)) return '0.0.0';

    final parts = version.split('.');
    while (parts.length < 3) {
      parts.add('0');
    }

    return parts.take(3).join('.');
  }
}
