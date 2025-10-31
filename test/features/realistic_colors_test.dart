import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/stellar_color_service.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('Realistic Colors Feature', () {
    test('UIState should have useRealisticColors toggle', () {
      final uiState = UIState();

      // Should start with realistic colors disabled
      expect(uiState.useRealisticColors, isFalse);

      // Should be able to toggle
      uiState.toggleRealisticColors();
      expect(uiState.useRealisticColors, isTrue);

      uiState.toggleRealisticColors();
      expect(uiState.useRealisticColors, isFalse);

      uiState.dispose();
    });

    group('StellarColorService', () {
      test('should return realistic colors for stars', () {
        final star = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 10.0, // Sun-like mass
          radius: 1.0,
          color: AppColors.basicYellow,
          bodyType: BodyType.star,
          name: 'Test Star',
        );

        final realisticColor = StellarColorService.getRealisticBodyColor(star);

        // Should return a different color than the original
        expect(realisticColor, isNot(equals(star.color)));

        // Should return a realistic stellar color (not default app colors)
        expect((realisticColor.a * 255.0).round() & 0xff, equals(255));
      });

      test('should return consistent colors for same mass stars', () {
        final star1 = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 15.0,
          radius: 1.0,
          color: AppColors.basicRed,
          bodyType: BodyType.star,
          name: 'Test Star 1',
        );

        final star2 = Body(
          position: vm.Vector3(10, 10, 10),
          velocity: vm.Vector3(1, 1, 1),
          mass: 15.0, // Same mass
          radius: 2.0,
          color: AppColors.basicBlue, // Different original color
          bodyType: BodyType.star,
          name: 'Test Star 2',
        );

        final color1 = StellarColorService.getRealisticBodyColor(star1);
        final color2 = StellarColorService.getRealisticBodyColor(star2);

        // Should return the same realistic color for stars with same mass
        expect(color1, equals(color2));
      });

      test('should handle different stellar mass ranges', () {
        final lowMassStar = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 5.0, // Lower mass
          radius: 1.0,
          color: AppColors.basicYellow,
          bodyType: BodyType.star,
          name: 'Low Mass Star',
        );

        final highMassStar = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 30.0, // Higher mass
          radius: 1.0,
          color: AppColors.basicYellow,
          bodyType: BodyType.star,
          name: 'High Mass Star',
        );

        final lowMassColor = StellarColorService.getRealisticBodyColor(
          lowMassStar,
        );
        final highMassColor = StellarColorService.getRealisticBodyColor(
          highMassStar,
        );

        // Should return different colors for different masses
        expect(lowMassColor, isNot(equals(highMassColor)));
      });

      test('should handle non-luminous bodies appropriately', () {
        final planet = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          bodyType: BodyType.planet,
          name: 'Test Planet',
        );

        final realisticColor = StellarColorService.getRealisticBodyColor(
          planet,
        );

        // Should handle planets/non-luminous bodies
        expect(realisticColor, isNotNull);
        expect((realisticColor.a * 255.0).round() & 0xff, equals(255));
      });

      test('should provide trail colors', () {
        final star = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 10.0,
          radius: 1.0,
          color: AppColors.basicYellow,
          bodyType: BodyType.star,
          name: 'Test Star',
        );

        final trailColor = StellarColorService.getRealisticTrailColor(star);

        // Trail color should have some transparency
        expect((trailColor.a * 255.0).round() & 0xff, lessThan(255));
        expect((trailColor.a * 255.0).round() & 0xff, greaterThan(0));
      });
    });

    group('Integration', () {
      test('realistic colors should be properly integrated', () {
        // This test validates that the realistic colors feature is properly
        // integrated throughout the system

        final uiState = UIState();

        // Test the UI state integration
        expect(uiState.useRealisticColors, isFalse);

        // Test that StellarColorService provides different results
        final testBody = Body(
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          mass: 8.0,
          radius: 1.0,
          color: AppColors.basicGreen,
          bodyType: BodyType.star,
          name: 'Integration Test Star',
        );

        final realisticColor = StellarColorService.getRealisticBodyColor(
          testBody,
        );
        expect(realisticColor, isNot(equals(testBody.color)));

        uiState.dispose();
      });
    });

    group('Specific Named Celestial Bodies', () {
      test(
        'should preserve original colors for ALL planets across all scenarios',
        () {
          // Test Sun
          final sun = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 50.0,
            radius: 4.8,
            color: AppColors.celestialGold,
            name: 'Sun',
            bodyType: BodyType.star,
          );
          expect(
            StellarColorService.getRealisticBodyColor(sun),
            equals(AppColors.stellarGType),
          );

          // Test Earth - should return original color, not realistic color
          final earth = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 0.02,
            radius: 0.6,
            color: AppColors.planetEarth,
            name: 'Earth',
            bodyType: BodyType.planet,
          );
          final earthColor = StellarColorService.getRealisticBodyColor(earth);
          expect(
            earthColor,
            equals(AppColors.planetEarth),
          ); // Should return original color

          // Test Mars - should return original color, not realistic color
          final mars = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 0.01,
            radius: 0.32,
            color: AppColors.planetMars,
            name: 'Mars',
            bodyType: BodyType.planet,
          );
          final marsColor = StellarColorService.getRealisticBodyColor(mars);
          expect(
            marsColor,
            equals(AppColors.planetMars),
          ); // Should return original color

          // Test Jupiter - should return original color, not realistic color
          final jupiter = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 0.15,
            radius: 6.72,
            color: AppColors.planetJupiter,
            name: 'Jupiter',
            bodyType: BodyType.planet,
          );
          final jupiterColor = StellarColorService.getRealisticBodyColor(
            jupiter,
          );
          expect(
            jupiterColor,
            equals(AppColors.planetJupiter),
          ); // Should return original color

          // Test Super Earth from random scenario - should return original color
          final superEarth = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 2.5,
            radius: 0.8,
            color: AppColors.planetVenus, // Example color
            name: 'Super Earth',
            bodyType: BodyType.planet,
          );
          final superEarthColor = StellarColorService.getRealisticBodyColor(
            superEarth,
          );
          expect(
            superEarthColor,
            equals(AppColors.planetVenus),
          ); // Should return original color
        },
      );

      test('should preserve original colors for moons', () {
        // Test Moon in Earth-Moon-Sun system - should return original color
        final moon = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 0.015,
          radius: 0.162,
          color: AppColors.celestialSilver,
          name: 'Moon',
          bodyType: BodyType.moon,
        );
        // Moon should return its original color, not realistic color
        final moonColor = StellarColorService.getRealisticBodyColor(moon);
        expect(moonColor, equals(AppColors.celestialSilver));
      });

      test('should recognize asteroid belt bodies', () {
        // Test Central Star
        final centralStar = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 20.0,
          radius: 2.0,
          color: AppColors.celestialGold,
          name: 'Central Star',
          bodyType: BodyType.star,
        );
        // Central star should get realistic stellar color based on mass
        final starColor = StellarColorService.getRealisticBodyColor(
          centralStar,
        );
        expect(starColor, isNot(equals(AppColors.celestialGold)));

        // Test Asteroid
        final asteroid = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 0.001,
          radius: 0.1,
          color: AppColors.celestialSilver,
          name: 'Asteroid 1',
          bodyType: BodyType.asteroid,
        );
        expect(
          StellarColorService.getRealisticBodyColor(asteroid),
          equals(AppColors.asteroidBrownish),
        );
      });

      test('should recognize binary star system bodies', () {
        // Test Star A
        final starA = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 8.0,
          radius: 1.5,
          color: AppColors.celestialRed,
          name: 'Star A',
          bodyType: BodyType.star,
        );
        // Star A should get realistic stellar color based on mass
        final starAColor = StellarColorService.getRealisticBodyColor(starA);
        expect(starAColor, isNot(equals(AppColors.celestialRed)));

        // Test Star B
        final starB = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 8.0,
          radius: 1.5,
          color: AppColors.celestialBlue,
          name: 'Star B',
          bodyType: BodyType.star,
        );
        // Star B should get realistic stellar color based on mass
        final starBColor = StellarColorService.getRealisticBodyColor(starB);
        expect(starBColor, isNot(equals(AppColors.celestialBlue)));
      });
    });
  });
}
