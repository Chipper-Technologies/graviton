import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/version_status.dart';

void main() {
  group('VersionStatus Enum', () {
    test('should have all expected version statuses', () {
      expect(VersionStatus.values.length, equals(3));
      expect(VersionStatus.values, contains(VersionStatus.current));
      expect(VersionStatus.values, contains(VersionStatus.beta));
      expect(VersionStatus.values, contains(VersionStatus.outdated));
    });

    test('should cover all version scenarios', () {
      // Should have current/up-to-date status
      expect(
        VersionStatus.values,
        contains(VersionStatus.current),
        reason: 'Should have status for current/up-to-date versions',
      );

      // Should have beta/pre-release status
      expect(
        VersionStatus.values,
        contains(VersionStatus.beta),
        reason: 'Should have status for beta/pre-release versions',
      );

      // Should have outdated status
      expect(
        VersionStatus.values,
        contains(VersionStatus.outdated),
        reason: 'Should have status for outdated versions',
      );
    });

    test('should have semantic naming', () {
      // Names should be clear and descriptive
      expect(VersionStatus.current.name, equals('current'));
      expect(VersionStatus.beta.name, equals('beta'));
      expect(VersionStatus.outdated.name, equals('outdated'));
    });

    test('should be minimal but comprehensive', () {
      // Should have exactly the essential statuses
      expect(
        VersionStatus.values.length,
        equals(3),
        reason: 'Should have exactly three essential version statuses',
      );

      // Should not have redundant statuses
      final uniqueNames = VersionStatus.values
          .map((status) => status.name)
          .toSet();
      expect(
        uniqueNames.length,
        equals(VersionStatus.values.length),
        reason: 'All version statuses should have unique names',
      );
    });

    test('should follow enum naming conventions', () {
      for (final status in VersionStatus.values) {
        // Should use camelCase
        expect(
          status.name,
          matches(RegExp(r'^[a-z][a-zA-Z]*$')),
          reason: '${status.name} should follow camelCase convention',
        );

        // Should be single words or compound words
        expect(
          status.name,
          isNot(contains('_')),
          reason: '${status.name} should not contain underscores',
        );
        expect(
          status.name,
          isNot(contains('-')),
          reason: '${status.name} should not contain hyphens',
        );
      }
    });
  });
}
