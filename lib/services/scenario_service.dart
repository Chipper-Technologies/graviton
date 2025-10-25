import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/temperature_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for generating preset astronomical scenarios
class ScenarioService {
  final math.Random _random = math.Random();

  /// Generate bodies for a specific scenario type
  List<Body> generateScenario(ScenarioType type, {AppLocalizations? l10n}) {
    switch (type) {
      case ScenarioType.random:
        return _generateRandomBodies(l10n);
      case ScenarioType.earthMoonSun:
        return _generateEarthMoonSun(l10n);
      case ScenarioType.binaryStars:
        return _generateBinaryStars(l10n);
      case ScenarioType.asteroidBelt:
        return _generateAsteroidBelt(l10n);
      case ScenarioType.galaxyFormation:
        return _generateGalaxyFormation(l10n);
      case ScenarioType.solarSystem:
        return _generateSolarSystem(l10n);
      case ScenarioType.threeBodyClassic:
        return _generateRandomBodies(l10n); // Use random for now
      case ScenarioType.collisionDemo:
        return _generateRandomBodies(l10n); // Use random for now
      case ScenarioType.deepSpace:
        return _generateRandomBodies(l10n); // Use random for now
    }
  }

  /// Generate random three-body system (original behavior)
  List<Body> _generateRandomBodies(AppLocalizations? l10n) {
    // Enhanced 3D Body Generation System:
    // - Stars now span ±20 units in Z-axis (was ±10) for true 3D distribution
    // - Planets span ±15 units in Z-axis (was ±6) with enhanced Z-velocity
    // - Planet mass ranges from Earth-size (0.8-2.0) to Super-Earth (4.0-7.0)
    // - This makes planets much more resilient and creates more interesting dynamics

    // Define color palette for the bodies
    const colors = [
      AppColors.celestialAmber, // amber
      AppColors.celestialTeal, // teal
      AppColors.celestialBlue, // blue
      AppColors.celestialRed, // red
      AppColors.celestialPink, // pink
      AppColors.celestialLightBlue, // light blue
    ];

    final bodies = <Body>[];

    // Generate three main stars in a fully 3D triangular configuration
    for (int i = 0; i < SimulationConstants.numberOfStars; i++) {
      final angle =
          (i * 2 * math.pi / SimulationConstants.numberOfStars) +
          (_random.nextDouble() - 0.5) *
              SimulationConstants
                  .starAngleRandomness; // triangle with some randomness

      final distance =
          SimulationConstants.starDistanceMin +
          _random.nextDouble() *
              (SimulationConstants.starDistanceMax -
                  SimulationConstants.starDistanceMin);

      final height =
          (_random.nextDouble() - 0.5) *
          SimulationConstants
              .starHeightRange; // expanded z height for maximum 3D spread

      final position = vm.Vector3(
        distance * math.cos(angle),
        distance * math.sin(angle),
        height,
      );

      // Calculate velocity for roughly circular motion with guaranteed 3D characteristics
      final orbitalSpeed =
          SimulationConstants.starOrbitalSpeedMin +
          _random.nextDouble() *
              (SimulationConstants.starOrbitalSpeedMax -
                  SimulationConstants.starOrbitalSpeedMin);

      final tangentAngle = angle + math.pi / 2; // perpendicular to radius

      // Generate Z-velocity with minimum threshold to ensure dramatic 3D motion
      final zVelocityMagnitude =
          SimulationConstants.starZVelocityMin +
          _random.nextDouble() *
              (SimulationConstants.starZVelocityMax -
                  SimulationConstants.starZVelocityMin);

      final zVelocityDirection = _random.nextBool() ? 1 : -1;
      final zVelocity = zVelocityMagnitude * zVelocityDirection;
      final velocity = vm.Vector3(
        orbitalSpeed * math.cos(tangentAngle) +
            (_random.nextDouble() - 0.5) *
                SimulationConstants.starVelocityRandomness,
        orbitalSpeed * math.sin(tangentAngle) +
            (_random.nextDouble() - 0.5) *
                SimulationConstants.starVelocityRandomness,
        zVelocity, // guaranteed significant z velocity for true 3D motion
      );

      // Assign star names
      final starNames = l10n != null
          ? [l10n.bodyAlpha, l10n.bodyBeta, l10n.bodyGamma]
          : ['Alpha', 'Beta', 'Gamma'];

      // Generate star mass and radius first
      final starMass =
          SimulationConstants.starMassMin +
          _random.nextDouble() *
              (SimulationConstants.starMassMax -
                  SimulationConstants.starMassMin);

      final starRadius =
          SimulationConstants.starRadiusMin +
          _random.nextDouble() *
              (SimulationConstants.starRadiusMax -
                  SimulationConstants.starRadiusMin);

      // Calculate realistic stellar luminosity based on mass-luminosity relationship
      // For main sequence stars: L ∝ M^3.5 (roughly)
      // Normalize relative to a solar-mass star (average of our mass range)
      final avgMass =
          (SimulationConstants.starMassMin + SimulationConstants.starMassMax) /
          2;
      final massRatio = starMass / avgMass;
      final stellarLuminosity =
          SimulationConstants.solarLuminosity * math.pow(massRatio, 3.5);

      bodies.add(
        Body(
          position: position,
          velocity: velocity,
          mass: starMass,
          radius: starRadius,
          color: colors[i],
          name: starNames[i],
          isPlanet: false,
          bodyType: BodyType.star,
          stellarLuminosity: stellarLuminosity,
          temperature: TemperatureService.getInitialTemperature(
            BodyType.star,
            starMass,
          ),
        ),
      );
    }

    // Add a planet with variable mass (Earth to Super-Earth range)
    final planetAngle = _random.nextDouble() * 2 * math.pi;
    final planetDistance =
        SimulationConstants.planetDistanceMin +
        _random.nextDouble() *
            (SimulationConstants.planetDistanceMax -
                SimulationConstants.planetDistanceMin);

    final planetHeight =
        (_random.nextDouble() - 0.5) *
        SimulationConstants
            .planetHeightRange; // expanded z range for enhanced 3D motion

    final planetPosition = vm.Vector3(
      planetDistance * math.cos(planetAngle),
      planetDistance * math.sin(planetAngle),
      planetHeight,
    );

    // Calculate planet orbital velocity around system center with guaranteed 3D motion
    final planetOrbitalSpeed =
        SimulationConstants.planetOrbitalSpeedMin +
        _random.nextDouble() *
            (SimulationConstants.planetOrbitalSpeedMax -
                SimulationConstants.planetOrbitalSpeedMin);

    final planetTangentAngle = planetAngle + math.pi / 2;

    // Generate Z-velocity with minimum threshold for enhanced 3D dynamics
    final planetZVelocityMagnitude =
        SimulationConstants.planetZVelocityMin +
        _random.nextDouble() *
            (SimulationConstants.planetZVelocityMax -
                SimulationConstants.planetZVelocityMin);

    final planetZVelocityDirection = _random.nextBool() ? 1 : -1;
    final planetZVelocity = planetZVelocityMagnitude * planetZVelocityDirection;
    final planetVelocity = vm.Vector3(
      planetOrbitalSpeed * math.cos(planetTangentAngle) +
          (_random.nextDouble() - 0.5) *
              SimulationConstants.planetVelocityRandomness,
      planetOrbitalSpeed * math.sin(planetTangentAngle) +
          (_random.nextDouble() - 0.5) *
              SimulationConstants.planetVelocityRandomness,
      planetZVelocity, // guaranteed significant z velocity for dramatic 3D planet motion
    );

    // Planet mass variation: Earth-size (1.0) to Super-Earth (6.0)
    // This makes planets much more resilient and interesting
    final planetMassType = _random.nextDouble();
    final double planetMass;
    final double planetRadius;

    if (planetMassType < SimulationConstants.smallPlanetProbability) {
      // Small rocky planet (Mercury to Mars size): 30% chance
      planetMass =
          SimulationConstants.smallPlanetMassMin +
          _random.nextDouble() *
              (SimulationConstants.smallPlanetMassMax -
                  SimulationConstants.smallPlanetMassMin);
      planetRadius =
          SimulationConstants.smallPlanetRadiusMin +
          _random.nextDouble() *
              (SimulationConstants.smallPlanetRadiusMax -
                  SimulationConstants.smallPlanetRadiusMin);
    } else if (planetMassType <
        SimulationConstants.earthLikePlanetProbability) {
      // Earth-like planet: 40% chance
      planetMass =
          SimulationConstants.earthLikePlanetMassMin +
          _random.nextDouble() *
              (SimulationConstants.earthLikePlanetMassMax -
                  SimulationConstants.earthLikePlanetMassMin);
      planetRadius =
          SimulationConstants.earthLikePlanetRadiusMin +
          _random.nextDouble() *
              (SimulationConstants.earthLikePlanetRadiusMax -
                  SimulationConstants.earthLikePlanetRadiusMin);
    } else {
      // Super-Earth: 30% chance
      planetMass =
          SimulationConstants.superEarthMassMin +
          _random.nextDouble() *
              (SimulationConstants.superEarthMassMax -
                  SimulationConstants.superEarthMassMin);
      planetRadius =
          SimulationConstants.superEarthRadiusMin +
          _random.nextDouble() *
              (SimulationConstants.superEarthRadiusMax -
                  SimulationConstants.superEarthRadiusMin);
    }

    // Determine planet type based on mass for naming
    String planetName;

    if (planetMass < 2.0) {
      planetName = l10n?.bodyRockyPlanet ?? 'Rocky Planet';
    } else if (planetMass < 4.0) {
      planetName = l10n?.bodyEarthLike ?? 'Earth-like';
    } else {
      planetName = l10n?.bodySuperEarth ?? 'Super-Earth';
    }

    bodies.add(
      Body(
        position: planetPosition,
        velocity: planetVelocity,
        mass: planetMass,
        radius: planetRadius,
        color:
            colors[3 +
                _random.nextInt(
                  colors.length - 3,
                )], // random color from remaining palette
        name: planetName,
        isPlanet: true,
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0, // Planets don't emit significant light
        temperature: TemperatureService.getInitialTemperature(
          BodyType.planet,
          planetMass,
          distance: planetDistance,
        ),
      ),
    );

    return bodies;
  }

