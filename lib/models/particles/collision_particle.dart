import 'package:flutter/material.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a single debris particle ejected from a collision
///
/// Debris particles are physics-based particles that follow trajectories
/// based on the collision impact velocity and angle. They gradually fade
/// out and slow down over their lifetime.
class CollisionParticle {
  /// 3D position of the particle
  vm.Vector3 position;

  /// Velocity vector (units per second)
  vm.Vector3 velocity;

  /// Particle color (based on body temperature/composition)
  Color color;

  /// Visual size of the particle
  double size;

  /// Current age in seconds
  double age;

  /// Total lifetime in seconds before particle disappears
  double lifetime;

  /// Mass of the particle (for gravity interactions)
  double mass;

  CollisionParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    this.age = 0,
    required this.lifetime,
    this.mass = 0.0,
  });

  /// Calculate the opacity based on particle age
  ///
  /// Returns 1.0 at birth, fading to 0.0 at end of lifetime
  double get opacity {
    if (age >= lifetime) return 0.0;
    return 1.0 - (age / lifetime);
  }

  /// Check if the particle has exceeded its lifetime
  bool get isExpired => age >= lifetime;

  /// Update particle position and age
  ///
  /// [dt] - Time delta in seconds
  /// [gravityAcceleration] - Optional gravity acceleration to apply
  void update(double dt, {vm.Vector3? gravityAcceleration}) {
    age += dt;

    // Apply gravity if provided
    if (gravityAcceleration != null) {
      velocity += gravityAcceleration * dt;
    }

    // Update position based on velocity
    position += velocity * dt;

    // Apply drag/friction to slow down particles over time
    velocity *= SimulationConstants.particleDragCoefficient;
  }

  /// Create a copy of this particle with updated values
  CollisionParticle copyWith({
    vm.Vector3? position,
    vm.Vector3? velocity,
    Color? color,
    double? size,
    double? age,
    double? lifetime,
    double? mass,
  }) {
    return CollisionParticle(
      position: position ?? this.position.clone(),
      velocity: velocity ?? this.velocity.clone(),
      color: color ?? this.color,
      size: size ?? this.size,
      age: age ?? this.age,
      lifetime: lifetime ?? this.lifetime,
      mass: mass ?? this.mass,
    );
  }
}
