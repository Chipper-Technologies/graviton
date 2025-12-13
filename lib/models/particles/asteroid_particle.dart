import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Lightweight particle for asteroid belt visualization
/// These don't participate in N-body physics but follow predefined orbital paths
class AsteroidParticle {
  final double orbitRadius;
  final double orbitSpeed;
  final double orbitPhase; // Starting angle
  final double inclination; // Orbital inclination in radians
  final Color color;
  final double size;
  final double eccentricity;
  final bool
  useXZPlane; // true for solar system (XZ), false for asteroid belt scenario (XY)

  late double _currentAngle;

  AsteroidParticle({
    required this.orbitRadius,
    required this.orbitSpeed,
    required this.orbitPhase,
    required this.inclination,
    required this.color,
    required this.size,
    this.eccentricity = 0.0,
    this.useXZPlane = false,
  }) {
    _currentAngle = orbitPhase;
  }

  /// Update particle position based on elapsed time
  void update(double deltaTime) {
    _currentAngle += orbitSpeed * deltaTime;

    // Keep angle in [0, 2π] range
    _currentAngle = _currentAngle % (2 * math.pi);
  }

  /// Get current 3D position of the particle
  vm.Vector3 get position {
    // Calculate elliptical orbit position
    final currentRadius =
        orbitRadius * (1 - eccentricity * math.cos(_currentAngle));

    if (useXZPlane) {
      // Solar system coordinate system: base orbit in XZ plane (horizontal)
      final x = currentRadius * math.cos(_currentAngle);
      final z = currentRadius * math.sin(_currentAngle);
      var y = 0.0;

      // Apply inclination (rotation around X-axis)
      if (inclination != 0.0) {
        final zInclined = z * math.cos(inclination) - y * math.sin(inclination);
        final yInclined = z * math.sin(inclination) + y * math.cos(inclination);
        return vm.Vector3(x, yInclined, zInclined);
      }

      return vm.Vector3(x, y, z);
    } else {
      // Asteroid belt scenario coordinate system: base orbit in XY plane (vertical)
      final x = currentRadius * math.cos(_currentAngle);
      final y = currentRadius * math.sin(_currentAngle);
      var z = 0.0;

      // Apply inclination (rotation around X-axis)
      if (inclination != 0.0) {
        final yInclined = y * math.cos(inclination) - z * math.sin(inclination);
        final zInclined = y * math.sin(inclination) + z * math.cos(inclination);
        return vm.Vector3(x, yInclined, zInclined);
      }

      return vm.Vector3(x, y, z);
    }
  }

  /// Get current angle for debugging
  double get currentAngle => _currentAngle;
}
