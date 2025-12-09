import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/constants/relativistic_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/core/constants/test_constants.dart';
import 'package:graviton/utils/relativistic_physics_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('RelativisticPhysicsUtils Tests', () {
    group('Lorentz Factor Calculations', () {
      test('should return 1.0 for zero velocity', () {
        final velocity = vm.Vector3.zero();
        final gamma = RelativisticPhysicsUtils.calculateLorentzFactor(velocity);

        expect(gamma, equals(1.0));
      });

      test('should return correct gamma for slow velocities', () {
        // v = 0.1c
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.1, 0.0, 0.0);
        final gamma = RelativisticPhysicsUtils.calculateLorentzFactor(velocity);

        // γ = 1/√(1-0.01) = 1/√0.99 ≈ 1.005
        final expectedGamma = 1.0 / math.sqrt(0.99);
        expect(
          gamma,
          closeTo(expectedGamma, TestConstants.physicsTestTolerance),
        );
      });

      test('should return correct gamma for moderate velocities', () {
        // v = 0.5c
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(0.0, c * 0.5, 0.0);
        final gamma = RelativisticPhysicsUtils.calculateLorentzFactor(velocity);

        // γ = 1/√(1-0.25) = 1/√0.75 ≈ 1.1547
        final expectedGamma = 1.0 / math.sqrt(0.75);
        expect(
          gamma,
          closeTo(expectedGamma, TestConstants.physicsTestTolerance),
        );
      });

      test('should return high gamma for near-light-speed velocities', () {
        // v = 0.9c
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(0.0, 0.0, c * 0.9);
        final gamma = RelativisticPhysicsUtils.calculateLorentzFactor(velocity);

        // γ = 1/√(1-0.81) = 1/√0.19 ≈ 2.294
        final expectedGamma = 1.0 / math.sqrt(0.19);
        expect(gamma, closeTo(expectedGamma, 0.01));
      });

      test('should handle velocities exceeding maxBeta safely', () {
        // Try to exceed maxBeta (should be clamped)
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.99, 0.0, 0.0);
        final gamma = RelativisticPhysicsUtils.calculateLorentzFactor(velocity);

        // Should be clamped to maxBeta = 0.95
        expect(gamma.isFinite, isTrue);
        expect(gamma, greaterThan(1.0));
      });

      test('should work with 3D velocity vectors', () {
        final c = RelativisticConstants.speedOfLight;
        // v = (0.3c, 0.3c, 0.3c), |v| ≈ 0.52c
        final velocity = vm.Vector3(c * 0.3, c * 0.3, c * 0.3);
        final beta = velocity.length / c;
        final expectedGamma = 1.0 / math.sqrt(1.0 - beta * beta);

        final gamma = RelativisticPhysicsUtils.calculateLorentzFactor(velocity);

        expect(gamma, closeTo(expectedGamma, 0.01));
      });
    });

    group('Beta (v/c) Calculations', () {
      test('should return 0.0 for zero velocity', () {
        final velocity = vm.Vector3.zero();
        final beta = RelativisticPhysicsUtils.calculateBeta(velocity);

        expect(beta, equals(0.0));
      });

      test('should return correct beta for known velocities', () {
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.5, 0.0, 0.0);
        final beta = RelativisticPhysicsUtils.calculateBeta(velocity);

        expect(beta, closeTo(0.5, TestConstants.physicsTestTolerance));
      });

      test('should handle zero speed of light', () {
        final velocity = vm.Vector3(1.0, 0.0, 0.0);
        final beta = RelativisticPhysicsUtils.calculateBeta(
          velocity,
          speedOfLight: 0.0,
        );

        expect(beta, equals(0.0));
      });

      test('should calculate beta for 3D velocities', () {
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.6, c * 0.8, 0.0);
        // |v| = c * √(0.36 + 0.64) = c * 1.0
        final beta = RelativisticPhysicsUtils.calculateBeta(velocity);

        expect(beta, closeTo(1.0, 0.01));
      });
    });

    group('Velocity Capping', () {
      test('should not modify velocities below maxBeta', () {
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.5, 0.0, 0.0);
        final capped = RelativisticPhysicsUtils.capVelocity(velocity);

        expect(
          capped.x,
          closeTo(velocity.x, TestConstants.physicsTestTolerance),
        );
        expect(capped.y, equals(velocity.y));
        expect(capped.z, equals(velocity.z));
      });

      test('should cap velocities exceeding maxBeta', () {
        final c = RelativisticConstants.speedOfLight;
        // Try to exceed maxBeta
        final velocity = vm.Vector3(c * 0.99, 0.0, 0.0);
        final capped = RelativisticPhysicsUtils.capVelocity(velocity);

        final beta = RelativisticPhysicsUtils.calculateBeta(capped);
        expect(beta, lessThanOrEqualTo(RelativisticConstants.maxBeta + 0.01));
      });

      test('should preserve direction when capping', () {
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.6, c * 0.6, c * 0.6);
        final capped = RelativisticPhysicsUtils.capVelocity(velocity);

        // Direction should be preserved (unit vectors should match)
        final origDir = velocity.normalized();
        final cappedDir = capped.normalized();

        expect(cappedDir.x, closeTo(origDir.x, 0.01));
        expect(cappedDir.y, closeTo(origDir.y, 0.01));
        expect(cappedDir.z, closeTo(origDir.z, 0.01));
      });
    });

    group('Time Dilation Calculations', () {
      test('should return 1.0 for zero velocity', () {
        final velocity = vm.Vector3.zero();
        final dilation = RelativisticPhysicsUtils.calculateTimeDilation(
          velocity,
        );

        expect(dilation, equals(1.0));
      });

      test('should return correct dilation for moderate speeds', () {
        // v = 0.5c → γ ≈ 1.1547 → dilation ≈ 0.866
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.5, 0.0, 0.0);
        final dilation = RelativisticPhysicsUtils.calculateTimeDilation(
          velocity,
        );

        final expectedDilation = math.sqrt(0.75); // √(1-0.25)
        expect(
          dilation,
          closeTo(expectedDilation, TestConstants.physicsTestTolerance),
        );
      });

      test('should return small dilation for very high speeds', () {
        // v = 0.9c → significant time dilation
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(0.0, c * 0.9, 0.0);
        final dilation = RelativisticPhysicsUtils.calculateTimeDilation(
          velocity,
        );

        expect(dilation, lessThan(0.5)); // Time passes slower
        expect(dilation, greaterThan(0.0));
      });
    });

    group('1PN Acceleration Corrections', () {
      test('should reduce to classical for zero velocities', () {
        final pos1 = vm.Vector3.zero();
        final pos2 = vm.Vector3(10.0, 0.0, 0.0);
        final vel1 = vm.Vector3.zero();
        final vel2 = vm.Vector3.zero();
        const mass2 = 10.0;

        final accel1PN = RelativisticPhysicsUtils.calculate1PNAcceleration(
          pos1,
          vel1,
          pos2,
          vel2,
          mass2,
        );

        // Should be close to classical Newtonian at zero velocity
        final r = pos2 - pos1;
        final dist2 = r.length2 + SimulationConstants.softening;
        final invR = 1.0 / math.sqrt(dist2);
        final invR3 = invR * invR * invR;
        final classicalAccel =
            r * (SimulationConstants.gravitationalConstant * mass2 * invR3);

        // 1PN should be close but not exact to classical at zero velocity
        expect(accel1PN.x, closeTo(classicalAccel.x, 0.01));
        expect(accel1PN.y, closeTo(classicalAccel.y, 0.01));
        expect(accel1PN.z, closeTo(classicalAccel.z, 0.01));
      });

      test('should add corrections for high velocities', () {
        final pos1 = vm.Vector3.zero();
        final pos2 = vm.Vector3(10.0, 0.0, 0.0);
        final c = RelativisticConstants.speedOfLight;
        final vel1 = vm.Vector3(0.0, c * 0.5, 0.0); // 0.5c perpendicular
        final vel2 = vm.Vector3.zero();
        const mass2 = 10.0;

        final accel1PN = RelativisticPhysicsUtils.calculate1PNAcceleration(
          pos1,
          vel1,
          pos2,
          vel2,
          mass2,
        );

        // Calculate classical for comparison
        final r = pos2 - pos1;
        final dist2 = r.length2 + SimulationConstants.softening;
        final invR = 1.0 / math.sqrt(dist2);
        final invR3 = invR * invR * invR;
        final classicalAccel =
            r * (SimulationConstants.gravitationalConstant * mass2 * invR3);

        // 1PN correction should differ from classical
        final difference = (accel1PN - classicalAccel).length;
        expect(difference, greaterThan(0.0));
      });

      test('should return finite values for realistic scenarios', () {
        final pos1 = vm.Vector3(5.0, 3.0, 2.0);
        final pos2 = vm.Vector3(15.0, 8.0, 6.0);
        final vel1 = vm.Vector3(1.0, 0.5, 0.3);
        final vel2 = vm.Vector3(0.8, 1.2, 0.2);
        const mass2 = 20.0;

        final accel1PN = RelativisticPhysicsUtils.calculate1PNAcceleration(
          pos1,
          vel1,
          pos2,
          vel2,
          mass2,
        );

        expect(accel1PN.x.isFinite, isTrue);
        expect(accel1PN.y.isFinite, isTrue);
        expect(accel1PN.z.isFinite, isTrue);
      });
    });

    group('Relativistic Momentum', () {
      test('should reduce to classical for low speeds', () {
        const mass = 10.0;
        final velocity = vm.Vector3(0.1, 0.0, 0.0);

        final pRel = RelativisticPhysicsUtils.calculateRelativisticMomentum(
          mass,
          velocity,
        );
        final pClassical = velocity * mass;

        // Use relative tolerance for low-speed momentum
        expect(pRel.x, closeTo(pClassical.x, 0.001));
      });

      test('should be larger than classical for high speeds', () {
        const mass = 10.0;
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.8, 0.0, 0.0);

        final pRel = RelativisticPhysicsUtils.calculateRelativisticMomentum(
          mass,
          velocity,
        );
        final pClassical = velocity * mass;

        expect(pRel.length, greaterThan(pClassical.length));
      });
    });

    group('Relativistic Kinetic Energy', () {
      test('should be approximately classical for low speeds', () {
        const mass = 10.0;
        final velocity = vm.Vector3(0.5, 0.0, 0.0);

        final keRel =
            RelativisticPhysicsUtils.calculateRelativisticKineticEnergy(
              mass,
              velocity,
            );
        final keClassical = 0.5 * mass * velocity.length2;

        // Should be close for low velocities (within 5%)
        expect(keRel, closeTo(keClassical, keClassical * 0.05));
      });

      test('should be much larger than classical for high speeds', () {
        const mass = 10.0;
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.9, 0.0, 0.0);

        final keRel =
            RelativisticPhysicsUtils.calculateRelativisticKineticEnergy(
              mass,
              velocity,
            );
        final keClassical = 0.5 * mass * velocity.length2;

        expect(keRel, greaterThan(keClassical * 2.0));
      });

      test('should return zero for zero velocity', () {
        const mass = 10.0;
        final velocity = vm.Vector3.zero();

        final keRel =
            RelativisticPhysicsUtils.calculateRelativisticKineticEnergy(
              mass,
              velocity,
            );

        expect(keRel, closeTo(0.0, TestConstants.physicsTestTolerance));
      });
    });

    group('Proper Time Updates', () {
      test('should advance by dt for zero velocity', () {
        const properTime = 100.0;
        const dt = 1.0;
        final velocity = vm.Vector3.zero();

        final newProperTime = RelativisticPhysicsUtils.updateProperTime(
          properTime,
          dt,
          velocity,
        );

        expect(
          newProperTime,
          closeTo(properTime + dt, TestConstants.physicsTestTolerance),
        );
      });

      test('should advance slower for high velocities', () {
        const properTime = 100.0;
        const dt = 1.0;
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.9, 0.0, 0.0);

        final newProperTime = RelativisticPhysicsUtils.updateProperTime(
          properTime,
          dt,
          velocity,
        );

        // Proper time should advance less than coordinate time
        expect(newProperTime - properTime, lessThan(dt));
        expect(newProperTime, greaterThan(properTime));
      });
    });

    group('Utility Functions', () {
      test(
        'shouldUseRelativisticCorrections returns false for slow objects',
        () {
          final velocity = vm.Vector3(0.5, 0.0, 0.0);

          final shouldUse =
              RelativisticPhysicsUtils.shouldUseRelativisticCorrections(
                velocity,
              );

          expect(shouldUse, isFalse);
        },
      );

      test(
        'shouldUseRelativisticCorrections returns true for fast objects',
        () {
          final velocity = vm.Vector3(2.0, 0.0, 0.0);

          final shouldUse =
              RelativisticPhysicsUtils.shouldUseRelativisticCorrections(
                velocity,
              );

          expect(shouldUse, isTrue);
        },
      );

      test('shouldShowRelativisticEffects returns false for slow objects', () {
        final velocity = vm.Vector3(0.1, 0.0, 0.0);

        final shouldShow =
            RelativisticPhysicsUtils.shouldShowRelativisticEffects(velocity);

        expect(shouldShow, isFalse);
      });

      test(
        'shouldShowRelativisticEffects returns true for moderate speeds',
        () {
          final c = RelativisticConstants.speedOfLight;
          final velocity = vm.Vector3(c * 0.2, 0.0, 0.0);

          final shouldShow =
              RelativisticPhysicsUtils.shouldShowRelativisticEffects(velocity);

          expect(shouldShow, isTrue);
        },
      );

      test('getColorShiftFactor returns 0 for slow objects', () {
        final velocity = vm.Vector3(0.1, 0.0, 0.0);

        final factor = RelativisticPhysicsUtils.getColorShiftFactor(velocity);

        expect(factor, equals(0.0));
      });

      test('getColorShiftFactor returns value between 0 and 1', () {
        final c = RelativisticConstants.speedOfLight;
        final velocity = vm.Vector3(c * 0.5, 0.0, 0.0);

        final factor = RelativisticPhysicsUtils.getColorShiftFactor(velocity);

        expect(factor, greaterThanOrEqualTo(0.0));
        expect(factor, lessThanOrEqualTo(1.0));
      });

      test('getColorShiftFactor increases with velocity', () {
        final c = RelativisticConstants.speedOfLight;
        final vel1 = vm.Vector3(c * 0.2, 0.0, 0.0);
        final vel2 = vm.Vector3(c * 0.5, 0.0, 0.0);
        final vel3 = vm.Vector3(c * 0.8, 0.0, 0.0);

        final factor1 = RelativisticPhysicsUtils.getColorShiftFactor(vel1);
        final factor2 = RelativisticPhysicsUtils.getColorShiftFactor(vel2);
        final factor3 = RelativisticPhysicsUtils.getColorShiftFactor(vel3);

        expect(factor2, greaterThan(factor1));
        expect(factor3, greaterThan(factor2));
      });
    });
  });
}
