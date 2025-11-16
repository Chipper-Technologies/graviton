import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/number_utils.dart';

void main() {
  group('NumberUtils Locale-Aware Formatting Tests', () {
    group('formatIntegerWithSeparators', () {
      test('formats small integers without separators', () {
        expect(NumberUtils.formatIntegerWithSeparators(123), '123');
        expect(NumberUtils.formatIntegerWithSeparators(0), '0');
        expect(NumberUtils.formatIntegerWithSeparators(1), '1');
      });

      test('formats large integers with default locale separators', () {
        // Note: These tests use the system default locale
        // In most test environments, this will be 'en_US'
        expect(NumberUtils.formatIntegerWithSeparators(1234), contains('1'));
        expect(NumberUtils.formatIntegerWithSeparators(1234567), contains('1'));
        expect(NumberUtils.formatIntegerWithSeparators(1000000), contains('1'));
      });

      test('formats integers with specific English locale', () {
        expect(NumberUtils.formatIntegerWithSeparators(1234, 'en_US'), '1,234');
        expect(
          NumberUtils.formatIntegerWithSeparators(1234567, 'en_US'),
          '1,234,567',
        );
        expect(
          NumberUtils.formatIntegerWithSeparators(1000000, 'en_US'),
          '1,000,000',
        );
        expect(NumberUtils.formatIntegerWithSeparators(999, 'en_US'), '999');
      });

      test('formats integers with specific German locale', () {
        expect(NumberUtils.formatIntegerWithSeparators(1234, 'de_DE'), '1.234');
        expect(
          NumberUtils.formatIntegerWithSeparators(1234567, 'de_DE'),
          '1.234.567',
        );
        expect(
          NumberUtils.formatIntegerWithSeparators(1000000, 'de_DE'),
          '1.000.000',
        );
      });

      test('formats integers with specific French locale', () {
        // French uses non-breaking space as thousands separator
        // Test that it contains the digits we expect, allowing for different space characters
        final result = NumberUtils.formatIntegerWithSeparators(1234, 'fr_FR');
        expect(result, contains('1'));
        expect(result, contains('234'));
        expect(result.length, 5); // 1 + separator + 234

        final largeResult = NumberUtils.formatIntegerWithSeparators(
          1234567,
          'fr_FR',
        );
        expect(largeResult, contains('1'));
        expect(largeResult, contains('234'));
        expect(largeResult, contains('567'));
      });

      test('handles negative numbers', () {
        expect(
          NumberUtils.formatIntegerWithSeparators(-1234, 'en_US'),
          '-1,234',
        );
        expect(
          NumberUtils.formatIntegerWithSeparators(-1234567, 'en_US'),
          '-1,234,567',
        );
        expect(
          NumberUtils.formatIntegerWithSeparators(-1000, 'de_DE'),
          '-1.000',
        );
      });

      test('handles edge cases', () {
        expect(NumberUtils.formatIntegerWithSeparators(0, 'en_US'), '0');
        expect(NumberUtils.formatIntegerWithSeparators(-0, 'en_US'), '0');
        expect(NumberUtils.formatIntegerWithSeparators(999, 'en_US'), '999');
        expect(NumberUtils.formatIntegerWithSeparators(1000, 'en_US'), '1,000');
      });
    });

    group('formatDoubleWithSeparators', () {
      test('formats doubles with default decimal places', () {
        // Default behavior varies by locale, so we test structure
        final result = NumberUtils.formatDoubleWithSeparators(1234.5678);
        expect(result, contains('1'));
        expect(result, contains('234'));
      });

      test(
        'formats doubles with specified decimal places in English locale',
        () {
          expect(
            NumberUtils.formatDoubleWithSeparators(
              1234.5678,
              decimalPlaces: 2,
              locale: 'en_US',
            ),
            '1,234.57',
          );
          expect(
            NumberUtils.formatDoubleWithSeparators(
              1234.5,
              decimalPlaces: 2,
              locale: 'en_US',
            ),
            '1,234.50',
          );
          expect(
            NumberUtils.formatDoubleWithSeparators(
              1234.0,
              decimalPlaces: 0,
              locale: 'en_US',
            ),
            '1,234',
          );
        },
      );

      test(
        'formats doubles with specified decimal places in German locale',
        () {
          expect(
            NumberUtils.formatDoubleWithSeparators(
              1234.5678,
              decimalPlaces: 2,
              locale: 'de_DE',
            ),
            '1.234,57',
          );
          expect(
            NumberUtils.formatDoubleWithSeparators(
              1234.5,
              decimalPlaces: 2,
              locale: 'de_DE',
            ),
            '1.234,50',
          );
          expect(
            NumberUtils.formatDoubleWithSeparators(
              999.99,
              decimalPlaces: 2,
              locale: 'de_DE',
            ),
            '999,99',
          );
        },
      );

      test(
        'formats doubles with specified decimal places in French locale',
        () {
          // French uses non-breaking space for thousands and comma for decimal
          final result = NumberUtils.formatDoubleWithSeparators(
            1234.5678,
            decimalPlaces: 2,
            locale: 'fr_FR',
          );
          expect(result, contains('1'));
          expect(result, contains('234'));
          expect(result, contains(',57')); // French uses comma for decimal

          final simpleResult = NumberUtils.formatDoubleWithSeparators(
            1234.5,
            decimalPlaces: 1,
            locale: 'fr_FR',
          );
          expect(simpleResult, contains('1'));
          expect(simpleResult, contains('234'));
          expect(simpleResult, contains(',5'));
        },
      );

      test('handles small numbers without separators', () {
        expect(
          NumberUtils.formatDoubleWithSeparators(
            123.45,
            decimalPlaces: 2,
            locale: 'en_US',
          ),
          '123.45',
        );
        expect(
          NumberUtils.formatDoubleWithSeparators(
            0.5,
            decimalPlaces: 1,
            locale: 'en_US',
          ),
          '0.5',
        );
      });

      test('handles negative doubles', () {
        expect(
          NumberUtils.formatDoubleWithSeparators(
            -1234.56,
            decimalPlaces: 2,
            locale: 'en_US',
          ),
          '-1,234.56',
        );
        expect(
          NumberUtils.formatDoubleWithSeparators(
            -999.99,
            decimalPlaces: 2,
            locale: 'de_DE',
          ),
          '-999,99',
        );
      });

      test('handles zero values', () {
        expect(
          NumberUtils.formatDoubleWithSeparators(
            0.0,
            decimalPlaces: 2,
            locale: 'en_US',
          ),
          '0.00',
        );
        expect(
          NumberUtils.formatDoubleWithSeparators(
            0.0,
            decimalPlaces: 0,
            locale: 'en_US',
          ),
          '0',
        );
      });
    });

    group('formatCompact', () {
      test('formats numbers with compact notation in English locale', () {
        expect(NumberUtils.formatCompact(1234, 'en_US'), '1.23K');
        expect(NumberUtils.formatCompact(1234567, 'en_US'), '1.23M');
        expect(NumberUtils.formatCompact(1234567890, 'en_US'), '1.23B');
        expect(NumberUtils.formatCompact(1234567890123, 'en_US'), '1.23T');
      });

      test('formats small numbers without compact notation', () {
        expect(NumberUtils.formatCompact(123, 'en_US'), '123');
        expect(NumberUtils.formatCompact(999, 'en_US'), '999');
        expect(NumberUtils.formatCompact(0, 'en_US'), '0');
      });

      test('formats numbers with compact notation in different locales', () {
        // German locale uses different abbreviations
        expect(NumberUtils.formatCompact(1234, 'de_DE'), contains('1'));
        expect(NumberUtils.formatCompact(1234567, 'de_DE'), contains('1'));

        // French locale
        expect(NumberUtils.formatCompact(1234, 'fr_FR'), contains('1'));
        expect(NumberUtils.formatCompact(1234567, 'fr_FR'), contains('1'));
      });

      test('handles negative numbers in compact format', () {
        expect(NumberUtils.formatCompact(-1234, 'en_US'), '-1.23K');
        expect(NumberUtils.formatCompact(-1234567, 'en_US'), '-1.23M');
      });

      test('handles decimal input values', () {
        expect(NumberUtils.formatCompact(1234.5, 'en_US'), '1.23K');
        expect(NumberUtils.formatCompact(1234567.89, 'en_US'), '1.23M');
      });
    });

    group('formatSimulationSteps', () {
      test('formats simulation step counts correctly', () {
        expect(NumberUtils.formatSimulationSteps(1234, 'en_US'), '1,234');
        expect(
          NumberUtils.formatSimulationSteps(1234567, 'en_US'),
          '1,234,567',
        );
        expect(NumberUtils.formatSimulationSteps(0, 'en_US'), '0');
        expect(NumberUtils.formatSimulationSteps(999, 'en_US'), '999');
      });

      test('formats simulation steps with different locales', () {
        expect(
          NumberUtils.formatSimulationSteps(1234567, 'de_DE'),
          '1.234.567',
        );

        // French locale test - check structure rather than exact characters
        final frResult = NumberUtils.formatSimulationSteps(1234567, 'fr_FR');
        expect(frResult, contains('1'));
        expect(frResult, contains('234'));
        expect(frResult, contains('567'));
      });

      test('handles typical simulation step counts', () {
        // Test common step count ranges
        expect(NumberUtils.formatSimulationSteps(100, 'en_US'), '100');
        expect(NumberUtils.formatSimulationSteps(10000, 'en_US'), '10,000');
        expect(NumberUtils.formatSimulationSteps(500000, 'en_US'), '500,000');
        expect(
          NumberUtils.formatSimulationSteps(1000000, 'en_US'),
          '1,000,000',
        );
      });

      test('uses default locale when none specified', () {
        // Should not throw and should return a string
        final result = NumberUtils.formatSimulationSteps(1234567);
        expect(result, isA<String>());
        expect(result, contains('1'));
        expect(result, contains('234'));
        expect(result, contains('567'));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('handles very large numbers', () {
        const largeInt = 9223372036854775807; // Max int64
        final result = NumberUtils.formatIntegerWithSeparators(
          largeInt,
          'en_US',
        );
        expect(result, isA<String>());
        expect(result, contains('9'));
      });

      test('handles very small decimal numbers', () {
        final result = NumberUtils.formatDoubleWithSeparators(
          0.000001,
          decimalPlaces: 6,
          locale: 'en_US',
        );
        expect(result, '0.000001');
      });

      test('handles invalid locale gracefully', () {
        // Should fall back to default locale behavior
        expect(
          () => NumberUtils.formatIntegerWithSeparators(1234, 'invalid_locale'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
  });
}
