import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a single particle in a planetary ring system
class RingParticle {
  double orbitRadius;
  double orbitSpeed;
  double orbitPhase;
  double inclination;
  Color color;
  double size;
  bool useXZPlane;

  // Current position (calculated during update)
  vm.Vector3 position = vm.Vector3.zero();

  RingParticle({
    required this.orbitRadius,
    required this.orbitSpeed,
    required this.orbitPhase,
    required this.inclination,
    required this.color,
    required this.size,
    this.useXZPlane = false,
  });

  /// Update particle position based on orbital mechanics
  void update(double deltaTime) {
    // Update orbital phase
    orbitPhase += orbitSpeed * deltaTime;

    // Calculate position in orbital plane
    final x = orbitRadius * math.cos(orbitPhase);
    final y = orbitRadius * math.sin(orbitPhase);
    final z = orbitRadius * math.sin(inclination);

    if (useXZPlane) {
      // For solar system (horizontal plane)
      position = vm.Vector3(x, z, y);
    } else {
      // For planetary rings (vertical plane for side view)
      position = vm.Vector3(x, y, z);
    }
  }
}
