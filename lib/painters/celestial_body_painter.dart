import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/painters/light_contribution.dart';
import 'package:graviton/painters/shadow_info.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/sunspot_data.dart';
import 'package:graviton/services/stellar_color_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering celestial bodies (planets, stars, black holes)
class CelestialBodyPainter {
  // Cache for sunspot positions to avoid recalculating on every frame
  static final Map<int, List<SunspotData>> _sunspotCache = {};

  // Reusable DateFormat instance for efficient day-of-year calculations
  static final DateFormat _dayOfYearFormat = DateFormat("D");

  /// Calculate the average distance of points from the screen center
  static double _calculateAverageDistanceFromCenter(
    List<Offset> points,
    Size canvasSize,
  ) {
    if (points.isEmpty) {
      return double.infinity;
    }

    final screenCenter = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final totalDistance = points
        .map((point) => (point - screenCenter).distance)
        .reduce((sum, distance) => sum + distance);

    return totalDistance / points.length;
  }

  /// Draw a body based on its name/type with special rendering for known celestial objects
  static void drawBody(
    Canvas canvas,
    Offset center,
    double radius,
    Body body, {
    vm.Matrix4? viewMatrix,
    Size? canvasSize,
    double opacity = 1.0,
    bool useRealisticColors = false,
    bool showStellarCoronas = true,
    bool showAtmosphericEffects = false,
    bool enableHemisphereLighting = true,
    bool enableCastShadows = false,
    bool enableSpecularHighlights = false,
    List<Body>? allBodies,
    bool showRelativisticGlow = false,
    bool showTidalVisualization = false,
  }) {
    // Special rendering for celestial bodies
    final bodyEnum = CelestialBodyName.fromString(body.name);
    if (bodyEnum?.isBlackHole == true) {
      drawBlackHole(canvas, center, radius, opacity: opacity);
    } else if (bodyEnum == CelestialBodyName.sun ||
        (body.bodyType == BodyType.star &&
            bodyEnum == CelestialBodyName.centralStar)) {
      drawSun(
        canvas,
        center,
        radius,
        body,
        useRealisticColors: useRealisticColors,
        showStellarCoronas: showStellarCoronas,
      );
    } else if (body.bodyType == BodyType.star &&
        useRealisticColors &&
        _shouldHaveSunspots(body)) {
      // Other stars that should have magnetic activity (sunspots) - ONLY in realistic mode
      drawSun(
        canvas,
        center,
        radius,
        body,
        useRealisticColors: useRealisticColors,
        showStellarCoronas: showStellarCoronas,
      );
    } else {
      // Check for specific celestial body types using enum
      final celestialBody = CelestialBodyName.fromString(body.name);

      switch (celestialBody) {
        case CelestialBodyName.mercury:
          drawMercury(canvas, center, radius);
          if (showAtmosphericEffects) {
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetMercury,
              hazeIntensity: 0.1,
            );
          }
        case CelestialBodyName.venus:
          drawVenus(canvas, center, radius);
          if (showAtmosphericEffects) {
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetVenus,
              hazeIntensity: 0.6,
            );
          }
        case CelestialBodyName.earth:
          drawEarth(canvas, center, radius);
          if (showAtmosphericEffects) {
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetEarth,
              hazeIntensity: 0.3,
              atmosphericColor: AppColors.starSkyBlue,
            );
          }
        case CelestialBodyName.mars:
          drawMars(canvas, center, radius);
          if (showAtmosphericEffects) {
            // Mars has a thin CO2 atmosphere with dust storms
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetMars,
              hazeIntensity: 0.15, // Thin atmosphere
            );
          }
        case CelestialBodyName.jupiter:
          drawJupiter(canvas, center, radius);
          if (showAtmosphericEffects) {
            // Jupiter has extensive atmosphere with cloud bands
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetJupiter,
              hazeIntensity: 0.4, // Thick atmosphere
            );
          }
        case CelestialBodyName.saturn:
          drawSaturn(
            canvas,
            center,
            radius,
            body,
            viewMatrix: viewMatrix,
            canvasSize: canvasSize,
          );
          if (showAtmosphericEffects) {
            // Saturn has similar atmosphere to Jupiter but slightly less dense
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetSaturn,
              hazeIntensity: 0.35, // Thick atmosphere
            );
          }
        case CelestialBodyName.uranus:
          drawUranus(
            canvas,
            center,
            radius,
            body,
            viewMatrix: viewMatrix,
            canvasSize: canvasSize,
          );
          if (showAtmosphericEffects) {
            // Uranus has methane atmosphere giving blue-green haze
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetUranus,
              hazeIntensity: 0.25, // Moderate atmosphere
            );
          }
        case CelestialBodyName.neptune:
          drawNeptune(canvas, center, radius);
          if (showAtmosphericEffects) {
            // Neptune has similar atmosphere to Uranus with deeper blue
            _drawAtmosphericHalo(
              canvas,
              center,
              radius,
              AppColors.planetNeptune,
              hazeIntensity: 0.3, // Moderate atmosphere
            );
          }
        default:
          // Normal body rendering
          // Use realistic colors based on stellar properties when enabled
          final bodyColor = useRealisticColors
              ? StellarColorService.getRealisticBodyColor(body)
              : body.color;

          // Calculate hemisphere lighting offset if enabled
          Offset lightingOffset = Offset.zero;
          if (enableHemisphereLighting && allBodies != null) {
            final rawOffset = _calculateHemisphereLightingOffset(
              allBodies,
              body,
              center,
            );
            // Scale offset by radius to make it proportional to body size
            lightingOffset = Offset(
              rawOffset.dx * radius,
              rawOffset.dy * radius,
            );
          }

          // Create gradient with lighting offset applied
          final gradientCenter = center + lightingOffset;
          final glow = RadialGradient(
            center: Alignment(
              (gradientCenter.dx - center.dx) /
                  (radius * RenderingConstants.bodyGlowMultiplier),
              (gradientCenter.dy - center.dy) /
                  (radius * RenderingConstants.bodyGlowMultiplier),
            ),
            colors: [
              bodyColor.withValues(alpha: RenderingConstants.bodyAlpha),
              bodyColor.withValues(alpha: RenderingConstants.bodyGlowAlpha),
            ],
          );

          final rect = Rect.fromCircle(
            center: center,
            radius: radius * RenderingConstants.bodyGlowMultiplier,
          );
          canvas.drawCircle(
            center,
            radius * RenderingConstants.bodyGlowMultiplier,
            Paint()..shader = glow.createShader(rect),
          );

          // Draw solid body with hemisphere lighting
          if (enableHemisphereLighting && lightingOffset != Offset.zero) {
            // Create hemisphere gradient for main body
            final hemisphereGradient = RadialGradient(
              center: Alignment(
                lightingOffset.dx / radius,
                lightingOffset.dy / radius,
              ),
              colors: [
                // Brighter on lit side
                Color.lerp(
                  bodyColor,
                  AppColors.uiWhite,
                  RenderingConstants.hemisphereLightingIntensity,
                )!,
                bodyColor,
                // Darker on shadow side
                Color.lerp(
                  bodyColor,
                  AppColors.uiBlack,
                  RenderingConstants.hemisphereLightingIntensity *
                      RenderingConstants.hemisphereLightingShadowIntensityRatio,
                )!,
              ],
              stops: const [
                RenderingConstants.hemisphereLightingGradientStart,
                RenderingConstants.hemisphereLightingGradientMid,
                RenderingConstants.hemisphereLightingGradientEnd,
              ],
            );

            final bodyRect = Rect.fromCircle(center: center, radius: radius);
            canvas.drawCircle(
              center,
              radius,
              Paint()..shader = hemisphereGradient.createShader(bodyRect),
            );
          } else {
            // No hemisphere lighting - use solid color
            canvas.drawCircle(center, radius, Paint()..color = bodyColor);
          }

          // Draw cast shadows if enabled
          if (enableCastShadows &&
              allBodies != null &&
              body.bodyType != BodyType.star) {
            drawCastShadow(canvas, center, radius, body, allBodies);
          }

          // Draw specular highlights if enabled
          if (enableSpecularHighlights &&
              allBodies != null &&
              body.bodyType != BodyType.star) {
            drawSpecularHighlight(canvas, center, radius, body, allBodies);
          }

          // Draw atmospheric scattering if hemisphere lighting is enabled
          // This creates a sunrise/sunset glow on the lit side
          if (enableHemisphereLighting &&
              allBodies != null &&
              body.bodyType == BodyType.planet) {
            drawAtmosphericScattering(
              canvas,
              center,
              radius,
              body,
              allBodies,
              bodyColor,
            );
          }

          // Apply atmospheric effects to all planets (not in named solar system)
          if (showAtmosphericEffects &&
              body.bodyType == BodyType.planet &&
              body.isPlanet == true) {
            final intensity = _getAtmosphericIntensityForBody(body);
            if (intensity > 0.0) {
              _drawAtmosphericHalo(
                canvas,
                center,
                radius,
                bodyColor,
                hazeIntensity: intensity,
              );
            }
          }

          // Draw relativistic glow if enabled and body has time dilation
          if (showRelativisticGlow &&
              body.showRelativisticGlow &&
              body.timeDilationFactor < 1.0) {
            _drawRelativisticGlow(
              canvas,
              center,
              radius,
              body.timeDilationFactor,
              bodyColor,
            );
          }

          // Draw tidal deformation and stress visualization if enabled
          if (showTidalVisualization && body.showTidalForces) {
            _drawTidalVisualization(canvas, center, radius, body, bodyColor);
          }
      }
    }
  }

  /// Draw a realistic black hole with accretion disk and event horizon
  static void drawBlackHole(
    Canvas canvas,
    Offset center,
    double radius, {
    double opacity = 1.0,
  }) {
    // Enhanced accretion disk for supermassive black hole - clean glow
    final accretionDiskRadius =
        radius *
        RenderingConstants
            .blackHoleAccretionDiskMultiplier; // Large disk for presence

    // Single clean glow - no color mixing issues (with opacity adjustment)
    final cleanGlow = RadialGradient(
      colors: [
        AppColors.starGlowWhite.withValues(
          alpha: AppTypography.opacityHigh * opacity,
        ), // Bright white center
        AppColors.starGlowGold.withValues(
          alpha: AppTypography.opacityMedium * opacity,
        ), // Golden ring
        AppColors.starGlowOrange.withValues(
          alpha: AppTypography.opacityFaint * opacity,
        ), // Orange outer
        AppColors.starGlowRedOrange.withValues(
          alpha: AppTypography.opacityMidFade * opacity,
        ), // Dim orange edge
        AppColors.transparentColor,
      ],
    );

    final glowRect = Rect.fromCircle(
      center: center,
      radius: accretionDiskRadius,
    );
    canvas.drawCircle(
      center,
      accretionDiskRadius,
      Paint()..shader = cleanGlow.createShader(glowRect),
    );

    // Clean accretion disk rings - simple and bright
    final diskPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppTypography.borderExtraThick;

    for (int i = 0; i < 5; i++) {
      final ringRadius = radius * (1.3 + i * 0.4);
      final alpha =
          ((RenderingConstants.blackHoleRingBaseAlpha -
                      i * RenderingConstants.blackHoleRingAlphaDecrement) *
                  opacity)
              .clamp(
                AppTypography.opacityTransparent,
                AppTypography.opacityFull,
              ); // Clean intensity progression with opacity

      // Clean color progression - no green mixing
      Color ringColor;
      if (i == 0) {
        ringColor = AppColors.starGlowWhite.withValues(alpha: alpha); // White
      } else if (i == 1) {
        ringColor = AppColors.starGlowGold.withValues(alpha: alpha); // Gold
      } else if (i == 2) {
        ringColor = AppColors.starGlowOrange.withValues(alpha: alpha); // Orange
      } else {
        ringColor = AppColors.starGlowRedOrange.withValues(
          alpha: alpha,
        ); // Red-orange
      }

      diskPaint.color = ringColor;
      canvas.drawCircle(center, ringRadius, diskPaint);
    }

    // Photon sphere - gravitational lensing effect (with opacity)
    final photonSphereRadius = radius * 1.8;
    final photonSpherePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.starGlowWhite.withValues(
        alpha: AppTypography.opacityFaint * opacity,
      );

    canvas.drawCircle(center, photonSphereRadius, photonSpherePaint);

    // Event horizon - the inescapable void (with opacity for fade effect)
    final eventHorizonPaint = Paint()
      ..color = AppColors.uiBlack.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, eventHorizonPaint);

    // Schwarzschild radius indicator - menacing edge of no return (with opacity)
    final schwarzschildPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = RenderingConstants.blackHoleEventHorizonStrokeWidth
      ..color = AppColors.starGlowWhite.withValues(
        alpha: AppTypography.opacityMediumHigh * opacity,
      );

    canvas.drawCircle(center, radius, schwarzschildPaint);

    // Add subtle gravitational distortion rings for menacing effect (with opacity)
    for (int i = 1; i <= 2; i++) {
      final distortionRadius = radius * (1.0 + i * 0.15);
      final distortionPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = RenderingConstants.blackHoleDistortionStrokeWidth
        ..color = AppColors.starGlowWhite.withValues(
          alpha: (AppTypography.opacityVeryFaint / i) * opacity,
        );

      canvas.drawCircle(center, distortionRadius, distortionPaint);
    }
  }

  /// Draw the Sun with solar flares and corona, adapted for realistic stellar colors
  static void drawSun(
    Canvas canvas,
    Offset center,
    double radius,
    Body body, {
    bool useRealisticColors = false,
    bool showStellarCoronas = true,
  }) {
    // Get current time once for all solar animations
    final currentTimeSeconds = DateTime.now().millisecondsSinceEpoch / 1000.0;

    // Determine stellar surface color based on realistic colors setting
    final stellarColor = useRealisticColors
        ? StellarColorService.getRealisticBodyColor(body)
        : (body.name == 'Sun'
              ? AppColors.coronaGold
              : body.color); // Use warmer gold instead of pure yellow

    // Calculate stellar temperature for color adaptation
    final stellarTemperature =
        body.temperature >
            SimulationConstants
                .meaningfulStellarTemperatureThreshold // Has a meaningful stellar temperature
        ? body.temperature
        : _calculateStellarTemperature(body.mass);

    // Corona - outer solar atmosphere (adapt color to stellar type)
    // Only render if showStellarCoronas is true
    if (showStellarCoronas) {
      final coronaGlow = RadialGradient(
        colors: [
          _getCoronaColor(stellarTemperature, useRealisticColors).withValues(
            alpha: AppTypography.opacityVeryHigh,
          ), // Bright center adapted to star type
          _getCoronaColor(
            stellarTemperature,
            useRealisticColors,
            isOuter: true,
          ).withValues(alpha: AppTypography.opacityMediumHigh), // Outer color
          AppColors.accretionDiskRed.withValues(
            alpha: AppTypography.opacityFaint,
          ), // Red outer
          AppColors.transparentColor,
        ],
      );

      final coronaRect = Rect.fromCircle(center: center, radius: radius * 3.0);
      canvas.drawCircle(
        center,
        radius * 3.0,
        Paint()..shader = coronaGlow.createShader(coronaRect),
      );
    }

    // Solar surface with stellar color adaptation
    final surfaceGlow = RadialGradient(
      colors: [
        stellarColor, // Center color based on stellar type
        stellarColor.withValues(
          alpha: AppTypography.opacityVeryHigh,
        ), // Slightly transparent middle
        useRealisticColors
            ? _getSurfaceEdgeColor(
                stellarTemperature,
                stellarColor,
              ) // Realistic: temperature-adapted edge
            : AppColors
                  .coronaOrange, // Non-realistic: simple orange edge like before
      ],
    );

    final surfaceRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = surfaceGlow.createShader(surfaceRect),
    );

    // Add random sunspots (dark regions on solar surface) - adapted to stellar temperature
    _drawSunspots(
      canvas,
      center,
      radius,
      stellarTemperature,
      stellarColor,
      body,
    );

    // Add dynamic solar flares (bright eruptions from surface) - adapted to stellar type
    _drawSolarFlares(
      canvas,
      center,
      radius,
      currentTimeSeconds,
      stellarTemperature,
      stellarColor,
      body,
    );
  }

  /// Draw realistic sunspots on the sun's surface - adapted to stellar temperature
  static void _drawSunspots(
    Canvas canvas,
    Offset center,
    double radius,
    double stellarTemperature,
    Color stellarColor,
    Body body,
  ) {
    // Use a seed based on the current day and body name for stable sunspot positions
    final now = DateTime.now().toUtc();
    final dayOfYear = int.parse(_dayOfYearFormat.format(now));
    final bodyHash = body.name.hashCode.abs();

    // Create seed that changes daily and is unique per body
    final seed = dayOfYear * RenderingConstants.seedDayMultiplier + bodyHash;

    // Check if we need to recalculate sunspots for this day
    final cacheKey = seed;
    List<SunspotData>? cachedSunspots = _sunspotCache[cacheKey];

    // Generate sunspots if not cached for this day
    if (cachedSunspots == null) {
      cachedSunspots = _generateSunspots(
        seed,
        center,
        radius,
        stellarTemperature,
        stellarColor,
      );
      _sunspotCache.clear(); // Clear old cache to prevent memory growth
      _sunspotCache[cacheKey] = cachedSunspots;
    }

    // Draw the cached sunspots, transforming from base reference coordinates to current sun
    for (final sunspot in cachedSunspots) {
      // Transform sunspot from base reference coordinates to current sun's position and size
      // Formula: currentPos = currentCenter + (basePos - baseCenter) * scale
      final scaleFactor = radius / _baseSunRadius;
      final adjustedCenter = Offset(
        center.dx + (sunspot.center.dx - _baseSunCenter.dx) * scaleFactor,
        center.dy + (sunspot.center.dy - _baseSunCenter.dy) * scaleFactor,
      );
      final adjustedRadius = sunspot.radius * scaleFactor;

      // Check if adjusted spot is still within sun's visible area
      final distanceFromCenter = (adjustedCenter - center).distance;
      if (distanceFromCenter + adjustedRadius >
          radius * RenderingConstants.sunspotMaxDistanceMultiplier) {
        continue; // Skip spots that would extend too far outside
      }

      // Draw penumbra with adjusted rect
      final adjustedPenumbraRect = Rect.fromCircle(
        center: adjustedCenter,
        radius: adjustedRadius,
      );
      canvas.drawCircle(
        adjustedCenter,
        adjustedRadius,
        Paint()
          ..shader = sunspot.penumbraGradient.createShader(
            adjustedPenumbraRect,
          ),
      );

      // Draw umbra with adjusted rect
      final adjustedUmbraRadius =
          adjustedRadius * RenderingConstants.sunspotUmbraMultiplier;
      final adjustedUmbraRect = Rect.fromCircle(
        center: adjustedCenter,
        radius: adjustedUmbraRadius,
      );
      canvas.drawCircle(
        adjustedCenter,
        adjustedUmbraRadius,
        Paint()..shader = sunspot.umbraGradient.createShader(adjustedUmbraRect),
      );
    }
  }

  // Base reference values for scaling cached sunspots to current sun position/size
  // These are NOT absolute positions - they serve as reference coordinates for relative calculations.
  // Cached sunspots are generated using these base values and then scaled/translated to match
  // the actual sun's current center and radius during rendering.
  static const Offset _baseSunCenter = Offset(
    0,
    0,
  ); // Reference center for relative positioning
  static const double _baseSunRadius =
      100.0; // Reference radius for scaling calculations

  /// Generate sunspots for a specific day using base reference coordinates
  ///
  /// Note: The center and radius parameters are currently unused - sunspots are generated
  /// in base reference coordinates (_baseSunCenter, _baseSunRadius) and later transformed
  /// to match the actual sun's position and size during rendering.
  static List<SunspotData> _generateSunspots(
    int seed,
    Offset center,
    double radius,
    double stellarTemperature,
    Color stellarColor,
  ) {
    final random = math.Random(seed);
    final sunspots = <SunspotData>[];

    // Generate sunspots using configured constants in base coordinate system
    final numSpots =
        RenderingConstants.minSunspots +
        random.nextInt(RenderingConstants.maxAdditionalSunspots);

    for (int i = 0; i < numSpots; i++) {
      // Generate random position within base reference coordinates
      final angle = random.nextDouble() * 2 * math.pi;
      final distance =
          random.nextDouble() *
          _baseSunRadius *
          RenderingConstants
              .sunspotPositionLimitMultiplier; // Keep within 70% of base radius
      final spotCenter = Offset(
        _baseSunCenter.dx + distance * math.cos(angle),
        _baseSunCenter.dy + distance * math.sin(angle),
      );

      // Random size for each sunspot (smaller ones more common)
      final sizeRandom = random.nextDouble();
      double spotRadius;
      if (sizeRandom < RenderingConstants.sunspotSizeProbabilityThreshold) {
        // 60% chance of small sunspot
        spotRadius =
            _baseSunRadius *
            (RenderingConstants.sunspotSizePercentMin +
                random.nextDouble() *
                    RenderingConstants
                        .sunspotSizeRangeSmall); // 3-8% of sun radius
      } else if (sizeRandom < RenderingConstants.sunspotSizeProbabilityMedium) {
        // 30% chance of medium sunspot
        spotRadius =
            _baseSunRadius *
            (RenderingConstants.sunspotSizeMediumMin +
                random.nextDouble() *
                    RenderingConstants
                        .sunspotSizeRangeMedium); // 8-15% of sun radius
      } else {
        // 10% chance of large sunspot
        spotRadius =
            _baseSunRadius *
            (RenderingConstants.sunspotSizeLargeMin +
                random.nextDouble() *
                    RenderingConstants
                        .sunspotSizeRangeLarge); // 12-20% of sun radius
      }

      // Create gradient paint objects with temperature-adaptive colors
      final penumbraColor = _getSunspotPenumbraColor(
        stellarTemperature,
        stellarColor,
      );
      final umbraColor = _getSunspotUmbraColor(
        stellarTemperature,
        stellarColor,
      );

      final penumbraGradient = RadialGradient(
        colors: [
          penumbraColor.withValues(
            alpha: AppTypography.opacityMedium,
          ), // Lighter penumbra adapted to star type
          penumbraColor.withValues(
            alpha: AppTypography.opacityHigh,
          ), // Medium penumbra
          penumbraColor.withValues(
            alpha: AppTypography.opacityFaint,
          ), // Fade to surface
        ],
        stops: const [0.0, 0.6, 1.0],
      );

      final umbraGradient = RadialGradient(
        colors: [
          umbraColor.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ), // Very dark center adapted to star type
          penumbraColor.withValues(
            alpha: AppTypography.opacityMediumHigh,
          ), // Dark penumbra color
          penumbraColor.withValues(
            alpha: AppTypography.opacityMedium,
          ), // Fade to penumbra
        ],
        stops: const [0.0, 0.7, 1.0],
      );

      sunspots.add(
        SunspotData(
          center: spotCenter,
          radius: spotRadius,
          penumbraGradient: penumbraGradient,
          umbraGradient: umbraGradient,
          penumbraRect: Rect.fromCircle(center: spotCenter, radius: spotRadius),
          umbraRect: Rect.fromCircle(
            center: spotCenter,
            radius: spotRadius * 0.4,
          ),
        ),
      );
    }

    return sunspots;
  }

  /// Draw dynamic solar flares erupting from the sun's surface - adapted to stellar type
  static void _drawSolarFlares(
    Canvas canvas,
    Offset center,
    double radius,
    double currentTimeSeconds,
    double stellarTemperature,
    Color stellarColor,
    Body body,
  ) {
    // Use multiple time scales for different flare phases
    final currentTime =
        currentTimeSeconds; // Use passed time instead of DateTime.now()

    // Create multiple flare cycles with different timing
    const flareLifetime =
        30.0; // Each flare lives for 30 seconds (balanced speed)
    const maxFlares = 2; // Maximum concurrent flares (reduced from 3)

    // Get sunspot positions for magnetic field correlation
    // Use day-based seed for variation that matches current sunspots
    final now = DateTime.now().toUtc();
    final dayOfYear = int.parse(_dayOfYearFormat.format(now));
    final bodyHash = body.name.hashCode.abs();
    final daySeed = dayOfYear * RenderingConstants.seedDayMultiplier + bodyHash;

    final sunspotRandom = math.Random(daySeed);
    final numSunspots =
        RenderingConstants.minSunspots +
        sunspotRandom.nextInt(RenderingConstants.maxAdditionalSunspots);
    final sunspotPositions = <Offset>[];

    // Calculate sunspot positions (same logic as _drawSunspots)
    for (int i = 0; i < numSunspots; i++) {
      final angle = sunspotRandom.nextDouble() * 2 * math.pi;
      final distance = sunspotRandom.nextDouble() * radius * 0.7;
      final spotCenter = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );
      sunspotPositions.add(spotCenter);
    }

    // Generate animated flares with staggered timing
    for (int flareIndex = 0; flareIndex < maxFlares; flareIndex++) {
      // Each flare has its own cycle offset
      final flareOffset =
          flareIndex * (flareLifetime / maxFlares); // Stagger flares
      final flareStartTime =
          (currentTime + flareOffset) %
          (flareLifetime * 2.5); // Longer gaps between cycles

      // Skip if this flare hasn't started yet or has ended
      if (flareStartTime > flareLifetime) continue;

      // Calculate flare animation progress (0.0 to 1.0)
      final flareProgress = flareStartTime / flareLifetime;

      // Use flare index with day seed for varied positioning that changes daily
      // Fixed seed per flare cycle - do NOT include flareProgress in seed
      final flareCycle = (currentTime / (flareLifetime * 2.5)).floor();
      final flareRandom = math.Random(
        daySeed +
            flareIndex * RenderingConstants.flareIndexSeedOffset +
            flareCycle * 1000,
      );

      // Choose flare origin (prefer sunspot areas)
      Offset flareOrigin;
      final nearSunspot =
          flareRandom.nextDouble() < 0.75; // 75% chance near sunspot

      if (nearSunspot && sunspotPositions.isNotEmpty) {
        // Place flare near a random sunspot
        final sunspotIndex = flareRandom.nextInt(sunspotPositions.length);
        final sunspot = sunspotPositions[sunspotIndex];

        // Add some variation around the sunspot
        final offsetAngle = flareRandom.nextDouble() * 2 * math.pi;
        final offsetDistance = radius * (0.1 + flareRandom.nextDouble() * 0.2);

        flareOrigin = Offset(
          sunspot.dx + offsetDistance * math.cos(offsetAngle),
          sunspot.dy + offsetDistance * math.sin(offsetAngle),
        );

        // Ensure flare origin is still within sun's surface
        final distanceFromCenter = (flareOrigin - center).distance;
        if (distanceFromCenter > radius * 0.9) {
          final angleToCenter = math.atan2(
            center.dy - flareOrigin.dy,
            center.dx - flareOrigin.dx,
          );
          flareOrigin = Offset(
            center.dx + radius * 0.9 * math.cos(angleToCenter + math.pi),
            center.dy + radius * 0.9 * math.sin(angleToCenter + math.pi),
          );
        }
      } else {
        // Random position on sun's surface
        final angle = flareRandom.nextDouble() * 2 * math.pi;
        flareOrigin = Offset(
          center.dx + radius * 0.9 * math.cos(angle),
          center.dy + radius * 0.9 * math.sin(angle),
        );
      }

      // Animate flare emergence and fade
      double animatedLength;
      double animatedIntensity;

      if (flareProgress < 0.5) {
        // Phase 1: Slow emergence (0-50% of lifetime)
        final emergenceProgress = flareProgress / 0.5;
        // Use cubic easing for very gradual emergence
        final easeOut =
            emergenceProgress *
            emergenceProgress *
            (3.0 - 2.0 * emergenceProgress);
        animatedLength =
            easeOut * radius * (0.6 + flareRandom.nextDouble() * 0.8);
        animatedIntensity = easeOut * (0.8 + flareRandom.nextDouble() * 0.2);
      } else if (flareProgress < 0.8) {
        // Phase 2: Peak intensity (50-80% of lifetime)
        final peakProgress = (flareProgress - 0.5) / 0.3;
        final intensity =
            0.9 +
            math.sin(peakProgress * math.pi * 2) * 0.1; // Subtle fluctuation
        animatedLength = radius * (0.6 + flareRandom.nextDouble() * 0.8);
        animatedIntensity = intensity * (0.8 + flareRandom.nextDouble() * 0.2);
      } else {
        // Phase 3: Fade out (80-100% of lifetime)
        final fadeProgress = (flareProgress - 0.8) / 0.2;
        final fadeEase = math.cos(
          fadeProgress * math.pi * 0.5,
        ); // Ease in curve
        animatedLength =
            fadeEase * radius * (0.6 + flareRandom.nextDouble() * 0.8);
        animatedIntensity = fadeEase * (0.8 + flareRandom.nextDouble() * 0.2);
      }

      // Skip very faded flares
      if (animatedIntensity < 0.1) continue;

      // Calculate flare properties
      final flareWidth = radius * (0.03 + flareRandom.nextDouble() * 0.05);

      // Determine flare type: 40% chance of horseshoe loop, 60% chance of outward arch
      final isHorseshoeLoop = flareRandom.nextDouble() < 0.4;

      // Calculate flare direction (outward from sun center with slight variation)
      final angleToCenter = math.atan2(
        flareOrigin.dy - center.dy,
        flareOrigin.dx - center.dx,
      );
      final outwardAngle =
          angleToCenter + (flareRandom.nextDouble() - 0.5) * 0.15;

      late Path path;

      if (isHorseshoeLoop) {
        // Create horseshoe-shaped magnetic field loop that returns to sun
        path = _createHorseshoeFlare(
          flareOrigin,
          center,
          radius,
          animatedLength,
          outwardAngle,
          flareRandom,
        );
      } else {
        // Create outward arching flare (existing behavior)
        final flareEndX =
            flareOrigin.dx + animatedLength * math.cos(outwardAngle);
        final flareEndY =
            flareOrigin.dy + animatedLength * math.sin(outwardAngle);
        final flareEnd = Offset(flareEndX, flareEndY);

        path = _createArchingFlare(
          flareOrigin,
          flareEnd,
          animatedLength,
          outwardAngle,
          flareRandom,
        );
      }

      // Create gradient with animated intensity
      final flareGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.coronaYellow.withValues(
            alpha: animatedIntensity * RenderingConstants.sunFlareAlphaCenter,
          ),
          AppColors.coronaOrange.withValues(
            alpha: animatedIntensity * RenderingConstants.sunFlareAlphaMid,
          ),
          AppColors.accretionDiskRed.withValues(
            alpha: animatedIntensity * RenderingConstants.sunFlareAlphaEdge,
          ),
          AppColors.transparentColor,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      );

      // Calculate gradient bounds based on flare path
      final pathBounds = path.getBounds();
      final gradientBounds = pathBounds.isEmpty
          ? Rect.fromCircle(center: flareOrigin, radius: animatedLength)
          : pathBounds;

      // Draw main flare body
      final flarePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = flareWidth
        ..strokeCap = StrokeCap.round
        ..shader = flareGradient.createShader(gradientBounds);

      canvas.drawPath(path, flarePaint);

      // Add bright core line
      final corePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = flareWidth * 0.3
        ..strokeCap = StrokeCap.round
        ..color = AppColors.starGlowWhite.withValues(
          alpha: animatedIntensity * RenderingConstants.sunFlareBaseAlpha,
        );

      canvas.drawPath(path, corePaint);

      // Add glow effect
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = flareWidth * 1.5
        ..strokeCap = StrokeCap.round
        ..color = AppColors.coronaYellow.withValues(
          alpha: animatedIntensity * RenderingConstants.sunFlareRingAlpha,
        );

      canvas.drawPath(path, glowPaint);
    }
  }

  /// Create a horseshoe-shaped solar flare that loops back to the sun
  static Path _createHorseshoeFlare(
    Offset flareOrigin,
    Offset sunCenter,
    double sunRadius,
    double flareLength,
    double outwardAngle,
    math.Random random,
  ) {
    final path = Path();
    path.moveTo(flareOrigin.dx, flareOrigin.dy);

    // Calculate the arch height for the loop (higher than regular arches)
    final archHeight =
        flareLength * (0.5 + random.nextDouble() * 0.4); // 50-90% of length

    // Find a secondary point on the sun's surface for the flare to reconnect
    // Offset from the original angle to create loop span
    final loopSpanAngle =
        (0.3 + random.nextDouble() * 0.6) *
        (random.nextBool() ? 1 : -1); // 0.3-0.9 radians span
    final reconnectAngle = outwardAngle + loopSpanAngle;
    final reconnectPoint = Offset(
      sunCenter.dx + sunRadius * 0.9 * math.cos(reconnectAngle),
      sunCenter.dy + sunRadius * 0.9 * math.sin(reconnectAngle),
    );

    // Calculate the magnetic field loop using complex curve
    final directionX = math.cos(outwardAngle);
    final directionY = math.sin(outwardAngle);
    final perpAngle = outwardAngle + math.pi * 0.5;

    // First control point: rise from surface
    final ctrl1X =
        flareOrigin.dx +
        (flareLength * 0.4) * directionX +
        archHeight * 0.6 * math.cos(perpAngle);
    final ctrl1Y =
        flareOrigin.dy +
        (flareLength * 0.4) * directionY +
        archHeight * 0.6 * math.sin(perpAngle);

    // Second control point: peak of the arch
    final midX = (flareOrigin.dx + reconnectPoint.dx) * 0.5;
    final midY = (flareOrigin.dy + reconnectPoint.dy) * 0.5;
    final ctrl2X = midX + archHeight * math.cos(perpAngle);
    final ctrl2Y = midY + archHeight * math.sin(perpAngle);

    // Third control point: descent toward reconnection
    final reconnectDirectionX = math.cos(
      reconnectAngle + math.pi,
    ); // Inward direction
    final reconnectDirectionY = math.sin(reconnectAngle + math.pi);
    final ctrl3X =
        reconnectPoint.dx +
        (flareLength * 0.4) * reconnectDirectionX +
        archHeight * 0.6 * math.cos(perpAngle);
    final ctrl3Y =
        reconnectPoint.dy +
        (flareLength * 0.4) * reconnectDirectionY +
        archHeight * 0.6 * math.sin(perpAngle);

    // Create smooth horseshoe curve using multiple cubic segments
    path.cubicTo(
      ctrl1X,
      ctrl1Y,
      ctrl2X,
      ctrl2Y,
      midX + archHeight * 0.5 * math.cos(perpAngle),
      midY + archHeight * 0.5 * math.sin(perpAngle),
    );
    path.cubicTo(
      ctrl2X,
      ctrl2Y,
      ctrl3X,
      ctrl3Y,
      reconnectPoint.dx,
      reconnectPoint.dy,
    );

    return path;
  }

  /// Create an arching solar flare that extends outward
  static Path _createArchingFlare(
    Offset flareOrigin,
    Offset flareEnd,
    double flareLength,
    double outwardAngle,
    math.Random random,
  ) {
    final path = Path();
    path.moveTo(flareOrigin.dx, flareOrigin.dy);

    // Calculate arch height based on flare length
    final archHeight =
        flareLength * (0.3 + random.nextDouble() * 0.4); // 30-70% of length

    // Create realistic magnetic field arch
    final directionX = math.cos(outwardAngle);
    final directionY = math.sin(outwardAngle);

    // Calculate arch control points for a dramatic curve
    final perpAngle = outwardAngle + math.pi * 0.5; // 90 degrees from outward
    final archMidX =
        flareOrigin.dx +
        (flareLength * 0.6) * directionX +
        archHeight * math.cos(perpAngle);
    final archMidY =
        flareOrigin.dy +
        (flareLength * 0.6) * directionY +
        archHeight * math.sin(perpAngle);

    // Second control point: curve back toward the original direction
    final archEndX =
        flareOrigin.dx +
        (flareLength * 0.9) * directionX +
        archHeight * 0.5 * math.cos(perpAngle);
    final archEndY =
        flareOrigin.dy +
        (flareLength * 0.9) * directionY +
        archHeight * 0.5 * math.sin(perpAngle);

    // Create a cubic bezier curve for smooth magnetic field arch
    path.cubicTo(
      archMidX,
      archMidY, // First control point (peak of arch)
      archEndX,
      archEndY, // Second control point (arch descent)
      flareEnd.dx,
      flareEnd.dy, // End point
    );

    return path;
  }

  /// Draw Mercury with crater-like surface
  static void drawMercury(Canvas canvas, Offset center, double radius) {
    // Base planet
    final mercuryGlow = RadialGradient(
      colors: [
        AppColors.moonLightGray, // Light gray center
        AppColors.moonBrownGray, // Brown-gray edge
      ],
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = mercuryGlow.createShader(rect),
    );

    // Crater details
    final craterPaint = Paint()
      ..color = AppColors.moonShadow.withValues(
        alpha: AppTypography.opacityHigh,
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
      radius * 0.2,
      craterPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy + radius * 0.3),
      radius * 0.15,
      craterPaint,
    );
  }

  /// Draw Venus with thick atmosphere
  static void drawVenus(Canvas canvas, Offset center, double radius) {
    // Thick atmosphere glow
    final atmosphereGlow = RadialGradient(
      colors: [
        AppColors.venusYellow.withValues(
          alpha: AppTypography.opacityMediumHigh,
        ), // Bright center
        AppColors.venusOrangeMiddle.withValues(
          alpha: AppTypography.opacitySemiTransparent,
        ), // Orange middle
        AppColors.venusOuterGlow.withValues(
          alpha: AppTypography.opacityVeryFaint,
        ), // Outer glow
        AppColors.transparentColor,
      ],
    );

    final atmosphereRect = Rect.fromCircle(
      center: center,
      radius: radius * 2.0,
    );
    canvas.drawCircle(
      center,
      radius * 2.0,
      Paint()..shader = atmosphereGlow.createShader(atmosphereRect),
    );

    // Planet surface
    final surfaceGlow = RadialGradient(
      colors: [
        AppColors.venusCreamCenter, // Light cream center
        AppColors.venusGoldenEdge, // Golden yellow edge
      ],
    );

    final surfaceRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = surfaceGlow.createShader(surfaceRect),
    );
  }

  /// Draw Earth with continents and atmosphere
  static void drawEarth(Canvas canvas, Offset center, double radius) {
    // Thin blue atmosphere
    final atmosphereGlow = RadialGradient(
      colors: [
        AppColors.earthSkyBlue.withValues(
          alpha: AppTypography.opacityFaint,
        ), // Sky blue
        AppColors.transparentColor,
      ],
    );

    final atmosphereRect = Rect.fromCircle(
      center: center,
      radius: radius * 1.5,
    );
    canvas.drawCircle(
      center,
      radius * 1.5,
      Paint()..shader = atmosphereGlow.createShader(atmosphereRect),
    );

    // Ocean base
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = AppColors.earthDeepBlue,
    ); // Deep blue

    // Continental masses
    final continentPaint = Paint()
      ..color = AppColors.earthGreen
      ..style = PaintingStyle.fill;

    // Simple continent shapes
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5,
      1.2,
      true,
      continentPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.8),
      1.8,
      0.8,
      true,
      continentPaint,
    );
  }

  /// Draw Mars with polar ice caps
  static void drawMars(Canvas canvas, Offset center, double radius) {
    // Thin atmosphere
    final atmosphereGlow = RadialGradient(
      colors: [
        AppColors.marsFaintRed.withValues(
          alpha: AppTypography.opacityVeryFaint,
        ), // Faint red
        AppColors.transparentColor,
      ],
    );

    final atmosphereRect = Rect.fromCircle(
      center: center,
      radius: radius * 1.3,
    );
    canvas.drawCircle(
      center,
      radius * 1.3,
      Paint()..shader = atmosphereGlow.createShader(atmosphereRect),
    );

    // Planet surface
    final surfaceGlow = RadialGradient(
      colors: [
        AppColors.marsBrightRed, // Bright red center
        AppColors.marsMediumRed, // Medium red edge
      ],
    );

    final surfaceRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = surfaceGlow.createShader(surfaceRect),
    );

    // Polar ice caps
    final icePaint = Paint()
      ..color = AppColors.marsIceWhite.withValues(
        alpha: AppTypography.opacityVeryHigh,
      );
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.7),
      radius * 0.3,
      icePaint,
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy + radius * 0.7),
      radius * 0.25,
      icePaint,
    );
  }

  /// Draw Jupiter with Great Red Spot and bands
  static void drawJupiter(Canvas canvas, Offset center, double radius) {
    // Gas giant glow
    final giantGlow = RadialGradient(
      colors: [
        AppColors.jupiterCreamCenter.withValues(
          alpha: AppTypography.opacityVeryHigh,
        ), // Cream center
        AppColors.jupiterGoldEdge.withValues(
          alpha: AppTypography.opacitySemiTransparent,
        ), // Gold edge
        AppColors.transparentColor,
      ],
    );

    final glowRect = Rect.fromCircle(center: center, radius: radius * 2.0);
    canvas.drawCircle(
      center,
      radius * 2.0,
      Paint()..shader = giantGlow.createShader(glowRect),
    );

    // Planet base
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = AppColors.jupiterSurface,
    );

    // Atmospheric bands
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;

    bandPaint.color = AppColors.jupiterBandGold.withValues(
      alpha: AppTypography.opacityHigh,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      0,
      6.28,
      false,
      bandPaint,
    );

    bandPaint.color = AppColors.jupiterBandBrown.withValues(
      alpha: AppTypography.opacityMedium,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.8),
      0,
      6.28,
      false,
      bandPaint,
    );

    // Great Red Spot
    final redSpotPaint = Paint()
      ..color = AppColors.jupiterRedSpot.withValues(
        alpha: AppTypography.opacityVeryHigh,
      );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.3, center.dy),
        width: radius * 0.4,
        height: radius * 0.2,
      ),
      redSpotPaint,
    );
  }

  /// Draw Saturn with prominent rings (with correct inclination)
  static void drawSaturn(
    Canvas canvas,
    Offset center,
    double radius,
    Body body, {
    vm.Matrix4? viewMatrix,
    Size? canvasSize,
  }) {
    // Planet base with realistic Saturn colors
    final saturnGlow = RadialGradient(
      colors: [
        AppColors.saturnCreamCenter, // Light cream center
        AppColors.saturnGoldenMiddle, // Golden yellow middle
        AppColors.saturnBurlywoodEdge, // Burlywood edge
      ],
    );

    final planetRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = saturnGlow.createShader(planetRect),
    );

    // Add subtle bands to Saturn's atmosphere
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..color = AppColors.saturnRingColor.withValues(
        alpha: AppTypography.opacityFaint,
      );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.6),
      0,
      6.28,
      false,
      bandPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.8),
      0,
      6.28,
      false,
      bandPaint,
    );

    // Draw beautiful 3D inclined ring system if we have the view matrix
    if (viewMatrix != null && canvasSize != null) {
      _drawSaturnRings(
        canvas,
        center,
        radius,
        body.position,
        viewMatrix,
        canvasSize,
      );
    } else {
      // Fallback to beautiful circular rings
      _drawSaturnRingsFallback(canvas, center, radius);
    }
  }

  /// Draw Uranus tilted with beautiful faint rings (with correct inclination)
  static void drawUranus(
    Canvas canvas,
    Offset center,
    double radius,
    Body body, {
    vm.Matrix4? viewMatrix,
    Size? canvasSize,
  }) {
    // Ice giant glow with realistic Uranus colors
    final uranusGlow = RadialGradient(
      colors: [
        AppColors.uranusCyanCenter, // Light cyan center
        AppColors.uranusCyanMiddle, // Cyan middle
        AppColors.uranusTurquoiseEdge, // Turquoise edge
      ],
    );

    final planetRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = uranusGlow.createShader(planetRect),
    );

    // Draw beautiful 3D inclined ring system if we have the view matrix
    if (viewMatrix != null && canvasSize != null) {
      _drawUranusRings(
        canvas,
        center,
        radius,
        body.position,
        viewMatrix,
        canvasSize,
      );
    } else {
      // Fallback to beautiful vertical rings
      _drawUranusRingsFallback(canvas, center, radius);
    }
  }

  /// Draw Neptune with great dark spot
  static void drawNeptune(Canvas canvas, Offset center, double radius) {
    // Deep blue glow
    final neptuneGlow = RadialGradient(
      colors: [
        AppColors.neptuneCornflowerCenter, // Cornflower blue center
        AppColors.neptuneDeepBlueEdge, // Deep blue edge
      ],
    );

    final planetRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = neptuneGlow.createShader(planetRect),
    );

    // Great Dark Spot
    final darkSpotPaint = Paint()
      ..color = AppColors.neptuneDarkSpot.withValues(
        alpha: AppTypography.opacityHigh,
      );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.2, center.dy + radius * 0.1),
        width: radius * 0.3,
        height: radius * 0.2,
      ),
      darkSpotPaint,
    );

    // Atmospheric bands
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..color = AppColors.neptuneWindBand.withValues(
        alpha: AppTypography.opacityMedium,
      );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      0,
      6.28,
      false,
      bandPaint,
    );
  }

  /// Draw Saturn's beautiful ring system in 3D
  static void _drawSaturnRings(
    Canvas canvas,
    Offset center,
    double radius,
    vm.Vector3 bodyPosition,
    vm.Matrix4 viewMatrix,
    Size canvasSize,
  ) {
    // Saturn's ring system with REALISTIC proportions
    // Real Saturn rings are much closer to the planet than currently shown
    final ringData = [
      // [innerRadius, outerRadius, color, opacity] - CORRECTED realistic proportions
      [
        1.11,
        1.16,
        AppColors.saturnDRing,
        0.3,
      ], // D Ring - Very close inner ring
      [1.23, 1.45, AppColors.saturnCRing, 0.5], // C Ring - Crepe ring
      [
        1.53,
        1.88,
        AppColors.saturnBRing,
        0.9,
      ], // B Ring - Main bright ring (much closer)
      // Cassini Division gap here (1.88 - 1.95)
      [
        1.95,
        2.27,
        AppColors.saturnARing,
        0.8,
      ], // A Ring - Outer main ring (closer)
      [
        2.27,
        2.32,
        AppColors.saturnFRing,
        0.4,
      ], // F Ring - Very narrow shepherd ring
    ];

    const int numPoints = 128; // High detail for smooth rings
    final inclinationRadians =
        26.7 * math.pi / 180.0; // Saturn's ring inclination

    for (final ring in ringData) {
      final innerRadius = radius * (ring[0] as double);
      final outerRadius = radius * (ring[1] as double);
      final color = ring[2] as Color;
      final opacity = ring[3] as double;

      // Create filled ring band by drawing many triangular segments
      final innerPoints = <Offset>[];
      final outerPoints = <Offset>[];

      // Generate inner and outer ring edge points
      for (int i = 0; i <= numPoints; i++) {
        final angle = (i / numPoints) * 2 * math.pi;

        // Inner ring edge
        final innerLocalX = innerRadius * math.cos(angle);
        final innerLocalZ = innerRadius * math.sin(angle);
        final innerRotatedY = innerLocalZ * math.sin(inclinationRadians);
        final innerRotatedZ = innerLocalZ * math.cos(inclinationRadians);
        final innerWorldPos = vm.Vector3(
          bodyPosition.x + innerLocalX,
          bodyPosition.y + innerRotatedY,
          bodyPosition.z + innerRotatedZ,
        );

        final innerScreenPos = PainterUtils.project(
          viewMatrix,
          innerWorldPos,
          canvasSize,
        );

        // Outer ring edge
        final outerLocalX = outerRadius * math.cos(angle);
        final outerLocalZ = outerRadius * math.sin(angle);
        final outerRotatedY = outerLocalZ * math.sin(inclinationRadians);
        final outerRotatedZ = outerLocalZ * math.cos(inclinationRadians);
        final outerWorldPos = vm.Vector3(
          bodyPosition.x + outerLocalX,
          bodyPosition.y + outerRotatedY,
          bodyPosition.z + outerRotatedZ,
        );
        final outerScreenPos = PainterUtils.project(
          viewMatrix,
          outerWorldPos,
          canvasSize,
        );

        if (innerScreenPos != null && outerScreenPos != null) {
          innerPoints.add(innerScreenPos);
          outerPoints.add(outerScreenPos);
        }
      }

      // Draw filled ring band using triangular strips
      if (innerPoints.length > 2 && outerPoints.length > 2) {
        final ringPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = color.withValues(alpha: opacity);

        // Create path for filled ring band
        final path = Path();

        // Start from first inner point
        path.moveTo(innerPoints[0].dx, innerPoints[0].dy);

        // Add all inner points
        for (int i = 1; i < innerPoints.length; i++) {
          path.lineTo(innerPoints[i].dx, innerPoints[i].dy);
        }

        // Connect to outer ring (in reverse order for proper fill)
        for (int i = outerPoints.length - 1; i >= 0; i--) {
          path.lineTo(outerPoints[i].dx, outerPoints[i].dy);
        }

        // Close the path
        path.close();

        canvas.drawPath(path, ringPaint);

        // Add subtle ring texture with lighter streaks
        // Only draw texture lines when not zoomed in too close to avoid visual artifacts
        final avgInnerDistance = _calculateAverageDistanceFromCenter(
          innerPoints,
          canvasSize,
        );

        if (avgInnerDistance > RenderingConstants.ringTextureMinDistance) {
          // Only draw texture when ring is not too close to camera
          final texturePaint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = RenderingConstants.ringTextureStrokeWidth
            ..color = color.withValues(
              alpha: opacity * RenderingConstants.ringTextureAlpha,
            );

          // Draw some radial texture lines for ring particle effect
          for (int i = 0; i < numPoints; i += 8) {
            if (i < innerPoints.length && i < outerPoints.length) {
              canvas.drawLine(innerPoints[i], outerPoints[i], texturePaint);
            }
          }
        }
      }
    }
  }

  /// Draw Saturn's beautiful ring system fallback (2D)
  static void _drawSaturnRingsFallback(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    // Saturn's ring system with REALISTIC proportions - rings much closer to planet
    final ringData = [
      // [innerRadius, outerRadius, color, opacity] - CORRECTED realistic proportions
      [1.11, 1.16, AppColors.saturnDRing, 0.3], // D Ring
      [1.23, 1.45, AppColors.saturnCRing, 0.5], // C Ring
      [
        1.53,
        1.88,
        AppColors.saturnBRing,
        0.9,
      ], // B Ring (main ring much closer)
      // Cassini Division gap (1.88 - 1.95)
      [1.95, 2.27, AppColors.saturnARing, 0.8], // A Ring (closer)
      [2.27, 2.32, AppColors.saturnFRing, 0.4], // F Ring (very narrow)
    ];

    for (final ring in ringData) {
      final innerRadius = radius * (ring[0] as double);
      final outerRadius = radius * (ring[1] as double);
      final color = ring[2] as Color;
      final opacity = ring[3] as double;

      // Draw filled ring band
      final ringPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: opacity);

      // Create ring band as annular shape (ring between two circles)
      final path = Path();

      // Outer circle
      path.addOval(Rect.fromCircle(center: center, radius: outerRadius));

      // Inner circle (subtract from outer to create ring)
      path.addOval(Rect.fromCircle(center: center, radius: innerRadius));
      path.fillType = PathFillType.evenOdd; // This creates the ring hole

      canvas.drawPath(path, ringPaint);

      // Add ring texture with radial lines
      // Only draw texture lines when not zoomed in too close to avoid visual artifacts
      if (radius < RenderingConstants.ringTextureMaxRadius) {
        // Only draw texture when Saturn is not too large on screen
        final texturePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = RenderingConstants.ringTextureStrokeWidth
          ..color = color.withValues(
            alpha: opacity * RenderingConstants.ringGlowAlpha,
          );

        const int textureLines = 32;
        for (int i = 0; i < textureLines; i++) {
          final angle = (i / textureLines) * 2 * math.pi;
          final innerX = center.dx + innerRadius * math.cos(angle);
          final innerY = center.dy + innerRadius * math.sin(angle);
          final outerX = center.dx + outerRadius * math.cos(angle);
          final outerY = center.dy + outerRadius * math.sin(angle);

          canvas.drawLine(
            Offset(innerX, innerY),
            Offset(outerX, outerY),
            texturePaint,
          );
        }
      }
    }
  }

  /// Draw Uranus's enhanced ring system in 3D
  static void _drawUranusRings(
    Canvas canvas,
    Offset center,
    double radius,
    vm.Vector3 bodyPosition,
    vm.Matrix4 viewMatrix,
    Size canvasSize,
  ) {
    // Uranus's very narrow, dark ring system - discovered in 1977
    // Just a few thin, dark rings - much simpler than Saturn's
    final ringData = [
      // [radius, strokeWidth, opacity] - just simple thin lines
      [1.6, 0.8, 0.15], // Inner ring group
      [1.9, 1.0, 0.20], // Middle ring
      [2.3, 1.2, 0.25], // Epsilon ring (main ring)
    ];

    const int numPoints = 48; // Fewer points needed for simple rings
    final inclinationRadians =
        97.8 * math.pi / 180.0; // Uranus is tilted on its side!

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.genericDarkGray; // Dark gray

    for (final ring in ringData) {
      final ringRadius = radius * ring[0];
      final strokeWidth = ring[1];
      final opacity = ring[2];

      ringPaint.strokeWidth = strokeWidth;
      ringPaint.color = AppColors.genericDarkGray.withValues(alpha: opacity);

      final ringPoints = <Offset>[];

      // Generate ring points
      for (int i = 0; i <= numPoints; i++) {
        final angle = (i / numPoints) * 2 * math.pi;

        final localX = ringRadius * math.cos(angle);
        final localZ = ringRadius * math.sin(angle);
        final rotatedY = localZ * math.sin(inclinationRadians);
        final rotatedZ = localZ * math.cos(inclinationRadians);

        final worldPos = vm.Vector3(
          bodyPosition.x + localX,
          bodyPosition.y + rotatedY,
          bodyPosition.z + rotatedZ,
        );
        final screenPos = PainterUtils.project(
          viewMatrix,
          worldPos,
          canvasSize,
        );
        if (screenPos != null) {
          ringPoints.add(screenPos);
        }
      }

      // Draw simple ring as connected line segments
      if (ringPoints.length > 2) {
        for (int i = 0; i < ringPoints.length - 1; i++) {
          canvas.drawLine(ringPoints[i], ringPoints[i + 1], ringPaint);
        }
      }
    }
  }

  /// Draw Uranus's simple ring system fallback (2D)
  static void _drawUranusRingsFallback(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    // Uranus's very narrow, dark ring system - simple fallback version
    // Just a few thin, dark rings to match astronomical reality
    final ringData = [
      // [radius, strokeWidth, opacity] - just simple thin lines
      [1.6, 0.8, 0.15], // Inner ring group
      [1.9, 1.0, 0.20], // Middle ring
      [2.3, 1.2, 0.25], // Epsilon ring (main ring)
    ];

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.genericDarkGray; // Dark gray

    for (final ring in ringData) {
      final ringRadius = radius * ring[0];
      final strokeWidth = ring[1];
      final opacity = ring[2];

      ringPaint.strokeWidth = strokeWidth;
      ringPaint.color = AppColors.genericDarkGray.withValues(alpha: opacity);

      // Draw simple ellipse ring (vertical orientation for Uranus)
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: ringRadius * 0.4, // Compressed horizontally
          height: ringRadius * 2.0, // Extended vertically (Uranus is tilted)
        ),
        ringPaint,
      );
    }
  }

  /// Helper method to draw atmospheric halo effects around planets
  ///
  /// Creates a radial gradient halo simulating atmospheric scattering and haze.
  /// The effect intensity and color can be customized based on the planet's
  /// atmospheric characteristics.
  ///
  /// Parameters:
  /// - [canvas]: The canvas to draw on
  /// - [center]: Center point of the planet
  /// - [radius]: Base radius of the planet body
  /// - [baseColor]: Primary color of the planet for halo tinting
  /// - [hazeIntensity]: Controls opacity and extent of atmospheric haze (0.0-1.0)
  /// - [atmosphericColor]: Optional color for atmospheric scattering effects
  ///   (e.g., blue for Earth's Rayleigh scattering)
  static void _drawAtmosphericHalo(
    Canvas canvas,
    Offset center,
    double radius,
    Color baseColor, {
    double hazeIntensity = RenderingConstants.atmosphericHazeDefaultIntensity,
    Color? atmosphericColor,
  }) {
    // Use atmospheric color if provided, otherwise use base color
    final hazeColor = atmosphericColor ?? baseColor;

    // Create gradient that fades from haze color to transparent
    // Extend halo beyond planet radius based on intensity
    final hazeExtent =
        RenderingConstants.atmosphericHazeBaseExtent +
        (hazeIntensity *
            RenderingConstants
                .atmosphericHazeIntensityMultiplier); // 1.0x to 1.5x radius
    final hazeGlow = RadialGradient(
      colors: [
        hazeColor.withValues(
          alpha: AppTypography.opacityMedium * hazeIntensity,
        ), // Inner haze
        hazeColor.withValues(
          alpha: AppTypography.opacityLowMedium * hazeIntensity,
        ), // Middle fade
        hazeColor.withValues(
          alpha: AppTypography.opacityFaint * hazeIntensity,
        ), // Outer edge
        AppColors.transparentColor, // Fully transparent at edge
      ],
      stops: RenderingConstants
          .atmosphericHazeStops, // Concentrate effect near planet
    );

    final hazeRect = Rect.fromCircle(
      center: center,
      radius: radius * hazeExtent,
    );
    canvas.drawCircle(
      center,
      radius * hazeExtent,
      Paint()..shader = hazeGlow.createShader(hazeRect),
    );
  }

  /// Draw relativistic glow effect based on time dilation
  ///
  /// Bodies moving at high velocities experience time dilation (γ < 1.0).
  /// This renders a velocity-based blue-shifted glow that intensifies with
  /// higher velocities, visualizing the relativistic effects.
  ///
  /// Parameters:
  /// - [canvas]: The canvas to draw on
  /// - [center]: Center position of the body
  /// - [radius]: Radius of the body
  /// - [timeDilationFactor]: Time dilation factor (γ), ranges from 0.0 (light speed) to 1.0 (stationary)
  /// - [bodyColor]: Base color of the body
  static void _drawRelativisticGlow(
    Canvas canvas,
    Offset center,
    double radius,
    double timeDilationFactor,
    Color bodyColor,
  ) {
    // Calculate glow intensity based on time dilation
    // Lower γ (higher velocity) = brighter glow
    // γ = 1.0 (stationary) → intensity = 0.0 (no glow)
    // γ = 0.0 (light speed) → intensity = 1.0 (maximum glow)
    final glowIntensity = 1.0 - timeDilationFactor;

    // Only render if significant relativistic effects present
    if (glowIntensity < RenderingConstants.minimumRelativisticGlowThreshold) {
      return;
    }

    // Blue-shift color for relativistic glow (approaching light speed appears blue-shifted)
    final relativisticColor = Color.lerp(
      AppColors.relativisticBlue,
      AppColors.relativisticWhite,
      glowIntensity * RenderingConstants.relativisticColorBlendRatio,
    )!;

    // Create multi-layered glow effect
    // Outer glow layer (faint, extended)
    final outerGlowRadius =
        radius *
        (RenderingConstants.relativisticOuterGlowRadiusBase +
            glowIntensity *
                RenderingConstants.relativisticOuterGlowRadiusIntensityScale);
    final outerGlow = RadialGradient(
      colors: [
        relativisticColor.withValues(alpha: glowIntensity * 0.3),
        relativisticColor.withValues(alpha: glowIntensity * 0.15),
        AppColors.transparentColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final outerRect = Rect.fromCircle(center: center, radius: outerGlowRadius);
    canvas.drawCircle(
      center,
      outerGlowRadius,
      Paint()..shader = outerGlow.createShader(outerRect),
    );

    // Inner glow layer (intense, compact)
    final innerGlowRadius = radius * (1.3 + glowIntensity * 0.4);
    final innerGlow = RadialGradient(
      colors: [
        relativisticColor.withValues(alpha: glowIntensity * 0.6),
        relativisticColor.withValues(alpha: glowIntensity * 0.4),
        AppColors.transparentColor,
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final innerRect = Rect.fromCircle(center: center, radius: innerGlowRadius);
    canvas.drawCircle(
      center,
      innerGlowRadius,
      Paint()..shader = innerGlow.createShader(innerRect),
    );
  }

  /// Draw tidal deformation and stress visualization
  ///
  /// Visualizes tidal forces acting on a body by rendering:
  /// 1. Elliptical deformation along major/minor tidal axes
  /// 2. Color-coded stress magnitude (from base color to red/orange)
  /// 3. Directional lines showing tidal axis orientation
  ///
  /// Parameters:
  /// - [canvas]: The canvas to draw on
  /// - [center]: Center position of the body
  /// - [radius]: Base radius of the body
  /// - [body]: Body object containing tidal force data
  /// - [bodyColor]: Base color of the body
  static void _drawTidalVisualization(
    Canvas canvas,
    Offset center,
    double radius,
    Body body,
    Color bodyColor,
  ) {
    if (body.tidalStress < RenderingConstants.minimumTidalStressThreshold) {
      return;
    }

    // Calculate stress intensity (normalized)
    // tidalStress can range from 0 to very large values
    // Normalize to 0.0-1.0 range for visualization
    final stressIntensity = math.min(
      body.tidalStress / RenderingConstants.tidalStressNormalizationFactor,
      1.0,
    );

    // Color-code based on tidal stress magnitude
    // Low stress: base color → Medium stress: orange → High stress: red
    final stressColor = Color.lerp(
      Color.lerp(
        bodyColor,
        AppColors.tidalStressOrange,
        stressIntensity * RenderingConstants.tidalStressMediumBlendRatio,
      )!,
      AppColors.tidalStressRed,
      stressIntensity * RenderingConstants.tidalStressHighBlendRatio,
    )!;

    // Draw stress color overlay
    final stressGlow = RadialGradient(
      colors: [
        stressColor.withValues(alpha: stressIntensity * 0.4),
        stressColor.withValues(alpha: stressIntensity * 0.2),
        AppColors.transparentColor,
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    final stressRect = Rect.fromCircle(center: center, radius: radius * 1.5);
    canvas.drawCircle(
      center,
      radius * 1.5,
      Paint()..shader = stressGlow.createShader(stressRect),
    );

    // Draw tidal deformation axes if they exist
    if (body.tidalAxisMajor.length >
            RenderingConstants.minimumTidalStressThreshold &&
        body.tidalAxisMinor.length >
            RenderingConstants.minimumTidalStressThreshold) {
      // Scale axes for visualization (exaggerate deformation for visibility)
      final majorLength = radius * (1.0 + stressIntensity * 0.3);
      final minorLength = radius * (1.0 - stressIntensity * 0.15);

      // Calculate axis endpoints
      final majorAxis = body.tidalAxisMajor.normalized();
      final minorAxis = body.tidalAxisMinor.normalized();

      final majorEnd1 =
          center + Offset(majorAxis.x * majorLength, majorAxis.y * majorLength);
      final majorEnd2 =
          center - Offset(majorAxis.x * majorLength, majorAxis.y * majorLength);
      final minorEnd1 =
          center + Offset(minorAxis.x * minorLength, minorAxis.y * minorLength);
      final minorEnd2 =
          center - Offset(minorAxis.x * minorLength, minorAxis.y * minorLength);

      // Draw tidal axis lines
      final axisPaint = Paint()
        ..color = stressColor.withValues(alpha: stressIntensity * 0.7)
        ..strokeWidth = AppTypography.spacingXXSmall
        ..style = PaintingStyle.stroke;

      // Major axis (direction of maximum tidal stretch)
      canvas.drawLine(majorEnd1, majorEnd2, axisPaint);

      // Minor axis (direction of maximum tidal compression)
      axisPaint.strokeWidth = AppTypography.spacingXXSmall * 0.7;
      canvas.drawLine(minorEnd1, minorEnd2, axisPaint);

      // Draw arrowheads on major axis to show direction
      _drawArrowhead(canvas, majorEnd1, majorAxis, axisPaint, radius * 0.15);
      _drawArrowhead(canvas, majorEnd2, -majorAxis, axisPaint, radius * 0.15);
    }
  }

  /// Draw an arrowhead at the given position pointing in the given direction
  static void _drawArrowhead(
    Canvas canvas,
    Offset position,
    vm.Vector3 direction,
    Paint paint,
    double size,
  ) {
    // Calculate perpendicular vector for arrowhead wings
    final perpendicular = vm.Vector3(
      -direction.y,
      direction.x,
      0.0,
    ).normalized();

    // Arrow wing endpoints
    final wing1 =
        position -
        Offset(direction.x * size, direction.y * size) +
        Offset(perpendicular.x * size * 0.5, perpendicular.y * size * 0.5);
    final wing2 =
        position -
        Offset(direction.x * size, direction.y * size) -
        Offset(perpendicular.x * size * 0.5, perpendicular.y * size * 0.5);

    // Draw arrowhead
    final path = Path()
      ..moveTo(position.dx, position.dy)
      ..lineTo(wing1.dx, wing1.dy)
      ..moveTo(position.dx, position.dy)
      ..lineTo(wing2.dx, wing2.dy);

    canvas.drawPath(path, paint);
  }

  /// Determine atmospheric intensity for generic planets based on mass and characteristics
  ///
  /// Returns a value between 0.0 (no atmosphere) and 0.6 (thick atmosphere)
  /// based on planetary mass and type. This allows atmospheric effects to work
  /// for randomly generated planets and custom scenarios.
  static double _getAtmosphericIntensityForBody(Body body) {
    // No atmosphere for non-planets or bodies without planet flag
    if (body.bodyType != BodyType.planet || body.isPlanet != true) {
      return 0.0;
    }

    final mass = body.mass;

    // Small rocky planets (Mercury to Mars size): minimal atmosphere
    // Mass range: 1.0 - 2.0
    if (mass < SimulationConstants.earthLikePlanetMassMin) {
      return 0.1; // Thin/minimal atmosphere
    }

    // Earth-like planets: moderate atmosphere
    // Mass range: 2.0 - 4.0
    if (mass < SimulationConstants.superEarthMassMin) {
      return 0.3; // Earth-like atmosphere
    }

    // Super-Earth planets: thicker atmosphere due to higher gravity
    // Mass range: 4.0 - 7.0
    if (mass < 7.0) {
      return 0.4; // Thick atmosphere
    }

    // Large gas giants and ice giants: very thick atmosphere
    // Mass range: > 7.0
    return 0.5; // Very thick atmosphere (Jupiter/Saturn-like)
  }

  /// Helper method to calculate stellar temperature from mass
  static double _calculateStellarTemperature(double mass) {
    // Sun has mass ~10 units in our simulation, temperature ~5778K
    const sunMass = 10.0;
    const sunTemperature = 5778.0;

    // Mass-temperature relationship for main sequence stars
    final massRatio = mass / sunMass;

    if (massRatio > 1.5) {
      // High mass stars: stronger dependence
      return sunTemperature * math.pow(massRatio, 0.8);
    } else {
      // Lower mass stars: weaker dependence
      return sunTemperature * math.pow(massRatio, 0.5);
    }
  }

  /// Helper method to determine if a star should have sunspots based on temperature
  static bool _shouldHaveSunspots(Body body) {
    if (body.bodyType != BodyType.star) return false;

    // Stars with magnetic activity (roughly F, G, K, M types)
    // Very hot stars (O, B, A types > 7500K) have different magnetic field structures
    final temperature =
        body.temperature >
            SimulationConstants
                .meaningfulStellarTemperatureThreshold // Has a meaningful stellar temperature
        ? body.temperature
        : _calculateStellarTemperature(body.mass);

    // Stars between 2000K and 7500K typically have convective zones that generate magnetic activity.
    // This temperature range corresponds to spectral types F, G, K, and M. Note: F, G, K stars have
    // partially convective exteriors similar to the Sun, while M-type stars (< 3700K) have fully
    // convective interiors with different magnetic field structures. This sunspot model is simplified
    // and most accurately represents solar-type (F, G, K) magnetic activity patterns.
    return temperature >= 2000.0 && temperature <= 7500.0;
  }

  /// Get corona color based on stellar temperature
  static Color _getCoronaColor(
    double temperature,
    bool useRealisticColors, {
    bool isOuter = false,
  }) {
    if (!useRealisticColors) {
      return isOuter
          ? AppColors.accretionDiskOrange
          : AppColors.accretionDiskGold;
    }

    // Adapt corona color to stellar temperature
    if (temperature > 6000) {
      // Hot stars (F, A, B, O types) - bluish corona
      return isOuter
          ? AppColors.stellarFType.withValues(
              alpha: AppTypography.opacityVeryHigh,
            )
          : AppColors.stellarAType;
    } else if (temperature > 5000) {
      // Sun-like stars (G type) - yellowish corona
      return isOuter
          ? AppColors.stellarGType.withValues(
              alpha: AppTypography.opacityVeryHigh,
            )
          : AppColors.coronaGold;
    } else if (temperature > 3500) {
      // Cool stars (K type) - orange corona
      return isOuter
          ? AppColors.stellarKType.withValues(
              alpha: AppTypography.opacityVeryHigh,
            )
          : AppColors.accretionDiskOrange;
    } else {
      // Very cool stars (M type) - reddish corona
      return isOuter
          ? AppColors.stellarMType.withValues(
              alpha: AppTypography.opacityVeryHigh,
            )
          : AppColors.accretionDiskRed;
    }
  }

  /// Get surface edge color based on stellar temperature
  static Color _getSurfaceEdgeColor(double temperature, Color baseColor) {
    // Create a slightly darker/cooler edge version of the base stellar color
    final hsv = HSVColor.fromColor(baseColor);
    final newSaturation = (hsv.saturation * 1.2).clamp(0.0, 1.0);
    final newValue = (hsv.value * 0.7).clamp(0.0, 1.0);
    return hsv.withValue(newValue).withSaturation(newSaturation).toColor();
  }

  /// Get sunspot penumbra color based on stellar temperature and surface color
  static Color _getSunspotPenumbraColor(
    double temperature,
    Color stellarColor,
  ) {
    // Sunspot penumbra should be a darker, cooler version of the stellar surface
    final hsv = HSVColor.fromColor(stellarColor);

    if (temperature > 6000) {
      // Hot stars (F, A, B, O types) - bluish penumbra
      final newValue = (hsv.value * 0.6).clamp(0.0, 1.0);
      final newSaturation = (hsv.saturation * 0.8).clamp(0.0, 1.0);
      return hsv.withValue(newValue).withSaturation(newSaturation).toColor();
    } else if (temperature > 5000) {
      // Sun-like stars (G type) - golden penumbra
      return AppColors.coronaGold.withValues(
        alpha: AppTypography.opacityVeryHigh,
      );
    } else if (temperature > 3500) {
      // Cool stars (K type) - orange penumbra
      return AppColors.coronaOrange.withValues(
        alpha: AppTypography.opacityVeryHigh,
      );
    } else {
      // Very cool stars (M type) - reddish penumbra
      final newValue = (hsv.value * 0.5).clamp(0.0, 1.0);
      final newHue = (hsv.hue + 10) % 360;
      return hsv.withValue(newValue).withHue(newHue).toColor();
    }
  }

  /// Get sunspot umbra color based on stellar temperature and surface color
  static Color _getSunspotUmbraColor(double temperature, Color stellarColor) {
    // Umbra should be much darker than penumbra but still reflect the star's basic character
    final hsv = HSVColor.fromColor(stellarColor);

    if (temperature > 6000) {
      // Hot stars - very dark blue-black umbra
      final newValue = (hsv.value * 0.15).clamp(0.0, 1.0);
      final newSaturation = (hsv.saturation * 0.5).clamp(0.0, 1.0);
      return hsv.withValue(newValue).withSaturation(newSaturation).toColor();
    } else if (temperature > 5000) {
      // Sun-like stars - black with slight golden tint
      return AppColors.uiBlack.withValues(
        alpha: AppTypography.opacityAlmostOpaque,
      );
    } else if (temperature > 3500) {
      // Cool stars - dark reddish-brown umbra
      final newValue = (hsv.value * 0.2).clamp(0.0, 1.0);
      final newHue = (hsv.hue + 15) % 360;
      return hsv.withValue(newValue).withHue(newHue).toColor();
    } else {
      // Very cool stars - very dark red umbra
      final newValue = (hsv.value * 0.1).clamp(0.0, 1.0);
      final newHue = (hsv.hue + 20) % 360;
      return hsv.withValue(newValue).withHue(newHue).toColor();
    }
  }

  /// Calculate hemisphere lighting gradient offset based on nearest light source
  ///
  /// For celestial bodies, the lit hemisphere faces toward the nearest star.
  /// This creates a more realistic appearance by shifting the radial gradient
  /// center toward the light source direction.
  ///
  /// Parameters:
  /// - [bodies]: All bodies in the simulation to find nearest star
  /// - [currentBody]: The body being rendered
  /// - [currentBodyPosition]: Current body's position in 2D canvas space
  ///
  /// Returns an [Offset] representing the gradient center offset from body center,
  /// or [Offset.zero] if no light source is found.
  ///
  /// Now uses blended lighting from multiple light sources for more realistic
  /// illumination in systems with multiple stars.
  static Offset _calculateHemisphereLightingOffset(
    List<Body> bodies,
    Body currentBody,
    Offset currentBodyPosition,
  ) {
    // Find all stars in the system
    final stars = bodies
        .where((body) => body != currentBody && body.bodyType == BodyType.star)
        .toList();

    // No stars found, return no offset
    if (stars.isEmpty) {
      return Offset.zero;
    }

    // Calculate blended lighting from multiple sources
    final blendedLight = _calculateBlendedLighting(currentBody, stars);

    // No significant light contribution
    if (blendedLight.intensity == 0.0) {
      return Offset.zero;
    }

    // Extract 2D direction from 3D light direction
    final normX = blendedLight.direction.x;
    final normY = blendedLight.direction.y;
    // Z component affects the offset magnitude (bodies facing toward/away from camera)

    // Project onto 2D canvas space (simplified projection)
    // The offset is a fraction of the body radius, controlled by gradient offset constant
    // Scale by intensity for realistic light falloff
    final offsetMagnitude =
        RenderingConstants.hemisphereLightingGradientOffset *
        blendedLight.intensity;

    return Offset(normX * offsetMagnitude, normY * offsetMagnitude);
  }

  /// Calculate and draw cast shadow on a body from another body blocking light
  ///
  /// Implements a simplified shadow model with umbra (full shadow) and penumbra
  /// (partial shadow) regions. Shadows are cast when a body is between a light
  /// source and the current body.
  ///
  /// Parameters:
  /// - [canvas]: The canvas to draw on
  /// - [center]: Center position of the body receiving the shadow
  /// - [radius]: Radius of the body receiving the shadow
  /// - [currentBody]: The body that may be in shadow
  /// - [allBodies]: All bodies in simulation to check for shadow casters
  static void drawCastShadow(
    Canvas canvas,
    Offset center,
    double radius,
    Body currentBody,
    List<Body> allBodies,
  ) {
    // Find all stars (light sources)
    final stars = allBodies.where((b) => b.bodyType == BodyType.star).toList();
    if (stars.isEmpty) {
      return; // No light sources, no shadows
    }

    for (final star in stars) {
      // Skip if star is too far (optimization)
      final starDistance = _calculate3DDistance(currentBody, star);
      if (starDistance == 0 ||
          starDistance > RenderingConstants.castShadowMaxDistance) {
        continue;
      }

      // Find bodies that could cast shadows on current body
      for (final caster in allBodies) {
        // Skip self, stars, and very small bodies
        if (caster == currentBody ||
            caster.bodyType == BodyType.star ||
            caster.radius < RenderingConstants.castShadowMinCasterRadius) {
          continue;
        }

        // Check if caster is between star and current body
        if (!_isBodyBlockingLight(star, caster, currentBody)) {
          continue;
        }

        // Calculate shadow parameters
        final shadowInfo = _calculateShadowGeometry(
          star,
          caster,
          currentBody,
          center,
          radius,
        );

        if (shadowInfo == null) {
          continue; // No shadow to draw
        }

        // Draw umbra (full shadow)
        if (shadowInfo.umbraRadius > 0) {
          final umbraGradient = RadialGradient(
            colors: [
              AppColors.uiBlack.withValues(
                alpha: RenderingConstants.castShadowUmbraAlpha,
              ),
              AppColors.uiBlack.withValues(alpha: 0.0),
            ],
            stops: const [
              RenderingConstants.castShadowUmbraGradientStart,
              RenderingConstants.castShadowUmbraGradientEnd,
            ],
          );

          final umbraRect = Rect.fromCircle(
            center: shadowInfo.shadowCenter,
            radius: shadowInfo.umbraRadius,
          );
          canvas.drawCircle(
            shadowInfo.shadowCenter,
            shadowInfo.umbraRadius,
            Paint()
              ..shader = umbraGradient.createShader(umbraRect)
              ..blendMode = BlendMode.multiply,
          );
        }

        // Draw penumbra (partial shadow)
        if (shadowInfo.penumbraRadius > shadowInfo.umbraRadius) {
          final penumbraGradient = RadialGradient(
            colors: [
              AppColors.uiBlack.withValues(
                alpha:
                    RenderingConstants.castShadowUmbraAlpha *
                    RenderingConstants.castShadowPenumbraIntensityRatio,
              ),
              AppColors.transparentColor,
            ],
          );

          final penumbraRect = Rect.fromCircle(
            center: shadowInfo.shadowCenter,
            radius: shadowInfo.penumbraRadius,
          );
          canvas.drawCircle(
            shadowInfo.shadowCenter,
            shadowInfo.penumbraRadius,
            Paint()
              ..shader = penumbraGradient.createShader(penumbraRect)
              ..blendMode = BlendMode.multiply,
          );
        }
      }
    }
  }

  /// Calculate 3D distance between two bodies
  static double _calculate3DDistance(Body body1, Body body2) {
    final dx = body2.position.x - body1.position.x;
    final dy = body2.position.y - body1.position.y;
    final dz = body2.position.z - body1.position.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }

  /// Check if a body is blocking light from a star to another body
  static bool _isBodyBlockingLight(Body star, Body caster, Body receiver) {
    // Calculate distances
    final starToCaster = _calculate3DDistance(star, caster);
    final starToReceiver = _calculate3DDistance(star, receiver);

    // Caster must be between star and receiver (closer to star)
    if (starToCaster >= starToReceiver) {
      return false;
    }

    // Calculate if caster is in the path using angular check
    // Vector from star to caster
    final starCasterX = caster.position.x - star.position.x;
    final starCasterY = caster.position.y - star.position.y;
    final starCasterZ = caster.position.z - star.position.z;

    // Vector from star to receiver
    final starReceiverX = receiver.position.x - star.position.x;
    final starReceiverY = receiver.position.y - star.position.y;
    final starReceiverZ = receiver.position.z - star.position.z;

    // Normalize vectors
    final starCasterDist = starToCaster;
    final starReceiverDist = starToReceiver;

    final normCasterX = starCasterX / starCasterDist;
    final normCasterY = starCasterY / starCasterDist;
    final normCasterZ = starCasterZ / starCasterDist;

    final normReceiverX = starReceiverX / starReceiverDist;
    final normReceiverY = starReceiverY / starReceiverDist;
    final normReceiverZ = starReceiverZ / starReceiverDist;

    // Calculate dot product (cosine of angle)
    final dotProduct =
        normCasterX * normReceiverX +
        normCasterY * normReceiverY +
        normCasterZ * normReceiverZ;

    // Bodies must be roughly aligned (small angle)
    return dotProduct > RenderingConstants.castShadowAlignmentThreshold;
  }

  /// Calculate shadow geometry on receiver body
  static ShadowInfo? _calculateShadowGeometry(
    Body star,
    Body caster,
    Body receiver,
    Offset receiverCenter,
    double receiverRadius,
  ) {
    // Calculate shadow position on receiver (simplified 2D projection)
    // Direction from star through caster to receiver
    final starToCasterX = caster.position.x - star.position.x;
    final starToCasterY = caster.position.y - star.position.y;

    // Normalize direction
    final distance = math.sqrt(
      starToCasterX * starToCasterX + starToCasterY * starToCasterY,
    );
    if (distance == 0) {
      return null;
    }

    // Shadow center offset from receiver center
    // Simplified: use opposite direction of star-caster vector
    final shadowOffsetX =
        -starToCasterX /
        distance *
        receiverRadius *
        RenderingConstants.castShadowCenterOffsetRatio;
    final shadowOffsetY =
        -starToCasterY /
        distance *
        receiverRadius *
        RenderingConstants.castShadowCenterOffsetRatio;

    final shadowCenter = Offset(
      receiverCenter.dx + shadowOffsetX,
      receiverCenter.dy + shadowOffsetY,
    );

    // Calculate shadow size based on caster size and distances
    final starToCaster = _calculate3DDistance(star, caster);
    final casterToReceiver = _calculate3DDistance(caster, receiver);

    // Umbra size decreases with distance
    final totalDistance = starToCaster + casterToReceiver;
    final umbraScale =
        (caster.radius * receiverRadius) /
        totalDistance.clamp(
          RenderingConstants.castShadowMinDistance,
          double.infinity,
        );
    final umbraRadius = umbraScale.clamp(
      0.0,
      receiverRadius * RenderingConstants.castShadowMaxUmbraRatio,
    );

    // Penumbra is larger
    final penumbraRadius =
        umbraRadius * (1.0 + RenderingConstants.castShadowPenumbraRatio);

    return ShadowInfo(
      shadowCenter: shadowCenter,
      umbraRadius: umbraRadius,
      penumbraRadius: penumbraRadius,
    );
  }

  /// Draw specular highlight on a body from nearby stars
  ///
  /// Implements Phong shading model for specular reflection, creating a bright
  /// highlight where light from stars reflects directly toward the viewer.
  ///
  /// Parameters:
  /// - [canvas]: The canvas to draw on
  /// - [center]: Center position of the body
  /// - [radius]: Radius of the body
  /// - [currentBody]: The body receiving the highlight
  /// - [allBodies]: All bodies in simulation to find light sources
  static void drawSpecularHighlight(
    Canvas canvas,
    Offset center,
    double radius,
    Body currentBody,
    List<Body> allBodies,
  ) {
    // Find nearest star for strongest highlight
    Body? nearestStar;
    double minDistance = double.infinity;

    for (final otherBody in allBodies) {
      if (otherBody == currentBody || otherBody.bodyType != BodyType.star) {
        continue;
      }

      final distance = _calculate3DDistance(currentBody, otherBody);
      if (distance < minDistance && distance > 0) {
        minDistance = distance;
        nearestStar = otherBody;
      }
    }

    if (nearestStar == null) {
      return; // No light source
    }

    // Calculate light direction (from body to star)
    final lightDirX = nearestStar.position.x - currentBody.position.x;
    final lightDirY = nearestStar.position.y - currentBody.position.y;
    final lightDirZ = nearestStar.position.z - currentBody.position.z;
    final lightDist = math.sqrt(
      lightDirX * lightDirX + lightDirY * lightDirY + lightDirZ * lightDirZ,
    );

    if (lightDist == 0) {
      return;
    }

    // Normalize light direction
    final normLightX = lightDirX / lightDist;
    final normLightY = lightDirY / lightDist;
    final normLightZ = lightDirZ / lightDist;

    // Simplified view direction (assume camera looking down -Z axis)
    const viewX = RenderingConstants.specularViewDirectionX;
    const viewY = RenderingConstants.specularViewDirectionY;
    const viewZ = RenderingConstants.specularViewDirectionZ;

    // Calculate reflection vector using Phong model
    // R = 2(N·L)N - L, where N is surface normal at highlight point
    // Simplified: we use the light direction as approximate surface normal
    final dotNL =
        normLightX * normLightX +
        normLightY * normLightY +
        normLightZ * normLightZ;
    final reflectX = 2 * dotNL * normLightX - normLightX;
    final reflectY = 2 * dotNL * normLightY - normLightY;
    final reflectZ = 2 * dotNL * normLightZ - normLightZ;

    // Calculate R·V (how well reflection aligns with view)
    final dotRV = reflectX * viewX + reflectY * viewY + reflectZ * viewZ;

    // Only draw highlight if reflection somewhat toward viewer
    if (dotRV < RenderingConstants.specularMinReflectionDot) {
      return;
    }

    // Calculate highlight intensity using Phong shininess
    final intensity = math
        .pow(
          dotRV.clamp(0.0, 1.0),
          RenderingConstants.specularHighlightShininess,
        )
        .toDouble();

    if (intensity < RenderingConstants.specularMinIntensity) {
      return; // Too dim
    }

    // Position highlight on the lit side
    final highlightOffset = Offset(
      normLightX * radius * RenderingConstants.specularHighlightSize,
      normLightY * radius * RenderingConstants.specularHighlightSize,
    );
    final highlightCenter = center + highlightOffset;

    // Draw specular highlight with gradient
    final highlightRadius = radius * RenderingConstants.specularHighlightSize;

    // Scale intensity by body's albedo (reflectivity)
    // Ice worlds and bright surfaces reflect more light than dark rocky bodies
    final albedo = _getBodyAlbedo(currentBody);
    final highlightIntensity =
        intensity * RenderingConstants.specularHighlightIntensity * albedo;

    final highlightGradient = RadialGradient(
      colors: [
        AppColors.uiWhite.withValues(alpha: highlightIntensity),
        AppColors.uiWhite.withValues(
          alpha:
              highlightIntensity *
              RenderingConstants.specularHighlightGradientFalloff,
        ),
        AppColors.transparentColor,
      ],
      stops: const [
        RenderingConstants.specularHighlightGradientStart,
        RenderingConstants.specularHighlightGradientMidpoint,
        RenderingConstants.specularHighlightGradientEnd,
      ],
    );

    final highlightRect = Rect.fromCircle(
      center: highlightCenter,
      radius: highlightRadius,
    );
    canvas.drawCircle(
      highlightCenter,
      highlightRadius,
      Paint()
        ..shader = highlightGradient.createShader(highlightRect)
        ..blendMode = BlendMode.plus, // Additive blending for bright highlight
    );
  }

  /// Draw atmospheric scattering effect on the lit side of a body
  ///
  /// Creates a sunrise/sunset glow effect along the terminator (day/night boundary)
  /// by adding orange/red scattering where atmosphere is backlit by the star.
  static void drawAtmosphericScattering(
    Canvas canvas,
    Offset center,
    double radius,
    Body currentBody,
    List<Body> allBodies,
    Color bodyColor,
  ) {
    // Find light sources
    final stars = allBodies
        .where((body) => body != currentBody && body.bodyType == BodyType.star)
        .toList();

    if (stars.isEmpty) {
      return; // No light source
    }

    // Calculate blended lighting direction
    final blendedLight = _calculateBlendedLighting(currentBody, stars);

    if (blendedLight.intensity <
        RenderingConstants.atmosphericScatteringMinIntensity) {
      return; // Too dim for visible scattering
    }

    // Calculate light direction in 2D (normalized)
    final lightX = blendedLight.direction.x;
    final lightY = blendedLight.direction.y;

    // Create scattering effect along the terminator (perpendicular to light)
    // Scattering appears as a crescent around the lit edge
    final scatteringWidth =
        radius * RenderingConstants.atmosphericScatteringWidth;
    final scatteringIntensity =
        RenderingConstants.atmosphericScatteringIntensity *
        blendedLight.intensity;

    // Position scattering ring slightly toward the light source
    final scatteringOffset = Offset(
      lightX * radius * RenderingConstants.atmosphericScatteringOffsetRatio,
      lightY * radius * RenderingConstants.atmosphericScatteringOffsetRatio,
    );

    // Create gradient with warm scattering colors (orange/red like sunrise)
    final scatteringGradient = RadialGradient(
      center: Alignment(
        scatteringOffset.dx / (radius + scatteringWidth),
        scatteringOffset.dy / (radius + scatteringWidth),
      ),
      colors: [
        // Inner edge: blend with body color
        Color.lerp(
          bodyColor,
          AppColors.stellarGType,
          RenderingConstants.atmosphericScatteringInnerColorBlend,
        )!.withValues(
          alpha:
              scatteringIntensity *
              RenderingConstants.atmosphericScatteringInnerAlpha,
        ),
        // Mid: orange scattering
        AppColors.stellarKType.withValues(
          alpha:
              scatteringIntensity *
              RenderingConstants.atmosphericScatteringMidAlpha,
        ),
        // Outer: red/orange glow
        AppColors.stellarMType.withValues(
          alpha:
              scatteringIntensity *
              RenderingConstants.atmosphericScatteringOuterAlpha,
        ),
        // Fade to transparent
        AppColors.transparentColor,
      ],
      stops: const [
        RenderingConstants.atmosphericScatteringGradientStart,
        RenderingConstants.atmosphericScatteringGradientMid1,
        RenderingConstants.atmosphericScatteringGradientMid2,
        RenderingConstants.atmosphericScatteringGradientEnd,
      ],
      // Concentrate scattering near terminator
      focal: Alignment(
        scatteringOffset.dx /
            (radius + scatteringWidth) *
            RenderingConstants.atmosphericScatteringFocalRatio,
        scatteringOffset.dy /
            (radius + scatteringWidth) *
            RenderingConstants.atmosphericScatteringFocalRatio,
      ),
      focalRadius:
          RenderingConstants.atmosphericScatteringConcentration *
          RenderingConstants.atmosphericScatteringFocalRadiusMultiplier,
    );

    final scatteringRect = Rect.fromCircle(
      center: center,
      radius: radius + scatteringWidth,
    );

    canvas.drawCircle(
      center,
      radius +
          scatteringWidth *
              RenderingConstants.atmosphericScatteringDrawWidthRatio,
      Paint()
        ..shader = scatteringGradient.createShader(scatteringRect)
        ..blendMode = BlendMode.plus, // Additive for glowing effect
    );
  }

  /// Get albedo (reflectivity) for a body based on its properties
  ///
  /// Returns a value between 0.0 (absorbs all light) and 1.0 (reflects all light)
  /// based on the body's type, name, and color characteristics.
  static double _getBodyAlbedo(Body body) {
    // Check for specific celestial bodies first
    final bodyName = CelestialBodyName.fromString(body.name);

    // Ice worlds (bright, reflective)
    if (body.name.toLowerCase().contains('ice') ||
        body.name.toLowerCase().contains('icy')) {
      return RenderingConstants.albedoIce;
    }

    // Ocean worlds
    if (bodyName == CelestialBodyName.earth ||
        body.name.toLowerCase().contains('ocean') ||
        body.name.toLowerCase().contains('water')) {
      return RenderingConstants.albedoWater;
    }

    // Desert/arid worlds
    if (bodyName == CelestialBodyName.mars ||
        body.name.toLowerCase().contains('desert') ||
        body.name.toLowerCase().contains('arid')) {
      return RenderingConstants.albedoDesert;
    }

    // Dark/volcanic worlds
    if (body.name.toLowerCase().contains('volcanic') ||
        body.name.toLowerCase().contains('lava') ||
        body.name.toLowerCase().contains('dark')) {
      return RenderingConstants.albedoDark;
    }

    // Gas giants (based on specific known bodies)
    if (bodyName == CelestialBodyName.jupiter ||
        bodyName == CelestialBodyName.saturn ||
        bodyName == CelestialBodyName.uranus ||
        bodyName == CelestialBodyName.neptune ||
        body.name.toLowerCase().contains('gas giant')) {
      return RenderingConstants.albedoGasGiant;
    }

    // Rocky terrestrial planets (default for planets)
    if (body.bodyType == BodyType.planet) {
      return RenderingConstants.albedoRock;
    }

    // Vegetation (Earth-like)
    if (body.name.toLowerCase().contains('forest') ||
        body.name.toLowerCase().contains('vegetation')) {
      return RenderingConstants.albedoVegetation;
    }

    // Moons typically have lower albedo (rocky/icy mix)
    if (body.bodyType == BodyType.moon) {
      return (RenderingConstants.albedoRock + RenderingConstants.albedoIce) / 2;
    }

    // Default for unknown types
    return RenderingConstants.albedoDefault;
  }

  /// Calculate blended lighting from multiple light sources
  ///
  /// Returns the dominant light direction and intensity by blending contributions
  /// from up to [RenderingConstants.maxLightSourcesForBlending] light sources.
  static LightContribution _calculateBlendedLighting(
    Body body,
    List<Body> lightSources,
  ) {
    if (lightSources.isEmpty) {
      // No light sources - return zero contribution
      return LightContribution(
        star: body, // Use body itself as placeholder
        intensity: 0.0,
        direction: vm.Vector3(
          RenderingConstants.defaultLightDirectionX,
          RenderingConstants.defaultLightDirectionY,
          RenderingConstants.defaultLightDirectionZ,
        ),
      );
    }

    // Calculate contributions from each light source
    final contributions = <LightContribution>[];

    for (final star in lightSources) {
      final displacement = star.position - body.position;
      final distance = displacement.length;

      // Skip if too far away
      if (distance > RenderingConstants.lightSourceMaxDistance) {
        continue;
      }

      // Calculate intensity based on inverse square law with distance
      final baseIntensity = star.mass / (distance * distance);

      // Normalize to reasonable range (0.0 - 1.0)
      final normalizedIntensity =
          (baseIntensity * RenderingConstants.lightIntensityNormalizationFactor)
              .clamp(0.0, 1.0);

      // Skip if contribution is too small
      if (normalizedIntensity < RenderingConstants.lightSourceMinContribution) {
        continue;
      }

      contributions.add(
        LightContribution(
          star: star,
          intensity: normalizedIntensity,
          direction: displacement.normalized(),
        ),
      );
    }

    // If no significant contributions, return zero
    if (contributions.isEmpty) {
      return LightContribution(
        star: lightSources.first,
        intensity: 0.0,
        direction: vm.Vector3(
          RenderingConstants.defaultLightDirectionX,
          RenderingConstants.defaultLightDirectionY,
          RenderingConstants.defaultLightDirectionZ,
        ),
      );
    }

    // Sort by intensity (brightest first)
    contributions.sort((a, b) => b.intensity.compareTo(a.intensity));

    // Take top N contributions
    final topContributions = contributions
        .take(RenderingConstants.maxLightSourcesForBlending)
        .toList();

    // Blend directions weighted by intensity
    var blendedDirection = vm.Vector3.zero();
    var totalIntensity = 0.0;

    for (final contribution in topContributions) {
      blendedDirection += contribution.direction * contribution.intensity;
      totalIntensity += contribution.intensity;
    }

    // Normalize the blended direction
    if (blendedDirection.length > 0) {
      blendedDirection = blendedDirection.normalized();
    }

    return LightContribution(
      star: topContributions.first.star, // Use brightest star as primary
      intensity: totalIntensity / topContributions.length, // Average intensity
      direction: blendedDirection,
    );
  }
}
