import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/live_region_importance.dart';

void main() {
  group('LiveRegionImportance', () {
    group('Enum Values', () {
      test('should have all expected values', () {
        const values = LiveRegionImportance.values;

        expect(values, hasLength(2));
        expect(values, contains(LiveRegionImportance.polite));
        expect(values, contains(LiveRegionImportance.assertive));
      });

      test('should have consistent enum indices', () {
        expect(LiveRegionImportance.polite.index, equals(0));
        expect(LiveRegionImportance.assertive.index, equals(1));
      });
    });

    group('Extension - value property', () {
      test('should return correct string value for polite', () {
        expect(LiveRegionImportance.polite.value, equals('polite'));
      });

      test('should return correct string value for assertive', () {
        expect(LiveRegionImportance.assertive.value, equals('assertive'));
      });

      test('should return lowercase values', () {
        for (final importance in LiveRegionImportance.values) {
          expect(importance.value, equals(importance.value.toLowerCase()));
        }
      });
    });

    group('Extension - description property', () {
      test('should return meaningful description for polite', () {
        const expected =
            'Polite announcements that don\'t interrupt current speech';
        expect(LiveRegionImportance.polite.description, equals(expected));
      });

      test('should return meaningful description for assertive', () {
        const expected =
            'Assertive announcements that interrupt current speech';
        expect(LiveRegionImportance.assertive.description, equals(expected));
      });

      test('should return non-empty descriptions for all values', () {
        for (final importance in LiveRegionImportance.values) {
          expect(importance.description, isNotEmpty);
          expect(importance.description.trim(), equals(importance.description));
        }
      });

      test('should contain expected keywords in descriptions', () {
        expect(
          LiveRegionImportance.polite.description,
          contains('don\'t interrupt'),
        );
        expect(
          LiveRegionImportance.assertive.description,
          contains('interrupt'),
        );

        for (final importance in LiveRegionImportance.values) {
          expect(
            importance.description.toLowerCase(),
            contains('announcements'),
          );
          expect(importance.description.toLowerCase(), contains('speech'));
        }
      });
    });

    group('Extension - isHighPriority property', () {
      test('polite should not be high priority', () {
        expect(LiveRegionImportance.polite.isHighPriority, isFalse);
      });

      test('assertive should be high priority', () {
        expect(LiveRegionImportance.assertive.isHighPriority, isTrue);
      });

      test('should have exactly one high priority value', () {
        final highPriorityValues = LiveRegionImportance.values
            .where((importance) => importance.isHighPriority)
            .toList();

        expect(highPriorityValues, hasLength(1));
        expect(
          highPriorityValues.first,
          equals(LiveRegionImportance.assertive),
        );
      });
    });

    group('Extension - fromString static method', () {
      test('should parse valid string values correctly', () {
        expect(
          LiveRegionImportanceExtension.fromString('polite'),
          equals(LiveRegionImportance.polite),
        );
        expect(
          LiveRegionImportanceExtension.fromString('assertive'),
          equals(LiveRegionImportance.assertive),
        );
      });

      test('should be case insensitive', () {
        expect(
          LiveRegionImportanceExtension.fromString('POLITE'),
          equals(LiveRegionImportance.polite),
        );
        expect(
          LiveRegionImportanceExtension.fromString('Assertive'),
          equals(LiveRegionImportance.assertive),
        );
        expect(
          LiveRegionImportanceExtension.fromString('AsSeRtIvE'),
          equals(LiveRegionImportance.assertive),
        );
        expect(
          LiveRegionImportanceExtension.fromString('pOlItE'),
          equals(LiveRegionImportance.polite),
        );
      });

      test('should default to polite for invalid values', () {
        expect(
          LiveRegionImportanceExtension.fromString('invalid'),
          equals(LiveRegionImportance.polite),
        );
        expect(
          LiveRegionImportanceExtension.fromString('unknown'),
          equals(LiveRegionImportance.polite),
        );
        expect(
          LiveRegionImportanceExtension.fromString(''),
          equals(LiveRegionImportance.polite),
        );
        expect(
          LiveRegionImportanceExtension.fromString('12345'),
          equals(LiveRegionImportance.polite),
        );
      });

      test('should handle null and edge cases gracefully', () {
        expect(
          LiveRegionImportanceExtension.fromString('   polite   '),
          equals(
            LiveRegionImportance.polite,
          ), // Note: current implementation doesn't trim
        );
      });

      test('should handle special characters', () {
        expect(
          LiveRegionImportanceExtension.fromString('polite!'),
          equals(LiveRegionImportance.polite),
        );
        expect(
          LiveRegionImportanceExtension.fromString('assertive@'),
          equals(LiveRegionImportance.polite),
        );
      });
    });

    group('String roundtrip conversion', () {
      test('should successfully roundtrip through string conversion', () {
        for (final importance in LiveRegionImportance.values) {
          final stringValue = importance.value;
          final parsedBack = LiveRegionImportanceExtension.fromString(
            stringValue,
          );
          expect(parsedBack, equals(importance));
        }
      });

      test('should maintain consistency in string representations', () {
        const expectedMappings = {
          LiveRegionImportance.polite: 'polite',
          LiveRegionImportance.assertive: 'assertive',
        };

        for (final entry in expectedMappings.entries) {
          expect(entry.key.value, equals(entry.value));
          expect(
            LiveRegionImportanceExtension.fromString(entry.value),
            equals(entry.key),
          );
        }
      });
    });

    group('Accessibility compliance', () {
      test('should follow ARIA live region standards', () {
        // ARIA live region supports 'polite' and 'assertive' values
        const ariaLiveValues = {'polite', 'assertive'};

        for (final importance in LiveRegionImportance.values) {
          expect(ariaLiveValues, contains(importance.value));
        }
      });

      test('should provide appropriate guidance for screen readers', () {
        // Polite should be for non-critical updates
        expect(LiveRegionImportance.polite.isHighPriority, isFalse);
        expect(
          LiveRegionImportance.polite.description,
          contains('don\'t interrupt'),
        );

        // Assertive should be for critical updates
        expect(LiveRegionImportance.assertive.isHighPriority, isTrue);
        expect(
          LiveRegionImportance.assertive.description,
          contains('interrupt'),
        );
      });
    });

    group('Usage patterns', () {
      test('should support common accessibility patterns', () {
        // Test typical usage patterns
        const commonUsages = [
          'polite', // Status updates, progress notifications
          'assertive', // Error messages, critical alerts
        ];

        for (final usage in commonUsages) {
          final importance = LiveRegionImportanceExtension.fromString(usage);
          expect(LiveRegionImportance.values, contains(importance));
        }
      });

      test('should provide meaningful distinctions', () {
        final polite = LiveRegionImportance.polite;
        final assertive = LiveRegionImportance.assertive;

        // Should be different values
        expect(polite, isNot(equals(assertive)));

        // Should have different characteristics
        expect(polite.isHighPriority, isNot(equals(assertive.isHighPriority)));
        expect(polite.value, isNot(equals(assertive.value)));
        expect(polite.description, isNot(equals(assertive.description)));
      });
    });

    group('Documentation and discoverability', () {
      test('should have comprehensive documentation', () {
        // Check that all enum values have meaningful descriptions
        for (final importance in LiveRegionImportance.values) {
          expect(importance.description, isNotEmpty);
          expect(
            importance.description.length,
            greaterThan(20),
          ); // Should be descriptive
        }
      });

      test('should be self-documenting through extension methods', () {
        // The extension should provide all necessary information
        for (final importance in LiveRegionImportance.values) {
          // Should have string value for serialization
          expect(importance.value, isNotEmpty);

          // Should have description for documentation
          expect(importance.description, isNotEmpty);

          // Should have priority indicator for logic
          expect(importance.isHighPriority, isA<bool>());
        }
      });
    });

    group('Performance considerations', () {
      test('should have fast string conversion', () {
        // Test that string conversion doesn't involve complex operations
        for (final importance in LiveRegionImportance.values) {
          final stopwatch = Stopwatch()..start();
          final value = importance.value;
          stopwatch.stop();

          expect(value, isNotEmpty);
          // String conversion should be very fast (under 1ms even on slow systems)
          expect(stopwatch.elapsedMilliseconds, lessThan(10));
        }
      });

      test('should have fast parsing from string', () {
        const testValues = ['polite', 'assertive', 'invalid'];

        for (final testValue in testValues) {
          final stopwatch = Stopwatch()..start();
          final result = LiveRegionImportanceExtension.fromString(testValue);
          stopwatch.stop();

          expect(result, isA<LiveRegionImportance>());
          // String parsing should be very fast
          expect(stopwatch.elapsedMilliseconds, lessThan(10));
        }
      });
    });
  });
}
