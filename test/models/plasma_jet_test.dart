// Copyright (c) 2025 Chipper Technologies LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/collision_particle.dart';
import 'package:graviton/models/plasma_jet.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('PlasmaJet', () {
    test('initializes with correct properties', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: vm.Vector3(5.0, 0.0, 0.0),
          color: AppColors.stellarOType,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];
      final origin = vm.Vector3.zero();
      final direction = vm.Vector3(1.0, 0.0, 0.0);
      const velocity = 10.0;
      const lifetime = 3.0;
      const baseColor = AppColors.stellarOType;
      const temperature = 25000.0;
      const isBipolar = true;

      final jet = PlasmaJet(
        particles: particles,
        origin: origin,
        direction: direction,
        velocity: velocity,
        lifetime: lifetime,
        baseColor: baseColor,
        temperature: temperature,
        isBipolar: isBipolar,
      );

      expect(jet.particles, equals(particles));
      expect(jet.origin, equals(origin));
      expect(jet.direction, equals(direction));
      expect(jet.velocity, equals(velocity));
      expect(jet.age, equals(0.0));
      expect(jet.lifetime, equals(lifetime));
      expect(jet.baseColor, equals(baseColor));
      expect(jet.temperature, equals(temperature));
      expect(jet.isBipolar, equals(isBipolar));
    });

    test('opacity decreases linearly with age', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 2.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      // At age 0, opacity should be high (affected by temperature)
      final initialOpacity = jet.opacity;
      expect(initialOpacity, greaterThanOrEqualTo(0.5));

      // At age 1.0 (halfway through lifetime)
      jet.age = 1.0;
      final midOpacity = jet.opacity;
      expect(midOpacity, lessThan(initialOpacity));
      expect(midOpacity, greaterThan(0.1));

      // At age 2.0 (end of lifetime), opacity should be 0.0
      jet.age = 2.0;
      expect(jet.opacity, equals(0.0));

      // Beyond lifetime
      jet.age = 3.0;
      expect(jet.opacity, equals(0.0));
    });

    test('opacity increases with higher temperature', () {
      final coolJet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        age: 0.5,
        lifetime: 2.0,
        baseColor: AppColors.stellarOType,
        temperature: 10000.0, // Cooler
      );

      final hotJet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        age: 0.5,
        lifetime: 2.0,
        baseColor: AppColors.stellarOType,
        temperature: 50000.0, // Hotter (clamped to max)
      );

      expect(hotJet.opacity, greaterThan(coolJet.opacity));
    });

    test('isExpired returns true when age exceeds lifetime', () {
      final jet = PlasmaJet(
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
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 2.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      expect(jet.isExpired, isFalse);

      jet.age = 1.5;
      expect(jet.isExpired, isFalse);

      jet.age = 2.0;
      expect(jet.isExpired, isTrue);

      jet.age = 3.0;
      expect(jet.isExpired, isTrue);
    });

    test('isExpired returns true when particles list is empty', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 2.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      expect(jet.isExpired, isTrue);
    });

    test('length returns distance from origin to farthest particle', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3(5.0, 0.0, 0.0),
          velocity: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final origin = vm.Vector3.zero();
      final jet = PlasmaJet(
        particles: particles,
        origin: origin,
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      // Farthest particle is at distance 10.0
      expect(jet.length, closeTo(10.0, 0.01));
    });

    test('length returns 0.0 when particles list is empty', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      expect(jet.length, equals(0.0));
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

        final jet = PlasmaJet(
          particles: particles,
          origin: vm.Vector3.zero(),
          direction: vm.Vector3(1.0, 0.0, 0.0),
          velocity: 10.0,
          lifetime: 3.0,
          baseColor: AppColors.stellarOType,
          temperature: 25000.0,
        );

        expect(jet.activeParticleCount, equals(2));
      },
    );

    test('update increases age', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      expect(jet.age, equals(0.0));

      jet.update(0.1);
      expect(jet.age, closeTo(0.1, 0.001));

      jet.update(0.2);
      expect(jet.age, closeTo(0.3, 0.001));
    });

    test('update updates all particles', () {
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(10.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(10.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 2.0,
          mass: 0.5,
        ),
      ];

      final jet = PlasmaJet(
        particles: particles,
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      jet.update(0.1);

      // All particles should have been updated
      expect(particles[0].age, closeTo(0.1, 0.001));
      expect(particles[1].age, closeTo(0.1, 0.001));
      expect(particles[0].position.x, greaterThan(0.0));
      expect(particles[1].position.x, greaterThan(0.0));
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

      final jet = PlasmaJet(
        particles: particles,
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 10.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      expect(jet.particles.length, equals(2));

      // Update until first particle expires
      jet.update(0.6);

      expect(jet.particles.length, equals(1));
      expect(jet.particles[0].lifetime, equals(5.0));
    });

    test('temperatureAdjustedColor returns blue-white for very hot plasma', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 35000.0, // Very hot
      );

      final adjustedColor = jet.temperatureAdjustedColor;

      // Should be lerped towards white
      expect(
        (adjustedColor.r * 255.0).round(),
        greaterThanOrEqualTo((AppColors.stellarOType.r * 255.0).round()),
      );
      expect(
        (adjustedColor.g * 255.0).round(),
        greaterThanOrEqualTo((AppColors.stellarOType.g * 255.0).round()),
      );
      expect(
        (adjustedColor.b * 255.0).round(),
        greaterThanOrEqualTo((AppColors.stellarOType.b * 255.0).round()),
      );
    });

    test('temperatureAdjustedColor returns blue-tinted for hot plasma', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarGType,
        temperature: 20000.0, // Hot
      );

      final adjustedColor = jet.temperatureAdjustedColor;

      // Should be lerped towards blue
      expect(
        (adjustedColor.b * 255.0).round(),
        greaterThanOrEqualTo((AppColors.stellarGType.b * 255.0).round()),
      );
    });

    test('temperatureAdjustedColor returns orange-red for cooler plasma', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarGType,
        temperature: 10000.0, // Cooler
      );

      final adjustedColor = jet.temperatureAdjustedColor;

      // Should be lerped towards orange
      expect(
        (adjustedColor.r * 255.0).round(),
        greaterThanOrEqualTo((AppColors.stellarGType.r * 255.0).round()),
      );
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

      final jet = PlasmaJet(
        particles: particles,
        origin: vm.Vector3(1.0, 2.0, 3.0),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        age: 0.5,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
        isBipolar: true,
      );

      final copy = jet.copyWith();

      // Should have same values but different instances
      expect(copy.velocity, equals(jet.velocity));
      expect(copy.age, equals(jet.age));
      expect(copy.lifetime, equals(jet.lifetime));
      expect(copy.baseColor, equals(jet.baseColor));
      expect(copy.temperature, equals(jet.temperature));
      expect(copy.isBipolar, equals(jet.isBipolar));
      expect(copy.origin, equals(jet.origin));
      expect(copy.direction, equals(jet.direction));

      // Should be different instances
      expect(identical(copy, jet), isFalse);
      expect(identical(copy.origin, jet.origin), isFalse);
      expect(identical(copy.direction, jet.direction), isFalse);
      expect(identical(copy.particles, jet.particles), isFalse);
    });

    test('copyWith overrides specified values', () {
      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        age: 0.5,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
        isBipolar: true,
      );

      final copy = jet.copyWith(
        velocity: 20.0,
        age: 1.0,
        temperature: 35000.0,
        isBipolar: false,
      );

      expect(copy.velocity, equals(20.0));
      expect(copy.age, equals(1.0));
      expect(copy.temperature, equals(35000.0));
      expect(copy.isBipolar, equals(false));
      expect(copy.lifetime, equals(jet.lifetime)); // Unchanged
      expect(copy.baseColor, equals(jet.baseColor)); // Unchanged
    });

    test('jet extends along direction vector as particles move', () {
      final direction = vm.Vector3(1.0, 0.0, 0.0).normalized();
      final particles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3(1.0, 0.0, 0.0),
          velocity: direction * 10.0,
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 5.0,
          mass: 0.5,
        ),
      ];

      final jet = PlasmaJet(
        particles: particles,
        origin: vm.Vector3.zero(),
        direction: direction,
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      final initialLength = jet.length;

      // Update multiple times
      for (int i = 0; i < 5; i++) {
        jet.update(0.1);
      }

      // Jet should have extended
      expect(jet.length, greaterThan(initialLength));
    });

    test('bipolar jet property can be queried', () {
      final bipolarJet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
        isBipolar: true,
      );

      final unipolarJet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
        isBipolar: false,
      );

      expect(bipolarJet.isBipolar, isTrue);
      expect(unipolarJet.isBipolar, isFalse);
    });

    test('direction vector should be normalized for consistent physics', () {
      final direction = vm.Vector3(3.0, 4.0, 0.0); // Magnitude = 5
      final normalizedDirection = direction.normalized();

      final jet = PlasmaJet(
        particles: [],
        origin: vm.Vector3.zero(),
        direction: normalizedDirection,
        velocity: 10.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      // Direction should be unit vector
      expect(jet.direction.length, closeTo(1.0, 0.001));
    });

    test('high velocity jets travel faster than low velocity jets', () {
      final fastParticles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(20.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 5.0,
          mass: 0.5,
        ),
      ];

      final slowParticles = <CollisionParticle>[
        CollisionParticle(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3(5.0, 0.0, 0.0),
          color: AppColors.uiWhite,
          size: 0.1,
          lifetime: 5.0,
          mass: 0.5,
        ),
      ];

      final fastJet = PlasmaJet(
        particles: fastParticles,
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 20.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      final slowJet = PlasmaJet(
        particles: slowParticles,
        origin: vm.Vector3.zero(),
        direction: vm.Vector3(1.0, 0.0, 0.0),
        velocity: 5.0,
        lifetime: 3.0,
        baseColor: AppColors.stellarOType,
        temperature: 25000.0,
      );

      // Update both jets
      fastJet.update(0.5);
      slowJet.update(0.5);

      // Fast jet should have traveled farther
      expect(fastJet.length, greaterThan(slowJet.length));
    });
  });
}
