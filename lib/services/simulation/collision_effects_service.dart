import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/models/particles/collision_particle.dart';
import 'package:graviton/models/particles/debris_cloud.dart';
import 'package:graviton/models/effects/plasma_jet.dart';
import 'package:graviton/models/effects/shockwave.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/particle_physics_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for generating and managing collision visual effects
///
/// This service creates particle-based visual effects when bodies collide,
/// including debris particles, shockwaves, material ejection clouds, and
/// plasma jets for high-energy impacts.
class CollisionEffectsService {
  /// Random number generator for particle variation
  final math.Random _random = math.Random();

  /// Active debris particles
  final List<CollisionParticle> debrisParticles = [];

  /// Active shockwaves
  final List<Shockwave> shockwaves = [];

  /// Active debris clouds
  final List<DebrisCloud> debrisClouds = [];

  /// Active plasma jets
  final List<PlasmaJet> plasmaJets = [];

  /// Settings for which effects are enabled
  bool showDebris = true;
  bool showShockwaves = true;
  bool showEjection = true;
  bool showPlasmaJets = false;

  /// Generate collision effects when two bodies merge
  ///
  /// Creates various particle effects based on collision properties
  /// and enabled settings
  void generateCollisionEffects({
    required Body body1,
    required Body body2,
    required vm.Vector3 collisionPoint,
  }) {
    // Calculate collision properties
    final impactEnergy = ParticlePhysicsUtils.calculateImpactEnergy(
      body1,
      body2,
    );
    final collisionDirection = ParticlePhysicsUtils.calculateCollisionDirection(
      body1,
      body2,
    );
    final totalMass = body1.mass + body2.mass;
    final avgTemperature = (body1.temperature + body2.temperature) / 2;
    final impactColor = _getImpactColor(body1, body2);

    // Generate debris particles
    if (showDebris &&
        debrisParticles.length < RenderingConstants.maxDebrisParticles) {
      _generateDebrisParticles(
        collisionPoint: collisionPoint,
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        baseColor: impactColor,
        temperature: avgTemperature,
      );
    }

    // Generate shockwaves
    if (showShockwaves) {
      _generateShockwave(
        collisionPoint: collisionPoint,
        impactEnergy: impactEnergy,
        combinedMass: totalMass,
        color: impactColor,
      );
    }

    // Generate material ejection cloud
    if (showEjection) {
      _generateDebrisCloud(
        collisionPoint: collisionPoint,
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        baseColor: impactColor,
        temperature: avgTemperature,
      );
    }

    // Generate plasma jets for high-energy collisions
    if (showPlasmaJets &&
        ParticlePhysicsUtils.shouldGeneratePlasmaJets(
          impactEnergy: impactEnergy,
          totalMass: totalMass,
        )) {
      _generatePlasmaJet(
        collisionPoint: collisionPoint,
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        temperature: avgTemperature,
        baseColor: impactColor,
      );
    }
  }

  /// Generate debris particles scattered from collision
  void _generateDebrisParticles({
    required vm.Vector3 collisionPoint,
    required vm.Vector3 collisionDirection,
    required double impactEnergy,
    required Color baseColor,
    required double temperature,
  }) {
    final particleCount = ParticlePhysicsUtils.calculateParticleCount(
      impactEnergy: impactEnergy,
      minParticles: 10,
      maxParticles: 40,
    );

    for (int i = 0; i < particleCount; i++) {
      final particle = ParticlePhysicsUtils.createDebrisParticle(
        collisionPoint: collisionPoint,
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        baseColor: baseColor,
        temperature: temperature,
        random: _random,
      );
      debrisParticles.add(particle);
    }
  }

  /// Generate expanding shockwave ring
  void _generateShockwave({
    required vm.Vector3 collisionPoint,
    required double impactEnergy,
    required double combinedMass,
    required Color color,
  }) {
    final params = ParticlePhysicsUtils.calculateShockwaveParameters(
      impactEnergy: impactEnergy,
      combinedMass: combinedMass,
    );

    final shockwave = Shockwave(
      position: collisionPoint.clone(),
      color: color.withValues(alpha: AppTypography.opacityVeryHigh),
      thickness: params['thickness']!,
      maxRadius: params['maxRadius']!,
      lifetime: params['lifetime']!,
      impactEnergy: impactEnergy,
    );

    shockwaves.add(shockwave);

    // Add second, slower shockwave for layered effect
    final secondShockwave = Shockwave(
      position: collisionPoint.clone(),
      color: color.withValues(alpha: AppTypography.opacityMedium),
      thickness:
          params['thickness']! *
          SimulationConstants.secondaryShockwaveThicknessMultiplier,
      maxRadius: params['maxRadius']! * 1.3,
      lifetime: params['lifetime']! * 1.5,
      impactEnergy: impactEnergy,
    );

    shockwaves.add(secondShockwave);
  }

