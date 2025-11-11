import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/models/body.dart';
import 'package:graviton/constants/simulation_constants.dart';

/// Service for calculating stable orbital positions and velocities
/// Provides smart orbital placement functionality for the scenario editor
class OrbitalMechanicsService {
  /// Calculate position and velocity for a circular orbit around a central body
  static OrbitalPlacement calculateCircularOrbit({
    required Body centralBody,
    required double orbitRadius,
    required double orbitPhase, // Angle in radians (0 to 2*pi)
    double inclination = 0.0, // Inclination angle in radians
    double gravitationalConstant = SimulationConstants.gravitationalConstant,
  }) {
    // Validate arguments
    if (orbitRadius <= 0) {
      throw ArgumentError('Orbit radius must be positive, got: $orbitRadius');
    }
    if (orbitRadius <= centralBody.radius) {
      throw ArgumentError(
        'Orbit radius ($orbitRadius) must be greater than central body radius (${centralBody.radius})',
      );
    }
    if (centralBody.mass <= 0) {
      throw ArgumentError(
        'Central body mass must be positive, got: ${centralBody.mass}',
      );
    }
    if (gravitationalConstant <= 0) {
      throw ArgumentError(
        'Gravitational constant must be positive, got: $gravitationalConstant',
      );
    }

    // Calculate orbital velocity for circular orbit: v = sqrt(GM/r)
    final orbitalSpeed = math.sqrt(
      gravitationalConstant * centralBody.mass / orbitRadius,
    );

    // Calculate position in orbital plane
    final x = orbitRadius * math.cos(orbitPhase);
    final z = orbitRadius * math.sin(orbitPhase);
    final y = 0.0; // Start in orbital plane

    // Apply inclination rotation around the X-axis
    final inclinedY = y * math.cos(inclination) - z * math.sin(inclination);
    final inclinedZ = y * math.sin(inclination) + z * math.cos(inclination);

    // Position relative to central body
    final position = centralBody.position + vm.Vector3(x, inclinedY, inclinedZ);

    // Velocity is perpendicular to position vector for circular orbit
    final velocityX = -orbitalSpeed * math.sin(orbitPhase);
    final velocityZ = orbitalSpeed * math.cos(orbitPhase);
    final velocityY = 0.0; // Start in orbital plane

    // Apply inclination rotation to velocity
    final inclinedVelY =
        velocityY * math.cos(inclination) - velocityZ * math.sin(inclination);
    final inclinedVelZ =
        velocityY * math.sin(inclination) + velocityZ * math.cos(inclination);

    // Add central body's velocity to maintain relative motion
    final velocity =
        centralBody.velocity +
        vm.Vector3(velocityX, inclinedVelY, inclinedVelZ);

    return OrbitalPlacement(
      position: position,
      velocity: velocity,
      orbitRadius: orbitRadius,
      orbitalPeriod: _calculateOrbitalPeriod(
        orbitRadius,
        centralBody.mass,
        gravitationalConstant,
      ),
      eccentricity: 0.0, // Circular orbit
      inclination: inclination,
    );
  }

  /// Calculate position and velocity for an elliptical orbit around a central body
  static OrbitalPlacement calculateEllipticalOrbit({
    required Body centralBody,
    required double semiMajorAxis,
    required double eccentricity,
    required double orbitPhase, // True anomaly in radians
    double inclination = 0.0,
    double argumentOfPeriapsis = 0.0, // Angle from ascending node to periapsis
    double gravitationalConstant = SimulationConstants.gravitationalConstant,
  }) {
    // Validate arguments
    if (semiMajorAxis <= 0) {
      throw ArgumentError(
        'Semi-major axis must be positive, got: $semiMajorAxis',
      );
    }
    if (semiMajorAxis * (1 - eccentricity) <= centralBody.radius) {
      throw ArgumentError(
        'Periapsis distance (${semiMajorAxis * (1 - eccentricity)}) must be greater than central body radius (${centralBody.radius})',
      );
    }
    if (centralBody.mass <= 0) {
      throw ArgumentError(
        'Central body mass must be positive, got: ${centralBody.mass}',
      );
    }
    if (gravitationalConstant <= 0) {
      throw ArgumentError(
        'Gravitational constant must be positive, got: $gravitationalConstant',
      );
    }

    // Validate eccentricity (0 = circle, 0-1 = ellipse, 1 = parabola, >1 = hyperbola)
    if (eccentricity < 0 || eccentricity >= 1) {
      throw ArgumentError(
        'Eccentricity must be between 0 and 1 for stable elliptical orbits',
      );
    }

    // Calculate distance from central body at current true anomaly
    final radius =
        semiMajorAxis *
        (1 - eccentricity * eccentricity) /
        (1 + eccentricity * math.cos(orbitPhase));

    // Calculate position in orbital plane (periapsis at x-axis)
    final x = radius * math.cos(orbitPhase);
    final z = radius * math.sin(orbitPhase);

    // Calculate velocity in orbital plane using vis-viva equation
    final specificOrbitalEnergy =
        -gravitationalConstant * centralBody.mass / (2 * semiMajorAxis);
    final velocityMagnitude = math.sqrt(
      2 *
          (specificOrbitalEnergy +
              gravitationalConstant * centralBody.mass / radius),
    );

    // Velocity direction in orbital plane (perpendicular to radius vector plus radial component)
    final flightPathAngle = math.atan2(
      eccentricity * math.sin(orbitPhase),
      1 + eccentricity * math.cos(orbitPhase),
    );
    final velocityX =
        -velocityMagnitude * math.sin(orbitPhase + flightPathAngle);
    final velocityZ =
        velocityMagnitude * math.cos(orbitPhase + flightPathAngle);

    // Apply rotations: first argument of periapsis, then inclination
    final cosArg = math.cos(argumentOfPeriapsis);
    final sinArg = math.sin(argumentOfPeriapsis);
    final cosInc = math.cos(inclination);
    final sinInc = math.sin(inclination);

    // Rotate position
    final rotatedPosX = x * cosArg - z * sinArg;
    final rotatedPosY = (x * sinArg + z * cosArg) * sinInc;
    final rotatedPosZ = (x * sinArg + z * cosArg) * cosInc;

    // Rotate velocity
    final rotatedVelX = velocityX * cosArg - velocityZ * sinArg;
    final rotatedVelY = (velocityX * sinArg + velocityZ * cosArg) * sinInc;
    final rotatedVelZ = (velocityX * sinArg + velocityZ * cosArg) * cosInc;

    // Add central body's position and velocity
    final position =
        centralBody.position +
        vm.Vector3(rotatedPosX, rotatedPosY, rotatedPosZ);
    final velocity =
        centralBody.velocity +
        vm.Vector3(rotatedVelX, rotatedVelY, rotatedVelZ);

    return OrbitalPlacement(
      position: position,
      velocity: velocity,
      orbitRadius: radius,
      orbitalPeriod: _calculateOrbitalPeriod(
        semiMajorAxis,
        centralBody.mass,
        gravitationalConstant,
      ),
      eccentricity: eccentricity,
      inclination: inclination,
    );
  }

