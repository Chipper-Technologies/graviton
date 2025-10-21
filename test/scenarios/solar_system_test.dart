import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/services/simulation.dart' as physics;

void main() {
  group('Solar System Orbital Mechanics', () {
    test('Planets should have stable circular orbital velocities', () {
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(ScenarioType.solarSystem);

      // Find the Sun
      final sun = bodies.firstWhere((body) => body.name == 'Sun');
      expect(sun.mass, 50.0);
      expect(sun.position.length, closeTo(0, 0.001)); // Sun at center
      expect(sun.velocity.length, closeTo(0, 0.001)); // Sun stationary

      // Check planets have correct orbital velocities
      final planets = bodies.where((body) => body.name != 'Sun').toList();
      expect(planets.length, 8); // All 8 planets

      // Verify more realistic mass ratios (Sun should dominate)
      for (final planet in planets) {
        final massRatio = sun.mass / planet.mass;
        expect(
          massRatio,
          greaterThan(300),
          reason:
              '${planet.name} mass ratio too small (${massRatio.toStringAsFixed(1)}:1)',
        );
        expect(
          massRatio,
          lessThanOrEqualTo(5000),
          reason:
              '${planet.name} mass ratio too large (${massRatio.toStringAsFixed(1)}:1)',
        );
      }

      for (final planet in planets) {
        final distance = planet.position.length;
        final speed = planet.velocity.length;

        // Expected circular orbital velocity: v = sqrt(G * M / r)
        // G = 1.2, M = 50.0 (sun mass)
        final expectedSpeed = math.sqrt(1.2 * 50.0 / distance);

        // Velocity should be very close to calculated orbital speed
        expect(
          speed,
          closeTo(expectedSpeed, 0.001),
          reason: '${planet.name} orbital velocity incorrect',
        );

        // Velocity should be approximately perpendicular to position (allowing for orbital inclinations)
        // For inclined orbits, the dot product won't be exactly zero but should be small
        final dotProduct = planet.position.dot(planet.velocity);
        expect(
          dotProduct.abs(),
          lessThan(0.01),
          reason:
              '${planet.name} velocity not approximately perpendicular to position',
        );
      }
    });

    test('Simulation should maintain stable orbits over time', () {
      final simulation = physics.Simulation();
      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Get initial positions
      final initialPositions = simulation.bodies
          .map((b) => b.position.clone())
          .toList();

      // Run simulation for several steps
      const timeStep = 0.01;
      const numSteps = 1000;

      for (int i = 0; i < numSteps; i++) {
        simulation.stepRK4(timeStep);
      }

      // Check that planets are still roughly at their orbital distances
      // (they should complete multiple orbits but maintain distance)
      final sun = simulation.bodies.firstWhere((body) => body.name == 'Sun');
      final planets = simulation.bodies
          .where((body) => body.name != 'Sun')
          .toList();

      for (int i = 0; i < planets.length; i++) {
        final planet = planets[i];
        final initialDistance =
            initialPositions[i + 1].length; // +1 to skip sun
        final currentDistance = (planet.position - sun.position).length;

        // Distance should remain roughly constant (within 10% for stability)
        final distanceRatio = currentDistance / initialDistance;
        expect(
          distanceRatio,
          greaterThan(0.8),
          reason: '${planet.name} orbit too small ($distanceRatio)',
        );
        expect(
          distanceRatio,
          lessThan(1.2),
          reason: '${planet.name} orbit too large ($distanceRatio)',
        );
      }
    });
  });
}
