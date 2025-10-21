import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/orbital_parameters.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/painter_utils.dart';
import 'package:graviton/utils/physics_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Painter for drawing predicted orbital paths
class OrbitalPathPainter {
  OrbitalPathPainter._(); // Private constructor

  /// Draw complete orbital paths for bodies in stable orbits
  /// Set dualMode to true to show both ideal circular and actual elliptical paths
  static void drawOrbitalPaths(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    physics.Simulation sim,
    bool showOrbitalPaths, {
    bool dualMode = false,
  }) {
    if (!showOrbitalPaths) return;

    // Show orbital paths for solar system, Earth-Moon-Sun, and binary star scenarios
    if (sim.currentScenario != ScenarioType.solarSystem &&
        sim.currentScenario != ScenarioType.earthMoonSun &&
        sim.currentScenario != ScenarioType.binaryStars) {
      return;
    }

    // Create an instance to access instance methods
    final painter = OrbitalPathPainter._();

    for (int i = 0; i < sim.bodies.length; i++) {
      final body = sim.bodies[i];

      // Only draw orbital paths for planets and moons
      if (body.bodyType != BodyType.planet && body.bodyType != BodyType.moon) {
        continue;
      }

      // Special handling for binary star scenario
      if (sim.currentScenario == ScenarioType.binaryStars) {
        // For the planet, show orbital path around the center of mass of the two stars
        if (body.bodyType == BodyType.planet) {
          // Find the two stars
          final stars = sim.bodies.where((b) => b.bodyType == BodyType.star).toList();
          if (stars.length >= 2) {
            // Calculate center of mass of the two stars as the orbital center
            final star1 = stars[0];
            final star2 = stars[1];
            final totalMass = star1.mass + star2.mass;
            final centerOfMass = (star1.position * star1.mass + star2.position * star2.mass) / totalMass;

            // Create a virtual central body at the center of mass
            final virtualCenter = Body(
              position: centerOfMass,
              velocity: vm.Vector3.zero(),
              mass: totalMass,
              radius: 1.0,
              color: AppColors.transparentColor,
              name: 'Center of Mass',
            );

            // Calculate orbital parameters for planet around center of mass
            final orbitalParams = _calculateOrbitalParameters(body, virtualCenter);
            if (orbitalParams != null) {
              // Draw the orbital path for the planet
              if (dualMode) {
                painter._drawDualOrbitalPaths(canvas, size, vp, orbitalParams, body, sim);
              } else {
                painter._drawOrbitalEllipse(
                  canvas,
                  size,
                  vp,
                  orbitalParams,
                  body.color,
                  scenario: sim.currentScenario,
                  body: body,
                  sim: sim,
                );
              }
            }
          }
        }

        // For the moon, it should orbit the planet
        if (body.bodyType == BodyType.moon) {
          // Find the planet it orbits
          final centralBody = sim.bodies.firstWhere(
            (b) => b.bodyType == BodyType.planet,
            orElse: () => sim.bodies.first,
          );

          // Calculate orbital parameters for moon around planet
          final orbitalParams = _calculateOrbitalParameters(body, centralBody);
          if (orbitalParams == null) {
            // If calculation fails, create a simple circular orbit
            final distance = (body.position - centralBody.position).length;
            final simpleParams = OrbitalParameters(
              center: centralBody.position,
              semiMajorAxis: distance,
              semiMinorAxis: distance,
              eccentricity: 0.0,
              inclination: 0.0,
              argumentOfPeriapsis: 0.0,
            );

            // Draw simple orbital path
            painter._drawOrbitalEllipse(
              canvas,
              size,
              vp,
              simpleParams,
              body.color,
              scenario: sim.currentScenario,
              body: body,
              sim: sim,
            );

            continue;
          }

          // Get inclination for this body (scenario specific)
          double inclination;
          if (sim.currentScenario == ScenarioType.binaryStars) {
            // For binary stars, calculate actual inclination from body's orbital plane
            inclination = _calculateActualInclination(body, sim);
          } else {
            // For other scenarios, use predefined inclinations
            inclination = _getBodyInclination(body.name, sim.currentScenario);
          }

          // Update orbital parameters with inclination
          final inclinedParams = OrbitalParameters(
            center: orbitalParams.center,
            semiMajorAxis: orbitalParams.semiMajorAxis,
            semiMinorAxis: orbitalParams.semiMinorAxis,
            eccentricity: orbitalParams.eccentricity,
            inclination: inclination,
            argumentOfPeriapsis: orbitalParams.argumentOfPeriapsis,
          );

          // Draw the orbital path(s) for the moon
          if (dualMode) {
            painter._drawDualOrbitalPaths(canvas, size, vp, inclinedParams, body, sim);
          } else {
            painter._drawOrbitalEllipse(
              canvas,
              size,
              vp,
              inclinedParams,
              body.color,
              isDashed: false,
              scenario: sim.currentScenario,
              body: body,
            );
          }
        }

        continue;
      }

      // Normal handling for other scenarios

      // Find the central body to orbit around
      final centralBody = _findCentralBody(sim.bodies, body);
      if (centralBody == null) continue;

      // Calculate orbital parameters
      final orbitalParams = _calculateOrbitalParameters(body, centralBody);
      if (orbitalParams == null) continue;

      // Get inclination - calculate from actual body motion for all scenarios
      // to ensure path matches actual motion
      double inclination = 0.0;
      final r = body.position - centralBody.position;
      final v = body.velocity - centralBody.velocity;
      final angularMomentum = r.cross(v);

      if (angularMomentum.length > 0.01) {
        // Calculate inclination from angular momentum
        double inclinationRadians;
        if (sim.currentScenario == ScenarioType.binaryStars) {
          // For binary stars (XY plane), inclination is angle from Z-axis
          inclinationRadians = math.acos((angularMomentum.z.abs()) / angularMomentum.length);
        } else {
          // For solar system (XZ plane), inclination is angle from Y-axis
          inclinationRadians = math.acos((angularMomentum.y.abs()) / angularMomentum.length);
        }
        inclination = inclinationRadians * (180.0 / math.pi);

        // Determine sign of inclination based on direction
        if (sim.currentScenario == ScenarioType.binaryStars) {
          if (angularMomentum.z < 0) inclination = -inclination;
        } else {
          if (angularMomentum.y < 0) inclination = -inclination;
        }
      }

      // Update orbital parameters with inclination
      final inclinedParams = OrbitalParameters(
        center: orbitalParams.center,
        semiMajorAxis: orbitalParams.semiMajorAxis,
        semiMinorAxis: orbitalParams.semiMinorAxis,
        eccentricity: orbitalParams.eccentricity,
        inclination: inclination,
        argumentOfPeriapsis: orbitalParams.argumentOfPeriapsis,
      );

      // Draw the orbital path(s)
      if (dualMode) {
        painter._drawDualOrbitalPaths(canvas, size, vp, inclinedParams, body, sim);
      } else {
        painter._drawOrbitalEllipse(
          canvas,
          size,
          vp,
          inclinedParams,
          body.color,
          scenario: sim.currentScenario,
          body: body,
          sim: sim,
        );
      }
    }
  }

