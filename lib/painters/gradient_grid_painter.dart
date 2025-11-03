import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';

/// Custom painter for creating a gradient grid background that fades out to the bottom
class GradientGridPainter extends CustomPainter {
  final double gridSize;
  final Color gridColor;
  final double opacity;

  const GradientGridPainter({
    this.gridSize = 20.0,
    this.gridColor = AppColors.uiWhite,
    this.opacity = 0.1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // Increased stroke width for better visibility

    // Create vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      // Calculate fade based on distance from bottom - simple linear fade
      final fadeGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gridColor.withValues(alpha: opacity),
          gridColor.withValues(alpha: opacity * 0.3),
          gridColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      );

      paint.shader = fadeGradient.createShader(
        Rect.fromLTWH(x, 0, 1, size.height),
      );

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Create horizontal lines with same fade approach
    for (double y = 0; y <= size.height; y += gridSize) {
      // Calculate fade based on distance from bottom
      final distanceFromBottom = size.height - y;
      final fadeRatio = (distanceFromBottom / size.height).clamp(0.0, 1.0);

      // Simple fade to transparent
      double lineOpacity;
      if (fadeRatio > 0.6) {
        lineOpacity = opacity;
      } else if (fadeRatio > 0.0) {
        lineOpacity = opacity * (fadeRatio / 0.6) * 0.3;
      } else {
        lineOpacity = 0.0;
      }

      paint.shader = null;
      paint.color = gridColor.withValues(alpha: lineOpacity);

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is GradientGridPainter) {
      return oldDelegate.gridSize != gridSize ||
          oldDelegate.gridColor != gridColor ||
          oldDelegate.opacity != opacity;
    }
    return true;
  }
}