  /// Generate billowing debris cloud
  void _generateDebrisCloud({
    required vm.Vector3 collisionPoint,
    required vm.Vector3 collisionDirection,
    required double impactEnergy,
    required Color baseColor,
    required double temperature,
  }) {
    // Limit cloud particles for performance
    if (debrisClouds.fold<int>(
          0,
          (sum, cloud) => sum + cloud.particles.length,
        ) >=
        RenderingConstants.maxCloudParticles) {
      return;
    }

    final particleCount = ParticlePhysicsUtils.calculateParticleCount(
      impactEnergy: impactEnergy,
      minParticles: 15,
      maxParticles: 30,
    );

    final cloudParticles = <CollisionParticle>[];

    // Generate particles with wider spread for cloud effect
    for (int i = 0; i < particleCount; i++) {
      final velocity = ParticlePhysicsUtils.generateDebrisVelocity(
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        random: _random,
        spreadAngle: 90.0, // Wider spread for cloud
      );

      final particle = CollisionParticle(
        position: collisionPoint.clone(),
        velocity:
            velocity *
            SimulationConstants.cloudVelocityMultiplier, // Slower than debris
        color:
            ParticlePhysicsUtils.generateDebrisColor(
              baseColor: baseColor,
              temperature: temperature,
              random: _random,
              variation: AppTypography.opacityFaint,
            ).withValues(
              alpha: AppTypography.opacityMediumHigh,
            ), // Semi-transparent
        size: ParticlePhysicsUtils.calculateParticleSize(
          impactEnergy: impactEnergy,
          random: _random,
          minSize: 1.0,
          maxSize: 4.0,
        ),
        lifetime: ParticlePhysicsUtils.calculateParticleLifetime(
          impactEnergy: impactEnergy,
          random: _random,
          minLifetime: 1.5,
          maxLifetime: 4.0,
        ),
        mass: 0.0005,
      );
      cloudParticles.add(particle);
    }

    final expansionRate =
        math.sqrt(impactEnergy) * SimulationConstants.cloudExpansionMultiplier;

    final cloud = DebrisCloud(
      particles: cloudParticles,
      centerOfMass: collisionPoint.clone(),
      expansionRate: expansionRate,
      lifetime: SimulationConstants.cloudLifetime,
      baseColor: baseColor,
      collisionDirection: collisionDirection,
    );

    debrisClouds.add(cloud);
  }

