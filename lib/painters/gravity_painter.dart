import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering gravity wells and gravitational field visualization
class GravityPainter {
  /// Draw gravity wells showing gravitational field strength around objects
  static void drawGravityWells(Canvas canvas, Size size, vm.Matrix4 vp, physics.Simulation sim, bool showGravityWells) {
    if (!showGravityWells) return;

    for (int i = 0; i < sim.bodies.length; i++) {
      final body = sim.bodies[i];
      final center = PainterUtils.project(vp, body.position, size);
      if (center == null) continue;

      // Calculate well depth based on mass (more massive = deeper well)
      final wellDepth = math.log(body.mass + 1) * 20.0; // Logarithmic scaling
      final maxRadius = wellDepth * 3.0;

      // Draw concentric circles representing gravitational field strength
      const int ringCount = 8;
      for (int ring = ringCount; ring > 0; ring--) {
        final ringRadius = (ring / ringCount) * maxRadius;

        // Calculate field strength at this distance (inverse square law)
        final distance = ringRadius / 20.0; // Scale for visual purposes
        final fieldStrength = body.mass / (distance * distance + 1.0); // Add 1 to avoid division by zero

        // Normalize field strength for alpha calculation
        final normalizedStrength = (fieldStrength / (body.mass + 1.0)).clamp(0.0, 1.0);
        final alpha = (normalizedStrength * 0.4 * (ring / ringCount)).clamp(0.02, 0.3);

        // Color based on object type and field strength
        Color wellColor;
        if (body.bodyType == BodyType.star) {
          wellColor = AppColors.gravityWellYellow.withValues(alpha: alpha);
        } else {
          wellColor = AppColors.gravityWellBlue.withValues(alpha: alpha);
        }

        // Draw the field ring
        final ringPaint = Paint()
          ..color = wellColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawCircle(center, ringRadius, ringPaint);
      }

      // Draw grid pattern to show space-time curvature
      if (body.mass > 10.0) {
        // Only for massive objects
        _drawGravityGrid(canvas, center, body, maxRadius);
      }
    }
  }

  /// Draw a subtle grid pattern to show space-time curvature around massive objects
  static void _drawGravityGrid(Canvas canvas, Offset center, Body body, double maxRadius) {
    const int gridLines = 6;
    final gridSpacing = maxRadius / gridLines;

    final gridPaint = Paint()
      ..color = body.bodyType == BodyType.star
          ? AppColors.gravityWellYellow.withValues(alpha: AppTypography.opacityDisabled)
          : AppColors.gravityWellCyan.withValues(alpha: AppTypography.opacityDisabled)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw curved grid lines that bend toward the massive object
    for (int i = -gridLines; i <= gridLines; i++) {
      if (i == 0) continue; // Skip the center line

      final baseOffset = i * gridSpacing;

      // Vertical curved lines
      final path1 = Path();
      for (double t = -maxRadius; t <= maxRadius; t += 5.0) {
        final x = center.dx + baseOffset;

        // Bend the line toward the massive object based on distance
        final distanceFromCenter = math.sqrt(baseOffset * baseOffset + t * t);
        final curvature = (body.mass / (distanceFromCenter + 20.0)) * 0.3;
        final bentX = x - (baseOffset > 0 ? 1 : -1) * curvature;
        final y = center.dy + t;

        if (t == -maxRadius) {
          path1.moveTo(bentX, y);
        } else {
          path1.lineTo(bentX, y);
        }
      }

      canvas.drawPath(path1, gridPaint);

      // Horizontal curved lines
      final path2 = Path();
      for (double t = -maxRadius; t <= maxRadius; t += 5.0) {
        final y = center.dy + baseOffset;

        // Bend the line toward the massive object
        final distanceFromCenter = math.sqrt(t * t + baseOffset * baseOffset);
        final curvature = (body.mass / (distanceFromCenter + 20.0)) * 0.3;
        final bentY = y - (baseOffset > 0 ? 1 : -1) * curvature;
        final x = center.dx + t;

        if (t == -maxRadius) {
          path2.moveTo(x, bentY);
        } else {
          path2.lineTo(x, bentY);
        }
      }

      canvas.drawPath(path2, gridPaint);
    }
  }
}
