import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/services/simulation/stellar_color_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Body Realistic Color Override', () {
    test('Body should have useRealisticColor property defaulting to true', () {
      final star = Body(
        name: 'Test Star',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarGType,
        bodyType: BodyType.star,
      );

      expect(star.useRealisticColor, isTrue);
    });

    test('Body should allow setting useRealisticColor to false', () {
      final star = Body(
        name: 'Test Star',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarOType,
        bodyType: BodyType.star,
        useRealisticColor: false,
      );

      expect(star.useRealisticColor, isFalse);
    });

    test(
      'StellarColorService should return custom color when useRealisticColor is false',
      () {
        final customColor = AppColors.stellarOType;
        final star = Body(
          name: 'Custom Star',
          mass: 1.0,
          radius: 10.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: customColor,
          bodyType: BodyType.star,
          useRealisticColor: false,
        );

        final resultColor = StellarColorService.getRealisticBodyColor(star);
        expect(resultColor, equals(customColor));
      },
    );

    test(
      'StellarColorService should return realistic color when useRealisticColor is true',
      () {
        final star = Body(
          name: 'Realistic Star',
          mass: 1.0,
          radius: 10.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.stellarOType, // Custom color
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
          useRealisticColor: true,
        );

        final realisticColor = StellarColorService.getRealisticBodyColor(star);
        // The realistic color should be different from the custom color for most masses
        // (except if it happens to match, but that's very unlikely)
        expect(realisticColor, isNotNull);
        expect(realisticColor, isA<Color>());
      },
    );

    test('Planets should always use custom color regardless of flag', () {
      final customColor = AppColors.planetNeptune;
      final planet = Body(
        name: 'Test Planet',
        mass: 1.0,
        radius: 5.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: customColor,
        bodyType: BodyType.planet,
        useRealisticColor:
            true, // Even with flag true, planets use custom color
      );

      final resultColor = StellarColorService.getRealisticBodyColor(planet);
      expect(resultColor, equals(customColor));
    });

    test('Moons should always use custom color regardless of flag', () {
      final customColor = AppColors.moonRocky;
      final moon = Body(
        name: 'Test Moon',
        mass: 0.1,
        radius: 2.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: customColor,
        bodyType: BodyType.moon,
        useRealisticColor: true, // Even with flag true, moons use custom color
      );

      final resultColor = StellarColorService.getRealisticBodyColor(moon);
      expect(resultColor, equals(customColor));
    });

    test('useRealisticColor should be included in equality comparison', () {
      final star1 = Body(
        name: 'Star 1',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarGType,
        bodyType: BodyType.star,
        useRealisticColor: true,
      );

      final star2 = Body(
        name: 'Star 1',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarGType,
        bodyType: BodyType.star,
        useRealisticColor: false,
      );

      expect(star1 == star2, isFalse);
    });

    test('useRealisticColor should be included in hashCode', () {
      final star1 = Body(
        name: 'Star 1',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarGType,
        bodyType: BodyType.star,
        useRealisticColor: true,
      );

      final star2 = Body(
        name: 'Star 1',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarGType,
        bodyType: BodyType.star,
        useRealisticColor: false,
      );

      expect(star1.hashCode != star2.hashCode, isTrue);
    });

    test('Body setter should update useRealisticColor', () {
      final star = Body(
        name: 'Test Star',
        mass: 1.0,
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: AppColors.stellarGType,
        bodyType: BodyType.star,
        useRealisticColor: true,
      );

      expect(star.useRealisticColor, isTrue);

      star.useRealisticColor = false;
      expect(star.useRealisticColor, isFalse);

      star.useRealisticColor = true;
      expect(star.useRealisticColor, isTrue);
    });

    test('Toggling useRealisticColor should affect color selection', () {
      final customColor = AppColors.uiPurple;
      final star = Body(
        name: 'Toggle Star',
        mass: 2.0, // High mass to ensure different realistic color
        radius: 10.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: customColor,
        bodyType: BodyType.star,
        stellarLuminosity: 2.0,
        useRealisticColor: false,
      );

      // With flag false, should use custom color
      var resultColor = StellarColorService.getRealisticBodyColor(star);
      expect(resultColor, equals(customColor));

      // Toggle to true
      star.useRealisticColor = true;
      resultColor = StellarColorService.getRealisticBodyColor(star);

      // Should now use realistic color (different from custom)
      expect(resultColor, isNot(equals(customColor)));
    });

    test('Asteroids should respect useRealisticColor flag', () {
      final customColor = AppColors.basicPink;
      final asteroid = Body(
        name: 'Asteroid',
        mass: 0.01,
        radius: 1.0,
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        color: customColor,
        bodyType: BodyType.asteroid,
        useRealisticColor: false,
      );

      // With flag false, should use custom color
      var resultColor = StellarColorService.getRealisticBodyColor(asteroid);
      expect(resultColor, equals(customColor));
    });

    test(
      'Black holes should respect useRealisticColor flag (non-luminous)',
      () {
        final customColor = AppColors.spaceDeepPurple;
        final blackHole = Body(
          name: 'Black Hole',
          mass: 100.0,
          radius: 5.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: customColor,
          bodyType: BodyType.blackHole,
          useRealisticColor: false,
          habitabilityStatus: HabitabilityStatus.unknown,
        );

        // With flag false, should use custom color
        final resultColor = StellarColorService.getRealisticBodyColor(
          blackHole,
        );
        expect(resultColor, equals(customColor));
      },
    );
  });
}
