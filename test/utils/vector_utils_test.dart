import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/utils/vector_utils.dart';
import 'package:graviton/constants/test_constants.dart';

void main() {
  group('VectorUtils Tests', () {
    group('Position Generation', () {
      test('should generate position from polar coordinates', () {
        const distance = 1.0;
        const angle = 0.0; // 0 radians = positive x axis
        const height = 0.0;

        final position = VectorUtils.positionFromPolar(distance, angle, height);

        expect(position.x, closeTo(1.0, TestConstants.physicsTestTolerance));
        expect(position.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(position.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });

      test('should generate position with height', () {
        const distance = 2.0;
        const angle = math.pi / 2; // 90 degrees = positive y axis
        const height = 3.0;

        final position = VectorUtils.positionFromPolar(distance, angle, height);

        expect(position.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(position.y, closeTo(2.0, TestConstants.physicsTestTolerance));
        expect(position.z, closeTo(3.0, TestConstants.physicsTestTolerance));
      });

      test('should generate random orbital position', () {
        const minDistance = 1.0;
        const maxDistance = 2.0;
        const heightRange = 1.0;

        final position = VectorUtils.randomOrbitalPosition(
          minDistance,
          maxDistance,
          heightRange,
        );

        final distance = math.sqrt(
          position.x * position.x + position.y * position.y,
        );
        expect(distance, greaterThanOrEqualTo(minDistance));
        expect(distance, lessThanOrEqualTo(maxDistance));
        expect(position.z.abs(), lessThanOrEqualTo(heightRange / 2));
      });
    });

    group('Velocity Generation', () {
      test('should generate orbital velocity perpendicular to radius', () {
        const orbitalSpeed = 1.0;
        const angle = 0.0; // position on positive x axis

        final velocity = VectorUtils.orbitalVelocityFromAngle(
          orbitalSpeed,
          angle,
        );

        // Should be perpendicular (in positive y direction for 0 angle)
        expect(velocity.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(velocity.y, closeTo(1.0, TestConstants.physicsTestTolerance));
        expect(velocity.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });

      test('should generate 3D orbital velocity with z component', () {
        const orbitalSpeed = 1.0;
        const angle = 0.0;
        const zVelocity = 0.5;

        final velocity = VectorUtils.orbital3DVelocity(
          orbitalSpeed,
          angle,
          zVelocity,
        );

        expect(velocity.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(velocity.y, closeTo(1.0, TestConstants.physicsTestTolerance));
        expect(velocity.z, closeTo(0.5, TestConstants.physicsTestTolerance));
      });

      test('should add randomness to velocity when specified', () {
        const orbitalSpeed = 1.0;
        const angle = 0.0;
        const randomness = 0.1;
        final random = math.Random(42); // Seeded for reproducibility

        final velocity = VectorUtils.orbitalVelocityFromAngle(
          orbitalSpeed,
          angle,
          randomness: randomness,
          random: random,
        );

        // Should be close to base velocity but with some variation
        expect((velocity.y - 1.0).abs(), lessThanOrEqualTo(randomness / 2));
      });
    });

    group('Vector Operations', () {
      test('should calculate angle between vectors correctly', () {
        final v1 = vm.Vector3(1, 0, 0);
        final v2 = vm.Vector3(0, 1, 0);

        final angle = VectorUtils.angleBetween(v1, v2);

        expect(
          angle,
          closeTo(math.pi / 2, TestConstants.physicsTestTolerance),
        ); // 90 degrees
      });

      test('should handle zero vectors in angle calculation', () {
        final v1 = vm.Vector3.zero();
        final v2 = vm.Vector3(1, 0, 0);

        final angle = VectorUtils.angleBetween(v1, v2);

        expect(angle, equals(0.0));
      });

      test('should project vector correctly', () {
        final a = vm.Vector3(2, 2, 0);
        final b = vm.Vector3(1, 0, 0);

        final projection = VectorUtils.projectOnto(a, b);

        expect(projection.x, closeTo(2.0, TestConstants.physicsTestTolerance));
        expect(projection.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(projection.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });

      test('should reflect vector correctly', () {
        final v = vm.Vector3(1, -1, 0);
        final n = vm.Vector3(0, 1, 0); // vertical normal

        final reflected = VectorUtils.reflect(v, n);

        expect(reflected.x, closeTo(1.0, TestConstants.physicsTestTolerance));
        expect(
          reflected.y,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        ); // flipped
        expect(reflected.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });
    });

    group('Rotations', () {
      test('should rotate around Z axis correctly', () {
        final vector = vm.Vector3(1, 0, 0);
        const angle = math.pi / 2; // 90 degrees

        final rotated = VectorUtils.rotateZ(vector, angle);

        expect(rotated.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(rotated.y, closeTo(1.0, TestConstants.physicsTestTolerance));
        expect(rotated.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });

      test('should rotate around Y axis correctly', () {
        final vector = vm.Vector3(1, 0, 0);
        const angle = math.pi / 2; // 90 degrees

        final rotated = VectorUtils.rotateY(vector, angle);

        expect(rotated.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(rotated.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(rotated.z, closeTo(-1.0, TestConstants.physicsTestTolerance));
      });

      test('should rotate around X axis correctly', () {
        final vector = vm.Vector3(0, 1, 0);
        const angle = math.pi / 2; // 90 degrees

        final rotated = VectorUtils.rotateX(vector, angle);

        expect(rotated.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(rotated.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(rotated.z, closeTo(1.0, TestConstants.physicsTestTolerance));
      });
    });

    group('Random Vectors', () {
      test('should generate unit vectors', () {
        final random = math.Random(42); // Seeded for reproducibility
        final unitVector = VectorUtils.randomUnitVector(random);

        expect(
          unitVector.length,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should generate vectors within sphere', () {
        const radius = 2.0;
        final random = math.Random(42);
        final vector = VectorUtils.randomVectorInSphere(radius, random);

        expect(vector.length, lessThanOrEqualTo(radius));
      });
    });

    group('Distance Calculations', () {
      test('should calculate distance correctly', () {
        final p1 = vm.Vector3(0, 0, 0);
        final p2 = vm.Vector3(3, 4, 0);

        final distance = VectorUtils.distance(p1, p2);

        expect(
          distance,
          closeTo(5.0, TestConstants.physicsTestTolerance),
        ); // 3-4-5 triangle
      });

      test('should calculate squared distance correctly', () {
        final p1 = vm.Vector3(0, 0, 0);
        final p2 = vm.Vector3(3, 4, 0);

        final distanceSquared = VectorUtils.distanceSquared(p1, p2);

        expect(
          distanceSquared,
          closeTo(25.0, TestConstants.physicsTestTolerance),
        );
      });
    });

    group('Vector Utilities', () {
      test('should clamp vector components', () {
        final vector = vm.Vector3(-2, 0, 5);
        const minValue = -1.0;
        const maxValue = 3.0;

        final clamped = VectorUtils.clampComponents(vector, minValue, maxValue);

        expect(clamped.x, equals(-1.0));
        expect(clamped.y, equals(0.0));
        expect(clamped.z, equals(3.0));
      });

      test('should interpolate between vectors', () {
        final a = vm.Vector3(0, 0, 0);
        final b = vm.Vector3(2, 4, 6);
        const t = 0.5;

        final interpolated = VectorUtils.lerp(a, b, t);

        expect(
          interpolated.x,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        );
        expect(
          interpolated.y,
          closeTo(2.0, TestConstants.physicsTestTolerance),
        );
        expect(
          interpolated.z,
          closeTo(3.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should perform spherical interpolation', () {
        final a = vm.Vector3(1, 0, 0).normalized();
        final b = vm.Vector3(0, 1, 0).normalized();
        const t = 0.5;

        final interpolated = VectorUtils.slerp(a, b, t);

        // Result should be normalized and roughly halfway
        expect(
          interpolated.length,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        );
        expect(interpolated.x, greaterThan(0));
        expect(interpolated.y, greaterThan(0));
      });
    });

    group('Coordinate Conversions', () {
      test('should convert to spherical coordinates', () {
        final cartesian = vm.Vector3(0, 0, 1); // Point on positive z axis

        final spherical = VectorUtils.toSpherical(cartesian);

        expect(
          spherical.x,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        ); // r
        expect(
          spherical.z,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        ); // phi (angle from z axis)
      });

      test('should convert from spherical coordinates', () {
        const r = 1.0;
        const theta = 0.0;
        const phi = 0.0; // Point on positive z axis

        final cartesian = VectorUtils.fromSpherical(r, theta, phi);

        expect(cartesian.x, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(cartesian.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(cartesian.z, closeTo(1.0, TestConstants.physicsTestTolerance));
      });

      test('should handle zero vector in spherical conversion', () {
        final cartesian = vm.Vector3.zero();

        final spherical = VectorUtils.toSpherical(cartesian);

        expect(spherical, equals(vm.Vector3.zero()));
      });
    });

    group('Geometric Queries', () {
      test('should check if point is within sphere', () {
        final point = vm.Vector3(0.5, 0.5, 0);
        final center = vm.Vector3(0, 0, 0);
        const radius = 1.0;

        final isWithin = VectorUtils.isWithinSphere(point, center, radius);

        expect(isWithin, isTrue);
      });

      test('should check if point is outside sphere', () {
        final point = vm.Vector3(2, 0, 0);
        final center = vm.Vector3(0, 0, 0);
        const radius = 1.0;

        final isWithin = VectorUtils.isWithinSphere(point, center, radius);

        expect(isWithin, isFalse);
      });

      test('should find closest point on line segment', () {
        final point = vm.Vector3(1, 1, 0);
        final segmentStart = vm.Vector3(0, 0, 0);
        final segmentEnd = vm.Vector3(2, 0, 0);

        final closestPoint = VectorUtils.closestPointOnSegment(
          point,
          segmentStart,
          segmentEnd,
        );

        expect(
          closestPoint.x,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        );
        expect(
          closestPoint.y,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
        expect(
          closestPoint.z,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should handle zero-length segment', () {
        final point = vm.Vector3(1, 1, 0);
        final segmentStart = vm.Vector3(0, 0, 0);
        final segmentEnd = vm.Vector3(0, 0, 0);

        final closestPoint = VectorUtils.closestPointOnSegment(
          point,
          segmentStart,
          segmentEnd,
        );

        expect(closestPoint, equals(segmentStart));
      });
    });

    group('Edge Cases', () {
      test('should handle lerp with t outside [0,1]', () {
        final a = vm.Vector3(0, 0, 0);
        final b = vm.Vector3(1, 1, 1);

        final lerp1 = VectorUtils.lerp(a, b, -0.5); // Should clamp to 0
        final lerp2 = VectorUtils.lerp(a, b, 1.5); // Should clamp to 1

        expect(lerp1, equals(a));
        expect(lerp2, equals(b));
      });

      test('should handle slerp with nearly parallel vectors', () {
        final a = vm.Vector3(1, 0, 0);
        final b = vm.Vector3(1.00001, 0, 0).normalized();

        expect(() => VectorUtils.slerp(a, b, 0.5), returnsNormally);
      });

      test('should handle projection onto zero vector', () {
        final a = vm.Vector3(1, 1, 0);
        final b = vm.Vector3.zero();

        final projection = VectorUtils.projectOnto(a, b);

        expect(projection, equals(vm.Vector3.zero()));
      });
    });
  });
}
