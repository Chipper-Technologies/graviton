import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/changelog_category.dart';
import 'package:graviton/models/changelog_entry.dart';

void main() {
  group('ChangelogCategory Enum Tests', () {
    test('should create enum from string values', () {
      expect(ChangelogCategory.fromString('added'), ChangelogCategory.added);
      expect(
        ChangelogCategory.fromString('improved'),
        ChangelogCategory.improved,
      );
      expect(ChangelogCategory.fromString('fixed'), ChangelogCategory.fixed);
      expect(
        ChangelogCategory.fromString('invalid'),
        ChangelogCategory.added,
      ); // Default fallback
      expect(
        ChangelogCategory.fromString(null),
        ChangelogCategory.added,
      ); // Null fallback
    });

    test('should have correct string values', () {
      expect(ChangelogCategory.added.value, 'added');
      expect(ChangelogCategory.improved.value, 'improved');
      expect(ChangelogCategory.fixed.value, 'fixed');
    });

    test('should have correct display names', () {
      expect(ChangelogCategory.added.displayName, 'Added');
      expect(ChangelogCategory.improved.displayName, 'Improved');
      expect(ChangelogCategory.fixed.displayName, 'Fixed');
    });

    test('should work with ChangelogEntry model', () {
      final entry = ChangelogEntry(
        title: 'Test Feature',
        description: 'A test feature',
        category: ChangelogCategory.added,
      );

      expect(entry.category, ChangelogCategory.added);

      // Test serialization
      final map = entry.toMap();
      expect(map['category'], 'added');

      // Test deserialization
      final entryFromMap = ChangelogEntry.fromMap(map);
      expect(entryFromMap.category, ChangelogCategory.added);
    });

    test('should handle invalid category in fromMap gracefully', () {
      final map = {
        'title': 'Test',
        'description': 'Test description',
        'category': 'invalid_category',
      };

      final entry = ChangelogEntry.fromMap(map);
      expect(
        entry.category,
        ChangelogCategory.added,
      ); // Should default to 'added'
    });
  });
}