  /// Find the central body that the given body orbits around
  static Body? _findCentralBody(List<Body> bodies, Body orbitingBody) {
    // Special case for Moon - it orbits Earth, not the Sun
    if (orbitingBody.name == 'Moon') {
      return bodies.firstWhere((body) => body.name == 'Earth', orElse: () => bodies.first);
    }

    // For other bodies, find the most massive body
    Body? centralBody;
    double maxMass = 0;

    for (final body in bodies) {
      if (body == orbitingBody) continue;
      if (body.mass > maxMass) {
        maxMass = body.mass;
        centralBody = body;
      }
    }

    return centralBody;
  }

  /// Get the orbital inclination for a specific body based on scenario (in degrees)
  static double _getBodyInclination(String bodyName, ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.solarSystem:
        // Real orbital inclinations relative to Earth's orbital plane (ecliptic)
        switch (bodyName) {
          case 'Mercury':
            return 7.0;
          case 'Venus':
            return 3.4;
          case 'Earth':
            return 0.0;
          case 'Mars':
            return 1.9;
          case 'Jupiter':
            return 1.3;
          case 'Saturn':
            return 2.5;
          case 'Uranus':
            return 0.8;
          case 'Neptune':
            return 1.8;
          default:
            return 0.0;
        }
      case ScenarioType.earthMoonSun:
        // Earth-Moon-Sun system inclinations
        switch (bodyName) {
          case 'Earth':
            return 0.0; // Earth's orbit defines the reference plane
          case 'Moon':
            return 1.0; // Reduced from 5.14° for visual stability in three-body system
          default:
            return 0.0;
        }
      default:
        return 0.0; // No inclination for other scenarios
    }
  }

  /// Calculate actual inclination from body's current orbital motion (for randomized scenarios)
  static double _calculateActualInclination(Body body, physics.Simulation sim) {
    // Find the central body (one with larger mass)
    final centralBody = sim.bodies.firstWhere((b) => b.mass > body.mass, orElse: () => sim.bodies.first);
    final r = body.position - centralBody.position;

    // For binary stars, the base orbital plane was XY, with inclination applied around X-axis
    // Original position was (0, planetDistance, 0), rotated to (0, planetY, planetZ)
    // Where planetY = planetDistance * cos(incl) and planetZ = planetDistance * sin(incl)
    // So inclination = atan2(planetZ, planetY) = atan2(r.z, r.y)

    final inclinationRadians = math.atan2(r.z.abs(), r.y.abs());
    final inclinationDegrees = inclinationRadians * 180.0 / math.pi;
    return inclinationDegrees;
  }

  /// Calculate orbital parameters for a circular/elliptical orbit
  static OrbitalParameters? _calculateOrbitalParameters(Body orbitingBody, Body centralBody) {
    final r = orbitingBody.position - centralBody.position;
    final v = orbitingBody.velocity - centralBody.velocity;

    final distance = r.length;
    final speed = v.length;

    if (distance < 0.001) return null; // Too close to central body

    // For nearly circular orbits (like in solar system), use current distance as orbital radius
    final orbitalRadius = distance;
    final center = centralBody.position;

    // Calculate expected circular orbital velocity
    final expectedSpeed = PhysicsUtils.calculateOrbitalVelocity(centralBody.mass, distance);

    // If the current speed is close to expected circular orbital speed, assume circular orbit
    final speedRatio = speed / expectedSpeed;

    // Be more lenient for moons in three-body systems (they get perturbed)
    final isThreeBodySystem = (orbitingBody.name == 'Moon');
    final minRatio = isThreeBodySystem ? 0.5 : 0.8;
    final maxRatio = isThreeBodySystem ? 2.0 : 1.2;

    if (speedRatio > minRatio && speedRatio < maxRatio) {
      // For stable orbital paths, use fixed inclination based on initial conditions
      // Don't calculate inclination from current position to avoid rocking motion
      return OrbitalParameters(
        center: center,
        semiMajorAxis: orbitalRadius,
        semiMinorAxis: orbitalRadius,
        eccentricity: 0.0,
        inclination: 0.0, // Keep paths stable by using 0 inclination
        argumentOfPeriapsis: 0.0,
      );
    }

    // For more complex orbital mechanics, we'd need full Keplerian element calculations
    // For now, just handle circular orbits which work well for the solar system scenario
    return null;
  }

  /// Draw both ideal circular and actual elliptical orbital paths
  void _drawDualOrbitalPaths(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    OrbitalParameters params,
    Body body,
    physics.Simulation sim,
  ) {
    // 1. Draw ideal circular orbit (light, theoretical)
    final idealParams = OrbitalParameters(
      center: params.center,
      semiMajorAxis: params.semiMajorAxis,
      semiMinorAxis: params.semiMajorAxis, // Force circular
      eccentricity: 0.0,
      inclination: params.inclination,
      argumentOfPeriapsis: params.argumentOfPeriapsis,
    );

    final lightColor = body.color.withValues(alpha: AppTypography.opacitySemiTransparent); // More visible for testing
    _drawOrbitalEllipse(canvas, size, vp, idealParams, lightColor, scenario: sim.currentScenario, body: body, sim: sim);

    // 2. Draw actual elliptical orbit (dark blue dashed)
    final actualParams = _estimateActualOrbit(params, body, sim);
    final darkBlue = AppColors.uiDarkBlueOrbit.withValues(alpha: AppTypography.opacityNearlyOpaque); // Much darker blue

    _drawOrbitalEllipse(
      canvas,
      size,
      vp,
      actualParams,
      darkBlue,
      isDashed: true,
      scenario: sim.currentScenario,
      body: body,
      sim: sim,
    );
  }

  /// Estimate actual orbital parameters based on trail data or realistic modeling
  OrbitalParameters _estimateActualOrbit(OrbitalParameters baseParams, Body body, physics.Simulation sim) {
    // The elliptical orbit should be FIXED and represent the actual orbital path
    // The circular orbit (current distance) should intersect it twice per revolution

    // Use FIXED average orbital radius - but make it LARGER than current distance
    // so the circular orbit can intersect it at periapsis and apoapsis
    double fixedSemiMajor;

    if (body.name == 'Moon' || body.name == 'Moon M') {
      fixedSemiMajor = 0.35; // Larger than typical Moon distance (0.25) so circle can intersect
    } else if (body.name == 'Planet P') {
      // Binary star planet orbits at distance 60.0, make ellipse slightly larger
      fixedSemiMajor = 65.0; // Slightly larger than actual binary planet distance (60.0)
    } else if (body.bodyType == BodyType.planet) {
      switch (body.name) {
        case 'Mercury':
          fixedSemiMajor = 18.0; // Closer to actual Mercury distance
        case 'Venus':
          fixedSemiMajor = 23.0; // Closer to actual Venus distance
        case 'Earth':
          fixedSemiMajor = 52.0; // Even closer to actual Earth distance
        case 'Mars':
          fixedSemiMajor = 85.0; // Closer to actual Mars distance
        case 'Jupiter':
          fixedSemiMajor = 160.0; // Closer to actual Jupiter distance
        case 'Saturn':
          fixedSemiMajor = 220.0; // Closer to actual Saturn distance
        case 'Uranus':
          fixedSemiMajor = 320.0; // Closer to actual Uranus distance
        case 'Neptune':
          fixedSemiMajor = 420.0; // Closer to actual Neptune distance
        default:
          fixedSemiMajor = 55.0; // Closer default
      }
    } else {
      fixedSemiMajor = 55.0; // Closer default
    }

    // Set moderate eccentricity for oval shape that's wide enough to intersect at both extremes
    double eccentricity = 0.0;

    if (body.name == 'Moon') {
      eccentricity = 0.4; // Moderate oval for Moon - wide enough for both intersections
    } else if (body.bodyType == BodyType.planet) {
      switch (body.name) {
        case 'Mercury':
          eccentricity = 0.5; // Moderate oval - wide enough
        case 'Venus':
          eccentricity = 0.3; // Moderate oval - wide enough
        case 'Earth':
          eccentricity = 0.3; // Moderate oval - wide enough
        case 'Mars':
          eccentricity = 0.4; // Moderate oval - wide enough
        case 'Jupiter':
          eccentricity = 0.3; // Moderate oval - wide enough
        case 'Saturn':
          eccentricity = 0.4; // Moderate oval - wide enough
        case 'Uranus':
          eccentricity = 0.3; // Moderate oval - wide enough
        case 'Neptune':
          eccentricity = 0.3; // Moderate oval - wide enough
        default:
          eccentricity = 0.4; // Moderate oval - wide enough
      }
    }

    // Create FIXED ellipse - this should never change size
    final semiMajor = fixedSemiMajor;
    final semiMinor = semiMajor * math.sqrt(1.0 - eccentricity * eccentricity);

    return OrbitalParameters(
      center: baseParams.center,
      semiMajorAxis: semiMajor,
      semiMinorAxis: semiMinor,
      eccentricity: eccentricity,
      inclination: baseParams.inclination,
      argumentOfPeriapsis: 0.0, // Align major axis with current position for better visibility
    );
  }

  /// Draw an orbital ellipse with inclination
  void _drawOrbitalEllipse(
    Canvas canvas,
    Size size,
    vm.Matrix4 vp,
    OrbitalParameters params,
    Color bodyColor, {
    bool isDashed = false,
    ScenarioType? scenario,
    Body? body,
    physics.Simulation? sim,
  }) {
    const int numPoints = 128; // Number of points to draw the ellipse
    final points = <Offset>[];

    // Determine orbital direction from angular momentum (if body provided)
    bool clockwise = false;

    if (body != null && sim != null) {
      // Calculate angular momentum to determine direction
      final centralBody = sim.bodies.firstWhere((b) => b.mass > body.mass, orElse: () => sim.bodies.first);
      final r = body.position - centralBody.position;
      final v = body.velocity - centralBody.velocity;
      final angularMomentum = r.cross(v);

      if (scenario == ScenarioType.binaryStars) {
        // For binary stars (XY plane), check Z component
        clockwise = angularMomentum.z < 0;
      } else {
        // For solar system (XZ plane), check Y component
        clockwise = angularMomentum.y < 0;
      }
    }

    // Calculate the current phase (where the body is on its orbit) to align the path
    double phaseOffset = 0.0;
    if (body != null && sim != null) {
      // Find the central body for this orbit
      final centralBody = sim.bodies.firstWhere((b) => b.mass > body.mass, orElse: () => sim.bodies.first);
      final r = body.position - centralBody.position;

      // Calculate the current angle of the body's position relative to the orbital center
      if (scenario == ScenarioType.binaryStars) {
        // For XY plane orbits
        phaseOffset = math.atan2(r.y, r.x);
      } else {
        // For XZ plane orbits
        phaseOffset = math.atan2(r.z, r.x);
      }
    }

    // Generate points for orbital path
    for (int i = 0; i <= numPoints; i++) {
      // Use clockwise/counterclockwise direction based on actual motion, with phase alignment
      final baseAngle = clockwise
          ? (1.0 - i / numPoints) * 2 * math.pi
          : // Clockwise
            (i / numPoints) * 2 * math.pi; // Counterclockwise

      final angle = baseAngle + phaseOffset; // Align path with body's current position

      // Calculate position on the ellipse based on scenario - with proper inclination
      double x, y, z;

      if (scenario == ScenarioType.binaryStars) {
        // Binary star system uses XY plane (vertical orbits) as base
        x = params.semiMajorAxis * math.cos(angle);
        y = params.semiMinorAxis * math.sin(angle);
        z = 0.0;

        // Apply inclination around X-axis for binary stars (match planet generation)
        if (params.inclination != 0.0) {
          final incRad = params.inclination * (math.pi / 180.0);
          // Use same rotation as planet generation in scenario service
          final yInclined = y * math.cos(incRad);
          final zInclined = y * math.sin(incRad);
          y = yInclined;
          z = zInclined;
        }
      } else {
        // Solar system and other scenarios use XZ plane (horizontal orbits) as base
        x = params.semiMajorAxis * math.cos(angle);
        z = params.semiMinorAxis * math.sin(angle);
        y = 0.0;

        // Apply inclination around X-axis for solar system (match planet generation)
        if (params.inclination != 0.0) {
          final incRad = params.inclination * (math.pi / 180.0);
          // Use same rotation as planet generation in scenario service
          final zInclined = z * math.cos(incRad);
          final yInclined = z * math.sin(incRad);
          y = yInclined;
          z = zInclined;
          y = yInclined;
          z = zInclined;
        }
      }

      // Transform to world space (relative to orbital center)
      final worldPos = params.center + vm.Vector3(x, y, z);

      // Project to screen space
      final screenPos = PainterUtils.project(vp, worldPos, size);
      if (screenPos != null) {
        points.add(screenPos);
      }
    }

    if (points.length < 3) return; // Not enough points to draw

    // Draw the orbital path
    final pathPaint = Paint()
      ..color = bodyColor
          .withValues(alpha: AppTypography.opacityFaint) // Semi-transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw path as connected line segments (dashed or solid)
    if (isDashed) {
      // Draw dashed line
      const dashLength = 8.0;
      const gapLength = 4.0;

      for (int i = 0; i < points.length - 1; i++) {
        final start = points[i];
        final end = points[i + 1];
        final segmentLength = (end - start).distance;

        // Draw dashed segments
        double currentDistance = 0.0;

        while (currentDistance < segmentLength) {
          final progress1 = currentDistance / segmentLength;
          final progress2 = math.min((currentDistance + dashLength) / segmentLength, 1.0);

          final dashStart = Offset.lerp(start, end, progress1)!;
          final dashEnd = Offset.lerp(start, end, progress2)!;

          canvas.drawLine(dashStart, dashEnd, pathPaint);
          currentDistance += dashLength + gapLength;
        }
      }
    } else {
      // Draw solid line
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], pathPaint);
      }
    }

    // Draw some orbital direction indicators (small arrows)
    _drawOrbitalDirectionIndicators(
      canvas,
      points,
      bodyColor,
      body: body,
      orbitalCenter: params.center,
      scenario: scenario,
    );
  }

  /// Draw small arrows to indicate orbital direction
  void _drawOrbitalDirectionIndicators(
    Canvas canvas,
    List<Offset> points,
    Color bodyColor, {
    Body? body,
    vm.Vector3? orbitalCenter,
    ScenarioType? scenario,
  }) {
    if (points.length < 8) return;

    final arrowPaint = Paint()
      ..color = bodyColor.withValues(alpha: AppTypography.opacityMedium)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    // Since points are now generated in the correct orbital direction,
    // arrows can simply follow the point sequence

    // Draw arrows at quarter positions around the orbit
    final arrowPositions = [points.length ~/ 4, points.length ~/ 2, (points.length * 3) ~/ 4];

    for (final pos in arrowPositions) {
      if (pos >= points.length - 1) continue;

      final current = points[pos];
      final next = points[pos + 1];

      // Calculate direction from point sequence (scenario-specific)
      double dx, dy;
      if (scenario == ScenarioType.binaryStars) {
        // For binary stars, use normal direction (next - current)
        dx = next.dx - current.dx;
        dy = next.dy - current.dy;
      } else {
        // For solar system and others, use reversed direction (current - next)
        dx = current.dx - next.dx;
        dy = current.dy - next.dy;
      }

      final length = math.sqrt(dx * dx + dy * dy);

      if (length < 0.1) continue;

      // Normalize direction
      final ndx = dx / length;
      final ndy = dy / length;

      // Draw small arrow
      const arrowSize = 8.0;
      final arrowEnd = Offset(current.dx + ndx * arrowSize, current.dy + ndy * arrowSize);

      // Arrow head
      final perpX = -ndy;
      final perpY = ndx;

      final arrowHead1 = Offset(arrowEnd.dx - ndx * 4 + perpX * 2, arrowEnd.dy - ndy * 4 + perpY * 2);

      final arrowHead2 = Offset(arrowEnd.dx - ndx * 4 - perpX * 2, arrowEnd.dy - ndy * 4 - perpY * 2);

      canvas.drawLine(current, arrowEnd, arrowPaint);
      canvas.drawLine(arrowEnd, arrowHead1, arrowPaint);
      canvas.drawLine(arrowEnd, arrowHead2, arrowPaint);
    }
  }
}
