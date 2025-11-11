import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/indicator_data.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/color_utils.dart';

/// Custom painter for rendering offscreen body indicators
///
/// This painter draws circular indicators with directional arrows
/// that point towards offscreen celestial bodies. The indicators
/// include the body's color, selection state, and name label.
class IndicatorPainter extends CustomPainter {
  /// The indicator data containing body information and positioning
  final IndicatorData indicator;

  /// Whether this indicator represents a selected body
  final bool isSelected;

  const IndicatorPainter({required this.indicator, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _drawArrow(
      canvas,
      center,
      indicator.direction.x,
      indicator.direction.y,
      indicator.body,
      isSelected,
    );
  }

  /// Draws the indicator arrow pointing in the direction of the offscreen body
  void _drawArrow(
    Canvas canvas,
    Offset position,
    double dirX,
    double dirY,
    Body body,
    bool isSelected,
  ) {
    final baseColor = isSelected
        ? AppColors.uiSelectionYellow
        : ColorUtils.getBodyColor(body);

    // Special handling for black hole - use dark gray with white border for visibility
    final bodyEnum = CelestialBodyName.fromString(body.name);
    final circleColor = bodyEnum?.isBlackHole == true && !isSelected
        ? AppColors.offScreenBlackHole
        : baseColor;

    final paint = Paint()
      ..color = circleColor
          .withValues(
            alpha: AppTypography.opacityHigh,
          ) // Make the background more opaque
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // Draw circle background
    canvas.drawCircle(position, 15, paint..style = PaintingStyle.fill);

    // Draw border
    canvas.drawCircle(
      position,
      15,
      paint
        ..style = PaintingStyle.stroke
        ..color = isSelected
            ? AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityNearlyOpaque,
              )
            : AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMediumHigh,
              )
        ..strokeWidth = 2.0,
    );

    // Calculate arrow points
    const arrowLength = 8.0;
    const arrowWidth = 6.0;

    final tipX = position.dx + dirX * arrowLength * 0.5;
    final tipY = position.dy + dirY * arrowLength * 0.5;

    final baseX = position.dx - dirX * arrowLength * 0.5;
    final baseY = position.dy - dirY * arrowLength * 0.5;

    // Perpendicular vector for arrow wings
    final perpX = -dirY;
    final perpY = dirX;

    final path = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(
        baseX + perpX * arrowWidth * 0.5,
        baseY + perpY * arrowWidth * 0.5,
      )
      ..lineTo(
        baseX - perpX * arrowWidth * 0.5,
        baseY - perpY * arrowWidth * 0.5,
      )
      ..close();

    // Draw arrow
    canvas.drawPath(
      path,
      paint
        ..color = AppColors.uiWhite.withValues(
          alpha: AppTypography.opacityNearlyOpaque,
        )
        ..style = PaintingStyle.fill,
    );

    // Draw body name
    _drawBodyName(canvas, position, _formatBodyName(body), isSelected);
  }

  /// Formats body name for display, showing "Planet+Moon" for moons
  String _formatBodyName(Body body) {
    if (body.bodyType == BodyType.moon) {
      // For moons, try to show the parent planet name if available
      // Note: In this context we don't have access to all bodies,
      // so we just use the moon name. The parent logic would need
      // to be handled at the widget level.
      return body.name;
    }

    return body.name;
  }

  /// Draws the body name label below the indicator
  void _drawBodyName(
    Canvas canvas,
    Offset position,
    String bodyName,
    bool isSelected,
  ) {
    final textStyle = TextStyle(
      color: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      fontSize: AppTypography.fontSizeSmall,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      shadows: [
        Shadow(
          offset: const Offset(1, 1),
          blurRadius: 2,
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityMediumHigh,
          ),
        ),
      ],
    );

    final textPainter = TextPainter(
      text: TextSpan(text: bodyName, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Position text below the indicator circle
    final textOffset = Offset(
      position.dx - textPainter.width / 2,
      position.dy + 20, // 15 (circle radius) + 5 (spacing)
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter oldDelegate) {
    return indicator != oldDelegate.indicator ||
        isSelected != oldDelegate.isSelected;
  }
}
