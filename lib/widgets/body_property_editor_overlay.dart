import 'package:flutter/material.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Overlay that shows property editor icons for selected bodies
class BodyPropertyEditorOverlay extends StatelessWidget {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final int? selectedBodyIndex;
  final VoidCallback? onPropertyIconTapped;

  const BodyPropertyEditorOverlay({
    super.key,
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    this.selectedBodyIndex,
    this.onPropertyIconTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedBodyIndex == null ||
        selectedBodyIndex! < 0 ||
        selectedBodyIndex! >= bodies.length) {
      return const SizedBox.expand();
    }

    final body = bodies[selectedBodyIndex!];
    final screenPos = _projectToScreen(body.position, screenSize);

    if (screenPos == null) {
      return const SizedBox.expand();
    }

    // Position the icon above the body (higher than the label)
    final iconPosition = Offset(
      screenPos.dx, // Centered horizontally with the body
      screenPos.dy - 50, // 50 pixels above body center (well above the label)
    );

    return Stack(
      children: [
        Positioned(
          left: iconPosition.dx - 18, // Icon radius
          top: iconPosition.dy - 18, // Icon radius
          child: GestureDetector(
            onTap: onPropertyIconTapped,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityVeryHigh,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityNearlyOpaque,
                  ),
                  width: AppTypography.borderThick,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.uiCyanAccent.withValues(
                      alpha: AppTypography.opacityFaint,
                    ),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.tune,
                color: AppColors.uiWhite,
                size: AppTypography.iconSizeMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Project a 3D world position to 2D screen coordinates
  Offset? _projectToScreen(vm.Vector3 worldPos, Size screenSize) {
    final mvp = projMatrix * viewMatrix;
    final homogeneousPos = vm.Vector4(worldPos.x, worldPos.y, worldPos.z, 1.0);
    final clipPos = mvp * homogeneousPos;

    // Check if point is in front of camera
    if (clipPos.w <= 0) return null;

    // Convert to normalized device coordinates
    final ndc = vm.Vector3(
      clipPos.x / clipPos.w,
      clipPos.y / clipPos.w,
      clipPos.z / clipPos.w,
    );

    // Check if point is within viewing frustum
    if (ndc.z > 1.0 || ndc.z < -1.0) return null;

    // Convert to screen coordinates
    final screenX = (ndc.x + 1.0) * 0.5 * screenSize.width;
    final screenY = (1.0 - ndc.y) * 0.5 * screenSize.height;

    return Offset(screenX, screenY);
  }
}
