import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering visual effects like merge flashes and explosions
class EffectsPainter {
  /// Draw merge flashes from body collisions
  static void drawMergeFlashes(Canvas canvas, Size size, vm.Matrix4 vp, physics.Simulation sim) {
    // Flashes (draw before bodies so glow looks integrated)
    for (final flash in sim.mergeFlashes) {
      final p = PainterUtils.project(vp, flash.position, size);
      if (p == null) continue;

      final t = (flash.age / SimulationConstants.flashDuration).clamp(0.0, 1.0);
      final alpha = math.exp(-SimulationConstants.flashExpDecay * t);
      final radius = SimulationConstants.flashInitialRadius + SimulationConstants.flashMaxRadius * t;

      final shader = RadialGradient(
        colors: [
          flash.color.withValues(alpha: SimulationConstants.flashInitialAlpha * alpha),
          flash.color.withValues(alpha: AppTypography.opacityTransparent),
        ],
      ).createShader(Rect.fromCircle(center: p, radius: radius));

      canvas.drawCircle(p, radius, Paint()..shader = shader);
    }
  }
}
