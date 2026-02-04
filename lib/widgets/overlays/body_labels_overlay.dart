import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/localization_utils.dart';
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

  /// Project 3D world position to 2D screen coordinates
  /// Returns screen position, z-depth (for sorting), and screen radius, or null if not visible
  ({Offset screenPos, double zDepth, double screenRadius})? _projectBody(
    Body body,
    Size size,
  ) {
    final viewPos = viewMatrix.transformed3(body.position);
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

    // Calculate screen radius by projecting a point offset by the body's radius
    // Use the body's radius in world space to determine screen radius
    final edgePos = body.position + vm.Vector3(body.radius, 0, 0);
    final edgeViewPos = viewMatrix.transformed3(edgePos);
    final edgeClipPos = projMatrix.transformed3(edgeViewPos);

    double screenRadius = 0;
    if (edgeClipPos.z.abs() > RenderingConstants.projectionClipZThreshold) {
      final edgeNdc = edgeClipPos / edgeClipPos.z;
      final edgeScreenX =
          (edgeNdc.x * RenderingConstants.ndcTransformOffset +
              RenderingConstants.ndcTransformOffset) *
          size.width;
      screenRadius = (edgeScreenX - screenX).abs();
    }

    // Return screen position, z-depth, and screen radius
    return (
      screenPos: Offset(screenX, screenY),
      zDepth: viewPos.z,
      screenRadius: screenRadius,
    );
  }

  /// Check if a body is occluded by any closer body.
  ///
  /// Returns true if the body's center is within another closer body's
  /// projected disc.
  ///
  /// **Performance Note:** This uses an O(n) check against already-processed
  /// closer bodies, resulting in O(n²) overall complexity for the full
  /// occlusion pass. This is acceptable for typical scenarios (10-50 bodies).
  /// If body counts grow significantly (100+), consider optimizing with
  /// spatial partitioning (e.g., a simple grid or quadtree) to reduce the
  /// number of distance checks per body.
  bool _isOccluded(
    ({Offset screenPos, double zDepth, double screenRadius}) target,
    List<({Body body, Offset screenPos, double zDepth, double screenRadius})>
    closerBodies,
  ) {
    for (final occluder in closerBodies) {
      // Check if target's center is within occluder's disc
      final dx = target.screenPos.dx - occluder.screenPos.dx;
      final dy = target.screenPos.dy - occluder.screenPos.dy;
      final distance = math.sqrt(dx * dx + dy * dy);

      // Use a slightly smaller radius to avoid hiding labels at the edge
      final occlusionRadius =
          occluder.screenRadius *
          RenderingConstants.bodyOcclusionRadiusMultiplier;

      if (distance < occlusionRadius) {
        return true; // Occluded
      }
    }
    return false;
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

    // Build list of visible bodies with their screen positions, z-depths, and radii
    final visibleBodies =
        <({Body body, Offset screenPos, double zDepth, double screenRadius})>[];

    for (final body in bodies) {
      final projection = _projectBody(body, size);
      if (projection != null) {
        visibleBodies.add((
          body: body,
          screenPos: projection.screenPos,
          zDepth: projection.zDepth,
          screenRadius: projection.screenRadius,
        ));
      }
    }

    // Sort by z-depth: closest first (less negative z = closer to camera)
    // We need closest first so we can check occlusion against closer bodies
    visibleBodies.sort((a, b) => b.zDepth.compareTo(a.zDepth));

    // Track which bodies to actually draw labels for (not occluded)
    final labelsToShow =
        <({Body body, Offset screenPos, double zDepth, double screenRadius})>[];
    final closerBodies =
        <({Body body, Offset screenPos, double zDepth, double screenRadius})>[];

    for (final item in visibleBodies) {
      // Check if this body is occluded by any closer body
      if (!_isOccluded((
        screenPos: item.screenPos,
        zDepth: item.zDepth,
        screenRadius: item.screenRadius,
      ), closerBodies)) {
        labelsToShow.add(item);
      }
      // Add this body to the list of potential occluders for further bodies
      closerBodies.add(item);
    }

    // Sort labels to show: furthest first so closer labels draw on top
    labelsToShow.sort((a, b) => a.zDepth.compareTo(b.zDepth));

    for (final item in labelsToShow) {
      // Offset label position slightly to avoid overlapping with the body
      final labelOffset = Offset(
        item.screenPos.dx + AppTypography.labelOffsetX, // Offset to the right
        item.screenPos.dy - AppTypography.labelOffsetY, // Offset upward
      );

      // Get the localized name for the body
      final localizedName = LocalizationUtils.getLocalizedBodyName(
        item.body.name,
        l10n,
      );

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
