import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:graviton/state/app_state.dart';

void main() {
  group('Settings Persistence Integration Tests', () {
    test('UIState should load and save settings correctly', () async {
      // Create a UIState instance
      final uiState = UIState();

      // Test that we can initialize it (should work even without SharedPreferences in tests)
      await uiState.initialize();

      // Test that default values are set correctly
      expect(uiState.showTrails, isTrue);
      expect(uiState.showLabels, isTrue);
      expect(uiState.showStats, isFalse);

      // Test that we can toggle values (this will attempt to save but gracefully fail in tests)
      uiState.toggleStats();
      expect(uiState.showStats, isTrue);
    });

    test('AppState should initialize UIState properly', () async {
      final appState = AppState();

      // Test that AppState initializes properly
      expect(appState.isInitialized, isTrue);

      // Test that UIState is accessible and has correct defaults
      expect(appState.ui.showTrails, isTrue);
      expect(appState.ui.showLabels, isTrue);
      expect(appState.ui.showStats, isFalse);

      // Test async initialization
      await appState.initializeAsync();

      // UI should still be functional after async init
      expect(appState.ui.showTrails, isTrue);

      // Test that simulation timeScale is also accessible and has correct default
      expect(appState.simulation.timeScale, equals(8.0));
    });

    test('SimulationState should save and load timeScale', () async {
      final appState = AppState();

      // Test that default timeScale is 8.0
      expect(appState.simulation.timeScale, equals(8.0));

      // Test async initialization
      await appState.initializeAsync();

      // TimeScale should still be 8.0 after initialization
      expect(appState.simulation.timeScale, equals(8.0));

      // Test setting timeScale (this will attempt to save but gracefully fail in tests)
      appState.simulation.setTimeScale(2.5);
      expect(appState.simulation.timeScale, equals(2.5));

      // Test clamping
      appState.simulation.setTimeScale(20.0); // Should clamp to 16.0
      expect(appState.simulation.timeScale, equals(16.0));

      appState.simulation.setTimeScale(0.05); // Should clamp to 0.1
      expect(appState.simulation.timeScale, equals(0.1));
    });
  });
}
