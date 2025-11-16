import 'package:vector_math/vector_math_64.dart' as vm;

/// Container for orbital placement calculations
///
/// This model encapsulates the results of orbital mechanics calculations,
/// providing both position and velocity vectors along with orbital parameters
/// for physics-accurate celestial body placement in gravitational simulations.
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
