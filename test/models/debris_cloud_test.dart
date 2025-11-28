// Copyright (c) 2025 Chipper Technologies LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/collision_particle.dart';
import 'package:graviton/models/debris_cloud.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('DebrisCloud', () {
    test('initializes with correct properties', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3(0.5, 0.0, 0.0),
          color: AppColors.stellarOType,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];
      final centerOfMass = vm.Vector3(0.0, 0.0, 0.0);
      const expansionRate = 5.0;
      const lifetime = 3.0;
      const baseColor = AppColors.stellarOType;
      final collisionDirection = vm.Vector3(1.0, 0.0, 0.0);

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: centerOfMass,
        expansionRate: expansionRate,
        lifetime: lifetime,
        baseColor: baseColor,
        collisionDirection: collisionDirection,
      );

      expect(cloud.particles, equals(particles));
      expect(cloud.centerOfMass, equals(centerOfMass));
      expect(cloud.expansionRate, equals(expansionRate));
      expect(cloud.age, equals(0.0));
      expect(cloud.lifetime, equals(lifetime));
      expect(cloud.baseColor, equals(baseColor));
      expect(cloud.collisionDirection, equals(collisionDirection));
    });

    test('opacity returns average opacity of all particles', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        )..age = 0.0, // opacity = 1.0
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        )..age = 1.0, // opacity = 0.5
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        )..age = 2.0, // opacity = 0.0
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      // Average opacity = (1.0 + 0.5 + 0.0) / 3 = 0.5
      expect(cloud.opacity, closeTo(0.5, 0.01));
    });

    test('opacity returns 0.0 when particles list is empty', () {
      final cloud = DebrisCloud(
        particles: [],
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      expect(cloud.opacity, equals(0.0));
    });

    test('isExpired returns true when age exceeds lifetime', () {
      final cloud = DebrisCloud(
        particles: [
          CollisionParticle(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiWhite,
            size: 0.1,
            lifetime: 5.0,
            mass: 0.5,
          ),
        ],
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 2.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      expect(cloud.isExpired, isFalse);

      cloud.age = 1.5;
      expect(cloud.isExpired, isFalse);

      cloud.age = 2.0;
      expect(cloud.isExpired, isTrue);

      cloud.age = 3.0;
      expect(cloud.isExpired, isTrue);
    });

    test('isExpired returns true when particles list is empty', () {
      final cloud = DebrisCloud(
        particles: [],
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 2.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      expect(cloud.isExpired, isTrue);
    });

    test(
      'activeParticleCount returns correct count of non-expired particles',
      () {
        final particles = <CollisionParticle>[
          CollisionParticle(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiWhite,
            size: 0.1,
            lifetime: 2.0,
            mass: 0.5,
          )..age = 0.5, // Not expired
          CollisionParticle(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiWhite,
            size: 0.1,
            lifetime: 2.0,
            mass: 0.5,
          )..age = 2.5, // Expired
          CollisionParticle(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            color: AppColors.uiWhite,
            size: 0.1,
            lifetime: 2.0,
            mass: 0.5,
          )..age = 1.0, // Not expired
        ];

        final cloud = DebrisCloud(
          particles: particles,
          centerOfMass: vm.Vector3.zero(),
          expansionRate: 5.0,
          lifetime: 3.0,
          baseColor: AppColors.uiWhite,
          collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
        );

        expect(cloud.activeParticleCount, equals(2));
      },
    );

    test('update increases age', () {
      final cloud = DebrisCloud(
        particles: [],
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      expect(cloud.age, equals(0.0));

      cloud.update(0.1);
      expect(cloud.age, closeTo(0.1, 0.001));

      cloud.update(0.2);
      expect(cloud.age, closeTo(0.3, 0.001));
    });

    test('update updates all particles', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(1.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(0.0, 1.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      cloud.update(0.1);

      // All particles should have been updated
      expect(particles[0].age, closeTo(0.1, 0.001));
      expect(particles[1].age, closeTo(0.1, 0.001));
      expect(particles[0].position.x, greaterThan(0.0));
      expect(particles[1].position.y, greaterThan(0.0));
    });

    test('update removes expired particles', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 0.5, // Short lifetime
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 5.0, // Long lifetime
          mass: 0.5,
        ),
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 10.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      expect(cloud.particles.length, equals(2));

      // Update until first particle expires
      cloud.update(0.6);

      expect(cloud.particles.length, equals(1));
      expect(cloud.particles[0].lifetime, equals(5.0));
    });

    test('update with gravity applies acceleration to particles', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(0.0, 10.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      final gravityAcceleration = vm.Vector3(0.0, -9.8, 0.0);

      for (int i = 0; i < 5; i++) {
        cloud.update(0.1, gravityAcceleration: gravityAcceleration);
      }

      // Particle should have moved downward
      expect(particles[0].position.y, lessThan(10.0));
      expect(particles[0].velocity.y, lessThan(0.0));
    });

    test('update recalculates center of mass based on particle positions', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3(1.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3(-1.0, 0.0, 0.0),
          velocity: vm.Vector3(-1.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      // Initial center of mass should be at origin (average of 1 and -1)
      expect(cloud.centerOfMass.x, closeTo(0.0, 0.01));

      cloud.update(0.1);

      // After update, particles move apart but center of mass should remain at origin
      expect(cloud.centerOfMass.x, closeTo(0.0, 0.01));
      expect(particles[0].position.x, greaterThan(1.0));
      expect(particles[1].position.x, lessThan(-1.0));
    });

    test('radius returns distance from center to farthest particle', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(5.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3(0.0, 3.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3(0.0, 0.0, 1.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final centerOfMass = vm.Vector3.zero();
      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: centerOfMass,
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      // Farthest particle is at (5, 0, 0), distance = 5
      expect(cloud.radius, closeTo(5.0, 0.01));
    });

    test('radius returns 0.0 when particles list is empty', () {
      final cloud = DebrisCloud(
        particles: [],
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      expect(cloud.radius, equals(0.0));
    });

    test('copyWith creates a new instance with copied values', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3(1.0, 2.0, 3.0),
        expansionRate: 5.0,
        age: 0.5,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      final copy = cloud.copyWith();

      // Should have same values but different instances
      expect(copy.expansionRate, equals(cloud.expansionRate));
      expect(copy.age, equals(cloud.age));
      expect(copy.lifetime, equals(cloud.lifetime));
      expect(copy.baseColor, equals(cloud.baseColor));
      expect(copy.centerOfMass, equals(cloud.centerOfMass));
      expect(copy.collisionDirection, equals(cloud.collisionDirection));

      // Should be different instances
      expect(identical(copy, cloud), isFalse);
      expect(identical(copy.centerOfMass, cloud.centerOfMass), isFalse);
      expect(identical(copy.particles, cloud.particles), isFalse);
    });

    test('copyWith overrides specified values', () {
      final cloud = DebrisCloud(
        particles: [],
        centerOfMass: vm.Vector3(1.0, 2.0, 3.0),
        expansionRate: 5.0,
        age: 0.5,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      final copy = cloud.copyWith(
        expansionRate: 10.0,
        age: 1.0,
        baseColor: AppColors.stellarBType,
      );

      expect(copy.expansionRate, equals(10.0));
      expect(copy.age, equals(1.0));
      expect(copy.baseColor, equals(AppColors.stellarBType));
      expect(copy.lifetime, equals(cloud.lifetime)); // Unchanged
      expect(copy.centerOfMass, equals(cloud.centerOfMass)); // Cloned
    });

    test('cloud expands as particles move outward', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3(2.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 5.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3(-1.0, 0.0, 0.0),
          velocity: vm.Vector3(-2.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 5.0,
          mass: 0.5,
        ),
      ];

      final cloud = DebrisCloud(
        particles: particles,
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: vm.Vector3(1.0, 0.0, 0.0),
      );

      final initialRadius = cloud.radius;

      // Update multiple times
      for (int i = 0; i < 5; i++) {
        cloud.update(0.1);
      }

      // Cloud should have expanded
      expect(cloud.radius, greaterThan(initialRadius));
    });

    test('collisionDirection affects asymmetric expansion pattern', () {
      // This test verifies that the collisionDirection property is preserved
      // The actual asymmetric expansion would be handled by the service layer
      final direction = vm.Vector3(1.0, 0.5, 0.0).normalized();

      final cloud = DebrisCloud(
        particles: [],
        centerOfMass: vm.Vector3.zero(),
        expansionRate: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.uiWhite,
        collisionDirection: direction,
      );

      expect(cloud.collisionDirection, equals(direction));
      expect(
        cloud.collisionDirection.length,
        closeTo(1.0, 0.001),
      ); // Normalized
    });
  });
}
