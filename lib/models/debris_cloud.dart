import 'package:flutter/material.dart';
import 'package:graviton/models/collision_particle.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a cloud of material ejected from a collision
///
/// Debris clouds are collections of particles that expand outward
/// in a billowing, asymmetric pattern based on the collision angle.
class DebrisCloud {
  /// Collection of particles in this cloud
  List<CollisionParticle> particles;

  /// Center of mass position
  vm.Vector3 centerOfMass;

  /// Overall expansion rate (units per second)
  double expansionRate;

  /// Current age in seconds
  double age;

  /// Total lifetime in seconds
  double lifetime;

  /// Base color of the cloud
  Color baseColor;

  /// Collision direction vector (for asymmetric expansion)
  vm.Vector3 collisionDirection;

  DebrisCloud({
    required this.particles,
    required this.centerOfMass,
    required this.expansionRate,
    this.age = 0,
    required this.lifetime,
    required this.baseColor,
    required this.collisionDirection,
  });

  /// Calculate the average opacity of the cloud
  double get opacity {
    if (particles.isEmpty) return 0.0;
    final avgOpacity =
        particles.map((p) => p.opacity).reduce((a, b) => a + b) /
        particles.length;
    return avgOpacity;
  }

  /// Check if the cloud has expired
  bool get isExpired => age >= lifetime || particles.isEmpty;

  /// Get the number of active particles
  int get activeParticleCount => particles.where((p) => !p.isExpired).length;

  /// Update all particles in the cloud
  ///
  /// [dt] - Time delta in seconds
  /// [gravityAcceleration] - Optional gravity to apply to particles
  void update(double dt, {vm.Vector3? gravityAcceleration}) {
    age += dt;

    // Update center of mass
    if (particles.isNotEmpty) {
      centerOfMass = _calculateCenterOfMass();
    }

    // Update each particle
    for (final particle in particles) {
      particle.update(dt, gravityAcceleration: gravityAcceleration);
    }

    // Remove expired particles
    particles.removeWhere((p) => p.isExpired);
  }

  /// Calculate the current center of mass from all particles
  vm.Vector3 _calculateCenterOfMass() {
    if (particles.isEmpty) return centerOfMass;

    final sum = particles.fold<vm.Vector3>(
      vm.Vector3.zero(),
      (acc, p) => acc + p.position,
    );

    return sum / particles.length.toDouble();
  }

  /// Get the current radius of the cloud (distance from center to farthest particle)
  double get radius {
    if (particles.isEmpty) return 0.0;

    return particles
        .map((p) => (p.position - centerOfMass).length)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Create a copy of this cloud with updated values
  DebrisCloud copyWith({
    List<CollisionParticle>? particles,
    vm.Vector3? centerOfMass,
    double? expansionRate,
    double? age,
    double? lifetime,
    Color? baseColor,
    vm.Vector3? collisionDirection,
  }) {
    return DebrisCloud(
      particles: particles ?? this.particles.map((p) => p.copyWith()).toList(),
      centerOfMass: centerOfMass ?? this.centerOfMass.clone(),
      expansionRate: expansionRate ?? this.expansionRate,
      age: age ?? this.age,
      lifetime: lifetime ?? this.lifetime,
      baseColor: baseColor ?? this.baseColor,
      collisionDirection: collisionDirection ?? this.collisionDirection.clone(),
    );
  }
}
