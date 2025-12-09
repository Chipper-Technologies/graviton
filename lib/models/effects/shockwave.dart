import 'package:flutter/material.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents an expanding shockwave ring from a collision
///
/// Shockwaves are circular energy rings that expand outward from
/// the collision point, with their size and intensity scaled by
/// the impact energy.
class Shockwave {
  /// 3D position of the shockwave center
  vm.Vector3 position;

  /// Current radius of the expanding ring
  double radius;

  /// Color of the shockwave (based on collision energy)
  Color color;

  /// Thickness of the ring line
  double thickness;

  /// Current age in seconds
  double age;

  /// Maximum radius the shockwave will reach
  double maxRadius;

  /// Total lifetime in seconds
  double lifetime;

  /// Initial impact energy (for intensity calculation)
  double impactEnergy;

  Shockwave({
    required this.position,
    this.radius = 0.0,
    required this.color,
    required this.thickness,
    this.age = 0,
    required this.maxRadius,
    required this.lifetime,
    required this.impactEnergy,
  });

  /// Calculate the opacity based on shockwave age
  ///
  /// Starts at high opacity, fades to 0 at end of lifetime
  double get opacity {
    if (age >= lifetime) return 0.0;
    // Exponential fade for more dramatic effect
    final t = age / lifetime;
    return (1.0 - t) * AppTypography.opacityHigh;
  }

  /// Check if the shockwave has exceeded its lifetime
  bool get isExpired => age >= lifetime;

  /// Get the normalized expansion progress (0.0 to 1.0)
  double get expansionProgress {
    return (radius / maxRadius).clamp(0.0, 1.0);
  }

  /// Update shockwave expansion and age
  ///
  /// [dt] - Time delta in seconds
  void update(double dt) {
    age += dt;

    // Expand radius based on progress through lifetime
    final targetRadius = maxRadius * (age / lifetime);
    radius = targetRadius.clamp(0.0, maxRadius);

    // Thickness decreases as shockwave expands
    thickness *= SimulationConstants.shockwaveThicknessDecayRate;
  }

  /// Create a copy of this shockwave with updated values
  Shockwave copyWith({
    vm.Vector3? position,
    double? radius,
    Color? color,
    double? thickness,
    double? age,
    double? maxRadius,
    double? lifetime,
    double? impactEnergy,
  }) {
    return Shockwave(
      position: position ?? this.position.clone(),
      radius: radius ?? this.radius,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      age: age ?? this.age,
      maxRadius: maxRadius ?? this.maxRadius,
      lifetime: lifetime ?? this.lifetime,
      impactEnergy: impactEnergy ?? this.impactEnergy,
    );
  }
}
