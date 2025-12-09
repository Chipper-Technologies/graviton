import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Custom painter for highlighting tutorial areas
class HighlightPainter extends CustomPainter {
  final Rect highlightArea;

  HighlightPainter(this.highlightArea);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.uiWhite.withValues(alpha: AppTypography.opacitySubtle)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        highlightArea,
        const Radius.circular(AppTypography.radiusMedium),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
