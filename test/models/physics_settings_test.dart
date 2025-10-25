import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/physics_settings.dart';

void main() {
  group('PhysicsSettings', () {
    test('defaults() should create settings from simulation constants', () {
      final defaults = PhysicsSettings.defaults();

      expect(
        defaults.gravitationalConstant,
        equals(SimulationConstants.gravitationalConstant),
      );
      expect(defaults.softening, equals(SimulationConstants.softening));
      expect(
        defaults.collisionRadiusMultiplier,
        equals(SimulationConstants.collisionRadiusMultiplier),
      );
      expect(
        defaults.maxTrailPoints,
        equals(SimulationConstants.maxTrailPoints),
      );
      expect(defaults.trailFadeRate, equals(SimulationConstants.trailFadeRate));
      expect(
        defaults.vibrationThrottleTime,
        equals(SimulationConstants.vibrationThrottleTime),
      );
      expect(defaults.vibrationEnabled, isTrue);
    });

    test('realistic() should create realistic physics settings', () {
      final realistic = PhysicsSettings.realistic();

      expect(realistic.gravitationalConstant, equals(1.2));
      expect(realistic.softening, equals(0.01));
      expect(realistic.collisionRadiusMultiplier, equals(0.2));
      expect(realistic.maxTrailPoints, equals(300));
      expect(realistic.trailFadeRate, equals(0.5));
      expect(realistic.vibrationThrottleTime, equals(0.18));
      expect(realistic.vibrationEnabled, isTrue);
    });

    test('experimental() should create experimental physics settings', () {
      final experimental = PhysicsSettings.experimental();

      expect(
        experimental.gravitationalConstant,
        equals(SimulationConstants.gravitationalConstant),
      );
      expect(experimental.softening, equals(SimulationConstants.softening));
      expect(
        experimental.collisionRadiusMultiplier,
        equals(SimulationConstants.collisionRadiusMultiplier),
      );
      expect(
        experimental.maxTrailPoints,
        equals(SimulationConstants.maxTrailPoints),
      );
      expect(
        experimental.trailFadeRate,
        equals(SimulationConstants.trailFadeRate),
      );
      expect(
        experimental.vibrationThrottleTime,
        equals(SimulationConstants.vibrationThrottleTime),
      );
      expect(experimental.vibrationEnabled, isTrue);
    });

    group('forScenario()', () {
      test('should return realistic settings for educational scenarios', () {
        final solarSystemSettings = PhysicsSettings.forScenario(
          ScenarioType.solarSystem,
        );
        final earthMoonSunSettings = PhysicsSettings.forScenario(
          ScenarioType.earthMoonSun,
        );

        expect(solarSystemSettings.gravitationalConstant, equals(1.2));
        expect(earthMoonSunSettings.gravitationalConstant, equals(1.2));
        expect(solarSystemSettings.softening, equals(0.01));
        expect(earthMoonSunSettings.softening, equals(0.01));
      });

      test('should return experimental settings for sandbox scenarios', () {
        final randomSettings = PhysicsSettings.forScenario(ScenarioType.random);
        final threeBodySettings = PhysicsSettings.forScenario(
          ScenarioType.threeBodyClassic,
        );
        final galaxySettings = PhysicsSettings.forScenario(
          ScenarioType.galaxyFormation,
        );

        expect(
          randomSettings.gravitationalConstant,
          equals(SimulationConstants.gravitationalConstant),
        );
        expect(
          threeBodySettings.gravitationalConstant,
          equals(SimulationConstants.gravitationalConstant),
        );
        expect(
          galaxySettings.gravitationalConstant,
          equals(SimulationConstants.gravitationalConstant),
        );

        // All should now use the reduced collision radius multiplier
        expect(randomSettings.collisionRadiusMultiplier, equals(0.1));
        expect(threeBodySettings.collisionRadiusMultiplier, equals(0.1));
        expect(galaxySettings.collisionRadiusMultiplier, equals(0.1));
      });
    });

    test('copyWith() should create modified copy', () {
      final original = PhysicsSettings.defaults();
      final modified = original.copyWith(
        gravitationalConstant: 5.0,
        softening: 0.05,
        vibrationEnabled: false,
      );

      expect(modified.gravitationalConstant, equals(5.0));
      expect(modified.softening, equals(0.05));
      expect(modified.vibrationEnabled, isFalse);
      // Unchanged values should remain the same
      expect(
        modified.collisionRadiusMultiplier,
        equals(original.collisionRadiusMultiplier),
      );
      expect(modified.maxTrailPoints, equals(original.maxTrailPoints));
      expect(modified.trailFadeRate, equals(original.trailFadeRate));
      expect(
        modified.vibrationThrottleTime,
        equals(original.vibrationThrottleTime),
      );
    });

    test('isDifferentFromDefaults() should detect differences correctly', () {
      const scenario = ScenarioType.solarSystem;
      final defaults = PhysicsSettings.forScenario(scenario);
      final modified = defaults.copyWith(gravitationalConstant: 10.0);

      expect(defaults.isDifferentFromDefaults(scenario), isFalse);
      expect(modified.isDifferentFromDefaults(scenario), isTrue);
    });

    test('toMap() and fromMap() should serialize/deserialize correctly', () {
      final original = PhysicsSettings(
        gravitationalConstant: 2.5,
        softening: 0.02,
        collisionRadiusMultiplier: 0.3,
        maxTrailPoints: 400,
        trailFadeRate: 0.7,
        vibrationThrottleTime: 0.2,
        vibrationEnabled: false,
      );

      final map = original.toMap();
      final restored = PhysicsSettings.fromMap(map);

      expect(
        restored.gravitationalConstant,
        equals(original.gravitationalConstant),
      );
      expect(restored.softening, equals(original.softening));
      expect(
        restored.collisionRadiusMultiplier,
        equals(original.collisionRadiusMultiplier),
      );
      expect(restored.maxTrailPoints, equals(original.maxTrailPoints));
      expect(restored.trailFadeRate, equals(original.trailFadeRate));
      expect(
        restored.vibrationThrottleTime,
        equals(original.vibrationThrottleTime),
      );
      expect(restored.vibrationEnabled, equals(original.vibrationEnabled));
    });

    test('fromMap() should handle missing values with defaults', () {
      final incomplete = <String, dynamic>{
        'gravitationalConstant': 3.0,
        'softening': 0.03,
        // Missing other values
      };

      final settings = PhysicsSettings.fromMap(incomplete);

      expect(settings.gravitationalConstant, equals(3.0));
      expect(settings.softening, equals(0.03));
      expect(
        settings.collisionRadiusMultiplier,
        equals(SimulationConstants.collisionRadiusMultiplier),
      );
      expect(
        settings.maxTrailPoints,
        equals(SimulationConstants.maxTrailPoints),
      );
      expect(settings.trailFadeRate, equals(SimulationConstants.trailFadeRate));
      expect(
        settings.vibrationThrottleTime,
        equals(SimulationConstants.vibrationThrottleTime),
      );
      expect(settings.vibrationEnabled, isTrue);
    });

    test('equality operator should work correctly', () {
      final settings1 = PhysicsSettings.defaults();
      final settings2 = PhysicsSettings.defaults();
      final settings3 = settings1.copyWith(gravitationalConstant: 5.0);

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });

    test('hashCode should be consistent with equality', () {
      final settings1 = PhysicsSettings.defaults();
      final settings2 = PhysicsSettings.defaults();
      final settings3 = settings1.copyWith(gravitationalConstant: 5.0);

      expect(settings1.hashCode, equals(settings2.hashCode));
      expect(settings1.hashCode, isNot(equals(settings3.hashCode)));
    });

    test('toString() should provide readable representation', () {
      final settings = PhysicsSettings.defaults();
      final string = settings.toString();

      expect(string, contains('PhysicsSettings'));
      expect(string, contains('gravitationalConstant'));
      expect(string, contains('softening'));
      expect(string, contains('collisionRadiusMultiplier'));
      expect(string, contains('maxTrailPoints'));
      expect(string, contains('trailFadeRate'));
      expect(string, contains('vibrationThrottleTime'));
      expect(string, contains('vibrationEnabled'));
    });
  });
}
