import 'package:flutter/material.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/models/particles/collision_particle.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a directional plasma jet from a massive star collision
///
/// Plasma jets are bipolar streams of superheated material ejected
/// along the collision axis at extremely high velocities.
class PlasmaJet {
  /// Collection of particles forming the jet stream
  List<CollisionParticle> particles;

  /// Origin point of the jet
  vm.Vector3 origin;

  /// Direction vector of the jet (normalized)
  vm.Vector3 direction;

  /// Velocity magnitude of the jet (units per second)
  double velocity;

  /// Current age in seconds
  double age;

  /// Total lifetime in seconds
  double lifetime;

  /// Base color (typically blue-white for hot plasma)
  Color baseColor;

  /// Temperature of the plasma (affects color and intensity)
  double temperature;

  /// Whether this is a bipolar jet (creates opposing jet)
  bool isBipolar;

  PlasmaJet({
    required this.particles,
    required this.origin,
    required this.direction,
    required this.velocity,
    this.age = 0,
    required this.lifetime,
    required this.baseColor,
    required this.temperature,
    this.isBipolar = true,
  });

  /// Calculate jet opacity based on age and temperature
  double get opacity {
    if (age >= lifetime) return 0.0;
    final ageFactor = 1.0 - (age / lifetime);
    // Hotter jets are brighter
    final tempFactor = (temperature / SimulationConstants.plasmaMaxTemperature)
        .clamp(
          SimulationConstants.plasmaMinOpacityFactor,
          SimulationConstants.plasmaMaxOpacityFactor,
        );
    return ageFactor * tempFactor;
  }

  /// Check if the jet has expired
  bool get isExpired => age >= lifetime || particles.isEmpty;

  /// Get the length of the jet (distance from origin to farthest particle)
  double get length {
    if (particles.isEmpty) return 0.0;

    return particles
        .map((p) => (p.position - origin).length)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Get the number of active particles
  int get activeParticleCount => particles.where((p) => !p.isExpired).length;

  /// Update all particles in the jet
  ///
  /// [dt] - Time delta in seconds
  void update(double dt) {
    age += dt;

    // Update each particle
    for (final particle in particles) {
      particle.update(dt);
    }

    // Remove expired particles
    particles.removeWhere((p) => p.isExpired);
  }

  /// Get color adjusted for temperature
  ///
  /// Hotter plasma appears more blue-white, cooler appears more red-orange
  Color get temperatureAdjustedColor {
    if (temperature > 30000) {
      // Very hot: blue-white
      return Color.lerp(baseColor, AppColors.uiWhite, 0.6) ?? baseColor;
    } else if (temperature > 15000) {
      // Hot: blue tinted
      return Color.lerp(baseColor, AppColors.primaryColor, 0.4) ?? baseColor;
    } else {
      // Cooler: orange-red tinted
      return Color.lerp(baseColor, AppColors.stellarKType, 0.3) ?? baseColor;
    }
  }

  /// Create a copy of this jet with updated values
  PlasmaJet copyWith({
    List<CollisionParticle>? particles,
    vm.Vector3? origin,
    vm.Vector3? direction,
    double? velocity,
    double? age,
    double? lifetime,
    Color? baseColor,
    double? temperature,
    bool? isBipolar,
  }) {
    return PlasmaJet(
      particles: particles ?? this.particles.map((p) => p.copyWith()).toList(),
      origin: origin ?? this.origin.clone(),
      direction: direction ?? this.direction.clone(),
      velocity: velocity ?? this.velocity,
      age: age ?? this.age,
      lifetime: lifetime ?? this.lifetime,
      baseColor: baseColor ?? this.baseColor,
      temperature: temperature ?? this.temperature,
      isBipolar: isBipolar ?? this.isBipolar,
    );
  }
}
