// Copyright (c) 2025 Chipper Technologies, LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/services/asteroid_belt_system.dart';
import 'package:graviton/services/habitable_zone_service.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:vibration/vibration.dart';

/// Core physics simulation for Graviton
class Simulation {
  // Physics parameters (now instance variables for real-time adjustment)
  double gravitationalConstant = SimulationConstants.gravitationalConstant;
  double softening = SimulationConstants.softening;
  double collisionRadiusMultiplier = SimulationConstants.collisionRadiusMultiplier;
  int maxTrail = SimulationConstants.maxTrailPoints;
  double fadeRate = SimulationConstants.trailFadeRate;
  double vibrationThrottleTime = SimulationConstants.vibrationThrottleTime;
  bool vibrationEnabled = true;

  List<Body> bodies = [];
  List<List<TrailPoint>> trails = [];
  List<MergeFlash> mergeFlashes = [];

  // Asteroid belt particle systems
  final AsteroidBeltSystem asteroidBelt = AsteroidBeltSystem();
  final AsteroidBeltSystem kuiperBelt = AsteroidBeltSystem();

  double _timeSinceLastVibe = 0; // throttle vibration
  final ScenarioService _scenarioService = ScenarioService();
  final HabitableZoneService _habitableZoneService = HabitableZoneService();
  ScenarioType _currentScenario = ScenarioType.random;

  // Habitability update throttling
  double _timeSinceLastHabitabilityUpdate = 0.0;
  static const double _habitabilityUpdateInterval = 0.1; // Update every 0.1 seconds

  Simulation() {
    reset();
  }

  /// Get the current scenario type
  ScenarioType get currentScenario => _currentScenario;

  /// Update physics parameters for real-time adjustment
  void updatePhysicsSettings({
    double? gravitationalConstant,
    double? softening,
    double? collisionRadiusMultiplier,
    int? maxTrailPoints,
    double? trailFadeRate,
    double? vibrationThrottleTime,
    bool? vibrationEnabled,
  }) {
    if (gravitationalConstant != null) {
      this.gravitationalConstant = gravitationalConstant;
    }
    if (softening != null) {
      this.softening = softening;
    }
    if (collisionRadiusMultiplier != null) {
      this.collisionRadiusMultiplier = collisionRadiusMultiplier;
    }
    if (maxTrailPoints != null) {
      maxTrail = maxTrailPoints;
    }
    if (trailFadeRate != null) {
      fadeRate = trailFadeRate;
    }
    if (vibrationThrottleTime != null) {
      this.vibrationThrottleTime = vibrationThrottleTime;
    }
    if (vibrationEnabled != null) {
      this.vibrationEnabled = vibrationEnabled;
    }
  }

  /// Set gravitational constant
  void setGravitationalConstant(double value) {
    gravitationalConstant = value;
  }

  /// Set softening parameter
  void setSoftening(double value) {
    softening = value;
  }

  /// Set collision radius multiplier
  void setCollisionRadiusMultiplier(double value) {
    collisionRadiusMultiplier = value;
  }

  /// Set maximum trail points
  void setMaxTrailPoints(int value) {
    maxTrail = value;
  }

  /// Set trail fade rate
  void setTrailFadeRate(double value) {
    fadeRate = value;
  }

  /// Set vibration throttle time
  void setVibrationThrottleTime(double value) {
    vibrationThrottleTime = value;
  }

  /// Set vibration enabled
  void setVibrationEnabled(bool value) {
    vibrationEnabled = value;
  }

  /// Reset simulation with current scenario
  void reset() {
    resetWithScenario(_currentScenario);
  }

