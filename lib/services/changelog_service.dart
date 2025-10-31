import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/models/changelog.dart';

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
        debugPrint('Firestore not available');
        return null;
      }

      final doc = await collection.doc(version).get();
      if (!doc.exists) {
        debugPrint('Changelog version $version not found');
        return null;
      }

      final changelog = ChangelogVersion.fromFirestore(doc);

      // Add to cache if not already present
      if (!_cachedChangelogs.any((c) => c.version == version)) {
        _cachedChangelogs.add(changelog);
        // Re-sort cache by version descending
        _cachedChangelogs.sort((a, b) => b.version.compareTo(a.version));
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
      _cachedChangelogs.sort((a, b) => b.version.compareTo(a.version));
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
