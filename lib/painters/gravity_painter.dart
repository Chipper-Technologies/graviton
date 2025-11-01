// Copyright 2025 Chipper Technologies, LLC. All rights reserved.
//
// Dynamic Gravity Well Visualization System
// ========================================
//
// This file implements a sophisticated 3D gravity well visualization system that
// dynamically adapts to the orbital mechanics of gravitational simulations. The
// system represents gravitational fields as funnel-shaped depressions in spacetime,
// providing an intuitive way to visualize how mass curves space and influences
// orbital motion.
//
// ## Key Innovations:
//
// ### 1. Dynamic Orbital Plane Detection
// Instead of using fixed coordinate systems, the gravity wells automatically align
// with the actual orbital planes of the simulated bodies. This is achieved by:
// - Calculating angular momentum vectors from orbiting bodies
// - Using conservation of angular momentum to determine natural orbital planes
// - Creating orthogonal coordinate systems within these planes
//
// ### 2. Physics-Accurate Scaling
// The visualization respects fundamental physics principles:
// - Well radius: Based on Hill sphere approximation (gravitational dominance)
// - Well depth: Derived from gravitational potential energy (U = -GM/r)
// - Smooth transitions: Prevents mathematical singularities while maintaining accuracy
//
// ### 3. Adaptive Detail System
// Rendering complexity automatically adjusts based on viewing distance:
// - Close view: High detail for scientific examination
// - Medium view: Balanced detail for normal interaction
// - Far view: Simplified geometry for performance
//
// ### 4. Educational Design
// The visualization emphasizes educational value through:
// - Per-body controls for selective visualization
// - Physically meaningful color coding
// - Clear visual hierarchy with alternating line styles
// - Intuitive funnel metaphor for gravitational potential
//
// ## Usage:
// Gravity wells are controlled via the `Body.showGravityWell` property and
// automatically render for enabled bodies during the simulation visualization phase.
//
// ## Performance:
// The system is optimized for real-time rendering with adaptive LOD, efficient
// 3D projection, and minimal memory allocation during animation frames.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter responsible for rendering gravity wells and gravitational field visualization
///
/// This class provides physics-accurate 3D gravity well visualization that dynamically adapts
/// to the orbital mechanics of the simulated system. The gravity wells represent gravitational
/// potential energy as funnel-shaped depressions in spacetime, oriented according to the
/// actual orbital planes of nearby bodies.
///
/// ## Key Features:
///
/// ### Dynamic Orbital Plane Detection
/// - Automatically calculates orbital planes based on angular momentum of orbiting bodies
/// - Gravity wells align with actual orbital motion rather than using fixed orientations
/// - Supports complex multi-body systems with inclined orbits
///
/// ### Physics-Based Scaling
/// - Well radius: Hill sphere approximation (R ∝ ∛(M/3))
/// - Well depth: Gravitational potential energy (U = -GM/r)
/// - Center smoothing: Prevents mathematical singularities while maintaining physical accuracy
///
/// ### Zoom-Responsive Detail Levels
/// - Close view (< 100 units): 20 rings, 32 segments, 24 radial lines
/// - Medium view (100-400 units): 12 rings, 24 segments, 12 radial lines
/// - Far view (> 400 units): 8 rings, 16 segments, 8 radial lines
///
/// ### Visual Design Elements
/// - Concentric rings: Show gravitational field strength contours
/// - Radial lines: Provide depth perception with alternating opacity (every 5th line brighter)
/// - Central circle: Marks the deepest point of the gravitational well
/// - Color coding: Stars use yellow, other bodies use blue
///
/// ## Implementation Details:
///
/// The visualization uses a three-component coordinate system derived from orbital mechanics:
/// - Normal vector: Perpendicular to orbital plane (from angular momentum)
/// - Tangent vectors: Two orthogonal vectors within the orbital plane
/// - Depth offset: Applied along the normal vector for 3D funnel effect
///
/// Per-body gravity well settings are controlled via the `Body.showGravityWell` property,
/// allowing selective visualization of gravitational fields for educational purposes.
class GravityPainter {
  /// Storage for tracking gravity well orientation history for temporal indicators
  static final Map<String, List<({vm.Vector3 normal, double timestamp})>>
  _wellOrientationHistory = {};
  static const int _maxHistoryLength =
      30; // Keep last 30 orientations (about 0.5 seconds at 60fps)

