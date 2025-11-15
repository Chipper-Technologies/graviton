import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/changelog_category.dart';
import 'package:graviton/models/changelog_entry.dart';

void main() {
  group('ChangelogEntry', () {
    group('constructor and properties', () {
      test('creates instance with required properties', () {
        final entry = ChangelogEntry(
          title: 'Test Feature',
          category: ChangelogCategory.added,
        );

        expect(entry.title, equals('Test Feature'));
        expect(entry.description, isNull);
        expect(entry.category, equals(ChangelogCategory.added));
      });

      test('creates instance with all properties', () {
        final entry = ChangelogEntry(
          title: 'Enhanced Physics',
          description:
              'Improved gravitational calculations for better accuracy',
          category: ChangelogCategory.improved,
        );

        expect(entry.title, equals('Enhanced Physics'));
        expect(
          entry.description,
          equals('Improved gravitational calculations for better accuracy'),
        );
        expect(entry.category, equals(ChangelogCategory.improved));
      });

      test('handles empty title', () {
        final entry = ChangelogEntry(
          title: '',
          category: ChangelogCategory.fixed,
        );

        expect(entry.title, equals(''));
        expect(entry.category, equals(ChangelogCategory.fixed));
      });

      test('handles very long title and description', () {
        final longTitle = 'A' * 500;
        final longDescription = 'B' * 1000;

        final entry = ChangelogEntry(
          title: longTitle,
          description: longDescription,
          category: ChangelogCategory.added,
        );

        expect(entry.title, equals(longTitle));
        expect(entry.description, equals(longDescription));
      });

      test('handles special characters in title and description', () {
        final entry = ChangelogEntry(
          title: 'Fixed: Ω calculation with π/2 precision',
          description: 'Resolved issue with special chars: éñ, 中文, 🚀',
          category: ChangelogCategory.fixed,
        );

        expect(entry.title, equals('Fixed: Ω calculation with π/2 precision'));
        expect(
          entry.description,
          equals('Resolved issue with special chars: éñ, 中文, 🚀'),
        );
      });
    });

    group('fromMap factory constructor', () {
      test('creates from map with all fields', () {
        final map = {
          'title': 'New Simulation Mode',
          'description': 'Added three-body problem simulation',
          'category': 'added',
        };

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals('New Simulation Mode'));
        expect(
          entry.description,
          equals('Added three-body problem simulation'),
        );
        expect(entry.category, equals(ChangelogCategory.added));
      });

      test('creates from map without description', () {
        final map = {'title': 'Bug Fix', 'category': 'fixed'};

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals('Bug Fix'));
        expect(entry.description, isNull);
        expect(entry.category, equals(ChangelogCategory.fixed));
      });

      test('handles missing title with default empty string', () {
        final map = {'category': 'improved'};

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals(''));
        expect(entry.category, equals(ChangelogCategory.improved));
      });

      test('handles invalid category gracefully', () {
        final map = {'title': 'Test Entry', 'category': 'invalid_category'};

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals('Test Entry'));
        expect(
          entry.category,
          equals(ChangelogCategory.added),
        ); // Default fallback
      });

      test('handles null category', () {
        final map = {'title': 'Test Entry', 'category': null};

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals('Test Entry'));
        expect(
          entry.category,
          equals(ChangelogCategory.added),
        ); // Default fallback
      });

      test('handles missing category', () {
        final map = {'title': 'Test Entry'};

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals('Test Entry'));
        expect(
          entry.category,
          equals(ChangelogCategory.added),
        ); // Default fallback
      });

      test('handles null description explicitly', () {
        final map = {
          'title': 'Test Entry',
          'description': null,
          'category': 'fixed',
        };

        final entry = ChangelogEntry.fromMap(map);

        expect(entry.title, equals('Test Entry'));
        expect(entry.description, isNull);
        expect(entry.category, equals(ChangelogCategory.fixed));
      });

      test('handles all changelog categories', () {
        final categories = [
          {'category': 'added', 'expected': ChangelogCategory.added},
          {'category': 'improved', 'expected': ChangelogCategory.improved},
          {'category': 'fixed', 'expected': ChangelogCategory.fixed},
        ];

        for (final categoryTest in categories) {
          final map = {
            'title': 'Test ${categoryTest['category']}',
            'category': categoryTest['category'],
          };

          final entry = ChangelogEntry.fromMap(map);
          expect(entry.category, equals(categoryTest['expected']));
        }
      });
    });

    group('toMap method', () {
      test('converts to map with all fields', () {
        final entry = ChangelogEntry(
          title: 'Performance Optimization',
          description: 'Reduced memory usage by 30%',
          category: ChangelogCategory.improved,
        );

        final map = entry.toMap();

        expect(map['title'], equals('Performance Optimization'));
        expect(map['description'], equals('Reduced memory usage by 30%'));
        expect(map['category'], equals('improved'));
      });

      test('converts to map without description', () {
        final entry = ChangelogEntry(
          title: 'Quick Fix',
          category: ChangelogCategory.fixed,
        );

        final map = entry.toMap();

        expect(map['title'], equals('Quick Fix'));
        expect(map['description'], isNull);
        expect(map['category'], equals('fixed'));
      });

      test('converts all category types correctly', () {
        final entries = [
          ChangelogEntry(title: 'Added', category: ChangelogCategory.added),
          ChangelogEntry(
            title: 'Improved',
            category: ChangelogCategory.improved,
          ),
          ChangelogEntry(title: 'Fixed', category: ChangelogCategory.fixed),
        ];

        final expectedCategories = ['added', 'improved', 'fixed'];

        for (int i = 0; i < entries.length; i++) {
          final map = entries[i].toMap();
          expect(map['category'], equals(expectedCategories[i]));
        }
      });
    });

    group('round-trip serialization', () {
      test('maintains data integrity through fromMap/toMap cycle', () {
        final originalEntry = ChangelogEntry(
          title: 'Complex Feature',
          description: 'Multi-line\ndescription with special chars: é, 中, 🚀',
          category: ChangelogCategory.added,
        );

        final map = originalEntry.toMap();
        final reconstructedEntry = ChangelogEntry.fromMap(map);

        expect(reconstructedEntry.title, equals(originalEntry.title));
        expect(
          reconstructedEntry.description,
          equals(originalEntry.description),
        );
        expect(reconstructedEntry.category, equals(originalEntry.category));
      });

      test('handles null description in round-trip', () {
        final originalEntry = ChangelogEntry(
          title: 'Simple Fix',
          category: ChangelogCategory.fixed,
        );

        final map = originalEntry.toMap();
        final reconstructedEntry = ChangelogEntry.fromMap(map);

        expect(reconstructedEntry.title, equals(originalEntry.title));
        expect(reconstructedEntry.description, isNull);
        expect(reconstructedEntry.category, equals(originalEntry.category));
      });
    });

    group('equality and hashCode', () {
      test('equal entries have same equality result', () {
        final entry1 = ChangelogEntry(
          title: 'Test Feature',
          description: 'Test description',
          category: ChangelogCategory.added,
        );

        final entry2 = ChangelogEntry(
          title: 'Test Feature',
          description: 'Test description',
          category: ChangelogCategory.added,
        );

        expect(entry1, equals(entry2));
        expect(entry1.hashCode, equals(entry2.hashCode));
      });

      test('different titles result in inequality', () {
        final entry1 = ChangelogEntry(
          title: 'Feature A',
          category: ChangelogCategory.added,
        );

        final entry2 = ChangelogEntry(
          title: 'Feature B',
          category: ChangelogCategory.added,
        );

        expect(entry1, isNot(equals(entry2)));
        expect(entry1.hashCode, isNot(equals(entry2.hashCode)));
      });

      test('different descriptions result in inequality', () {
        final entry1 = ChangelogEntry(
          title: 'Test Feature',
          description: 'Description A',
          category: ChangelogCategory.added,
        );

        final entry2 = ChangelogEntry(
          title: 'Test Feature',
          description: 'Description B',
          category: ChangelogCategory.added,
        );

        expect(entry1, isNot(equals(entry2)));
      });

      test('different categories result in inequality', () {
        final entry1 = ChangelogEntry(
          title: 'Test Feature',
          category: ChangelogCategory.added,
        );

        final entry2 = ChangelogEntry(
          title: 'Test Feature',
          category: ChangelogCategory.fixed,
        );

        expect(entry1, isNot(equals(entry2)));
      });

      test('null vs non-null description results in inequality', () {
        final entry1 = ChangelogEntry(
          title: 'Test Feature',
          description: null,
          category: ChangelogCategory.added,
        );

        final entry2 = ChangelogEntry(
          title: 'Test Feature',
          description: 'Some description',
          category: ChangelogCategory.added,
        );

        expect(entry1, isNot(equals(entry2)));
      });

      test('handles identity equality', () {
        final entry = ChangelogEntry(
          title: 'Test Feature',
          category: ChangelogCategory.added,
        );

        expect(entry, equals(entry));
        expect(entry.hashCode, equals(entry.hashCode));
      });

      test('does not equal different type', () {
        final entry = ChangelogEntry(
          title: 'Test Feature',
          category: ChangelogCategory.added,
        );

        expect(entry, isNot(equals('string')));
        expect(entry, isNot(equals(42)));
        expect(entry, isNot(equals(null)));
      });
    });

    group('toString method', () {
      test('provides meaningful string representation with description', () {
        final entry = ChangelogEntry(
          title: 'New Camera System',
          description: 'Completely redesigned camera controls',
          category: ChangelogCategory.added,
        );

        final stringRep = entry.toString();
        expect(stringRep, contains('ChangelogEntry'));
        expect(stringRep, contains('New Camera System'));
        expect(stringRep, contains('Completely redesigned camera controls'));
        expect(stringRep, contains('added'));
      });

      test('provides meaningful string representation without description', () {
        final entry = ChangelogEntry(
          title: 'Bug Fix',
          category: ChangelogCategory.fixed,
        );

        final stringRep = entry.toString();
        expect(stringRep, contains('ChangelogEntry'));
        expect(stringRep, contains('Bug Fix'));
        expect(stringRep, contains('null'));
        expect(stringRep, contains('fixed'));
      });

      test('handles special characters in toString', () {
        final entry = ChangelogEntry(
          title: 'Ω Physics Update',
          description: 'Enhanced π calculations',
          category: ChangelogCategory.improved,
        );

        final stringRep = entry.toString();
        expect(stringRep, contains('Ω Physics Update'));
        expect(stringRep, contains('Enhanced π calculations'));
      });
    });

    group('edge cases and validation', () {
      test('handles extremely long content', () {
        final entry = ChangelogEntry(
          title: 'A' * 10000,
          description: 'B' * 50000,
          category: ChangelogCategory.added,
        );

        expect(entry.title.length, equals(10000));
        expect(entry.description!.length, equals(50000));

        // Should serialize/deserialize correctly
        final map = entry.toMap();
        final reconstructed = ChangelogEntry.fromMap(map);
        expect(reconstructed.title, equals(entry.title));
        expect(reconstructed.description, equals(entry.description));
      });

      test('handles newlines and whitespace', () {
        final entry = ChangelogEntry(
          title: '  Spaced Title  ',
          description: 'Multi-line\ndescription\n\nwith spaces  ',
          category: ChangelogCategory.improved,
        );

        expect(entry.title, equals('  Spaced Title  '));
        expect(entry.description, contains('\n'));

        // Should preserve formatting through serialization
        final map = entry.toMap();
        final reconstructed = ChangelogEntry.fromMap(map);
        expect(reconstructed.description, equals(entry.description));
      });

      test('handles unicode and emoji content', () {
        final entry = ChangelogEntry(
          title: '🚀 Performance Boost 中文',
          description: 'Émojis work: ✅ 🎯 📱\nUnicode: éñ中文',
          category: ChangelogCategory.improved,
        );

        final map = entry.toMap();
        final reconstructed = ChangelogEntry.fromMap(map);

        expect(reconstructed.title, equals('🚀 Performance Boost 中文'));
        expect(reconstructed.description, contains('✅ 🎯 📱'));
        expect(reconstructed.description, contains('éñ中文'));
      });
    });

    group('real-world scenarios', () {
      test('typical changelog entries', () {
        final entries = [
          ChangelogEntry(
            title: 'Added three-body simulation',
            description:
                'Implemented Runge-Kutta integration for accurate orbital mechanics',
            category: ChangelogCategory.added,
          ),
          ChangelogEntry(
            title: 'Improved performance',
            description:
                'Optimized rendering pipeline, 60% faster on mobile devices',
            category: ChangelogCategory.improved,
          ),
          ChangelogEntry(
            title: 'Fixed camera controls',
            description:
                'Resolved issue where camera would get stuck during zoom',
            category: ChangelogCategory.fixed,
          ),
        ];

        for (final entry in entries) {
          // Should serialize and deserialize correctly
          final map = entry.toMap();
          final reconstructed = ChangelogEntry.fromMap(map);
          expect(reconstructed, equals(entry));

          // Should have valid toString
          expect(entry.toString(), isNotEmpty);
          expect(entry.toString(), contains(entry.title));
        }
      });
    });
  });
}
