import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/educational_focus_keys.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('ScenarioConfig', () {
    group('constructor and properties', () {
      test('creates instance with all required properties', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.edit,
          primaryColor: Colors.purple,
          expectedBodyCount: 5,
          educationalFocus: EducationalFocusKeys.chaoticDynamics,
        );

        expect(config.type, equals(ScenarioType.custom));
        expect(config.icon, equals(Icons.edit));
        expect(config.primaryColor, equals(Colors.purple));
        expect(config.expectedBodyCount, equals(5));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.chaoticDynamics),
        );
        expect(config.optimalCameraDistance, isNull);
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });

      test('creates instance with optional camera distance', () {
        const config = ScenarioConfig(
          type: ScenarioType.solarSystem,
          icon: Icons.wb_sunny,
          primaryColor: AppColors.celestialOrange,
          expectedBodyCount: 9,
          educationalFocus: EducationalFocusKeys.planetaryMotion,
          optimalCameraDistance: 1500.0,
        );

        expect(config.optimalCameraDistance, equals(1500.0));
        expect(config.cameraDistanceMultiplier, equals(1.2)); // Default
      });

      test('creates instance with custom camera distance multiplier', () {
        const config = ScenarioConfig(
          type: ScenarioType.galaxyFormation,
          icon: Icons.blur_circular,
          primaryColor: AppColors.celestialPink,
          expectedBodyCount: 50,
          educationalFocus: EducationalFocusKeys.structureFormation,
          cameraDistanceMultiplier: 2.5,
        );

        expect(config.cameraDistanceMultiplier, equals(2.5));
        expect(config.optimalCameraDistance, isNull);
      });

      test('creates instance with both camera properties', () {
        const config = ScenarioConfig(
          type: ScenarioType.earthMoonSun,
          icon: Icons.public,
          primaryColor: AppColors.celestialTeal,
          expectedBodyCount: 3,
          educationalFocus: EducationalFocusKeys.realWorldSystem,
          optimalCameraDistance: 800.0,
          cameraDistanceMultiplier: 1.5,
        );

        expect(config.optimalCameraDistance, equals(800.0));
        expect(config.cameraDistanceMultiplier, equals(1.5));
      });
    });

    group('default configurations', () {
      test('contains all scenario types', () {
        final expectedTypes = [
          ScenarioType.random,
          ScenarioType.earthMoonSun,
          ScenarioType.binaryStars,
          ScenarioType.asteroidBelt,
          ScenarioType.galaxyFormation,
          ScenarioType.solarSystem,
        ];

        for (final type in expectedTypes) {
          expect(
            ScenarioConfig.defaults.containsKey(type),
            isTrue,
            reason: 'Default config should exist for $type',
          );
        }
      });

      test('random scenario configuration', () {
        final config = ScenarioConfig.defaults[ScenarioType.random]!;

        expect(config.type, equals(ScenarioType.random));
        expect(config.icon, equals(Icons.shuffle));
        expect(config.primaryColor, equals(AppColors.celestialAmber));
        expect(config.expectedBodyCount, equals(4));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.chaoticDynamics),
        );
        expect(config.optimalCameraDistance, isNull);
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });

      test('earth-moon-sun scenario configuration', () {
        final config = ScenarioConfig.defaults[ScenarioType.earthMoonSun]!;

        expect(config.type, equals(ScenarioType.earthMoonSun));
        expect(config.icon, equals(Icons.public));
        expect(config.primaryColor, equals(AppColors.celestialTeal));
        expect(config.expectedBodyCount, equals(3));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.realWorldSystem),
        );
        expect(config.optimalCameraDistance, isNull);
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });

      test('binary stars scenario configuration', () {
        final config = ScenarioConfig.defaults[ScenarioType.binaryStars]!;

        expect(config.type, equals(ScenarioType.binaryStars));
        expect(config.icon, equals(Icons.brightness_7));
        expect(config.primaryColor, equals(AppColors.celestialRed));
        expect(config.expectedBodyCount, equals(4));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.binaryOrbits),
        );
        expect(config.optimalCameraDistance, isNull);
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });

      test('asteroid belt scenario configuration', () {
        final config = ScenarioConfig.defaults[ScenarioType.asteroidBelt]!;

        expect(config.type, equals(ScenarioType.asteroidBelt));
        expect(config.icon, equals(Icons.scatter_plot));
        expect(config.primaryColor, equals(AppColors.celestialBlue));
        expect(config.expectedBodyCount, equals(3));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.manyBodyDynamics),
        );
        expect(config.optimalCameraDistance, isNull);
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });

      test('galaxy formation scenario configuration', () {
        final config = ScenarioConfig.defaults[ScenarioType.galaxyFormation]!;

        expect(config.type, equals(ScenarioType.galaxyFormation));
        expect(config.icon, equals(Icons.blur_circular));
        expect(config.primaryColor, equals(AppColors.celestialPink));
        expect(config.expectedBodyCount, equals(31));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.structureFormation),
        );
        expect(config.optimalCameraDistance, equals(600.0));
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });

      test('solar system scenario configuration', () {
        final config = ScenarioConfig.defaults[ScenarioType.solarSystem]!;

        expect(config.type, equals(ScenarioType.solarSystem));
        expect(config.icon, equals(Icons.wb_sunny));
        expect(config.primaryColor, equals(AppColors.celestialOrange));
        expect(config.expectedBodyCount, equals(9));
        expect(
          config.educationalFocus,
          equals(EducationalFocusKeys.planetaryMotion),
        );
        expect(config.optimalCameraDistance, equals(1200.0));
        expect(config.cameraDistanceMultiplier, equals(1.2));
      });
    });

    group('scenario type and icon relationships', () {
      test('each scenario has appropriate icon for its type', () {
        final iconMappings = {
          ScenarioType.random: Icons.shuffle, // Random/chaotic
          ScenarioType.earthMoonSun: Icons.public, // Earth/world system
          ScenarioType.binaryStars: Icons.brightness_7, // Stellar/bright
          ScenarioType.asteroidBelt: Icons.scatter_plot, // Scattered objects
          ScenarioType.galaxyFormation: Icons.blur_circular, // Large structure
          ScenarioType.solarSystem: Icons.wb_sunny, // Solar/sun centered
        };

        for (final entry in iconMappings.entries) {
          final config = ScenarioConfig.defaults[entry.key]!;
          expect(
            config.icon,
            equals(entry.value),
            reason: '${entry.key} should use ${entry.value}',
          );
        }
      });

      test('each scenario has appropriate color for its theme', () {
        final colorMappings = {
          ScenarioType.random:
              AppColors.celestialAmber, // Chaotic/unpredictable
          ScenarioType.earthMoonSun: AppColors.celestialTeal, // Earth/water
          ScenarioType.binaryStars: AppColors.celestialRed, // Hot/energetic
          ScenarioType.asteroidBelt: AppColors.celestialBlue, // Space/cold
          ScenarioType.galaxyFormation: AppColors.celestialPink, // Cosmic/vast
          ScenarioType.solarSystem: AppColors.celestialOrange, // Solar/warm
        };

        for (final entry in colorMappings.entries) {
          final config = ScenarioConfig.defaults[entry.key]!;
          expect(
            config.primaryColor,
            equals(entry.value),
            reason: '${entry.key} should use ${entry.value}',
          );
        }
      });
    });

    group('educational focus mapping', () {
      test('each scenario targets appropriate educational concept', () {
        final educationalMappings = {
          ScenarioType.random: EducationalFocusKeys.chaoticDynamics,
          ScenarioType.earthMoonSun: EducationalFocusKeys.realWorldSystem,
          ScenarioType.binaryStars: EducationalFocusKeys.binaryOrbits,
          ScenarioType.asteroidBelt: EducationalFocusKeys.manyBodyDynamics,
          ScenarioType.galaxyFormation: EducationalFocusKeys.structureFormation,
          ScenarioType.solarSystem: EducationalFocusKeys.planetaryMotion,
        };

        for (final entry in educationalMappings.entries) {
          final config = ScenarioConfig.defaults[entry.key]!;
          expect(
            config.educationalFocus,
            equals(entry.value),
            reason: '${entry.key} should focus on ${entry.value}',
          );
        }
      });

      test('educational focus keys are valid strings', () {
        for (final config in ScenarioConfig.defaults.values) {
          expect(config.educationalFocus, isA<String>());
          expect(config.educationalFocus.isNotEmpty, isTrue);
          expect(
            config.educationalFocus.trim(),
            equals(config.educationalFocus),
          );
        }
      });
    });

    group('expected body count validation', () {
      test('body counts are realistic for each scenario type', () {
        final expectedRanges = {
          ScenarioType.random: (min: 3, max: 10), // Reasonable chaos
          ScenarioType.earthMoonSun: (min: 3, max: 3), // Exactly 3 bodies
          ScenarioType.binaryStars: (min: 2, max: 6), // Binary + planets
          ScenarioType.asteroidBelt: (
            min: 3,
            max: 20,
          ), // Central body + asteroids
          ScenarioType.galaxyFormation: (min: 20, max: 100), // Many particles
          ScenarioType.solarSystem: (min: 8, max: 15), // Planets + moons
        };

        for (final entry in expectedRanges.entries) {
          final config = ScenarioConfig.defaults[entry.key]!;
          final range = entry.value;

          expect(
            config.expectedBodyCount,
            greaterThanOrEqualTo(range.min),
            reason: '${entry.key} should have at least ${range.min} bodies',
          );
          expect(
            config.expectedBodyCount,
            lessThanOrEqualTo(range.max),
            reason: '${entry.key} should have at most ${range.max} bodies',
          );
        }
      });

      test('all body counts are positive integers', () {
        for (final config in ScenarioConfig.defaults.values) {
          expect(config.expectedBodyCount, greaterThan(0));
          expect(config.expectedBodyCount, isA<int>());
        }
      });
    });

    group('camera configuration validation', () {
      test('scenarios with fixed camera distances have reasonable values', () {
        final scenariosWithFixedCamera = [
          ScenarioType.galaxyFormation,
          ScenarioType.solarSystem,
        ];

        for (final type in scenariosWithFixedCamera) {
          final config = ScenarioConfig.defaults[type]!;
          expect(
            config.optimalCameraDistance,
            isNotNull,
            reason: '$type should have fixed camera distance',
          );
          expect(config.optimalCameraDistance!, greaterThan(0));
          expect(
            config.optimalCameraDistance!,
            lessThan(10000),
          ); // Reasonable upper bound
        }
      });

      test('scenarios without fixed camera distances use auto-calculation', () {
        final scenariosWithAutoCamera = [
          ScenarioType.random,
          ScenarioType.earthMoonSun,
          ScenarioType.binaryStars,
          ScenarioType.asteroidBelt,
        ];

        for (final type in scenariosWithAutoCamera) {
          final config = ScenarioConfig.defaults[type]!;
          expect(
            config.optimalCameraDistance,
            isNull,
            reason: '$type should use auto-calculated camera distance',
          );
        }
      });

      test('all camera distance multipliers are reasonable', () {
        for (final config in ScenarioConfig.defaults.values) {
          expect(config.cameraDistanceMultiplier, greaterThan(0));
          expect(
            config.cameraDistanceMultiplier,
            lessThanOrEqualTo(5.0),
          ); // Reasonable upper bound
        }
      });

      test('default camera distance multiplier is applied consistently', () {
        for (final config in ScenarioConfig.defaults.values) {
          expect(config.cameraDistanceMultiplier, equals(1.2));
        }
      });
    });

    group('realistic scenario configurations', () {
      test('educational space exploration scenario', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.rocket_launch,
          primaryColor: Colors.deepPurple,
          expectedBodyCount: 12,
          educationalFocus: EducationalFocusKeys.realWorldSystem,
          optimalCameraDistance: 2000.0,
          cameraDistanceMultiplier: 1.8,
        );

        expect(config.type, equals(ScenarioType.custom));
        expect(config.icon, equals(Icons.rocket_launch));
        expect(config.expectedBodyCount, equals(12));
        expect(config.optimalCameraDistance, equals(2000.0));
        expect(config.cameraDistanceMultiplier, equals(1.8));
      });

      test('high-performance gaming scenario', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.speed,
          primaryColor: Colors.red,
          expectedBodyCount: 3,
          educationalFocus: EducationalFocusKeys.chaoticDynamics,
          cameraDistanceMultiplier: 0.8, // Closer for action
        );

        expect(
          config.expectedBodyCount,
          equals(3),
        ); // Few bodies for performance
        expect(config.cameraDistanceMultiplier, equals(0.8)); // Closer view
        expect(config.optimalCameraDistance, isNull); // Auto-calculated
      });

      test('research demonstration scenario', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.science,
          primaryColor: Colors.teal,
          expectedBodyCount: 100,
          educationalFocus: EducationalFocusKeys.structureFormation,
          optimalCameraDistance: 5000.0,
          cameraDistanceMultiplier: 3.0, // Far view for overview
        );

        expect(
          config.expectedBodyCount,
          equals(100),
        ); // Many bodies for research
        expect(
          config.optimalCameraDistance,
          equals(5000.0),
        ); // Fixed far distance
        expect(config.cameraDistanceMultiplier, equals(3.0)); // Wide overview
      });
    });

    group('edge cases and boundary conditions', () {
      test('handles minimum body count', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.adjust,
          primaryColor: Colors.grey,
          expectedBodyCount: 1,
          educationalFocus: EducationalFocusKeys.chaoticDynamics,
        );

        expect(config.expectedBodyCount, equals(1));
        expect(() => config.expectedBodyCount, returnsNormally);
      });

      test('handles maximum reasonable body count', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.apps,
          primaryColor: Colors.grey,
          expectedBodyCount: 1000,
          educationalFocus: EducationalFocusKeys.manyBodyDynamics,
        );

        expect(config.expectedBodyCount, equals(1000));
        expect(() => config.expectedBodyCount, returnsNormally);
      });

      test('handles extreme camera distances', () {
        const configs = [
          ScenarioConfig(
            type: ScenarioType.custom,
            icon: Icons.zoom_out,
            primaryColor: Colors.grey,
            expectedBodyCount: 5,
            educationalFocus: EducationalFocusKeys.chaoticDynamics,
            optimalCameraDistance: 0.1, // Very close
          ),
          ScenarioConfig(
            type: ScenarioType.custom,
            icon: Icons.zoom_in,
            primaryColor: Colors.grey,
            expectedBodyCount: 5,
            educationalFocus: EducationalFocusKeys.chaoticDynamics,
            optimalCameraDistance: 1000000.0, // Very far
          ),
        ];

        for (final config in configs) {
          expect(config.optimalCameraDistance, isNotNull);
          expect(config.optimalCameraDistance!, greaterThan(0));
        }
      });

      test('handles extreme camera multipliers', () {
        const configs = [
          ScenarioConfig(
            type: ScenarioType.custom,
            icon: Icons.close,
            primaryColor: Colors.grey,
            expectedBodyCount: 5,
            educationalFocus: EducationalFocusKeys.chaoticDynamics,
            cameraDistanceMultiplier: 0.1, // Very tight
          ),
          ScenarioConfig(
            type: ScenarioType.custom,
            icon: Icons.open_in_full,
            primaryColor: Colors.grey,
            expectedBodyCount: 5,
            educationalFocus: EducationalFocusKeys.chaoticDynamics,
            cameraDistanceMultiplier: 100.0, // Very wide
          ),
        ];

        for (final config in configs) {
          expect(config.cameraDistanceMultiplier, greaterThan(0));
        }
      });

      test('handles special unicode characters in educational focus', () {
        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.school,
          primaryColor: Colors.blue,
          expectedBodyCount: 5,
          educationalFocus: '🌟 αβγ δε Stellar Dynamics & Mechanics 🚀',
        );

        expect(config.educationalFocus, contains('🌟'));
        expect(config.educationalFocus, contains('αβγ'));
        expect(config.educationalFocus, contains('🚀'));
      });

      test('handles very long educational focus descriptions', () {
        const longEducationalFocus =
            'This is an extremely detailed educational focus that encompasses multiple learning objectives including orbital mechanics, gravitational interactions, chaotic dynamics, energy conservation, momentum transfer, tidal effects, relativistic corrections, and computational physics methodologies for advanced students';

        const config = ScenarioConfig(
          type: ScenarioType.custom,
          icon: Icons.book,
          primaryColor: Colors.indigo,
          expectedBodyCount: 8,
          educationalFocus: longEducationalFocus,
        );

        expect(config.educationalFocus, equals(longEducationalFocus));
        expect(config.educationalFocus.length, greaterThan(200));
      });
    });

    group('configuration consistency validation', () {
      test('all default configurations have unique types', () {
        final types = ScenarioConfig.defaults.keys.toSet();
        expect(
          types.length,
          equals(ScenarioConfig.defaults.length),
          reason: 'All scenario types should be unique',
        );
      });

      test('all default configurations have valid colors', () {
        for (final config in ScenarioConfig.defaults.values) {
          // Color values are valid integers
          expect(config.primaryColor, isA<Color>());
          expect(
            config.primaryColor.a,
            equals(1.0),
          ); // Should be opaque (1.0 = 100% alpha)
        }
      });

      test('all default configurations have valid icons', () {
        for (final config in ScenarioConfig.defaults.values) {
          expect(config.icon.codePoint, isA<int>());
          expect(config.icon.codePoint, greaterThan(0));
        }
      });

      test('scenario type matches configuration type', () {
        for (final entry in ScenarioConfig.defaults.entries) {
          expect(
            entry.value.type,
            equals(entry.key),
            reason: 'Config type should match map key',
          );
        }
      });
    });
  });
}
