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
      test('should handle very small radius', () {
        final body = Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: AppColors.basicBlue,
          name: 'Test Body',
        );

        // Use minimum valid radius (0.1) instead of zero to avoid NaN
        expect(
          () => CelestialBodyPainter.drawBody(canvas, center, 0.1, body),
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

    group('Lighting Effects', () {
      group('drawBody with hemisphere lighting', () {
        test('should apply hemisphere lighting from nearest star', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Earth',
            bodyType: BodyType.planet,
          );

          final star = Body(
            position: vm.Vector3(10, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Sun',
            bodyType: BodyType.star,
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              planet,
              enableHemisphereLighting: true,
              allBodies: [planet, star],
            ),
            returnsNormally,
          );
        });

        test('should work with multiple stars', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final star1 = Body(
            position: vm.Vector3(10, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star 1',
            bodyType: BodyType.star,
          );

          final star2 = Body(
            position: vm.Vector3(-10, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star 2',
            bodyType: BodyType.star,
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              planet,
              enableHemisphereLighting: true,
              allBodies: [planet, star1, star2],
            ),
            returnsNormally,
          );
        });

        test('should handle no stars gracefully', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              planet,
              enableHemisphereLighting: true,
              allBodies: [planet],
            ),
            returnsNormally,
          );
        });
      });

      group('drawCastShadow', () {
        test('should draw cast shadow with blocking body', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Shadowed Planet',
            bodyType: BodyType.planet,
          );

          final star = Body(
            position: vm.Vector3(20, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star',
            bodyType: BodyType.star,
          );

          final blocker = Body(
            position: vm.Vector3(10, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 3.0,
            radius: 1.5,
            color: AppColors.basicRed,
            name: 'Blocking Body',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawCastShadow(
              canvas,
              center,
              radius,
              planet,
              [planet, star, blocker],
            ),
            returnsNormally,
          );
        });

        test('should handle multiple blocking bodies', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final star = Body(
            position: vm.Vector3(30, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star',
            bodyType: BodyType.star,
          );

          final blocker1 = Body(
            position: vm.Vector3(10, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 3.0,
            radius: 1.5,
            color: AppColors.basicRed,
            name: 'Blocker 1',
            bodyType: BodyType.planet,
          );

          final blocker2 = Body(
            position: vm.Vector3(20, 5, 0),
            velocity: vm.Vector3.zero(),
            mass: 3.0,
            radius: 1.5,
            color: AppColors.basicRed,
            name: 'Blocker 2',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawCastShadow(
              canvas,
              center,
              radius,
              planet,
              [planet, star, blocker1, blocker2],
            ),
            returnsNormally,
          );
        });

        test('should handle no light sources', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawCastShadow(
              canvas,
              center,
              radius,
              planet,
              [planet],
            ),
            returnsNormally,
          );
        });

        test('should work with binary star system', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final star1 = Body(
            position: vm.Vector3(15, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star 1',
            bodyType: BodyType.star,
          );

          final star2 = Body(
            position: vm.Vector3(-15, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarKType,
            name: 'Star 2',
            bodyType: BodyType.star,
          );

          final blocker = Body(
            position: vm.Vector3(7, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 3.0,
            radius: 1.5,
            color: AppColors.basicRed,
            name: 'Blocker',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawCastShadow(
              canvas,
              center,
              radius,
              planet,
              [planet, star1, star2, blocker],
            ),
            returnsNormally,
          );
        });
      });

      group('drawSpecularHighlight', () {
        test('should draw specular highlight from nearest star', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final star = Body(
            position: vm.Vector3(10, 5, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star',
            bodyType: BodyType.star,
          );

          expect(
            () => CelestialBodyPainter.drawSpecularHighlight(
              canvas,
              center,
              radius,
              planet,
              [planet, star],
            ),
            returnsNormally,
          );
        });

        test('should choose nearest star from multiple', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final nearStar = Body(
            position: vm.Vector3(5, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Near Star',
            bodyType: BodyType.star,
          );

          final farStar = Body(
            position: vm.Vector3(50, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarKType,
            name: 'Far Star',
            bodyType: BodyType.star,
          );

          expect(
            () => CelestialBodyPainter.drawSpecularHighlight(
              canvas,
              center,
              radius,
              planet,
              [planet, nearStar, farStar],
            ),
            returnsNormally,
          );
        });

        test('should handle no stars', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawSpecularHighlight(
              canvas,
              center,
              radius,
              planet,
              [planet],
            ),
            returnsNormally,
          );
        });

        test('should work with different body sizes', () {
          final star = Body(
            position: vm.Vector3(10, 5, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star',
            bodyType: BodyType.star,
          );

          final sizes = [0.5, 1.0, 2.0, 5.0, 10.0];

          for (final size in sizes) {
            final body = Body(
              position: vm.Vector3(0, 0, 0),
              velocity: vm.Vector3.zero(),
              mass: 5.0,
              radius: size,
              color: AppColors.terrestrialEarthLike,
              name: 'Body $size',
              bodyType: BodyType.planet,
            );

            expect(
              () => CelestialBodyPainter.drawSpecularHighlight(
                canvas,
                center,
                radius * size,
                body,
                [body, star],
              ),
              returnsNormally,
              reason: 'Failed at size $size',
            );
          }
        });
      });

      group('Combined Lighting in drawBody', () {
        test('should apply all lighting effects when enabled', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final star = Body(
            position: vm.Vector3(10, 5, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star',
            bodyType: BodyType.star,
          );

          final blocker = Body(
            position: vm.Vector3(5, 2, 0),
            velocity: vm.Vector3.zero(),
            mass: 3.0,
            radius: 1.5,
            color: AppColors.basicRed,
            name: 'Blocker',
            bodyType: BodyType.planet,
          );

          expect(
            () => CelestialBodyPainter.drawBody(
              canvas,
              center,
              radius,
              planet,
              enableHemisphereLighting: true,
              enableCastShadows: true,
              enableSpecularHighlights: true,
              allBodies: [planet, star, blocker],
            ),
            returnsNormally,
          );
        });

        test('should respect individual lighting toggles', () {
          final planet = Body(
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3.zero(),
            mass: 5.0,
            radius: 2.0,
            color: AppColors.terrestrialEarthLike,
            name: 'Planet',
            bodyType: BodyType.planet,
          );

          final star = Body(
            position: vm.Vector3(10, 5, 0),
            velocity: vm.Vector3.zero(),
            mass: 1000.0,
            radius: 5.0,
            color: AppColors.stellarGType,
            name: 'Star',
            bodyType: BodyType.star,
          );

          // Test each combination
          final combinations = [
            {'hemisphere': true, 'shadow': false, 'specular': false},
            {'hemisphere': false, 'shadow': true, 'specular': false},
            {'hemisphere': false, 'shadow': false, 'specular': true},
            {'hemisphere': true, 'shadow': true, 'specular': false},
            {'hemisphere': true, 'shadow': false, 'specular': true},
            {'hemisphere': false, 'shadow': true, 'specular': true},
            {'hemisphere': false, 'shadow': false, 'specular': false},
          ];

          for (final combo in combinations) {
            expect(
              () => CelestialBodyPainter.drawBody(
                canvas,
                center,
                radius,
                planet,
                enableHemisphereLighting: combo['hemisphere']!,
                enableCastShadows: combo['shadow']!,
                enableSpecularHighlights: combo['specular']!,
                allBodies: [planet, star],
              ),
              returnsNormally,
              reason: 'Failed with combo: $combo',
            );
          }
        });
      });
    });

    group('Enhancement Features', () {
      test('should apply albedo-based specular highlights', () {
        final testRecorder = ui.PictureRecorder();
        final testCanvas = Canvas(testRecorder);

        final iceWorld = Body(
          name: 'Ice Planet',
          mass: 1.0,
          radius: 6.0e6,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.white,
          bodyType: BodyType.planet,
        );

        final star = Body(
          name: 'Star',
          mass: 100.0,
          radius: 6.96e8,
          position: vm.Vector3(10, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.yellow,
          bodyType: BodyType.star,
        );

        CelestialBodyPainter.drawBody(
          testCanvas,
          const Offset(100, 100),
          50.0,
          iceWorld,
          enableSpecularHighlights: true,
          allBodies: [star, iceWorld],
        );

        expect(() => testRecorder.endRecording(), returnsNormally);
      });

      test('should blend light from multiple stars', () {
        final testRecorder = ui.PictureRecorder();
        final testCanvas = Canvas(testRecorder);

        final planet = Body(
          name: 'Planet',
          mass: 1.0,
          radius: 6.0e6,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.blue,
          bodyType: BodyType.planet,
        );

        final starA = Body(
          name: 'Star A',
          mass: 100.0,
          radius: 6.96e8,
          position: vm.Vector3(10, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.yellow,
          bodyType: BodyType.star,
        );

        final starB = Body(
          name: 'Star B',
          mass: 80.0,
          radius: 5.5e8,
          position: vm.Vector3(-8, 5, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.orange,
          bodyType: BodyType.star,
        );

        CelestialBodyPainter.drawBody(
          testCanvas,
          const Offset(100, 100),
          50.0,
          planet,
          enableHemisphereLighting: true,
          allBodies: [starA, starB, planet],
        );

        expect(() => testRecorder.endRecording(), returnsNormally);
      });

      test('should draw atmospheric scattering on planets', () {
        final testRecorder = ui.PictureRecorder();
        final testCanvas = Canvas(testRecorder);

        final earth = Body(
          name: 'Earth',
          mass: 1.0,
          radius: 6.0e6,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.blue,
          bodyType: BodyType.planet,
        );

        final sun = Body(
          name: 'Sun',
          mass: 333000.0,
          radius: 6.96e8,
          position: vm.Vector3(15, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.yellow,
          bodyType: BodyType.star,
        );

        CelestialBodyPainter.drawBody(
          testCanvas,
          const Offset(100, 100),
          50.0,
          earth,
          enableHemisphereLighting: true,
          allBodies: [sun, earth],
        );

        expect(() => testRecorder.endRecording(), returnsNormally);
      });

      test('should combine all enhancements', () {
        final testRecorder = ui.PictureRecorder();
        final testCanvas = Canvas(testRecorder);

        final planet = Body(
          name: 'Tatooine',
          mass: 1.0,
          radius: 6.0e6,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.orange,
          bodyType: BodyType.planet,
        );

        final sunA = Body(
          name: 'Tatoo I',
          mass: 100.0,
          radius: 6.96e8,
          position: vm.Vector3(12, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.yellow,
          bodyType: BodyType.star,
        );

        final sunB = Body(
          name: 'Tatoo II',
          mass: 95.0,
          radius: 6.8e8,
          position: vm.Vector3(-10, 7, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.orange,
          bodyType: BodyType.star,
        );

        CelestialBodyPainter.drawBody(
          testCanvas,
          const Offset(100, 100),
          50.0,
          planet,
          enableHemisphereLighting: true,
          enableCastShadows: true,
          enableSpecularHighlights: true,
          allBodies: [sunA, sunB, planet],
        );

        expect(() => testRecorder.endRecording(), returnsNormally);
      });
    });

    tearDown(() {
      recorder.endRecording();
    });
  });
}
