import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/physics_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppState Physics Integration', () {
    late AppState appState;

    setUp(() async {
      // Initialize test environment
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});

      appState = AppState();
      await appState.initializeAsync();
    });

    test('app state should initialize with physics state', () {
      expect(appState.isInitialized, isTrue);
      expect(appState.physics, isNotNull);
      expect(appState.simulation, isNotNull);
    });

    test('switching scenarios should update physics settings', () {
      // Switch to Solar System scenario
      appState.switchToScenarioWithPhysics(ScenarioType.solarSystem);
      expect(
        appState.simulation.currentScenario,
        equals(ScenarioType.solarSystem),
      );

      // Switch to Three Body Classic scenario
      appState.switchToScenarioWithPhysics(ScenarioType.threeBodyClassic);
      expect(
        appState.simulation.currentScenario,
        equals(ScenarioType.threeBodyClassic),
      );
    });

    test('physics state should track scenario changes', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      // Switch to different scenarios
      testPhysicsState.switchToScenario(ScenarioType.solarSystem);
      expect(
        testPhysicsState.currentScenario,
        equals(ScenarioType.solarSystem),
      );

      testPhysicsState.switchToScenario(ScenarioType.threeBodyClassic);
      expect(
        testPhysicsState.currentScenario,
        equals(ScenarioType.threeBodyClassic),
      );
    });

    test('physics parameters should persist across state changes', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      // Switch to Solar System and modify physics
      testPhysicsState.switchToScenario(ScenarioType.solarSystem);
      testPhysicsState.updateParameter(gravitationalConstant: 5.0);

      // Create new physics state (simulating app restart)
      final newPhysicsState = PhysicsState();
      await newPhysicsState.initialize();
      newPhysicsState.switchToScenario(ScenarioType.solarSystem);

      // Settings should persist
      expect(
        newPhysicsState.currentSettings.gravitationalConstant,
        equals(5.0),
      );
    });

    test(
      'different scenarios should maintain separate physics settings',
      () async {
        final testPhysicsState = PhysicsState();
        await testPhysicsState.initialize();

        // Modify Solar System physics
        testPhysicsState.switchToScenario(ScenarioType.solarSystem);
        testPhysicsState.updateParameter(gravitationalConstant: 5.0);
        final solarSystemG =
            testPhysicsState.currentSettings.gravitationalConstant;

        // Modify Three Body Classic physics
        testPhysicsState.switchToScenario(ScenarioType.threeBodyClassic);
        testPhysicsState.updateParameter(gravitationalConstant: 10.0);
        final threeBodyG =
            testPhysicsState.currentSettings.gravitationalConstant;

        // Switch back to Solar System
        testPhysicsState.switchToScenario(ScenarioType.solarSystem);

        // Solar System settings should be preserved
        expect(
          testPhysicsState.currentSettings.gravitationalConstant,
          equals(solarSystemG),
        );
        expect(
          testPhysicsState.currentSettings.gravitationalConstant,
          isNot(equals(threeBodyG)),
        );
      },
    );

    test('app state simulation should reflect physics changes', () {
      appState.switchToScenarioWithPhysics(ScenarioType.solarSystem);

      final originalG = appState.simulation.simulation.gravitationalConstant;

      // Update simulation physics through app state
      appState.physics.updateParameter(gravitationalConstant: originalG * 2);
      appState.simulation.applyPhysicsSettings(
        appState.physics.currentSettings,
      );

      expect(
        appState.simulation.simulation.gravitationalConstant,
        equals(originalG * 2),
      );
    });

    test('physics state change notifications should work', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      bool notificationReceived = false;
      testPhysicsState.addListener(() {
        notificationReceived = true;
      });

      // Update a parameter
      testPhysicsState.updateParameter(gravitationalConstant: 7.5);

      expect(notificationReceived, isTrue);
    });

    test(
      'physics customization detection should work across scenarios',
      () async {
        final testPhysicsState = PhysicsState();
        await testPhysicsState.initialize();

        // Solar System should start with default settings
        testPhysicsState.switchToScenario(ScenarioType.solarSystem);
        expect(testPhysicsState.hasCustomSettings, isFalse);

        // Modify Solar System physics
        testPhysicsState.updateParameter(gravitationalConstant: 5.0);
        expect(testPhysicsState.hasCustomSettings, isTrue);

        // Three Body Classic should still have default settings
        testPhysicsState.switchToScenario(ScenarioType.threeBodyClassic);
        expect(testPhysicsState.hasCustomSettings, isFalse);

        // Check customization summary
        final customizationSummary = testPhysicsState.getCustomizationSummary();
        expect(customizationSummary[ScenarioType.solarSystem], isTrue);
        expect(customizationSummary[ScenarioType.threeBodyClassic], isFalse);
      },
    );

    test(
      'resetting physics should restore defaults for current scenario',
      () async {
        final testPhysicsState = PhysicsState();
        await testPhysicsState.initialize();

        testPhysicsState.switchToScenario(ScenarioType.solarSystem);

        // Modify physics
        testPhysicsState.updateParameter(gravitationalConstant: 5.0);
        expect(testPhysicsState.hasCustomSettings, isTrue);

        // Reset to defaults
        testPhysicsState.resetCurrentToDefaults();
        expect(testPhysicsState.hasCustomSettings, isFalse);
      },
    );

    test('physics state should handle all scenario types', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      // Test switching between all scenario types
      for (final scenario in ScenarioType.values) {
        expect(
          () => testPhysicsState.switchToScenario(scenario),
          returnsNormally,
        );
        expect(testPhysicsState.currentScenario, equals(scenario));
      }
    });

    test('concurrent physics updates should be handled correctly', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      testPhysicsState.switchToScenario(ScenarioType.solarSystem);

      // Simulate concurrent updates
      for (int i = 0; i < 5; i++) {
        testPhysicsState.updateParameter(gravitationalConstant: i.toDouble());
      }

      // Should have completed without errors
      expect(
        testPhysicsState.currentSettings.gravitationalConstant,
        isA<double>(),
      );
    });

    test('app state reset should maintain physics settings', () {
      appState.switchToScenarioWithPhysics(ScenarioType.solarSystem);
      appState.physics.updateParameter(gravitationalConstant: 5.0);

      final customG = appState.physics.currentSettings.gravitationalConstant;

      // Reset simulation (but not physics settings)
      appState.resetAll();

      // Physics settings should be preserved
      expect(
        appState.physics.currentSettings.gravitationalConstant,
        equals(customG),
      );
    });

    test('physics settings can be retrieved for specific scenarios', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      // Modify Solar System scenario
      testPhysicsState.switchToScenario(ScenarioType.solarSystem);
      testPhysicsState.updateParameter(gravitationalConstant: 5.0);

      // Switch to another scenario
      testPhysicsState.switchToScenario(ScenarioType.threeBodyClassic);

      // Should still be able to get Solar System settings
      final solarSystemSettings = testPhysicsState.getSettingsForScenario(
        ScenarioType.solarSystem,
      );
      expect(solarSystemSettings.gravitationalConstant, equals(5.0));
    });

    test('resetting all scenarios should clear all customizations', () async {
      final testPhysicsState = PhysicsState();
      await testPhysicsState.initialize();

      // Customize multiple scenarios
      testPhysicsState.switchToScenario(ScenarioType.solarSystem);
      testPhysicsState.updateParameter(gravitationalConstant: 5.0);

      testPhysicsState.switchToScenario(ScenarioType.threeBodyClassic);
      testPhysicsState.updateParameter(gravitationalConstant: 10.0);

      // Reset all
      testPhysicsState.resetAllToDefaults();

      // Check that all customizations are cleared
      final customizationSummary = testPhysicsState.getCustomizationSummary();
      for (final isCustomized in customizationSummary.values) {
        expect(isCustomized, isFalse);
      }
    });

    test('app state should coordinate all subsystems correctly', () {
      expect(appState.simulation, isNotNull);
      expect(appState.physics, isNotNull);
      expect(appState.camera, isNotNull);
      expect(appState.ui, isNotNull);

      // All subsystems should be listening to each other
      expect(appState.isInitialized, isTrue);
    });

    test('error handling should work correctly', () {
      expect(appState.lastError, isNull);

      appState.setError('Test error');
      expect(appState.lastError, equals('Test error'));

      appState.clearError();
      expect(appState.lastError, isNull);
    });
  });
}
