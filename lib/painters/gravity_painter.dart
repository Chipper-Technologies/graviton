import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering gravity wells and gravitational field visualization
class GravityPainter {
  /// Draw gravity wells showing gravitational field strength around objects
  static void drawGravityWells(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
    bool showGravityWells,
  ) {
    if (!showGravityWells) return;

    for (int i = 0; i < sim.bodies.length; i++) {
      final body = sim.bodies[i];

      // Draw 3D funnel-shaped gravity well
      _draw3DGravityWell(canvas, size, vp, body);

      // Draw curved grid for massive objects to show space-time curvature
      if (body.mass > 10.0) {
        _draw3DSpaceTimeGrid(canvas, size, vp, body);
      }
    }
  }

  /// Draw a 3D funnel-shaped gravity well that curves downward
  static void _draw3DGravityWell(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
  ) {
    // Calculate well properties based on mass - make it more dramatic
    final wellStrength =
        math.log(body.mass + 1) * 2.0; // Increased depth factor
    final maxRadius =
        wellStrength * 80.0; // Larger radius for better visibility
    const int ringCount = 8; // Fewer, more visible rings
    const int segments = 24; // Fewer segments for better performance

    // Color based on object type - make it more vibrant
    final baseColor = body.bodyType == BodyType.star
        ? AppColors.gravityWellYellow
        : AppColors.gravityWellBlue;

    // Draw concentric rings at different depths to create funnel shape
    for (int ring = 1; ring <= ringCount; ring++) {
      final normalizedRing = ring / ringCount;
      final ringRadius = normalizedRing * maxRadius;

      // Calculate dramatic depth using steeper gravitational curve
      // Much more pronounced funnel shape
      final depthFactor = 1.0 - normalizedRing;
      final depth =
          wellStrength * depthFactor * depthFactor * depthFactor * 15.0;

      // Calculate field strength for opacity with higher baseline
      final fieldStrength = body.mass / (ringRadius * ringRadius + 1.0);
      final normalizedStrength = (fieldStrength / (body.mass + 1.0)).clamp(
        0.0,
        1.0,
      );

      // Much more visible alpha values
      final alpha =
          (0.15 + normalizedStrength * 0.4 * (1.0 - normalizedRing * 0.5))
              .clamp(0.08, 0.6); // Higher minimum and maximum alpha

      final ringColor = baseColor.withValues(alpha: alpha);
      final ringPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0; // Thicker lines for better visibility

      // Generate 3D ring points
      final ringPoints = <Offset>[];
      for (int segment = 0; segment <= segments; segment++) {
        final angle = (segment / segments) * 2 * math.pi;

        // Calculate 3D position of point on the ring
        final localX = ringRadius * math.cos(angle);
        final localZ = ringRadius * math.sin(angle);
        final localY = -depth; // Negative Y goes "down" into the well

        // Transform to world coordinates
        final worldPos = vm.Vector3(
          body.position.x + localX,
          body.position.y + localY,
          body.position.z + localZ,
        );

        // Project to screen coordinates
        final screenPos = PainterUtils.project(vp, worldPos, size);
        if (screenPos != null) {
          ringPoints.add(screenPos);
        }
      }

      // Draw the ring if we have enough points
      if (ringPoints.length > 2) {
        final path = Path();
        path.moveTo(ringPoints.first.dx, ringPoints.first.dy);
        for (int i = 1; i < ringPoints.length; i++) {
          path.lineTo(ringPoints[i].dx, ringPoints[i].dy);
        }
        canvas.drawPath(path, ringPaint);
      }
    }

    // Draw radial lines connecting the rings to show funnel structure
    _drawRadialLines(
      canvas,
      size,
      vp,
      body,
      wellStrength,
      maxRadius,
      baseColor,
    );
  }