  /// Find the most massive body to use as orbital center
  static Body? findCentralBody(List<Body> bodies) {
    if (bodies.isEmpty) return null;

    Body mostMassive = bodies.first;
    for (final body in bodies) {
      if (body.mass > mostMassive.mass) {
        mostMassive = body;
      }
    }

    return mostMassive;
  }

  /// Calculate safe orbital radius based on body sizes
  static double calculateSafeOrbitRadius(Body centralBody, Body orbitingBody) {
    // Minimum safe distance: 3x the sum of radii to avoid collisions
    final minSafeDistance = 3.0 * (centralBody.radius + orbitingBody.radius);

    // Suggested orbital radius: 5x the larger radius for visual clarity
    final visuallyClearDistance =
        5.0 * math.max(centralBody.radius, orbitingBody.radius);

    return math.max(minSafeDistance, visuallyClearDistance);
  }

  /// Calculate Hill sphere radius (sphere of gravitational influence)
  static double calculateHillSphere(
    Body centralBody,
    Body orbitingBody,
    double orbitRadius,
  ) {
    return orbitRadius *
        math.pow(orbitingBody.mass / (3 * centralBody.mass), 1 / 3);
  }

  /// Check if an orbit is stable (inside Hill sphere)
  static bool isOrbitStable(
    Body centralBody,
    Body orbitingBody,
    double orbitRadius,
  ) {
    final hillRadius = calculateHillSphere(
      centralBody,
      orbitingBody,
      orbitRadius,
    );
    // The factor '2' ensures the orbit radius is at least twice the sum of the body radii,
    // providing a buffer to avoid grazing collisions and tidal disruption.
    // The factor '0.5' restricts the orbit to within half the Hill sphere radius,
    // which is a conservative threshold for long-term orbital stability in multi-body systems.
    return orbitRadius > 2 * (centralBody.radius + orbitingBody.radius) &&
        orbitRadius < 0.5 * hillRadius; // Conservative stability check
  }

  /// Calculate orbital period using Kepler's Third Law: T = 2π√(a³/GM)
  static double _calculateOrbitalPeriod(
    double semiMajorAxis,
    double centralMass,
    double gravitationalConstant,
  ) {
    return 2 *
        math.pi *
        math.sqrt(
          math.pow(semiMajorAxis, 3) / (gravitationalConstant * centralMass),
        );
  }

  /// Generate multiple orbital positions for a multi-body system
  static List<OrbitalPlacement> generateSystemOrbits({
    required Body centralBody,
    required List<Body> orbitingBodies,
    double baseOrbitRadius = 20.0,
    double orbitSpacing = 1.5, // Multiplier between consecutive orbits
    double gravitationalConstant = SimulationConstants.gravitationalConstant,
  }) {
    final placements = <OrbitalPlacement>[];

    for (int i = 0; i < orbitingBodies.length; i++) {
      final orbitRadius = baseOrbitRadius * math.pow(orbitSpacing, i);
      final orbitPhase =
          (2 * math.pi * i) / orbitingBodies.length; // Distribute evenly

      final placement = calculateCircularOrbit(
        centralBody: centralBody,
        orbitRadius: orbitRadius,
        orbitPhase: orbitPhase,
        gravitationalConstant: gravitationalConstant,
      );

      placements.add(placement);
    }

    return placements;
  }
}

/// Container for orbital placement calculations
class OrbitalPlacement {
  final vm.Vector3 position;
  final vm.Vector3 velocity;
  final double orbitRadius;
  final double orbitalPeriod; // Time for one complete orbit
  final double eccentricity; // 0 = circular, 0-1 = elliptical
  final double inclination; // Orbit inclination in radians

  const OrbitalPlacement({
    required this.position,
    required this.velocity,
    required this.orbitRadius,
    required this.orbitalPeriod,
    required this.eccentricity,
    required this.inclination,
  });

  /// Convert orbital period from simulation units to Earth days (approximate)
  double get orbitalPeriodInDays {
    // This conversion factor would need calibration based on simulation time scale
    return orbitalPeriod /
        (24 * 3600); // Assuming simulation time is in seconds
  }

  /// Check if this is a circular orbit
  bool get isCircular => eccentricity < 0.01;

  /// Check if this is a highly eccentric orbit
  bool get isHighlyEccentric => eccentricity > 0.5;
}
