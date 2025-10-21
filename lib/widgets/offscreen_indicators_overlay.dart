import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Overlay that shows arrows pointing to off-screen bodies
class OffScreenIndicatorsOverlay extends StatelessWidget {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final int? selectedBodyIndex;

  const OffScreenIndicatorsOverlay({
    super.key,
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    this.selectedBodyIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OffScreenIndicatorPainter(
        bodies: bodies,
        viewMatrix: viewMatrix,
        projMatrix: projMatrix,
        screenSize: screenSize,
        selectedBodyIndex: selectedBodyIndex,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _OffScreenIndicatorPainter extends CustomPainter {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final int? selectedBodyIndex;

  _OffScreenIndicatorPainter({
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    this.selectedBodyIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final mvp = projMatrix * viewMatrix;

    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      final worldPos = vm.Vector4(body.position.x, body.position.y, body.position.z, 1.0);
      final clipPos = mvp * worldPos;

      // Skip if behind camera
      if (clipPos.w <= 0) continue;

      // Convert to normalized device coordinates
      final ndc = vm.Vector3(clipPos.x / clipPos.w, clipPos.y / clipPos.w, clipPos.z / clipPos.w);

      // Convert to screen coordinates
      final screenX = (ndc.x + 1) * 0.5 * size.width;
      final screenY = (1 - ndc.y) * 0.5 * size.height;

      // Check if object is off-screen
      final isOffScreen =
          screenX < 0 || screenX > size.width || screenY < 0 || screenY > size.height || ndc.z > 1.0; // Too far away

      if (isOffScreen) {
        _drawOffScreenIndicator(canvas, size, screenX, screenY, body, i == selectedBodyIndex);
      }
    }
  }

  void _drawOffScreenIndicator(
    Canvas canvas,
    Size size,
    double worldScreenX,
    double worldScreenY,
    Body body,
    bool isSelected,
  ) {
    // Calculate direction to off-screen object
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;

    final dirX = worldScreenX - centerX;
    final dirY = worldScreenY - centerY;
    final distance = math.sqrt(dirX * dirX + dirY * dirY);

    if (distance == 0) return;

    // Normalize direction
    final normalizedX = dirX / distance;
    final normalizedY = dirY / distance;

    // Calculate position on screen edge
    final margin = 40.0;
    final maxX = size.width - margin;
    final maxY = size.height - margin;

    // Find intersection with screen bounds
    double indicatorX, indicatorY;

    // Calculate where the direction vector hits the screen bounds
    final tX = normalizedX > 0 ? (maxX - centerX) / normalizedX : (margin - centerX) / normalizedX;
    final tY = normalizedY > 0 ? (maxY - centerY) / normalizedY : (margin - centerY) / normalizedY;

    final t = math.min(tX.abs(), tY.abs());

    indicatorX = centerX + normalizedX * t;
    indicatorY = centerY + normalizedY * t;

    // Clamp to screen bounds
    indicatorX = indicatorX.clamp(margin, size.width - margin);
    indicatorY = indicatorY.clamp(margin, size.height - margin);

    // Draw the arrow
    _drawArrow(canvas, Offset(indicatorX, indicatorY), normalizedX, normalizedY, body, isSelected);
  }

  void _drawArrow(Canvas canvas, Offset position, double dirX, double dirY, Body body, bool isSelected) {
    final baseColor = isSelected ? AppColors.uiSelectionYellow : _getBodyColor(body);

    // Special handling for black hole - use dark gray with white border for visibility
    final circleColor = body.name == 'Black Hole' && !isSelected ? AppColors.offScreenBlackHole : baseColor;

    final paint = Paint()
      ..color = circleColor
          .withValues(alpha: AppTypography.opacityHigh) // Make the background more opaque
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
            ? AppColors.uiWhite.withValues(alpha: AppTypography.opacityNearlyOpaque)
            : AppColors.uiWhite.withValues(alpha: AppTypography.opacityMediumHigh)
        ..strokeWidth = 2.0,
    );

    // Calculate arrow points
    final arrowLength = 8.0;
    final arrowWidth = 6.0;

    final tipX = position.dx + dirX * arrowLength * 0.5;
    final tipY = position.dy + dirY * arrowLength * 0.5;

    final baseX = position.dx - dirX * arrowLength * 0.5;
    final baseY = position.dy - dirY * arrowLength * 0.5;

    // Perpendicular vector for arrow wings
    final perpX = -dirY;
    final perpY = dirX;

    final path = Path()
      ..moveTo(tipX, tipY)
      ..lineTo(baseX + perpX * arrowWidth * 0.5, baseY + perpY * arrowWidth * 0.5)
      ..lineTo(baseX - perpX * arrowWidth * 0.5, baseY - perpY * arrowWidth * 0.5)
      ..close();

    // Draw arrow
    canvas.drawPath(
      path,
      paint
        ..color = AppColors.uiWhite.withValues(alpha: AppTypography.opacityNearlyOpaque)
        ..style = PaintingStyle.fill,
    );
  }

  Color _getBodyColor(Body body) {
    // Match the exact colors used in CelestialBodyPainter
    switch (body.name) {
      case 'Black Hole':
        return AppColors.uiBlack;
      case 'Sun':
        return AppColors.offScreenSun; // Gold
      case 'Mercury':
        return AppColors.offScreenMercury; // Brownish gray
      case 'Venus':
        return AppColors.offScreenVenus; // Yellowish
      case 'Earth':
        return AppColors.offScreenEarth; // Blue
      case 'Mars':
        return AppColors.offScreenMars; // Red
      case 'Jupiter':
        return AppColors.offScreenJupiter; // Tan/beige
      case 'Saturn':
        return AppColors.offScreenSaturn; // Light gold
      case 'Uranus':
        return AppColors.offScreenUranus; // Light blue
      case 'Neptune':
        return AppColors.offScreenNeptune; // Deep blue
      default:
        // Use the body's default color property for other objects
        return body.color;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
