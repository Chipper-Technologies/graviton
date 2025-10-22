import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering the space background, starfield, and distant galaxies
class BackgroundPainter {
  /// Draw dynamic animated space gradient background with fluid color transitions
  /// Each simulation creates a unique background pattern based on simulation parameters
  static void drawSpaceBackground(Canvas canvas, Size size, [int? seed]) {
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final backgroundSeed = seed ?? 42; // Default seed if none provided

    // Create fluid, animated gradient with multiple layers for depth
    _drawAnimatedSpaceGradient(canvas, size, time, backgroundSeed);
  }

  /// Draw spherical gradient background that wraps around the 3D scene like the starfield
  /// Creates gradient sources positioned in 3D space that get projected to screen
  static void drawSphericalSpaceBackground(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    vm.Matrix4 view, [
    int? seed,
  ]) {
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final backgroundSeed = seed ?? 42;

    // Create spherical gradient sources in 3D space
    _drawSphericalGradients(canvas, size, vp, view, time, backgroundSeed);
  }

  /// Create a beautiful animated space gradient with flowing colors
  /// Uses seed to create unique patterns that change with each simulation
  static void _drawAnimatedSpaceGradient(
    Canvas canvas,
    Size size,
    double time,
    int seed,
  ) {
    // Use theme colors for deep space background palette with enhanced vibrant purples
    final spaceColors = [
      AppColors.backgroundDeepBlue,
      AppColors.backgroundPurple,
      AppColors.backgroundDeepPurple,
      AppColors.backgroundVibrantPurple,
      AppColors.backgroundMysticPurple,
      AppColors.backgroundRoyalPurple,
      AppColors.spaceDeepPurple,
      AppColors.spacePurple,
      AppColors.spaceVibrantPurple,
      AppColors.spaceMysticPurple,
      AppColors.spaceRoyalPurple,
      AppColors.spaceDeepBlueBlack,
      AppColors.nebulaVibrantPurple,
      AppColors.nebulaMysticPurple,
      AppColors.nebulaElectricPurple,
      AppColors.nebulaCosmicPurple,
      AppColors.nebulaRoyalBlue,
      AppColors.nebulaDarkMagenta,
      AppColors.nebulaBlueViolet,
      AppColors.nebulaDarkOrchid,
      AppColors.backgroundBlack,
    ];

    // Use seed to create unique variations for each simulation
    final random = math.Random(seed);
    final seedOffset1 = random.nextDouble() * 10; // Random phase offset
    final seedOffset2 = random.nextDouble() * 8;
    final seedOffset3 = random.nextDouble() * 12;
    final speedMultiplier = 0.8 + random.nextDouble() * 0.4; // Speed variation
    final colorShift = random.nextInt(
      spaceColors.length,
    ); // Starting color offset

    // Create multiple animated radial gradient layers for organic, flowing motion
    for (int layer = 0; layer < 4; layer++) {
      final layerTime =
          time *
          (0.08 + layer * 0.03) *
          speedMultiplier; // Unique speed per sim
      final layerAlpha = 0.6 - (layer * 0.1);
      final layerSeedOffset =
          random.nextDouble() * 5; // Unique offset per layer

      // Smoothly cycle through colors over time with seed-based variation
      final colorIndex1 =
          ((layerTime * 0.25 + layer * 2.1 + seedOffset1) % spaceColors.length)
              .floor();
      final colorIndex2 =
          ((layerTime * 0.18 + layer * 1.7 + seedOffset2 + 3) %
                  spaceColors.length)
              .floor();
      final colorIndex3 =
          ((layerTime * 0.22 + layer * 2.3 + seedOffset3 + 5) %
                  spaceColors.length)
              .floor();

      // Smooth interpolation factors for color blending with seed variation
      final blend1 =
          (math.sin(layerTime * 0.3 + layer * 1.4 + layerSeedOffset) * 0.5 +
          0.5);
      final blend2 =
          (math.cos(layerTime * 0.35 + layer * 0.9 + layerSeedOffset * 1.3) *
              0.5 +
          0.5);
      final blend3 =
          (math.sin(layerTime * 0.28 + layer * 1.8 + layerSeedOffset * 0.8) *
              0.5 +
          0.5);

      // Create interpolated colors with seed-based color shift
      final color1 = Color.lerp(
        spaceColors[(colorIndex1 + colorShift) % spaceColors.length],
        spaceColors[(colorIndex1 + colorShift + 1) % spaceColors.length],
        blend1,
      )!.withValues(alpha: layerAlpha);

      final color2 = Color.lerp(
        spaceColors[(colorIndex2 + colorShift) % spaceColors.length],
        spaceColors[(colorIndex2 + colorShift + 1) % spaceColors.length],
        blend2,
      )!.withValues(alpha: layerAlpha);

      final color3 = Color.lerp(
        spaceColors[(colorIndex3 + colorShift) % spaceColors.length],
        spaceColors[(colorIndex3 + colorShift + 1) % spaceColors.length],
        blend3,
      )!.withValues(alpha: layerAlpha);

      // Create organic, flowing radial gradients with seed-based positioning
      // Animate center position in smooth, circular patterns with unique offsets
      final centerX =
          0.5 + math.sin(layerTime * 0.15 + layer * 1.3 + seedOffset1) * 0.4;
      final centerY =
          0.5 + math.cos(layerTime * 0.12 + layer * 0.8 + seedOffset2) * 0.3;

      // Animate radius for breathing effect with seed variation
      final baseRadius =
          0.8 + math.sin(layerTime * 0.2 + layer * 1.1 + seedOffset3) * 0.3;

      // Create multiple overlapping radial gradients for organic patterns
      final radialGradient1 = Paint()
        ..blendMode = layer == 0 ? BlendMode.src : BlendMode.overlay
        ..shader = RadialGradient(
          center: Alignment(centerX * 2 - 1, centerY * 2 - 1),
          radius: baseRadius,
          colors: [
            color1,
            color2.withValues(alpha: color2.a * 0.7),
            color3.withValues(alpha: color3.a * 0.4),
            AppColors.transparentColor,
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ).createShader(Offset.zero & size);

      canvas.drawRect(Offset.zero & size, radialGradient1);

      // Add a second offset radial gradient for more complexity with seed variation
      final offset = layer * 0.3 + layerSeedOffset;
      final centerX2 =
          0.5 +
          math.cos(layerTime * 0.18 + layer * 2.1 + offset + seedOffset2) *
              0.35;
      final centerY2 =
          0.5 +
          math.sin(layerTime * 0.14 + layer * 1.6 + offset + seedOffset3) *
              0.25;
      final radius2 =
          0.6 + math.cos(layerTime * 0.25 + layer * 0.7 + seedOffset1) * 0.2;

      final radialGradient2 = Paint()
        ..blendMode = BlendMode.softLight
        ..shader = RadialGradient(
          center: Alignment(centerX2 * 2 - 1, centerY2 * 2 - 1),
          radius: radius2,
          colors: [
            color2.withValues(alpha: layerAlpha * 0.6),
            color3.withValues(alpha: layerAlpha * 0.3),
            AppColors.transparentColor,
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Offset.zero & size);

      canvas.drawRect(Offset.zero & size, radialGradient2);
    }
  }

  /// Create spherical gradient sources positioned in 3D space that wrap around the scene
  /// Similar to how stars are positioned on a sphere but for gradient color sources
  static void _drawSphericalGradients(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    vm.Matrix4 view,
    double time,
    int seed,
  ) {
    // Use theme colors for deep space background palette
    final spaceColors = [
      AppColors.backgroundDeepBlue,
      AppColors.backgroundPurple,
      AppColors.backgroundDeepPurple,
      AppColors.backgroundVibrantPurple,
      AppColors.backgroundMysticPurple,
      AppColors.backgroundRoyalPurple,
      AppColors.spaceDeepPurple,
      AppColors.spacePurple,
      AppColors.spaceVibrantPurple,
      AppColors.spaceMysticPurple,
      AppColors.spaceRoyalPurple,
      AppColors.spaceDeepBlueBlack,
      AppColors.nebulaVibrantPurple,
      AppColors.nebulaMysticPurple,
      AppColors.nebulaElectricPurple,
      AppColors.nebulaCosmicPurple,
      AppColors.nebulaRoyalBlue,
      AppColors.nebulaDarkMagenta,
      AppColors.nebulaBlueViolet,
      AppColors.nebulaDarkOrchid,
      AppColors.backgroundBlack,
    ];

    // Use seed to create stable variations
    final random = math.Random(seed);

    // Create gradient sources using theme constants
    for (
      int source = 0;
      source < RenderingConstants.sphericalGradientSourceCount;
      source++
    ) {
      // Use deterministic positioning based on source index for stability
      final phi =
          (source * 2.39996322972865332) %
          (2 * math.pi); // Golden angle for even distribution
      final theta = math.acos(
        1 -
            2 *
                (source + 0.5) /
                RenderingConstants.sphericalGradientSourceCount,
      ); // Even latitude distribution

      final x = math.sin(theta) * math.cos(phi);
      final y = math.sin(theta) * math.sin(phi);
      final z = math.cos(theta);

      // Position the gradient source using theme radius
      final basePosition =
          vm.Vector3(x, y, z) *
          RenderingConstants.sphericalGradientSourceRadius;

      // Add subtle animation with seed-based phase offset using theme scale
      final phaseOffset = random.nextDouble() * math.pi * 2;
      final animatedPosition = vm.Vector3(
        basePosition.x +
            math.sin(time * 0.05 + phaseOffset) *
                RenderingConstants.sphericalGradientSourceRadius *
                RenderingConstants.sphericalGradientAnimationScale,
        basePosition.y +
            math.cos(time * 0.04 + phaseOffset + 1.0) *
                RenderingConstants.sphericalGradientSourceRadius *
                RenderingConstants.sphericalGradientAnimationScale,
        basePosition.z +
            math.sin(time * 0.06 + phaseOffset + 2.0) *
                RenderingConstants.sphericalGradientSourceRadius *
                RenderingConstants.sphericalGradientAnimationScale,
      );

      // Always project, even if behind camera - we'll handle visibility differently
      final screenPos = PainterUtils.project(vp, animatedPosition, size);

      // Choose stable colors based on source index
      final colorIndex1 = (source * 2) % spaceColors.length;
      final colorIndex2 = (source * 3 + 2) % spaceColors.length;

      // Create slow color animation
      final colorBlend =
          (math.sin(time * 0.1 + source * 0.8 + phaseOffset) * 0.5 + 0.5);
      final sourceColor = Color.lerp(
        spaceColors[colorIndex1],
        spaceColors[colorIndex2],
        colorBlend,
      )!;

      // Calculate visibility based on camera direction using theme constants
      final cameraForward = vm.Vector3(view[2], view[6], view[10]).normalized();
      final sourceDirection = animatedPosition.normalized();
      final dotProduct = cameraForward.dot(sourceDirection);

      // Create smooth falloff using theme visibility constants
      final visibility = math.max(
        0.0,
        RenderingConstants.sphericalGradientMinVisibility +
            dotProduct * RenderingConstants.sphericalGradientMaxVisibility,
      );

      // Use screen position if available, otherwise estimate position
      Offset center;
      if (screenPos != null) {
        center = screenPos;
      } else {
        // For sources behind camera, project them to screen edges smoothly
        final screenX = size.width * 0.5 + sourceDirection.x * size.width * 0.3;
        final screenY =
            size.height * 0.5 + sourceDirection.y * size.height * 0.3;
        center = Offset(screenX, screenY);
      }

      // Large, overlapping gradients using theme radius constants
      final gradientRadius =
          RenderingConstants.sphericalGradientBaseRadius +
          math.sin(time * 0.08 + source * 0.5) *
              RenderingConstants.sphericalGradientRadiusVariation;
      final intensity =
          visibility *
          (RenderingConstants.sphericalGradientBaseIntensity +
              RenderingConstants.sphericalGradientIntensityVariation *
                  math.sin(time * 0.12 + source));

      // Draw the spherical gradient source using theme alpha values
      final gradientPaint = Paint()
        ..blendMode = source == 0 ? BlendMode.src : BlendMode.softLight
        ..shader = RadialGradient(
          center: Alignment(
            (center.dx / size.width) * 2 - 1,
            (center.dy / size.height) * 2 - 1,
          ),
          radius: gradientRadius / math.max(size.width, size.height),
          colors: [
            sourceColor.withValues(
              alpha:
                  intensity * RenderingConstants.sphericalGradientPrimaryAlpha,
            ),
            sourceColor.withValues(
              alpha:
                  intensity *
                  RenderingConstants.sphericalGradientSecondaryAlpha,
            ),
            sourceColor.withValues(
              alpha:
                  intensity * RenderingConstants.sphericalGradientTertiaryAlpha,
            ),
            AppColors.transparentColor,
          ],
          stops: const [0.0, 0.4, 0.8, 1.0],
        ).createShader(Offset.zero & size);

      canvas.drawRect(Offset.zero & size, gradientPaint);
    }
  }

  /// Draw enhanced starfield with variable sizes, colors, and twinkling
  static void drawEnhancedStarfield(
    Canvas canvas,
    vm.Matrix4 vp,
    vm.Matrix4 view,
    Size size,
    List<StarData> stars,
  ) {
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;

    for (final star in stars) {
      final p = PainterUtils.project(vp, star.position, size);
      if (p == null) continue;

      // Calculate distance-based fading for depth
      final distance = star.position.length;
      final distanceFade = math
          .max(0.3, 1.0 - (distance / 3000.0))
          .clamp(0.0, 1.0);

      // Add subtle twinkling effect
      final twinklePhase =
          (star.position.x + star.position.y + star.position.z) * 0.001;
      final twinkle = 0.7 + 0.3 * math.sin(time * 2.0 + twinklePhase);

      // Combine brightness factors
      final finalBrightness = star.brightness * distanceFade * twinkle;
      final alpha = (finalBrightness * 255).round().clamp(0, 255);

      // Create star color with calculated alpha
      final starColor = Color(star.color).withValues(alpha: alpha / 255.0);

      // Draw main star
      final starPaint = Paint()
        ..isAntiAlias = true
        ..color = starColor;
      canvas.drawCircle(p, star.size, starPaint);

      // Add subtle glow for brighter stars
      if (star.brightness > 0.7 && star.size > 1.0) {
        final glowPaint = Paint()
          ..isAntiAlias = true
          ..color = starColor.withValues(alpha: alpha / 255.0 * 0.3);
        canvas.drawCircle(p, star.size * 2.5, glowPaint);
      }
    }
  }

  /// Generate a completely randomized galaxy with seeded randomization for consistency
  static Map<String, dynamic> _generateRandomGalaxy(math.Random random) {
    // Random galaxy types
    const galaxyTypes = ['spiral', 'elliptical', 'irregular'];
    final type = galaxyTypes[random.nextInt(galaxyTypes.length)];

    // Random position in distant 3D space
    final position = vm.Vector3(
      (random.nextDouble() - 0.5) * 5000.0, // -2500 to 2500
      (random.nextDouble() - 0.5) * 5000.0, // -2500 to 2500
      (random.nextDouble() - 0.5) * 4000.0, // -2000 to 2000
    );

    // Random size categories
    final sizeCategory = random.nextInt(3);
    final size = switch (sizeCategory) {
      0 => 40.0 + random.nextDouble() * 20.0, // Small: 40-60
      1 => 60.0 + random.nextDouble() * 20.0, // Medium: 60-80
      2 => 80.0 + random.nextDouble() * 40.0, // Large: 80-120
      _ => 65.0, // Fallback
    };

    // Random rotation and tilts
    final rotation = (random.nextDouble() - 0.5) * 6.28; // -π to π
    final tiltX = (random.nextDouble() - 0.5) * 3.14; // -π/2 to π/2
    final tiltY = (random.nextDouble() - 0.5) * 3.14; // -π/2 to π/2

    // Random galaxy colors with cosmic themes
    final galaxyColors = [
      AppColors.nebulaMediumSlateBlue, // Medium slate blue
      AppColors.nebulaPlum, // Plum
      AppColors.nebulaBlueViolet, // Blue violet
      AppColors.nebulaSlateBlue, // Slate blue
      AppColors.nebulaMediumSlateBlue2, // Medium slate blue
      AppColors.nebulaDarkOrchid, // Dark orchid
      AppColors.nebulaDarkMagenta, // Dark magenta
      AppColors.nebulaVibrantPurple, // Vibrant purple
      AppColors.nebulaMysticPurple, // Mystic purple
      AppColors.nebulaElectricPurple, // Electric purple
      AppColors.nebulaCosmicPurple, // Cosmic purple
      AppColors.nebulaRoyalBlue, // Royal blue
      AppColors.nebulaCornflowerBlue, // Cornflower blue
      AppColors.nebulaSkyBlue, // Sky blue
      AppColors.backgroundVibrantPurple, // Background vibrant purple
      AppColors.backgroundMysticPurple, // Background mystic purple
      AppColors.backgroundRoyalPurple, // Background royal purple
    ];

    final baseColor = galaxyColors[random.nextInt(galaxyColors.length)];
    final alpha =
        0.2 +
        random.nextDouble() *
            0.35; // Enhanced from 0.15-0.4 to 0.2-0.55 for more vibrant purples
    final color = baseColor.withValues(alpha: alpha);

    return {
      'position': position,
      'type': type,
      'size': size,
      'rotation': rotation,
      'tiltX': tiltX,
      'tiltY': tiltY,
      'color': color,
    };
  }

  /// Draw distant galaxies in 3D space using enhanced rendering with full randomization
  static void drawDistantGalaxies(
    Canvas canvas,
    vm.Matrix4 vp,
    vm.Matrix4 view,
    Size size,
  ) {
    final random = math.Random(
      42,
    ); // Seeded for consistent results across frames

    // Generate randomized galaxies
    final galaxyCount = 8 + random.nextInt(5); // 8-12 galaxies
    final galaxies = List.generate(
      galaxyCount,
      (_) => _generateRandomGalaxy(random),
    );

    for (final galaxy in galaxies) {
      final worldPos = galaxy['position'] as vm.Vector3;
      final galaxyType = galaxy['type'] as String;
      final galaxySize = galaxy['size'] as double;
      final rotation = galaxy['rotation'] as double;
      final tiltX = galaxy['tiltX'] as double;
      final tiltY = galaxy['tiltY'] as double;
      final galaxyColor = galaxy['color'] as Color;

      // Project galaxy center to screen space
      final centerProjected = PainterUtils.project(vp, worldPos, size);
      if (centerProjected == null) continue;

      // Calculate distance-based size scaling (galaxies are very distant)
      final eyeSpace =
          (view * vm.Vector4(worldPos.x, worldPos.y, worldPos.z, 1));
      final dist = (-eyeSpace.z).abs().clamp(
        RenderingConstants.distanceClampMin * 5,
        RenderingConstants.distanceClampMax * 2,
      );

      // Scale galaxy size based on distance
      final projectedSize =
          (galaxySize * RenderingConstants.bodySizeMultiplier / dist).clamp(
            15.0,
            120.0,
          );

      // Calculate perspective effects from 3D rotation
      final perspectiveScale = PainterUtils.calculatePerspectiveScale(
        tiltX,
        tiltY,
      );
      final effectiveSize = projectedSize * perspectiveScale;

      // Draw different galaxy types with 3D rotation
      switch (galaxyType) {
        case 'spiral':
          _drawSpiralGalaxy(
            canvas,
            centerProjected,
            effectiveSize,
            rotation,
            tiltX,
            tiltY,
            galaxyColor,
          );
          break;
        case 'elliptical':
          _drawEllipticalGalaxy(
            canvas,
            centerProjected,
            effectiveSize,
            rotation,
            tiltX,
            tiltY,
            galaxyColor,
          );
          break;
        case 'irregular':
          _drawIrregularGalaxy(
            canvas,
            centerProjected,
            effectiveSize,
            rotation,
            tiltX,
            tiltY,
            galaxyColor,
          );
          break;
      }
    }
  }

  /// Draw a spiral galaxy with 3D rotation effects
  static void _drawSpiralGalaxy(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
    double tiltX,
    double tiltY,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Create 3D transformation matrix for tilt
    final transform = Float64List.fromList([
      math.cos(tiltY),
      -math.sin(tiltX) * math.sin(tiltY),
      0,
      0,
      0,
      math.cos(tiltX),
      0,
      0,
      math.sin(tiltY),
      math.sin(tiltX) * math.cos(tiltY),
      1,
      0,
      0,
      0,
      0,
      1,
    ]);
    canvas.transform(transform);
    canvas.rotate(rotation);

    // Outer glow halo
    final haloSize = size * 1.8;
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: color.a * 0.1),
          color.withValues(alpha: color.a * 0.05),
          AppColors.transparentColor,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: haloSize));
    canvas.drawCircle(Offset.zero, haloSize, haloPaint);

