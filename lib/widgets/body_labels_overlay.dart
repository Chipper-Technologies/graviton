import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/enums/celestial_body_name.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Overlay widget that displays labels for celestial bodies
class BodyLabelsOverlay extends StatelessWidget {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final Size screenSize;
  final AppLocalizations? l10n;

  const BodyLabelsOverlay({
    super.key,
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    required this.screenSize,
    this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BodyLabelsPainter(
        bodies: bodies,
        viewMatrix: viewMatrix,
        projMatrix: projMatrix,
        l10n: l10n,
      ),
      size: screenSize,
    );
  }
}

class _BodyLabelsPainter extends CustomPainter {
  final List<Body> bodies;
  final vm.Matrix4 viewMatrix;
  final vm.Matrix4 projMatrix;
  final AppLocalizations? l10n;

  _BodyLabelsPainter({
    required this.bodies,
    required this.viewMatrix,
    required this.projMatrix,
    this.l10n,
  });

  /// Translate a stored body name to the current localized name
  String _getLocalizedBodyName(String storedName) {
    if (l10n == null) return storedName;

    // Try to find a matching enum value
    final bodyEnum = CelestialBodyName.fromString(storedName);
    if (bodyEnum != null) {
      // Handle numbered bodies like "Asteroid 1"
      final RegExp numberedPattern = RegExp(r'^(\w+(?:\s+\w+)*)\s+(\d+)$');
      final match = numberedPattern.firstMatch(storedName);
      if (match != null) {
        final number = int.tryParse(match.group(2)!);
        if (number != null) {
          return bodyEnum.getNumberedLocalizedName(l10n, number);
        }
      }

      // Regular body name
      return bodyEnum.getLocalizedName(l10n);
    }

    // Handle special cases that don't have enums yet
    switch (storedName) {
      case 'Rocky Planet':
        return l10n!.bodyRockyPlanet;
      case 'Ringed Planet':
        return l10n!.bodyRingedPlanet;
      default:
        return storedName; // Fallback to original name
    }
  }

  /// Project 3D world position to 2D screen coordinates
  Offset? _project(vm.Vector3 worldPos, Size size) {
    final viewPos = viewMatrix.transformed3(worldPos);
    if (viewPos.z > -RenderingConstants.projectionClipZThreshold) {
      return null; // Behind camera
    }

    final clipPos = projMatrix.transformed3(viewPos);
    if (clipPos.z.abs() < RenderingConstants.projectionClipZThreshold) {
      return null; // Too close to camera
    }

    final ndc = clipPos / clipPos.z;
    if (ndc.x.abs() > 2.0 || ndc.y.abs() > 2.0) {
      return null; // Outside view frustum
    }

    final screenX =
        (ndc.x * RenderingConstants.ndcTransformOffset +
            RenderingConstants.ndcTransformOffset) *
        size.width;

    final screenY =
        (-ndc.y * RenderingConstants.ndcTransformOffset +
            RenderingConstants.ndcTransformOffset) *
        size.height;

    return Offset(screenX, screenY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: AppColors.uiWhite.withValues(
        alpha: AppTypography.opacityNearlyOpaque,
      ),
      fontSize: AppTypography.fontSizeSmall,
      fontWeight: FontWeight.w500,
      shadows: AppTypography.createTextShadow(
        color: AppColors.uiBlack,
        opacity: AppTypography.opacityVeryHigh,
      ),
    );

    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i];
      final screenPos = _project(body.position, size);

      if (screenPos == null) continue;

      // Offset label position slightly to avoid overlapping with the body
      final labelOffset = Offset(
        screenPos.dx + 15, // Offset to the right
        screenPos.dy - 10, // Offset upward
      );

      // Get the localized name for the body
      final localizedName = _getLocalizedBodyName(body.name);

      // Create text painter
      final textPainter = TextPainter(
        text: TextSpan(text: localizedName, style: textStyle),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Draw background box for better readability
      final backgroundRect = Rect.fromLTWH(
        labelOffset.dx - 3,
        labelOffset.dy - 2,
        textPainter.width + 6,
        textPainter.height + 4,
      );

      final backgroundPaint = Paint()
        ..color = AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityMediumHigh,
        )
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(backgroundRect, const Radius.circular(3)),
        backgroundPaint,
      );

      // Draw the text
      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint since bodies are moving
  }
}
