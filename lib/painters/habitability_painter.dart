import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering habitable zones and habitability indicators
class HabitabilityPainter {
  /// Draw habitable zones around stars
  static void drawHabitableZones(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    vm.Matrix4 view,
    physics.Simulation sim,
    bool showHabitableZones,
  ) {
    if (!showHabitableZones) return;

    final zones = sim.getHabitableZones();

    for (final zone in zones) {
      final starPos = zone['position'] as vm.Vector3;
      final innerRadius = zone['innerRadius'] as double;
      final outerRadius = zone['outerRadius'] as double;

      final starProjected = PainterUtils.project(vp, starPos, size);
      if (starProjected == null) continue;

      // Sample multiple perpendicular directions to find the maximum apparent radius
      // This ensures consistent zone size regardless of camera rotation direction
      final eyeSpace = (view * vm.Vector4(starPos.x, starPos.y, starPos.z, 1));
      final cameraToStar = vm.Vector3(
        -eyeSpace.x,
        -eyeSpace.y,
        -eyeSpace.z,
      ).normalized();

      // Find two perpendicular vectors to the camera-star direction
      vm.Vector3 perp1, perp2;
      if (cameraToStar.z.abs() < 0.9) {
        perp1 = cameraToStar.cross(vm.Vector3(0, 0, 1)).normalized();
        perp2 = cameraToStar.cross(perp1).normalized();
      } else {
        perp1 = cameraToStar.cross(vm.Vector3(1, 0, 0)).normalized();
        perp2 = cameraToStar.cross(perp1).normalized();
      }

      // Sample multiple directions and use the maximum radius
      double maxInnerRadius = 0;
      double maxOuterRadius = 0;

      for (int i = 0; i < 4; i++) {
        final angle = (i / 4.0) * 2 * 3.14159;
        final direction = perp1 * math.cos(angle) + perp2 * math.sin(angle);

        final innerPoint = starPos + direction * innerRadius;
        final outerPoint = starPos + direction * outerRadius;

        final innerProj = PainterUtils.project(vp, innerPoint, size);
        final outerProj = PainterUtils.project(vp, outerPoint, size);

        if (innerProj != null && outerProj != null) {
          final innerDist = (innerProj - starProjected).distance;
          final outerDist = (outerProj - starProjected).distance;

          maxInnerRadius = math.max(maxInnerRadius, innerDist);
          maxOuterRadius = math.max(maxOuterRadius, outerDist);
        }
      }

      if (maxInnerRadius == 0 || maxOuterRadius == 0) continue;

      final projectedInnerRadius = maxInnerRadius;
      final projectedOuterRadius = maxOuterRadius;

      // Create gradient for habitable zone (green center fading to transparent)
      final habitableGradient = RadialGradient(
        center: Alignment.center,
        stops: const [0.0, 0.7, 1.0],
        colors: [
          AppColors.habitabilityHabitable.withValues(
            alpha: AppTypography.opacityFaint,
          ), // More opaque center
          AppColors.habitabilityHabitable.withValues(
            alpha: AppTypography.opacityMidFade,
          ), // Mid fade
          AppColors.habitabilityHabitable.withValues(
            alpha: AppTypography.opacityTransparent,
          ), // Transparent edge
        ],
      );

      // Draw habitable zone with gradient fill
      final habitableRect = Rect.fromCircle(
        center: starProjected,
        radius: projectedOuterRadius,
      );
      final habitableZoneFill = Paint()
        ..shader = habitableGradient.createShader(habitableRect)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..addOval(
          Rect.fromCircle(center: starProjected, radius: projectedOuterRadius),
        )
        ..addOval(
          Rect.fromCircle(center: starProjected, radius: projectedInnerRadius),
        );
      path.fillType = PathFillType.evenOdd;

      canvas.drawPath(path, habitableZoneFill);

      // Inner boundary (too hot zone) with gradient
      final hotGradient = RadialGradient(
        center: Alignment.center,
        stops: const [0.0, 0.8, 1.0],
        colors: [
          AppColors.habitabilityTooHot.withValues(
            alpha: AppTypography.opacityLowMedium,
          ),
          AppColors.habitabilityTooHot.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          AppColors.habitabilityTooHot.withValues(
            alpha: AppTypography.opacityTransparent,
          ),
        ],
      );

      final hotRect = Rect.fromCircle(
        center: starProjected,
        radius: projectedInnerRadius,
      );
      final hotZoneFill = Paint()
        ..shader = hotGradient.createShader(hotRect)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(starProjected, projectedInnerRadius, hotZoneFill);

      // Zone boundary lines (more subtle)
      final innerBoundaryPaint = Paint()
        ..color = AppColors.habitabilityTooHot.withValues(
          alpha: AppTypography.opacityFaint,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final outerBoundaryPaint = Paint()
        ..color = AppColors.habitabilityTooCold.withValues(
          alpha: AppTypography.opacityFaint,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Draw boundary circles
      canvas.drawCircle(
        starProjected,
        projectedInnerRadius,
        innerBoundaryPaint,
      );
      canvas.drawCircle(
        starProjected,
        projectedOuterRadius,
        outerBoundaryPaint,
      );
    }
  }

  /// Draw habitability indicator around a planet with star-like fading gradient
  static void drawHabitabilityIndicator(
    Canvas canvas,
    Offset center,
    double bodyRadius,
    Body body,
    bool showHabitabilityIndicators,
  ) {
    if (!showHabitabilityIndicators || body.bodyType != BodyType.planet) return;

    final statusColor = Color(body.habitabilityStatus.statusColor);
    final indicatorRadius =
        bodyRadius * 4.0; // Much wider radius for more visibility

    // Star-like radial gradient that fades out to transparent - brighter and more visible
    final habitabilityGlow = RadialGradient(
      colors: [
        statusColor.withValues(
          alpha: AppTypography.opacityNearlyOpaque,
        ), // Very bright center
        statusColor.withValues(
          alpha: AppTypography.opacityHigh,
        ), // Bright middle
        statusColor.withValues(
          alpha: AppTypography.opacitySemiTransparent,
        ), // Middle fade
        statusColor.withValues(
          alpha: AppTypography.opacityDisabled,
        ), // Outer fade
        AppColors.transparentColor, // Complete fade to transparent
      ],
      stops: const [
        0.0,
        0.2,
        0.5,
        0.8,
        1.0,
      ], // More gradient steps for smoother fade
    );

    // Draw the main glow effect
    final glowRect = Rect.fromCircle(center: center, radius: indicatorRadius);
    canvas.drawCircle(
      center,
      indicatorRadius,
      Paint()..shader = habitabilityGlow.createShader(glowRect),
    );

    // Add multiple border rings for more definition and visibility
    final innerBorderPaint = Paint()
      ..color = statusColor.withValues(alpha: AppTypography.opacityMediumHigh)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, indicatorRadius * 0.7, innerBorderPaint);

    final outerBorderPaint = Paint()
      ..color = statusColor.withValues(
        alpha: AppTypography.opacitySemiTransparent,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, indicatorRadius * 0.9, outerBorderPaint);

    // Enhanced pulse effect for habitable planets
    if (body.habitabilityStatus == HabitabilityStatus.habitable) {
      final pulseRadius1 = indicatorRadius * 1.15;
      final pulse1Paint = Paint()
        ..color = statusColor.withValues(alpha: AppTypography.opacityFaint)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, pulseRadius1, pulse1Paint);

      final pulseRadius2 = indicatorRadius * 1.3;
      final pulse2Paint = Paint()
        ..color = statusColor.withValues(alpha: AppTypography.opacityVeryFaint)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, pulseRadius2, pulse2Paint);
    }
  }
}
