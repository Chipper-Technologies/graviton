import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering celestial bodies (planets, stars, black holes)
class CelestialBodyPainter {
  /// Draw a body based on its name/type with special rendering for known celestial objects
  static void drawBody(
    Canvas canvas,
    Offset center,
    double radius,
    Body body, {
    vm.Matrix4? viewMatrix,
    Size? canvasSize,
    double opacity = 1.0,
  }) {
    // Special rendering for celestial bodies
    if (body.name.contains('Black Hole') || body.name == 'Black Hole' || body.name == 'Supermassive Black Hole') {
      drawBlackHole(canvas, center, radius, opacity: opacity);
    } else if (body.name == 'Sun') {
      drawSun(canvas, center, radius);
    } else if (body.name == 'Mercury') {
      drawMercury(canvas, center, radius);
    } else if (body.name == 'Venus') {
      drawVenus(canvas, center, radius);
    } else if (body.name == 'Earth') {
      drawEarth(canvas, center, radius);
    } else if (body.name == 'Mars') {
      drawMars(canvas, center, radius);
    } else if (body.name == 'Jupiter') {
      drawJupiter(canvas, center, radius);
    } else if (body.name == 'Saturn') {
      drawSaturn(canvas, center, radius, body, viewMatrix: viewMatrix, canvasSize: canvasSize);
    } else if (body.name == 'Uranus') {
      drawUranus(canvas, center, radius, body, viewMatrix: viewMatrix, canvasSize: canvasSize);
    } else if (body.name == 'Neptune') {
      drawNeptune(canvas, center, radius);
    } else {
      // Normal body rendering
      final glow = RadialGradient(
        colors: [
          body.color.withValues(alpha: RenderingConstants.bodyAlpha),
          body.color.withValues(alpha: RenderingConstants.bodyGlowAlpha),
        ],
      );

      final rect = Rect.fromCircle(center: center, radius: radius * RenderingConstants.bodyGlowMultiplier);
      canvas.drawCircle(
        center,
        radius * RenderingConstants.bodyGlowMultiplier,
        Paint()..shader = glow.createShader(rect),
      );

      canvas.drawCircle(center, radius, Paint()..color = body.color);
    }
  }

  /// Draw a realistic black hole with accretion disk and event horizon
  static void drawBlackHole(Canvas canvas, Offset center, double radius, {double opacity = 1.0}) {
    // Enhanced accretion disk for supermassive black hole - clean glow
    final accretionDiskRadius = radius * 5.0; // Large disk for presence

    // Single clean glow - no color mixing issues (with opacity adjustment)
    final cleanGlow = RadialGradient(
      colors: [
        AppColors.starGlowWhite.withValues(alpha: AppTypography.opacityHigh * opacity), // Bright white center
        AppColors.starGlowGold.withValues(alpha: AppTypography.opacityMedium * opacity), // Golden ring
        AppColors.starGlowOrange.withValues(alpha: AppTypography.opacityFaint * opacity), // Orange outer
        AppColors.starGlowRedOrange.withValues(alpha: AppTypography.opacityMidFade * opacity), // Dim orange edge
        AppColors.transparentColor,
      ],
    );

    final glowRect = Rect.fromCircle(center: center, radius: accretionDiskRadius);
    canvas.drawCircle(center, accretionDiskRadius, Paint()..shader = cleanGlow.createShader(glowRect));

    // Clean accretion disk rings - simple and bright
    final diskPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    for (int i = 0; i < 5; i++) {
      final ringRadius = radius * (1.3 + i * 0.4);
      final alpha = ((0.6 - i * 0.1) * opacity).clamp(0.0, 1.0); // Clean intensity progression with opacity

      // Clean color progression - no green mixing
      Color ringColor;
      if (i == 0) {
        ringColor = AppColors.starGlowWhite.withValues(alpha: alpha); // White
      } else if (i == 1) {
        ringColor = AppColors.starGlowGold.withValues(alpha: alpha); // Gold
      } else if (i == 2) {
        ringColor = AppColors.starGlowOrange.withValues(alpha: alpha); // Orange
      } else {
        ringColor = AppColors.starGlowRedOrange.withValues(alpha: alpha); // Red-orange
      }

      diskPaint.color = ringColor;
      canvas.drawCircle(center, ringRadius, diskPaint);
    }

    // Photon sphere - gravitational lensing effect (with opacity)
    final photonSphereRadius = radius * 1.8;
    final photonSpherePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.starGlowWhite.withValues(alpha: AppTypography.opacityFaint * opacity);

    canvas.drawCircle(center, photonSphereRadius, photonSpherePaint);

    // Event horizon - the inescapable void (with opacity for fade effect)
    final eventHorizonPaint = Paint()
      ..color = AppColors.uiBlack.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, eventHorizonPaint);

