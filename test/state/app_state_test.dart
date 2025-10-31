import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/app_state.dart';

void main() {
  group('AppState Tests', () {
    late AppState appState;

    setUp(() {
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
      expect(appState.simulation.timeScale, equals(8.0));

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
  });
}
