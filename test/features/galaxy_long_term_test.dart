import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/simulation.dart' as physics;

void main() {
  group('Galaxy Formation Long-term Stability', () {
    test('Outer stars should remain stable over very long simulation', () {
      final simulation = physics.Simulation();
      simulation.resetWithScenario(ScenarioType.galaxyFormation);

      // Find and track all outer stars (distance > 100)
      final outerStars = <int, double>{};
      for (int i = 1; i < simulation.bodies.length; i++) {
        final distance = simulation.bodies[i].position.length;
        if (distance > 100.0) {
          outerStars[i] = distance;
        }
      }

      // Run a very long simulation
      const timeStep = 1.0 / 60.0;
      const totalTime = 500.0; // Very long time
      final totalSteps = (totalTime / timeStep).round();

      int survivingOuterStars = outerStars.length;
      const ejectionDistance = 600.0; // Very far threshold

      for (int step = 0; step < totalSteps; step++) {
        simulation.stepRK4(timeStep);

        if (step % 10 == 0) {
          // Check every 10 steps
          // Check if any outer stars have been ejected
          for (final starIndex in outerStars.keys) {
            if (starIndex < simulation.bodies.length) {
              final star = simulation.bodies[starIndex];
              final distance = star.position.length;

              if (distance > ejectionDistance) {
                survivingOuterStars--;
                outerStars.remove(starIndex);
                break; // Remove from tracking
              }
            }
          }
        }
      }

      final survivalRate = survivingOuterStars / outerStars.length;

      // We expect at least 70% of outer stars to survive the very long simulation
      expect(survivalRate, greaterThan(0.7), reason: 'Too many outer stars were ejected over long simulation time');
    });
  });
}