  /// Draw radial lines from edge to center to show the funnel depth structure
  static void _drawRadialLines(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    double wellStrength,
    double maxRadius,
    Color baseColor,
  ) {
    const int radialLineCount = 8; // Number of radial lines around the well
    const int radialSegments = 6; // Points along each radial line

    // Create paint for radial lines - slightly more transparent than rings
    final radialPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw radial lines at regular angular intervals
    for (int lineIndex = 0; lineIndex < radialLineCount; lineIndex++) {
      final angle = (lineIndex / radialLineCount) * 2 * math.pi;
      final radialPoints = <Offset>[];

      // Draw line from outer edge to center
      for (int segment = 0; segment <= radialSegments; segment++) {
        final normalizedRadius =
            1.0 - (segment / radialSegments); // From 1.0 to 0.0
        final radius = normalizedRadius * maxRadius;

        // Calculate depth at this radius using same curve as rings
        final depthFactor = 1.0 - normalizedRadius;
        final depth =
            wellStrength * depthFactor * depthFactor * depthFactor * 15.0;

        // Calculate 3D position
        final localX = radius * math.cos(angle);
        final localZ = radius * math.sin(angle);
        final localY = -depth;

        // Transform to world coordinates
        final worldPos = vm.Vector3(
          body.position.x + localX,
          body.position.y + localY,
          body.position.z + localZ,
        );

        // Project to screen coordinates
        final screenPos = PainterUtils.project(vp, worldPos, size);
        if (screenPos != null) {
          radialPoints.add(screenPos);
        }
      }

      // Draw the radial line if we have enough points
      if (radialPoints.length > 1) {
        final path = Path();
        path.moveTo(radialPoints.first.dx, radialPoints.first.dy);
        for (int i = 1; i < radialPoints.length; i++) {
          path.lineTo(radialPoints[i].dx, radialPoints[i].dy);
        }
        canvas.drawPath(path, radialPaint);
      }
    }
  }

  /// Draw 3D curved grid lines to visualize space-time curvature
  static void _draw3DSpaceTimeGrid(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
  ) {
    // Calculate grid properties based on mass - make it subtle
    final gridStrength = math.log(body.mass + 1) * 0.2; // Reduced from 0.4
    final maxRadius = gridStrength * 60.0; // Smaller than well radius
    const int gridLines = 4; // Fewer lines to reduce clutter
    const int gridSegments = 12; // Fewer segments for better performance

    final gridSpacing = maxRadius / gridLines;

    final gridPaint = Paint()
      ..color = body.bodyType == BodyType.star
          ? AppColors.gravityWellYellow.withValues(
              alpha: 0.1,
            ) // Much more subtle
          : AppColors.gravityWellCyan.withValues(
              alpha: 0.08,
            ) // Much more subtle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4; // Thinner lines

    // Draw fewer curved grid lines to support the funnel visualization
    for (int lineIndex = -gridLines; lineIndex <= gridLines; lineIndex += 2) {
      if (lineIndex == 0) continue; // Skip center lines

      final lineOffset = lineIndex * gridSpacing;

      // Draw lines parallel to X-axis (varying Z, constant X)
      _drawCurvedGridLine(
        canvas,
        size,
        vp,
        body,
        gridPaint,
        lineOffset,
        0.0,
        maxRadius,
        gridSegments,
        isXDirection: false, // This line varies in Z direction
      );

      // Draw lines parallel to Z-axis (varying X, constant Z)
      _drawCurvedGridLine(
        canvas,
        size,
        vp,
        body,
        gridPaint,
        0.0,
        lineOffset,
        maxRadius,
        gridSegments,
        isXDirection: true, // This line varies in X direction
      );
    }
  }

  /// Draw a single curved grid line that bends toward the massive object
  static void _drawCurvedGridLine(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    Paint paint,
    double fixedX,
    double fixedZ,
    double maxRadius,
    int segments, {
    required bool isXDirection,
  }) {
    final gridPoints = <Offset>[];

    for (int segment = 0; segment <= segments; segment++) {
      final t = (segment / segments) * 2.0 - 1.0; // Range from -1 to 1
      final coordinate = t * maxRadius;

      double localX, localZ;
      if (isXDirection) {
        localX = coordinate;
        localZ = fixedZ;
      } else {
        localX = fixedX;
        localZ = coordinate;
      }

      // Calculate distance from center for curvature
      final distanceFromCenter = math.sqrt(localX * localX + localZ * localZ);

      // Calculate gravitational curvature effect - match the funnel depth
      // Use similar curve as the funnel rings for consistency
      final curvatureDepth = body.mass / (distanceFromCenter + 5.0) * 2.5;
      final localY = -curvatureDepth; // Curve downward (negative Y)

      // Transform to world coordinates
      final worldPos = vm.Vector3(
        body.position.x + localX,
        body.position.y + localY,
        body.position.z + localZ,
      );

      // Project to screen coordinates
      final screenPos = PainterUtils.project(vp, worldPos, size);
      if (screenPos != null) {
        gridPoints.add(screenPos);
      }
    }

    // Draw the curved line if we have enough points
    if (gridPoints.length > 1) {
      final path = Path();
      path.moveTo(gridPoints.first.dx, gridPoints.first.dy);
      for (int i = 1; i < gridPoints.length; i++) {
        path.lineTo(gridPoints[i].dx, gridPoints[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }
}
