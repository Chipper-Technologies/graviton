import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/core/enums/temperature_unit.dart';

void main() {
  group('NumberUtils', () {
    group('formatMass', () {
      test('formats zero mass', () {
        expect(NumberUtils.formatMass(0), equals('0 kg'));
      });

      test('formats small masses with decimals', () {
        expect(NumberUtils.formatMass(1.5), equals('1.5 kg'));
        expect(NumberUtils.formatMass(123.456), equals('123.5 kg'));
      });

      test('formats large masses with thousand separators', () {
        expect(NumberUtils.formatMass(1234567), equals('1,234,567 kg'));
        expect(NumberUtils.formatMass(1000000), equals('1,000,000 kg'));
      });

      test('formats astronomical masses with scientific notation', () {
        expect(NumberUtils.formatMass(1.989e30), equals('1.99×10³⁰ kg'));
        expect(NumberUtils.formatMass(5.972e24), equals('5.97×10²⁴ kg'));
        expect(NumberUtils.formatMass(7.35e22), equals('7.35×10²² kg'));
      });

      test('formats very small masses with scientific notation', () {
        expect(NumberUtils.formatMass(1.67e-27), equals('1.67×10⁻²⁷ kg'));
        expect(NumberUtils.formatMass(9.11e-31), equals('9.11×10⁻³¹ kg'));
      });

      test('handles negative masses', () {
        expect(NumberUtils.formatMass(-1.989e30), equals('-1.99×10³⁰ kg'));
        expect(NumberUtils.formatMass(-123.456), equals('-123.5 kg'));
      });
    });

    group('formatDecimal', () {
      test('formats zero with specified decimal places', () {
        expect(NumberUtils.formatDecimal(0.0, 0), equals('0'));
        expect(NumberUtils.formatDecimal(0.0, 1), equals('0.0'));
        expect(NumberUtils.formatDecimal(0.0, 2), equals('0.00'));
        expect(NumberUtils.formatDecimal(0.0, 3), equals('0.000'));
      });

      test('formats positive numbers with specified precision', () {
        expect(NumberUtils.formatDecimal(123.456789, 0), equals('123'));
        expect(NumberUtils.formatDecimal(123.456789, 1), equals('123.5'));
        expect(NumberUtils.formatDecimal(123.456789, 2), equals('123.46'));
        expect(NumberUtils.formatDecimal(123.456789, 3), equals('123.457'));
      });

      test('formats negative numbers with specified precision', () {
        expect(NumberUtils.formatDecimal(-123.456789, 0), equals('-123'));
        expect(NumberUtils.formatDecimal(-123.456789, 1), equals('-123.5'));
        expect(NumberUtils.formatDecimal(-123.456789, 2), equals('-123.46'));
        expect(NumberUtils.formatDecimal(-123.456789, 3), equals('-123.457'));
      });

      test('adds thousands separators to large numbers', () {
        expect(NumberUtils.formatDecimal(1234.567, 2), equals('1,234.57'));
        expect(NumberUtils.formatDecimal(1234567.89, 1), equals('1,234,567.9'));
        expect(NumberUtils.formatDecimal(12345678.0, 0), equals('12,345,678'));
      });

      test('handles very small numbers correctly', () {
        expect(NumberUtils.formatDecimal(0.000123, 6), equals('0.000123'));
        expect(NumberUtils.formatDecimal(0.001, 3), equals('0.001'));
        expect(NumberUtils.formatDecimal(0.00001, 5), equals('0.00001'));
      });

      test('handles rounding correctly', () {
        expect(NumberUtils.formatDecimal(1.999, 2), equals('2.00'));
        expect(NumberUtils.formatDecimal(1.995, 2), equals('2.00'));
        expect(NumberUtils.formatDecimal(1.994, 2), equals('1.99'));
        expect(NumberUtils.formatDecimal(1.9999, 3), equals('2.000'));
      });

      group('Edge cases for debug scenarios', () {
        test('handles NaN gracefully', () {
          expect(NumberUtils.formatDecimal(double.nan, 2), equals('NaN'));
          expect(NumberUtils.formatDecimal(double.nan, 0), equals('NaN'));
          expect(NumberUtils.formatDecimal(double.nan, 5), equals('NaN'));
        });

        test('handles positive infinity gracefully', () {
          expect(NumberUtils.formatDecimal(double.infinity, 2), equals('∞'));
          expect(NumberUtils.formatDecimal(double.infinity, 0), equals('∞'));
          expect(NumberUtils.formatDecimal(double.infinity, 5), equals('∞'));
        });

        test('handles negative infinity gracefully', () {
          expect(
            NumberUtils.formatDecimal(double.negativeInfinity, 2),
            equals('-∞'),
          );
          expect(
            NumberUtils.formatDecimal(double.negativeInfinity, 0),
            equals('-∞'),
          );
          expect(
            NumberUtils.formatDecimal(double.negativeInfinity, 5),
            equals('-∞'),
          );
        });

        test('handles very large finite numbers', () {
          expect(NumberUtils.formatDecimal(double.maxFinite, 0), isA<String>());
          expect(NumberUtils.formatDecimal(double.maxFinite, 2), isA<String>());
          // Should not throw exceptions
          expect(
            () => NumberUtils.formatDecimal(double.maxFinite, 1),
            returnsNormally,
          );
        });

        test('handles very small positive numbers', () {
          expect(
            NumberUtils.formatDecimal(double.minPositive, 0),
            isA<String>(),
          );
          expect(
            NumberUtils.formatDecimal(double.minPositive, 10),
            isA<String>(),
          );
          // Should not throw exceptions
          expect(
            () => NumberUtils.formatDecimal(double.minPositive, 5),
            returnsNormally,
          );
        });
      });

      group('Physics simulation edge cases', () {
        test('handles calculation results that might be NaN', () {
          // Simulate division by zero scenario in physics calculations
          final result = 0.0 / 0.0; // This produces NaN
          expect(NumberUtils.formatDecimal(result, 3), equals('NaN'));
        });

        test('handles calculation results that might be infinite', () {
          // Simulate overflow scenario in physics calculations
          final positiveResult = 1.0 / 0.0; // This produces positive infinity
          final negativeResult = -1.0 / 0.0; // This produces negative infinity

          expect(NumberUtils.formatDecimal(positiveResult, 2), equals('∞'));
          expect(NumberUtils.formatDecimal(negativeResult, 2), equals('-∞'));
        });

        test('handles gravitational force calculations edge cases', () {
          // Test scenarios that might occur in three-body problem calculations
          final nanResult = double.nan;
          final infiniteResult = double.infinity;

          expect(NumberUtils.formatDecimal(nanResult, 6), equals('NaN'));
          expect(NumberUtils.formatDecimal(infiniteResult, 6), equals('∞'));
        });
      });
    });

    group('formatDistance', () {
      test('formats zero distance', () {
        expect(NumberUtils.formatDistance(0), equals('0 m'));
      });

      test('formats small distances in meters', () {
        expect(NumberUtils.formatDistance(1.5), equals('1.5 m'));
        expect(NumberUtils.formatDistance(999.9), equals('999.9 m'));
      });

      test('formats medium distances in kilometers', () {
        expect(NumberUtils.formatDistance(1000), equals('1 km'));
        expect(NumberUtils.formatDistance(384400000), equals('384,400 km'));
        expect(NumberUtils.formatDistance(1234567890), equals('1,234,568 km'));
      });

      test('formats very large distances with AU units', () {
        expect(NumberUtils.formatDistance(1.5e15), equals('10027 AU'));
      });

      test('formats astronomical unit distances', () {
        expect(NumberUtils.formatDistance(149597870700), equals('1 AU'));
        expect(NumberUtils.formatDistance(778547200000), equals('5.2 AU'));
        expect(NumberUtils.formatDistance(1.496e11 * 39.5), equals('39.5 AU'));
      });

      test('formats light-year distances', () {
        expect(NumberUtils.formatDistance(9.46073047258e15), equals('1 ly'));
        expect(NumberUtils.formatDistance(4.37e16), equals('4.62 ly'));
      });

      test('handles negative distances', () {
        expect(NumberUtils.formatDistance(-1000), equals('-1 km'));
        expect(NumberUtils.formatDistance(-149597870700), equals('-1 AU'));
      });
    });

    group('formatVelocity', () {
      test('formats zero velocity', () {
        expect(NumberUtils.formatVelocity(0), equals('0 m/s'));
      });

      test('formats small velocities in m/s', () {
        expect(NumberUtils.formatVelocity(340.29), equals('340.3 m/s'));
        expect(NumberUtils.formatVelocity(999), equals('999 m/s'));
      });

      test('formats large velocities in km/s', () {
        expect(NumberUtils.formatVelocity(1000), equals('1 km/s'));
        expect(NumberUtils.formatVelocity(29780), equals('29.78 km/s'));
        expect(NumberUtils.formatVelocity(299792458), equals('299792 km/s'));
      });

      test('handles negative velocities', () {
        expect(NumberUtils.formatVelocity(-340.29), equals('-340.3 m/s'));
        expect(NumberUtils.formatVelocity(-29780), equals('-29.78 km/s'));
      });
    });

    group('formatTemperature', () {
      test('formats zero temperature', () {
        expect(NumberUtils.formatTemperature(0), equals('0 K'));
      });

      test('formats low temperatures with decimals', () {
        expect(NumberUtils.formatTemperature(2.7), equals('2.7 K'));
        expect(NumberUtils.formatTemperature(77.35), equals('77.35 K'));
      });

      test('formats high temperatures as integers with separators', () {
        expect(NumberUtils.formatTemperature(288.15), equals('288 K'));
        expect(NumberUtils.formatTemperature(5778), equals('5,778 K'));
        expect(NumberUtils.formatTemperature(15000000), equals('15,000,000 K'));
      });

      test('handles negative temperatures', () {
        expect(NumberUtils.formatTemperature(-273.15), equals('-273 K'));
        expect(NumberUtils.formatTemperature(-50.5), equals('-50.5 K'));
      });
    });

    group('formatLuminosity', () {
      test('formats zero luminosity', () {
        expect(NumberUtils.formatLuminosity(0), equals('0 W'));
      });

      test('formats small luminosities in watts', () {
        expect(NumberUtils.formatLuminosity(1000), equals('1,000 W'));
        expect(NumberUtils.formatLuminosity(500000), equals('500,000 W'));
      });

      test('formats very large luminosities in solar units', () {
        expect(NumberUtils.formatLuminosity(1e25), equals('0.026 L☉'));
      });

      test('formats stellar luminosities in solar units', () {
        expect(NumberUtils.formatLuminosity(3.828e26), equals('1 L☉'));
        expect(NumberUtils.formatLuminosity(1.51e25), equals('0.039 L☉'));
        expect(NumberUtils.formatLuminosity(7.656e26), equals('2 L☉'));
      });

      test('formats very small luminosities with scientific notation', () {
        expect(NumberUtils.formatLuminosity(1e-5), equals('1×10⁻⁵ W'));
      });

      test('handles negative luminosities', () {
        expect(NumberUtils.formatLuminosity(-1000), equals('-1,000 W'));
        expect(NumberUtils.formatLuminosity(-3.828e26), equals('-1 L☉'));
      });
    });

    group('formatVector2', () {
      test('formats null vector', () {
        expect(NumberUtils.formatVector2(null), equals('(0, 0)'));
      });

      test('formats Vector2 with proper precision', () {
        final vector = Vector2(123.456, -789.012);
        expect(NumberUtils.formatVector2(vector), equals('(123.5, -789)'));
      });

      test('formats Vector2 with zero values', () {
        final vector = Vector2(0, 0);
        expect(NumberUtils.formatVector2(vector), equals('(0, 0)'));
      });

      test('formats Vector2 with small values', () {
        final vector = Vector2(0.001, -0.0001);
        expect(NumberUtils.formatVector2(vector), equals('(0.001, -0.0001)'));
      });
    });

    group('formatVector3', () {
      test('formats null vector', () {
        expect(NumberUtils.formatVector3(null), equals('(0, 0, 0)'));
      });

      test('formats Vector3 with proper precision', () {
        final vector = Vector3(123.456, -789.012, 456.789);
        expect(
          NumberUtils.formatVector3(vector),
          equals('(123.5, -789, 456.8)'),
        );
      });

      test('formats Vector3 with zero values', () {
        final vector = Vector3(0, 0, 0);
        expect(NumberUtils.formatVector3(vector), equals('(0, 0, 0)'));
      });

      test('formats Vector3 with small values', () {
        final vector = Vector3(0.001, -0.0001, 0.5);
        expect(
          NumberUtils.formatVector3(vector),
          equals('(0.001, -0.0001, 0.5)'),
        );
      });
    });

    group('formatPercentage', () {
      test('formats small percentages with appropriate precision', () {
        expect(NumberUtils.formatPercentage(0.001), equals('0.1%'));
        expect(NumberUtils.formatPercentage(0.0001), equals('0.01%'));
      });

      test('formats medium percentages with 1 decimal place', () {
        expect(NumberUtils.formatPercentage(0.005), equals('0.5%'));
        expect(NumberUtils.formatPercentage(0.095), equals('10%'));
      });

      test('formats large percentages as integers', () {
        expect(NumberUtils.formatPercentage(0.1234), equals('12%'));
        expect(NumberUtils.formatPercentage(1.0), equals('100%'));
        expect(NumberUtils.formatPercentage(2.5), equals('250%'));
      });

      test('handles negative percentages', () {
        expect(NumberUtils.formatPercentage(-0.1234), equals('-12%'));
        expect(NumberUtils.formatPercentage(-0.005), equals('-0.5%'));
      });
    });

    group('parseDouble', () {
      test('parses valid double strings', () {
        expect(NumberUtils.parseDouble('123.45'), equals(123.45));
        expect(NumberUtils.parseDouble('0'), equals(0.0));
        expect(NumberUtils.parseDouble('-456.78'), equals(-456.78));
        expect(NumberUtils.parseDouble('1.23e10'), equals(1.23e10));
      });

      test('returns 0 for invalid strings', () {
        expect(NumberUtils.parseDouble('abc'), equals(0.0));
        expect(NumberUtils.parseDouble(''), equals(0.0));
        expect(NumberUtils.parseDouble(null), equals(0.0));
        expect(NumberUtils.parseDouble('12.34.56'), equals(0.0));
      });
    });

    group('parseInt', () {
      test('parses valid integer strings', () {
        expect(NumberUtils.parseInt('123'), equals(123));
        expect(NumberUtils.parseInt('0'), equals(0));
        expect(NumberUtils.parseInt('-456'), equals(-456));
      });

      test('returns 0 for invalid strings', () {
        expect(NumberUtils.parseInt('abc'), equals(0));
        expect(NumberUtils.parseInt(''), equals(0));
        expect(NumberUtils.parseInt(null), equals(0));
        expect(NumberUtils.parseInt('12.34'), equals(0));
        expect(NumberUtils.parseInt('123abc'), equals(0));
      });
    });

    group('_formatSuperscript', () {
      test('formats positive exponents', () {
        // This tests the internal method through scientific notation
        expect(NumberUtils.formatMass(1e23), contains('×10²³'));
        expect(NumberUtils.formatMass(1e9), contains('1×10⁹'));
      });

      test('formats negative exponents', () {
        // This tests the internal method through scientific notation
        expect(NumberUtils.formatMass(1e-23), contains('×10⁻²³'));
        expect(NumberUtils.formatMass(1e-5), contains('×10⁻⁵'));
      });

      test('formats multi-digit exponents', () {
        // This tests the internal method through scientific notation
        expect(NumberUtils.formatMass(1e123), contains('×10¹²³'));
        expect(NumberUtils.formatMass(1e-123), contains('×10⁻¹²³'));
      });
    });

    group('_formatScientific', () {
      test('formats numbers in proper scientific notation', () {
        // Test through mass formatting which uses scientific notation
        expect(NumberUtils.formatMass(1.23456e30), equals('1.23×10³⁰ kg'));
        expect(NumberUtils.formatMass(9.876e-25), equals('9.88×10⁻²⁵ kg'));
      });

      test('handles edge cases', () {
        // Zero should not use scientific notation
        expect(NumberUtils.formatMass(0), equals('0 kg'));

        // Very small numbers
        expect(NumberUtils.formatMass(1e-30), contains('×10⁻³⁰'));

        // Very large numbers
        expect(NumberUtils.formatMass(1e50), contains('×10⁵⁰'));
      });
    });

    group('_formatDecimal', () {
      test('removes trailing zeros', () {
        // Test through distance formatting which uses decimal formatting
        expect(NumberUtils.formatDistance(1000.0), equals('1 km'));
        expect(NumberUtils.formatDistance(1500.0), equals('2 km'));
      });

      test('handles very small numbers', () {
        expect(NumberUtils.formatDistance(0.000123), equals('0.000123 m'));
        expect(NumberUtils.formatDistance(0.001), equals('0.001 m'));
      });

      test('handles integers correctly', () {
        expect(NumberUtils.formatDistance(5000), equals('5 km'));
        expect(NumberUtils.formatDistance(123000), equals('123 km'));
      });
    });

    group('_formatLargeNumber', () {
      test('adds thousand separators', () {
        // Test through temperature formatting which uses large number formatting
        expect(NumberUtils.formatTemperature(1234567), equals('1,234,567 K'));
        expect(NumberUtils.formatTemperature(5778000), equals('5,778,000 K'));
        expect(NumberUtils.formatTemperature(1000), equals('1,000 K'));
      });

      test('handles numbers without separators needed', () {
        expect(NumberUtils.formatTemperature(999), equals('999 K'));
        expect(NumberUtils.formatTemperature(100), equals('100 K'));
      });
    });

    group('Edge cases and boundary conditions', () {
      test('handles very large numbers', () {
        expect(NumberUtils.formatMass(double.maxFinite), isA<String>());
        expect(NumberUtils.formatDistance(double.maxFinite), isA<String>());
      });

      test('handles very small positive numbers', () {
        expect(NumberUtils.formatMass(double.minPositive), isA<String>());
        expect(NumberUtils.formatDistance(double.minPositive), isA<String>());
      });

      test('handles infinity', () {
        expect(NumberUtils.formatMass(double.infinity), contains('Infinity'));
        expect(
          NumberUtils.formatMass(double.negativeInfinity),
          contains('Infinity'),
        );
      });

      test('handles NaN', () {
        expect(NumberUtils.formatMass(double.nan), contains('NaN'));
      });
    });

    group('Real-world astronomical values', () {
      test('formats Sun values correctly', () {
        // Sun mass: 1.989 × 10^30 kg
        expect(NumberUtils.formatMass(1.989e30), equals('1.99×10³⁰ kg'));

        // Sun temperature: 5778 K
        expect(NumberUtils.formatTemperature(5778), equals('5,778 K'));

        // Sun luminosity: 3.828 × 10^26 W
        expect(NumberUtils.formatLuminosity(3.828e26), equals('1 L☉'));
      });

      test('formats Earth values correctly', () {
        // Earth mass: 5.972 × 10^24 kg
        expect(NumberUtils.formatMass(5.972e24), equals('5.97×10²⁴ kg'));

        // Earth-Sun distance: 1 AU
        expect(NumberUtils.formatDistance(149597870700), equals('1 AU'));

        // Earth orbital velocity: ~29.78 km/s
        expect(NumberUtils.formatVelocity(29780), equals('29.78 km/s'));
      });

      test('formats Moon values correctly', () {
        // Moon mass: 7.35 × 10^22 kg
        expect(NumberUtils.formatMass(7.35e22), equals('7.35×10²² kg'));

        // Earth-Moon distance: 384,400 km
        expect(NumberUtils.formatDistance(384400000), equals('384,400 km'));
      });

      test('formats Proxima Centauri distance correctly', () {
        // Proxima Centauri: ~4.24 light-years
        expect(NumberUtils.formatDistance(4.0e16), equals('4.23 ly'));
      });
    });

    group('formatMassInSolarMasses', () {
      test('formats zero mass', () {
        expect(NumberUtils.formatMassInSolarMasses(0), equals('0 M☉'));
      });

      test('formats typical stellar masses', () {
        // 10 sim units = 1 solar mass
        expect(NumberUtils.formatMassInSolarMasses(10.0), equals('1.00 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(5.0), equals('0.500 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(20.0), equals('2.00 M☉'));
      });

      test('formats large stellar masses', () {
        expect(NumberUtils.formatMassInSolarMasses(150.0), equals('15.0 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(300.0), equals('30.0 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(1000.0), equals('100 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(1500.0), equals('150 M☉'));
      });

      test('formats small stellar masses', () {
        expect(NumberUtils.formatMassInSolarMasses(1.0), equals('0.100 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(0.5), equals('0.050 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(8.0), equals('0.800 M☉'));
      });

      test('formats planetary masses', () {
        // Jupiter: ~0.001 solar masses, ~10 sim units for 1 solar mass
        expect(NumberUtils.formatMassInSolarMasses(0.01), equals('0.001 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(0.05), equals('0.005 M☉'));
      });

      test('handles negative masses', () {
        expect(NumberUtils.formatMassInSolarMasses(-10.0), equals('-1.00 M☉'));
        expect(NumberUtils.formatMassInSolarMasses(-150.0), equals('-15.0 M☉'));
      });

      test('uses appropriate precision for different magnitudes', () {
        // Very small: 3 decimals
        expect(NumberUtils.formatMassInSolarMasses(0.1), equals('0.010 M☉'));
        // Medium: 2 decimals
        expect(NumberUtils.formatMassInSolarMasses(15.0), equals('1.50 M☉'));
        // Large: 1 decimal
        expect(NumberUtils.formatMassInSolarMasses(150.0), equals('15.0 M☉'));
        // Very large: 0 decimals
        expect(NumberUtils.formatMassInSolarMasses(1500.0), equals('150 M☉'));
      });
    });

    group('formatRadiusInSolarRadii', () {
      test('formats zero radius', () {
        expect(NumberUtils.formatRadiusInSolarRadii(0), equals('0 R☉'));
      });

      test('formats typical stellar radii', () {
        // 1 sim unit ≈ 1 solar radius
        expect(NumberUtils.formatRadiusInSolarRadii(1.0), equals('1.00 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(0.5), equals('0.500 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(2.0), equals('2.00 R☉'));
      });

      test('formats large stellar radii', () {
        expect(NumberUtils.formatRadiusInSolarRadii(10.0), equals('10.0 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(15.5), equals('15.5 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(100.0), equals('100.0 R☉'));
      });

      test('formats small stellar and planetary radii', () {
        expect(NumberUtils.formatRadiusInSolarRadii(0.1), equals('0.100 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(0.01), equals('0.010 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(0.7), equals('0.700 R☉'));
      });

      test('handles negative radii', () {
        expect(NumberUtils.formatRadiusInSolarRadii(-1.0), equals('-1.00 R☉'));
        expect(NumberUtils.formatRadiusInSolarRadii(-0.5), equals('-0.500 R☉'));
      });

      test('uses appropriate precision for different magnitudes', () {
        // Small: 3 decimals
        expect(NumberUtils.formatRadiusInSolarRadii(0.123), equals('0.123 R☉'));
        // Medium: 2 decimals
        expect(NumberUtils.formatRadiusInSolarRadii(1.567), equals('1.57 R☉'));
        // Large: 1 decimal
        expect(NumberUtils.formatRadiusInSolarRadii(12.345), equals('12.3 R☉'));
      });

      test('formats realistic astronomical values', () {
        // Red dwarf: ~0.1-0.5 R☉
        expect(NumberUtils.formatRadiusInSolarRadii(0.2), equals('0.200 R☉'));
        // Main sequence: ~0.8-1.2 R☉
        expect(NumberUtils.formatRadiusInSolarRadii(0.9), equals('0.900 R☉'));
        // Giant star: ~10-100 R☉
        expect(NumberUtils.formatRadiusInSolarRadii(50.0), equals('50.0 R☉'));
      });
    });

    group('Temperature Conversion Functions', () {
      group('kelvinToCelsius', () {
        test('converts freezing point of water correctly', () {
          expect(NumberUtils.kelvinToCelsius(273.15), closeTo(0.0, 0.0001));
        });

        test('converts boiling point of water correctly', () {
          expect(NumberUtils.kelvinToCelsius(373.15), closeTo(100.0, 0.0001));
        });

        test('converts absolute zero correctly', () {
          expect(NumberUtils.kelvinToCelsius(0), equals(-273.15));
        });

        test('converts room temperature correctly', () {
          expect(NumberUtils.kelvinToCelsius(294.15), closeTo(21.0, 0.0001));
        });

        test('converts sun surface temperature correctly', () {
          expect(NumberUtils.kelvinToCelsius(5778), closeTo(5504.85, 0.01));
        });

        test('handles negative results correctly', () {
          expect(NumberUtils.kelvinToCelsius(200), closeTo(-73.15, 0.01));
          expect(NumberUtils.kelvinToCelsius(100), closeTo(-173.15, 0.01));
        });
      });

      group('kelvinToFahrenheit', () {
        test('converts freezing point of water correctly', () {
          expect(NumberUtils.kelvinToFahrenheit(273.15), closeTo(32.0, 0.0001));
        });

        test('converts boiling point of water correctly', () {
          expect(
            NumberUtils.kelvinToFahrenheit(373.15),
            closeTo(212.0, 0.0001),
          );
        });

        test('converts absolute zero correctly', () {
          expect(NumberUtils.kelvinToFahrenheit(0), closeTo(-459.67, 0.01));
        });

        test('converts room temperature correctly', () {
          expect(NumberUtils.kelvinToFahrenheit(294.15), closeTo(69.8, 0.1));
        });

        test('converts sun surface temperature correctly', () {
          expect(NumberUtils.kelvinToFahrenheit(5778), closeTo(9940.73, 0.01));
        });

        test('handles negative results correctly', () {
          expect(NumberUtils.kelvinToFahrenheit(200), closeTo(-99.67, 0.01));
          expect(NumberUtils.kelvinToFahrenheit(100), closeTo(-279.67, 0.01));
        });
      });

      group('celsiusToKelvin', () {
        test('converts freezing point of water correctly', () {
          expect(NumberUtils.celsiusToKelvin(0.0), equals(273.15));
        });

        test('converts boiling point of water correctly', () {
          expect(NumberUtils.celsiusToKelvin(100.0), equals(373.15));
        });

        test('converts absolute zero correctly', () {
          expect(NumberUtils.celsiusToKelvin(-273.15), closeTo(0.0, 0.0001));
        });

        test('converts room temperature correctly', () {
          expect(NumberUtils.celsiusToKelvin(21.0), equals(294.15));
        });

        test('handles negative values correctly', () {
          expect(NumberUtils.celsiusToKelvin(-50.0), closeTo(223.15, 0.01));
          expect(NumberUtils.celsiusToKelvin(-100.0), closeTo(173.15, 0.01));
        });
      });

      group('fahrenheitToKelvin', () {
        test('converts freezing point of water correctly', () {
          expect(NumberUtils.fahrenheitToKelvin(32.0), closeTo(273.15, 0.0001));
        });

        test('converts boiling point of water correctly', () {
          expect(
            NumberUtils.fahrenheitToKelvin(212.0),
            closeTo(373.15, 0.0001),
          );
        });

        test('converts absolute zero correctly', () {
          expect(NumberUtils.fahrenheitToKelvin(-459.67), closeTo(0.0, 0.01));
        });

        test('converts room temperature correctly', () {
          expect(NumberUtils.fahrenheitToKelvin(69.8), closeTo(294.15, 0.01));
        });

        test('handles negative values correctly', () {
          expect(NumberUtils.fahrenheitToKelvin(-40.0), closeTo(233.15, 0.01));
          expect(NumberUtils.fahrenheitToKelvin(0.0), closeTo(255.37, 0.01));
        });
      });

      group('round-trip conversion consistency', () {
        test('Kelvin -> Celsius -> Kelvin maintains accuracy', () {
          const testValues = [0.0, 273.15, 373.15, 5778.0, 294.15];
          for (final kelvin in testValues) {
            final celsius = NumberUtils.kelvinToCelsius(kelvin);
            final backToKelvin = NumberUtils.celsiusToKelvin(celsius);
            expect(
              backToKelvin,
              closeTo(kelvin, 0.0001),
              reason: 'Round-trip conversion failed for $kelvin K',
            );
          }
        });

        test('Kelvin -> Fahrenheit -> Kelvin maintains accuracy', () {
          const testValues = [0.0, 273.15, 373.15, 5778.0, 294.15];
          for (final kelvin in testValues) {
            final fahrenheit = NumberUtils.kelvinToFahrenheit(kelvin);
            final backToKelvin = NumberUtils.fahrenheitToKelvin(fahrenheit);
            expect(
              backToKelvin,
              closeTo(kelvin, 0.001),
              reason: 'Round-trip conversion failed for $kelvin K',
            );
          }
        });
      });
    });

    group('formatTemperatureWithUnit', () {
      // Define temperature units for testing
      final kelvin = TemperatureUnit.kelvin;
      final celsius = TemperatureUnit.celsius;
      final fahrenheit = TemperatureUnit.fahrenheit;

      group('with Kelvin unit', () {
        test('formats small temperatures with decimals', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(2.7, kelvin),
            equals('2.7 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(77.35, kelvin),
            equals('77.35 K'),
          );
        });

        test('formats large temperatures as integers with separators', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, kelvin),
            equals('273 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(5778.0, kelvin),
            equals('5,778 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(15000000.0, kelvin),
            equals('15,000,000 K'),
          );
        });

        test('handles zero temperature', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(0.0, kelvin),
            equals('0 K'),
          );
        });
      });

      group('with Celsius unit', () {
        test('converts and formats freezing point', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, celsius),
            equals('0 °C'),
          );
        });

        test('converts and formats boiling point', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(373.15, celsius),
            equals('100 °C'),
          );
        });

        test('converts and formats room temperature', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(294.15, celsius),
            equals('21 °C'),
          );
        });

        test('converts and formats sun temperature', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(5778.0, celsius),
            equals('5,505 °C'),
          );
        });

        test('handles negative temperatures', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(200.0, celsius),
            equals('-73.15 °C'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(0.0, celsius),
            equals('-273 °C'),
          );
        });
      });

      group('with Fahrenheit unit', () {
        test('converts and formats freezing point', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, fahrenheit),
            equals('32 °F'),
          );
        });

        test('converts and formats boiling point', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(373.15, fahrenheit),
            equals('212 °F'),
          );
        });

        test('converts and formats room temperature', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(294.15, fahrenheit),
            equals('69.8 °F'),
          );
        });

        test('converts and formats sun temperature', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(5778.0, fahrenheit),
            equals('9,941 °F'),
          );
        });

        test('handles negative temperatures', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(200.0, fahrenheit),
            equals('-99.67 °F'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(0.0, fahrenheit),
            equals('-460 °F'),
          );
        });
      });

      group('with legacy string-based unit detection', () {
        test('detects TemperatureUnit.celsius string pattern', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(
              273.15,
              'TemperatureUnit.celsius',
            ),
            equals('0 °C'),
          );
        });

        test('detects TemperatureUnit.fahrenheit string pattern', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(
              273.15,
              'TemperatureUnit.fahrenheit',
            ),
            equals('32 °F'),
          );
        });

        test('defaults to Kelvin for unrecognized strings', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, 'invalid'),
            equals('273 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, ''),
            equals('273 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, 'xyz'),
            equals('273 K'),
          );
        });

        test('handles null/undefined values gracefully', () {
          expect(
            NumberUtils.formatTemperatureWithUnit(273.15, null),
            equals('273 K'),
          );
        });
      });

      group('precision and formatting consistency', () {
        test('maintains consistent precision across units', () {
          const testTemp = 294.15; // Room temperature

          // All should have appropriate precision for their magnitude
          final kelvinResult = NumberUtils.formatTemperatureWithUnit(
            testTemp,
            kelvin,
          );
          final celsiusResult = NumberUtils.formatTemperatureWithUnit(
            testTemp,
            celsius,
          );
          final fahrenheitResult = NumberUtils.formatTemperatureWithUnit(
            testTemp,
            fahrenheit,
          );

          expect(kelvinResult, equals('294 K')); // Integer for large values
          expect(celsiusResult, equals('21 °C')); // Integer for medium values
          expect(
            fahrenheitResult,
            equals('69.8 °F'),
          ); // 1 decimal for medium values
        });

        test('formats extreme temperatures appropriately', () {
          const extremeTemp = 50000000.0; // Core of massive star

          expect(
            NumberUtils.formatTemperatureWithUnit(extremeTemp, kelvin),
            equals('50,000,000 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(extremeTemp, celsius),
            equals('49,999,727 °C'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(extremeTemp, fahrenheit),
            equals('89,999,540 °F'),
          );
        });
      });

      group('astronomical temperatures', () {
        test('formats cosmic microwave background', () {
          const cmbTemp = 2.7;
          expect(
            NumberUtils.formatTemperatureWithUnit(cmbTemp, kelvin),
            equals('2.7 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(cmbTemp, celsius),
            equals('-270 °C'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(cmbTemp, fahrenheit),
            equals('-455 °F'),
          );
        });

        test('formats stellar core temperatures', () {
          const coreTemp = 15000000.0;
          expect(
            NumberUtils.formatTemperatureWithUnit(coreTemp, kelvin),
            equals('15,000,000 K'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(coreTemp, celsius),
            equals('14,999,727 °C'),
          );
          expect(
            NumberUtils.formatTemperatureWithUnit(coreTemp, fahrenheit),
            equals('26,999,540 °F'),
          );
        });
      });
    });
  });
}
