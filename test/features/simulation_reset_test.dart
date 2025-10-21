import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/simulation_state.dart';

void main() {
  group('Simulation Reset Tests', () {
    test('Reset should restart simulation properly', () async {
      final simulation = SimulationState();

      // Let the simulation initialize
      await Future.delayed(Duration(milliseconds: 100));

      // Verify initial state
      expect(
        simulation.bodies.length,
        greaterThan(0),
        reason: 'Should have bodies after initialization',
      );

      // Start the simulation if it's not already running
      if (!simulation.isRunning) {
        simulation.start();
      }

      // Wait a bit for the start to take effect
      await Future.delayed(Duration(milliseconds: 50));

      // Verify simulation is running
      expect(
        simulation.isRunning,
        isTrue,
        reason: 'Simulation should be running after start',
      );
      expect(
        simulation.isPaused,
        isFalse,
        reason: 'Simulation should not be paused after start',
      );

      // Store initial state
      final initialBodiesCount = simulation.bodies.length;

      // Simulate some steps
      for (int i = 0; i < 10; i++) {
        simulation.step(1 / 60.0);
      }

      // Verify simulation has progressed
      expect(
        simulation.stepCount,
        greaterThan(0),
        reason: 'Step count should increase after stepping',
      );
      expect(
        simulation.totalTime,
        greaterThan(0),
        reason: 'Total time should increase after stepping',
      );
      expect(
        simulation.bodies.length,
        equals(initialBodiesCount),
        reason: 'Bodies count should remain consistent',
      );

      // Now reset
      simulation.reset();

      // Give microtask time to complete
      await Future.delayed(Duration(milliseconds: 100));

      // Verify reset effects
      expect(
        simulation.bodies.length,
        equals(initialBodiesCount),
        reason: 'Bodies count should be preserved after reset',
      );
      expect(
        simulation.stepCount,
        equals(0),
        reason: 'Step count should be reset to 0',
      );
      expect(
        simulation.totalTime,
        equals(0.0),
        reason: 'Total time should be reset to 0',
      );

      // Step the simulation after reset
      simulation.step(1 / 60.0);

      // Verify simulation continues to work after reset
      expect(
        simulation.isRunning,
        isTrue,
        reason: 'Simulation should be running after reset',
      );
      expect(
        simulation.isPaused,
        isFalse,
        reason: 'Simulation should not be paused after reset',
      );
      expect(
        simulation.bodies.length,
        greaterThan(0),
        reason: 'Simulation should have bodies after reset',
      );
      expect(
        simulation.stepCount,
        greaterThan(0),
        reason: 'Step count should increase after stepping',
      );
    });
  });
}
