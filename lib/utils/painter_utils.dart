import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Utility methods for 3D projection and common painting operations
class PainterUtils {
  /// Projects a 3D point to 2D screen coordinates
  static Offset? project(vm.Matrix4 vp, vm.Vector3 p, Size size) {
    final clip = vp * vm.Vector4(p.x, p.y, p.z, 1);
    if (clip.w <= 0) return null;
    final ndc = vm.Vector2(clip.x / clip.w, clip.y / clip.w);
    return Offset((ndc.x + 1) * size.width * 0.5, (1 - ndc.y) * size.height * 0.5);
  }

  /// Gets the clip-space z coordinate for depth sorting
  static double clipZ(vm.Matrix4 vp, vm.Vector3 p) {
    final clip = vp * vm.Vector4(p.x, p.y, p.z, 1);
    return clip.w > 0 ? clip.z / clip.w : double.infinity;
  }

  /// Calculates perspective scaling based on tilt angles
  static double calculatePerspectiveScale(double tiltX, double tiltY) {
    // Simulate perspective foreshortening based on viewing angle
    return math.cos(tiltX * 0.5) * math.cos(tiltY * 0.5);
  }

  /// Creates a radial gradient shader for glowing effects
  static Paint createGlowPaint({
    required Color color,
    required Offset center,
    required double radius,
    double coreAlpha = 1.0,
    double edgeAlpha = 0.0,
    List<double>? stops,
  }) {
    return Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: coreAlpha),
          color.withValues(alpha: edgeAlpha),
        ],
        stops: stops ?? [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a multi-stop radial gradient for complex glow effects
  static Paint createMultiStopGlowPaint({
    required List<Color> colors,
    required List<double> stops,
    required Offset center,
    required double radius,
  }) {
    assert(colors.length == stops.length, 'Colors and stops must have the same length');
    return Paint()
      ..shader = RadialGradient(
        colors: colors,
        stops: stops,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
  }
}
