import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:graviton/state/physics_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PhysicsState', () {
    late PhysicsState physicsState;

    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      physicsState = PhysicsState();
    });

    test('should initialize with default settings', () {
      expect(physicsState.currentSettings, equals(PhysicsSettings.defaults()));
      expect(physicsState.currentScenario, equals(ScenarioType.random));
    });

    test(
      'switchToScenario() should load scenario-appropriate defaults',
      () async {
        await physicsState.initialize();

        // Switch to solar system (realistic scenario)
        physicsState.switchToScenario(ScenarioType.solarSystem);

        expect(physicsState.currentScenario, equals(ScenarioType.solarSystem));
        expect(physicsState.currentSettings.gravitationalConstant, equals(1.2));
        expect(physicsState.currentSettings.softening, equals(0.01));
        expect(
          physicsState.currentSettings.maxTrailPoints,
          equals(300),
        ); // Realistic uses 300

        // Switch to random (experimental scenario)
        physicsState.switchToScenario(ScenarioType.random);

        expect(physicsState.currentScenario, equals(ScenarioType.random));
        expect(
          physicsState.currentSettings.gravitationalConstant,
          equals(1.2),
        ); // Same as SimulationConstants
        expect(
          physicsState.currentSettings.maxTrailPoints,
          equals(500),
        ); // Experimental uses 500
      },
    );

    test(
      'updateCurrentSettings() should update and persist settings',
      () async {
        await physicsState.initialize();
        physicsState.switchToScenario(ScenarioType.solarSystem);

        final customSettings = PhysicsSettings(
          gravitationalConstant: 5.0,
          softening: 0.05,
          collisionRadiusMultiplier: 0.5,
          maxTrailPoints: 600,
          trailFadeRate: 1.0,
          vibrationThrottleTime: 0.3,
          vibrationEnabled: false,
        );

        physicsState.updateCurrentSettings(customSettings);

        expect(physicsState.currentSettings, equals(customSettings));
        expect(physicsState.hasCustomSettings, isTrue);
      },
    );

    test('updateParameter() should update individual parameters', () async {
      await physicsState.initialize();
      physicsState.switchToScenario(ScenarioType.solarSystem);

      final originalSettings = physicsState.currentSettings;

      physicsState.updateParameter(
        gravitationalConstant: 7.5,
        vibrationEnabled: false,
      );

      expect(physicsState.currentSettings.gravitationalConstant, equals(7.5));
      expect(physicsState.currentSettings.vibrationEnabled, isFalse);
      // Other parameters should remain unchanged
      expect(
        physicsState.currentSettings.softening,
        equals(originalSettings.softening),
      );
      expect(
        physicsState.currentSettings.collisionRadiusMultiplier,
        equals(originalSettings.collisionRadiusMultiplier),
      );
    });

    test('resetCurrentToDefaults() should restore scenario defaults', () async {
      await physicsState.initialize();
      physicsState.switchToScenario(ScenarioType.solarSystem);

      // Customize settings
      physicsState.updateParameter(gravitationalConstant: 10.0);
      expect(physicsState.hasCustomSettings, isTrue);

      // Reset to defaults
      physicsState.resetCurrentToDefaults();

      expect(physicsState.hasCustomSettings, isFalse);
      expect(
        physicsState.currentSettings.gravitationalConstant,
        equals(1.2),
      ); // Solar system default
    });

    test('resetAllToDefaults() should clear all customizations', () async {
      await physicsState.initialize();

      // Customize multiple scenarios
      physicsState.switchToScenario(ScenarioType.solarSystem);
      physicsState.updateParameter(gravitationalConstant: 10.0);

      physicsState.switchToScenario(ScenarioType.random);
      physicsState.updateParameter(softening: 0.1);

      // Reset all
      physicsState.resetAllToDefaults();

      // Check that customizations are cleared
      physicsState.switchToScenario(ScenarioType.solarSystem);
      expect(physicsState.hasCustomSettings, isFalse);

      physicsState.switchToScenario(ScenarioType.random);
      expect(physicsState.hasCustomSettings, isFalse);
    });

    test('hasCustomSettings should correctly detect customizations', () async {
      await physicsState.initialize();
      physicsState.switchToScenario(ScenarioType.solarSystem);

      expect(physicsState.hasCustomSettings, isFalse);

      physicsState.updateParameter(gravitationalConstant: 5.0);
      expect(physicsState.hasCustomSettings, isTrue);

      physicsState.resetCurrentToDefaults();
      expect(physicsState.hasCustomSettings, isFalse);
    });

    test('getSettingsForScenario() should return correct settings', () async {
      await physicsState.initialize();

      // Customize solar system
      physicsState.switchToScenario(ScenarioType.solarSystem);
      physicsState.updateParameter(gravitationalConstant: 8.0);

      // Switch to different scenario
      physicsState.switchToScenario(ScenarioType.random);

      // Should still return customized settings for solar system
      final solarSystemSettings = physicsState.getSettingsForScenario(
        ScenarioType.solarSystem,
      );
      expect(solarSystemSettings.gravitationalConstant, equals(8.0));

      // Should return defaults for uncustomized scenario
      final binaryStarSettings = physicsState.getSettingsForScenario(
        ScenarioType.binaryStars,
      );
      expect(
        binaryStarSettings,
        equals(PhysicsSettings.forScenario(ScenarioType.binaryStars)),
      );
    });

    test(
      'getCustomizationSummary() should return correct customization status',
      () async {
        await physicsState.initialize();

        // Customize two scenarios
        physicsState.switchToScenario(ScenarioType.solarSystem);
        physicsState.updateParameter(gravitationalConstant: 5.0);

        physicsState.switchToScenario(ScenarioType.random);
        physicsState.updateParameter(softening: 0.1);

        final summary = physicsState.getCustomizationSummary();

        expect(summary[ScenarioType.solarSystem], isTrue);
        expect(summary[ScenarioType.random], isTrue);
        expect(summary[ScenarioType.binaryStars], isFalse);
        expect(summary[ScenarioType.earthMoonSun], isFalse);
      },
    );

    test('should persist and restore settings across sessions', () async {
      // Create first instance and customize settings
      final physicsState1 = PhysicsState();
      await physicsState1.initialize();

      physicsState1.switchToScenario(ScenarioType.solarSystem);
      physicsState1.updateParameter(
        gravitationalConstant: 6.0,
        softening: 0.02,
        vibrationEnabled: false,
      );

      physicsState1.switchToScenario(ScenarioType.random);
      physicsState1.updateParameter(collisionRadiusMultiplier: 0.8);

      // Create new instance and verify persistence
      final physicsState2 = PhysicsState();
      await physicsState2.initialize();

      physicsState2.switchToScenario(ScenarioType.solarSystem);
      expect(physicsState2.currentSettings.gravitationalConstant, equals(6.0));
      expect(physicsState2.currentSettings.softening, equals(0.02));
      expect(physicsState2.currentSettings.vibrationEnabled, isFalse);

      physicsState2.switchToScenario(ScenarioType.random);
      expect(
        physicsState2.currentSettings.collisionRadiusMultiplier,
        equals(0.8),
      );
    });

    test('should handle corrupted preferences gracefully', () async {
      // Set invalid JSON in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'physics_settings_per_scenario': 'invalid json',
      });

      final physicsState = PhysicsState();

      // Should not throw and should use defaults
      await expectLater(() => physicsState.initialize(), returnsNormally);
      expect(physicsState.currentSettings, equals(PhysicsSettings.defaults()));
    });

    test('should notify listeners when settings change', () async {
      await physicsState.initialize();

      var notificationCount = 0;
      physicsState.addListener(() => notificationCount++);

      physicsState.switchToScenario(ScenarioType.solarSystem);
      expect(notificationCount, equals(1));

      physicsState.updateParameter(gravitationalConstant: 5.0);
      expect(notificationCount, equals(2));

      physicsState.resetCurrentToDefaults();
      expect(notificationCount, equals(3));

      physicsState.resetAllToDefaults();
      expect(notificationCount, equals(4));
    });

    test('should handle all scenario types correctly', () async {
      await physicsState.initialize();

      // Test all scenario types
      for (final scenario in ScenarioType.values) {
        physicsState.switchToScenario(scenario);
        expect(physicsState.currentScenario, equals(scenario));

        // Should have appropriate defaults
        final expectedDefaults = PhysicsSettings.forScenario(scenario);
        expect(physicsState.currentSettings, equals(expectedDefaults));

        // Should be able to customize
        physicsState.updateParameter(gravitationalConstant: 99.0);
        expect(
          physicsState.currentSettings.gravitationalConstant,
          equals(99.0),
        );
        expect(physicsState.hasCustomSettings, isTrue);

        // Should be able to reset
        physicsState.resetCurrentToDefaults();
        expect(physicsState.hasCustomSettings, isFalse);
      }
    });
  });
}
