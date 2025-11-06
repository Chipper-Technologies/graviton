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

      return changelogs;
    } catch (e) {
      // Try to return cached data on error
      if (_cachedChangelogs.isNotEmpty) {
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
      return null;
    }
  }

  /// Get changelogs newer than a specific version
  Future<List<ChangelogVersion>> getChangelogsSince(String version) async {
    final allChangelogs = await fetchChangelogs();

    // Filter changelogs newer than the specified version
    // This assumes semantic versioning (e.g., "1.2.0")
    return allChangelogs.where((changelog) {
      return VersionUtils.compareVersions(changelog.version, version) > 0;
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
          fallbackVersions ??
          VersionUtils.generateFallbackVersions(currentVersion);

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
      return [];
    }
  }

  /// Clear cached changelogs (useful for testing or refresh)
  void clearCache() {
    _cachedChangelogs.clear();
  }

  /// Refresh changelogs from server (bypassing cache)
  Future<List<ChangelogVersion>> refreshChangelogs() async {
    clearCache();
    return fetchChangelogs(useCache: false, source: Source.server);
  }

  /// Mock method for testing (adds sample changelog data)
  Future<void> addMockChangelog(ChangelogVersion changelog) async {
    if (kDebugMode) {
      _cachedChangelogs.add(changelog);
      _cachedChangelogs.sort(
        (a, b) => VersionUtils.compareVersions(b.version, a.version),
      );
    }
  }

  /// Upload a changelog to Firestore (admin function - for testing only)
  Future<void> uploadChangelog(ChangelogVersion changelog) async {
    if (!kDebugMode) {
      return;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final collection = _firestore?.collection('changelogs');
      if (collection == null) {
        return;
      }

      await collection.doc(changelog.version).set(changelog.toMap());

      // Refresh cache
      await refreshChangelogs();
    } catch (e) {
      debugPrint('Error uploading changelog: $e');
    }
  }
}
