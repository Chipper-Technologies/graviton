import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/state/ui_state.dart';

void main() {
  group('Performance Optimizations', () {
    late UIState uiState;

    setUp(() {
      uiState = UIState();
    });

    tearDown(() {
      uiState.dispose();
    });

    test('should disable heavy features for galaxy formation scenario', () {
      // Arrange - ensure all features are enabled initially (default state)
      // UI state defaults have showLabels, showOrbitalPaths, showOffScreenIndicators, and globalGravityFields as true
      expect(uiState.showLabels, isTrue);
      expect(uiState.showOrbitalPaths, isTrue);
      expect(uiState.showOffScreenIndicators, isTrue);
      expect(uiState.globalGravityFields, isTrue);

      // Act - apply optimizations for galaxy formation
      uiState.applyPerformanceOptimizationsForScenario(
        ScenarioType.galaxyFormation,
        31, // Galaxy formation typically has ~31 bodies
      );

      // Assert - heavy features should be disabled
      expect(uiState.showLabels, isFalse);
      expect(uiState.showOrbitalPaths, isFalse);
      expect(uiState.showOffScreenIndicators, isFalse);
      expect(uiState.globalGravityFields, isFalse);
    });

    test('should disable heavy features for asteroid belt scenario', () {
      // Arrange - ensure all features are enabled initially
      expect(uiState.showLabels, isTrue);
      expect(uiState.showOrbitalPaths, isTrue);
      expect(uiState.showOffScreenIndicators, isTrue);
      expect(uiState.globalGravityFields, isTrue);

      // Act - apply optimizations for asteroid belt
      uiState.applyPerformanceOptimizationsForScenario(
        ScenarioType.asteroidBelt,
        15, // Even with fewer bodies, asteroid belt is performance-heavy
      );

      // Assert - heavy features should be disabled
      expect(uiState.showLabels, isFalse);
      expect(uiState.showOrbitalPaths, isFalse);
      expect(uiState.showOffScreenIndicators, isFalse);
      expect(uiState.globalGravityFields, isFalse);
    });

    test('should disable heavy features for scenarios with 20+ bodies', () {
      // Arrange - ensure all features are enabled initially
      expect(uiState.showLabels, isTrue);
      expect(uiState.showOrbitalPaths, isTrue);
      expect(uiState.showOffScreenIndicators, isTrue);
      expect(uiState.globalGravityFields, isTrue);

      // Act - apply optimizations for a scenario with many bodies
      uiState.applyPerformanceOptimizationsForScenario(
        ScenarioType.solarSystem, // Not in heavy list, but has many bodies
        25,
      );

      // Assert - heavy features should be disabled due to body count
      expect(uiState.showLabels, isFalse);
      expect(uiState.showOrbitalPaths, isFalse);
      expect(uiState.showOffScreenIndicators, isFalse);
      expect(uiState.globalGravityFields, isFalse);
    });

    test(
      'should not disable features for simple scenarios with few bodies',
      () {
        // Arrange - ensure all features are enabled initially
        expect(uiState.showLabels, isTrue);
        expect(uiState.showOrbitalPaths, isTrue);
        expect(uiState.showOffScreenIndicators, isTrue);
        expect(uiState.globalGravityFields, isTrue);

        // Act - apply optimizations for a simple scenario
        uiState.applyPerformanceOptimizationsForScenario(
          ScenarioType.earthMoonSun,
          3, // Only 3 bodies
        );

        // Assert - features should remain enabled
        expect(uiState.showLabels, isTrue);
        expect(uiState.showOrbitalPaths, isTrue);
        expect(uiState.showOffScreenIndicators, isTrue);
        expect(uiState.globalGravityFields, isTrue);
      },
    );

    test('should only disable features that are currently enabled', () {
      // Arrange - disable labels and gravity fields but keep other features enabled
      uiState.toggleLabels(); // This will set showLabels to false
      uiState
          .toggleGlobalGravityFields(); // This will set globalGravityFields to false
      expect(uiState.showLabels, isFalse);
      expect(uiState.showOrbitalPaths, isTrue);
      expect(uiState.showOffScreenIndicators, isTrue);
      expect(uiState.globalGravityFields, isFalse);

      // Act - apply optimizations
      uiState.applyPerformanceOptimizationsForScenario(
        ScenarioType.galaxyFormation,
        31,
      );

      // Assert - labels and gravity fields stay disabled, others get disabled
      expect(uiState.showLabels, isFalse);
      expect(uiState.showOrbitalPaths, isFalse);
      expect(uiState.showOffScreenIndicators, isFalse);
      expect(uiState.globalGravityFields, isFalse);
    });
  });
}