  /// Generate Earth-Moon-Sun system with realistic lunar orbital characteristics
  /// - Moon distance: accurate 390:1 ratio vs Earth-Sun distance
  /// - Moon size: accurate 0.27x Earth diameter
  /// - Moon inclination: realistic 5.14° to ecliptic plane
  /// - Moon mass: scaled 5x for simulation stability (real mass too small for stable orbit)
  List<Body> _generateEarthMoonSun(AppLocalizations? l10n) {
    final bodies = <Body>[];

    // Use same approach as solar system - stationary Sun, simple stable orbits
    bodies.add(
      Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(), // Keep Sun stationary like in solar system
        mass:
            45.0, // Further reduced from 60.0 to minimize Sun's disruptive influence
        radius: 4.8, // Same realistic Sun size as solar system scenario
        color: AppColors.celestialGold, // Gold
        name: l10n?.bodySun ?? 'Sun',
        bodyType: BodyType.star,
        stellarLuminosity: SimulationConstants.solarLuminosity,
      ),
    );

    // Earth orbiting the Sun - simple circular orbit in horizontal plane
    final earthDistance =
        50.0; // Same as solar system Earth distance for consistency
    final earthSpeed =
        math.sqrt(1.2 * 45.0 / earthDistance) * 1.0; // Updated for new Sun mass

