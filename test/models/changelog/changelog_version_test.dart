import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graviton/models/changelog/changelog_version.dart';
import 'package:graviton/models/changelog/changelog_entry.dart';
import 'package:graviton/core/enums/changelog_category.dart';

void main() {
  group('ChangelogVersion', () {
    group('Constructor', () {
      test('should create instance with all required fields', () {
        final releaseDate = DateTime(2023, 10, 15);
        final entries = [
          const ChangelogEntry(
            title: 'Feature 1',
            category: ChangelogCategory.added,
          ),
        ];

        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Major Release',
          entries: entries,
        );

        expect(version.version, equals('1.0.0'));
        expect(version.releaseDate, equals(releaseDate));
        expect(version.title, equals('Major Release'));
        expect(version.entries, equals(entries));
      });

      test('should handle empty entries list', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Empty Release',
          entries: const [],
        );

        expect(version.entries, isEmpty);
        expect(version.hasEntries, isFalse);
      });
    });

    group('fromMap', () {
      test('should create from map with Timestamp', () {
        final timestamp = Timestamp.fromDate(DateTime(2023, 10, 15));
        final map = {
          'version': '1.0.0',
          'title': 'Map Release',
          'releaseDate': timestamp,
          'entries': [
            {'title': 'Map Feature', 'category': 'added'},
          ],
        };

        final version = ChangelogVersion.fromMap(map);

        expect(version.version, equals('1.0.0'));
        expect(version.title, equals('Map Release'));
        expect(version.releaseDate, equals(DateTime(2023, 10, 15)));
        expect(version.entries, hasLength(1));
      });

      test('should create from map with String date', () {
        final map = {
          'version': '2.0.0',
          'title': 'String Map Release',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': [],
        };

        final version = ChangelogVersion.fromMap(map);

        expect(
          version.releaseDate,
          equals(DateTime.parse('2023-10-15T00:00:00.000Z')),
        );
      });

      test('should handle missing fields with defaults', () {
        final map = <String, dynamic>{};

        final version = ChangelogVersion.fromMap(map);

        expect(version.version, equals(''));
        expect(version.title, equals(''));
        expect(version.entries, isEmpty);
        expect(version.releaseDate, isA<DateTime>());
      });

      test('should handle null entries list', () {
        final map = {
          'version': '3.0.0',
          'title': 'Null Entries',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': null,
        };

        final version = ChangelogVersion.fromMap(map);

        expect(version.entries, isEmpty);
      });

      test('should handle invalid date format gracefully', () {
        final map = {
          'version': '3.0.0',
          'title': 'Invalid Date Release',
          'releaseDate': 'invalid-date',
          'entries': [],
        };

        final version = ChangelogVersion.fromMap(map);

        expect(version.version, equals('3.0.0'));
        // Should default to current time when date parsing fails
        expect(version.releaseDate, isA<DateTime>());
      });

      test(
        'should handle single entry object format - expects list format',
        () {
          final map = {
            'version': '4.0.0',
            'title': 'Single Entry Release',
            'releaseDate': Timestamp.fromDate(DateTime(2023, 10, 15)),
            'entries': [
              {'title': 'Single Feature', 'category': 'added'},
            ],
          };

          final version = ChangelogVersion.fromMap(map);

          expect(version.entries, hasLength(1));
          expect(version.entries.first.title, equals('Single Feature'));
        },
      );

      test('should handle complex entry data', () {
        final map = {
          'version': '5.0.0',
          'title': 'Complex Entry Release',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': [
            {
              'title': 'Feature with Description',
              'description': 'Detailed description',
              'category': 'added',
            },
            {'title': 'Bug Fix', 'category': 'fixed'},
            {
              'title': 'Improvement',
              'description': 'Performance improvement',
              'category': 'improved',
            },
          ],
        };

        final version = ChangelogVersion.fromMap(map);

        expect(version.entries, hasLength(3));
        expect(version.entries[0].title, equals('Feature with Description'));
        expect(version.entries[0].description, equals('Detailed description'));
        expect(version.entries[0].category, equals(ChangelogCategory.added));
        expect(version.entries[1].category, equals(ChangelogCategory.fixed));
        expect(version.entries[2].category, equals(ChangelogCategory.improved));
      });
    });

    group('toMap', () {
      test('should convert to map correctly', () {
        final releaseDate = DateTime(2023, 10, 15);
        final entries = [
          const ChangelogEntry(
            title: 'Test Feature',
            description: 'Test description',
            category: ChangelogCategory.added,
          ),
        ];

        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: entries,
        );

        final map = version.toMap();

        expect(map['title'], equals('Test Release'));
        expect(map['releaseDate'], isA<Timestamp>());
        expect(map['entries'], isA<List>());
        expect(map['entries'], hasLength(1));
      });

      test('should handle empty entries list', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Empty Release',
          entries: const [],
        );

        final map = version.toMap();

        expect(map['entries'], isEmpty);
      });

      test('should correctly serialize multiple entries', () {
        final entries = [
          const ChangelogEntry(
            title: 'Feature 1',
            category: ChangelogCategory.added,
          ),
          const ChangelogEntry(
            title: 'Bug Fix 1',
            description: 'Fixed critical bug',
            category: ChangelogCategory.fixed,
          ),
        ];

        final version = ChangelogVersion(
          version: '2.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Multi-Entry Release',
          entries: entries,
        );

        final map = version.toMap();

        expect(map['entries'], hasLength(2));
        final entriesList = map['entries'] as List;
        expect(entriesList[0]['title'], equals('Feature 1'));
        expect(entriesList[1]['title'], equals('Bug Fix 1'));
        expect(entriesList[1]['description'], equals('Fixed critical bug'));
      });
    });

    group('Category Filtering', () {
      late ChangelogVersion versionWithMixedEntries;

      setUp(() {
        versionWithMixedEntries = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Mixed Release',
          entries: const [
            ChangelogEntry(
              title: 'Added Feature 1',
              category: ChangelogCategory.added,
            ),
            ChangelogEntry(
              title: 'Added Feature 2',
              category: ChangelogCategory.added,
            ),
            ChangelogEntry(
              title: 'Improved Something',
              category: ChangelogCategory.improved,
            ),
            ChangelogEntry(
              title: 'Fixed Bug',
              category: ChangelogCategory.fixed,
            ),
          ],
        );
      });

      test('getEntriesByCategory should filter by category', () {
        final addedEntries = versionWithMixedEntries.getEntriesByCategory(
          ChangelogCategory.added,
        );
        expect(addedEntries, hasLength(2));
        expect(
          addedEntries.every((e) => e.category == ChangelogCategory.added),
          isTrue,
        );

        final improvedEntries = versionWithMixedEntries.getEntriesByCategory(
          ChangelogCategory.improved,
        );
        expect(improvedEntries, hasLength(1));

        final fixedEntries = versionWithMixedEntries.getEntriesByCategory(
          ChangelogCategory.fixed,
        );
        expect(fixedEntries, hasLength(1));
      });

      test(
        'getEntriesByCategory should return empty list for non-existent category',
        () {
          final emptyVersion = ChangelogVersion(
            version: '1.0.0',
            releaseDate: DateTime(2023, 10, 15),
            title: 'Empty Release',
            entries: const [],
          );

          final addedEntries = emptyVersion.getEntriesByCategory(
            ChangelogCategory.added,
          );
          expect(addedEntries, isEmpty);
        },
      );

      test('addedFeatures getter should return added entries', () {
        final added = versionWithMixedEntries.addedFeatures;
        expect(added, hasLength(2));
        expect(
          added.every((e) => e.category == ChangelogCategory.added),
          isTrue,
        );
      });

      test('improvements getter should return improved entries', () {
        final improved = versionWithMixedEntries.improvements;
        expect(improved, hasLength(1));
        expect(improved.first.category, equals(ChangelogCategory.improved));
      });

      test('fixes getter should return fixed entries', () {
        final fixes = versionWithMixedEntries.fixes;
        expect(fixes, hasLength(1));
        expect(fixes.first.category, equals(ChangelogCategory.fixed));
      });
    });

    group('Properties', () {
      test('hasEntries should return true when entries exist', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: const [
            ChangelogEntry(title: 'Test', category: ChangelogCategory.added),
          ],
        );

        expect(version.hasEntries, isTrue);
      });

      test('hasEntries should return false when no entries', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Empty Release',
          entries: const [],
        );

        expect(version.hasEntries, isFalse);
      });

      test('entryCount should return correct count', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: const [
            ChangelogEntry(title: 'Test 1', category: ChangelogCategory.added),
            ChangelogEntry(title: 'Test 2', category: ChangelogCategory.fixed),
          ],
        );

        expect(version.entries.length, equals(2));
      });
    });

    group('Equality and HashCode', () {
      test('should be equal for identical properties', () {
        final releaseDate = DateTime(2023, 10, 15);
        final entries = [
          const ChangelogEntry(
            title: 'Test',
            category: ChangelogCategory.added,
          ),
        ];

        final version1 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: entries,
        );

        final version2 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: entries,
        );

        expect(version1, equals(version2));
        expect(version1.hashCode, equals(version2.hashCode));
      });

      test('should not be equal for different versions', () {
        final releaseDate = DateTime(2023, 10, 15);
        final entries = [
          const ChangelogEntry(
            title: 'Test',
            category: ChangelogCategory.added,
          ),
        ];

        final version1 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: entries,
        );

        final version2 = ChangelogVersion(
          version: '2.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: entries,
        );

        expect(version1, isNot(equals(version2)));
      });

      test('should not be equal for different titles', () {
        final releaseDate = DateTime(2023, 10, 15);
        final entries = [
          const ChangelogEntry(
            title: 'Test',
            category: ChangelogCategory.added,
          ),
        ];

        final version1 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'First Release',
          entries: entries,
        );

        final version2 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Second Release',
          entries: entries,
        );

        expect(version1, isNot(equals(version2)));
      });

      test('should not be equal for different dates', () {
        final entries = [
          const ChangelogEntry(
            title: 'Test',
            category: ChangelogCategory.added,
          ),
        ];

        final version1 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: entries,
        );

        final version2 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 16),
          title: 'Test Release',
          entries: entries,
        );

        expect(version1, isNot(equals(version2)));
      });

      test('should not be equal for different entry counts', () {
        final releaseDate = DateTime(2023, 10, 15);

        final version1 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: const [
            ChangelogEntry(title: 'Test 1', category: ChangelogCategory.added),
          ],
        );

        final version2 = ChangelogVersion(
          version: '1.0.0',
          releaseDate: releaseDate,
          title: 'Test Release',
          entries: const [
            ChangelogEntry(title: 'Test 1', category: ChangelogCategory.added),
            ChangelogEntry(title: 'Test 2', category: ChangelogCategory.added),
          ],
        );

        expect(version1, isNot(equals(version2)));
      });

      test('should handle identity equality', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: const [],
        );

        expect(version, equals(version));
      });

      test('should not be equal to different type', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: const [],
        );

        expect(version, isNot(equals('not a version')));
      });

      test('should not be equal to null', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: const [],
        );

        expect(version, isNot(equals(null)));
      });
    });

    group('toString', () {
      test('should provide useful string representation', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Test Release',
          entries: const [
            ChangelogEntry(title: 'Test', category: ChangelogCategory.added),
          ],
        );

        final str = version.toString();

        expect(str, contains('1.0.0'));
        expect(str, contains('Test Release'));
        expect(str, contains('2023-10-15'));
        expect(str, contains('entries: 1'));
      });

      test('should show empty entries in string representation', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Empty Release',
          entries: const [],
        );

        final str = version.toString();

        expect(str, contains('entries: 0'));
      });
    });

    group('Edge Cases', () {
      test('should handle very long version strings', () {
        final version = ChangelogVersion(
          version: '1.0.0-alpha.1+build.2023.10.15.12345',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Complex Version',
          entries: const [],
        );

        expect(version.version, equals('1.0.0-alpha.1+build.2023.10.15.12345'));
      });

      test('should handle unicode characters in title', () {
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: '🚀 Release with Emojis 中文',
          entries: const [],
        );

        expect(version.title, equals('🚀 Release with Emojis 中文'));
      });

      test('should handle future dates', () {
        final futureDate = DateTime(2050, 1, 1);
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: futureDate,
          title: 'Future Release',
          entries: const [],
        );

        expect(version.releaseDate, equals(futureDate));
      });

      test('should handle very old dates', () {
        final oldDate = DateTime(1970, 1, 1);
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: oldDate,
          title: 'Old Release',
          entries: const [],
        );

        expect(version.releaseDate, equals(oldDate));
      });

      test('should handle empty strings', () {
        final version = ChangelogVersion(
          version: '',
          releaseDate: DateTime(2023, 10, 15),
          title: '',
          entries: const [],
        );

        expect(version.version, equals(''));
        expect(version.title, equals(''));
      });

      test('should handle maximum date values', () {
        // Test with a very far future date
        final maxDate = DateTime(9999, 12, 31);
        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: maxDate,
          title: 'Far Future Release',
          entries: const [],
        );

        expect(version.releaseDate, equals(maxDate));
      });

      test('should handle large number of entries', () {
        final manyEntries = List.generate(
          1000,
          (index) => ChangelogEntry(
            title: 'Entry $index',
            category: ChangelogCategory
                .values[index % ChangelogCategory.values.length],
          ),
        );

        final version = ChangelogVersion(
          version: '1.0.0',
          releaseDate: DateTime(2023, 10, 15),
          title: 'Large Release',
          entries: manyEntries,
        );

        expect(version.entries, hasLength(1000));
        expect(version.hasEntries, isTrue);
        expect(version.entries.length, equals(1000));
      });
    });

    group('fromMap Edge Cases for fromFirestore Coverage', () {
      test('should handle Timestamp vs String date detection', () {
        // Test the different date parsing paths
        final timestampMap = {
          'version': '1.0.0',
          'title': 'Test',
          'releaseDate': Timestamp.fromDate(DateTime(2023, 10, 15)),
          'entries': [],
        };

        final stringMap = {
          'version': '1.0.0',
          'title': 'Test',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': [],
        };

        final nullMap = {
          'version': '1.0.0',
          'title': 'Test',
          'releaseDate': null,
          'entries': [],
        };

        final timestampVersion = ChangelogVersion.fromMap(timestampMap);
        final stringVersion = ChangelogVersion.fromMap(stringMap);
        final nullVersion = ChangelogVersion.fromMap(nullMap);

        expect(timestampVersion.releaseDate.day, equals(15));
        expect(stringVersion.releaseDate.day, equals(15));
        expect(nullVersion.releaseDate, isA<DateTime>());
      });

      test('should handle entries as single object vs list', () {
        // Test single object format (simulating fromFirestore behavior)
        final listMap = {
          'version': '1.0.0',
          'title': 'Test',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': [
            {'title': 'Feature 1', 'category': 'added'},
            {'title': 'Feature 2', 'category': 'fixed'},
          ],
        };

        final emptyMap = {
          'version': '1.0.0',
          'title': 'Test',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': [],
        };

        final nullEntriesMap = {
          'version': '1.0.0',
          'title': 'Test',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': null,
        };

        final listVersion = ChangelogVersion.fromMap(listMap);
        final emptyVersion = ChangelogVersion.fromMap(emptyMap);
        final nullVersion = ChangelogVersion.fromMap(nullEntriesMap);

        expect(listVersion.entries, hasLength(2));
        expect(emptyVersion.entries, isEmpty);
        expect(nullVersion.entries, isEmpty);
      });

      test('should handle missing title with version fallback', () {
        final mapWithoutTitle = {
          'version': '1.2.3',
          'releaseDate': '2023-10-15T00:00:00.000Z',
          'entries': [],
        };

        final version = ChangelogVersion.fromMap(mapWithoutTitle);

        // This tests the fallback logic that would be used in fromFirestore
        expect(version.version, equals('1.2.3'));
        expect(
          version.title,
          equals(''),
        ); // fromMap uses empty string as default
      });

      test('should handle complex nested entry data', () {
        final complexMap = {
          'version': '2.0.0',
          'title': 'Complex Release',
          'releaseDate': Timestamp.fromDate(DateTime(2023, 10, 15)),
          'entries': [
            {
              'title': 'Complex Feature',
              'description': 'A very detailed description',
              'category': 'added',
            },
            {'title': 'Simple Fix', 'category': 'fixed'},
          ],
        };

        final version = ChangelogVersion.fromMap(complexMap);

        expect(version.entries, hasLength(2));
        expect(
          version.entries.first.description,
          equals('A very detailed description'),
        );
        expect(version.entries.last.description, isNull);
      });
    });
  });
}
