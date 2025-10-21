import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering body trails and motion history
class TrailPainter {
  /// Draw trails for all bodies in the simulation
  static void drawTrails(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
    bool showTrails,
    bool useWarmTrails,
  ) {
    if (!showTrails) return;

    for (int i = 0; i < sim.bodies.length && i < sim.trails.length; i++) {
      final bodyColor = sim.bodies[i].color;
      final hueTarget = useWarmTrails ? AppColors.uiOrangeAccent : AppColors.uiLightBlueAccent;
      final pts = sim.trails[i];

      for (int k = 1; k < pts.length; k++) {
        final a = pts[k - 1];
        final b = pts[k];
        final pa = PainterUtils.project(vp, a.pos, size);
        final pb = PainterUtils.project(vp, b.pos, size);
        if (pa == null || pb == null) continue;

        final alpha = math.min(a.alpha, b.alpha);

        Color color;
        if (sim.currentScenario == ScenarioType.galaxyFormation) {
          // For galaxy formation, calculate dynamic color based on trail segment distance from black hole
          final segmentPos = (a.pos + b.pos) * 0.5; // Midpoint of trail segment
          final distanceFromCenter = segmentPos.length;

          // Use same color progression as stars: green -> yellow -> orange -> red
          Color segmentColor;
          if (distanceFromCenter > 120.0) {
            segmentColor = AppColors.uiGreen;
          } else if (distanceFromCenter > 80.0) {
            final t = (120.0 - distanceFromCenter) / 40.0;
            segmentColor = Color.lerp(AppColors.uiGreen, AppColors.uiYellow, t) ?? AppColors.uiYellow;
          } else if (distanceFromCenter > 50.0) {
            final t = (80.0 - distanceFromCenter) / 30.0;
            segmentColor = Color.lerp(AppColors.uiYellow, AppColors.uiOrange, t) ?? AppColors.uiOrange;
          } else {
            final t = math.min(1.0, (50.0 - distanceFromCenter) / 50.0);
            segmentColor = Color.lerp(AppColors.uiOrange, AppColors.uiRed, t) ?? AppColors.uiRed;
          }

          color = segmentColor.withValues(alpha: alpha);
        } else {
          color = Color.lerp(bodyColor, hueTarget, 1.0 - alpha)!.withValues(alpha: alpha);
        }

        final p = Paint()
          ..color = color
          ..strokeWidth = SimulationConstants.trailStrokeWidth
          ..style = PaintingStyle.stroke;

        canvas.drawLine(pa, pb, p);
      }
    }
  }
}