    // Earth orbital inclination: 0° by definition (ecliptic reference plane)
    final earthInclinationRadians = 0.0; // Earth defines the ecliptic plane

    // Start Earth at a random angle in horizontal XZ plane
    final earthAngle = _random.nextDouble() * 2.0 * math.pi;
    final earthX = earthDistance * math.cos(earthAngle);
    final earthZ = earthDistance * math.sin(earthAngle);

    // Apply Earth's inclination (which is 0, so no change, but keeping consistent with solar system)
    final earthZInclined = earthZ * math.cos(earthInclinationRadians);
    final earthY = earthZ * math.sin(earthInclinationRadians);

    // Earth velocity in horizontal plane with inclination
    // For counterclockwise motion when viewed from above (positive Y)
    final earthBaseVx =
        earthSpeed * math.sin(earthAngle); // Flipped sign for counterclockwise
    final earthBaseVz =
        -earthSpeed * math.cos(earthAngle); // Flipped sign for counterclockwise
    final earthVx = earthBaseVx;
    final earthVz = earthBaseVz * math.cos(earthInclinationRadians);
    final earthVy = earthBaseVz * math.sin(earthInclinationRadians);

    bodies.add(
      Body(
        position: vm.Vector3(earthX, earthY, earthZInclined),
        velocity: vm.Vector3(earthVx, earthVy, earthVz),
        mass:
            0.30, // Maximally increased from 0.20 to completely dominate Moon's orbit
        radius: 0.6,
        color: AppColors.planetEarth, // Same blue as solar system Earth
        name: l10n?.bodyEarth ?? 'Earth',
        isPlanet: true,
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
      ),
    );

