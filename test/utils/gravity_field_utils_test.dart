import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/gravity_field_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('GravityFieldUtils', () {
    late Body testBody;

    setUp(() {
      testBody = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 10.0, // Simulation units (typical star mass)
        radius: 1.0, // Simulation units (typical star radius)
        color: AppColors.basicBlue,
        name: 'Test Body',
        bodyType: BodyType.planet,
      );
    });

    group('calculateFieldStrength', () {
      test('should calculate correct field strength using Newton\'s law', () {
        // Test at 2.0 units distance (outside the body)
        final testPosition = vm.Vector3(2.0, 0.0, 0.0);
        final fieldStrength = GravityFieldUtils.calculateFieldStrength(
          testBody,
          testPosition,
        );

        // Expected: GM/r² = (1.2 * 10.0) / 2.0²
        final expected =
            SimulationConstants.gravitationalConstant * testBody.mass / 4.0;
        expect(fieldStrength, closeTo(expected, expected * 0.01));
      });

      test('should follow inverse square law', () {
        final position1 = vm.Vector3(2.0, 0.0, 0.0); // Outside body
        final position2 = vm.Vector3(4.0, 0.0, 0.0); // 2x distance
        final position4 = vm.Vector3(8.0, 0.0, 0.0); // 4x distance

        final strength1 = GravityFieldUtils.calculateFieldStrength(
          testBody,
          position1,
        );
        final strength2 = GravityFieldUtils.calculateFieldStrength(
          testBody,
          position2,
        );
        final strength4 = GravityFieldUtils.calculateFieldStrength(
          testBody,
          position4,
        );

        // At 2x distance, strength should be 1/4
        expect(strength2, closeTo(strength1 / 4.0, strength1 * 0.01));

        // At 4x distance, strength should be 1/16
        expect(strength4, closeTo(strength1 / 16.0, strength1 * 0.01));
      });

      test('should be independent of direction', () {
        const distance = 5.0;
        final positions = [
          vm.Vector3(distance, 0.0, 0.0), // +X
          vm.Vector3(0.0, distance, 0.0), // +Y
          vm.Vector3(0.0, 0.0, distance), // +Z
          vm.Vector3(-distance, 0.0, 0.0), // -X
          vm.Vector3(0.0, -distance, 0.0), // -Y
          vm.Vector3(0.0, 0.0, -distance), // -Z
        ];

        final expectedStrength = GravityFieldUtils.calculateFieldStrength(
          testBody,
          positions.first,
        );

        for (final position in positions) {
          final strength = GravityFieldUtils.calculateFieldStrength(
            testBody,
            position,
          );
          expect(strength, closeTo(expectedStrength, expectedStrength * 1e-10));
        }
      });

      test('should handle zero distance gracefully', () {
        // At the center of the body, field strength should be zero
        final fieldStrength = GravityFieldUtils.calculateFieldStrength(
          testBody,
          testBody.position,
        );

        expect(fieldStrength.isFinite, isTrue);
        expect(fieldStrength, equals(0.0)); // At center of uniform sphere
      });

      test('should handle very large distances', () {
        final farPosition = vm.Vector3(
          1000.0,
          0.0,
          0.0,
        ); // Very far in simulation units
        final fieldStrength = GravityFieldUtils.calculateFieldStrength(
          testBody,
          farPosition,
        );

        expect(fieldStrength.isFinite, isTrue);
        expect(fieldStrength, greaterThan(0));
        expect(fieldStrength, lessThan(0.01)); // Should be very weak
      });

      test('should handle bodies with different masses', () {
        final smallBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 5.0, // Smaller mass in simulation units
          radius: 0.8,
          color: AppColors.basicRed,
          name: 'Small Body',
          bodyType: BodyType.asteroid,
        );

        final largeBody = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 20.0, // Larger mass in simulation units
          radius: 1.5,
          color: AppColors.basicYellow,
          name: 'Large Body',
          bodyType: BodyType.star,
        );

        final testPosition = vm.Vector3(
          5.0,
          0.0,
          0.0,
        ); // Same distance from both

        final smallStrength = GravityFieldUtils.calculateFieldStrength(
          smallBody,
          testPosition,
        );
        final largeStrength = GravityFieldUtils.calculateFieldStrength(
          largeBody,
          testPosition,
        );

        // Large body should have stronger field proportional to mass ratio
        final massRatio = largeBody.mass / smallBody.mass;
        expect(
          largeStrength,
          closeTo(smallStrength * massRatio, smallStrength * 0.01),
        );
      });
    });

    group('calculateGravitationalPotential', () {
      test('should calculate correct gravitational potential', () {
        final testPosition = vm.Vector3(2.0, 0.0, 0.0); // Outside body
        final potential = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          testPosition,
        );

        // Expected: -GM/r = -(1.2 * 10.0) / 2.0
        final expected =
            -(SimulationConstants.gravitationalConstant * testBody.mass) / 2.0;
        expect(potential, closeTo(expected, expected.abs() * 0.01));
      });

      test('should be negative (attractive potential)', () {
        final testPosition = vm.Vector3(100.0, 0.0, 0.0);
        final potential = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          testPosition,
        );

        expect(potential, lessThan(0));
      });

      test('should approach zero at infinite distance', () {
        final farPosition = vm.Vector3(
          1000.0,
          0.0,
          0.0,
        ); // Very far in simulation units
        final potential = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          farPosition,
        );

        expect(potential, closeTo(0.0, 0.1)); // Should be very close to zero
      });

      test('should follow 1/r relationship', () {
        final position1 = vm.Vector3(2.0, 0.0, 0.0); // Outside body
        final position2 = vm.Vector3(4.0, 0.0, 0.0); // 2x distance

        final potential1 = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          position1,
        );
        final potential2 = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          position2,
        );

        // At 2x distance, potential should be 1/2 (closer to zero)
        expect(potential2, closeTo(potential1 / 2.0, potential1.abs() * 0.01));
      });

      test('should handle zero distance gracefully', () {
        // At center of body, potential should use internal formula
        final potential = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          testBody.position,
        );

        expect(potential.isFinite, isTrue);
        expect(potential, lessThan(0)); // Should still be negative
      });
    });

    group('normalizeFieldStrength', () {
      test('should return 0 for zero field strength', () {
        final normalized = GravityFieldUtils.normalizeFieldStrength(0.0, 1.0);
        expect(normalized, equals(0.0));
      });

      test('should return 1 for maximum field strength', () {
        const maxStrength = 100.0;
        final normalized = GravityFieldUtils.normalizeFieldStrength(
          maxStrength,
          maxStrength,
        );
        expect(normalized, equals(1.0));
      });

      test('should return values between 0 and 1', () {
        const maxStrength = 100.0;
        final testValues = [0.1, 1.0, 10.0, 50.0, 99.9];

        for (final strength in testValues) {
          final normalized = GravityFieldUtils.normalizeFieldStrength(
            strength,
            maxStrength,
          );
          expect(normalized, greaterThanOrEqualTo(0.0));
          expect(normalized, lessThanOrEqualTo(1.0));
        }
      });

      test('should use logarithmic scaling for better visualization', () {
        const maxStrength = 1000.0;

        final strength1 = 1.0;
        final strength10 = 10.0;
        final strength100 = 100.0;

        final norm1 = GravityFieldUtils.normalizeFieldStrength(
          strength1,
          maxStrength,
        );
        final norm10 = GravityFieldUtils.normalizeFieldStrength(
          strength10,
          maxStrength,
        );
        final norm100 = GravityFieldUtils.normalizeFieldStrength(
          strength100,
          maxStrength,
        );

        // Logarithmic scaling should compress the range
        expect(norm10 - norm1, lessThan(norm100 - norm10));
      });

      test('should handle edge cases', () {
        // Zero max strength should trigger assertion in debug mode
        expect(
          () => GravityFieldUtils.normalizeFieldStrength(10.0, 0.0),
          throwsA(isA<AssertionError>()),
        );

        // Negative field strength should trigger assertion in debug mode
        expect(
          () => GravityFieldUtils.normalizeFieldStrength(-5.0, 10.0),
          throwsA(isA<AssertionError>()),
        );

        // Strength greater than max
        final normalized3 = GravityFieldUtils.normalizeFieldStrength(
          150.0,
          100.0,
        );
        expect(normalized3, equals(1.0));
      });
    });

    group('getFieldStrengthColor', () {
      test('should return valid colors for all color schemes', () {
        const fieldStrength = 50.0;
        const maxStrength = 100.0;

        for (final scheme in GravityFieldColorScheme.values) {
          final color = GravityFieldUtils.getFieldStrengthColor(
            fieldStrength,
            maxStrength,
            scheme,
          );

          expect(color, isA<Color>());
          expect((color.r * 255.0).round() & 0xff, inInclusiveRange(0, 255));
          expect((color.g * 255.0).round() & 0xff, inInclusiveRange(0, 255));
          expect((color.b * 255.0).round() & 0xff, inInclusiveRange(0, 255));
          expect((color.a * 255.0).round() & 0xff, inInclusiveRange(0, 255));
        }
      });

      test('should return different colors for different strengths', () {
        const maxStrength = 100.0;
        const scheme = GravityFieldColorScheme.classic;

        final weakColor = GravityFieldUtils.getFieldStrengthColor(
          1.0,
          maxStrength,
          scheme,
        );
        final strongColor = GravityFieldUtils.getFieldStrengthColor(
          99.0,
          maxStrength,
          scheme,
        );

        expect(weakColor, isNot(equals(strongColor)));
      });

      test('should be consistent for same inputs', () {
        const fieldStrength = 25.0;
        const maxStrength = 100.0;
        const scheme = GravityFieldColorScheme.spectral;

        final color1 = GravityFieldUtils.getFieldStrengthColor(
          fieldStrength,
          maxStrength,
          scheme,
        );
        final color2 = GravityFieldUtils.getFieldStrengthColor(
          fieldStrength,
          maxStrength,
          scheme,
        );

        expect(color1, equals(color2));
      });
    });

    group('formatFieldStrength', () {
      // Note: formatFieldStrength requires AppLocalizations parameter
      // These tests focus on the method's existence and basic functionality
      test('should have formatFieldStrength method', () {
        expect(GravityFieldUtils.formatFieldStrength, isA<Function>());
      });
    });

    group('Integration Tests', () {
      test('should maintain physical relationships between functions', () {
        final testPosition = vm.Vector3(1000.0, 0.0, 0.0);

        final fieldStrength = GravityFieldUtils.calculateFieldStrength(
          testBody,
          testPosition,
        );
        final potential = GravityFieldUtils.calculateGravitationalPotential(
          testBody,
          testPosition,
        );

        // Field strength should be related to potential gradient
        expect(fieldStrength, greaterThan(0));
        expect(potential, lessThan(0));

        // Both should be finite and reasonable
        expect(fieldStrength.isFinite, isTrue);
        expect(potential.isFinite, isTrue);
      });

      test('should work correctly with realistic astronomical values', () {
        // Create a Sun-like body in simulation units
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass:
              15.0, // Large mass in simulation units (typical for central star)
          radius: 2.0, // Large radius in simulation units
          color: AppColors.basicYellow,
          name: 'Sun',
          bodyType: BodyType.star,
        );

        // Test at a planet-like orbital distance (simulation units)
        final earthOrbit = vm.Vector3(20.0, 0.0, 0.0);

        final fieldStrength = GravityFieldUtils.calculateFieldStrength(
          sun,
          earthOrbit,
        );
        final normalized = GravityFieldUtils.normalizeFieldStrength(
          fieldStrength,
          fieldStrength,
        );

        expect(fieldStrength, greaterThan(0));
        expect(
          fieldStrength,
          lessThan(10.0),
        ); // Should be reasonable in simulation units
        expect(normalized, equals(1.0));
      });

      test('should handle multiple bodies scenario', () {
        final bodies = [
          Body(
            position: vm.Vector3(-5.0, 0.0, 0.0),
            velocity: vm.Vector3.zero(),
            mass: 10.0, // Simulation units
            radius: 1.0,
            color: AppColors.basicBlue,
            name: 'Body 1',
            bodyType: BodyType.planet,
          ),
          Body(
            position: vm.Vector3(5.0, 0.0, 0.0),
            velocity: vm.Vector3.zero(),
            mass: 20.0, // Simulation units (2x mass)
            radius: 1.2,
            color: AppColors.basicRed,
            name: 'Body 2',
            bodyType: BodyType.planet,
          ),
        ];

        final testPosition = vm.Vector3(0.0, 5.0, 0.0); // Equidistant from both

        // Calculate field from each body
        final strength1 = GravityFieldUtils.calculateFieldStrength(
          bodies[0],
          testPosition,
        );
        final strength2 = GravityFieldUtils.calculateFieldStrength(
          bodies[1],
          testPosition,
        );

        // Both should contribute to the field
        expect(strength1, greaterThan(0));
        expect(strength2, greaterThan(0));

        // Body 2 has twice the mass, so it should have stronger field
        expect(strength2, greaterThan(strength1));
        expect(strength2, closeTo(strength1 * 2.0, strength1 * 0.01));
      });
    });

    group('Performance Tests', () {
      test('should calculate field strength efficiently', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 1; i <= 1000; i++) {
          final position = vm.Vector3(
            i / 100.0,
            0.0,
            0.0,
          ); // Avoid zero distance
          GravityFieldUtils.calculateFieldStrength(testBody, position);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });
  });
}
