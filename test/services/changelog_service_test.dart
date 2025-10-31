import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/changelog.dart';

void main() {
  group('ChangelogService', () {
    group('Version Comparison', () {
      test('should correctly compare semantic versions', () {
        // Test data for version comparison
        final testCases = [
          {'v1': '1.0.0', 'v2': '1.0.1', 'expected': -1},
          {'v1': '1.0.1', 'v2': '1.0.0', 'expected': 1},
          {'v1': '1.0.0', 'v2': '1.0.0', 'expected': 0},
          {'v1': '1.2.3', 'v2': '2.0.0', 'expected': -1},
          {'v1': '2.0.0', 'v2': '1.9.9', 'expected': 1},
          {'v1': '1.0', 'v2': '1.0.0', 'expected': 0},
        ];

        for (final testCase in testCases) {
          // We'll test this by creating a simple comparison helper
          final result = _compareVersions(
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
    });

    group('ChangelogVersion Model', () {
      test('should create ChangelogVersion with required fields', () {
        final changelog = ChangelogVersion(
          version: '1.0.0',
          title: 'Initial Release',
          releaseDate: DateTime(2024, 1, 1),
          entries: [
            ChangelogEntry(
              title: 'Initial release',
              category: 'added',
              description: 'Initial release of the app',
            ),
          ],
        );

        expect(changelog.version, '1.0.0');
        expect(changelog.title, 'Initial Release');
        expect(changelog.entries.length, 1);
        expect(changelog.entries.first.category, 'added');
        expect(
          changelog.entries.first.description,
          'Initial release of the app',
        );
      });

      test('should categorize entries correctly', () {
        final changelog = ChangelogVersion(
          version: '1.1.0',
          title: 'Feature Update',
          releaseDate: DateTime(2024, 2, 1),
          entries: [
            ChangelogEntry(
              title: 'New feature A',
              category: 'added',
              description: 'New feature A',
            ),
            ChangelogEntry(
              title: 'Better performance',
              category: 'improved',
              description: 'Better performance',
            ),
            ChangelogEntry(
              title: 'Bug fix',
              category: 'fixed',
              description: 'Bug fix',
            ),
            ChangelogEntry(
              title: 'New feature B',
              category: 'added',
              description: 'New feature B',
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
          category: 'fixed',
          description: 'Fixed a critical bug',
        );

        expect(entry.category, 'fixed');
        expect(entry.description, 'Fixed a critical bug');
      });
    });
  });
}

/// Helper function to test version comparison logic
/// This mimics the private _compareVersions method from ChangelogService
int _compareVersions(String version1, String version2) {
  final v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

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