    // Moon orbiting Earth - more stable configuration
    // Slightly larger distance and adjusted velocity for stability in three-body system
    final moonDistance =
        0.35; // Further increased from 0.30 for maximum Hill sphere
    final moonSpeed =
        math.sqrt(1.2 * 0.30 / moonDistance) *
        0.94; // Updated for new Earth mass and distance

    // Moon orbital inclination: reduced for visual stability in three-body system
    final moonInclinationRadians =
        1.0 * math.pi / 180.0; // Reduced from 5.14° to 1.0° for stability

    // Random moon phase (longitude)
    final moonAngle = _random.nextDouble() * 2.0 * math.pi;

    // Calculate Moon position with inclination relative to Earth's orbital plane
    // Moon orbits Earth in a plane inclined to the ecliptic (now horizontal XZ plane)
    final moonX = earthX + moonDistance * math.cos(moonAngle);
    final moonZ =
        earthZInclined +
        moonDistance * math.sin(moonAngle) * math.cos(moonInclinationRadians);
    final moonY =
        earthY +
        moonDistance * math.sin(moonAngle) * math.sin(moonInclinationRadians);

    // Moon velocity = Earth's velocity + Moon's orbital velocity around Earth (with inclination)
    // For counterclockwise motion when viewed from above (positive Y)
    final moonOrbitalVelX =
        moonSpeed * math.sin(moonAngle); // Flipped sign for counterclockwise
    final moonOrbitalVelZ =
        -moonSpeed *
        math.cos(moonAngle) *
        math.cos(moonInclinationRadians); // Flipped sign
    final moonOrbitalVelY =
        -moonSpeed *
        math.cos(moonAngle) *
        math.sin(moonInclinationRadians); // Flipped sign

    bodies.add(
      Body(
        position: vm.Vector3(moonX, moonY, moonZ),
        velocity: vm.Vector3(
          earthVx + moonOrbitalVelX,
          earthVy + moonOrbitalVelY,
          earthVz + moonOrbitalVelZ,
        ),
        mass:
            0.015, // Significantly increased Moon mass from 0.008 for maximum Earth-Moon coupling
        radius: 0.162, // Accurate Moon radius: 0.27x Earth (0.60) = 0.162
        color: AppColors.celestialSilver, // Silver
        name: l10n?.bodyMoon ?? 'Moon',
        bodyType: BodyType.moon,
        stellarLuminosity: 0.0,
      ),
    );

