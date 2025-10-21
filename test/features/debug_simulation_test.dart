import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/simulation_state.dart';

void main() {
  group('Debug Simulation State', () {
    test('Check if simulation stays running after reset', () async {
      final simulationState = SimulationState();

      // Initial state
      expect(simulationState.isRunning, false);
      expect(simulationState.isPaused, false);
      expect(simulationState.bodies.length, 4);

      // Start simulation
      simulationState.start();
      expect(simulationState.isRunning, true);
      expect(simulationState.isPaused, false);

      // Step a few times to verify movement
      for (int i = 0; i < 5; i++) {
        simulationState.step(1 / 60.0);
      }
      expect(simulationState.stepCount, greaterThan(0));
      expect(simulationState.totalTime, greaterThan(0));
      expect(simulationState.bodies.isNotEmpty, true);

      // Now reset
      final initialPos = simulationState.bodies.isNotEmpty
          ? simulationState.bodies.first.position.clone()
          : null;
      simulationState.reset();

      // After reset
      expect(simulationState.isRunning, true);
      expect(simulationState.isPaused, false);
      expect(simulationState.bodies.length, 4);
      expect(simulationState.stepCount, 0);
      expect(simulationState.totalTime, 0.0);

      // Step after reset to verify movement
      for (int i = 0; i < 5; i++) {
        simulationState.step(1 / 60.0);
      }

      expect(simulationState.stepCount, greaterThan(0));
      expect(simulationState.totalTime, greaterThan(0));
      if (simulationState.bodies.isNotEmpty && initialPos != null) {
        final newPos = simulationState.bodies.first.position;
        final distance = (newPos - initialPos).length;
        expect(
          distance,
          greaterThan(0),
          reason: 'Body should have moved after reset',
        );
      }

      // Verify simulation is still running
      expect(
        simulationState.isRunning,
        true,
        reason: 'Simulation should be running after reset',
      );
      expect(
        simulationState.isPaused,
        false,
        reason: 'Simulation should not be paused after reset',
      );
    });
  });
}
