import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/utils/collision_utils.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/constants/test_constants.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('CollisionUtils Tests', () {
    late Body body1;
    late Body body2;

    setUp(() {
      body1 = Body(
        position: vm.Vector3(0, 0, 0),
        velocity: vm.Vector3(1, 0, 0),
        mass: 1.0,
        radius: 0.5,
        color: AppColors.basicRed,
        name: 'Body1',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
      );

      body2 = Body(
        position: vm.Vector3(1, 0, 0),
        velocity: vm.Vector3(-1, 0, 0),
        mass: 2.0,
        radius: 0.3,
        color: AppColors.basicBlue,
        name: 'Body2',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
      );
    });

    group('Collision Detection', () {
      test('should detect collision when bodies are very close', () {
        // Move bodies very close together
        body2.position = vm.Vector3(
          TestConstants.testCollisionRadius * 0.5,
          0,
          0,
        );

        final colliding = CollisionUtils.areColliding(body1, body2);

        expect(colliding, isTrue);
      });

      test('should not detect collision when bodies are far apart', () {
        final colliding = CollisionUtils.areColliding(body1, body2);

        expect(colliding, isFalse);
      });

      test('should calculate collision distance correctly', () {
        final distance = CollisionUtils.calculateCollisionDistance(
          body1,
          body2,
        );

        expect(distance, closeTo(1.0, TestConstants.physicsTestTolerance));
      });

      test('should detect all collisions in body list', () {
        final body3 = Body(
          position: vm.Vector3(TestConstants.testCollisionRadius * 0.3, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 1.0,
          radius: 0.2,
          color: AppColors.basicGreen,
          name: 'Body3',
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
        );

        final bodies = [body1, body2, body3];
        final collisions = CollisionUtils.detectAllCollisions(bodies);

        // Should detect collision between body1 and body3
        expect(collisions, hasLength(1));
        expect(
          collisions[0],
          containsAll([0, 2]),
        ); // Indices of body1 and body3
      });

      test('should return empty list when no collisions', () {
        final bodies = [body1, body2];
        final collisions = CollisionUtils.detectAllCollisions(bodies);

        expect(collisions, isEmpty);
      });
    });

    group('Body Merging', () {
      test('should merge bodies conserving mass', () {
        final merged = CollisionUtils.mergeBodies(body1, body2);

        expect(
          merged.mass,
          closeTo(3.0, TestConstants.physicsTestTolerance),
        ); // 1.0 + 2.0
      });

      test('should merge bodies conserving momentum', () {
        final merged = CollisionUtils.mergeBodies(body1, body2);

        // Initial momentum: 1*1 + 2*(-1) = -1 in x direction
        // Final velocity: -1/3 in x direction
        expect(
          merged.velocity.x,
          closeTo(-1.0 / 3.0, TestConstants.momentumTestTolerance),
        );
        expect(
          merged.velocity.y,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
        expect(
          merged.velocity.z,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should place merged body at center of mass', () {
        final merged = CollisionUtils.mergeBodies(body1, body2);

        // Center of mass: (1*0 + 2*1) / (1+2) = 2/3
        expect(
          merged.position.x,
          closeTo(2.0 / 3.0, TestConstants.physicsTestTolerance),
        );
        expect(
          merged.position.y,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
        expect(
          merged.position.z,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should give merged body properties of more massive body', () {
        final merged = CollisionUtils.mergeBodies(body1, body2);

        // Body2 is more massive, so merged body should have its properties
        expect(merged.color, equals(AppColors.basicBlue));
        expect(merged.name, equals('Body2'));
      });

      test('should handle stellar luminosity correctly', () {
        // Create two stars
        final star1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          name: 'Star1',
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
        );

        final star2 = Body(
          position: vm.Vector3(0.01, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 2.0,
          radius: 1.2,
          color: AppColors.basicOrange,
          name: 'Star2',
          bodyType: BodyType.star,
          stellarLuminosity: 2.0,
        );

        final merged = CollisionUtils.mergeBodies(star1, star2);

        expect(
          merged.stellarLuminosity,
          closeTo(3.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should handle planet flag correctly', () {
        body1.isPlanet = true;
        body2.isPlanet = false;

        final merged = CollisionUtils.mergeBodies(body1, body2);

        expect(
          merged.isPlanet,
          isTrue,
        ); // Should be true if either was a planet
      });
    });

    group('Merge Flash Creation', () {
      test('should create merge flash at center of mass', () {
        final flash = CollisionUtils.createMergeFlash(body1, body2);

        // Center of mass position
        expect(
          flash.position.x,
          closeTo(2.0 / 3.0, TestConstants.physicsTestTolerance),
        );
        expect(
          flash.position.y,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
        expect(
          flash.position.z,
          closeTo(0.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should use color of more massive body', () {
        final flash = CollisionUtils.createMergeFlash(body1, body2);

        expect(
          flash.color,
          equals(AppColors.basicBlue),
        ); // Body2 is more massive
      });
    });

    group('Impact Calculations', () {
      test('should calculate impact velocity correctly', () {
        final impactVelocity = CollisionUtils.calculateImpactVelocity(
          body1,
          body2,
        );

        // Relative velocity magnitude: |(-1) - 1| = 2
        expect(
          impactVelocity,
          closeTo(2.0, TestConstants.physicsTestTolerance),
        );
      });

      test('should calculate reduced mass correctly', () {
        const mass1 = 2.0;
        const mass2 = 3.0;

        final reducedMass = CollisionUtils.calculateReducedMass(mass1, mass2);

        // μ = m1*m2/(m1+m2) = 2*3/(2+3) = 6/5 = 1.2
        expect(reducedMass, closeTo(1.2, TestConstants.physicsTestTolerance));
      });

      test('should return zero reduced mass for zero mass', () {
        const mass1 = 0.0;
        const mass2 = 3.0;

        final reducedMass = CollisionUtils.calculateReducedMass(mass1, mass2);

        expect(reducedMass, equals(0.0));
      });
    });

    group('Collision Normal', () {
      test('should calculate collision normal correctly', () {
        final normal = CollisionUtils.calculateCollisionNormal(body1, body2);

        // Should point from body1 to body2 (positive x direction)
        expect(normal.x, closeTo(1.0, TestConstants.physicsTestTolerance));
        expect(normal.y, closeTo(0.0, TestConstants.physicsTestTolerance));
        expect(normal.z, closeTo(0.0, TestConstants.physicsTestTolerance));
      });

      test('should handle same position bodies', () {
        body2.position = body1.position.clone();

        final normal = CollisionUtils.calculateCollisionNormal(body1, body2);

        // Should return arbitrary unit vector
        expect(normal.length, closeTo(1.0, TestConstants.physicsTestTolerance));
      });
    });

    group('Elastic Collisions', () {
      test('should calculate elastic collision velocities', () {
        final result = CollisionUtils.calculateElasticCollision(body1, body2);

        expect(result.containsKey('velocity1'), isTrue);
        expect(result.containsKey('velocity2'), isTrue);
        expect(result['velocity1'], isA<vm.Vector3>());
        expect(result['velocity2'], isA<vm.Vector3>());
      });

      test('should handle separating velocities', () {
        // Make bodies move away from each other
        body1.velocity = vm.Vector3(-1, 0, 0);
        body2.velocity = vm.Vector3(1, 0, 0);

        final result = CollisionUtils.calculateElasticCollision(body1, body2);

        // Velocities should remain unchanged for separating motion
        expect(
          result['velocity1']!.x,
          closeTo(-1.0, TestConstants.physicsTestTolerance),
        );
        expect(
          result['velocity2']!.x,
          closeTo(1.0, TestConstants.physicsTestTolerance),
        );
      });
    });

    group('Energy Calculations', () {
      test('should calculate energy loss in collision', () {
        // Create copies before merging
        final bodyBefore1 = Body(
          position: body1.position.clone(),
          velocity: body1.velocity.clone(),
          mass: body1.mass,
          radius: body1.radius,
          color: body1.color,
          name: body1.name,
          bodyType: body1.bodyType,
          stellarLuminosity: body1.stellarLuminosity,
        );

        final bodyBefore2 = Body(
          position: body2.position.clone(),
          velocity: body2.velocity.clone(),
          mass: body2.mass,
          radius: body2.radius,
          color: body2.color,
          name: body2.name,
          bodyType: body2.bodyType,
          stellarLuminosity: body2.stellarLuminosity,
        );

        final merged = CollisionUtils.mergeBodies(body1, body2);

        final energyLoss = CollisionUtils.calculateEnergyLoss(
          bodyBefore1,
          bodyBefore2,
          merged,
        );

        expect(
          energyLoss,
          greaterThanOrEqualTo(0),
        ); // Energy should be lost in inelastic collision
      });

      test('should check if collision is energetically favorable', () {
        // Place bodies close together
        body2.position = vm.Vector3(0.1, 0, 0);

        final favorable = CollisionUtils.isCollisionEnergeticallyFavorable(
          body1,
          body2,
        );

        expect(favorable, isA<bool>());
      });
    });

    group('Point Queries', () {
      test('should check if point is inside body', () {
        final point = vm.Vector3(0.1, 0, 0); // Inside body1 (radius 0.5)

        final inside = CollisionUtils.isPointInsideBody(point, body1);

        expect(inside, isTrue);
      });

      test('should check if point is outside body', () {
        final point = vm.Vector3(1.0, 0, 0); // Outside body1 (radius 0.5)

        final inside = CollisionUtils.isPointInsideBody(point, body1);

        expect(inside, isFalse);
      });
    });

    group('Time to Collision', () {
      test('should calculate time to collision for approaching bodies', () {
        // Bodies moving toward each other
        body1.velocity = vm.Vector3(1, 0, 0);
        body2.velocity = vm.Vector3(-1, 0, 0);
        body2.position = vm.Vector3(2, 0, 0); // Far enough apart

        final timeToCollision = CollisionUtils.calculateTimeToCollision(
          body1,
          body2,
        );

        expect(timeToCollision, isNotNull);
        expect(timeToCollision!, greaterThan(0));
      });

      test('should return null for separating bodies', () {
        // Bodies moving away from each other
        body1.velocity = vm.Vector3(-1, 0, 0);
        body2.velocity = vm.Vector3(1, 0, 0);

        final timeToCollision = CollisionUtils.calculateTimeToCollision(
          body1,
          body2,
        );

        expect(timeToCollision, isNull);
      });

      test('should return null for parallel motion', () {
        // Bodies moving in parallel
        body1.velocity = vm.Vector3(1, 0, 0);
        body2.velocity = vm.Vector3(1, 0, 0);

        final timeToCollision = CollisionUtils.calculateTimeToCollision(
          body1,
          body2,
        );

        expect(timeToCollision, isNull);
      });
    });

    group('Edge Cases', () {
      test('should handle zero mass bodies', () {
        body1.mass = 0.0;

        expect(() => CollisionUtils.mergeBodies(body1, body2), returnsNormally);
      });

      test('should handle identical bodies', () {
        final identicalBody = Body(
          position: body1.position.clone(),
          velocity: body1.velocity.clone(),
          mass: body1.mass,
          radius: body1.radius,
          color: body1.color,
          name: body1.name,
          bodyType: body1.bodyType,
          stellarLuminosity: body1.stellarLuminosity,
        );

        expect(
          () => CollisionUtils.mergeBodies(body1, identicalBody),
          returnsNormally,
        );
      });

      test('should handle bodies with zero radius', () {
        body1.radius = 0.0;
        body2.radius = 0.0;

        final colliding = CollisionUtils.areColliding(body1, body2);
        expect(
          colliding,
          isFalse,
        ); // Should not collide with zero collision radius
      });
    });
  });
}
