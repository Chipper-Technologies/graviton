import 'package:flutter/material.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Overlay widget that displays camera visual aids
class CameraVisualAidsOverlay extends StatelessWidget {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final int? selectedBodyIndex;
  final double cameraDistance;
  final bool showCrosshairs;

  const CameraVisualAidsOverlay({
    super.key,
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    required this.selectedBodyIndex,
    required this.cameraDistance,
    required this.showCrosshairs,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Crosshairs
        if (showCrosshairs) _buildCrosshairs(),
      ],
    );
  }

  Widget _buildCrosshairs() {
    return Positioned.fill(child: CustomPaint(painter: CrosshairsPainter()));
  }
}

/// Custom painter for drawing crosshairs
class CrosshairsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primaryColor.withValues(
        alpha: AppTypography.opacityMedium,
      )
      ..strokeWidth = AppTypography.borderMedium
      ..style = PaintingStyle.stroke;

    // Crosshair lines
    const lineLength = 20.0;
    const gap = 8.0;

    // Horizontal lines
    canvas.drawLine(
      Offset(center.dx - lineLength - gap, center.dy),
      Offset(center.dx - gap, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + gap, center.dy),
      Offset(center.dx + lineLength + gap, center.dy),
      paint,
    );

    // Vertical lines
    canvas.drawLine(
      Offset(center.dx, center.dy - lineLength - gap),
      Offset(center.dx, center.dy - gap),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + gap),
      Offset(center.dx, center.dy + lineLength + gap),
      paint,
    );

    // Center dot
    canvas.drawCircle(
      center,
      2.0,
      Paint()
        ..color = AppColors.primaryColor.withValues(
          alpha: AppTypography.opacityHigh,
        )
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
