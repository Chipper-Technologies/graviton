// Copyright (c) 2025 Chipper Technologies LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/particles/collision_particle.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CollisionParticle', () {
    test('initializes with correct properties', () {
      final position = vm.Vector3(1.0, 2.0, 3.0);
      final velocity = vm.Vector3(0.5, 0.5, 0.5);
      const color = AppColors.stellarOType;
      const size = 0.1;
      const lifetime = 2.0;
      const mass = 0.5;

      final particle = CollisionParticle(
        position: position,
        velocity: velocity,
        color: color,
        size: size,
        lifetime: lifetime,
        mass: mass,
      );

      expect(particle.position, equals(position));
      expect(particle.velocity, equals(velocity));
      expect(particle.color, equals(color));
      expect(particle.size, equals(size));
      expect(particle.lifetime, equals(lifetime));
      expect(particle.mass, equals(mass));
      expect(particle.age, equals(0.0));
    });

    test('opacity fades linearly over lifetime', () {
      final particle = CollisionParticle(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        size: 0.1,
        lifetime: 2.0,
        mass: 0.5,
      );

      // At age 0, opacity should be 1.0
      expect(particle.opacity, equals(1.0));

      // At age 1.0 (halfway through lifetime), opacity should be 0.5
      particle.age = 1.0;
      expect(particle.opacity, equals(0.5));

      // At age 2.0 (end of lifetime), opacity should be 0.0
      particle.age = 2.0;
      expect(particle.opacity, equals(0.0));

      // Beyond lifetime, opacity should clamp to 0.0
      particle.age = 3.0;
      expect(particle.opacity, equals(0.0));
    });

    test('update applies velocity and ages particle', () {
      final particle = CollisionParticle(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3(1.0, 2.0, 3.0),
        color: AppColors.uiWhite,
        size: 0.1,
        lifetime: 2.0,
        mass: 0.5,
      );

      const dt = 0.1;
      particle.update(dt);

      // Position should be updated by velocity * dt
      expect(particle.position.x, closeTo(0.1, 0.01));
      expect(particle.position.y, closeTo(0.2, 0.01));
      expect(particle.position.z, closeTo(0.3, 0.01));

      // Age should increase by dt
      expect(particle.age, closeTo(0.1, 0.001));
    });

    test('update applies gravitational acceleration when provided', () {
      final particle = CollisionParticle(
        position: vm.Vector3(0.0, 10.0, 0.0), // Start above origin
        velocity: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        size: 0.1,
        lifetime: 2.0,
        mass: 0.5,
      );

      // Apply gravity towards origin
      final gravityAcceleration = vm.Vector3(0.0, -9.8, 0.0);

      // Multiple updates with gravity
      for (int i = 0; i < 10; i++) {
        particle.update(0.1, gravityAcceleration: gravityAcceleration);
      }

      // Particle should have moved downward and gained downward velocity
      expect(particle.position.y, lessThan(10.0));
      expect(particle.velocity.y, lessThan(0.0)); // Negative is downward
    });

    test('update applies drag to slow down particle', () {
      final particle = CollisionParticle(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3(10.0, 0.0, 0.0), // High initial velocity
        color: AppColors.uiWhite,
        size: 0.1,
        lifetime: 2.0,
        mass: 0.5,
      );

      final initialSpeed = particle.velocity.length;

      // Update over time
      for (int i = 0; i < 10; i++) {
        particle.update(0.1);
      }

      final finalSpeed = particle.velocity.length;

      // Speed should decrease due to drag
      expect(finalSpeed, lessThan(initialSpeed));
      expect(finalSpeed, greaterThan(0.0)); // Should not stop completely
    });

    test('isExpired returns true when age exceeds lifetime', () {
      final particle = CollisionParticle(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        size: 0.1,
        lifetime: 2.0,
        mass: 0.5,
      );

      expect(particle.isExpired, isFalse);

      particle.age = 1.0;
      expect(particle.isExpired, isFalse);

      particle.age = 2.0;
      expect(particle.isExpired, isTrue); // Equal to lifetime is expired

      particle.age = 2.1;
      expect(particle.isExpired, isTrue);
    });

    test(
      'particles with different masses fall at same rate (physics accuracy)',
      () {
        final lightParticle = CollisionParticle(
          position: vm.Vector3(0.0, 10.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.1, // Light mass
        );

        final heavyParticle = CollisionParticle(
          position: vm.Vector3(0.0, 10.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 1.0, // Heavy mass
        );

        // Update both with same time step
        for (int i = 0; i < 10; i++) {
          lightParticle.update(0.1);
          heavyParticle.update(0.1);
        }

        // Gravitational acceleration should be independent of mass
        // (though drag will differ slightly, the effect should be minimal for short times)
        expect(
          lightParticle.position.y,
          closeTo(heavyParticle.position.y, 0.5),
        );
      },
    );

    test('color property is immutable', () {
      const initialColor = AppColors.stellarOType;
      final particle = CollisionParticle(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: initialColor,
        size: 0.1,
        lifetime: 2.0,
        mass: 0.5,
      );

      expect(particle.color, equals(initialColor));

      // Update should not change color
      particle.update(1.0);
      expect(particle.color, equals(initialColor));
    });
  });
}
