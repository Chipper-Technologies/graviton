// Copyright (c) 2025 Chipper Technologies LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/effects/shockwave.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Shockwave', () {
    test('initializes with correct properties', () {
      final position = vm.Vector3(1.0, 2.0, 3.0);
      const color = AppColors.stellarOType;
      const maxRadius = 10.0;
      const thickness = 0.5;
      const lifetime = 2.0;
      const impactEnergy = 100.0;

      final shockwave = Shockwave(
        position: position,
        color: color,
        maxRadius: maxRadius,
        thickness: thickness,
        lifetime: lifetime,
        impactEnergy: impactEnergy,
      );

      expect(shockwave.position, equals(position));
      expect(shockwave.color, equals(color));
      expect(shockwave.maxRadius, equals(maxRadius));
      expect(shockwave.thickness, equals(thickness));
      expect(shockwave.lifetime, equals(lifetime));
      expect(shockwave.impactEnergy, equals(impactEnergy));
      expect(shockwave.radius, equals(0.0));
      expect(shockwave.age, equals(0.0));
    });

    test('update expands radius towards maxRadius', () {
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      expect(shockwave.radius, equals(0.0));

      shockwave.update(0.1);
      expect(shockwave.radius, greaterThan(0.0));
      expect(shockwave.radius, lessThan(10.0));

      // Continue expanding
      final previousRadius = shockwave.radius;
      shockwave.update(0.1);
      expect(shockwave.radius, greaterThan(previousRadius));
    });

    test('radius does not exceed maxRadius', () {
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      // Update many times to ensure radius reaches max
      for (int i = 0; i < 100; i++) {
        shockwave.update(0.1);
      }

      expect(shockwave.radius, lessThanOrEqualTo(10.0));
    });

    test('age increases with updates', () {
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      expect(shockwave.age, equals(0.0));

      shockwave.update(0.1);
      expect(shockwave.age, closeTo(0.1, 0.001));

      shockwave.update(0.2);
      expect(shockwave.age, closeTo(0.3, 0.001));
    });

    test('opacity fades exponentially as radius approaches maxRadius', () {
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      // At radius 0, opacity should be high
      final initialOpacity = shockwave.opacity;
      expect(initialOpacity, greaterThan(0.5));

      // Expand to halfway
      while (shockwave.radius < 5.0) {
        shockwave.update(0.1);
      }
      final midOpacity = shockwave.opacity;
      expect(midOpacity, lessThan(initialOpacity));
      expect(midOpacity, greaterThan(0.1));

      // Expand near maxRadius
      while (shockwave.radius < 9.5) {
        shockwave.update(0.1);
      }
      final finalOpacity = shockwave.opacity;
      expect(finalOpacity, lessThan(midOpacity));
      expect(finalOpacity, greaterThan(0.0));
    });

    test('isExpired returns true when radius reaches maxRadius', () {
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      expect(shockwave.isExpired, isFalse);

      // Expand until expired
      while (!shockwave.isExpired) {
        shockwave.update(0.1);
      }

      expect(shockwave.radius, greaterThanOrEqualTo(10.0));
      expect(shockwave.isExpired, isTrue);
    });

    test('expansion speed is consistent', () {
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: AppColors.uiWhite,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      // Measure expansion over two identical time steps
      shockwave.update(0.1);
      final radiusAfterFirstStep = shockwave.radius;

      shockwave.update(0.1);
      final radiusAfterSecondStep = shockwave.radius;

      final expansionFirstStep = radiusAfterFirstStep - 0.0;
      final expansionSecondStep = radiusAfterSecondStep - radiusAfterFirstStep;

      // Expansion should be approximately consistent for small radii
      expect(
        expansionSecondStep,
        closeTo(expansionFirstStep, expansionFirstStep * 0.2),
      );
    });

    test('color property is immutable', () {
      const initialColor = AppColors.stellarBType;
      final shockwave = Shockwave(
        position: vm.Vector3.zero(),
        color: initialColor,
        maxRadius: 10.0,
        thickness: 0.5,
        lifetime: 2.0,
        impactEnergy: 100.0,
      );

      expect(shockwave.color, equals(initialColor));

      // Update should not change color
      shockwave.update(1.0);
      expect(shockwave.color, equals(initialColor));
    });

    test(
      'multiple shockwaves with different maxRadius expand at different rates',
      () {
        final smallShockwave = Shockwave(
          position: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          maxRadius: 5.0,
          thickness: 0.5,
          lifetime: 2.0,
          impactEnergy: 100.0,
        );

        final largeShockwave = Shockwave(
          position: vm.Vector3.zero(),
          color: AppColors.uiWhite,
          maxRadius: 20.0,
          thickness: 0.5,
          lifetime: 2.0,
          impactEnergy: 100.0,
        );

        // Update both with same time step
        smallShockwave.update(0.1);
        largeShockwave.update(0.1);

        // Larger shockwave should expand faster to reach its maxRadius
        expect(largeShockwave.radius, greaterThan(smallShockwave.radius));
      },
    );
  });
}