    // Medium glow
    final mediumGlowSize = size * 1.2;
    final mediumGlowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              color.withValues(alpha: color.a * 0.2),
              color.withValues(alpha: color.a * 0.1),
              AppColors.transparentColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: mediumGlowSize),
          );
    canvas.drawCircle(Offset.zero, mediumGlowSize, mediumGlowPaint);

    // Bright core with enhanced brightness
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: math.min(1.0, color.a * 1.5)),
          color.withValues(alpha: color.a * 0.9),
          color.withValues(alpha: color.a * 0.4),
          AppColors.transparentColor,
        ],
        stops: const [0.0, 0.2, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: size * 0.15));
    canvas.drawCircle(Offset.zero, size * 0.15, corePaint);

    // Spiral arms with glow
    for (int arm = 0; arm < 2; arm++) {
      final armAngle = arm * math.pi;
      final path = Path();
      bool first = true;

      for (double t = 0; t <= 2 * math.pi; t += 0.2) {
        final spiralRadius = size * 0.15 + (size * 0.7) * (t / (2 * math.pi));
        final angle = armAngle + t * 2.5; // Tighter spiral
        final x = spiralRadius * math.cos(angle);
        final y = spiralRadius * math.sin(angle);

        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }

      // Draw glow for spiral arms
      final armGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.12 * 2.5
        ..color = color.withValues(alpha: color.a * 0.3)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, armGlowPaint);

      // Draw main spiral arms
      final armPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.12
        ..color = color.withValues(alpha: color.a * 0.8)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, armPaint);
    }

    canvas.restore();
  }

  /// Draw an elliptical galaxy with 3D rotation effects
  static void _drawEllipticalGalaxy(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
    double tiltX,
    double tiltY,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Create 3D transformation matrix for tilt
    final transform = Float64List.fromList([
      math.cos(tiltY),
      -math.sin(tiltX) * math.sin(tiltY),
      0,
      0,
      0,
      math.cos(tiltX),
      0,
      0,
      math.sin(tiltY),
      math.sin(tiltX) * math.cos(tiltY),
      1,
      0,
      0,
      0,
      0,
      1,
    ]);
    canvas.transform(transform);
    canvas.rotate(rotation);

    // Ellipse dimensions
    final width = size;
    final height = size * 0.6; // Elliptical shape

    // Outer halo glow
    final haloWidth = width * 2.0;
    final haloHeight = height * 2.0;
    final haloPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              color.withValues(alpha: color.a * 0.15),
              color.withValues(alpha: color.a * 0.08),
              AppColors.transparentColor,
            ],
            stops: const [0.0, 0.6, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: haloWidth,
              height: haloHeight,
            ),
          );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: haloWidth,
        height: haloHeight,
      ),
      haloPaint,
    );

    // Medium glow
    final mediumWidth = width * 1.4;
    final mediumHeight = height * 1.4;
    final mediumGlowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              color.withValues(alpha: color.a * 0.25),
              color.withValues(alpha: color.a * 0.12),
              AppColors.transparentColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: Offset.zero,
              width: mediumWidth,
              height: mediumHeight,
            ),
          );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: mediumWidth,
        height: mediumHeight,
      ),
      mediumGlowPaint,
    );

    // Main elliptical body with enhanced brightness
    final mainPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              color.withValues(alpha: math.min(1.0, color.a * 1.3)),
              color.withValues(alpha: color.a * 0.8),
              color.withValues(alpha: color.a * 0.3),
              AppColors.transparentColor,
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ).createShader(
            Rect.fromCenter(center: Offset.zero, width: width, height: height),
          );
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: width, height: height),
      mainPaint,
    );

    canvas.restore();
  }

  /// Draw an irregular galaxy with 3D rotation effects
  static void _drawIrregularGalaxy(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
    double tiltX,
    double tiltY,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Create 3D transformation matrix for tilt
    final transform = Float64List.fromList([
      math.cos(tiltY),
      -math.sin(tiltX) * math.sin(tiltY),
      0,
      0,
      0,
      math.cos(tiltX),
      0,
      0,
      math.sin(tiltY),
      math.sin(tiltX) * math.cos(tiltY),
      1,
      0,
      0,
      0,
      0,
      1,
    ]);
    canvas.transform(transform);
    canvas.rotate(rotation);

    // Multiple irregular blobs with glow
    for (int blob = 0; blob < 5; blob++) {
      final blobAngle = (blob / 5.0) * 2 * math.pi;
      final blobDistance = size * (0.2 + 0.4 * math.sin(blob * 1.7));
      final blobSize = size * (0.15 + 0.2 * math.cos(blob * 2.3));

      final blobCenter = Offset(
        math.cos(blobAngle) * blobDistance,
        math.sin(blobAngle) * blobDistance,
      );

      final blobAlpha = color.a * (0.4 + 0.3 * math.sin(blob * 1.1));

      // Outer glow for each blob
      final blobGlowSize = blobSize * 2.2;
      final blobGlowPaint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                color.withValues(alpha: blobAlpha * 0.15),
                color.withValues(alpha: blobAlpha * 0.08),
                AppColors.transparentColor,
              ],
              stops: const [0.0, 0.6, 1.0],
            ).createShader(
              Rect.fromCircle(center: blobCenter, radius: blobGlowSize),
            );
      canvas.drawCircle(blobCenter, blobGlowSize, blobGlowPaint);

      // Medium glow
      final blobMediumGlowSize = blobSize * 1.5;
      final blobMediumGlowPaint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                color.withValues(alpha: blobAlpha * 0.3),
                color.withValues(alpha: blobAlpha * 0.15),
                AppColors.transparentColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(
              Rect.fromCircle(center: blobCenter, radius: blobMediumGlowSize),
            );
      canvas.drawCircle(blobCenter, blobMediumGlowSize, blobMediumGlowPaint);

      // Main blob with enhanced brightness
      final blobPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: math.min(1.0, blobAlpha * 1.4)),
            color.withValues(alpha: blobAlpha * 0.8),
            color.withValues(alpha: blobAlpha * 0.4),
            AppColors.transparentColor,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: blobCenter, radius: blobSize));

      canvas.drawCircle(blobCenter, blobSize, blobPaint);
    }

    canvas.restore();
  }
}