  /// Draw gravity wells showing gravitational field strength around objects
  ///
  /// This method renders 3D funnel-shaped gravity wells for all bodies that have
  /// gravity well visualization enabled. Each well is oriented according to the
  /// orbital plane of nearby bodies and scaled based on physics principles.
  ///
  /// Parameters:
  /// - [canvas]: Flutter canvas for rendering
  /// - [size]: Canvas dimensions for projection calculations
  /// - [vp]: Combined view-projection matrix for 3D-to-2D transformation
  /// - [sim]: Physics simulation containing body positions, velocities, and masses
  /// - [cameraDistance]: Current camera distance for zoom-responsive detail levels
  /// - [view]: View matrix for calculating perspective distance
  ///
  /// The method automatically:
  /// - Detects orbital planes using angular momentum calculations
  /// - Adjusts detail levels based on camera distance
  /// - Applies physics-based scaling for radius and depth
  /// - Renders additional spacetime curvature grids for massive objects (mass > 10.0)
  /// - Tracks orientation changes for temporal visualization
  static void drawGravityWells(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
    double cameraDistance,
    vm.Matrix4 view,
  ) {
    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();

    for (int i = 0; i < sim.bodies.length; i++) {
      final body = sim.bodies[i];

      // Only draw gravity well if enabled for this specific body
      if (!body.showGravityWell) continue;

      // Calculate the same projection and radius as used for body rendering
      final bodyScreenPosition = PainterUtils.project(vp, body.position, size);
      if (bodyScreenPosition == null) {
        continue; // Body is behind camera or outside view
      }

      final eyeSpace =
          (view *
          vm.Vector4(body.position.x, body.position.y, body.position.z, 1));
      final dist = (-eyeSpace.z).abs().clamp(0.1, 1e9);
      final bodyScreenRadius = (body.radius * 175.0 / dist).clamp(2.0, 875.0);

      // Calculate orbital plane and track orientation changes
      final orbitalPlane = _calculateOrbitalPlane(body, sim);
      _trackOrientationChange(body.name, orbitalPlane.normal, currentTime);

      // Draw 3D funnel-shaped gravity well with zoom-responsive detail and temporal indicators
      _draw3DGravityWell(
        canvas,
        size,
        vp,
        body,
        sim,
        cameraDistance,
        orbitalPlane,
        bodyScreenPosition,
        bodyScreenRadius,
      );

      // Draw curved grid for massive objects to show space-time curvature
      // if (body.mass > SimulationConstants.spacetimeCurvatureMassThreshold) {
      //   _draw3DSpaceTimeGrid(canvas, size, vp, body, sim);
      // }
    }
  }

  /// Calculate the orbital plane orientation based on nearby orbiting bodies
  ///
  /// This method dynamically determines the natural orbital plane of a gravitational system
  /// by analyzing the angular momentum vectors of bodies orbiting the central mass. This
  /// ensures gravity wells align with actual orbital motion rather than using fixed orientations.
  ///
  /// ## Algorithm:
  /// 1. **Identify Orbiting Bodies**: Finds bodies with significant velocity relative to the
  ///    central body and within reasonable orbital distances
  /// 2. **Calculate Angular Momentum**: Computes L = r × v for each orbiting body, weighted by mass
  /// 3. **Determine Plane Normal**: Uses total angular momentum vector as the orbital plane normal
  /// 4. **Generate Tangent Vectors**: Creates two orthogonal vectors within the orbital plane
  ///
  /// ## Parameters:
  /// - [centralBody]: The massive body around which others orbit
  /// - [sim]: Physics simulation containing all bodies with positions and velocities
  ///
  /// ## Returns:
  /// A record containing:
  /// - `normal`: Unit vector perpendicular to the orbital plane
  /// - `tangent1`: First orthogonal vector within the orbital plane
  /// - `tangent2`: Second orthogonal vector within the orbital plane
  ///
  /// ## Fallback Behavior:
  /// If no orbiting motion is detected, defaults to horizontal plane (XZ) with Y-up normal.
  /// This maintains visual consistency for static or single-body scenarios.
  ///
  /// ## Physics Rationale:
  /// In real gravitational systems, orbital planes are defined by conservation of angular
  /// momentum. This method replicates that principle to create physically accurate visualizations
  /// that match the actual dynamics of the simulated system.

  static const double minAngularMomentumThreshold = 1e-9;

  static ({vm.Vector3 normal, vm.Vector3 tangent1, vm.Vector3 tangent2})
  _calculateOrbitalPlane(Body centralBody, physics.Simulation sim) {
    // Find orbiting bodies (bodies with significant velocity relative to central body)
    // Enhanced sensitivity for more responsive gravity well orientations
    final orbitingBodies = <Body>[];
    for (final body in sim.bodies) {
      if (body == centralBody) continue;

      final distance = (body.position - centralBody.position).length;
      final relativeVelocity = (body.velocity - centralBody.velocity).length;

      // Enhanced responsiveness: lower velocity threshold and wider distance range
      // This makes wells respond to even subtle orbital interactions
      if (relativeVelocity > 0.01 &&
          distance < 2000.0 &&
          distance > centralBody.radius * 1.5) {
        orbitingBodies.add(body);
      }
    }

    if (orbitingBodies.isEmpty) {
      // No orbiting bodies found, use default horizontal plane (XZ)
      return (
        normal: vm.Vector3(0, 1, 0), // Y-up normal
        tangent1: vm.Vector3(1, 0, 0), // X-axis tangent
        tangent2: vm.Vector3(0, 0, 1), // Z-axis tangent
      );
    }

    // Calculate orbital plane normal using angular momentum vectors
    // Enhanced responsiveness: more sensitive to subtle orbital changes
    vm.Vector3 totalAngularMomentum = vm.Vector3.zero();

    for (final body in orbitingBodies) {
      final r = body.position - centralBody.position;
      final v = body.velocity - centralBody.velocity;
      final angularMomentum = r.cross(v);

      // Enhanced weighting: use square root of mass for more balanced influence
      // This prevents massive bodies from completely dominating the orientation
      final weight = math.sqrt(body.mass);
      totalAngularMomentum += angularMomentum * weight;
    }

    // Enhanced sensitivity: lower threshold filters out floating-point noise but allows detection of subtle orbital motion.
    if (totalAngularMomentum.length > minAngularMomentumThreshold) {
      final normal = totalAngularMomentum.normalized();

      // Create two orthogonal tangent vectors in the orbital plane
      // First tangent: choose a vector that's not parallel to normal
      vm.Vector3 tangent1;
      if (normal.x.abs() < 0.9) {
        tangent1 = vm.Vector3(1, 0, 0).cross(normal).normalized();
      } else {
        tangent1 = vm.Vector3(0, 1, 0).cross(normal).normalized();
      }

      // Second tangent: cross product of normal and first tangent
      final tangent2 = normal.cross(tangent1).normalized();

      return (normal: normal, tangent1: tangent1, tangent2: tangent2);
    }

    // Fallback to default horizontal plane
    return (
      normal: vm.Vector3(0, 1, 0),
      tangent1: vm.Vector3(1, 0, 0),
      tangent2: vm.Vector3(0, 0, 1),
    );
  }