  /// Generate plasma jet for massive collisions
  void _generatePlasmaJet({
    required vm.Vector3 collisionPoint,
    required vm.Vector3 collisionDirection,
    required double impactEnergy,
    required double temperature,
    required Color baseColor,
  }) {
    // Limit jet particles for performance
    if (plasmaJets.fold<int>(0, (sum, jet) => sum + jet.particles.length) >=
        RenderingConstants.maxJetParticles) {
      return;
    }

    final jetVelocity = ParticlePhysicsUtils.calculatePlasmaJetVelocity(
      impactEnergy: impactEnergy,
      temperature: temperature,
    );

    final particleCount = ParticlePhysicsUtils.calculateParticleCount(
      impactEnergy: impactEnergy,
      minParticles: 8,
      maxParticles: 20,
    );

    final jetParticles = <CollisionParticle>[];

    // Generate collimated jet particles
    for (int i = 0; i < particleCount; i++) {
      final velocity = ParticlePhysicsUtils.generateDebrisVelocity(
        collisionDirection: collisionDirection,
        impactEnergy: impactEnergy,
        random: _random,
        spreadAngle:
            SimulationConstants.plasmaJetSpreadAngle, // Narrow cone for jet
      );

      // Scale velocity to jet speed
      final jetVel = velocity.normalized() * jetVelocity;

      final particle = CollisionParticle(
        position: collisionPoint.clone(),
        velocity: jetVel,
        color: _getPlasmaColor(temperature),
        size: ParticlePhysicsUtils.calculateParticleSize(
          impactEnergy: impactEnergy,
          random: _random,
          minSize: 0.8,
          maxSize: 2.0,
        ),
        lifetime: ParticlePhysicsUtils.calculateParticleLifetime(
          impactEnergy: impactEnergy,
          random: _random,
          minLifetime: 1.0,
          maxLifetime: 2.5,
        ),
      );
      jetParticles.add(particle);
    }

    final jet = PlasmaJet(
      particles: jetParticles,
      origin: collisionPoint.clone(),
      direction: collisionDirection,
      velocity: jetVelocity,
      lifetime: 2.5,
      baseColor: baseColor,
      temperature: temperature,
      isBipolar: true,
    );

    plasmaJets.add(jet);

    // Create opposing jet if bipolar
    if (jet.isBipolar) {
      final opposingJetParticles = <CollisionParticle>[];

      for (int i = 0; i < particleCount; i++) {
        final velocity = ParticlePhysicsUtils.generateDebrisVelocity(
          collisionDirection: collisionDirection * -1.0,
          impactEnergy: impactEnergy,
          random: _random,
          spreadAngle: SimulationConstants.plasmaJetSpreadAngle,
        );

        final jetVel = velocity.normalized() * jetVelocity;

        final particle = CollisionParticle(
          position: collisionPoint.clone(),
          velocity: jetVel,
          color: _getPlasmaColor(temperature),
          size: ParticlePhysicsUtils.calculateParticleSize(
            impactEnergy: impactEnergy,
            random: _random,
            minSize: 0.8,
            maxSize: 2.0,
          ),
          lifetime: ParticlePhysicsUtils.calculateParticleLifetime(
            impactEnergy: impactEnergy,
            random: _random,
            minLifetime: 1.0,
            maxLifetime: 2.5,
          ),
        );
        opposingJetParticles.add(particle);
      }

      final opposingJet = PlasmaJet(
        particles: opposingJetParticles,
        origin: collisionPoint.clone(),
        direction: collisionDirection * -1.0,
        velocity: jetVelocity,
        lifetime: 2.5,
        baseColor: baseColor,
        temperature: temperature,
        isBipolar: false, // Don't recursively create more jets
      );

      plasmaJets.add(opposingJet);
    }
  }

  /// Update all active effects
  ///
  /// [dt] - Time delta in seconds
  void update(double dt) {
    // Update debris particles
    for (final particle in debrisParticles) {
      particle.update(dt);
    }
    debrisParticles.removeWhere((p) => p.isExpired);

    // Update shockwaves
    for (final shockwave in shockwaves) {
      shockwave.update(dt);
    }
    shockwaves.removeWhere((s) => s.isExpired);

    // Update debris clouds
    for (final cloud in debrisClouds) {
      cloud.update(dt);
    }
    debrisClouds.removeWhere((c) => c.isExpired);

    // Update plasma jets
    for (final jet in plasmaJets) {
      jet.update(dt);
    }
    plasmaJets.removeWhere((j) => j.isExpired);
  }

  /// Clear all active effects
  void clearAll() {
    debrisParticles.clear();
    shockwaves.clear();
    debrisClouds.clear();
    plasmaJets.clear();
  }

  /// Get impact color from colliding bodies
  Color _getImpactColor(Body body1, Body body2) {
    // Use color of more massive body
    return body1.mass >= body2.mass ? body1.color : body2.color;
  }

  /// Get plasma color based on temperature
  Color _getPlasmaColor(double temperature) {
    if (temperature > 30000) {
      return AppColors.stellarOType; // Blue-white
    } else if (temperature > 15000) {
      return AppColors.stellarBType; // Blue
    } else if (temperature > 10000) {
      return AppColors.stellarAType; // White
    } else {
      return AppColors.stellarFType; // Yellow-white
    }
  }

  /// Get total active particle count across all effect types
  int get totalParticleCount {
    return debrisParticles.length +
        debrisClouds.fold<int>(
          0,
          (sum, cloud) => sum + cloud.particles.length,
        ) +
        plasmaJets.fold<int>(0, (sum, jet) => sum + jet.particles.length);
  }

  /// Get total active effect count
  int get totalEffectCount {
    return debrisParticles.length +
        shockwaves.length +
        debrisClouds.length +
        plasmaJets.length;
  }
}
