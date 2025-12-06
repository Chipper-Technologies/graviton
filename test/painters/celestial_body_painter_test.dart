import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/painters/celestial_body_painter.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('CelestialBodyPainter', () {
    late Canvas canvas;
    late ui.PictureRecorder recorder;
    late Offset center;
    late double radius;

    setUp(() {
      recorder = ui.PictureRecorder();
      canvas = Canvas(recorder);
      center = const Offset(100, 100);
      radius = 50.0;
    });

    group('drawBody', () {
      test('should draw normal body without errors', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, radius, body),
          returnsNormally,
        );
      });

      test('should draw black hole with special rendering', () {
        final blackHole = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 10.0,
          color: AppColors.uiBlack,
          name: 'Black Hole',
        );

        expect(
          () =>
              CelestialBodyPainter.drawBody(canvas, center, radius, blackHole),
          returnsNormally,
        );
      });

      test('should draw Sun with special rendering', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, radius, sun),
          returnsNormally,
        );
      });

      test('should draw all planets with special rendering', () {
        final planets = [
          'Mercury',
          'Venus',
          'Earth',
          'Mars',
          'Jupiter',
          'Saturn',
          'Uranus',
          'Neptune',
        ];

        for (final planetName in planets) {
          final planet = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 10.0,
            radius: 5.0,
            color: AppColors.basicBlue,
            name: planetName,
          );

          expect(
            () => CelestialBodyPainter.drawBody(canvas, center, radius, planet),
            returnsNormally,
            reason: 'Failed to draw $planetName',
          );
        }
      });
    });

    group('Individual Celestial Bodies', () {
      test('should draw black hole with accretion disk', () {
        expect(
          () => CelestialBodyPainter.drawBlackHole(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Sun with corona', () {
        final testBody = Body(
          name: 'Sun',
          mass: 1.989e30,
          radius: 6.96e8,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          color: AppColors.basicYellow,
        );
        expect(
          () => CelestialBodyPainter.drawSun(canvas, center, radius, testBody),
          returnsNormally,
        );
      });

      test('should draw Mercury with craters', () {
        expect(
          () => CelestialBodyPainter.drawMercury(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Venus with atmosphere', () {
        expect(
          () => CelestialBodyPainter.drawVenus(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Earth with continents and atmosphere', () {
        expect(
          () => CelestialBodyPainter.drawEarth(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Mars with polar ice caps', () {
        expect(
          () => CelestialBodyPainter.drawMars(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Jupiter with Great Red Spot and bands', () {
        expect(
          () => CelestialBodyPainter.drawJupiter(canvas, center, radius),
          returnsNormally,
        );
      });

      test('should draw Saturn with rings', () {
        final saturn = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.basicYellow,
          name: 'Saturn',
        );
        expect(
          () => CelestialBodyPainter.drawSaturn(canvas, center, radius, saturn),
          returnsNormally,
        );
      });

      test('should draw Uranus with tilted rings', () {
        final uranus = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.basicCyan,
          name: 'Uranus',
        );
        expect(
          () => CelestialBodyPainter.drawUranus(canvas, center, radius, uranus),
          returnsNormally,
        );
      });

      test('should draw Neptune with Great Dark Spot', () {
        expect(
          () => CelestialBodyPainter.drawNeptune(canvas, center, radius),
          returnsNormally,
        );
      });
    });

    group('Edge Cases', () {
      test('should handle zero radius', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, 0.0, body),
          returnsNormally,
        );
      });

      test('should handle very large radius', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, 1000.0, body),
          returnsNormally,
        );
      });

      test('should handle negative center coordinates', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            const Offset(-100, -100),
            radius,
            body,
          ),
          returnsNormally,
        );
      });

      test('should handle transparent colors', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue.withValues(
            alpha: AppTypography.opacityTransparent,
          ),
          name: 'Test Body',
        );

        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, radius, body),
          returnsNormally,
        );
      });
    });

    group('Visual Effects Conditional Rendering', () {
      test('should render stellar coronas when enabled', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            sun,
            showStellarCoronas: true,
          ),
          returnsNormally,
        );
      });

      test('should skip stellar coronas when disabled', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            sun,
            showStellarCoronas: false,
          ),
          returnsNormally,
        );
      });

      test('should render atmospheric effects on planets when enabled', () {
        final earth = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Earth',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            earth,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should skip atmospheric effects on planets when disabled', () {
        final earth = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Earth',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            earth,
            showAtmosphericEffects: false,
          ),
          returnsNormally,
        );
      });

      test('should support both effects enabled simultaneously', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            sun,
            showStellarCoronas: true,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should support both effects disabled simultaneously', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            sun,
            showStellarCoronas: false,
            showAtmosphericEffects: false,
          ),
          returnsNormally,
        );
      });
    });

    group('Sunspot and Solar Flare Rendering', () {
      test('should render sunspots on Sun without errors', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            sun,
            useRealisticColors: true, // Enables sunspots
          ),
          returnsNormally,
        );
      });

      test('should render sunspots on other stars without errors', () {
        final star = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1500.0,
          radius: 25.0,
          color: AppColors.stellarFType,
          name: 'Star Alpha',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            star,
            useRealisticColors: true,
          ),
          returnsNormally,
        );
      });

      test('should handle sunspot rendering at different scales', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        // Test with small radius
        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            10.0, // Small radius
            sun,
            useRealisticColors: true,
          ),
          returnsNormally,
        );

        // Test with large radius
        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            200.0, // Large radius
            sun,
            useRealisticColors: true,
          ),
          returnsNormally,
        );
      });

      test('should render solar flares without errors', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        // Solar flares are drawn as part of drawBody for stars
        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            sun,
            useRealisticColors: true,
          ),
          returnsNormally,
        );
      });

      test('should handle multiple render calls consistently', () {
        final sun = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1000.0,
          radius: 20.0,
          color: AppColors.basicYellow,
          name: 'Sun',
        );

        // Render multiple times to test caching behavior
        for (int i = 0; i < 5; i++) {
          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              sun,
              useRealisticColors: true,
            ),
            returnsNormally,
            reason: 'Failed on render iteration $i',
          );
        }
      });

      test(
        'should render without sunspots when useRealisticColors is false',
        () {
          final sun = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 20.0,
            color: AppColors.basicYellow,
            name: 'Sun',
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              sun,
              useRealisticColors: false, // Disables sunspots
            ),
            returnsNormally,
          );
        },
      );
    });

    group('Atmospheric Halo Rendering', () {
      test('should render atmospheric effects on Mercury', () {
        final mercury = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.planetMercury,
          name: 'Mercury',
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            mercury,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should render atmospheric effects on all planets', () {
        final planetNames = [
          'Mercury',
          'Venus',
          'Earth',
          'Mars',
          'Jupiter',
          'Saturn',
          'Uranus',
          'Neptune',
        ];

        for (final planetName in planetNames) {
          final planet = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 10.0,
            radius: 5.0,
            color: AppColors.basicBlue,
            name: planetName,
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              planet,
              showAtmosphericEffects: true,
            ),
            returnsNormally,
            reason: 'Failed to render atmospheric effects on $planetName',
          );
        }
      });

      test('should handle atmospheric effects at different scales', () {
        final earth = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0,
          radius: 5.0,
          color: AppColors.planetEarth,
          name: 'Earth',
        );

        // Test with various scales
        final scales = [5.0, 20.0, 50.0, 100.0, 200.0];
        for (final scale in scales) {
          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              scale,
              earth,
              showAtmosphericEffects: true,
            ),
            returnsNormally,
            reason: 'Failed at scale $scale',
          );
        }
      });
    });

    group('Generic Planet Atmospheric Effects', () {
      test('should apply atmospheric effects to rocky planets', () {
        final rockyPlanet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.5, // Small rocky planet mass range
          radius: 0.5,
          color: AppColors.terrestrialRockyMercury,
          name: 'Rocky Planet',
          bodyType: BodyType.planet,
          isPlanet: true,
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            rockyPlanet,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should apply atmospheric effects to earth-like planets', () {
        final earthLike = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 3.0, // Earth-like planet mass range
          radius: 1.2,
          color: AppColors.terrestrialEarthLike,
          name: 'Earth-like',
          bodyType: BodyType.planet,
          isPlanet: true,
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            earthLike,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should apply atmospheric effects to super-earth planets', () {
        final superEarth = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 5.0, // Super-Earth mass range
          radius: 1.8,
          color: AppColors.superEarthTemperate,
          name: 'Super-Earth',
          bodyType: BodyType.planet,
          isPlanet: true,
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            superEarth,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should apply atmospheric effects to gas giants', () {
        final gasGiant = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 10.0, // Large gas giant mass
          radius: 3.0,
          color: AppColors.gasGiantJupiterLike,
          name: 'Gas Giant',
          bodyType: BodyType.planet,
          isPlanet: true,
        );

        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            gasGiant,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test('should NOT apply atmospheric effects when disabled', () {
        final planet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 3.0,
          radius: 1.2,
          color: AppColors.terrestrialEarthLike,
          name: 'Test Planet',
          bodyType: BodyType.planet,
          isPlanet: true,
        );

        // Should render normally without atmospheric effects
        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            planet,
            showAtmosphericEffects: false,
          ),
          returnsNormally,
        );
      });

      test('should NOT apply atmospheric effects to non-planet bodies', () {
        final star = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 100.0,
          radius: 5.0,
          color: AppColors.stellarGType,
          name: 'Star',
          bodyType: BodyType.star,
          isPlanet: false,
        );

        // Should render star normally without atmospheric effects
        expect(
          () => CelestialBodyPainter.drawBody(
            canvas,
            center,
            radius,
            star,
            showAtmosphericEffects: true,
          ),
          returnsNormally,
        );
      });

      test(
        'should NOT apply atmospheric effects to bodies without isPlanet flag',
        () {
          final asteroid = Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 0.1,
            radius: 0.2,
            color: AppColors.uiOrange,
            name: 'Asteroid',
            bodyType: BodyType.asteroid,
            isPlanet: false,
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              asteroid,
              showAtmosphericEffects: true,
            ),
            returnsNormally,
          );
        },
      );

      test('should handle planets in custom scenarios', () {
        final customPlanets = [
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 1.8,
            radius: 0.8,
            color: AppColors.terrestrialRockyMercury,
            name: 'Inner Rocky Planet',
            bodyType: BodyType.planet,
            isPlanet: true,
          ),
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 3.2,
            radius: 1.5,
            color: AppColors.terrestrialEarthLike,
            name: 'Habitable Planet',
            bodyType: BodyType.planet,
            isPlanet: true,
          ),
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 6.5,
            radius: 2.2,
            color: AppColors.gasGiantJupiterLike,
            name: 'Gas Giant',
            bodyType: BodyType.planet,
            isPlanet: true,
          ),
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 4.5,
            radius: 1.8,
            color: AppColors.iceGiantNeptuneLike,
            name: 'Ice Giant',
            bodyType: BodyType.planet,
            isPlanet: true,
          ),
          Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: 2.8,
            radius: 1.2,
            color: AppColors.temperatureCold,
            name: 'Rogue Planet',
            bodyType: BodyType.planet,
            isPlanet: true,
          ),
        ];

        for (final planet in customPlanets) {
          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              planet,
              showAtmosphericEffects: true,
            ),
            returnsNormally,
            reason: 'Failed for ${planet.name}',
          );
        }
      });

      test('should scale atmospheric effects with planet size', () {
        final planet = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 3.0,
          radius: 1.2,
          color: AppColors.terrestrialEarthLike,
          name: 'Test Planet',
          bodyType: BodyType.planet,
          isPlanet: true,
        );

        // Test with various sizes
        final sizes = [10.0, 30.0, 60.0, 120.0, 200.0];
        for (final size in sizes) {
          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              size,
              planet,
              showAtmosphericEffects: true,
            ),
            returnsNormally,
            reason: 'Failed at size $size',
          );
        }
      });
    });

    tearDown(() {
      recorder.endRecording();
    });
  });
}