  /// Reset simulation with a specific scenario
  void resetWithScenario(ScenarioType scenario, {AppLocalizations? l10n}) {
    _currentScenario = scenario;
    bodies = _scenarioService.generateScenario(scenario, l10n: l10n);
    trails = List.generate(bodies.length, (_) => <TrailPoint>[]);
    mergeFlashes.clear();
    _timeSinceLastVibe = 0;

    // Initialize belt systems based on scenario
    if (scenario == ScenarioType.asteroidBelt) {
      // Clear any existing particles
      asteroidBelt.clear();
      kuiperBelt.clear();

      // Generate asteroid belt around the central star
      // Belt parameters: fits perfectly within outer planet orbit
      asteroidBelt.generateBelt(
        innerRadius: 8.0, // Closer to center
        outerRadius: 22.0, // Reduced to fit neatly within outer planet orbit (30.0)
        particleCount: 2500, // More particles for denser belt
        centralMass: 20.0, // Match the central star mass
        gravitationalConstant: 1.2,
        baseColor: AppColors.asteroidBrownish, // Brownish asteroids
        colorVariation: 0.2,
        useXZPlane: false, // Asteroid belt scenario uses XY plane
        minSize: 0.02, // Smaller particles for asteroid belt scenario
        maxSize: 0.08, // Reduced maximum size for subtler appearance
      );
    } else if (scenario == ScenarioType.solarSystem) {
      // Clear any existing particles
      asteroidBelt.clear();
      kuiperBelt.clear();

      // Generate realistic asteroid belt between Mars (76.0) and Jupiter (260.0)
      asteroidBelt.generateBelt(
        innerRadius: 110.0, // Between Mars and Jupiter
        outerRadius: 200.0, // Closer to Jupiter's orbit
        particleCount: 3000, // Increased density for better visibility
        centralMass: 50.0, // Match the Sun's mass
        gravitationalConstant: 1.2,
        baseColor: AppColors.asteroidBrownish, // Brownish asteroids
        colorVariation: 0.2,
        useXZPlane: true, // Solar system uses XZ plane (horizontal)
      );

      // Generate Kuiper belt at realistic astronomical distance
      kuiperBelt.generateBelt(
        innerRadius: 1200.0, // ~30 AU - where Kuiper belt actually begins
        outerRadius: 1600.0, // ~50 AU - classical Kuiper belt edge
        particleCount: 3000, // Dense population for realism
        centralMass: 50.0, // Match the Sun's mass
        gravitationalConstant: 1.2,
        baseColor: AppColors.kuiperBeltIcy, // Icy blue-white for Kuiper objects
        colorVariation: 0.3, // More variation for distant objects
        useXZPlane: true, // Solar system uses XZ plane (horizontal)
        minSize: 0.10, // Smaller for more subtle appearance
        maxSize: 0.20, // Reduced maximum size
      );
    } else if (scenario == ScenarioType.galaxyFormation) {
      // Clear any existing particles
      asteroidBelt.clear();
      kuiperBelt.clear();

      // Generate galactic disk using asteroid belt system for background stars/dust
      asteroidBelt.generateBelt(
        innerRadius: 10.0, // Start closer to center
        outerRadius: 300.0, // Much wider disk to encompass all stars (was 150)
        particleCount: 15000, // Optimal density for good performance (was 100000)
        centralMass: 200.0, // Match the supermassive black hole mass
        gravitationalConstant: 1.2,
        baseColor: AppColors.accretionGold, // Bright gold - intense galactic core glow
        colorVariation: 0.6, // High variation for dynamic glow effect
        useXZPlane: false, // Galaxy in XY plane (vertical) to match main stars
        minSize: 0.03, // Larger particles for stronger glow
        maxSize: 0.12, // Much larger for intense luminosity
      );

      // Generate outer galactic halo for extended structure
      kuiperBelt.generateBelt(
        innerRadius: 300.0, // Beyond main disk
        outerRadius: 500.0, // Much wider extended halo
        particleCount: 8000, // Reasonable outer structure (was 50000)
        centralMass: 200.0, // Match the supermassive black hole mass
        gravitationalConstant: 1.2,
        baseColor: AppColors.accretionMoccasin, // Moccasin - warm outer glow extending from center
        colorVariation: 0.5, // Strong variation for glow effect
        useXZPlane: false, // Galaxy in XY plane (vertical) to match main stars
        minSize: 0.025, // Larger halo particles for extended glow
        maxSize: 0.09, // Substantial outer glow particles
      );
    } else {
      // Clear asteroid belts for other scenarios
      asteroidBelt.clear();
      kuiperBelt.clear();
    }
  }

