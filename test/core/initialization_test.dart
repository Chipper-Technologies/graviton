import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/simulation_state.dart';
import '../test_utils.dart';

void main() {
  group('Simulation Initialization Test', () {
    test('Should start with random scenario after initialize', () async {
      final simulationState = SimulationState();
      final mockL10n = TestUtils.createMockAppLocalizations();

      // Before localization - should have 0 bodies (deferred until l10n available)
      expect(simulationState.bodies.length, 0);

      // Update localization context BEFORE initialize
      simulationState.updateLocalization(mockL10n);

      // After localization update - should have 4 bodies
      expect(simulationState.bodies.length, 4);

      // Initialize (should set to random scenario by default)
      await simulationState.initialize();

      // Check that we have 4 bodies (default random scenario)
      expect(
        simulationState.bodies.length,
        4,
        reason: 'Should have 4 bodies after initialization',
      );

      // Check that bodies have proper names after initialization
      final bodiesWithNames = simulationState.bodies
          .where((body) => body.name.isNotEmpty)
          .toList();
      expect(
        bodiesWithNames.length,
        equals(4),
        reason: 'All bodies should have names',
      );

      // Verify all bodies have proper mass (should be > 0)
      for (final body in simulationState.bodies) {
        expect(
          body.mass,
          greaterThan(0),
          reason: 'All bodies should have positive mass',
        );
        expect(
          body.radius,
          greaterThan(0),
          reason: 'All bodies should have positive radius',
        );
      }
    });
  });
}
