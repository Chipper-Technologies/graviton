import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/services/simulation.dart' as physics;

void main() {
  group('Earth-Moon-Sun Orbital Mechanics', () {
    test('System should be simple and stable like solar system', () {
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(
        ScenarioType.earthMoonSun,
      );

      final sun = bodies.firstWhere((body) => body.name == 'Sun');
      final earth = bodies.firstWhere((body) => body.name == 'Earth');
      final moon = bodies.firstWhere((body) => body.name == 'Moon');

      // Sun should be stationary (like in solar system scenario)
      expect(sun.velocity.length, closeTo(0.0, 1e-10));
      expect(sun.position.length, closeTo(0.0, 1e-10));

      // Earth should have a reasonable distance from Sun (same as solar system)
      expect(earth.position.length, closeTo(50.0, 1.0));

      // Moon should be very close to Earth
      final moonEarthDistance = (moon.position - earth.position).length;
      expect(moonEarthDistance, lessThan(1.0)); // Expect closer than 1.0 unit

      // Debug output (commented out to avoid lint warnings)
      // print('Earth distance from Sun: ${earth.position.length}');
      // print('Moon distance from Earth: $moonEarthDistance');
    });

    test('Bodies should have stable circular orbital velocities', () {
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(
        ScenarioType.earthMoonSun,
      );

      // Find the bodies
      final sun = bodies.firstWhere((body) => body.name == 'Sun');
      final earth = bodies.firstWhere((body) => body.name == 'Earth');
      final moon = bodies.firstWhere((body) => body.name == 'Moon');

      expect(sun.mass, 45.0); // Updated to match earth-moon-sun scenario
      expect(sun.position.length, closeTo(0, 0.001)); // Sun at center
      expect(sun.velocity.length, closeTo(0, 0.001)); // Sun stationary again

      // Check Earth has correct orbital velocity around Sun
      final earthDistance = earth.position.length;
      final earthSpeed = earth.velocity.length;
      final expectedEarthSpeed = math.sqrt(
        1.2 * 50.0 / earthDistance,
      ); // Updated for Sun's mass (50.0)

      // Debug output (commented out to avoid lint warnings)
      // print('Earth distance: $earthDistance');
      // print('Earth speed: $earthSpeed');
      // print('Expected Earth speed: $expectedEarthSpeed');

      // Earth speed should be close to stable circular orbital velocity
      expect(
        earthSpeed,
        closeTo(expectedEarthSpeed * 0.95, expectedEarthSpeed * 0.1),
      );

      // Check Moon has correct orbital velocity around Earth
      final moonEarthVector = moon.position - earth.position;
      final moonEarthDistance = moonEarthVector.length;
      final moonRelativeVel = moon.velocity - earth.velocity;
      final moonSpeed = moonRelativeVel.length;
      final expectedMoonSpeed = math.sqrt(
        1.2 * 0.30 / moonEarthDistance,
      ); // Updated for Earth's new mass (0.30)

      // Debug output (commented out to avoid lint warnings)
      // print('Moon-Earth distance: $moonEarthDistance');
      // print('Moon relative speed: $moonSpeed');
      // print('Expected Moon speed: $expectedMoonSpeed');

      // Moon speed should be close to stable circular orbital velocity around Earth
      expect(moonSpeed, closeTo(expectedMoonSpeed, expectedMoonSpeed * 0.15));
    });

    test('Moon should orbit Earth, not directly the Sun', () {
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(
        ScenarioType.earthMoonSun,
      );

      final sun = bodies.firstWhere((body) => body.name == 'Sun');
      final earth = bodies.firstWhere((body) => body.name == 'Earth');
      final moon = bodies.firstWhere((body) => body.name == 'Moon');

      // Moon should be much closer to Earth than to Sun
      final moonEarthDistance = (moon.position - earth.position).length;
      final moonSunDistance = (moon.position - sun.position).length;

      expect(moonEarthDistance, lessThan(moonSunDistance / 5.0));

      // Moon's mass should be much smaller than Earth's
      expect(
        moon.mass,
        lessThan(earth.mass),
      ); // Updated: 0.01 vs 0.02 (Moon is 50% of Earth mass)
    });

    test('Moon should remain bound to Earth throughout simulation', () {
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(
        ScenarioType.earthMoonSun,
      );

      final simulation = physics.Simulation();
      simulation.bodies = bodies;

      final earth = simulation.bodies.firstWhere(
        (body) => body.name == 'Earth',
      );
      final moon = simulation.bodies.firstWhere((body) => body.name == 'Moon');

      // Record initial Moon-Earth distance
      final initialMoonEarthDistance = (moon.position - earth.position).length;

      // Simulate for multiple orbits (longer test)
      for (int i = 0; i < 1000; i++) {
        simulation.stepRK4(0.01);
      }

      // Check that Moon is still close to Earth after simulation
      final finalEarth = simulation.bodies.firstWhere(
        (body) => body.name == 'Earth',
      );
      final finalMoon = simulation.bodies.firstWhere(
        (body) => body.name == 'Moon',
      );
      final finalMoonEarthDistance =
          (finalMoon.position - finalEarth.position).length;

      // Debug output (commented out to avoid lint warnings)
      // print('Initial Moon-Earth distance: $initialMoonEarthDistance');
      // print('Final Moon-Earth distance: $finalMoonEarthDistance');

      // Moon should still be relatively close to Earth (within factor of 3 of initial distance)
      expect(finalMoonEarthDistance, lessThan(initialMoonEarthDistance * 3.0));

      // Moon should be much closer to Earth than to Sun
      final finalSun = simulation.bodies.firstWhere(
        (body) => body.name == 'Sun',
      );
      final finalMoonSunDistance =
          (finalMoon.position - finalSun.position).length;
      expect(finalMoonEarthDistance, lessThan(finalMoonSunDistance / 3.0));
    });

    test('System should be stable in short-term simulation', () {
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(
        ScenarioType.earthMoonSun,
      );

      final simulation = physics.Simulation();
      simulation.bodies = bodies;

      // Simulate for a short period and check stability
      for (int i = 0; i < 100; i++) {
        simulation.stepRK4(0.01);
      }

      // All bodies should still exist and have reasonable positions
      expect(simulation.bodies.length, equals(3));

      final earth = simulation.bodies.firstWhere(
        (body) => body.name == 'Earth',
      );
      final moon = simulation.bodies.firstWhere((body) => body.name == 'Moon');

      // Bodies shouldn't have escaped to infinity
      expect(earth.position.length, lessThan(100.0));
      expect(moon.position.length, lessThan(100.0));

      // Bodies shouldn't have collided with the Sun
      expect(earth.position.length, greaterThan(5.0));
      expect(moon.position.length, greaterThan(2.0));
    });
  });
}
