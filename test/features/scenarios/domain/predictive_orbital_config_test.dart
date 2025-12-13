import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/physics/predictive_orbital_config.dart';

void main() {
  group('PredictiveOrbitalConfig', () {
    group('constructor and properties', () {
      test('creates instance with default values', () {
        const config = PredictiveOrbitalConfig();

        expect(config.predictionTimeframe, equals(15.0));
        expect(config.minDramaticScore, equals(0.3));
        expect(config.maxTrackedEvents, equals(3));
        expect(config.movementSpeed, equals(1.0));
        expect(config.useBanking, isTrue);
        expect(config.dramaLevel, equals(0.7));
      });

      test('creates instance with custom values', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 25.0,
          minDramaticScore: 0.5,
          maxTrackedEvents: 5,
          movementSpeed: 1.5,
          useBanking: false,
          dramaLevel: 0.9,
        );

        expect(config.predictionTimeframe, equals(25.0));
        expect(config.minDramaticScore, equals(0.5));
        expect(config.maxTrackedEvents, equals(5));
        expect(config.movementSpeed, equals(1.5));
        expect(config.useBanking, isFalse);
        expect(config.dramaLevel, equals(0.9));
      });

      test('handles extreme values', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 0.1,
          minDramaticScore: 0.0,
          maxTrackedEvents: 1,
          movementSpeed: 0.1,
          useBanking: false,
          dramaLevel: 0.0,
        );

        expect(config.predictionTimeframe, equals(0.1));
        expect(config.minDramaticScore, equals(0.0));
        expect(config.maxTrackedEvents, equals(1));
        expect(config.movementSpeed, equals(0.1));
        expect(config.useBanking, isFalse);
        expect(config.dramaLevel, equals(0.0));
      });

      test('handles maximum values', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 3600.0, // 1 hour
          minDramaticScore: 1.0,
          maxTrackedEvents: 100,
          movementSpeed: 10.0,
          useBanking: true,
          dramaLevel: 1.0,
        );

        expect(config.predictionTimeframe, equals(3600.0));
        expect(config.minDramaticScore, equals(1.0));
        expect(config.maxTrackedEvents, equals(100));
        expect(config.movementSpeed, equals(10.0));
        expect(config.useBanking, isTrue);
        expect(config.dramaLevel, equals(1.0));
      });
    });

    group('forScenario factory constructor', () {
      test('creates solar system configuration', () {
        final config = PredictiveOrbitalConfig.forScenario('solarsystem');

        expect(config.predictionTimeframe, equals(30.0));
        expect(config.minDramaticScore, equals(0.2));
        expect(config.dramaLevel, equals(0.5));
        expect(config.maxTrackedEvents, equals(3)); // Default value
        expect(config.movementSpeed, equals(1.0)); // Default value
        expect(config.useBanking, isTrue); // Default value
      });

      test('creates three-body configuration', () {
        final config = PredictiveOrbitalConfig.forScenario('threebody');

        expect(config.predictionTimeframe, equals(8.0));
        expect(config.minDramaticScore, equals(0.4));
        expect(config.dramaLevel, equals(0.8));
        expect(config.maxTrackedEvents, equals(3)); // Default value
        expect(config.movementSpeed, equals(1.0)); // Default value
        expect(config.useBanking, isTrue); // Default value
      });

      test('creates galaxy configuration', () {
        final config = PredictiveOrbitalConfig.forScenario('galaxy');

        expect(config.predictionTimeframe, equals(5.0));
        expect(config.minDramaticScore, equals(0.5));
        expect(config.dramaLevel, equals(0.9));
        expect(config.maxTrackedEvents, equals(3)); // Default value
        expect(config.movementSpeed, equals(1.0)); // Default value
        expect(config.useBanking, isTrue); // Default value
      });

      test('creates default configuration for unknown scenario', () {
        final config = PredictiveOrbitalConfig.forScenario('unknown');

        expect(config.predictionTimeframe, equals(15.0));
        expect(config.minDramaticScore, equals(0.3));
        expect(config.maxTrackedEvents, equals(3));
        expect(config.movementSpeed, equals(1.0));
        expect(config.useBanking, isTrue);
        expect(config.dramaLevel, equals(0.7));
      });

      test('handles case insensitive scenario types', () {
        final solarConfig1 = PredictiveOrbitalConfig.forScenario('SolarSystem');
        final solarConfig2 = PredictiveOrbitalConfig.forScenario('SOLARSYSTEM');
        final solarConfig3 = PredictiveOrbitalConfig.forScenario('solarsystem');

        expect(solarConfig1.predictionTimeframe, equals(30.0));
        expect(solarConfig2.predictionTimeframe, equals(30.0));
        expect(solarConfig3.predictionTimeframe, equals(30.0));

        expect(solarConfig1.dramaLevel, equals(0.5));
        expect(solarConfig2.dramaLevel, equals(0.5));
        expect(solarConfig3.dramaLevel, equals(0.5));
      });

      test('handles empty string scenario type', () {
        final config = PredictiveOrbitalConfig.forScenario('');

        // Should return default configuration
        expect(config.predictionTimeframe, equals(15.0));
        expect(config.minDramaticScore, equals(0.3));
        expect(config.dramaLevel, equals(0.7));
      });
    });

    group('realistic scenario configurations', () {
      test('educational solar system config', () {
        final config = PredictiveOrbitalConfig.forScenario('solarsystem');

        // Educational focus: longer prediction, lower drama
        expect(config.predictionTimeframe, greaterThan(20.0));
        expect(config.dramaLevel, lessThan(0.6));
        expect(config.minDramaticScore, lessThan(0.3));
      });

      test('dramatic three-body config', () {
        final config = PredictiveOrbitalConfig.forScenario('threebody');

        // Chaotic system: shorter prediction, higher drama
        expect(config.predictionTimeframe, lessThan(15.0));
        expect(config.dramaLevel, greaterThan(0.7));
        expect(config.minDramaticScore, greaterThan(0.3));
      });

      test('intense galaxy config', () {
        final config = PredictiveOrbitalConfig.forScenario('galaxy');

        // Fast chaos: very short prediction, maximum drama
        expect(config.predictionTimeframe, lessThan(10.0));
        expect(config.dramaLevel, greaterThan(0.8));
        expect(config.minDramaticScore, greaterThan(0.4));
      });

      test('custom educational config', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 60.0, // Long prediction for stability
          minDramaticScore: 0.1, // Very low threshold
          maxTrackedEvents: 1, // Focus on one event
          movementSpeed: 0.5, // Slow camera movement
          useBanking: false, // No fancy camera moves
          dramaLevel: 0.2, // Very educational
        );

        expect(config.predictionTimeframe, equals(60.0));
        expect(config.dramaLevel, equals(0.2));
        expect(config.movementSpeed, equals(0.5));
        expect(config.useBanking, isFalse);
        expect(config.maxTrackedEvents, equals(1));
      });

      test('custom action config', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 2.0, // Very short for rapid action
          minDramaticScore: 0.8, // High threshold for dramatic events
          maxTrackedEvents: 10, // Track many events
          movementSpeed: 3.0, // Fast camera movement
          useBanking: true, // Cinematic camera moves
          dramaLevel: 1.0, // Maximum drama
        );

        expect(config.predictionTimeframe, equals(2.0));
        expect(config.dramaLevel, equals(1.0));
        expect(config.movementSpeed, equals(3.0));
        expect(config.useBanking, isTrue);
        expect(config.maxTrackedEvents, equals(10));
        expect(config.minDramaticScore, equals(0.8));
      });
    });

    group('value relationships and validation', () {
      test('validates drama level affects other parameters', () {
        final lowDrama = PredictiveOrbitalConfig.forScenario('solarsystem');
        final mediumDrama = PredictiveOrbitalConfig();
        final highDrama = PredictiveOrbitalConfig.forScenario('galaxy');

        // Higher drama should correlate with shorter prediction times
        expect(lowDrama.dramaLevel, lessThan(mediumDrama.dramaLevel));
        expect(mediumDrama.dramaLevel, lessThan(highDrama.dramaLevel));

        expect(
          highDrama.predictionTimeframe,
          lessThan(mediumDrama.predictionTimeframe),
        );
        expect(
          mediumDrama.predictionTimeframe,
          lessThan(lowDrama.predictionTimeframe),
        );

        // Higher drama should correlate with higher dramatic score thresholds
        expect(
          lowDrama.minDramaticScore,
          lessThan(mediumDrama.minDramaticScore),
        );
        expect(
          mediumDrama.minDramaticScore,
          lessThan(highDrama.minDramaticScore),
        );
      });

      test('validates prediction timeframe ranges', () {
        const configs = [
          PredictiveOrbitalConfig(predictionTimeframe: 0.1), // Very short
          PredictiveOrbitalConfig(predictionTimeframe: 1.0), // Short
          PredictiveOrbitalConfig(predictionTimeframe: 15.0), // Default
          PredictiveOrbitalConfig(predictionTimeframe: 60.0), // Long
          PredictiveOrbitalConfig(predictionTimeframe: 300.0), // Very long
        ];

        for (final config in configs) {
          expect(config.predictionTimeframe, greaterThan(0.0));
          expect(
            config.predictionTimeframe,
            lessThanOrEqualTo(3600.0),
          ); // Max 1 hour
        }
      });

      test('validates drama level ranges', () {
        const configs = [
          PredictiveOrbitalConfig(dramaLevel: 0.0), // Educational
          PredictiveOrbitalConfig(dramaLevel: 0.3), // Calm
          PredictiveOrbitalConfig(dramaLevel: 0.7), // Default
          PredictiveOrbitalConfig(dramaLevel: 0.9), // Dramatic
          PredictiveOrbitalConfig(dramaLevel: 1.0), // Maximum
        ];

        for (final config in configs) {
          expect(config.dramaLevel, greaterThanOrEqualTo(0.0));
          expect(config.dramaLevel, lessThanOrEqualTo(1.0));
        }
      });

      test('validates movement speed ranges', () {
        const configs = [
          PredictiveOrbitalConfig(movementSpeed: 0.1), // Very slow
          PredictiveOrbitalConfig(movementSpeed: 0.5), // Slow
          PredictiveOrbitalConfig(movementSpeed: 1.0), // Default
          PredictiveOrbitalConfig(movementSpeed: 2.0), // Fast
          PredictiveOrbitalConfig(movementSpeed: 5.0), // Very fast
        ];

        for (final config in configs) {
          expect(config.movementSpeed, greaterThan(0.0));
          expect(
            config.movementSpeed,
            lessThanOrEqualTo(10.0),
          ); // Reasonable max
        }
      });

      test('validates max tracked events ranges', () {
        const configs = [
          PredictiveOrbitalConfig(maxTrackedEvents: 1), // Single focus
          PredictiveOrbitalConfig(maxTrackedEvents: 3), // Default
          PredictiveOrbitalConfig(maxTrackedEvents: 5), // Multiple
          PredictiveOrbitalConfig(maxTrackedEvents: 10), // Many
          PredictiveOrbitalConfig(maxTrackedEvents: 50), // Maximum practical
        ];

        for (final config in configs) {
          expect(config.maxTrackedEvents, greaterThan(0));
          expect(
            config.maxTrackedEvents,
            lessThanOrEqualTo(100),
          ); // Performance limit
        }
      });
    });

    group('edge cases and boundary conditions', () {
      test('handles zero prediction timeframe', () {
        const config = PredictiveOrbitalConfig(predictionTimeframe: 0.0);

        expect(config.predictionTimeframe, equals(0.0));
        // Should still function with other default values
        expect(config.minDramaticScore, equals(0.3));
        expect(config.dramaLevel, equals(0.7));
      });

      test('handles maximum practical values', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 86400.0, // 24 hours
          minDramaticScore: 2.0, // Above normal range
          maxTrackedEvents: 1000, // Very high
          movementSpeed: 100.0, // Extremely fast
          dramaLevel: 5.0, // Way above normal range
        );

        expect(config.predictionTimeframe, equals(86400.0));
        expect(config.minDramaticScore, equals(2.0));
        expect(config.maxTrackedEvents, equals(1000));
        expect(config.movementSpeed, equals(100.0));
        expect(config.dramaLevel, equals(5.0));
      });

      test('handles fractional and decimal values', () {
        const config = PredictiveOrbitalConfig(
          predictionTimeframe: 12.345,
          minDramaticScore: 0.123456789,
          movementSpeed: 1.999999,
          dramaLevel: 0.777777,
        );

        expect(config.predictionTimeframe, equals(12.345));
        expect(config.minDramaticScore, equals(0.123456789));
        expect(config.movementSpeed, equals(1.999999));
        expect(config.dramaLevel, equals(0.777777));
      });

      test('handles special scenario type variations', () {
        final testCases = [
          'Solar System', // With space
          'Three Body', // With space
          'three-body', // With hyphen
          'ThreeBody', // Camel case
          'GALAXY', // All caps
          'Galaxy ', // With trailing space
          ' solarsystem ', // With leading/trailing spaces
        ];

        for (final scenarioType in testCases) {
          final config = PredictiveOrbitalConfig.forScenario(scenarioType);

          // Should not throw and should return valid configuration
          expect(config.predictionTimeframe, greaterThan(0.0));
          expect(config.minDramaticScore, greaterThanOrEqualTo(0.0));
          expect(config.maxTrackedEvents, greaterThan(0));
          expect(config.movementSpeed, greaterThan(0.0));
          expect(config.dramaLevel, greaterThanOrEqualTo(0.0));
        }
      });
    });
  });
}