  /// Track gravity well orientation changes over time for temporal visualization
  ///
  /// This method maintains a history of gravity well orientations to enable visualization
  /// of how the wells are dynamically changing due to orbital interactions.
  ///
  /// Parameters:
  /// - [bodyName]: Unique identifier for the body
  /// - [normal]: Current orbital plane normal vector
  /// - [timestamp]: Current time in milliseconds
  static void _trackOrientationChange(
    String bodyName,
    vm.Vector3 normal,
    double timestamp,
  ) {
    // Initialize history for this body if it doesn't exist
    _wellOrientationHistory[bodyName] ??= [];

    final history = _wellOrientationHistory[bodyName]!;

    // Add current orientation to history
    history.add((normal: normal.clone(), timestamp: timestamp));

    // Remove old entries beyond max history length
    while (history.length > _maxHistoryLength) {
      history.removeAt(0);
    }
  }

  /// Calculate how much a gravity well's orientation has changed recently
  ///
  /// Returns a value from 0.0 (no change) to 1.0 (maximum change) based on
  /// the angular difference between recent orientations.
  /// Enhanced for increased responsiveness to subtle changes.
  static double _calculateOrientationChangeRate(String bodyName) {
    final history = _wellOrientationHistory[bodyName];
    if (history == null || history.length < 2) return 0.0;

    // Enhanced responsiveness: compare with more recent frame (5 instead of 10)
    // This makes the wells react faster to orientation changes
    final current = history.last.normal;
    final compareIndex = math.max(0, history.length - 5);
    final previous = history[compareIndex].normal;

    // Calculate angular difference (dot product gives cosine of angle between vectors)
    final dot = current.dot(previous).clamp(-1.0, 1.0);
    final angleDifference = math.acos(
      dot.abs(),
    ); // Use abs() to handle orientation flips

    // Enhanced sensitivity: lower threshold (π/8 = 22.5 degrees) for more visible changes
    // Also amplify small changes with a power function
    final normalizedChange = (angleDifference / (math.pi / 8)).clamp(0.0, 1.0);

    // Apply power curve to amplify subtle changes
    // The exponent 0.7 was empirically chosen to make small orientation changes more visible
    // while keeping the response smooth and not overly sensitive; values closer to 1.0 would be linear,
    // while lower values would exaggerate small changes too much.
    return math.pow(normalizedChange, 0.7).toDouble();
  }

  /// Detail level configuration for zoom-responsive rendering
  ///
  /// Dynamically adjusts the visual complexity of gravity wells based on camera distance
  /// to maintain smooth performance while maximizing detail when appropriate.
  ///
  /// ## Detail Levels:
  ///
  /// ### Close View (cameraDistance < 100):
  /// - **Ring Count**: 20 (high resolution field contours)
  /// - **Segments**: 32 (smooth circular geometry)
  /// - **Radial Lines**: 24 (detailed funnel structure)
  /// - **Use Case**: Detailed examination of individual gravity wells
  ///
  /// ### Medium View (100 ≤ cameraDistance < 400):
  /// - **Ring Count**: 12 (balanced detail)
  /// - **Segments**: 24 (adequate smoothness)
  /// - **Radial Lines**: 12 (clear structure)
  /// - **Use Case**: Normal viewing and interaction
  ///
  /// ### Far View (cameraDistance ≥ 400):
  /// - **Ring Count**: 8 (essential structure only)
  /// - **Segments**: 16 (basic geometry)
  /// - **Radial Lines**: 8 (minimal lines)
  /// - **Use Case**: Overview of multiple systems, performance priority
  ///
  /// ## Performance Considerations:
  /// This adaptive system prevents frame rate drops when viewing complex scenes
  /// from a distance while preserving visual fidelity for close inspection.
  /// The segment counts directly affect the number of 3D projections and path
  /// operations required per frame.
  ///
  /// ## Parameters:
  /// - [cameraDistance]: Current distance from camera to simulation center
  ///
  /// ## Returns:
  /// A record containing the appropriate detail settings for the given distance.
  static ({int ringCount, int segments, int radialLineCount})
  _calculateDetailLevel(double cameraDistance) {
    // Zoom levels: Close (< 100) -> Medium (100-400) -> Far (> 400)
    if (cameraDistance < SimulationConstants.gravityWellCloseViewThreshold) {
      // High detail when zoomed in close
      return (
        ringCount: SimulationConstants.gravityWellCloseRingCount,
        segments: SimulationConstants.gravityWellCloseSegments,
        radialLineCount: SimulationConstants.gravityWellCloseRadialLines,
      );
    } else if (cameraDistance <
        SimulationConstants.gravityWellMediumViewThreshold) {
      // Medium detail for normal viewing
      return (
        ringCount: SimulationConstants.gravityWellMediumRingCount,
        segments: SimulationConstants.gravityWellMediumSegments,
        radialLineCount: SimulationConstants.gravityWellMediumRadialLines,
      );
    } else {
      // Low detail when zoomed out far
      return (
        ringCount: SimulationConstants.gravityWellFarRingCount,
        segments: SimulationConstants.gravityWellFarSegments,
        radialLineCount: SimulationConstants.gravityWellFarRadialLines,
      );
    }
  }

