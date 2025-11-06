import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';

import 'package:vector_math/vector_math_64.dart' as vm;

/// Utility functions for gravity field calculations and visualization
class GravityFieldUtils {
  // Private constructor to prevent instantiation
  GravityFieldUtils._();

  /// Calculate gravitational field strength at a point due to a body
  ///
  /// Returns field strength in m/s² based on Newton's law of gravitation:
  /// g = G * M / r²
  ///
  /// Parameters:
  /// - [body]: The body generating the gravitational field
  /// - [position]: Position where field strength is calculated
  ///
  /// Returns field strength magnitude in m/s²
  static double calculateFieldStrength(Body body, vm.Vector3 position) {
    final distance = (position - body.position).length;
    if (distance < body.radius) {
      // Inside the body - field strength increases linearly from center
      // This prevents division by zero and models simplified solid sphere
      return (SimulationConstants.gravitationalConstant *
              body.mass *
              distance) /
          math.pow(body.radius, 3);
    }

    // Outside the body - standard inverse square law
    return (SimulationConstants.gravitationalConstant * body.mass) /
        math.pow(distance, 2);
  }

  /// Calculate gravitational potential at a point due to a body
  ///
  /// Returns gravitational potential in J/kg (or m²/s²) based on:
  /// V = -G * M / r
  ///
  /// Parameters:
  /// - [body]: The body generating the gravitational potential
  /// - [position]: Position where potential is calculated
  ///
  /// Returns gravitational potential in J/kg
  static double calculateGravitationalPotential(
    Body body,
    vm.Vector3 position,
  ) {
    final distance = (position - body.position).length;
    if (distance < body.radius) {
      // Inside the body - potential varies as -3GM/2R + GM*r²/2R³
      // This models a uniform density sphere
      final r = distance;
      final R = body.radius;
      final gm = SimulationConstants.gravitationalConstant * body.mass;
      return -gm * (3.0 / (2.0 * R) - (r * r) / (2.0 * R * R * R));
    }

    // Outside the body - standard potential
    return -(SimulationConstants.gravitationalConstant * body.mass) / distance;
  }

  /// Calculate the Hill sphere radius for a body
  ///
  /// The Hill sphere is the region around a body where its gravity dominates
  /// over tidal effects from a more massive primary body.
  ///
  /// R_hill = a * (m / 3M)^(1/3)
  ///
  /// Parameters:
  /// - [body]: The body for which to calculate Hill sphere
  /// - [primaryBody]: The more massive body (e.g., star for a planet)
  /// - [orbitalDistance]: Distance between the two bodies
  ///
  /// Returns Hill sphere radius
  static double calculateHillSphereRadius(
    Body body,
    Body primaryBody,
    double orbitalDistance,
  ) {
    final massRatio = body.mass / (3.0 * primaryBody.mass);
    return orbitalDistance * math.pow(massRatio, 1.0 / 3.0);
  }

  /// Get normalized field strength ratio for color mapping
  ///
  /// Converts field strength to a 0.0-1.0 range suitable for color interpolation.
  /// Uses logarithmic scaling to handle the wide range of field strengths.
  ///
  /// Parameters:
  /// - [fieldStrength]: Field strength in m/s²
  /// - [maxFieldStrength]: Maximum expected field strength for normalization
  ///
  /// Returns normalized ratio from 0.0 to 1.0
  static double normalizeFieldStrength(
    double fieldStrength,
    double maxFieldStrength,
  ) {
    if (fieldStrength <= 0 || maxFieldStrength <= 0) return 0.0;

    // Use logarithmic scaling to handle wide range of field strengths
    final logField = math.log(fieldStrength + 1.0);
    final logMax = math.log(maxFieldStrength + 1.0);

    return (logField / logMax).clamp(0.0, 1.0);
  }

  /// Calculate equipotential surface points around a body
  ///
  /// Generates points that form a surface of equal gravitational potential,
  /// useful for visualizing gravitational field topology.
  ///
  /// Parameters:
  /// - [body]: The body generating the gravitational field
  /// - [potential]: The potential value for the equipotential surface
  /// - [segments]: Number of segments for the circular approximation
  /// - [normal]: Normal vector for the plane of the surface
  /// - [tangent1]: First tangent vector in the surface plane
  /// - [tangent2]: Second tangent vector in the surface plane
  ///
  /// Returns list of 3D points forming the equipotential surface
  static List<vm.Vector3> calculateEquipotentialSurface(
    Body body,
    double potential,
    int segments,
    vm.Vector3 normal,
    vm.Vector3 tangent1,
    vm.Vector3 tangent2,
  ) {
    final points = <vm.Vector3>[];

    // Calculate radius for this potential level
    // V = -GM/r, so r = -GM/V
    final gm = SimulationConstants.gravitationalConstant * body.mass;
    final radius = math.max(body.radius, -gm / potential);

    // Generate circular points in the orbital plane
    for (int i = 0; i < segments; i++) {
      final angle = (i / segments) * 2 * math.pi;
      final x = radius * math.cos(angle);
      final z = radius * math.sin(angle);

      // Convert to 3D coordinates using the plane basis vectors
      final point = body.position + (tangent1 * x) + (tangent2 * z);
      points.add(point);
    }

    return points;
  }

