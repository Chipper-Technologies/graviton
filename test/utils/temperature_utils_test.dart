import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/temperature_utils.dart';

void main() {
  group('TemperatureUtils Tests', () {
    group('calculateStellarTemperature', () {
      test('should calculate temperature for Sun-like mass', () {
        final sunMass = SimulationConstants.sunMassReference;
        final sunTemp = SimulationConstants.sunTemperatureReference;
        final result = TemperatureUtils.calculateStellarTemperature(sunMass);

        expect(result, closeTo(sunTemp, 100)); // Within 100K of sun temperature
      });

      test('should calculate higher temperature for high mass stars', () {
        final sunMass = SimulationConstants.sunMassReference;
        final sunTemp = SimulationConstants.sunTemperatureReference;
        final highMass = sunMass * 3.0; // 3 solar masses

        final result = TemperatureUtils.calculateStellarTemperature(highMass);

        expect(
          result,
          greaterThan(sunTemp * 2),
        ); // Should be significantly hotter
      });

      test('should calculate lower temperature for low mass stars', () {
        final sunMass = SimulationConstants.sunMassReference;
        final sunTemp = SimulationConstants.sunTemperatureReference;
        final lowMass = sunMass * 0.5; // 0.5 solar masses

        final result = TemperatureUtils.calculateStellarTemperature(lowMass);

        expect(result, lessThan(sunTemp)); // Should be cooler
        expect(result, greaterThan(sunTemp * 0.5)); // But not too cool
      });

      test('should handle zero mass gracefully', () {
        final result = TemperatureUtils.calculateStellarTemperature(0.0);
        expect(result, equals(0.0));
      });

      test('should handle negative mass gracefully', () {
        final result = TemperatureUtils.calculateStellarTemperature(-10.0);
        expect(result, isNaN); // Math.pow with negative base can return NaN
      });
    });

    group('getColorFromTemperature', () {
      test('should return O-type color for very hot stars', () {
        final result = TemperatureUtils.getColorFromTemperature(35000);
        expect(result, equals(AppColors.stellarOType));
      });

      test('should return B-type color for hot blue-white stars', () {
        final result = TemperatureUtils.getColorFromTemperature(15000);
        expect(result, equals(AppColors.stellarBType));
      });

      test('should return A-type color for white stars', () {
        final result = TemperatureUtils.getColorFromTemperature(8000);
        expect(result, equals(AppColors.stellarAType));
      });

      test('should return F-type color for yellow-white stars', () {
        final result = TemperatureUtils.getColorFromTemperature(6500);
        expect(result, equals(AppColors.stellarFType));
      });

      test('should return G-type color for Sun-like stars', () {
        final result = TemperatureUtils.getColorFromTemperature(5800);
        expect(result, equals(AppColors.stellarGType));
      });

      test('should return K-type color for orange stars', () {
        final result = TemperatureUtils.getColorFromTemperature(4500);
        expect(result, equals(AppColors.stellarKType));
      });

      test('should return M-type color for red dwarf stars', () {
        final result = TemperatureUtils.getColorFromTemperature(3000);
        expect(result, equals(AppColors.stellarMType));
      });

      test('should handle boundary temperatures correctly', () {
        // Test exact boundary values
        expect(
          TemperatureUtils.getColorFromTemperature(30000),
          equals(AppColors.stellarBType),
        );
        expect(
          TemperatureUtils.getColorFromTemperature(30001),
          equals(AppColors.stellarOType),
        );

        expect(
          TemperatureUtils.getColorFromTemperature(5200),
          equals(AppColors.stellarKType),
        );
        expect(
          TemperatureUtils.getColorFromTemperature(5201),
          equals(AppColors.stellarGType),
        );
      });

      test('should handle extremely low temperatures', () {
        final result = TemperatureUtils.getColorFromTemperature(1000);
        expect(result, equals(AppColors.stellarMType));
      });

      test('should handle zero temperature', () {
        final result = TemperatureUtils.getColorFromTemperature(0);
        expect(result, equals(AppColors.stellarMType));
      });
    });

    group('getSpectralClass', () {
      test(
        'should return correct spectral classes for different temperatures',
        () {
          expect(TemperatureUtils.getSpectralClass(35000), equals('O'));
          expect(TemperatureUtils.getSpectralClass(15000), equals('B'));
          expect(TemperatureUtils.getSpectralClass(8000), equals('A'));
          expect(TemperatureUtils.getSpectralClass(6500), equals('F'));
          expect(TemperatureUtils.getSpectralClass(5800), equals('G'));
          expect(TemperatureUtils.getSpectralClass(4500), equals('K'));
          expect(TemperatureUtils.getSpectralClass(3000), equals('M'));
        },
      );

      test('should handle boundary values correctly', () {
        expect(TemperatureUtils.getSpectralClass(30000), equals('B'));
        expect(TemperatureUtils.getSpectralClass(30001), equals('O'));
        expect(TemperatureUtils.getSpectralClass(3701), equals('K'));
        expect(TemperatureUtils.getSpectralClass(3700), equals('M'));
      });
    });

    group('getTemperatureRange', () {
      test('should return correct temperature ranges for spectral classes', () {
        expect(TemperatureUtils.getTemperatureRange('O'), equals('> 30,000K'));
        expect(
          TemperatureUtils.getTemperatureRange('B'),
          equals('10,000-30,000K'),
        );
        expect(
          TemperatureUtils.getTemperatureRange('A'),
          equals('7,500-10,000K'),
        );
        expect(
          TemperatureUtils.getTemperatureRange('F'),
          equals('6,000-7,500K'),
        );
        expect(
          TemperatureUtils.getTemperatureRange('G'),
          equals('5,200-6,000K'),
        );
        expect(
          TemperatureUtils.getTemperatureRange('K'),
          equals('3,700-5,200K'),
        );
        expect(TemperatureUtils.getTemperatureRange('M'), equals('< 3,700K'));
      });

      test('should handle lowercase input', () {
        expect(
          TemperatureUtils.getTemperatureRange('g'),
          equals('5,200-6,000K'),
        );
        expect(TemperatureUtils.getTemperatureRange('m'), equals('< 3,700K'));
      });

      test('should handle invalid input', () {
        expect(TemperatureUtils.getTemperatureRange('X'), equals('Unknown'));
        expect(TemperatureUtils.getTemperatureRange(''), equals('Unknown'));
      });
    });

    group('getColorDescription', () {
      test('should return correct color descriptions for spectral classes', () {
        expect(TemperatureUtils.getColorDescription('O'), equals('Blue'));
        expect(TemperatureUtils.getColorDescription('B'), equals('Blue-white'));
        expect(TemperatureUtils.getColorDescription('A'), equals('White'));
        expect(
          TemperatureUtils.getColorDescription('F'),
          equals('Yellow-white'),
        );
        expect(TemperatureUtils.getColorDescription('G'), equals('Yellow'));
        expect(TemperatureUtils.getColorDescription('K'), equals('Orange'));
        expect(TemperatureUtils.getColorDescription('M'), equals('Red'));
      });

      test('should handle lowercase input', () {
        expect(TemperatureUtils.getColorDescription('g'), equals('Yellow'));
        expect(TemperatureUtils.getColorDescription('m'), equals('Red'));
      });

      test('should handle invalid input', () {
        expect(TemperatureUtils.getColorDescription('X'), equals('Unknown'));
        expect(TemperatureUtils.getColorDescription(''), equals('Unknown'));
      });
    });

    group('calculateLuminosity', () {
      test('should calculate luminosity for Sun-like mass', () {
        final sunMass = SimulationConstants.sunMassReference;
        final result = TemperatureUtils.calculateLuminosity(sunMass, 5778);

        expect(
          result,
          closeTo(1.0, 0.1),
        ); // Should be close to 1 solar luminosity
      });

      test('should calculate higher luminosity for massive stars', () {
        final sunMass = SimulationConstants.sunMassReference;
        final result = TemperatureUtils.calculateLuminosity(sunMass * 2, 10000);

        expect(result, greaterThan(10)); // Much more luminous
      });

      test('should calculate lower luminosity for low mass stars', () {
        final sunMass = SimulationConstants.sunMassReference;
        final result = TemperatureUtils.calculateLuminosity(
          sunMass * 0.5,
          3000,
        );

        expect(result, lessThan(0.2)); // Much less luminous
      });

      test('should handle zero mass', () {
        final result = TemperatureUtils.calculateLuminosity(0.0, 5778);
        expect(result, equals(0.0));
      });
    });

    group('isMeaningfulStellarTemperature', () {
      test('should return true for stellar temperatures', () {
        expect(TemperatureUtils.isMeaningfulStellarTemperature(5778), isTrue);
        expect(TemperatureUtils.isMeaningfulStellarTemperature(3000), isTrue);
        expect(TemperatureUtils.isMeaningfulStellarTemperature(30000), isTrue);
      });

      test('should return false for low temperatures', () {
        final threshold =
            SimulationConstants.meaningfulStellarTemperatureThreshold;
        expect(
          TemperatureUtils.isMeaningfulStellarTemperature(threshold - 1),
          isFalse,
        );
        expect(TemperatureUtils.isMeaningfulStellarTemperature(100), isFalse);
        expect(TemperatureUtils.isMeaningfulStellarTemperature(0), isFalse);
      });

      test('should handle boundary value correctly', () {
        final threshold =
            SimulationConstants.meaningfulStellarTemperatureThreshold;
        expect(
          TemperatureUtils.isMeaningfulStellarTemperature(threshold),
          isFalse,
        );
        expect(
          TemperatureUtils.isMeaningfulStellarTemperature(threshold + 1),
          isTrue,
        );
      });
    });

    group('Integration Tests', () {
      test('should provide consistent spectral classification', () {
        const temperatures = [
          35000.0,
          15000.0,
          8000.0,
          6500.0,
          5800.0,
          4500.0,
          3000.0,
        ];
        const expectedClasses = ['O', 'B', 'A', 'F', 'G', 'K', 'M'];

        for (int i = 0; i < temperatures.length; i++) {
          final temp = temperatures[i];
          final spectralClass = TemperatureUtils.getSpectralClass(temp);
          final color = TemperatureUtils.getColorFromTemperature(temp);

          expect(spectralClass, equals(expectedClasses[i]));
          expect(color, isA<Color>()); // Should return a valid color

          // Temperature range should be consistent
          final tempRange = TemperatureUtils.getTemperatureRange(spectralClass);
          expect(tempRange, isNot(equals('Unknown')));

          // Color description should be consistent
          final colorDesc = TemperatureUtils.getColorDescription(spectralClass);
          expect(colorDesc, isNot(equals('Unknown')));
        }
      });
    });
  });
}
