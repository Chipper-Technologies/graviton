import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Custom painter for gradient border
///
/// Paints a rounded rectangle border with a gradient effect using Google brand colors.
/// Used for social authentication buttons to create a rainbow border effect.
class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(AppTypography.radiusLarge),
    );

    final gradient = const LinearGradient(
      colors: [
        AppColors.googleBlue,
        AppColors.googleRed,
        AppColors.googleYellow,
        AppColors.googleGreen,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppTypography.borderThick;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
