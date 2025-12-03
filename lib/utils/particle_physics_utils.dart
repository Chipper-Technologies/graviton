import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/collision_particle.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Utilities for particle physics calculations in collision effects
class ParticlePhysicsUtils {
  ParticlePhysicsUtils._(); // Private constructor to prevent instantiation

  /// Calculate impact velocity between two colliding bodies
  ///
  /// Returns the relative velocity magnitude at collision point
  static double calculateImpactVelocity(Body body1, Body body2) {
    final relativeVelocity = body2.velocity - body1.velocity;
    return relativeVelocity.length;
  }

  /// Calculate collision impact energy
  ///
  /// Returns kinetic energy in the center of mass frame
  static double calculateImpactEnergy(Body body1, Body body2) {
    final relativeVelocity = body2.velocity - body1.velocity;
    final reducedMass = (body1.mass * body2.mass) / (body1.mass + body2.mass);
    return 0.5 * reducedMass * relativeVelocity.length2;
  }

  /// Calculate collision angle (impact direction)
  ///
  /// Returns normalized vector from body1 to body2
  static vm.Vector3 calculateCollisionDirection(Body body1, Body body2) {
    final direction = body2.position - body1.position;
    return direction.normalized();
  }

  /// Generate random velocity for debris particle
  ///
  /// Creates velocity based on impact energy and random ejection angle
  static vm.Vector3 generateDebrisVelocity({
    required vm.Vector3 collisionDirection,
    required double impactEnergy,
    required math.Random random,
    double spreadAngle = 45.0, // degrees
  }) {
    // Convert spread angle to radians
    final spreadRad = spreadAngle * (math.pi / 180.0);

    // Random angles for 3D spread
    final theta = random.nextDouble() * 2 * math.pi; // azimuthal
    final phi = (random.nextDouble() - 0.5) * spreadRad; // polar

    // Create random direction within cone
    final perpendicular1 = collisionDirection.cross(vm.Vector3(1, 0, 0));
    if (perpendicular1.length < 0.1) {
      // If collisionDirection is aligned with the x-axis, the cross product with (1, 0, 0) yields a zero vector.
      // In this case, we use the y-axis (0, 1, 0) as the fallback to ensure a valid perpendicular direction.
      perpendicular1.setFrom(collisionDirection.cross(vm.Vector3(0, 1, 0)));
    }
    perpendicular1.normalize();

    final perpendicular2 = collisionDirection.cross(perpendicular1);
    perpendicular2.normalize();

    // Combine to create ejection direction
    final direction =
        (collisionDirection * math.cos(phi)) +
        (perpendicular1 * (math.sin(phi) * math.cos(theta))) +
        (perpendicular2 * (math.sin(phi) * math.sin(theta)));

    // Scale velocity by impact energy (higher energy = faster particles)
    final speedScale = math.sqrt(impactEnergy) * 0.5;
    final speed = speedScale * (0.5 + random.nextDouble() * 0.5);

    return direction.normalized() * speed;
  }

  /// Generate color for debris particle based on body properties
  ///
  /// Creates temperature-based color with variation
  static Color generateDebrisColor({
    required Color baseColor,
    required double temperature,
    required math.Random random,
    double variation = 0.2,
  }) {
    // Hotter material appears brighter/whiter
    final tempFactor = (temperature / 10000.0).clamp(0.0, 1.0);
    final hotColor = Color.lerp(
      baseColor,
      AppColors.uiWhite,
      tempFactor * SimulationConstants.particleTemperatureLerpFactor,
    );

    // Add random variation
    final hsl = HSLColor.fromColor(hotColor ?? baseColor);
    final variedHsl = hsl.withLightness(
      (hsl.lightness + (random.nextDouble() - 0.5) * variation).clamp(0.0, 1.0),
    );

    return variedHsl.toColor();
  }

  /// Calculate particle size based on collision energy
  ///
  /// Larger impacts create larger particle fragments
  static double calculateParticleSize({
    required double impactEnergy,
    required math.Random random,
    double minSize = 0.5,
    double maxSize = 3.0,
  }) {
    final energyFactor = (math.log(impactEnergy + 1) / 10).clamp(0.0, 1.0);
    final baseSize = minSize + (maxSize - minSize) * energyFactor;

    // Add random variation
    return baseSize * (0.7 + random.nextDouble() * 0.6);
  }

  /// Calculate particle lifetime based on impact energy
  ///
  /// More energetic collisions create longer-lasting effects
  static double calculateParticleLifetime({
    required double impactEnergy,
    required math.Random random,
    double minLifetime = 0.5,
    double maxLifetime = 3.0,
  }) {
    final energyFactor = (math.log(impactEnergy + 1) / 10).clamp(0.0, 1.0);
    final baseLifetime =
        minLifetime + (maxLifetime - minLifetime) * energyFactor;

    // Add random variation
    return baseLifetime * (0.8 + random.nextDouble() * 0.4);
  }

  /// Create a single debris particle
  static CollisionParticle createDebrisParticle({
    required vm.Vector3 collisionPoint,
    required vm.Vector3 collisionDirection,
    required double impactEnergy,
    required Color baseColor,
    required double temperature,
    required math.Random random,
  }) {
    return CollisionParticle(
      position: collisionPoint.clone(),
      velocity: generateDebrisVelocity(
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        random: random,
      ),
      color: generateDebrisColor(
        baseColor: baseColor,
        temperature: temperature,
        random: random,
      ),
      size: calculateParticleSize(impactEnergy: impactEnergy, random: random),
      lifetime: calculateParticleLifetime(
        impactEnergy: impactEnergy,
        random: random,
      ),
      mass: 0.001, // Small mass for physics interactions
    );
  }

  /// Calculate shockwave parameters based on collision properties
  static Map<String, double> calculateShockwaveParameters({
    required double impactEnergy,
    required double combinedMass,
  }) {
    // Higher energy = larger, faster shockwave
    final energyFactor = math.log(impactEnergy + 1);

    final maxRadius = 20.0 + energyFactor * 15.0;
    final lifetime = 1.0 + energyFactor * 0.5;
    final thickness = 2.0 + energyFactor * 0.5;

    return {
      'maxRadius': maxRadius,
      'lifetime': lifetime,
      'thickness': thickness,
    };
  }

  /// Determine if collision is energetic enough for plasma jets
  ///
  /// Plasma jets only form in extremely high-energy collisions
  /// (typically massive star collisions)
  static bool shouldGeneratePlasmaJets({
    required double impactEnergy,
    required double totalMass,
    double massThreshold = 100.0, // Solar masses
    double energyThreshold = 1000.0,
  }) {
    return totalMass >= massThreshold && impactEnergy >= energyThreshold;
  }

  /// Calculate plasma jet velocity based on collision parameters
  static double calculatePlasmaJetVelocity({
    required double impactEnergy,
    required double temperature,
  }) {
    // Jets reach significant fractions of light speed in reality,
    // but we scale for visual effect in simulation
    final energyFactor = math.sqrt(impactEnergy);
    final tempFactor = math.sqrt(temperature / 10000.0);

    return (energyFactor * tempFactor * 50.0).clamp(10.0, 200.0);
  }

  /// Calculate number of particles to generate based on impact
  ///
  /// More energetic collisions produce more particles
  static int calculateParticleCount({
    required double impactEnergy,
    int minParticles = 5,
    int maxParticles = 50,
  }) {
    final energyFactor = (math.log(impactEnergy + 1) / 10).clamp(0.0, 1.0);
    return (minParticles + (maxParticles - minParticles) * energyFactor)
        .round();
  }
}
