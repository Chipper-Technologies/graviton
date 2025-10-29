import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/simulation.dart';
import 'dart:math' as math;

void main() {
  group('Enhanced 3D Simulation Tests', () {
    late Simulation simulation;

    setUp(() {
      simulation = Simulation();
    });

    test('Bodies should be distributed in full 3D space', () {
      // Test multiple resets to verify 3D distribution
      final List<double> zPositions = [];

      for (int trial = 0; trial < 20; trial++) {
        simulation.reset();
        for (final body in simulation.bodies) {
          zPositions.add(body.position.z.abs());
        }
      }

      // Should have bodies with significant Z-coordinates (> 5 units from plane)
      final significantZCount = zPositions.where((z) => z > 5.0).length;
      expect(
        significantZCount,
        greaterThan(10),
        reason:
            'Should have multiple bodies with significant Z-coordinates for true 3D distribution',
      );

      // Should have some bodies far from the XY plane (> 10 units)
      final farFromPlaneCount = zPositions.where((z) => z > 10.0).length;
      expect(
        farFromPlaneCount,
        greaterThan(5),
        reason: 'Should have bodies far from the XY plane',
      );
    });

    test('Stars should have enhanced Z-velocity for 3D motion', () {
      simulation.reset();

      final stars = simulation.bodies.where((b) => !b.isPlanet).toList();
      expect(stars, hasLength(3));

      for (final star in stars) {
        // Z-velocity should be non-trivial (enhanced from original)
        expect(
          star.velocity.z.abs(),
          greaterThan(0.01),
          reason: 'Stars should have significant Z-velocity for 3D motion',
        );
      }
    });

    test('Planet mass should vary significantly (Earth to Super-Earth)', () {
      final List<double> planetMasses = [];

      // Test multiple resets to see mass variation
      for (int trial = 0; trial < 30; trial++) {
        simulation.reset();
        final planets = simulation.bodies.where((b) => b.isPlanet).toList();
        if (planets.isNotEmpty) {
          planetMasses.add(planets.first.mass);
        }
      }

      expect(planetMasses, isNotEmpty);

      // Should have a good range of masses
      final minMass = planetMasses.reduce(math.min);
      final maxMass = planetMasses.reduce(math.max);

      expect(
        minMass,
        greaterThanOrEqualTo(1.0), // Updated from 0.8 to match new constant
        reason:
            'Minimum planet mass should be at least 1.0 (small rocky planet)',
      );
      expect(
        maxMass,
        lessThanOrEqualTo(7.5),
        reason: 'Maximum planet mass should be at most 7.5 (super-Earth limit)',
      );
      expect(
        maxMass - minMass,
        greaterThan(3.0),
        reason: 'Should have significant mass variation (> 3.0 mass units)',
      );
    });

    test('Planets should be more resilient than before', () {
      simulation.reset();

      final planets = simulation.bodies.where((b) => b.isPlanet).toList();
      final stars = simulation.bodies.where((b) => !b.isPlanet).toList();

      if (planets.isNotEmpty && stars.isNotEmpty) {
        final planet = planets.first;
        final averageStarMass =
            stars.map((s) => s.mass).reduce((a, b) => a + b) / stars.length;

        // Planet should be at least 8% of average star mass (was ~5% before)
        final massRatio = planet.mass / averageStarMass;
        expect(
          massRatio,
          greaterThan(0.08),
          reason:
              'Planets should be more massive relative to stars for better survivability',
        );
      }
    });

    test('Planet sizes should scale appropriately with mass', () {
      final List<Map<String, double>> planetData = [];

      // Collect planet mass/radius data
      for (int trial = 0; trial < 20; trial++) {
        simulation.reset();
        final planets = simulation.bodies.where((b) => b.isPlanet).toList();
        if (planets.isNotEmpty) {
          final planet = planets.first;
          planetData.add({'mass': planet.mass, 'radius': planet.radius});
        }
      }

      expect(planetData, isNotEmpty);

      // Check that larger masses generally have larger radii
      planetData.sort((a, b) => a['mass']!.compareTo(b['mass']!));

      if (planetData.length > 5) {
        final smallPlanets = planetData.take(5).toList();
        final largePlanets = planetData.skip(planetData.length - 5).toList();

        final avgSmallRadius =
            smallPlanets.map((p) => p['radius']!).reduce((a, b) => a + b) / 5;
        final avgLargeRadius =
            largePlanets.map((p) => p['radius']!).reduce((a, b) => a + b) / 5;

        expect(
          avgLargeRadius,
          greaterThan(avgSmallRadius),
          reason: 'Larger mass planets should generally have larger radii',
        );
      }
    });

    test('Bodies should have true 3D velocities', () {
      simulation.reset();

      for (final body in simulation.bodies) {
        final velocity3D = math.sqrt(
          body.velocity.x * body.velocity.x +
              body.velocity.y * body.velocity.y +
              body.velocity.z * body.velocity.z,
        );

        // Z-component should contribute meaningfully to total velocity
        if (velocity3D > 0.01) {
          final zContribution = body.velocity.z.abs() / velocity3D;
          expect(
            zContribution,
            greaterThan(0.05),
            reason:
                'Z-velocity should contribute at least 5% to total velocity for true 3D motion',
          );
        }
      }
    });

    test('System should maintain 3D character over time', () {
      simulation.reset();

      // Record initial Z-spread
      final initialZPositions = simulation.bodies
          .map((b) => b.position.z)
          .toList();
      final initialZSpread =
          initialZPositions.reduce(math.max) -
          initialZPositions.reduce(math.min);

      // Run simulation for several steps
      for (int i = 0; i < 30; i++) {
        simulation.stepRK4(1.0 / 60.0);
      }

      // Check that Z-spread is maintained (not collapsed to plane)
      final finalZPositions = simulation.bodies
          .map((b) => b.position.z)
          .toList();
      final finalZSpread =
          finalZPositions.reduce(math.max) - finalZPositions.reduce(math.min);

      expect(
        finalZSpread,
        greaterThan(initialZSpread * 0.3),
        reason:
            'System should maintain some 3D character over time, not collapse to a plane',
      );
    });
  });
}