    // Schwarzschild radius indicator - menacing edge of no return (with opacity)
    final schwarzschildPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = AppColors.starGlowWhite.withValues(alpha: AppTypography.opacityMediumHigh * opacity);

    canvas.drawCircle(center, radius, schwarzschildPaint);

    // Add subtle gravitational distortion rings for menacing effect (with opacity)
    for (int i = 1; i <= 2; i++) {
      final distortionRadius = radius * (1.0 + i * 0.15);
      final distortionPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = AppColors.starGlowWhite.withValues(alpha: (AppTypography.opacityVeryFaint / i) * opacity);

      canvas.drawCircle(center, distortionRadius, distortionPaint);
    }
  }

  /// Draw the Sun with solar flares and corona
  static void drawSun(Canvas canvas, Offset center, double radius) {
    // Corona - outer solar atmosphere
    final coronaGlow = RadialGradient(
      colors: [
        AppColors.accretionDiskGold.withValues(alpha: AppTypography.opacityVeryHigh), // Bright gold center
        AppColors.accretionDiskOrange.withValues(alpha: AppTypography.opacityMediumHigh), // Orange middle
        AppColors.accretionDiskRed.withValues(alpha: AppTypography.opacityFaint), // Red outer
        AppColors.transparentColor,
      ],
    );

    final coronaRect = Rect.fromCircle(center: center, radius: radius * 3.0);
    canvas.drawCircle(center, radius * 3.0, Paint()..shader = coronaGlow.createShader(coronaRect));

    // Solar surface with slight texture
    final surfaceGlow = RadialGradient(
      colors: [
        AppColors.coronaYellow, // Bright yellow center
        AppColors.coronaGold, // Gold
        AppColors.coronaOrange, // Orange edge
      ],
    );

    final surfaceRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(center, radius, Paint()..shader = surfaceGlow.createShader(surfaceRect));
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
    canvas.drawCircle(center, radius, Paint()..shader = mercuryGlow.createShader(rect));

    // Crater details
    final craterPaint = Paint()
      ..color = AppColors.moonShadow.withValues(alpha: AppTypography.opacityHigh)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.2), radius * 0.2, craterPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.4, center.dy + radius * 0.3), radius * 0.15, craterPaint);
  }

  /// Draw Venus with thick atmosphere
  static void drawVenus(Canvas canvas, Offset center, double radius) {
    // Thick atmosphere glow
    final atmosphereGlow = RadialGradient(
      colors: [
        AppColors.venusYellow.withValues(alpha: AppTypography.opacityMediumHigh), // Bright center
        AppColors.venusOrangeMiddle.withValues(alpha: AppTypography.opacitySemiTransparent), // Orange middle
        AppColors.venusOuterGlow.withValues(alpha: AppTypography.opacityVeryFaint), // Outer glow
        AppColors.transparentColor,
      ],
    );

    final atmosphereRect = Rect.fromCircle(center: center, radius: radius * 2.0);
    canvas.drawCircle(center, radius * 2.0, Paint()..shader = atmosphereGlow.createShader(atmosphereRect));

    // Planet surface
    final surfaceGlow = RadialGradient(
      colors: [
        AppColors.venusCreamCenter, // Light cream center
        AppColors.venusGoldenEdge, // Golden yellow edge
      ],
    );

    final surfaceRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(center, radius, Paint()..shader = surfaceGlow.createShader(surfaceRect));
  }

  /// Draw Earth with continents and atmosphere
  static void drawEarth(Canvas canvas, Offset center, double radius) {
    // Thin blue atmosphere
    final atmosphereGlow = RadialGradient(
      colors: [
        AppColors.earthSkyBlue.withValues(alpha: AppTypography.opacityFaint), // Sky blue
        AppColors.transparentColor,
      ],
    );

    final atmosphereRect = Rect.fromCircle(center: center, radius: radius * 1.5);
    canvas.drawCircle(center, radius * 1.5, Paint()..shader = atmosphereGlow.createShader(atmosphereRect));

    // Ocean base
    canvas.drawCircle(center, radius, Paint()..color = AppColors.earthDeepBlue); // Deep blue

    // Continental masses
    final continentPaint = Paint()
      ..color = AppColors.earthGreen
      ..style = PaintingStyle.fill;

    // Simple continent shapes
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -0.5, 1.2, true, continentPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.8), 1.8, 0.8, true, continentPaint);
  }

  /// Draw Mars with polar ice caps
  static void drawMars(Canvas canvas, Offset center, double radius) {
    // Thin atmosphere
    final atmosphereGlow = RadialGradient(
      colors: [
        AppColors.marsFaintRed.withValues(alpha: AppTypography.opacityVeryFaint), // Faint red
        AppColors.transparentColor,
      ],
    );

    final atmosphereRect = Rect.fromCircle(center: center, radius: radius * 1.3);
    canvas.drawCircle(center, radius * 1.3, Paint()..shader = atmosphereGlow.createShader(atmosphereRect));

    // Planet surface
    final surfaceGlow = RadialGradient(
      colors: [
        AppColors.marsBrightRed, // Bright red center
        AppColors.marsMediumRed, // Medium red edge
      ],
    );

    final surfaceRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(center, radius, Paint()..shader = surfaceGlow.createShader(surfaceRect));

    // Polar ice caps
    final icePaint = Paint()..color = AppColors.marsIceWhite.withValues(alpha: AppTypography.opacityVeryHigh);
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.7), radius * 0.3, icePaint);
    canvas.drawCircle(Offset(center.dx, center.dy + radius * 0.7), radius * 0.25, icePaint);
  }

  /// Draw Jupiter with Great Red Spot and bands
  static void drawJupiter(Canvas canvas, Offset center, double radius) {
    // Gas giant glow
    final giantGlow = RadialGradient(
      colors: [
        AppColors.jupiterCreamCenter.withValues(alpha: AppTypography.opacityVeryHigh), // Cream center
        AppColors.jupiterGoldEdge.withValues(alpha: AppTypography.opacitySemiTransparent), // Gold edge
        AppColors.transparentColor,
      ],
    );

    final glowRect = Rect.fromCircle(center: center, radius: radius * 2.0);
    canvas.drawCircle(center, radius * 2.0, Paint()..shader = giantGlow.createShader(glowRect));

    // Planet base
    canvas.drawCircle(center, radius, Paint()..color = AppColors.jupiterSurface);

    // Atmospheric bands
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;

    bandPaint.color = AppColors.jupiterBandGold.withValues(alpha: AppTypography.opacityHigh);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.6), 0, 6.28, false, bandPaint);

    bandPaint.color = AppColors.jupiterBandBrown.withValues(alpha: AppTypography.opacityMedium);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.8), 0, 6.28, false, bandPaint);

    // Great Red Spot
    final redSpotPaint = Paint()..color = AppColors.jupiterRedSpot.withValues(alpha: AppTypography.opacityVeryHigh);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + radius * 0.3, center.dy), width: radius * 0.4, height: radius * 0.2),
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
    canvas.drawCircle(center, radius, Paint()..shader = saturnGlow.createShader(planetRect));

    // Add subtle bands to Saturn's atmosphere
    final bandPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..color = AppColors.saturnRingColor.withValues(alpha: AppTypography.opacityFaint);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.6), 0, 6.28, false, bandPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.8), 0, 6.28, false, bandPaint);

    // Draw beautiful 3D inclined ring system if we have the view matrix
    if (viewMatrix != null && canvasSize != null) {
      _drawSaturnRings(canvas, center, radius, body.position, viewMatrix, canvasSize);
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
    canvas.drawCircle(center, radius, Paint()..shader = uranusGlow.createShader(planetRect));

    // Draw beautiful 3D inclined ring system if we have the view matrix
    if (viewMatrix != null && canvasSize != null) {
      _drawUranusRings(canvas, center, radius, body.position, viewMatrix, canvasSize);
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
    canvas.drawCircle(center, radius, Paint()..shader = neptuneGlow.createShader(planetRect));

    // Great Dark Spot
    final darkSpotPaint = Paint()..color = AppColors.neptuneDarkSpot.withValues(alpha: AppTypography.opacityHigh);
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
      ..color = AppColors.neptuneWindBand.withValues(alpha: AppTypography.opacityMedium);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius * 0.7), 0, 6.28, false, bandPaint);
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
      [1.11, 1.16, AppColors.saturnDRing, 0.3], // D Ring - Very close inner ring
      [1.23, 1.45, AppColors.saturnCRing, 0.5], // C Ring - Crepe ring
      [1.53, 1.88, AppColors.saturnBRing, 0.9], // B Ring - Main bright ring (much closer)
      // Cassini Division gap here (1.88 - 1.95)
      [1.95, 2.27, AppColors.saturnARing, 0.8], // A Ring - Outer main ring (closer)
      [2.27, 2.32, AppColors.saturnFRing, 0.4], // F Ring - Very narrow shepherd ring
    ];

    const int numPoints = 128; // High detail for smooth rings
    final inclinationRadians = 26.7 * math.pi / 180.0; // Saturn's ring inclination

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

        final innerScreenPos = PainterUtils.project(viewMatrix, innerWorldPos, canvasSize);

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
        final outerScreenPos = PainterUtils.project(viewMatrix, outerWorldPos, canvasSize);

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
        final texturePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = color.withValues(alpha: opacity * 0.3);

        // Draw some radial texture lines for ring particle effect
        for (int i = 0; i < numPoints; i += 8) {
          if (i < innerPoints.length && i < outerPoints.length) {
            canvas.drawLine(innerPoints[i], outerPoints[i], texturePaint);
          }
        }
      }
    }
  }

  /// Draw Saturn's beautiful ring system fallback (2D)
  static void _drawSaturnRingsFallback(Canvas canvas, Offset center, double radius) {
    // Saturn's ring system with REALISTIC proportions - rings much closer to planet
    final ringData = [
      // [innerRadius, outerRadius, color, opacity] - CORRECTED realistic proportions
      [1.11, 1.16, AppColors.saturnDRing, 0.3], // D Ring
      [1.23, 1.45, AppColors.saturnCRing, 0.5], // C Ring
      [1.53, 1.88, AppColors.saturnBRing, 0.9], // B Ring (main ring much closer)
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
      final texturePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.3
        ..color = color.withValues(alpha: opacity * 0.2);

      const int textureLines = 32;
      for (int i = 0; i < textureLines; i++) {
        final angle = (i / textureLines) * 2 * math.pi;
        final innerX = center.dx + innerRadius * math.cos(angle);
        final innerY = center.dy + innerRadius * math.sin(angle);
        final outerX = center.dx + outerRadius * math.cos(angle);
        final outerY = center.dy + outerRadius * math.sin(angle);

        canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), texturePaint);
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
    final inclinationRadians = 97.8 * math.pi / 180.0; // Uranus is tilted on its side!

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

        final worldPos = vm.Vector3(bodyPosition.x + localX, bodyPosition.y + rotatedY, bodyPosition.z + rotatedZ);
        final screenPos = PainterUtils.project(viewMatrix, worldPos, canvasSize);
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
  static void _drawUranusRingsFallback(Canvas canvas, Offset center, double radius) {
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
}
