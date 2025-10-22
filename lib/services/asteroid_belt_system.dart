import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/models/asteroid_particle.dart';
import 'package:graviton/theme/app_colors.dart';

/// Manages a particle-based asteroid belt system
/// Provides efficient rendering of thousands of asteroids without N-body physics
class AsteroidBeltSystem {
  final List<AsteroidParticle> _particles = [];
  final math.Random _random = math.Random();

  /// Generate asteroid belt with specified parameters
  void generateBelt({
    required double innerRadius,
    required double outerRadius,
    required int particleCount,
    required double centralMass,
    double gravitationalConstant = 1.2,
    Color baseColor =
        AppColors.asteroidBrownish, // Default brownish asteroid color
    double colorVariation = 0.3, // How much color can vary (0.0 to 1.0)
    bool useXZPlane =
        false, // true for solar system (XZ), false for asteroid belt scenario (XY)
    double minSize = 0.04, // Minimum particle size
    double maxSize = 0.16, // Maximum particle size
    double maxInclination =
        0.15, // Maximum inclination in radians (default ±4.3°)
    double radialDistribution =
        1.0, // 1.0 = even, >1.0 = more packed toward inner edge
  }) {
    _particles.clear();

    for (int i = 0; i < particleCount; i++) {
      // Random position within belt with configurable distribution
      final t = _random.nextDouble();
      final radius =
          innerRadius +
          (outerRadius - innerRadius) *
              math.pow(
                t,
                1.0 / radialDistribution,
              ); // Configurable distribution

      // Random starting angle
      final phase = _random.nextDouble() * 2 * math.pi;

      // Calculate orbital speed for stable circular orbit
      final speed = math.sqrt(gravitationalConstant * centralMass / radius);

      // Add some speed variation for elliptical orbits and slow it down significantly
      final speedVariation = 0.9 + _random.nextDouble() * 0.2; // ±10% variation
      var finalSpeed =
          speed *
          speedVariation *
          0.02; // Much much slower - 2% of calculated speed

      // Fix rotation direction for solar system (XZ plane) to match planetary motion
      if (useXZPlane) {
        finalSpeed =
            -finalSpeed; // Negative for counterclockwise rotation in XZ plane
      }

      // Configurable inclination for different scenarios
      final inclination =
          (_random.nextDouble() - 0.5) *
          maxInclination; // Configurable inclination range

      // Random asteroid appearance - customizable particle sizes
      final size = minSize + _random.nextDouble() * (maxSize - minSize);

      // Generate color based on base color with variation
      final brightness =
          0.7 + _random.nextDouble() * 0.3; // 70% to 100% brightness
      final variation =
          (_random.nextDouble() - 0.5) * colorVariation; // ±variation amount

      final red = ((baseColor.r + variation) * brightness * 255)
          .clamp(0, 255)
          .round();
      final green = ((baseColor.g + variation) * brightness * 255)
          .clamp(0, 255)
          .round();
      final blue = ((baseColor.b + variation) * brightness * 255)
          .clamp(0, 255)
          .round();

      final color = Color.fromARGB(255, red, green, blue);

      // Small eccentricity for more realistic orbits
      final eccentricity = _random.nextDouble() * 0.1; // 0-10% eccentricity

      _particles.add(
        AsteroidParticle(
          orbitRadius: radius,
          orbitSpeed: finalSpeed,
          orbitPhase: phase,
          inclination: inclination,
          color: color,
          size: size,
          eccentricity: eccentricity,
          useXZPlane: useXZPlane,
        ),
      );
    }
  }

  /// Update all particles
  void update(double deltaTime) {
    for (final particle in _particles) {
      particle.update(deltaTime);
    }
  }

  /// Get all particle positions and properties for rendering
  List<AsteroidParticle> get particles => List.unmodifiable(_particles);

  /// Get particle count
  int get particleCount => _particles.length;

  /// Clear all particles
  void clear() {
    _particles.clear();
  }
}
