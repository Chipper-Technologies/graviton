import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/utils/version_utils.dart';

/// Service for fetching and managing changelog data from Firestore
class ChangelogService {
  static ChangelogService? _instance;
  static ChangelogService get instance => _instance ??= ChangelogService._();

  ChangelogService._();

  FirebaseFirestore? _firestore;
  List<ChangelogVersion> _cachedChangelogs = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  List<ChangelogVersion> get cachedChangelogs =>
      List.unmodifiable(_cachedChangelogs);

  /// Initialize the changelog service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _firestore = FirebaseFirestore.instance;

      // Configure Firestore settings for offline support
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _isInitialized = true;
      debugPrint('ChangelogService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing ChangelogService: $e');
      // Don't throw - app should work without changelog functionality
    }
  }

  /// Fetch all changelogs from Firestore, ordered by version (newest first)
  Future<List<ChangelogVersion>> fetchChangelogs({
    bool useCache = true,
    Source source = Source.serverAndCache,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Return cached data if requested and available
    if (useCache && _cachedChangelogs.isNotEmpty) {
      return _cachedChangelogs;
    }

    try {
      final collection = _firestore?.collection('changelogs');
      if (collection == null) {
        debugPrint('Firestore not available, returning cached data');
        return _cachedChangelogs;
      }

      // Query changelogs ordered by version descending (newest first)
      final querySnapshot = await collection
          .orderBy('version', descending: true)
          .get(GetOptions(source: source));

      final changelogs = querySnapshot.docs
          .map((doc) => ChangelogVersion.fromFirestore(doc))
          .where(
            (changelog) => changelog.hasEntries,
          ) // Only include versions with entries
          .toList();

      // Update cache
      _cachedChangelogs = changelogs;

      debugPrint('Fetched ${changelogs.length} changelogs from Firestore');
      return changelogs;
    } catch (e) {
      debugPrint('Error fetching changelogs: $e');

      // Try to return cached data on error
      if (_cachedChangelogs.isNotEmpty) {
        debugPrint('Returning cached changelogs due to error');
        return _cachedChangelogs;
      }

      // Return empty list if no cached data available
      return [];
    }
  }

  /// Fetch a specific changelog version
  Future<ChangelogVersion?> fetchChangelogVersion(String version) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Check cache first
    try {
      final cached = _cachedChangelogs.firstWhere(
        (changelog) => changelog.version == version,
      );
      return cached;
    } catch (e) {
      // Not found in cache, fetch from Firestore
    }

    try {
      final collection = _firestore?.collection('changelogs');
      if (collection == null) {
        return null;
      }

      final doc = await collection.doc(version).get();

      if (!doc.exists) {
        return null;
      }

      final changelog = ChangelogVersion.fromFirestore(doc);

      // Add to cache if not already present
      if (!_cachedChangelogs.any((c) => c.version == version)) {
        _cachedChangelogs.add(changelog);
        // Re-sort cache by version descending
        _cachedChangelogs.sort(
          (a, b) => VersionUtils.compareVersions(b.version, a.version),
        );
      }

      return changelog;
    } catch (e) {
      debugPrint('Error fetching changelog version $version: $e');
      return null;
    }
  }

  /// Get changelogs newer than a specific version
  Future<List<ChangelogVersion>> getChangelogsSince(String version) async {
    final allChangelogs = await fetchChangelogs();

    // Filter changelogs newer than the specified version
    // This assumes semantic versioning (e.g., "1.2.0")
    return allChangelogs.where((changelog) {
      return _compareVersions(changelog.version, version) > 0;
    }).toList();
  }

  /// Check if there are new changelogs since a specific version
  Future<bool> hasNewChangelogsSince(String version) async {
    final newChangelogs = await getChangelogsSince(version);
    return newChangelogs.isNotEmpty;
  }

  /// Fetch changelogs with fallback to specific versions
  ///
  /// This method combines the logic used in both home_screen.dart and settings_dialog.dart
  /// to fetch changelogs with fallback strategies.
  ///
  /// First tries to fetch all changelogs, then falls back to specific versions
  /// based on the current version if the bulk fetch returns empty results.
  Future<List<ChangelogVersion>> fetchChangelogsWithFallback({
    String? currentVersion,
    List<String>? fallbackVersions,
  }) async {
    try {
      // First, try to fetch all changelogs
      final allChangelogs = await fetchChangelogs();

      if (allChangelogs.isNotEmpty) {
        return allChangelogs;
      }

      // If no changelogs found, try fallback versions
      final List<String> versionsToTry =
          fallbackVersions ?? _generateFallbackVersions(currentVersion);

      List<ChangelogVersion> foundChangelogs = [];

      for (final version in versionsToTry) {
        final changelog = await fetchChangelogVersion(version);
        if (changelog != null) {
          foundChangelogs.add(changelog);
        }
      }

      // Sort by version descending (newest first)
      foundChangelogs.sort(
        (a, b) => VersionUtils.compareVersions(b.version, a.version),
      );

      return foundChangelogs;
    } catch (e) {
      debugPrint('Error in fetchChangelogsWithFallback: $e');
      return [];
    }
  }

  /// Generate fallback versions based on current version
  List<String> _generateFallbackVersions(String? currentVersion) {
    if (currentVersion == null || currentVersion.isEmpty) {
      // Default fallback versions if no current version provided
      return ['1.2.0', '1.1.0', '1.0.0'];
    }

    try {
      // Parse current version to get next minor version
      final versionParts = currentVersion.split('.');
      if (versionParts.length < 3) {
        return ['1.2.0', '1.1.0', '1.0.0'];
      }

      final major = int.tryParse(versionParts[0]);
      final minor = int.tryParse(versionParts[1]);

      if (major == null || minor == null) {
        return ['1.2.0', '1.1.0', '1.0.0'];
      }

      // Generate fallback versions similar to home_screen.dart logic
      final versionsToTry = [
        '$major.${minor + 1}.0', // Next minor version (highest priority)
        currentVersion, // Current version
        '$major.$minor.0', // Current minor version base
        '$major.${minor - 1}.0', // Previous minor version
        '1.0.0', // Always try 1.0.0 as final fallback
      ];

      // Remove duplicates while preserving order
      return versionsToTry.toSet().toList();
    } catch (e) {
      debugPrint('Error generating fallback versions: $e');
      return ['1.2.0', '1.1.0', '1.0.0'];
    }
  }

  /// Clear cached changelogs (useful for testing or refresh)
  void clearCache() {
    _cachedChangelogs.clear();
    debugPrint('Changelog cache cleared');
  }

  /// Refresh changelogs from server (bypassing cache)
  Future<List<ChangelogVersion>> refreshChangelogs() async {
    clearCache();
    return fetchChangelogs(useCache: false, source: Source.server);
  }

  /// Compare two version strings (basic semantic versioning comparison)
  /// Returns: -1 if version1 < version2, 0 if equal, 1 if version1 > version2
  int _compareVersions(String version1, String version2) {
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

    return 0; // Versions are equal
  }

  /// Mock method for testing (adds sample changelog data)
  Future<void> addMockChangelog(ChangelogVersion changelog) async {
    if (kDebugMode) {
      _cachedChangelogs.add(changelog);
      _cachedChangelogs.sort(
        (a, b) => VersionUtils.compareVersions(b.version, a.version),
      );
      debugPrint('Mock changelog added: ${changelog.version}');
    }
  }

  /// Upload a changelog to Firestore (admin function - for testing only)
  Future<void> uploadChangelog(ChangelogVersion changelog) async {
    if (!kDebugMode) {
      debugPrint('Upload only available in debug mode');
      return;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final collection = _firestore?.collection('changelogs');
      if (collection == null) {
        debugPrint('Firestore not available');
        return;
      }

      await collection.doc(changelog.version).set(changelog.toMap());
      debugPrint('Uploaded changelog for version ${changelog.version}');

      // Refresh cache
      await refreshChangelogs();
    } catch (e) {
      debugPrint('Error uploading changelog: $e');
    }
  }
}