    return bodies;
  }

  /// Generate binary star system with planets
  List<Body> _generateBinaryStars(AppLocalizations? l10n) {
    final bodies = <Body>[];

    // APPLY EARTH-MOON-SUN SUCCESS FORMULA: Much simpler, conservative approach
    // Key insight: Earth-Moon-Sun works because Sun is stationary and masses are conservative

    // Start with two stars in much simpler, more stable configuration
    final starSeparation = 30.0; // Conservative separation
    final starMass =
        8.0; // Much smaller mass (Earth-Moon-Sun Sun is 45.0 but dominates completely)

    // Use the EXACT gravitational approach that works in Earth-Moon-Sun
    final gravitationalConstant = 1.2;

    // Make binary stars orbit MUCH slower (like Earth-Moon-Sun's conservative speeds)
    final binaryOrbitalSpeed =
        math.sqrt(gravitationalConstant * starMass / starSeparation) *
        0.50; // Very conservative

    // Randomize star orbital directions (clockwise or counterclockwise)
    final starDirectionMultiplier = _random.nextBool() ? 1.0 : -1.0;

    // Calculate stellar luminosity
    final avgMass =
        (SimulationConstants.starMassMin + SimulationConstants.starMassMax) / 2;
    final massRatio = starMass / avgMass;
    final stellarLuminosity =
        SimulationConstants.solarLuminosity * math.pow(massRatio, 3.5);

    // Star A - simple circular orbit with randomized direction
    bodies.add(
      Body(
        position: vm.Vector3(-starSeparation / 2, 0, 0),
        velocity: vm.Vector3(
          0,
          -binaryOrbitalSpeed * starDirectionMultiplier,
          0,
        ),
        mass: starMass,
        radius: 1.5,
        color: AppColors.celestialRedPlanet, // Red
        name: l10n?.bodyStarA ?? 'Star A',
        bodyType: BodyType.star,
        stellarLuminosity: stellarLuminosity,
      ),
    );

    // Star B - simple circular orbit with randomized direction
    bodies.add(
      Body(
        position: vm.Vector3(starSeparation / 2, 0, 0),
        velocity: vm.Vector3(
          0,
          binaryOrbitalSpeed * starDirectionMultiplier,
          0,
        ),
        mass: starMass,
        radius: 1.5,
        color: AppColors.celestialTealPlanet, // Teal
        name: l10n?.bodyStarB ?? 'Star B',
        bodyType: BodyType.star,
        stellarLuminosity: stellarLuminosity,
      ),
    );

    // Planet: Use EXACT Earth-Moon-Sun approach - conservative mass, conservative distance
    final planetDistance =
        60.0; // Far enough to be stable (like Earth at 50.0 from Sun)
    final totalStarMass = starMass * 2;
    final planetSpeed =
        math.sqrt(gravitationalConstant * totalStarMass / planetDistance) *
        1.0; // Same factor as Earth-Moon-Sun Earth

    // Randomize planet orbital direction (but remove inclination for simplicity)
    final planetDirectionMultiplier = _random.nextBool() ? 1.0 : -1.0;

    // Planet position in XY plane (no inclination)
    final planetY = planetDistance;
    final planetZ = 0.0;

    // Planet velocity perpendicular to position (in XY plane)
    final planetVx = planetSpeed * planetDirectionMultiplier;
    final planetVy = 0.0;
    final planetVz = 0.0;

    bodies.add(
      Body(
        position: vm.Vector3(0, planetY, planetZ),
        velocity: vm.Vector3(planetVx, planetVy, planetVz),
        mass: 0.25, // MUCH smaller mass (Earth-Moon-Sun Earth is 0.30)
        radius: 0.5,
        color: AppColors.celestialBluePlanet, // Blue
        name: l10n?.bodyPlanetP ?? 'Planet P',
        bodyType: BodyType.planet,
      ),
    );

    // Moon: Use EXACT Earth-Moon-Sun approach (no inclination)
    final moonDistance = 0.30; // Same as Earth-Moon-Sun Moon distance
    final moonSpeed =
        math.sqrt(gravitationalConstant * 0.25 / moonDistance) *
        0.94; // Same factor as Earth-Moon-Sun Moon

    // Moon position relative to planet (in XY plane)
    final moonX = moonDistance;
    final moonRelativeY = 0.0;
    final moonRelativeZ = 0.0;

    // Moon velocity relative to planet (perpendicular to moon position)
    final moonRelativeVx = 0.0;
    final moonRelativeVy = moonSpeed * planetDirectionMultiplier;
    final moonRelativeVz = 0.0;

    bodies.add(
      Body(
        position: vm.Vector3(
          moonX,
          planetY + moonRelativeY,
          planetZ + moonRelativeZ,
        ),
        velocity: vm.Vector3(
          planetVx + moonRelativeVx,
          planetVy + moonRelativeVy,
          planetVz + moonRelativeVz,
        ),
        mass: 0.015, // MUCH smaller mass (Earth-Moon-Sun Moon is 0.015)
        radius: 0.15,
        color: AppColors.celestialPlumPlanet, // Plum
        name: l10n?.bodyMoonM ?? 'Moon M',
        bodyType: BodyType.moon,
      ),
    );

    return bodies;
  }

  /// Generate asteroid belt around central star (now uses particle system)
  List<Body> _generateAsteroidBelt(AppLocalizations? l10n) {
    final bodies = <Body>[];

    // Central star (fixed in position - no drift)
    bodies.add(
      Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 20.0, // Increased mass for more stable belt
        radius: 2.0, // Larger for better visibility
        color: AppColors.celestialGold, // Gold
        name: l10n?.bodyCentralStar ?? 'Central Star',
        bodyType: BodyType.star,
        stellarLuminosity: 15.0, // Bright star
      ),
    );

    // Add a stable outer companion planet (well outside the belt, no intersection)
    final outerCompanionDistance =
        24.0; // Slightly further from belt (belt goes to 22) for safety
    final outerCompanionSpeed =
        math.sqrt(1.2 * 20.0 / outerCompanionDistance) *
        1.05; // Slightly increased velocity for stable orbit

    final outerAngle =
        0.0; // 0 degrees - start at positive X-axis for centered appearance

    bodies.add(
      Body(
        position: vm.Vector3(
          outerCompanionDistance * math.cos(outerAngle),
          outerCompanionDistance * math.sin(outerAngle),
          0,
        ), // No offset - orbit around exact center
        velocity: vm.Vector3(
          -outerCompanionSpeed * math.sin(outerAngle),
          outerCompanionSpeed * math.cos(outerAngle),
          0,
        ), // Perfect tangential velocity for stable circular orbit
        mass: 0.1, // Much smaller mass to minimize gravitational disruption
        radius: 1.2, // Larger radius for better visibility at greater distance
        color: AppColors.celestialBluePlanet2, // Blue planet
        name: l10n?.bodyOuterPlanet ?? 'Outer Planet',
        bodyType: BodyType.planet,
      ),
    );

    // Add a stable inner companion planet (well inside the belt)
    final innerCompanionDistance =
        5.0; // Well inside the belt (belt starts at 8)
    final innerCompanionSpeed =
        math.sqrt(1.2 * 20.0 / innerCompanionDistance) *
        0.9; // Faster inner orbit
    final innerAngle =
        math.pi; // Put inner planet at 180 degrees for better balance

    bodies.add(
      Body(
        position: vm.Vector3(
          innerCompanionDistance * math.cos(innerAngle),
          innerCompanionDistance * math.sin(innerAngle),
          0,
        ), // Position at 180 degrees
        velocity: vm.Vector3(
          -innerCompanionSpeed * math.sin(innerAngle),
          innerCompanionSpeed * math.cos(innerAngle),
          0,
        ), // Tangential velocity for circular orbit
        mass: 0.3, // Even smaller mass
        radius: 0.6,
        color: AppColors.celestialRedPlanet2, // Red planet
        name: l10n?.bodyInnerPlanet ?? 'Inner Planet',
        bodyType: BodyType.planet,
      ),
    );

    // Note: Asteroid particles are managed by AsteroidBeltSystem in simulation
    // This scenario only creates the central star, particles are handled separately

    return bodies;
  }

  /// Generate galaxy formation simulation
  List<Body> _generateGalaxyFormation(AppLocalizations? l10n) {
    final bodies = <Body>[];

    // Central supermassive black hole - much more massive and menacing
    bodies.add(
      Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass:
            300.0, // Increased from 200 to 300 for stronger gravitational binding
        radius: 2.5, // Larger, more menacing presence
        color: AppColors.celestialBlackHole, // Black (event horizon)
        name: l10n?.bodyBlackHole ?? 'Supermassive Black Hole',
        bodyType: BodyType.star, // Behaves like a star gravitationally
        stellarLuminosity:
            0.0, // Black holes don't emit light (except accretion disk)
      ),
    );

    // Generate stars in galactic disk formation (3 spiral arms + 2 inner close stars)
    // Most stars should remain in stable orbits - stellar ejections are rare in real galaxies
    const starsPerArm = 10; // Increased to include 2 inner stars per arm
    const numArms = 3;

    for (int arm = 0; arm < numArms; arm++) {
      final armAngleOffset =
          (arm * 2.0 * math.pi) / numArms; // 120° between arms

      for (int i = 0; i < starsPerArm; i++) {
        double radius;
        double spiralTightness;
        double safeRadius;
        double angleVariation;

        // First two stars in first arm are the special inner stars
        if (arm == 0 && i < 2) {
          // Inner stars at safer distances to prevent immediate ejection
          radius = i == 0
              ? 20.0
              : 25.0; // Increased from 12.0/15.0 for stability
          safeRadius = radius;
          angleVariation = i == 0 ? 0.0 : math.pi; // Opposite sides
        } else {
          // Regular galactic disk stars
          final armPosition = i / (starsPerArm - 1); // 0 to 1 along arm
          radius =
              50.0 +
              armPosition *
                  100.0; // Increased minimum: 50 to 150 units (was 40-120)
          spiralTightness = 0.3; // How tightly wound the spiral is
          // Reverse spiral winding for counterclockwise rotation with trailing arms
          final angle =
              armAngleOffset - armPosition * 4.0 * math.pi * spiralTightness;

          // Add some randomness to create natural scatter (reduced for stability)
          final radiusVariation =
              radius +
              (_random.nextDouble() - 0.5) * 2.0; // Further reduced from 3.0

          // Ensure minimum safe distance from black hole (increased minimum)
          safeRadius = math.max(radiusVariation, 45.0); // Increased from 30.0
          angleVariation = angle + (_random.nextDouble() - 0.5) * 0.2;
        }

        // Very thin galactic disk - most stars stay in plane
        final heightVariation =
            (_random.nextDouble() - 0.5) * 1.0; // Reduced from 1.5

        final x = safeRadius * math.cos(angleVariation);
        final y = safeRadius * math.sin(angleVariation);
        final z = heightVariation;

        // Orbital velocity calculation - use proper Keplerian orbital mechanics
        // For circular orbit: v = sqrt(G * M / r) where G=1.2, M=300 (increased black hole mass)
        final orbitalSpeed = math.sqrt(1.2 * 300.0 / safeRadius);

        double galaxySpeedFactor;
        if (arm == 0 && i < 2) {
          // Inner stars get slightly reduced speed for eventual decay, but still stable initially
          galaxySpeedFactor = i == 0
              ? 0.98
              : 0.96; // Even closer to orbital speed for stability
        } else {
          // Regular stars get higher than orbital velocity for strong stability margin
          galaxySpeedFactor =
              1.15; // Increased from 1.05 to 1.15 for better stability
        }

        final adjustedSpeed = orbitalSpeed * galaxySpeedFactor;

        // Remove speed variation to maintain perfect circular orbits initially
        final finalSpeed = adjustedSpeed; // No random variation for stability

        // Perpendicular velocity for perfectly circular orbits
        // For counterclockwise galaxy rotation with trailing spiral arms
        final vx = -finalSpeed * math.sin(angleVariation);
        final vy = finalSpeed * math.cos(angleVariation);
        final vz =
            (_random.nextDouble() - 0.5) * 0.01; // Even more minimal z-velocity

        // Star properties based on galactic position
        final massVariation =
            0.8 + _random.nextDouble() * 1.4; // 0.8 to 2.2 solar masses
        final radiusBody = 0.4 + massVariation * 0.15;

        // Calculate stellar luminosity
        final avgMass =
            (SimulationConstants.starMassMin +
                SimulationConstants.starMassMax) /
            2;
        final massRatio = massVariation / avgMass;
        final stellarLuminosity =
            SimulationConstants.solarLuminosity * math.pow(massRatio, 3.5);

        // Color based on stellar type and position
        Color color;
        if (arm == 0 && i < 2) {
          // Inner stars get special colors
          color = i == 0 ? AppColors.uiRed : AppColors.uiOrange;
        } else {
          // Regular stars: color based on distance (outer stars are older/redder)
          final distanceFromCenter = safeRadius / 80.0; // 0 to 1
          final baseHue =
              0.05 + distanceFromCenter * 0.15; // Blue center to red outer
          final hueVariation = baseHue + (_random.nextDouble() - 0.5) * 0.1;
          color = HSVColor.fromAHSV(
            1.0,
            hueVariation * 360,
            0.8,
            0.95,
          ).toColor();
        }

        bodies.add(
          Body(
            position: vm.Vector3(x, y, z),
            velocity: vm.Vector3(vx, vy, vz),
            mass: massVariation,
            radius: radiusBody,
            color: color,
            name:
                l10n?.bodyStar((arm * starsPerArm) + i + 1) ??
                'Star ${(arm * starsPerArm) + i + 1}',
            bodyType: BodyType.star,
            stellarLuminosity: stellarLuminosity,
          ),
        );
      }
    }

    return bodies;
  }

  /// Generate realistic solar system
  List<Body> _generateSolarSystem(AppLocalizations? l10n) {
    final bodies = <Body>[];

    // Sun - central star with realistic mass dominance and size
    // Real Sun is ~109x Earth diameter, using 8x for visibility while keeping realistic proportions
    bodies.add(
      Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 50.0, // Much more massive to dominate the system
        radius: 4.8, // 8x Earth (0.6) = visibly larger star
        color: AppColors.celestialGold, // Gold
        name: l10n?.bodySun ?? 'Sun',
        bodyType: BodyType.star,
        stellarLuminosity: SimulationConstants.solarLuminosity,
      ),
    );

    // Planetary data: [distance, mass, radius, color, name, inclination_degrees]
    // Distances based on real solar system proportions (scaled by 50x from AU)
    // Masses made smaller relative to Sun for stable orbits (Sun = 50.0)
    // Radii based on real solar system proportions scaled for visibility
    // Real diameter ratios: Mercury 0.38, Venus 0.95, Earth 1.0, Mars 0.53, Jupiter 11.2, Saturn 9.4, Uranus 4.0, Neptune 3.9
    // Planet data: [distance, mass, radius, color, inclinationDegrees]
    final planetData = [
      [
        19.5,
        0.01,
        0.23,
        AppColors.planetMercury,
        7.0,
      ], // Mercury - 0.38x Earth size
      [
        36.0,
        0.02,
        0.57,
        AppColors.planetVenus,
        3.4,
      ], // Venus - 0.95x Earth size
      [50.0, 0.02, 0.60, AppColors.planetEarth, 0.0], // Earth - Reference size
      [76.0, 0.01, 0.32, AppColors.planetMars, 1.9], // Mars - 0.53x Earth size
      [
        260.0,
        0.15,
        6.72,
        AppColors.planetJupiter,
        1.3,
      ], // Jupiter - 11.2x Earth size (gas giant)
      [
        479.0,
        0.10,
        5.64,
        AppColors.planetSaturn,
        2.5,
      ], // Saturn - 9.4x Earth size (gas giant)
      [
        960.0,
        0.05,
        2.40,
        AppColors.planetUranus,
        0.8,
      ], // Uranus - 4.0x Earth size (ice giant)
      [
        1505.0,
        0.06,
        2.34,
        AppColors.planetNeptune,
        1.8,
      ], // Neptune - 3.9x Earth size (ice giant)
    ];

    // Planet names
    final planetNames = [
      l10n?.bodyMercury ?? 'Mercury',
      l10n?.bodyVenus ?? 'Venus',
      l10n?.bodyEarth ?? 'Earth',
      l10n?.bodyMars ?? 'Mars',
      l10n?.bodyJupiter ?? 'Jupiter',
      l10n?.bodySaturn ?? 'Saturn',
      l10n?.bodyUranus ?? 'Uranus',
      l10n?.bodyNeptune ?? 'Neptune',
    ];

    // Generate planets with stable circular orbits and realistic inclinations
    for (int i = 0; i < planetData.length; i++) {
      final data = planetData[i];
      final distance = data[0] as double;
      final mass = data[1] as double;
      final radius = data[2] as double;
      final color = data[3] as Color;
      final inclinationDegrees = data[4] as double;
      final name = planetNames[i];

      // Random starting angle for variety
      final angle = _random.nextDouble() * 2.0 * math.pi;

      // Calculate correct orbital velocity for stable circular orbit
      // v = sqrt(G * M / r) where G = 1.2, M = sun mass (50.0), r = distance
      final sunMass = 50.0;
      final gravitationalConstant = 1.2;
      final orbitalSpeed = math.sqrt(
        gravitationalConstant * sunMass / distance,
      );

      // Convert inclination to radians
      final inclinationRadians = inclinationDegrees * math.pi / 180.0;

      // Position planet with proper orbital inclination
      // Place base orbit in XZ plane (horizontal) instead of XY plane
      final x = distance * math.cos(angle);
      final z = distance * math.sin(angle);

      // Apply inclination by rotating around the x-axis
      final zInclined = z * math.cos(inclinationRadians);
      final y = z * math.sin(inclinationRadians);

      // Velocity perpendicular to position vector for stable circular orbit
      // Place base velocity in XZ plane, then apply inclination
      // For counterclockwise motion when viewed from above (positive Y)
      final baseVx =
          orbitalSpeed * math.sin(angle); // Flipped sign for counterclockwise
      final baseVz =
          -orbitalSpeed * math.cos(angle); // Flipped sign for counterclockwise

      final vx = baseVx;
      final vz = baseVz * math.cos(inclinationRadians);
      final vy = baseVz * math.sin(inclinationRadians);

      bodies.add(
        Body(
          position: vm.Vector3(x, y, zInclined),
          velocity: vm.Vector3(vx, vy, vz),
          mass: mass,
          radius: radius,
          color: color,
          name: name,
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
        ),
      );
    }

    return bodies;
  }
}