  /// Calculate depth for a given radius using physics-based gravitational potential
  ///
  /// This method computes the depth of the gravity well at a specific radius using
  /// principles from gravitational physics, creating a realistic funnel shape that
  /// represents the gravitational potential energy landscape.
  ///
  /// ## Physics Implementation:
  ///
  /// ### Gravitational Potential:
  /// The depth is based on gravitational potential energy: U = -GM/r
  /// Where:
  /// - G: Gravitational constant (implicit in scaling)
  /// - M: Mass of the central body
  /// - r: Distance from the center
  ///
  /// ### Bowl Curve Function:
  /// Applies a smooth cubic interpolation: f(x) = x²(3-2x)
  /// This creates a natural bowl shape that:
  /// - Starts shallow at the edges
  /// - Deepens smoothly toward the center
  /// - Avoids sharp transitions or discontinuities
  ///
  /// ### Center Smoothing:
  /// Prevents mathematical singularities (infinite depth at r=0) by:
  /// - Limiting minimum effective radius to 10% of max radius
  /// - Maintaining physical accuracy while ensuring visual stability
  /// - Creating a naturally rounded bottom rather than a sharp point
  ///
  /// ## Parameters:
  /// - [body]: The gravitating body (provides mass and radius)
  /// - [radius]: Current radius from center (0 to maxRadius)
  /// - [maxRadius]: Maximum extent of the gravity well
  /// - [maxDepth]: Maximum depth for scaling purposes
  ///
  /// ## Returns:
  /// The calculated depth at the specified radius, smoothly varying from 0 at
  /// the edge to maximum depth near the center.
  static double _calculateDepthForRadius(
    Body body,
    double radius,
    double maxRadius,
    double maxDepth,
  ) {
    final normalizedRadius = radius / maxRadius;
    final depthFactor = 1.0 - normalizedRadius;
    final bowlCurve = depthFactor * depthFactor * (3.0 - 2.0 * depthFactor);

    // Use gravitational potential with smooth center handling
    final surfacePotential = body.mass / body.radius;

    // Create smooth rounded bottom by limiting depth near center
    final centerDistance = radius / maxRadius; // 0.0 at center, 1.0 at edge
    final centerSmoothing = math.max(
      0.1,
      centerDistance,
    ); // Minimum 10% radius from center
    final smoothedPotential =
        body.mass / (centerSmoothing * maxRadius + body.radius);
    final normalizedPotential = (smoothedPotential / surfacePotential).clamp(
      0.0,
      1.0,
    );

    return normalizedPotential * maxDepth * bowlCurve;
  }

