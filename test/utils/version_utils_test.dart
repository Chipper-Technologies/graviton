import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/version_utils.dart';

void main() {
  group('VersionUtils', () {
    group('compareVersions', () {
      test('should correctly compare semantic versions', () {
        final testCases = [
          {'v1': '1.0.0', 'v2': '1.0.1', 'expected': -1},
          {'v1': '1.0.1', 'v2': '1.0.0', 'expected': 1},
          {'v1': '1.0.0', 'v2': '1.0.0', 'expected': 0},
          {'v1': '1.2.3', 'v2': '2.0.0', 'expected': -1},
          {'v1': '2.0.0', 'v2': '1.9.9', 'expected': 1},
          {'v1': '1.0', 'v2': '1.0.0', 'expected': 0},
          {'v1': '0.9.9', 'v2': '1.0.0', 'expected': -1},
          {'v1': '10.0.0', 'v2': '2.0.0', 'expected': 1},
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

      test('should handle malformed versions gracefully', () {
        expect(VersionUtils.compareVersions('1.a.0', '1.0.0'), 0);
        expect(VersionUtils.compareVersions('invalid', '1.0.0'), -1);
        expect(VersionUtils.compareVersions('1.0.0', 'invalid'), 1);
        expect(VersionUtils.compareVersions('', '1.0.0'), -1);
      });
    });

    group('getNextMinorVersion', () {
      test('should calculate next minor version correctly', () {
        final testCases = [
          {'current': '1.0.0', 'next': '1.1.0'},
          {'current': '1.0.5', 'next': '1.1.0'},
          {'current': '1.1.0', 'next': '1.2.0'},
          {'current': '1.1.1', 'next': '1.2.0'},
          {'current': '1.1.9', 'next': '1.2.0'},
          {'current': '2.0.0', 'next': '2.1.0'},
          {'current': '2.5.3', 'next': '2.6.0'},
          {'current': '10.15.7', 'next': '10.16.0'},
          {'current': '0.0.0', 'next': '0.1.0'},
          {'current': '999.999.999', 'next': '999.1000.0'},
        ];

        for (final testCase in testCases) {
          final current = testCase['current'] as String;
          final expected = testCase['next'] as String;
          final result = VersionUtils.getNextMinorVersion(current);

          expect(
            result,
            expected,
            reason:
                'Version $current should map to next minor version $expected',
          );
        }
      });

      test('should handle invalid version formats', () {
        final invalidCases = [
          {'input': '', 'fallback': '1.1.0'},
          {'input': 'invalid', 'fallback': '1.1.0'},
          {'input': '1', 'fallback': '1.1.0'},
          {'input': '1.', 'fallback': '1.1.0'},
          {'input': '1.a.0', 'fallback': '1.1.0'},
          {'input': 'v1.0.0', 'fallback': '1.1.0'},
          {'input': '1.0.0-beta', 'fallback': '1.1.0'},
        ];

        for (final testCase in invalidCases) {
          final input = testCase['input'] as String;
          final expected = testCase['fallback'] as String;
          final result = VersionUtils.getNextMinorVersion(input);

          expect(
            result,
            expected,
            reason: 'Invalid version "$input" should fallback to $expected',
          );
        }
      });

      test('should handle edge cases', () {
        expect(VersionUtils.getNextMinorVersion('1.0'), '1.1.0');
        expect(VersionUtils.getNextMinorVersion('999.0.0'), '999.1.0');
        expect(VersionUtils.getNextMinorVersion('0.999.0'), '0.1000.0');
      });
    });

    group('parseVersion', () {
      test('should parse valid semantic versions', () {
        final testCases = [
          {
            'version': '1.2.3',
            'expected': {'major': 1, 'minor': 2, 'patch': 3},
          },
          {
            'version': '0.0.0',
            'expected': {'major': 0, 'minor': 0, 'patch': 0},
          },
          {
            'version': '10.20.30',
            'expected': {'major': 10, 'minor': 20, 'patch': 30},
          },
          {
            'version': '1.0',
            'expected': {'major': 1, 'minor': 0, 'patch': 0},
          },
        ];

        for (final testCase in testCases) {
          final version = testCase['version'] as String;
          final expected = testCase['expected'] as Map<String, int>;
          final result = VersionUtils.parseVersion(version);

          expect(
            result,
            expected,
            reason: 'Parsing $version should return $expected',
          );
        }
      });

      test('should handle invalid versions', () {
        final invalidCases = ['invalid', '', '1.a.0', 'v1.0.0', '1.0.0-beta'];

        for (final invalid in invalidCases) {
          final result = VersionUtils.parseVersion(invalid);
          expect(
            result,
            {'major': 0, 'minor': 0, 'patch': 0},
            reason: 'Invalid version "$invalid" should return zero version',
          );
        }
      });
    });

    group('isValidVersion', () {
      test('should identify valid versions', () {
        final validVersions = [
          '1.0.0',
          '0.0.0',
          '999.999.999',
          '1.0',
          '10.20',
          '1.2.3',
        ];

        for (final version in validVersions) {
          expect(
            VersionUtils.isValidVersion(version),
            true,
            reason: '$version should be considered valid',
          );
        }
      });

      test('should identify invalid versions', () {
        final invalidVersions = [
          '',
          'invalid',
          '1',
          '1.',
          '1.a.0',
          'v1.0.0',
          '1.0.0-beta',
          '1.0.0.0',
          'a.b.c',
          '1..0',
        ];

        for (final version in invalidVersions) {
          expect(
            VersionUtils.isValidVersion(version),
            false,
            reason: '$version should be considered invalid',
          );
        }
      });
    });

    group('normalizeVersion', () {
      test('should normalize valid versions', () {
        final testCases = [
          {'input': '1.0', 'expected': '1.0.0'},
          {'input': '1.2', 'expected': '1.2.0'},
          {'input': '1.0.0', 'expected': '1.0.0'},
          {'input': '10.20', 'expected': '10.20.0'},
        ];

        for (final testCase in testCases) {
          final input = testCase['input'] as String;
          final expected = testCase['expected'] as String;
          final result = VersionUtils.normalizeVersion(input);

          expect(
            result,
            expected,
            reason: 'Normalizing $input should return $expected',
          );
        }
      });

      test('should handle invalid versions', () {
        final invalidVersions = ['', 'invalid', '1', '1.a.0', 'v1.0.0'];

        for (final version in invalidVersions) {
          final result = VersionUtils.normalizeVersion(version);
          expect(
            result,
            '0.0.0',
            reason: 'Invalid version "$version" should normalize to 0.0.0',
          );
        }
      });
    });

    group('Integration Tests', () {
      test('should work together for version lookup logic', () {
        const currentVersion = '1.1.1';

        // Parse current version
        final parsed = VersionUtils.parseVersion(currentVersion);
        expect(parsed['major'], 1);
        expect(parsed['minor'], 1);
        expect(parsed['patch'], 1);

        // Calculate next minor version
        final nextMinor = VersionUtils.getNextMinorVersion(currentVersion);
        expect(nextMinor, '1.2.0');

        // Verify comparison logic
        expect(VersionUtils.compareVersions(currentVersion, nextMinor), -1);
        expect(VersionUtils.compareVersions(nextMinor, currentVersion), 1);
        expect(VersionUtils.compareVersions(currentVersion, currentVersion), 0);

        // Verify validation
        expect(VersionUtils.isValidVersion(currentVersion), true);
        expect(VersionUtils.isValidVersion(nextMinor), true);

        // Verify normalization
        expect(VersionUtils.normalizeVersion(currentVersion), currentVersion);
        expect(VersionUtils.normalizeVersion(nextMinor), nextMinor);
      });

      test('should handle changelog lookup priority scenario', () {
        const currentVersion = '1.1.1';
        const exactMatch = '1.1.1';
        final nextMinor = VersionUtils.getNextMinorVersion(currentVersion);

        // Simulate lookup order: exact match first, then next minor
        final lookupOrder = [exactMatch, nextMinor];
        expect(lookupOrder, ['1.1.1', '1.2.0']);

        // Verify that exact match has priority (same version = 0)
        expect(VersionUtils.compareVersions(currentVersion, exactMatch), 0);
        expect(VersionUtils.compareVersions(currentVersion, nextMinor), -1);
      });
    });
  });
}
