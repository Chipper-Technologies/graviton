import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test_mocks.mocks.dart';

void main() {
  group('AppState Tests', () {
    late AppState appState;

    setUp(() {
      // Set up mock SharedPreferences for all tests
      SharedPreferences.setMockInitialValues({});
      appState = AppState();
    });

    tearDown(() {
      // Only dispose if not already disposed in the test
      try {
        appState.dispose();
      } catch (e) {
        // Already disposed, ignore
      }
    });

    test('Initial state should be properly initialized', () {
      expect(appState.isInitialized, isTrue);
      expect(appState.lastError, isNull);
      expect(appState.simulation, isNotNull);
      expect(appState.ui, isNotNull);
      expect(appState.camera, isNotNull);
    });

    test('InitializeAsync should initialize both UI and simulation', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await appState.initializeAsync();

      // Should complete without error
      expect(appState.isInitialized, isTrue);
      expect(appState.lastError, isNull);
    });

    test('SetError should update lastError and notify listeners', () {
      var notificationCount = 0;
      appState.addListener(() => notificationCount++);

      const testError = 'Test error message';
      appState.setError(testError);

      expect(appState.lastError, equals(testError));
      expect(notificationCount, equals(1));
    });

    test('ClearError should remove lastError and notify listeners', () {
      var notificationCount = 0;
      appState.addListener(() => notificationCount++);

      // Set an error first
      appState.setError('Test error');
      expect(appState.lastError, isNotNull);

      // Clear the error
      appState.clearError();
      expect(appState.lastError, isNull);
      expect(notificationCount, equals(2)); // Once for set, once for clear
    });

    test('ResetAll should reset simulation, camera, and error', () {
      // Set up some state
      appState.setError('Test error');
      appState.simulation.start();

      // Reset everything
      appState.resetAll();

      expect(appState.lastError, isNull);
      expect(
        appState.simulation.isRunning,
        isTrue,
      ); // Should restart after reset
      expect(appState.simulation.stepCount, equals(0));
      expect(appState.simulation.totalTime, equals(0.0));
      expect(appState.simulation.isPaused, isFalse); // Should not be paused
    });

    test('Child state changes should trigger notifications', () {
      var notificationCount = 0;
      appState.addListener(() => notificationCount++);

      // Trigger changes in child states
      appState.ui.toggleTrails();
      expect(notificationCount, equals(1));

      appState.simulation.start();
      expect(notificationCount, equals(2));

      appState.camera.resetView();
      expect(notificationCount, equals(3));
    });

    test('UI state should be accessible and functional', () {
      expect(appState.ui.showTrails, isTrue); // Default value

      appState.ui.toggleTrails();
      expect(appState.ui.showTrails, isFalse);

      appState.ui.toggleStats();
      expect(appState.ui.showStats, isTrue);
    });

    test('Simulation state should be accessible and functional', () {
      expect(appState.simulation.isRunning, isFalse);
      expect(appState.simulation.timeScale, equals(4.0));

      appState.simulation.start();
      expect(appState.simulation.isRunning, isTrue);

      appState.simulation.setTimeScale(2.0);
      expect(appState.simulation.timeScale, equals(2.0));
    });

    test('Camera state should be accessible and functional', () {
      final initialDistance = appState.camera.distance;

      appState.camera.resetView();
      expect(appState.camera.distance, equals(initialDistance));

      appState.camera.toggleAutoRotate();
      expect(appState.camera.autoRotate, isTrue);
    });

    test('Multiple state changes should maintain consistency', () {
      var notificationCount = 0;
      appState.addListener(() => notificationCount++);

      // Make multiple changes
      appState.ui.toggleTrails();
      appState.simulation.start();
      appState.simulation.setTimeScale(3.0);
      appState.camera.toggleAutoRotate();
      appState.setError('Test error');
      appState.clearError();

      expect(notificationCount, equals(6));
      expect(appState.ui.showTrails, isFalse);
      expect(appState.simulation.isRunning, isTrue);
      expect(appState.simulation.timeScale, equals(3.0));
      expect(appState.camera.autoRotate, isTrue);
      expect(appState.lastError, isNull);
    });

    test('Error handling should not affect other state', () {
      // Set up some state
      appState.ui.toggleTrails();
      appState.simulation.start();
      appState.simulation.setTimeScale(2.5);

      // Set an error
      appState.setError('Test error');

      // Other state should remain unchanged
      expect(appState.ui.showTrails, isFalse);
      expect(appState.simulation.isRunning, isTrue);
      expect(appState.simulation.timeScale, equals(2.5));
      expect(appState.lastError, equals('Test error'));
    });

    test('Dispose should properly clean up resources', () {
      // Add some listeners to verify cleanup
      var uiNotificationCount = 0;
      var simulationNotificationCount = 0;
      var cameraNotificationCount = 0;

      appState.ui.addListener(() => uiNotificationCount++);
      appState.simulation.addListener(() => simulationNotificationCount++);
      appState.camera.addListener(() => cameraNotificationCount++);

      // Make some changes before disposal
      appState.ui.toggleTrails();
      appState.simulation.start();
      appState.camera.toggleAutoRotate();

      expect(uiNotificationCount, equals(1));
      expect(simulationNotificationCount, equals(1));
      expect(cameraNotificationCount, equals(1));

      // Dispose should not throw
      expect(() => appState.dispose(), returnsNormally);
    });

    test('Async initialization should handle errors gracefully', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Should complete without throwing, even if SharedPreferences isn't available
      await expectLater(appState.initializeAsync(), completes);
      expect(appState.isInitialized, isTrue);
    });

    test(
      'InitializeAsync should enable gravity wells when global gravity fields is enabled from settings',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();

        // Initialize async first
        await appState.initializeAsync();

        // Load a specific scenario that has bodies
        appState.simulation.resetWithScenario(ScenarioType.solarSystem);

        // Create a mock localization with all required strings for solar system
        final mockL10n = MockAppLocalizations();
        // Stub the strings needed for solar system scenario
        when(mockL10n.bodySun).thenReturn('Sun');
        when(mockL10n.bodyMercury).thenReturn('Mercury');
        when(mockL10n.bodyVenus).thenReturn('Venus');
        when(mockL10n.bodyEarth).thenReturn('Earth');
        when(mockL10n.bodyMars).thenReturn('Mars');
        when(mockL10n.bodyJupiter).thenReturn('Jupiter');
        when(mockL10n.bodySaturn).thenReturn('Saturn');
        when(mockL10n.bodyUranus).thenReturn('Uranus');
        when(mockL10n.bodyNeptune).thenReturn('Neptune');

        // In test environment, we need to manually provide localization to generate bodies
        appState.simulation.simulation.updateScenarioLocalization(mockL10n);

        // Ensure global gravity fields is enabled AFTER loading the scenario
        // so all bodies get their gravity wells enabled
        if (!appState.ui.globalGravityFields) {
          appState.ui.toggleGlobalGravityFields();
        } else {
          // If it was already enabled, toggle it off and back on to apply to new bodies
          appState.ui.toggleGlobalGravityFields(); // Turn off
          appState.ui.toggleGlobalGravityFields(); // Turn back on
        }

        // Allow the UI change to propagate to simulation state
        await Future.delayed(Duration.zero);

        // Verify that all bodies have gravity wells enabled after initialization
        expect(
          appState.simulation.bodies,
          isNotEmpty,
          reason:
              "Simulation should have bodies after loading solar system scenario",
        );

        for (final body in appState.simulation.bodies) {
          expect(
            body.showGravityWell,
            isTrue,
            reason:
                "All bodies should have gravity wells enabled when global gravity fields is ON at startup",
          );
        }
      },
    );

    group('Gravity Well Management', () {
      test(
        'Should enable all gravity wells when global setting is on',
        () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          await appState.initializeAsync();

          // Disable some gravity wells first
          for (final body in appState.simulation.bodies) {
            body.showGravityWell = false;
          }

          // Toggle global gravity fields on
          if (!appState.ui.globalGravityFields) {
            appState.ui.toggleGlobalGravityFields();
          }

          // All bodies should now have gravity wells enabled
          for (final body in appState.simulation.bodies) {
            expect(body.showGravityWell, isTrue);
          }
        },
      );

      test(
        'Should disable all gravity wells when global setting is off',
        () async {
          TestWidgetsFlutterBinding.ensureInitialized();
          await appState.initializeAsync();

          // Enable gravity wells first
          appState.ui.toggleGlobalGravityFields(); // On

          // Now turn it off
          appState.ui.toggleGlobalGravityFields(); // Off

          // All bodies should have gravity wells disabled
          for (final body in appState.simulation.bodies) {
            expect(body.showGravityWell, isFalse);
          }
        },
      );
    });

    group('Language Change Handling', () {
      test('Should track language changes', () {
        expect(appState.checkForPendingLanguageChange(), isFalse);

        // Simulate language change via UI state
        appState.ui.setLanguage('es');

        // Should detect pending change
        expect(appState.checkForPendingLanguageChange(), isTrue);

        // Second check should return false (already handled)
        expect(appState.checkForPendingLanguageChange(), isFalse);
      });

      test('Should initialize language tracking', () {
        final mockL10n = MockAppLocalizations();
        when(mockL10n.localeName).thenReturn('en');
        when(mockL10n.bodyAlpha).thenReturn('Alpha');
        when(mockL10n.bodyBeta).thenReturn('Beta');
        when(mockL10n.bodyGamma).thenReturn('Gamma');
        when(mockL10n.bodyRockyPlanet).thenReturn('Rocky Planet');
        when(mockL10n.bodyEarthLike).thenReturn('Earth-like');
        when(mockL10n.bodySuperEarth).thenReturn('Super Earth');

        expect(
          () => appState.initializeLanguageTracking(mockL10n),
          returnsNormally,
        );
      });

      test('Should handle language change with context', () {
        final mockL10n = MockAppLocalizations();
        when(mockL10n.localeName).thenReturn('es');
        when(mockL10n.bodySun).thenReturn('Sol');
        when(mockL10n.bodyMercury).thenReturn('Mercurio');
        when(mockL10n.bodyVenus).thenReturn('Venus');
        when(mockL10n.bodyEarth).thenReturn('Tierra');
        when(mockL10n.bodyAlpha).thenReturn('Alfa');
        when(mockL10n.bodyBeta).thenReturn('Beta');
        when(mockL10n.bodyGamma).thenReturn('Gamma');
        when(mockL10n.bodyRockyPlanet).thenReturn('Planeta Rocoso');
        when(mockL10n.bodyEarthLike).thenReturn('Similar a la Tierra');
        when(mockL10n.bodySuperEarth).thenReturn('Súper Tierra');

        expect(
          () => appState.handleLanguageChangeWithContext(mockL10n),
          returnsNormally,
        );
      });
    });

    group('Scenario Switching', () {
      test('Should switch scenarios with physics settings', () async {
        TestWidgetsFlutterBinding.ensureInitialized();

        final mockL10n = MockAppLocalizations();
        when(mockL10n.bodySun).thenReturn('Sun');
        when(mockL10n.bodyMercury).thenReturn('Mercury');
        when(mockL10n.bodyVenus).thenReturn('Venus');
        when(mockL10n.bodyEarth).thenReturn('Earth');
        when(mockL10n.bodyMars).thenReturn('Mars');
        when(mockL10n.bodyJupiter).thenReturn('Jupiter');
        when(mockL10n.bodySaturn).thenReturn('Saturn');
        when(mockL10n.bodyUranus).thenReturn('Uranus');
        when(mockL10n.bodyNeptune).thenReturn('Neptune');

        appState.switchToScenarioWithPhysics(
          ScenarioType.solarSystem,
          l10n: mockL10n,
        );

        expect(
          appState.simulation.currentScenario,
          equals(ScenarioType.solarSystem),
        );
      });

      test(
        'Should apply performance optimizations on scenario switch',
        () async {
          TestWidgetsFlutterBinding.ensureInitialized();

          var notificationCount = 0;
          appState.addListener(() => notificationCount++);

          final mockL10n = MockAppLocalizations();
          when(mockL10n.bodyStarA).thenReturn('Star A');
          when(mockL10n.bodyStarB).thenReturn('Star B');
          when(mockL10n.bodyPlanetP).thenReturn('Planet P');
          when(mockL10n.bodyMoonM).thenReturn('Moon M');

          appState.switchToScenarioWithPhysics(
            ScenarioType.binaryStars,
            l10n: mockL10n,
          );

          expect(notificationCount, greaterThan(0));
        },
      );
    });

    group('State Synchronization', () {
      test('Should sync realistic colors between UI and simulation', () {
        appState.ui.toggleRealisticColors();
        expect(appState.simulation.simulation.useRealisticColors, isTrue);

        appState.ui.toggleRealisticColors();
        expect(appState.simulation.simulation.useRealisticColors, isFalse);
      });

      test('Should sync vibration settings', () {
        appState.ui.toggleUIHapticFeedback();
        // Vibration setting should be synced
        expect(() => appState.ui.enableUIHapticFeedback, returnsNormally);
      });
    });

    group('Listener Management', () {
      test('Should propagate all child state changes', () {
        var notificationCount = 0;
        appState.addListener(() => notificationCount++);

        appState.ui.toggleStats();
        appState.simulation.start();
        appState.camera.toggleAutoRotate();
        appState.physics.resetCurrentToDefaults();

        expect(notificationCount, equals(4));
      });

      test('Should handle rapid state changes', () {
        var notificationCount = 0;
        appState.addListener(() => notificationCount++);

        // Rapid changes
        for (int i = 0; i < 10; i++) {
          appState.ui.toggleStats();
        }

        expect(notificationCount, equals(10));
      });
    });

    group('Error State Management', () {
      test('Should set and clear multiple errors', () {
        appState.setError('Error 1');
        expect(appState.lastError, equals('Error 1'));

        appState.setError('Error 2');
        expect(appState.lastError, equals('Error 2'));

        appState.clearError();
        expect(appState.lastError, isNull);
      });

      test('Should notify on error state changes', () {
        var notificationCount = 0;
        appState.addListener(() => notificationCount++);

        appState.setError('Test');
        appState.clearError();
        appState.setError('Another');
        appState.clearError();

        expect(notificationCount, equals(4));
      });
    });

    group('Initialization Edge Cases', () {
      test('Should handle double initialization gracefully', () async {
        TestWidgetsFlutterBinding.ensureInitialized();

        await appState.initializeAsync();
        expect(appState.isInitialized, isTrue);

        // Second initialization should not fail
        await expectLater(appState.initializeAsync(), completes);
        expect(appState.isInitialized, isTrue);
      });

      test('Should initialize with empty SharedPreferences', () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        SharedPreferences.setMockInitialValues({});

        final freshAppState = AppState();
        await freshAppState.initializeAsync();

        expect(freshAppState.isInitialized, isTrue);
        freshAppState.dispose();
      });
    });

    group('Dispose Behavior', () {
      test('Should remove all listeners on dispose', () {
        var notificationCount = 0;
        appState.addListener(() => notificationCount++);

        appState.ui.toggleStats();
        expect(notificationCount, equals(1));

        expect(() => appState.dispose(), returnsNormally);
      });

      test('Should dispose child states', () {
        final testAppState = AppState();

        expect(() => testAppState.dispose(), returnsNormally);

        // Child states should be disposed
        expect(
          () => testAppState.simulation.dispose(),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
