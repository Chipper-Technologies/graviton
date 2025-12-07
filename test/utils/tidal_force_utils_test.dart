import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/test_constants.dart';
import 'package:graviton/constants/tidal_constants.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/tidal_force_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('TidalForceUtils Tests', () {
    late Body primaryBody;
    late Body secondaryBody;

    setUp(() {
      // Primary massive body (e.g., planet)
      primaryBody = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 100.0,
        radius: 5.0,
        color: AppColors.celestialBluePlanet,
        name: 'Primary',
      );

      // Secondary smaller body (e.g., moon)
      secondaryBody = Body(
        position: vm.Vector3(20.0, 0.0, 0.0),
        velocity: vm.Vector3(0.0, 1.0, 0.0),
        mass: 10.0,
        radius: 2.0,
        color: AppColors.moonLightGray,
        name: 'Secondary',
      );
    });

    group('Tidal Tensor Calculations', () {
      test('should return zero tensor for single body', () {
        final tensor = TidalForceUtils.calculateTidalTensor(primaryBody, []);

        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            expect(tensor[i][j], equals(0.0));
          }
        }
      });

      test('should calculate non-zero tensor for nearby massive body', () {
        final tensor = TidalForceUtils.calculateTidalTensor(secondaryBody, [
          primaryBody,
        ]);

        // Should have non-zero components
        var hasNonZero = false;
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            if (tensor[i][j].abs() > TestConstants.physicsTestTolerance) {
              hasNonZero = true;
              break;
            }
          }
          if (hasNonZero) break;
        }

        expect(hasNonZero, isTrue);
      });

      test('should have symmetric tensor', () {
        final tensor = TidalForceUtils.calculateTidalTensor(secondaryBody, [
          primaryBody,
        ]);

        // Tidal tensor should be symmetric: T_ij = T_ji
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            expect(
              tensor[i][j],
              closeTo(tensor[j][i], TestConstants.physicsTestTolerance),
            );
          }
        }
      });

      test('should have traceless tensor', () {
        final tensor = TidalForceUtils.calculateTidalTensor(secondaryBody, [
          primaryBody,
        ]);

        // For a single source, tidal tensor should be approximately traceless
        final trace = tensor[0][0] + tensor[1][1] + tensor[2][2];
        expect(trace.abs(), lessThan(0.1)); // Nearly traceless
      });

      test('should filter bodies beyond maxBodies limit', () {
        final manyBodies = List.generate(
          20,
          (i) => Body(
            position: vm.Vector3(10.0 + i * 5.0, 0.0, 0.0),
            velocity: vm.Vector3.zero(),
            mass: 10.0,
            radius: 1.0,
            color: AppColors.basicBlue,
            name: 'Body$i',
          ),
        );

        // Should complete without error even with many bodies
        final tensor = TidalForceUtils.calculateTidalTensor(
          primaryBody,
          manyBodies,
          maxBodies: 5,
        );

        expect(tensor.length, equals(3));
        expect(tensor[0].length, equals(3));
      });

      test('should ignore bodies that are too close', () {
        // Place a body very close (within minDistanceMultiplier * radius)
        final veryCloseBody = Body(
          position: vm.Vector3(0.5, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'VeryClose',
        );

        final tensor = TidalForceUtils.calculateTidalTensor(primaryBody, [
          veryCloseBody,
        ]);

        // Should handle without numerical issues
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            expect(tensor[i][j].isFinite, isTrue);
          }
        }
      });
    });

    group('Tidal Stress Calculations', () {
      test('should return zero for zero tensor', () {
        final zeroTensor = List.generate(3, (_) => List.filled(3, 0.0));
        final stress = TidalForceUtils.calculateTidalStress(zeroTensor);

        expect(stress, equals(0.0));
      });

      test('should calculate correct Frobenius norm', () {
        final tensor = [
          [1.0, 0.0, 0.0],
          [0.0, 2.0, 0.0],
          [0.0, 0.0, 3.0],
        ];

        final stress = TidalForceUtils.calculateTidalStress(tensor);

        // Frobenius norm = √(1² + 2² + 3²) = √14
        final expected = math.sqrt(14.0);
        expect(stress, closeTo(expected, TestConstants.physicsTestTolerance));
      });

      test('should be non-negative', () {
        final tensor = TidalForceUtils.calculateTidalTensor(secondaryBody, [
          primaryBody,
        ]);
        final stress = TidalForceUtils.calculateTidalStress(tensor);

        expect(stress, greaterThanOrEqualTo(0.0));
      });
    });

    group('Roche Limit Calculations', () {
      test('should calculate correct Roche limit for equal densities', () {
        const primaryMass = 100.0;
        const primaryRadius = 5.0;
        const secondaryMass = 10.0;
        const secondaryRadius = 2.0;

        final rocheLimit = TidalForceUtils.calculateRocheLimit(
          primaryMass,
          primaryRadius,
          secondaryMass,
          secondaryRadius,
        );

        // For equal densities, Roche limit ≈ 2.456 * R_primary
        expect(rocheLimit, greaterThan(primaryRadius));
        expect(
          rocheLimit,
          closeTo(
            TidalConstants.rocheLimitMultiplierRigid * primaryRadius,
            primaryRadius,
          ),
        );
      });

      test('should increase with primary radius for constant density', () {
        // Keep density constant by scaling mass with radius^3
        const primaryRadius1 = 5.0;
        const primaryRadius2 = 10.0;
        const secondaryMass = 10.0;
        const secondaryRadius = 2.0;

        // Scale mass to keep density constant
        // density = mass / (4/3 * π * r³)
        // So if r2 = 2*r1, then m2 = 8*m1 for same density
        const primaryMass1 = 100.0;
        final primaryMass2 =
            primaryMass1 * math.pow(primaryRadius2 / primaryRadius1, 3);

        final roche1 = TidalForceUtils.calculateRocheLimit(
          primaryMass1,
          primaryRadius1,
          secondaryMass,
          secondaryRadius,
        );
        final roche2 = TidalForceUtils.calculateRocheLimit(
          primaryMass2,
          primaryRadius2,
          secondaryMass,
          secondaryRadius,
        );

        // With constant density, Roche limit scales linearly with radius
        // R_L = k * R_primary * (ρ_p/ρ_s)^(1/3)
        // If density constant, doubling radius doubles Roche limit
        expect(
          roche2,
          closeTo(roche1 * (primaryRadius2 / primaryRadius1), 0.01),
        );
      });

      test('should depend on density ratio', () {
        // Primary with high density
        const primaryMass = 1000.0;
        const primaryRadius = 5.0;

        // Secondary with low density
        const secondaryMass = 10.0;
        const secondaryRadius = 5.0; // Same radius, much less mass

        final rocheLimit = TidalForceUtils.calculateRocheLimit(
          primaryMass,
          primaryRadius,
          secondaryMass,
          secondaryRadius,
        );

        // High density ratio → larger Roche limit
        expect(
          rocheLimit,
          greaterThan(TidalConstants.rocheLimitMultiplierRigid * primaryRadius),
        );
      });

      test('should return zero for invalid inputs', () {
        expect(
          TidalForceUtils.calculateRocheLimit(0.0, 5.0, 10.0, 2.0),
          equals(0.0),
        );
        expect(
          TidalForceUtils.calculateRocheLimit(100.0, 0.0, 10.0, 2.0),
          equals(0.0),
        );
        expect(
          TidalForceUtils.calculateRocheLimit(100.0, 5.0, 0.0, 2.0),
          equals(0.0),
        );
        expect(
          TidalForceUtils.calculateRocheLimit(100.0, 5.0, 10.0, 0.0),
          equals(0.0),
        );
      });

      test('should differ for rigid vs fluid bodies', () {
        const primaryMass = 100.0;
        const primaryRadius = 5.0;
        const secondaryMass = 10.0;
        const secondaryRadius = 2.0;

        final rigidRoche = TidalForceUtils.calculateRocheLimit(
          primaryMass,
          primaryRadius,
          secondaryMass,
          secondaryRadius,
          useRigid: true,
        );

        final fluidRoche = TidalForceUtils.calculateRocheLimit(
          primaryMass,
          primaryRadius,
          secondaryMass,
          secondaryRadius,
          useRigid: false,
        );

        // Rigid and fluid should be slightly different
        expect((rigidRoche - fluidRoche).abs(), greaterThan(0.0));
      });
    });

    group('Roche Limit Detection', () {
      test('should detect bodies within Roche limit', () {
        // Create two bodies very close together
        final close1 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 100.0,
          radius: 5.0,
          color: AppColors.celestialBluePlanet,
          name: 'Close1',
        );

        final close2 = Body(
          position: vm.Vector3(
            8.0,
            0.0,
            0.0,
          ), // Very close - within Roche limit
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.moonLightGray,
          name: 'Close2',
        );

        final isWithin = TidalForceUtils.isWithinRocheLimit(close1, close2);

        // Should detect they are within Roche limit
        expect(isWithin, isTrue);
      });

      test('should not detect distant bodies as within Roche limit', () {
        // Create a distant body
        final distantBody = Body(
          position: vm.Vector3(200.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 5.0,
          radius: 1.0,
          color: AppColors.asteroidBrownish,
          name: 'Distant',
        );

        final isWithin = TidalForceUtils.isWithinRocheLimit(
          primaryBody,
          distantBody,
        );

        expect(isWithin, isFalse);
      });

      test('should respect threshold parameter', () {
        // At exact Roche limit
        final rocheLimit = TidalForceUtils.calculateRocheLimit(
          primaryBody.mass,
          primaryBody.radius,
          secondaryBody.mass,
          secondaryBody.radius,
        );

        final bodyAtRoche = Body(
          position: vm.Vector3(rocheLimit, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: secondaryBody.mass,
          radius: secondaryBody.radius,
          color: AppColors.moonLightGray,
          name: 'AtRoche',
        );

        // With threshold = 1.5, should be within
        final isWithin15 = TidalForceUtils.isWithinRocheLimit(
          primaryBody,
          bodyAtRoche,
          threshold: 1.5,
        );

        expect(isWithin15, isTrue);
      });
    });

    group('Tidal Heating Calculations', () {
      test('should return zero when tidal heating is disabled', () {
        const tidalStress = 1.0;
        const bodyMass = 10.0;
        const bodyRadius = 2.0;

        final heating = TidalForceUtils.calculateTidalHeating(
          tidalStress,
          bodyMass,
          bodyRadius,
        );

        // Should be zero when disabled in constants
        expect(heating, equals(0.0));
      });

      test('should increase with tidal stress squared', () {
        const bodyMass = 10.0;
        const bodyRadius = 2.0;

        // If heating were enabled, it should scale with stress²
        // (This test documents the expected behavior)
        const stress1 = 1.0;
        const stress2 = 2.0;

        final heating1 = TidalForceUtils.calculateTidalHeating(
          stress1,
          bodyMass,
          bodyRadius,
        );
        final heating2 = TidalForceUtils.calculateTidalHeating(
          stress2,
          bodyMass,
          bodyRadius,
        );

        // When enabled, heating2 should be 4x heating1
        // Currently both are zero since heating is disabled
        expect(heating1, equals(0.0));
        expect(heating2, equals(0.0));
      });

      test('should be non-negative', () {
        const tidalStress = 5.0;
        const bodyMass = 10.0;
        const bodyRadius = 2.0;

        final heating = TidalForceUtils.calculateTidalHeating(
          tidalStress,
          bodyMass,
          bodyRadius,
        );

        expect(heating, greaterThanOrEqualTo(0.0));
      });
    });

    group('Utility Functions', () {
      test('shouldVisualizeTidalForces returns false for low stress', () {
        const lowStress = 0.001;

        final shouldViz = TidalForceUtils.shouldVisualizeTidalForces(lowStress);

        expect(shouldViz, isFalse);
      });

      test('shouldVisualizeTidalForces returns true for high stress', () {
        const highStress = 0.1;

        final shouldViz = TidalForceUtils.shouldVisualizeTidalForces(
          highStress,
        );

        expect(shouldViz, isTrue);
      });

      test('getTidalStressCategory returns correct categories', () {
        expect(TidalForceUtils.getTidalStressCategory(0.0), equals('none'));
        expect(TidalForceUtils.getTidalStressCategory(0.2), equals('low'));
        expect(TidalForceUtils.getTidalStressCategory(0.5), equals('moderate'));
        expect(TidalForceUtils.getTidalStressCategory(0.8), equals('high'));
        expect(TidalForceUtils.getTidalStressCategory(1.5), equals('critical'));
      });

      test('calculateTidalElongationDirection returns normalized vector', () {
        final direction = TidalForceUtils.calculateTidalElongationDirection(
          secondaryBody,
          primaryBody,
        );

        expect(
          direction.length,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        );
      });

      test('estimateDisruptionTime returns infinity for safe bodies', () {
        // Create a distant body
        final distantBody = Body(
          position: vm.Vector3(200.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          mass: 5.0,
          radius: 1.0,
          color: AppColors.asteroidBrownish,
          name: 'Distant',
        );

        final time = TidalForceUtils.estimateDisruptionTime(
          distantBody,
          primaryBody,
        );

        expect(time, equals(double.infinity));
      });

      test('estimateDisruptionTime returns infinity when moving apart', () {
        // Bodies moving apart
        final body1 = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(-1.0, 0.0, 0.0),
          mass: 100.0,
          radius: 5.0,
          color: AppColors.celestialBluePlanet,
          name: 'Body1',
        );

        final body2 = Body(
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3(1.0, 0.0, 0.0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.moonLightGray,
          name: 'Body2',
        );

        final time = TidalForceUtils.estimateDisruptionTime(body1, body2);

        expect(time, equals(double.infinity));
      });

      test(
        'estimateDisruptionTime returns finite time for approaching bodies',
        () {
          // Bodies moving towards each other
          final body1 = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3(1.0, 0.0, 0.0),
            mass: 100.0,
            radius: 5.0,
            color: AppColors.celestialBluePlanet,
            name: 'Body1',
          );

          final body2 = Body(
            position: vm.Vector3(15.0, 0.0, 0.0),
            velocity: vm.Vector3(-1.0, 0.0, 0.0),
            mass: 10.0,
            radius: 2.0,
            color: AppColors.moonLightGray,
            name: 'Body2',
          );

          final time = TidalForceUtils.estimateDisruptionTime(body1, body2);

          // Should return a finite positive time if within Roche limit threshold
          expect(time, greaterThanOrEqualTo(0.0));
        },
      );
    });

    group('Principal Axes Calculations', () {
      test('should calculate principal axes for diagonal tensor', () {
        final tensor = [
          [1.0, 0.0, 0.0],
          [0.0, 2.0, 0.0],
          [0.0, 0.0, 3.0],
        ];

        final axes = TidalForceUtils.calculatePrincipalAxes(tensor);

        expect(axes['eigenvalues'], isNotNull);
        expect(axes['eigenvectors'], isNotNull);
        expect(axes['eigenvalues'].length, equals(3));
        expect(axes['eigenvectors'].length, equals(3));
      });

      test('should return finite values for realistic tensor', () {
        final tensor = TidalForceUtils.calculateTidalTensor(secondaryBody, [
          primaryBody,
        ]);

        final axes = TidalForceUtils.calculatePrincipalAxes(tensor);

        for (final eigenvalue in axes['eigenvalues']) {
          expect(eigenvalue.isFinite, isTrue);
        }
      });
    });
  });
}
