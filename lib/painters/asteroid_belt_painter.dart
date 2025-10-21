import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/services/asteroid_belt_system.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter for rendering asteroid belt particles
class AsteroidBeltPainter {
  AsteroidBeltPainter._(); // Private constructor

  /// Draw asteroid belt particles
  static void drawAsteroidBelt(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    AsteroidBeltSystem asteroidBelt,
    bool showAsteroidBelt,
  ) {
    if (!showAsteroidBelt || asteroidBelt.particleCount == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    int rendered = 0;
    const maxRenderDistance = 2000.0; // Increased to render Kuiper belt at proper distance

    for (final particle in asteroidBelt.particles) {
      final worldPos = particle.position;

      // Skip particles that are too far away
      final distanceFromOrigin = worldPos.length;
      if (distanceFromOrigin > maxRenderDistance) continue;

      // Project to screen space
      final screenPos = PainterUtils.project(vp, worldPos, size);
      if (screenPos == null) continue;

      // Calculate size based on distance (perspective effect)
      // Use different scaling for very distant objects (Kuiper belt)
      final perspectiveScale = distanceFromOrigin > 800
          ? math.max(0.3, 500.0 / (distanceFromOrigin + 100.0)) // Better scaling for Kuiper belt
          : math.max(0.1, 100.0 / (distanceFromOrigin + 50.0)); // Original scaling for asteroid belt
      final renderSize = particle.size * perspectiveScale * 15.0; // Increase multiplier for better visibility

      // Skip tiny particles for performance (but be more lenient for debugging)
      if (renderSize < 0.05) {
        continue; // Very low threshold to see more particles
      }

      // Set color with slight alpha for depth effect
      paint.color = particle.color.withValues(alpha: AppTypography.opacityVeryHigh);

      // Draw particle as a small circle
      canvas.drawCircle(screenPos, renderSize, paint);

      rendered++;

      // Limit rendering count for performance
      if (rendered > 1500) break; // Render max 1500 particles per frame
    }
  }
}
