import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/test_constants.dart';
import 'package:graviton/utils/physics_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('PhysicsUtils Tests', () {
    group('Gravitational Acceleration', () {
      test('should calculate correct gravitational acceleration', () {
        final pos1 = vm.Vector3(0, 0, 0);
        final pos2 = vm.Vector3(1, 0, 0);
        const mass2 = 1.0;

        final acceleration = PhysicsUtils.calculateGravitationalAcceleration(
          pos1,
          pos2,
          mass2,
        );

        // Should point toward mass2 (positive x direction)
        expect(acceleration.x, greaterThan(0));
        expect(acceleration.y, closeTo(0, TestConstants.physicsTestTolerance));
        expect(acceleration.z, closeTo(0, TestConstants.physicsTestTolerance));
      });

      test('should handle zero distance with softening', () {
        final pos1 = vm.Vector3(0, 0, 0);
        final pos2 = vm.Vector3(0, 0, 0);
        const mass2 = 1.0;

        expect(
          () => PhysicsUtils.calculateGravitationalAcceleration(
            pos1,
            pos2,
            mass2,
          ),
          returnsNormally,
        );
      });

      test('should follow inverse square law', () {
        final pos1 = vm.Vector3(0, 0, 0);
        final pos2_1 = vm.Vector3(1, 0, 0);
        final pos2_2 = vm.Vector3(2, 0, 0);
        const mass2 = 1.0;

        final accel1 = PhysicsUtils.calculateGravitationalAcceleration(
          pos1,
          pos2_1,
          mass2,
          softening: 0.0,
        );
        final accel2 = PhysicsUtils.calculateGravitationalAcceleration(
          pos1,
          pos2_2,
          mass2,
          softening: 0.0,
        );

        // Acceleration should be ~4 times smaller at double the distance (without softening)
        expect(
          accel1.x / accel2.x,
          closeTo(4.0, TestConstants.physicsTestTolerance),
        );
      });
    });

    group('Energy Calculations', () {
      test('should calculate energy received correctly', () {
        const luminosity = 1.0;
        const distance = 1.0;

        final energy = PhysicsUtils.calculateEnergyReceived(
          luminosity,
          distance,
        );

        expect(energy, closeTo(1.0, TestConstants.physicsTestTolerance));
      });

      test('should return zero for zero luminosity', () {
        const luminosity = 0.0;
        const distance = 1.0;

        final energy = PhysicsUtils.calculateEnergyReceived(
          luminosity,
          distance,
        );

        expect(energy, equals(0.0));
      });

      test('should return zero for zero distance', () {
        const luminosity = 1.0;
        const distance = 0.0;

        final energy = PhysicsUtils.calculateEnergyReceived(
          luminosity,
          distance,
        );

        expect(energy, equals(0.0));
      });

      test('should calculate total energy from multiple sources', () {
        final receiverPos = vm.Vector3(0, 0, 0);
        final sources = [
          MapEntry(vm.Vector3(1, 0, 0), 1.0), // luminosity 1 at distance 1
          MapEntry(vm.Vector3(2, 0, 0), 4.0), // luminosity 4 at distance 2
        ];

        final totalEnergy = PhysicsUtils.calculateTotalEnergyReceived(
          receiverPos,
          sources,
        );

        // Energy from source 1: 1/1² = 1.0
        // Energy from source 2: 4/2² = 1.0
        // Total: 2.0
        expect(totalEnergy, closeTo(2.0, TestConstants.physicsTestTolerance));
      });
    });

    group('Habitable Zone Calculations', () {
      test('should calculate habitable zone boundaries', () {
        const luminosity = 1.0; // Solar luminosity

        final boundaries = PhysicsUtils.calculateHabitableZoneBoundaries(
          luminosity,
        );

        expect(boundaries['inner'], greaterThan(0));
        expect(boundaries['outer'], greaterThan(boundaries['inner']!));
      });

      test('should return zero boundaries for insufficient luminosity', () {
        const luminosity = 0.001; // Below minimum threshold

        final boundaries = PhysicsUtils.calculateHabitableZoneBoundaries(
          luminosity,
        );

        expect(boundaries['inner'], equals(0.0));
        expect(boundaries['outer'], equals(0.0));
      });

      test('should scale with sqrt of luminosity', () {
        const luminosity1 = 1.0;
        const luminosity2 = 4.0; // 4 times brighter

        final boundaries1 = PhysicsUtils.calculateHabitableZoneBoundaries(
          luminosity1,
        );
        final boundaries2 = PhysicsUtils.calculateHabitableZoneBoundaries(
          luminosity2,
        );

        // Boundaries should be √4 = 2 times farther for 4x luminosity
        expect(
          boundaries2['inner']! / boundaries1['inner']!,
          closeTo(2.0, TestConstants.physicsTestTolerance),
        );
        expect(
          boundaries2['outer']! / boundaries1['outer']!,
          closeTo(2.0, TestConstants.physicsTestTolerance),
        );
      });
    });

    group('Orbital Mechanics', () {
      test('should calculate orbital velocity correctly', () {
        const totalMass = 1.0;
        const distance = 1.0;

        final velocity = PhysicsUtils.calculateOrbitalVelocity(
          totalMass,
          distance,
        );

        expect(velocity, greaterThan(0));
        // For unit mass and distance with G=1.2, v = √(G*M/r) = √(1.2*1/1) = √1.2
        expect(
          velocity,
          closeTo(math.sqrt(1.2), TestConstants.physicsTestTolerance),
        );
      });

      test('should return zero for zero mass', () {
        const totalMass = 0.0;
        const distance = 1.0;

        final velocity = PhysicsUtils.calculateOrbitalVelocity(
          totalMass,
          distance,
        );

        expect(velocity, equals(0.0));
      });

      test('should return zero for zero distance', () {
        const totalMass = 1.0;
        const distance = 0.0;

        final velocity = PhysicsUtils.calculateOrbitalVelocity(
          totalMass,
          distance,
        );

        expect(velocity, equals(0.0));
      });

      test('should calculate escape velocity correctly', () {
        const mass = 1.0;
        const radius = 1.0;

        final velocity = PhysicsUtils.calculateEscapeVelocity(mass, radius);

        expect(velocity, greaterThan(0));
        // v_escape = √(2GM/r) = √(2*1.2*1/1) = √2.4
        expect(
          velocity,
          closeTo(math.sqrt(2.4), TestConstants.physicsTestTolerance),
        );
      });
    });

    group('Energy Conservation', () {
      test('should calculate kinetic energy correctly', () {
        const mass = 2.0;
        final velocity = vm.Vector3(1, 0, 0);

        final kineticEnergy = PhysicsUtils.calculateKineticEnergy(
          mass,
          velocity,
        );

        // KE = 0.5 * m * v² = 0.5 * 2 * 1² = 1.0
        expect(kineticEnergy, closeTo(1.0, TestConstants.physicsTestTolerance));
      });

      test('should calculate potential energy correctly', () {
        const mass1 = 1.0;
        const mass2 = 2.0;
        const distance = 1.0;

        final potentialEnergy = PhysicsUtils.calculatePotentialEnergy(
          mass1,
          mass2,
          distance,
          softening: 0.0,
        );

        expect(
          potentialEnergy,
          lessThan(0),
        ); // Gravitational potential is negative
        // PE = -G*m1*m2/r = -1.2*1*2/1 = -2.4 (without softening)
        expect(
          potentialEnergy,
          closeTo(-2.4, TestConstants.physicsTestTolerance),
        );
      });

      test('should calculate total system energy', () {
        final masses = [1.0, 2.0];
        final positions = [vm.Vector3(0, 0, 0), vm.Vector3(1, 0, 0)];
        final velocities = [vm.Vector3(0, 1, 0), vm.Vector3(0, -0.5, 0)];

        final totalEnergy = PhysicsUtils.calculateSystemEnergy(
          masses,
          positions,
          velocities,
        );

        expect(totalEnergy, isA<double>());
        // Should be sum of kinetic and potential energies
      });

      test('should throw error for mismatched array lengths', () {
        final masses = [1.0, 2.0];
        final positions = [vm.Vector3(0, 0, 0)]; // Different length
        final velocities = [vm.Vector3(0, 1, 0), vm.Vector3(0, -0.5, 0)];

        expect(
          () =>
              PhysicsUtils.calculateSystemEnergy(masses, positions, velocities),
          throwsArgumentError,
        );
      });
    });

    group('Center of Mass and Momentum', () {
      test('should calculate center of mass correctly', () {
        final masses = [1.0, 2.0];
        final positions = [vm.Vector3(0, 0, 0), vm.Vector3(3, 0, 0)];

        final centerOfMass = PhysicsUtils.calculateCenterOfMass(
          masses,
          positions,
        );

        // COM = (1*0 + 2*3)/(1+2) = 6/3 = 2 in x direction
        expect(
          centerOfMass.x,
          closeTo(2.0, TestConstants.physicsTestTolerance),
        );
        expect(
          centerOfMass.y,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
        expect(
          centerOfMass.z,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should return zero for empty arrays', () {
        final masses = <double>[];
        final positions = <vm.Vector3>[];

        final centerOfMass = PhysicsUtils.calculateCenterOfMass(
          masses,
          positions,
        );

        expect(centerOfMass, equals(vm.Vector3.zero()));
      });

      test('should calculate system momentum correctly', () {
        final masses = [2.0, 3.0];
        final velocities = [vm.Vector3(1, 0, 0), vm.Vector3(-2, 0, 0)];

        final momentum = PhysicsUtils.calculateSystemMomentum(
          masses,
          velocities,
        );

        // Total momentum = 2*1 + 3*(-2) = 2 - 6 = -4 in x direction
        expect(momentum.x, closeTo(-4.0, TestConstants.physicsTestTolerance));
        expect(momentum.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(momentum.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });
    });

    group('Temperature and Equivalence', () {
      test('should calculate relative temperature correctly', () {
        const totalEnergy = 2.0;
        const earthReference = 1.0;

        final relativeTemp = PhysicsUtils.calculateRelativeTemperature(
          totalEnergy,
          earthReference,
        );

        expect(relativeTemp, closeTo(2.0, TestConstants.physicsTestTolerance));
      });

      test('should return zero for zero earth reference', () {
        const totalEnergy = 1.0;
        const earthReference = 0.0;

        final relativeTemp = PhysicsUtils.calculateRelativeTemperature(
          totalEnergy,
          earthReference,
        );

        expect(relativeTemp, equals(0.0));
      });

      test('should calculate energy to equivalent distance', () {
        const totalEnergy = 1.0;
        const referenceLuminosity = 4.0;

        final distance = PhysicsUtils.energyToEquivalentDistance(
          totalEnergy,
          referenceLuminosity,
        );

        // distance = √(L/E) = √(4/1) = 2
        expect(distance, closeTo(2.0, TestConstants.physicsTestTolerance));
      });

      test('should return infinity for zero energy', () {
        const totalEnergy = 0.0;
        const referenceLuminosity = 1.0;

        final distance = PhysicsUtils.energyToEquivalentDistance(
          totalEnergy,
          referenceLuminosity,
        );

        expect(distance, equals(double.infinity));
      });
    });

    group('Earth Energy Reference', () {
      test('should calculate earth energy reference', () {
        final earthEnergy = PhysicsUtils.calculateEarthEnergyReference();

        expect(earthEnergy, greaterThan(0));
        expect(earthEnergy, isA<double>());
      });
    });
  });
}