  void pushTrails(double dt) {
    // Ensure trails array matches bodies array length
    while (trails.length > bodies.length) {
      trails.removeLast();
    }
    while (trails.length < bodies.length) {
      trails.add(<TrailPoint>[]);
    }

    // First fade existing trail points, then add new ones
    for (int i = 0; i < bodies.length && i < trails.length; i++) {
      // Calculate custom fade rate and max trail for specific bodies in asteroid belt
      double customFadeRate = fadeRate;
      int customMaxTrail = maxTrail;

      if (_currentScenario == ScenarioType.asteroidBelt) {
        // For asteroid belt scenario: shorten inner planet trail (body index 2)
        if (i == 2 && bodies[i].name.contains('Inner')) {
          customFadeRate = fadeRate * 20.0; // Fade 20x faster (almost instant)
          customMaxTrail = math.max(1, maxTrail ~/ 20); // 1/20 the length (tiny trail)
        }
      } else if (_currentScenario == ScenarioType.galaxyFormation) {
        // For galaxy formation: dynamic trails based on velocity and distance from black hole
        final body = bodies[i];

        // Skip the black hole (index 0)
        if (i > 0 && body.bodyType == BodyType.star) {
          // Calculate distance and velocity from galactic center
          final distanceFromCenter = body.position.length;
          final velocity = body.velocity.length;

          // Create dramatic trail shortening effect as stars approach black hole
          if (distanceFromCenter < 100.0) {
            // Within galaxy disk
            // Combine distance and velocity effects for realistic physics
            final proximityFactor = math.max(0.0, (100.0 - distanceFromCenter) / 100.0); // 0 to 1

            // Velocity factor: faster stars = shorter trails (more frantic motion)
            final velocityFactor = math.min(1.0, velocity / 5.0); // Normalize to 0-1

            // Combined effect: both proximity and velocity shorten trails
            final combinedFactor = (proximityFactor * 0.7) + (velocityFactor * 0.3);

            // Trail length decreases dramatically near black hole and with high velocity
            final lengthReduction = 1.0 - (combinedFactor * 0.95); // Reduce up to 95%
            customMaxTrail = math.max(2, (maxTrail * lengthReduction).round());

            // Fade rate increases with both proximity and velocity
            final fadeIncrease = 1.0 + (combinedFactor * 6.0); // Up to 7x faster fade for fast, close stars
            customFadeRate = fadeRate * fadeIncrease;

            // Very close to black hole: short but visible trails
            if (distanceFromCenter < 20.0) {
              customMaxTrail = math.max(3, customMaxTrail ~/ 2); // Short but visible
              customFadeRate *= 2.0; // Faster fade
            }
          }
        }
      }

      // Fade existing trail points
      for (final pt in trails[i]) {
        pt.alpha *= math.exp(-customFadeRate * dt);
      }
      trails[i].removeWhere((pt) => pt.alpha < SimulationConstants.trailAlphaThreshold);

      // Add newest trail point with full alpha (don't fade this one)
      trails[i].add(TrailPoint(bodies[i].position.clone(), 1.0));

      // keep memory in check with custom max trail
      if (trails[i].length > customMaxTrail) {
        trails[i].removeRange(0, trails[i].length - customMaxTrail);
      }
    }

    // update flashes
    for (final f in mergeFlashes) {
      f.age += dt;
    }

    mergeFlashes.removeWhere((f) => f.age > SimulationConstants.flashDuration);

    // update vibration throttle
    _timeSinceLastVibe += dt;
  }

  // --- Physics (RK4) ---------------------------------------------------------