  /// Format field strength for display with appropriate units
  ///
  /// Automatically chooses appropriate units and precision based on magnitude.
  ///
  /// Parameters:
  /// - [fieldStrength]: Field strength in m/s²
  /// - [l10n]: Localization object for formatting
  ///
  /// Returns formatted string with value and units
  static String formatFieldStrength(
    double fieldStrength,
    AppLocalizations l10n,
  ) {
    if (fieldStrength >= 1.0) {
      // For strong fields, show with 2 decimal places
      return l10n.gravityFieldStrengthFormatted(
        fieldStrength.toStringAsFixed(2),
        l10n.gravityFieldStrengthUnit,
      );
    } else if (fieldStrength >= 0.01) {
      // For moderate fields, show with 3 decimal places
      return l10n.gravityFieldStrengthFormatted(
        fieldStrength.toStringAsFixed(3),
        l10n.gravityFieldStrengthUnit,
      );
    } else {
      // For weak fields, use scientific notation
      return l10n.gravityFieldStrengthFormatted(
        fieldStrength.toStringAsExponential(2),
        l10n.gravityFieldStrengthUnit,
      );
    }
  }

  /// Get field strength indicator color based on strength
  ///
  /// Uses the current color scheme to map field strength to appropriate colors.
  ///
  /// Parameters:
  /// - [fieldStrength]: Field strength in m/s²
  /// - [maxFieldStrength]: Maximum field strength for normalization
  /// - [colorScheme]: Color scheme to use for mapping
  ///
  /// Returns color representing the field strength
  static Color getFieldStrengthColor(
    double fieldStrength,
    double maxFieldStrength,
    GravityFieldColorScheme colorScheme,
  ) {
    final ratio = normalizeFieldStrength(fieldStrength, maxFieldStrength);
    return colorScheme.getEquipotentialColor(ratio);
  }

  /// Calculate optimal gravity well radius for visualization
  ///
  /// Determines an appropriate radius for gravity well visualization based on
  /// body mass and surrounding context.
  ///
  /// Parameters:
  /// - [body]: The body for which to calculate well radius
  /// - [cameraDistance]: Current camera distance for scaling
  ///
  /// Returns optimal well radius for visualization
  static double calculateOptimalWellRadius(Body body, double cameraDistance) {
    // Base radius on mass using Hill sphere approximation
    final massBasedRadius =
        math.pow(body.mass, 1.0 / 3.0) *
        SimulationConstants.gravityWellDiameterExpansion;

    // Clamp to reasonable bounds based on body size
    final minRadius =
        body.radius * SimulationConstants.gravityWellMinimumRadiusMultiplier;
    final maxRadius =
        body.radius * SimulationConstants.gravityWellMaximumRadiusMultiplier;

    final baseRadius = massBasedRadius.clamp(minRadius, maxRadius);

    // Scale based on camera distance for better visibility
    final distanceScale = math.sqrt(cameraDistance / 100.0).clamp(0.5, 3.0);

    return baseRadius * distanceScale;
  }

  /// Calculate gravity well depth for 3D visualization
  ///
  /// Determines how deep the gravity well funnel should appear based on
  /// the body's mass and the well radius.
  ///
  /// Parameters:
  /// - [body]: The body generating the gravitational well
  /// - [wellRadius]: The radius of the gravity well
  ///
  /// Returns well depth for 3D funnel visualization
  static double calculateWellDepth(Body body, double wellRadius) {
    // Depth based on mass with sublinear scaling for visual clarity
    final massBasedDepth = math.pow(
      body.mass,
      SimulationConstants.gravityWellMassDepthExponent,
    );

    // Scale relative to well radius
    final radiusScale = wellRadius / 50.0; // Normalize to reasonable scale

    return massBasedDepth * radiusScale;
  }

  /// Create paint for gravity field rendering
  ///
  /// Creates a Paint object with appropriate settings for gravity field visualization.
  ///
  /// Parameters:
  /// - [color]: Base color for the paint
  /// - [opacity]: Opacity level (0.0 to 1.0)
  /// - [strokeWidth]: Width for stroke painting
  /// - [useStroke]: Whether to use stroke or fill style
  ///
  /// Returns configured Paint object
  static Paint createGravityFieldPaint(
    Color color, {
    double opacity = 1.0,
    double strokeWidth = 1.0,
    bool useStroke = true,
  }) {
    return Paint()
      ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..style = useStroke ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  /// Calculate maximum field strength in a system
  ///
  /// Finds the maximum gravitational field strength among all bodies in the system,
  /// used for normalization and color scaling.
  ///
  /// Parameters:
  /// - [bodies]: List of all bodies in the system
  ///
  /// Returns maximum field strength in the system
  static double calculateMaxFieldStrength(List<Body> bodies) {
    if (bodies.isEmpty) return 1.0;

    double maxField = 0.0;

    for (final body in bodies) {
      // Calculate field strength at the body's surface
      final surfaceField = calculateFieldStrength(
        body,
        body.position + vm.Vector3(body.radius, 0, 0),
      );
      maxField = math.max(maxField, surfaceField);
    }

    return maxField > 0 ? maxField : 1.0;
  }
}