  /// Draw a 3D funnel-shaped gravity well that curves downward with zoom-responsive detail
  static void _draw3DGravityWell(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    physics.Simulation sim,
    double cameraDistance,
    ({vm.Vector3 normal, vm.Vector3 tangent1, vm.Vector3 tangent2})
    orbitalPlane,
    Offset bodyScreenPosition,
    double bodyScreenRadius,
  ) {
    // Calculate well properties based on physics: gravitational influence radius
    // Using Hill sphere approximation but scaled down to represent the inner gravitational zone
    // where objects would spiral inward rather than maintain stable orbits
    final isBlackHole =
        body.bodyType == BodyType.star &&
        body.mass > SimulationConstants.blackHoleMassThreshold;

    // Gravity well radius should scale with mass to show true gravitational influence
    // Base calculation includes both physical size and gravitational reach
    final massInfluenceRadius =
        math.pow(
          body.mass / SimulationConstants.gravityWellMassScalingDivisor,
          SimulationConstants.gravityWellMassScalingExponent,
        ) *
        SimulationConstants
            .gravityWellMassRadiusMultiplier; // Mass-based radius scaling

    final baseGravitationalRadius = isBlackHole
        ? math.max(
            body.radius * SimulationConstants.blackHoleRadiusMultiplier,
            massInfluenceRadius,
          ) // Black holes: larger of physical or mass-based radius
        : math.max(
            body.radius * SimulationConstants.normalBodyRadiusMultiplier,
            massInfluenceRadius *
                SimulationConstants.normalBodyMassInfluenceReduction,
          ); // Normal bodies: smaller mass influence

    // Expanded well diameter for better visual effect - increased by 40%
    final maxRadius =
        (baseGravitationalRadius *
                SimulationConstants.gravityWellDiameterExpansion)
            .clamp(
              body.radius *
                  SimulationConstants
                      .gravityWellMinimumRadiusMultiplier, // Expanded minimum: 2.8x physical radius (was 2.0x)
              body.radius *
                  SimulationConstants
                      .gravityWellMaximumRadiusMultiplier, // Expanded maximum to allow for larger visual impact (was 20.0x)
            );

    // Depth calculation that balances physics accuracy with visual proportionality
    // Use mass-based scaling with radius consideration for proper visual impact
    final massScale = math.pow(
      body.mass,
      SimulationConstants.gravityWellMassDepthExponent,
    ); // Sublinear scaling prevents extreme values

    // Scale depth based on mass and visual body size for proper proportionality
    // Special treatment for black holes to make them dramatically deeper
    final maxDepth =
        body.bodyType == BodyType.star &&
            body.mass > SimulationConstants.blackHoleMassThreshold
        ? massScale *
              body.radius *
              SimulationConstants
                  .blackHoleDepthMultiplier // Black holes get MASSIVE deeper wells!
        : massScale *
              body.radius *
              SimulationConstants.normalBodyDepthMultiplier; // Normal bodies

    // Zoom-responsive detail levels
    final detailLevel = _calculateDetailLevel(cameraDistance);
    // Black holes get MANY more rings to show dramatic spacetime curvature
    final ringCount = isBlackHole
        ? math.max(
            detailLevel.ringCount * SimulationConstants.blackHoleRingMultiplier,
            SimulationConstants.blackHoleMinimumRings,
          ) // Triple rings for black holes, minimum 30!
        : detailLevel.ringCount;
    final segments = isBlackHole
        ? math.max(
            detailLevel.segments,
            32,
          ) // Black holes always get high segment count
        : detailLevel.segments;

    // Use the body's actual color for the gravity well with enhanced vibrancy
    // Black holes get special visual treatment for dramatic effect
    final baseColor = isBlackHole
        ? AppColors
              .accretionMediumPurple // Bright purple for black holes - much more visible!
        : body.color;

    // Calculate orientation change rate for dynamic coloring (Enhancement 4)
    final changeRate = _calculateOrientationChangeRate(body.name);

    // Draw concentric rings at different depths to create funnel shape
    // Start with ring 0 at the body's surface (depth = 0) for perfect alignment
    for (int ring = 0; ring <= ringCount; ring++) {
      final normalizedRing = ring / ringCount;
      final ringRadius = ring == 0
          ? body.radius * 1.1
          : normalizedRing * maxRadius; // Surface ring matches body size

      // Use shared depth calculation for perfect connectivity with radial lines
      // IMPORTANT: Surface ring (ring 0) has NO depth offset to perfectly align with body
      final depth = ring == 0
          ? 0.0
          : _calculateDepthForRadius(body, ringRadius, maxRadius, maxDepth);

      // Calculate field strength for opacity with higher baseline
      final fieldStrength = body.mass / (ringRadius * ringRadius + 1.0);
      final normalizedStrength = (fieldStrength / (body.mass + 1.0)).clamp(
        0.0,
        1.0,
      );

      // Surface ring (ring 0) should be more visible to align with the body
      final edgeFadeAmount = ring == 0
          ? 0.0
          : (normalizedRing > 0.6
                ? (normalizedRing - 0.6) / 0.4
                : 0.0); // No fade for surface ring
      // Use exponential curve for more aggressive fade near edge
      final edgeFade =
          1.0 -
          (edgeFadeAmount *
              edgeFadeAmount *
              0.8); // Up to 80% reduction with curve

      // Much more visible alpha values - black holes get extra intensity
      final baseAlpha = isBlackHole
          ? 0.4
          : 0.15; // Black holes start MUCH more opaque
      final maxAlpha = isBlackHole
          ? 0.9
          : 0.6; // Black holes can be almost fully opaque

      // Surface ring gets enhanced visibility, other rings use normal calculation
      final calculatedAlpha = ring == 0
          ? baseAlpha *
                RenderingConstants
                    .gravityWellSurfaceRingAlphaMultiplier // Surface ring is more opaque
          : baseAlpha + normalizedStrength * 0.5;
      final alpha = (calculatedAlpha * edgeFade).clamp(
        isBlackHole ? 0.15 : 0.08, // Keep minimum high enough to see wells
        maxAlpha,
      );

      // Enhancement 4: Dynamic color coding based on orientation change rate
      // Blend base color with a highlighting color when wells are changing orientation
      final highlightColor = AppColors.uiRed; // Bright red for changes
      final dynamicColor =
          Color.lerp(baseColor, highlightColor, changeRate * 0.7) ?? baseColor;

      final ringColor = dynamicColor.withValues(alpha: alpha);
      final ringPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth =
            2.0 + (changeRate * 2.0); // Keep stroke width consistent

      // Generate 3D ring points
      final ringPoints = <Offset>[];

      if (ring == 0) {
        // Surface ring: Use the exact body screen position and radius for perfect alignment
        // Generate a circle directly in screen space around the body center
        final segmentCount = segments;
        for (int segment = 0; segment <= segmentCount; segment++) {
          final ringAngle = (segment / segmentCount) * 2 * math.pi;
          final screenRadius =
              bodyScreenRadius * 1.1; // Slightly larger than body

          final screenX =
              bodyScreenPosition.dx + screenRadius * math.cos(ringAngle);
          final screenY =
              bodyScreenPosition.dy + screenRadius * math.sin(ringAngle);

          ringPoints.add(Offset(screenX, screenY));
        }
      } else {
        // Deeper rings: Use the dynamically calculated orbital plane orientation
        for (int segment = 0; segment <= segments; segment++) {
          final ringAngle = (segment / segments) * 2 * math.pi;

          final localX =
              ringRadius * math.cos(ringAngle) * orbitalPlane.tangent1.x +
              ringRadius * math.sin(ringAngle) * orbitalPlane.tangent2.x;
          final localY =
              ringRadius * math.cos(ringAngle) * orbitalPlane.tangent1.y +
              ringRadius * math.sin(ringAngle) * orbitalPlane.tangent2.y -
              depth * orbitalPlane.normal.y;
          final localZ =
              ringRadius * math.cos(ringAngle) * orbitalPlane.tangent1.z +
              ringRadius * math.sin(ringAngle) * orbitalPlane.tangent2.z -
              depth * orbitalPlane.normal.z;

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

    // Enhancement 3: Draw visual orientation trails showing recent well orientations
    _drawOrientationTrails(
      canvas,
      size,
      vp,
      body,
      orbitalPlane,
      maxRadius * 1.2,
    );

    // Draw a small central circle at the bottom of the well for radial lines to connect to
    _drawCentralCircle(
      canvas,
      size,
      vp,
      body,
      maxDepth,
      maxRadius,
      baseColor,
      sim,
      orbitalPlane,
    );

    // Draw radial lines connecting the rings to the central circle with zoom-responsive detail
    final radialLineCount = isBlackHole
        ? math.max(
            detailLevel.radialLineCount * 2,
            24,
          ) // Black holes get more radial lines too
        : detailLevel.radialLineCount;

    _drawRadialLines(
      canvas,
      size,
      vp,
      body,
      maxDepth,
      maxRadius,
      baseColor,
      sim,
      radialLineCount,
      ringCount,
      orbitalPlane,
      bodyScreenPosition,
      bodyScreenRadius,
    );
  }

  /// Draw a small central circle at the bottom of the gravity well
  static void _drawCentralCircle(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    double maxDepth,
    double maxRadius,
    Color baseColor,
    physics.Simulation sim,
    ({vm.Vector3 normal, vm.Vector3 tangent1, vm.Vector3 tangent2})
    orbitalPlane,
  ) {
    // Central circle radius should be much smaller but still visible
    final centralRadius =
        maxRadius *
        SimulationConstants
            .centralCircleRadiusRatio; // 1.5% of max radius - much smaller

    // Central circle should be slightly deeper than the innermost ring for natural funnel effect
    final baseCentralDepth = _calculateDepthForRadius(
      body,
      centralRadius,
      maxRadius,
      maxDepth,
    );
    final centralDepth =
        baseCentralDepth *
        SimulationConstants
            .centralCircleDepthMultiplier; // Just 3% deeper than physics calculation

    const int segments = SimulationConstants
        .centralCircleSegments; // Fewer segments since it's small

    // Create paint for central circle - same transparency as radial lines
    final centralPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Generate 3D circle points
    final circlePoints = <Offset>[];
    for (int segment = 0; segment <= segments; segment++) {
      final angle = (segment / segments) * 2 * math.pi;

      // Calculate 3D position of point on the central circle using orbital plane
      final localX =
          centralRadius * math.cos(angle) * orbitalPlane.tangent1.x +
          centralRadius * math.sin(angle) * orbitalPlane.tangent2.x;
      final localY =
          centralRadius * math.cos(angle) * orbitalPlane.tangent1.y +
          centralRadius * math.sin(angle) * orbitalPlane.tangent2.y -
          centralDepth * orbitalPlane.normal.y;
      final localZ =
          centralRadius * math.cos(angle) * orbitalPlane.tangent1.z +
          centralRadius * math.sin(angle) * orbitalPlane.tangent2.z -
          centralDepth * orbitalPlane.normal.z;

      // Transform to world coordinates
      final worldPos = vm.Vector3(
        body.position.x + localX,
        body.position.y + localY,
        body.position.z + localZ,
      );

      // Project to screen coordinates
      final screenPos = PainterUtils.project(vp, worldPos, size);
      if (screenPos != null) {
        circlePoints.add(screenPos);
      }
    }

    // Draw the central circle if we have enough points
    if (circlePoints.length > 2) {
      final path = Path();
      path.moveTo(circlePoints.first.dx, circlePoints.first.dy);
      for (int i = 1; i < circlePoints.length; i++) {
        path.lineTo(circlePoints[i].dx, circlePoints[i].dy);
      }
      canvas.drawPath(path, centralPaint);
    }
  }

  /// Draw radial lines from edge to center to show the funnel depth structure with alternating colors
  static void _drawRadialLines(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    double maxDepth,
    double maxRadius,
    Color baseColor,
    physics.Simulation sim,
    int radialLineCount,
    int ringCount,
    ({vm.Vector3 normal, vm.Vector3 tangent1, vm.Vector3 tangent2})
    orbitalPlane,
    Offset bodyScreenPosition,
    double bodyScreenRadius,
  ) {
    // Draw radial lines at regular angular intervals with alternating colors
    for (int lineIndex = 0; lineIndex < radialLineCount; lineIndex++) {
      final angle = (lineIndex / radialLineCount) * 2 * math.pi;
      final radialPoints = <Offset>[];

      // Check if this is a black hole for enhanced visibility
      final isBlackHole =
          body.bodyType == BodyType.star &&
          body.mass > SimulationConstants.blackHoleMassThreshold;

      // Every 5th radial line gets the normal color, others are darker
      final isMainLine = (lineIndex % 5) == 0;

      // Enhanced alpha with fade-out effect for smoother visual transition
      final baseNormalAlpha = isBlackHole
          ? 0.5
          : 0.25; // Black holes get much brighter lines
      final baseDimAlpha = isBlackHole
          ? 0.3
          : 0.15; // Even dim lines are brighter for black holes

      final baseAlpha = isMainLine ? baseNormalAlpha : baseDimAlpha;

      final strokeWidth = isMainLine
          ? (isBlackHole ? 1.5 : 1.0)
          : (isBlackHole ? 1.0 : 0.7); // Black holes get thicker lines

      // Draw line from outer edge through rings to central circle
      for (int ringIndex = ringCount; ringIndex >= 1; ringIndex--) {
        final normalizedRing = ringIndex / ringCount;
        final radius = normalizedRing * maxRadius;
        final depth = _calculateDepthForRadius(
          body,
          radius,
          maxRadius,
          maxDepth,
        );

        // Calculate 3D position of point on the radial line using orbital plane
        final localX =
            radius * math.cos(angle) * orbitalPlane.tangent1.x +
            radius * math.sin(angle) * orbitalPlane.tangent2.x;
        final localY =
            radius * math.cos(angle) * orbitalPlane.tangent1.y +
            radius * math.sin(angle) * orbitalPlane.tangent2.y -
            depth * orbitalPlane.normal.y;
        final localZ =
            radius * math.cos(angle) * orbitalPlane.tangent1.z +
            radius * math.sin(angle) * orbitalPlane.tangent2.z -
            depth * orbitalPlane.normal.z;

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

      // Add the surface connection point using exact body screen position for perfect alignment
      final surfaceRadius = bodyScreenRadius * 1.1; // Same as surface ring
      final surfaceX = bodyScreenPosition.dx + surfaceRadius * math.cos(angle);
      final surfaceY = bodyScreenPosition.dy + surfaceRadius * math.sin(angle);
      radialPoints.insert(
        0,
        Offset(surfaceX, surfaceY),
      ); // Insert at beginning for outer-to-center order

      // Add the center point where all radial lines converge
      final centralRadius =
          maxRadius *
          SimulationConstants
              .centralCircleRadiusRatio; // For depth calculation only
      final baseCentralDepth = _calculateDepthForRadius(
        body,
        centralRadius,
        maxRadius,
        maxDepth,
      );
      final centralDepth =
          baseCentralDepth *
          SimulationConstants
              .centralCircleDepthMultiplier; // Same 3% deeper adjustment as central circle

      // All radial lines converge to the exact center using orbital plane
      final centralX = 0.0; // Center in orbital plane
      final centralY =
          -centralDepth * orbitalPlane.normal.y; // Depth along normal
      final centralZ =
          -centralDepth * orbitalPlane.normal.z; // Depth along normal

      // Transform central point to world coordinates
      final centralWorldPos = vm.Vector3(
        body.position.x + centralX,
        body.position.y + centralY,
        body.position.z + centralZ,
      );
      final centralScreenPos = PainterUtils.project(vp, centralWorldPos, size);
      if (centralScreenPos != null) {
        radialPoints.add(centralScreenPos);
      }

      // Draw the radial line with fade-out segments if we have enough points
      if (radialPoints.length > 1) {
        // Draw as segments with fade-out effect instead of one continuous line
        for (int i = 0; i < radialPoints.length - 1; i++) {
          final segmentProgress = i / (radialPoints.length - 1);

          // Calculate fade-out: inner segments (higher progress) are stronger
          final fadeAlpha = 1.0 - math.pow(1.0 - segmentProgress, 1.5);
          final segmentAlpha = baseAlpha * fadeAlpha;

          // Create paint for this segment with appropriate alpha
          final segmentPaint = Paint()
            ..color = baseColor.withValues(alpha: segmentAlpha)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth;

          canvas.drawLine(radialPoints[i], radialPoints[i + 1], segmentPaint);
        }
      }
    }
  }

  /// Draw 3D curved grid lines to visualize space-time curvature
  static void _draw3DSpaceTimeGrid(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    physics.Simulation sim,
  ) {
    // Calculate grid properties based on gravitational influence - more subtle than main well
    final gravitationalRadius =
        body.radius +
        math.pow(body.mass / 3.0, 1.0 / 3.0) * 6.0; // Smaller than main well
    final maxRadius = gravitationalRadius.clamp(
      body.radius * 1.5,
      body.radius * 8.0,
    ); // Smaller bounds
    const int gridLines = 4; // Fewer lines to reduce clutter
    const int gridSegments = 12; // Fewer segments for better performance

    final gridSpacing = maxRadius / gridLines;

    final gridPaint = Paint()
      ..color = body.color
          .withValues(alpha: 0.08) // Use body's color with subtle alpha
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
        sim,
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
        sim,
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
    int segments,
    physics.Simulation sim, {
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

      // Calculate final 3D position - coordinate system depends on scenario orientation
      late double finalX, finalY, finalZ;

      if (sim.currentScenario == ScenarioType.asteroidBelt) {
        // Asteroid belt uses XY plane (appears vertical)
        finalX = localX;
        finalY = isXDirection
            ? localZ
            : coordinate; // Adjust based on direction
        finalZ = -curvatureDepth; // Depth along Z axis
      } else {
        // Other scenarios use XZ plane (appears horizontal)
        finalX = localX;
        finalZ = localZ;
        finalY = -curvatureDepth; // Depth along Y axis
      }

      // Transform to world coordinates
      final worldPos = vm.Vector3(
        body.position.x + finalX,
        body.position.y + finalY,
        body.position.z + finalZ,
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

  /// Enhancement 3: Draw visual trails showing how gravity well orientations have changed
  ///
  /// This method renders a series of orientation indicators showing the recent history
  /// of gravity well orientations, making the dynamic nature of the wells visible.
  static void _drawOrientationTrails(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    Body body,
    ({vm.Vector3 normal, vm.Vector3 tangent1, vm.Vector3 tangent2})
    currentPlane,
    double indicatorRadius,
  ) {
    final history = _wellOrientationHistory[body.name];
    if (history == null || history.length < 2) return;

    // Draw orientation indicators for recent history
    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    final maxAge = 1000.0; // 1 second of history

    for (int i = history.length - 1; i >= 0; i--) {
      final entry = history[i];
      final age = currentTime - entry.timestamp;

      if (age > maxAge) break; // Stop drawing very old orientations

      // Calculate alpha based on age (newer = more opaque)
      final normalizedAge = age / maxAge;
      final alpha = (1.0 - normalizedAge) * 0.3; // Max 30% opacity

      if (alpha < 0.05) continue; // Skip very faint indicators

      // Draw a small orientation indicator showing the normal vector direction
      final indicatorLength = indicatorRadius * 0.3;
      final startPos = body.position;
      final endPos = startPos + (entry.normal * indicatorLength);

      // Project both points to screen
      final startScreen = PainterUtils.project(vp, startPos, size);
      final endScreen = PainterUtils.project(vp, endPos, size);

      if (startScreen != null && endScreen != null) {
        final paint = Paint()
          ..color = AppColors.uiYellow.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        // Draw a line indicating the orientation
        canvas.drawLine(
          Offset(startScreen.dx, startScreen.dy),
          Offset(endScreen.dx, endScreen.dy),
          paint,
        );

        // Draw a small circle at the end to make it more visible
        canvas.drawCircle(
          Offset(endScreen.dx, endScreen.dy),
          2.0,
          paint..style = PaintingStyle.fill,
        );
      }
    }
  }

  // ============================================================================
  // TESTING METHODS
  // ============================================================================
  // These methods expose private functionality for unit testing

  /// Testing method to access the private _calculateOrbitalPlane method
  static ({vm.Vector3 normal, vm.Vector3 tangent1, vm.Vector3 tangent2})
  calculateOrbitalPlaneForTesting(Body centralBody, physics.Simulation sim) {
    return _calculateOrbitalPlane(centralBody, sim);
  }

  /// Testing method to access the private _trackOrientationChange method
  static void trackOrientationChangeForTesting(
    String bodyName,
    vm.Vector3 normal,
    double timestamp,
  ) {
    _trackOrientationChange(bodyName, normal, timestamp);
  }

  /// Testing method to access the private _calculateOrientationChangeRate method
  static double calculateOrientationChangeRateForTesting(String bodyName) {
    return _calculateOrientationChangeRate(bodyName);
  }

  /// Testing method to access the private orientation history
  static List<({vm.Vector3 normal, double timestamp})>?
  getOrientationHistoryForTesting(String bodyName) {
    return _wellOrientationHistory[bodyName];
  }

  /// Testing method to clear orientation history (for test cleanup)
  static void clearOrientationHistoryForTesting() {
    _wellOrientationHistory.clear();
  }
}
