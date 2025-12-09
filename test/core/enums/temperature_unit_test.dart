import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/temperature_unit.dart';

void main() {
  group('TemperatureUnit Enum', () {
    test('should have all expected temperature units', () {
      expect(TemperatureUnit.values.length, equals(3));
      expect(TemperatureUnit.values, contains(TemperatureUnit.celsius));
      expect(TemperatureUnit.values, contains(TemperatureUnit.fahrenheit));
      expect(TemperatureUnit.values, contains(TemperatureUnit.kelvin));
    });

    test('should have correct symbols', () {
      expect(TemperatureUnit.celsius.symbol, equals('°C'));
      expect(TemperatureUnit.fahrenheit.symbol, equals('°F'));
      expect(TemperatureUnit.kelvin.symbol, equals('K'));
    });

    test('should have unique symbols', () {
      final symbols = TemperatureUnit.values.map((unit) => unit.symbol).toSet();
      expect(
        symbols.length,
        equals(TemperatureUnit.values.length),
        reason: 'All temperature units should have unique symbols',
      );
    });

    test('should have correct name localization keys', () {
      expect(
        TemperatureUnit.celsius.nameLocalizationKey,
        equals('temperatureUnitCelsiusName'),
      );
      expect(
        TemperatureUnit.fahrenheit.nameLocalizationKey,
        equals('temperatureUnitFahrenheitName'),
      );
      expect(
        TemperatureUnit.kelvin.nameLocalizationKey,
        equals('temperatureUnitKelvinName'),
      );
    });

    test('should have correct symbol localization keys', () {
      expect(
        TemperatureUnit.celsius.symbolLocalizationKey,
        equals('temperatureUnitCelsius'),
      );
      expect(
        TemperatureUnit.fahrenheit.symbolLocalizationKey,
        equals('temperatureUnitFahrenheit'),
      );
      expect(
        TemperatureUnit.kelvin.symbolLocalizationKey,
        equals('temperatureUnitKelvin'),
      );
    });

    test('should have unique name localization keys', () {
      final nameKeys = TemperatureUnit.values
          .map((unit) => unit.nameLocalizationKey)
          .toSet();
      expect(
        nameKeys.length,
        equals(TemperatureUnit.values.length),
        reason:
            'All temperature units should have unique name localization keys',
      );
    });

    test('should have unique symbol localization keys', () {
      final symbolKeys = TemperatureUnit.values
          .map((unit) => unit.symbolLocalizationKey)
          .toSet();
      expect(
        symbolKeys.length,
        equals(TemperatureUnit.values.length),
        reason:
            'All temperature units should have unique symbol localization keys',
      );
    });

    group('fromString conversion', () {
      test('should correctly convert from lowercase strings', () {
        expect(
          TemperatureUnit.fromString('celsius'),
          equals(TemperatureUnit.celsius),
        );
        expect(
          TemperatureUnit.fromString('fahrenheit'),
          equals(TemperatureUnit.fahrenheit),
        );
        expect(
          TemperatureUnit.fromString('kelvin'),
          equals(TemperatureUnit.kelvin),
        );
      });

      test('should correctly convert from uppercase strings', () {
        expect(
          TemperatureUnit.fromString('CELSIUS'),
          equals(TemperatureUnit.celsius),
        );
        expect(
          TemperatureUnit.fromString('FAHRENHEIT'),
          equals(TemperatureUnit.fahrenheit),
        );
        expect(
          TemperatureUnit.fromString('KELVIN'),
          equals(TemperatureUnit.kelvin),
        );
      });

      test('should correctly convert from mixed case strings', () {
        expect(
          TemperatureUnit.fromString('Celsius'),
          equals(TemperatureUnit.celsius),
        );
        expect(
          TemperatureUnit.fromString('Fahrenheit'),
          equals(TemperatureUnit.fahrenheit),
        );
        expect(
          TemperatureUnit.fromString('Kelvin'),
          equals(TemperatureUnit.kelvin),
        );
      });

      test('should default to celsius for invalid strings', () {
        expect(
          TemperatureUnit.fromString('invalid'),
          equals(TemperatureUnit.celsius),
        );
        expect(TemperatureUnit.fromString(''), equals(TemperatureUnit.celsius));
        expect(
          TemperatureUnit.fromString('xyz'),
          equals(TemperatureUnit.celsius),
        );
      });

      test('should handle null-like values gracefully', () {
        // Test edge cases that might occur in real usage
        expect(
          TemperatureUnit.fromString('null'),
          equals(TemperatureUnit.celsius),
        );
        expect(
          TemperatureUnit.fromString('undefined'),
          equals(TemperatureUnit.celsius),
        );
      });
    });

    group('enum consistency', () {
      test('should maintain consistent ordering', () {
        // Verify the order is maintained for UI consistency
        expect(TemperatureUnit.values[0], equals(TemperatureUnit.celsius));
        expect(TemperatureUnit.values[1], equals(TemperatureUnit.fahrenheit));
        expect(TemperatureUnit.values[2], equals(TemperatureUnit.kelvin));
      });

      test('should have toString return enum value', () {
        expect(
          TemperatureUnit.celsius.toString(),
          equals('TemperatureUnit.celsius'),
        );
        expect(
          TemperatureUnit.fahrenheit.toString(),
          equals('TemperatureUnit.fahrenheit'),
        );
        expect(
          TemperatureUnit.kelvin.toString(),
          equals('TemperatureUnit.kelvin'),
        );
      });

      test('should have proper enum name values', () {
        expect(TemperatureUnit.celsius.name, equals('celsius'));
        expect(TemperatureUnit.fahrenheit.name, equals('fahrenheit'));
        expect(TemperatureUnit.kelvin.name, equals('kelvin'));
      });
    });

    group('round-trip conversion', () {
      test('should maintain consistency between enum.name and fromString', () {
        for (final unit in TemperatureUnit.values) {
          expect(TemperatureUnit.fromString(unit.name), equals(unit));
        }
      });

      test('should maintain consistency with toString parsing', () {
        for (final unit in TemperatureUnit.values) {
          final enumString = unit.toString();
          final extractedName = enumString.split('.').last;
          expect(TemperatureUnit.fromString(extractedName), equals(unit));
        }
      });
    });

    group('localization key patterns', () {
      test('name localization keys should follow naming convention', () {
        for (final unit in TemperatureUnit.values) {
          expect(
            unit.nameLocalizationKey,
            matches(RegExp(r'^temperatureUnit[A-Z][a-z]+Name$')),
            reason:
                'Name localization key should follow pattern temperatureUnit{Unit}Name',
          );
        }
      });

      test('symbol localization keys should follow naming convention', () {
        for (final unit in TemperatureUnit.values) {
          expect(
            unit.symbolLocalizationKey,
            matches(RegExp(r'^temperatureUnit[A-Z][a-z]+$')),
            reason:
                'Symbol localization key should follow pattern temperatureUnit{Unit}',
          );
        }
      });

      test('name and symbol keys should be related', () {
        for (final unit in TemperatureUnit.values) {
          expect(
            unit.nameLocalizationKey,
            equals('${unit.symbolLocalizationKey}Name'),
            reason: 'Name key should be symbol key + "Name"',
          );
        }
      });
    });
  });
}