  void stepRK4(double dt) {
    final n = bodies.length;
    final initPos = [for (var b in bodies) b.position.clone()];
    final initVel = [for (var b in bodies) b.velocity.clone()];

    List<vm.Vector3> accelerations(List<vm.Vector3> pos) {
      final a = List.generate(n, (_) => vm.Vector3.zero());
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if (i == j) continue;
          final r = pos[j] - pos[i];
          final dist2 = r.length2;

          // Balanced softening for galaxy formation - allows spiraling into black hole
          double softening = SimulationConstants.softening;
          if (_currentScenario == ScenarioType.galaxyFormation) {
            // Use moderate softening that allows realistic orbital decay without sudden stops
            if (i == 0 || j == 0) {
              final distance = math.sqrt(dist2);
              if (distance < 10.0) {
                // Very close - use small softening to allow absorption but prevent singularities
                softening = 0.05;
              } else if (distance < 20.0) {
                // Close - moderate softening for realistic spiral
                softening = 0.1;
              } else {
                // Normal distance - regular softening
                softening = SimulationConstants.softening;
              }
            }
          }

          final softDist2 = dist2 + softening;
          final invR = 1.0 / math.sqrt(softDist2);
          final invR3 = invR * invR * invR;
          a[i] += r * (gravitationalConstant * bodies[j].mass * invR3);
        }
      }
      return a;
    }

    final k1x = [for (int i = 0; i < n; i++) initVel[i].clone()];
    final k1v = accelerations(initPos);

    final p2 = [for (int i = 0; i < n; i++) initPos[i] + k1x[i] * (dt / 2)];
    final v2 = [for (int i = 0; i < n; i++) initVel[i] + k1v[i] * (dt / 2)];
    final k2x = [for (int i = 0; i < n; i++) v2[i].clone()];
    final k2v = accelerations(p2);

    final p3 = [for (int i = 0; i < n; i++) initPos[i] + k2x[i] * (dt / 2)];
    final v3 = [for (int i = 0; i < n; i++) initVel[i] + k2v[i] * (dt / 2)];
    final k3x = [for (int i = 0; i < n; i++) v3[i].clone()];
    final k3v = accelerations(p3);

    final p4 = [for (int i = 0; i < n; i++) initPos[i] + k3x[i] * dt];
    final v4 = [for (int i = 0; i < n; i++) initVel[i] + k3v[i] * dt];
    final k4x = [for (int i = 0; i < n; i++) v4[i].clone()];
    final k4v = accelerations(p4);

    for (int i = 0; i < n; i++) {
      bodies[i].position = initPos[i] + (k1x[i] + k2x[i] * 2 + k3x[i] * 2 + k4x[i]) * (dt / 6);
      bodies[i].velocity = initVel[i] + (k1v[i] + k2v[i] * 2 + k3v[i] * 2 + k4v[i]) * (dt / 6);
    }

    // Special case: Keep central star fixed in asteroid belt scenario
    if (_currentScenario == ScenarioType.asteroidBelt && bodies.isNotEmpty) {
      bodies[0].position = vm.Vector3.zero(); // Force central star to stay at origin
      bodies[0].velocity = vm.Vector3.zero(); // Force central star to have zero velocity
      // Allow other bodies (companions) to move normally
    }

    // Special case: Keep supermassive black hole fixed at galaxy center
    if (_currentScenario == ScenarioType.galaxyFormation && bodies.isNotEmpty) {
      bodies[0].position = vm.Vector3.zero(); // Force black hole to stay at galactic center
      bodies[0].velocity = vm.Vector3.zero(); // Force black hole to have zero velocity

      // Allow natural orbital dynamics - no artificial barriers or damping
      // Allow all stars to orbit around the fixed black hole
    }

    _handleCollisions();

    // Update dynamic star colors for galaxy formation
    if (_currentScenario == ScenarioType.galaxyFormation) {
      _updateDynamicStarColors();
    }

    // Update asteroid belt particles (if active)
    if (_currentScenario == ScenarioType.asteroidBelt) {
      asteroidBelt.update(dt);
    } else if (_currentScenario == ScenarioType.solarSystem) {
      asteroidBelt.update(dt); // Main asteroid belt
      kuiperBelt.update(dt); // Kuiper belt
    } else if (_currentScenario == ScenarioType.galaxyFormation) {
      asteroidBelt.update(dt); // Galactic disk
      kuiperBelt.update(dt); // Galactic halo
    }
  }

  // --- Collisions (sticky merge) --------------------------------------------

  void _handleCollisions() {
    int i = 0;
    while (i < bodies.length) {
      int j = i + 1;
      while (j < bodies.length) {
        final b1 = bodies[i];
        final b2 = bodies[j];

        // Special handling for galaxy formation scenario
        if (_currentScenario == ScenarioType.galaxyFormation) {
          // Allow stars to fall into the supermassive black hole
          if (_isBlackHoleAbsorption(b1, b2)) {
            _absorbIntoBlackHole(i, j);
            // do not advance j; current j now points to the next body after removal
            continue;
          } else {
            // Skip regular mergers to preserve galactic structure
            j++;
            continue;
          }
        }

        final r = b2.position - b1.position;
        final dist = r.length;
        // Make collision radius adjustable for different scenarios
        final collisionRadius = (b1.radius + b2.radius) * collisionRadiusMultiplier;
        if (dist < collisionRadius) {
          _merge(i, j);
          // do not advance j; current j now points to the next body after removal
        } else {
          j++;
        }
      }

      i++;
    }

    // Safety check: if only one body remains, add some companions
    if (bodies.length <= 1) {
      _regenerateSystem();
    }
  }

  void _regenerateSystem() {
    // If we end up with too few bodies, regenerate a simple system
    final central = bodies.isNotEmpty
        ? bodies.first
        : Body(
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            mass: SimulationConstants.centralBodyMass,
            radius: SimulationConstants.centralBodyRadius,
            color: AppColors.binaryStarBrown,
            name: 'Central Star',
            isPlanet: true,
          );

    bodies = [
      central,
      Body(
        position: vm.Vector3(SimulationConstants.companion1Distance, 0, 0),
        velocity: vm.Vector3(0, SimulationConstants.companion1OrbitalSpeed, 0),
        mass: SimulationConstants.companion1Mass,
        radius: SimulationConstants.companion1Radius,
        color: AppColors.binaryStarWhite,
        name: 'Companion A',
      ),
      Body(
        position: vm.Vector3(-SimulationConstants.companion2Distance, 0, 0),
        velocity: vm.Vector3(0, -SimulationConstants.companion2OrbitalSpeed, 0),
        mass: SimulationConstants.companion2Mass,
        radius: SimulationConstants.companion2Radius,
        color: AppColors.binaryStarBlue,
        name: 'Companion B',
      ),
    ];

    trails = List.generate(bodies.length, (_) => <TrailPoint>[]);
  }

  void _merge(int i, int j) {
    final b1 = bodies[i];
    final b2 = bodies[j];

    final m = b1.mass + b2.mass;
    final p = (b1.position * b1.mass + b2.position * b2.mass) / m; // mass-weighted position
    final v = (b1.velocity * b1.mass + b2.velocity * b2.mass) / m; // momentum conservation
    final r = math.pow(math.pow(b1.radius, 3) + math.pow(b2.radius, 3), 1 / 3).toDouble();
    final color = _blendColor(b1.color, b2.color, b2.mass / m);

    // Collision flash
    mergeFlashes.add(MergeFlash(p.clone(), color, age: 0));

    // Energy-scaled vibration
    final rel = (b1.velocity - b2.velocity).length;
    final mu = (b1.mass * b2.mass) / m;
    final energy = 0.5 * mu * rel * rel; // reduced-mass kinetic energy
    _vibrateForEnergy(energy);

    // Create merged body name
    final mergedName = '${b1.name}+${b2.name}';

    // Determine merged body type - stars take precedence over planets
    final mergedBodyType = (b1.bodyType == BodyType.star || b2.bodyType == BodyType.star) ? BodyType.star : b1.bodyType;

    // Determine merged stellar luminosity - use the higher value
    final mergedLuminosity = math.max(b1.stellarLuminosity, b2.stellarLuminosity);

    // Replace b1 and remove b2
    bodies[i] = Body(
      position: p,
      velocity: v,
      mass: m,
      radius: r,
      color: color,
      name: mergedName,
      isPlanet: b1.isPlanet || b2.isPlanet,
      bodyType: mergedBodyType,
      stellarLuminosity: mergedLuminosity,
    );

    // Handle trails synchronization safely
    if (j < trails.length) {
      trails.removeAt(j);
    }

    bodies.removeAt(j);

    // Ensure trails array matches bodies array length
    while (trails.length > bodies.length) {
      trails.removeLast();
    }

    while (trails.length < bodies.length) {
      trails.add(<TrailPoint>[]);
    }
  }

  void _vibrateForEnergy(double energy) {
    // Normalize via log to keep in reasonable range, clamp to [0.1, 1.0]
    final intensity = (math.log(1 + energy) / SimulationConstants.vibrationIntensityLogDivisor).clamp(
      SimulationConstants.vibrationIntensityMin,
      SimulationConstants.vibrationIntensityMax,
    );

    final duration =
        (SimulationConstants.vibrationDurationMin +
                (SimulationConstants.vibrationDurationMax - SimulationConstants.vibrationDurationMin) * intensity)
            .toInt();

    final amplitude =
        (SimulationConstants.vibrationAmplitudeMin +
                (SimulationConstants.vibrationAmplitudeMax - SimulationConstants.vibrationAmplitudeMin) * intensity)
            .clamp(0, 255)
            .toInt();

    // throttle to at most one vibration per throttle time
    if (!vibrationEnabled || _timeSinceLastVibe < vibrationThrottleTime) return;
    _timeSinceLastVibe = 0;

    Vibration.hasVibrator().then((has) {
      if (has == true) {
        Vibration.vibrate(duration: duration, amplitude: amplitude);
      }
    });
  }

  Color _blendColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t.clamp(0.0, 1.0)) ?? a;
  }

  /// Update star colors dynamically based on distance from black hole and velocity
  void _updateDynamicStarColors() {
    for (int i = 1; i < bodies.length; i++) {
      // Skip black hole at index 0
      final body = bodies[i];
      if (body.bodyType != BodyType.star) continue;

      // Calculate distance and velocity factors
      final distanceFromCenter = body.position.length;
      final velocity = body.velocity.length;

      // Create color progression: green -> yellow -> orange -> red
      Color newColor;

      if (distanceFromCenter > 120.0) {
        // Far from black hole: green (cool, stable)
        newColor = AppColors.uiGreen;
      } else if (distanceFromCenter > 80.0) {
        // Medium distance: green to yellow transition
        final t = (120.0 - distanceFromCenter) / 40.0; // 0 to 1
        newColor = Color.lerp(AppColors.uiGreen, AppColors.uiYellow, t) ?? AppColors.uiYellow;
      } else if (distanceFromCenter > 50.0) {
        // Getting closer: yellow to orange transition
        final t = (80.0 - distanceFromCenter) / 30.0; // 0 to 1
        newColor = Color.lerp(AppColors.uiYellow, AppColors.uiOrange, t) ?? AppColors.uiOrange;
      } else {
        // Close to black hole: orange to red transition (hot, stressed)
        final t = math.min(1.0, (50.0 - distanceFromCenter) / 50.0); // 0 to 1
        newColor = Color.lerp(AppColors.uiOrange, AppColors.uiRed, t) ?? AppColors.uiRed;
      }

      // Add velocity-based intensity (faster = more intense/brighter)
      final velocityFactor = math.min(1.0, velocity / 8.0);
      final intensity = 0.7 + (velocityFactor * 0.3); // 0.7 to 1.0 brightness

      // Apply intensity to the color
      final hsv = HSVColor.fromColor(newColor);
      newColor = hsv.withValue(intensity).toColor();

      // Update the body's color
      bodies[i] = Body(
        position: body.position,
        velocity: body.velocity,
        mass: body.mass,
        radius: body.radius,
        color: newColor,
        name: body.name,
        isPlanet: body.isPlanet,
        bodyType: body.bodyType,
        stellarLuminosity: body.stellarLuminosity,
      );
    }
  }

  /// Check if this is a black hole absorption event
  bool _isBlackHoleAbsorption(Body b1, Body b2) {
    // Find which body is the supermassive black hole (most massive star)
    final blackHole = (b1.mass > 100.0 && b1.bodyType == BodyType.star)
        ? b1
        : (b2.mass > 100.0 && b2.bodyType == BodyType.star)
        ? b2
        : null;

    if (blackHole == null) return false;

    // Calculate distance between bodies
    final r = (b2.position - b1.position);
    final dist = r.length;

    // True event horizon - much smaller than visual representation (accretion disk)
    final eventHorizonRadius = blackHole.radius * 0.3; // True event horizon size
    final willAbsorb = dist < eventHorizonRadius;
    return willAbsorb;
  }

  /// Absorb a star into the black hole with dramatic effects
  void _absorbIntoBlackHole(int i, int j) {
    final b1 = bodies[i];
    final b2 = bodies[j];

    // Determine which is the black hole and which is being absorbed
    final isB1BlackHole = b1.mass > 100.0 && b1.bodyType == BodyType.star;
    final blackHole = isB1BlackHole ? b1 : b2;
    final victim = isB1BlackHole ? b2 : b1;
    final blackHoleIndex = isB1BlackHole ? i : j;
    final victimIndex = isB1BlackHole ? j : i;

    // Create dramatic absorption flash - much brighter than regular merges
    final flashColor = Color.lerp(victim.color, AppColors.uiWhite, 0.7) ?? AppColors.uiWhite;
    mergeFlashes.add(MergeFlash(victim.position.clone(), flashColor, age: 0));

    // Strong haptic feedback for black hole absorption
    _vibrateForBlackHoleAbsorption();

    // Black hole grows slightly (conservation of mass)
    final newMass = blackHole.mass + victim.mass;
    final newRadius = blackHole.radius * math.pow(newMass / blackHole.mass, 1 / 3);

    // Update black hole with new mass
    bodies[blackHoleIndex] = Body(
      position: blackHole.position,
      velocity: blackHole.velocity, // Black hole velocity barely changes
      mass: newMass,
      radius: newRadius,
      color: blackHole.color,
      name: blackHole.name,
      isPlanet: false,
      bodyType: BodyType.star,
      stellarLuminosity: blackHole.stellarLuminosity,
    );

    // Remove the absorbed body
    bodies.removeAt(victimIndex);
    trails.removeAt(victimIndex);

    // Adjust indices if needed
    if (victimIndex < blackHoleIndex) {
      // The black hole index shifted down by 1
      // No adjustment needed as we're returning anyway
    }
  }

  /// Strong vibration for black hole absorption events
  void _vibrateForBlackHoleAbsorption() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      // Strong, dramatic vibration pattern for black hole absorption
      Vibration.vibrate(
        pattern: [0, 200, 100, 300], // Strong double pulse
        intensities: [0, 255, 0, 255], // Maximum intensity
      );
    }
  }

  /// Update habitability status for all bodies (throttled for performance)
  void updateHabitability(double deltaTime) {
    _timeSinceLastHabitabilityUpdate += deltaTime;

    if (_timeSinceLastHabitabilityUpdate >= _habitabilityUpdateInterval) {
      _habitableZoneService.updateHabitabilityForAllBodies(bodies);
      _timeSinceLastHabitabilityUpdate = 0.0;
    }
  }

  /// Get all habitable zones for visualization
  List<Map<String, dynamic>> getHabitableZones() {
    return _habitableZoneService.getAllHabitableZones(bodies);
  }
}
