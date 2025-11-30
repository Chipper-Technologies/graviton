import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/collision_particle.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/particle_physics_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('ParticlePhysicsUtils Tests', () {
    late Body body1;
    late Body body2;
    late math.Random random;

    setUp(() {
      body1 = Body(
        position: vm.Vector3(0, 0, 0),
        velocity: vm.Vector3(1, 0, 0),
        mass: 10.0,
        radius: 1.0,
        color: AppColors.celestialRedPlanet,
        name: 'Body1',
      );

      body2 = Body(
        position: vm.Vector3(2, 0, 0),
        velocity: vm.Vector3(-1, 0, 0),
        mass: 15.0,
        radius: 1.0,
        color: AppColors.celestialBluePlanet,
        name: 'Body2',
      );

      random = math.Random(42); // Fixed seed for reproducibility
    });

    group('Impact Velocity Calculations', () {
      test('Should calculate impact velocity correctly', () {
        final impactVelocity = ParticlePhysicsUtils.calculateImpactVelocity(
          body1,
          body2,
        );

        // Relative velocity = (-1, 0, 0) - (1, 0, 0) = (-2, 0, 0)
        // Magnitude = 2.0
        expect(impactVelocity, equals(2.0));
      });

      test('Should handle zero relative velocity', () {
        body2.velocity.setFrom(body1.velocity);

        final impactVelocity = ParticlePhysicsUtils.calculateImpactVelocity(
          body1,
          body2,
        );

        expect(impactVelocity, equals(0.0));
      });

      test('Should calculate for perpendicular velocities', () {
        body1.velocity.setValues(1, 0, 0);
        body2.velocity.setValues(0, 1, 0);

        final impactVelocity = ParticlePhysicsUtils.calculateImpactVelocity(
          body1,
          body2,
        );

        // Relative velocity magnitude = sqrt(1^2 + 1^2) = sqrt(2)
        expect(impactVelocity, closeTo(math.sqrt(2), 0.001));
      });
    });

    group('Impact Energy Calculations', () {
      test('Should calculate impact energy correctly', () {
        final impactEnergy = ParticlePhysicsUtils.calculateImpactEnergy(
          body1,
          body2,
        );

        // Reduced mass = (10 * 15) / (10 + 15) = 6.0
        // Relative velocity squared = 4.0
        // Energy = 0.5 * 6.0 * 4.0 = 12.0
        expect(impactEnergy, equals(12.0));
      });

      test('Should return zero for bodies at rest', () {
        body1.velocity.setZero();
        body2.velocity.setZero();

        final impactEnergy = ParticlePhysicsUtils.calculateImpactEnergy(
          body1,
          body2,
        );

        expect(impactEnergy, equals(0.0));
      });

      test('Should scale with mass appropriately', () {
        final energy1 = ParticlePhysicsUtils.calculateImpactEnergy(
          body1,
          body2,
        );

        // Double the mass of body2
        body2.mass = 30.0;
        final energy2 = ParticlePhysicsUtils.calculateImpactEnergy(
          body1,
          body2,
        );

        // Reduced mass should increase, thus energy increases
        expect(energy2, greaterThan(energy1));
      });
    });

    group('Collision Direction Calculations', () {
      test('Should calculate collision direction correctly', () {
        final direction = ParticlePhysicsUtils.calculateCollisionDirection(
          body1,
          body2,
        );

        // Direction from body1 to body2 = (2,0,0) - (0,0,0) = (2,0,0)
        // Normalized = (1,0,0)
        expect(direction.x, closeTo(1.0, 0.001));
        expect(direction.y, closeTo(0.0, 0.001));
        expect(direction.z, closeTo(0.0, 0.001));
        expect(direction.length, closeTo(1.0, 0.001));
      });

      test('Should normalize direction vectors', () {
        body2.position.setValues(10, 10, 10);

        final direction = ParticlePhysicsUtils.calculateCollisionDirection(
          body1,
          body2,
        );

        // Should always be unit vector
        expect(direction.length, closeTo(1.0, 0.001));
      });

      test('Should handle negative directions', () {
        body2.position.setValues(-5, 0, 0);

        final direction = ParticlePhysicsUtils.calculateCollisionDirection(
          body1,
          body2,
        );

        expect(direction.x, closeTo(-1.0, 0.001));
        expect(direction.length, closeTo(1.0, 0.001));
      });
    });

    group('Debris Velocity Generation', () {
      test('Should generate debris velocity with correct structure', () {
        final collisionDirection = vm.Vector3(1, 0, 0);
        final velocity = ParticlePhysicsUtils.generateDebrisVelocity(
          collisionDirection: collisionDirection,
          impactEnergy: 100.0,
          random: random,
        );

        expect(velocity, isNotNull);
        expect(velocity.length, greaterThan(0.0));
      });

      test('Should scale velocity with impact energy', () {
        final collisionDirection = vm.Vector3(1, 0, 0);

        final velocity1 = ParticlePhysicsUtils.generateDebrisVelocity(
          collisionDirection: collisionDirection,
          impactEnergy: 10.0,
          random: math.Random(42),
        );

        final velocity2 = ParticlePhysicsUtils.generateDebrisVelocity(
          collisionDirection: collisionDirection,
          impactEnergy: 1000.0,
          random: math.Random(42),
        );

        expect(velocity2.length, greaterThan(velocity1.length));
      });

      test('Should create spread within specified angle', () {
        final collisionDirection = vm.Vector3(1, 0, 0);
        final velocities = <vm.Vector3>[];

        // Generate multiple velocities
        for (int i = 0; i < 20; i++) {
          velocities.add(
            ParticlePhysicsUtils.generateDebrisVelocity(
              collisionDirection: collisionDirection,
              impactEnergy: 50.0,
              random: math.Random(i),
              spreadAngle: 30.0,
            ),
          );
        }

        // Verify they're not all identical (random spread working)
        final uniqueVelocities = velocities.toSet();
        expect(uniqueVelocities.length, greaterThan(10));
      });

      test('Should handle different spread angles', () {
        final collisionDirection = vm.Vector3(0, 1, 0);

        final velocity1 = ParticlePhysicsUtils.generateDebrisVelocity(
          collisionDirection: collisionDirection,
          impactEnergy: 50.0,
          random: math.Random(42),
          spreadAngle: 10.0,
        );

        final velocity2 = ParticlePhysicsUtils.generateDebrisVelocity(
          collisionDirection: collisionDirection,
          impactEnergy: 50.0,
          random: math.Random(42),
          spreadAngle: 90.0,
        );

        expect(velocity1, isNotNull);
        expect(velocity2, isNotNull);
      });
    });

    group('Debris Color Generation', () {
      test('Should generate color based on base color', () {
        final color = ParticlePhysicsUtils.generateDebrisColor(
          baseColor: AppColors.celestialRedPlanet,
          temperature: 5000.0,
          random: random,
        );

        expect(color, isNotNull);
        expect(color, isA<Color>());
      });

      test('Should lighten color with higher temperature', () {
        final coldColor = ParticlePhysicsUtils.generateDebrisColor(
          baseColor: AppColors.celestialBluePlanet,
          temperature: 1000.0,
          random: math.Random(42),
          variation: 0.0,
        );

        final hotColor = ParticlePhysicsUtils.generateDebrisColor(
          baseColor: AppColors.celestialBluePlanet,
          temperature: 50000.0,
          random: math.Random(42),
          variation: 0.0,
        );

        // Hot color should be lighter (higher luminance)
        final coldHsl = HSLColor.fromColor(coldColor);
        final hotHsl = HSLColor.fromColor(hotColor);

        expect(hotHsl.lightness, greaterThanOrEqualTo(coldHsl.lightness));
      });

      test('Should apply random variation', () {
        final colors = <Color>[];

        for (int i = 0; i < 10; i++) {
          colors.add(
            ParticlePhysicsUtils.generateDebrisColor(
              baseColor: AppColors.celestialTealPlanet,
              temperature: 5000.0,
              random: math.Random(i),
              variation: 0.3,
            ),
          );
        }

        // Colors should vary due to random variation
        final uniqueColors = colors.toSet();
        expect(uniqueColors.length, greaterThan(5));
      });

      test('Should handle zero variation', () {
        final color1 = ParticlePhysicsUtils.generateDebrisColor(
          baseColor: AppColors.accretionGold,
          temperature: 5000.0,
          random: math.Random(42),
          variation: 0.0,
        );

        final color2 = ParticlePhysicsUtils.generateDebrisColor(
          baseColor: AppColors.accretionGold,
          temperature: 5000.0,
          random: math.Random(43),
          variation: 0.0,
        );

        // Should be very similar without variation
        expect(color1.toARGB32(), equals(color2.toARGB32()));
      });
    });

    group('Particle Size Calculations', () {
      test('Should calculate particle size within bounds', () {
        final size = ParticlePhysicsUtils.calculateParticleSize(
          impactEnergy: 50.0,
          random: random,
        );

        expect(size, greaterThanOrEqualTo(0.5 * 0.7));
        expect(size, lessThanOrEqualTo(3.0 * 1.3));
      });

      test('Should scale size with impact energy', () {
        final size1 = ParticlePhysicsUtils.calculateParticleSize(
          impactEnergy: 1.0,
          random: math.Random(42),
        );

        final size2 = ParticlePhysicsUtils.calculateParticleSize(
          impactEnergy: 10000.0,
          random: math.Random(42),
        );

        expect(size2, greaterThan(size1));
      });

      test('Should respect custom min and max sizes', () {
        final size = ParticlePhysicsUtils.calculateParticleSize(
          impactEnergy: 50.0,
          random: random,
          minSize: 2.0,
          maxSize: 5.0,
        );

        expect(size, greaterThanOrEqualTo(2.0 * 0.7));
        expect(size, lessThanOrEqualTo(5.0 * 1.3));
      });

      test('Should add random variation to sizes', () {
        final sizes = <double>[];

        for (int i = 0; i < 20; i++) {
          sizes.add(
            ParticlePhysicsUtils.calculateParticleSize(
              impactEnergy: 100.0,
              random: math.Random(i),
            ),
          );
        }

        // Sizes should vary
        final uniqueSizes = sizes.toSet();
        expect(uniqueSizes.length, greaterThan(15));
      });
    });

    group('Particle Lifetime Calculations', () {
      test('Should calculate lifetime within bounds', () {
        final lifetime = ParticlePhysicsUtils.calculateParticleLifetime(
          impactEnergy: 50.0,
          random: random,
        );

        expect(lifetime, greaterThanOrEqualTo(0.5 * 0.8));
        expect(lifetime, lessThanOrEqualTo(3.0 * 1.2));
      });

      test('Should scale lifetime with impact energy', () {
        final lifetime1 = ParticlePhysicsUtils.calculateParticleLifetime(
          impactEnergy: 1.0,
          random: math.Random(42),
        );

        final lifetime2 = ParticlePhysicsUtils.calculateParticleLifetime(
          impactEnergy: 10000.0,
          random: math.Random(42),
        );

        expect(lifetime2, greaterThan(lifetime1));
      });

      test('Should respect custom min and max lifetimes', () {
        final lifetime = ParticlePhysicsUtils.calculateParticleLifetime(
          impactEnergy: 50.0,
          random: random,
          minLifetime: 1.0,
          maxLifetime: 5.0,
        );

        expect(lifetime, greaterThanOrEqualTo(1.0 * 0.8));
        expect(lifetime, lessThanOrEqualTo(5.0 * 1.2));
      });
    });

    group('Debris Particle Creation', () {
      test('Should create valid collision particle', () {
        final collisionPoint = vm.Vector3(5, 5, 5);
        final collisionDirection = vm.Vector3(1, 0, 0);

        final particle = ParticlePhysicsUtils.createDebrisParticle(
          collisionPoint: collisionPoint,
          collisionDirection: collisionDirection,
          impactEnergy: 100.0,
          baseColor: AppColors.accretionOrange,
          temperature: 8000.0,
          random: random,
        );

        expect(particle, isA<CollisionParticle>());
        expect(particle.position, isNotNull);
        expect(particle.velocity, isNotNull);
        expect(particle.color, isNotNull);
        expect(particle.size, greaterThan(0.0));
        expect(particle.lifetime, greaterThan(0.0));
        expect(particle.mass, equals(0.001));
      });

      test('Should create particles at collision point', () {
        final collisionPoint = vm.Vector3(10, 20, 30);
        final collisionDirection = vm.Vector3(0, 1, 0);

        final particle = ParticlePhysicsUtils.createDebrisParticle(
          collisionPoint: collisionPoint,
          collisionDirection: collisionDirection,
          impactEnergy: 50.0,
          baseColor: AppColors.celestialPlumPlanet,
          temperature: 5000.0,
          random: random,
        );

        expect(particle.position.x, equals(10.0));
        expect(particle.position.y, equals(20.0));
        expect(particle.position.z, equals(30.0));
      });

      test('Should create particles with non-zero velocity', () {
        final particle = ParticlePhysicsUtils.createDebrisParticle(
          collisionPoint: vm.Vector3(0, 0, 0),
          collisionDirection: vm.Vector3(1, 0, 0),
          impactEnergy: 200.0,
          baseColor: AppColors.celestialTealPlanet,
          temperature: 10000.0,
          random: random,
        );

        expect(particle.velocity.length, greaterThan(0.0));
      });
    });

    group('Shockwave Parameter Calculations', () {
      test('Should calculate shockwave parameters', () {
        final params = ParticlePhysicsUtils.calculateShockwaveParameters(
          impactEnergy: 100.0,
          combinedMass: 50.0,
        );

        expect(params, containsPair('maxRadius', isA<double>()));
        expect(params, containsPair('lifetime', isA<double>()));
        expect(params, containsPair('thickness', isA<double>()));
      });

      test('Should scale parameters with impact energy', () {
        final params1 = ParticlePhysicsUtils.calculateShockwaveParameters(
          impactEnergy: 10.0,
          combinedMass: 50.0,
        );

        final params2 = ParticlePhysicsUtils.calculateShockwaveParameters(
          impactEnergy: 1000.0,
          combinedMass: 50.0,
        );

        expect(params2['maxRadius']!, greaterThan(params1['maxRadius']!));
        expect(params2['lifetime']!, greaterThan(params1['lifetime']!));
        expect(params2['thickness']!, greaterThan(params1['thickness']!));
      });

      test('Should have positive values', () {
        final params = ParticlePhysicsUtils.calculateShockwaveParameters(
          impactEnergy: 50.0,
          combinedMass: 25.0,
        );

        expect(params['maxRadius']!, greaterThan(0.0));
        expect(params['lifetime']!, greaterThan(0.0));
        expect(params['thickness']!, greaterThan(0.0));
      });
    });

    group('Plasma Jet Generation Criteria', () {
      test('Should generate plasma jets for high mass and energy', () {
        final shouldGenerate = ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: 2000.0,
          totalMass: 200.0,
        );

        expect(shouldGenerate, isTrue);
      });

      test('Should not generate for low mass', () {
        final shouldGenerate = ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: 2000.0,
          totalMass: 50.0,
        );

        expect(shouldGenerate, isFalse);
      });

      test('Should not generate for low energy', () {
        final shouldGenerate = ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: 500.0,
          totalMass: 200.0,
        );

        expect(shouldGenerate, isFalse);
      });

      test('Should respect custom thresholds', () {
        final shouldGenerate = ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: 100.0,
          totalMass: 50.0,
          massThreshold: 40.0,
          energyThreshold: 80.0,
        );

        expect(shouldGenerate, isTrue);
      });

      test('Should handle boundary conditions', () {
        // Exactly at threshold
        final shouldGenerate1 = ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: 1000.0,
          totalMass: 100.0,
          massThreshold: 100.0,
          energyThreshold: 1000.0,
        );

        expect(shouldGenerate1, isTrue);

        // Just below threshold
        final shouldGenerate2 = ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: 999.0,
          totalMass: 99.0,
          massThreshold: 100.0,
          energyThreshold: 1000.0,
        );

        expect(shouldGenerate2, isFalse);
      });
    });

    group('Plasma Jet Velocity Calculations', () {
      test('Should calculate plasma jet velocity', () {
        final velocity = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 2000.0,
          temperature: 50000.0,
        );

        expect(velocity, greaterThanOrEqualTo(10.0));
        expect(velocity, lessThanOrEqualTo(200.0));
      });

      test('Should scale with impact energy', () {
        final velocity1 = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 10.0,
          temperature: 10000.0,
        );

        final velocity2 = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 100.0,
          temperature: 10000.0,
        );

        expect(velocity2, greaterThan(velocity1));
      });

      test('Should scale with temperature', () {
        final velocity1 = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 10.0,
          temperature: 5000.0,
        );

        final velocity2 = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 10.0,
          temperature: 20000.0,
        );

        expect(velocity2, greaterThan(velocity1));
      });

      test('Should clamp to maximum velocity', () {
        final velocity = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 1000000.0,
          temperature: 1000000.0,
        );

        expect(velocity, equals(200.0));
      });

      test('Should clamp to minimum velocity', () {
        final velocity = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
          impactEnergy: 0.1,
          temperature: 100.0,
        );

        expect(velocity, equals(10.0));
      });
    });

    group('Particle Count Calculations', () {
      test('Should calculate particle count within bounds', () {
        final count = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: 100.0,
        );

        expect(count, greaterThanOrEqualTo(5));
        expect(count, lessThanOrEqualTo(50));
      });

      test('Should scale count with impact energy', () {
        final count1 = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: 1.0,
        );

        final count2 = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: 10000.0,
        );

        expect(count2, greaterThan(count1));
      });

      test('Should respect custom min and max counts', () {
        final count = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: 100.0,
          minParticles: 10,
          maxParticles: 100,
        );

        expect(count, greaterThanOrEqualTo(10));
        expect(count, lessThanOrEqualTo(100));
      });

      test('Should return integer values', () {
        final count = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: 75.5,
        );

        expect(count, isA<int>());
      });

      test('Should handle zero energy gracefully', () {
        final count = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: 0.0,
        );

        expect(count, equals(5)); // Should return minimum
      });

      test('Should handle extreme energy values', () {
        final count = ParticlePhysicsUtils.calculateParticleCount(
          impactEnergy: double.maxFinite / 2,
        );

        expect(count, equals(50)); // Should return maximum
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Should handle identical body positions', () {
        body2.position.setFrom(body1.position);

        final direction = ParticlePhysicsUtils.calculateCollisionDirection(
          body1,
          body2,
        );

        // With identical positions, direction is zero vector
        expect(direction.length, closeTo(0.0, 0.001));
      });

      test('Should handle zero mass bodies gracefully', () {
        body1.mass = 0.0;
        body2.mass = 0.0;

        // Should not throw error
        expect(
          () => ParticlePhysicsUtils.calculateImpactEnergy(body1, body2),
          returnsNormally,
        );
      });

      test('Should handle very large energy values', () {
        body1.mass = 1000000.0;
        body2.mass = 1000000.0;
        body1.velocity.setValues(10000, 0, 0);
        body2.velocity.setValues(-10000, 0, 0);

        final energy = ParticlePhysicsUtils.calculateImpactEnergy(body1, body2);

        expect(energy.isFinite, isTrue);
        expect(energy, greaterThan(0.0));
      });

      test('Should handle negative temperatures in color generation', () {
        final color = ParticlePhysicsUtils.generateDebrisColor(
          baseColor: AppColors.celestialRedPlanet,
          temperature: -1000.0,
          random: random,
        );

        expect(color, isNotNull);
        expect(color, isA<Color>());
      });
    });
  });
}
