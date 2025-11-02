import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/changelog_category.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/utils/version_utils.dart';

void main() {
  group('ChangelogService', () {
    group('Version Integration', () {
      test('should use VersionUtils for comparison operations', () {
        // Test that the service integrates properly with VersionUtils
        final testCases = [
          {'v1': '1.0.0', 'v2': '1.0.1', 'expected': -1},
          {'v1': '1.0.1', 'v2': '1.0.0', 'expected': 1},
          {'v1': '1.0.0', 'v2': '1.0.0', 'expected': 0},
          {'v1': '1.2.3', 'v2': '2.0.0', 'expected': -1},
          {'v1': '2.0.0', 'v2': '1.9.9', 'expected': 1},
        ];

        for (final testCase in testCases) {
          final result = VersionUtils.compareVersions(
            testCase['v1'] as String,
            testCase['v2'] as String,
          );
          expect(
            result,
            testCase['expected'],
            reason: 'Comparing ${testCase['v1']} with ${testCase['v2']}',
          );
        }
      });

      test('should demonstrate version lookup priority logic', () {
        const currentVersion = '1.1.1';
        final exactMatch = currentVersion;
        final nextMinor = VersionUtils.getNextMinorVersion(currentVersion);

        expect(nextMinor, '1.2.0');

        // In real implementation, we'd prefer exactMatch if it exists
        final lookupOrder = [exactMatch, nextMinor];
        expect(lookupOrder, ['1.1.1', '1.2.0']);

        // Verify comparison logic works as expected
        expect(VersionUtils.compareVersions(currentVersion, exactMatch), 0);
        expect(VersionUtils.compareVersions(currentVersion, nextMinor), -1);
      });
    });

    group('ChangelogVersion Model', () {
      test('should create ChangelogVersion with required fields', () {
        final changelogVersion = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 1, 1),
          title: 'Version 1.0.0',
          entries: [
            ChangelogEntry(
              title: 'Test feature',
              category: ChangelogCategory.added,
              description: 'Added a test feature',
            ),
          ],
        );

        expect(changelogVersion.version, '1.0.0');
        expect(changelogVersion.releaseDate, DateTime(2023, 1, 1));
        expect(changelogVersion.title, 'Version 1.0.0');
        expect(changelogVersion.entries.length, 1);
        expect(changelogVersion.entries.first.title, 'Test feature');
      });

      test('should categorize entries correctly', () {
        final changelog = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 1, 1),
          title: 'Version 1.0.0',
          entries: [
            ChangelogEntry(
              title: 'New feature A',
              category: ChangelogCategory.added,
              description: 'New feature A',
            ),
            ChangelogEntry(
              title: 'New feature B',
              category: ChangelogCategory.added,
              description: 'New feature B',
            ),
            ChangelogEntry(
              title: 'Better performance',
              category: ChangelogCategory.improved,
              description: 'Better performance',
            ),
            ChangelogEntry(
              title: 'Bug fix',
              category: ChangelogCategory.fixed,
              description: 'Bug fix',
            ),
          ],
        );

        final addedFeatures = changelog.addedFeatures;
        final improvements = changelog.improvements;
        final fixes = changelog.fixes;

        expect(addedFeatures.length, 2);
        expect(improvements.length, 1);
        expect(fixes.length, 1);

        expect(addedFeatures[0].description, 'New feature A');
        expect(addedFeatures[1].description, 'New feature B');
        expect(improvements[0].description, 'Better performance');
        expect(fixes[0].description, 'Bug fix');
      });
    });

    group('Changelog Entry Model', () {
      test('should create ChangelogEntry with category and description', () {
        final entry = ChangelogEntry(
          title: 'Fixed a critical bug',
          category: ChangelogCategory.fixed,
          description: 'Fixed a critical bug',
        );

        expect(entry.category, ChangelogCategory.fixed);
        expect(entry.description, 'Fixed a critical bug');
      });
    });
  });
}
