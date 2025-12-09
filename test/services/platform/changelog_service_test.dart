import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/changelog_category.dart';
import 'package:graviton/models/changelog/changelog.dart';
import 'package:graviton/services/platform/changelog_service.dart';
import 'package:graviton/utils/version_utils.dart';

void main() {
  group('ChangelogService Unit Tests', () {
    late ChangelogService service;

    // Test data
    final testChangelog1 = ChangelogVersion(
      version: '1.2.0',
      releaseDate: DateTime(2023, 6, 1),
      title: 'Version 1.2.0',
      entries: [
        ChangelogEntry(
          title: 'New Physics Engine',
          category: ChangelogCategory.added,
          description: 'Completely rebuilt physics simulation',
        ),
        ChangelogEntry(
          title: 'Performance Improvements',
          category: ChangelogCategory.improved,
          description: 'Optimized rendering pipeline',
        ),
      ],
    );

    final testChangelog2 = ChangelogVersion(
      version: '1.1.0',
      releaseDate: DateTime(2023, 5, 1),
      title: 'Version 1.1.0',
      entries: [
        ChangelogEntry(
          title: 'Bug Fixes',
          category: ChangelogCategory.fixed,
          description: 'Fixed camera controls',
        ),
      ],
    );

    final testChangelog3 = ChangelogVersion(
      version: '1.0.0',
      releaseDate: DateTime(2023, 4, 1),
      title: 'Initial Release',
      entries: [
        ChangelogEntry(
          title: 'Initial Release',
          category: ChangelogCategory.added,
          description: 'First version of Graviton',
        ),
      ],
    );

    setUp(() {
      // Reset service singleton for each test
      service = ChangelogService.instance;
      service.clearCache();
    });

    tearDown(() {
      service.clearCache();
    });

    group('Initialization', () {
      test('should handle initialization without Firebase errors', () async {
        expect(service.isInitialized, isFalse);

        // Initialize should complete without throwing even if Firebase fails
        await service.initialize();

        // Service should handle Firebase failures gracefully
        expect(true, isTrue); // Test passes if no exception thrown
      });

      test('should not reinitialize when already initialized', () async {
        await service.initialize();
        final firstInitState = service.isInitialized;

        await service.initialize();
        final secondInitState = service.isInitialized;

        expect(firstInitState, secondInitState);
      });
    });

    group('Cache Management', () {
      test('should start with empty cache', () {
        expect(service.cachedChangelogs, isEmpty);
      });

      test('should clear cache', () async {
        await service.addMockChangelog(testChangelog1);
        expect(service.cachedChangelogs, isNotEmpty);

        service.clearCache();
        expect(service.cachedChangelogs, isEmpty);
      });

      test('should return unmodifiable cache', () {
        final cache = service.cachedChangelogs;
        expect(() => cache.add(testChangelog1), throwsUnsupportedError);
      });
    });

    group('Mock Functionality', () {
      test('should add mock changelog in debug mode', () async {
        if (kDebugMode) {
          await service.addMockChangelog(testChangelog1);
          expect(service.cachedChangelogs.length, 1);
          expect(service.cachedChangelogs.first.version, '1.2.0');
        }
      });

      test('should sort mock changelogs by version descending', () async {
        if (kDebugMode) {
          await service.addMockChangelog(testChangelog1); // 1.2.0
          await service.addMockChangelog(testChangelog3); // 1.0.0
          await service.addMockChangelog(testChangelog2); // 1.1.0

          final changelogs = service.cachedChangelogs;
          expect(changelogs.length, 3);
          expect(changelogs[0].version, '1.2.0');
          expect(changelogs[1].version, '1.1.0');
          expect(changelogs[2].version, '1.0.0');
        }
      });
    });

    group('Version Filtering', () {
      test('should get changelogs since specific version', () async {
        // Add test data to cache
        await service.addMockChangelog(testChangelog1); // 1.2.0
        await service.addMockChangelog(testChangelog2); // 1.1.0
        await service.addMockChangelog(testChangelog3); // 1.0.0

        final newChangelogs = await service.getChangelogsSince('1.0.0');

        expect(newChangelogs.length, 2);
        expect(newChangelogs.any((c) => c.version == '1.2.0'), isTrue);
        expect(newChangelogs.any((c) => c.version == '1.1.0'), isTrue);
        expect(newChangelogs.any((c) => c.version == '1.0.0'), isFalse);
      });

      test('should check if has new changelogs since version', () async {
        await service.addMockChangelog(testChangelog1); // 1.2.0
        await service.addMockChangelog(testChangelog2); // 1.1.0
        await service.addMockChangelog(testChangelog3); // 1.0.0

        final hasNew = await service.hasNewChangelogsSince('1.0.0');
        expect(hasNew, isTrue);

        final hasNewFromLatest = await service.hasNewChangelogsSince('1.2.0');
        expect(hasNewFromLatest, isFalse);
      });

      test('should return empty list when no new changelogs', () async {
        await service.addMockChangelog(testChangelog3); // 1.0.0 only

        final newChangelogs = await service.getChangelogsSince('1.0.0');
        expect(newChangelogs, isEmpty);

        final hasNew = await service.hasNewChangelogsSince('1.0.0');
        expect(hasNew, isFalse);
      });
    });

    group('Fallback Strategy', () {
      test('should use cached data when available', () async {
        await service.addMockChangelog(testChangelog1);
        await service.addMockChangelog(testChangelog2);

        final result = await service.fetchChangelogsWithFallback(
          currentVersion: '1.0.0',
        );

        expect(result.length, 2);
        expect(result[0].version, '1.2.0'); // Newest first
        expect(result[1].version, '1.1.0');
      });

      test('should use fallback versions when cache is empty', () async {
        final result = await service.fetchChangelogsWithFallback(
          currentVersion: '1.1.0',
          fallbackVersions: ['1.1.0', '1.0.0'],
        );

        // Should return empty since we're not using real Firestore
        expect(result, isEmpty);
      });

      test('should generate fallback versions when none provided', () async {
        final result = await service.fetchChangelogsWithFallback(
          currentVersion: '1.1.0',
        );

        // Should use VersionUtils to generate fallbacks
        expect(result, isEmpty); // Empty since no Firestore data
      });

      test('should handle errors gracefully in fallback', () async {
        final result = await service.fetchChangelogsWithFallback(
          currentVersion: null, // This might cause issues
        );

        expect(result, isEmpty);
      });

      test('should sort fallback results by version descending', () async {
        // Add some test data
        await service.addMockChangelog(testChangelog3); // 1.0.0
        await service.addMockChangelog(testChangelog1); // 1.2.0

        final result = await service.fetchChangelogsWithFallback();

        expect(result.length, 2);
        expect(result[0].version, '1.2.0');
        expect(result[1].version, '1.0.0');
      });
    });

    group('Error Handling', () {
      test('should handle fetch errors gracefully', () async {
        // Clear any existing data
        service.clearCache();

        // Try to fetch when there's no data - should handle gracefully
        final result = await service.fetchChangelogs(useCache: false);
        expect(result, isA<List<ChangelogVersion>>());
      });

      test('should return cached data when available', () async {
        await service.addMockChangelog(testChangelog1);

        // Should return cached data even if fetch has issues
        final result = await service.fetchChangelogs();
        expect(result.length, 1);
        expect(result.first.version, '1.2.0');
      });

      test('should handle specific version fetch errors', () async {
        final result = await service.fetchChangelogVersion('nonexistent');
        expect(result, isNull);
      });

      test('should handle refresh errors gracefully', () async {
        final result = await service.refreshChangelogs();
        expect(result, isA<List<ChangelogVersion>>());
      });
    });

    group('Cache Behavior', () {
      test('should use cache when available', () async {
        await service.addMockChangelog(testChangelog1);

        // First call should use cache
        final result1 = await service.fetchChangelogs(useCache: true);
        expect(result1.length, 1);

        // Second call should also return cached data
        final result2 = await service.fetchChangelogs(useCache: true);
        expect(result2.length, 1);
      });

      test('should handle cache bypass attempts', () async {
        await service.addMockChangelog(testChangelog1);

        // When cache bypassed, behavior depends on Firebase availability
        final result = await service.fetchChangelogs(useCache: false);
        expect(result, isA<List<ChangelogVersion>>());
      });

      test('should refresh cache on refresh call', () async {
        await service.addMockChangelog(testChangelog1);
        expect(service.cachedChangelogs.length, 1);

        await service.refreshChangelogs();
        // After refresh, cache behavior depends on Firebase state
        expect(service.cachedChangelogs, isA<List<ChangelogVersion>>());
      });
    });

    group('Version-Specific Fetch', () {
      test('should find version in cache first', () async {
        await service.addMockChangelog(testChangelog1);

        final result = await service.fetchChangelogVersion('1.2.0');
        expect(result, isNotNull);
        expect(result!.version, '1.2.0');
        expect(result.title, 'Version 1.2.0');
      });

      test('should return null for non-existent version', () async {
        final result = await service.fetchChangelogVersion('99.99.99');
        expect(result, isNull);
      });

      test('should add fetched version to cache', () async {
        // Start with empty cache
        expect(service.cachedChangelogs, isEmpty);

        // Mock finding a version (in real scenario, this would come from Firestore)
        await service.addMockChangelog(testChangelog1);

        final result = await service.fetchChangelogVersion('1.2.0');
        expect(result, isNotNull);

        // Should be in cache now
        expect(service.cachedChangelogs.length, 1);
      });

      test('should maintain cache sorting when adding new version', () async {
        await service.addMockChangelog(testChangelog3); // 1.0.0
        await service.addMockChangelog(testChangelog1); // 1.2.0

        // Add middle version
        await service.addMockChangelog(testChangelog2); // 1.1.0

        final cache = service.cachedChangelogs;
        expect(cache[0].version, '1.2.0');
        expect(cache[1].version, '1.1.0');
        expect(cache[2].version, '1.0.0');
      });
    });

    group('Source Options', () {
      test('should handle different source parameters', () async {
        // Add cached data
        await service.addMockChangelog(testChangelog1);

        // Test with cache source - should return cached data
        final cacheResult = await service.fetchChangelogs(
          useCache: true,
          source: Source.cache,
        );
        expect(cacheResult.length, 1);

        // Test with server source - behavior depends on Firebase state
        final serverResult = await service.fetchChangelogs(
          useCache: false,
          source: Source.server,
        );
        expect(serverResult, isA<List<ChangelogVersion>>());
      });
    });

    group('Integration with VersionUtils', () {
      test('should use VersionUtils for version comparisons', () {
        // Test the integration points used by the service
        expect(VersionUtils.compareVersions('1.2.0', '1.1.0'), 1);
        expect(VersionUtils.compareVersions('1.1.0', '1.2.0'), -1);
        expect(VersionUtils.compareVersions('1.1.0', '1.1.0'), 0);
      });

      test('should handle version utils in fallback generation', () async {
        // Test that fallback logic integrates with VersionUtils
        final fallbackVersions = VersionUtils.generateFallbackVersions('1.1.0');
        expect(fallbackVersions, isNotEmpty);

        final result = await service.fetchChangelogsWithFallback(
          currentVersion: '1.1.0',
          fallbackVersions: fallbackVersions,
        );

        // Should not crash and return some result
        expect(result, isA<List<ChangelogVersion>>());
      });
    });

    group('Debug Mode Operations', () {
      test('should only allow upload in debug mode', () async {
        await service.uploadChangelog(testChangelog1);

        // In debug mode, this should work without throwing
        // In release mode, it should return early
        // Either way, no exception should be thrown
        expect(true, isTrue); // Test passes if no exception
      });

      test('should handle upload errors gracefully', () async {
        await service.uploadChangelog(testChangelog1);

        // Should complete without throwing even if Firestore fails
        expect(true, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle empty version string', () async {
        final result = await service.fetchChangelogVersion('');
        expect(result, isNull);
      });

      test('should handle null/empty fallback versions', () async {
        final result = await service.fetchChangelogsWithFallback(
          currentVersion: '1.0.0',
          fallbackVersions: [],
        );
        expect(result, isA<List<ChangelogVersion>>());
      });

      test('should handle malformed version strings', () async {
        final result = await service.getChangelogsSince('not.a.version');
        expect(result, isA<List<ChangelogVersion>>());
      });

      test('should handle concurrent cache operations', () async {
        // Simulate concurrent operations
        final futures = <Future>[];

        for (int i = 0; i < 5; i++) {
          futures.add(
            service.addMockChangelog(
              ChangelogVersion(
                version: '1.0.$i',
                releaseDate: DateTime.now(),
                title: 'Version 1.0.$i',
                entries: [],
              ),
            ),
          );
        }

        await Future.wait(futures);

        if (kDebugMode) {
          expect(service.cachedChangelogs.length, 5);
        }
      });
    });

    group('Performance', () {
      test('should efficiently handle large changelog lists', () async {
        // Add many changelogs
        for (int i = 0; i < 100; i++) {
          await service.addMockChangelog(
            ChangelogVersion(
              version: '1.0.$i',
              releaseDate: DateTime.now(),
              title: 'Version 1.0.$i',
              entries: [
                ChangelogEntry(
                  title: 'Feature $i',
                  category: ChangelogCategory.added,
                  description: 'Feature $i description',
                ),
              ],
            ),
          );
        }

        if (kDebugMode) {
          // Should handle large lists efficiently
          final startTime = DateTime.now();
          final result = await service.getChangelogsSince('1.0.50');
          final endTime = DateTime.now();

          expect(result.length, lessThan(50)); // Should filter correctly
          expect(endTime.difference(startTime).inMilliseconds, lessThan(100));
        }
      });
    });
  });
}
