import 'dart:math' as math;

import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/models/body.dart';

/// Service for calculating habitable zones and determining planet habitability
class HabitableZoneService {
  /// Calculate habitable zone boundaries for a given star
  /// Returns a map with 'inner' and 'outer' distance boundaries
  Map<String, double> calculateHabitableZone(Body star) {
    if (!star.isLuminous ||
        star.stellarLuminosity <
            SimulationConstants.minLuminosityForHabitableZone) {
      return {'inner': 0.0, 'outer': 0.0};
    }

    final luminosity = star.stellarLuminosity;
    final sqrtLuminosity = math.sqrt(luminosity);

    // Calculate habitable zone boundaries in AU
    final innerAU =
        SimulationConstants.habitableZoneInnerMultiplier * sqrtLuminosity;
    final outerAU =
        SimulationConstants.habitableZoneOuterMultiplier * sqrtLuminosity;

    // Convert to simulation units
    final innerDistance = innerAU / SimulationConstants.simulationUnitsToAU;
    final outerDistance = outerAU / SimulationConstants.simulationUnitsToAU;
    return {'inner': innerDistance, 'outer': outerDistance};
  }

  /// Calculate habitability status for a planet based on its position
  /// relative to nearby stars and their luminosities
  HabitabilityStatus calculateHabitabilityStatus(
    Body planet,
    List<Body> bodies,
  ) {
    // Only planets and moons can be habitable
    if (!planet.canBeHabitable) {
      return HabitabilityStatus.unknown;
    }

    // First check physical characteristics that override temperature considerations
    // Check for gas giant characteristics (large radius and low density suggest gas composition)
    if (_isGasGiant(planet)) {
      return HabitabilityStatus.gasGiant;
    }

    // Check if planet is too small (insufficient mass for atmosphere retention)
    if (_isTooSmall(planet)) {
      return HabitabilityStatus.tooSmall;
    }

    // Check for extreme gravity conditions
    if (_hasExtremeGravity(planet)) {
      return HabitabilityStatus.extremeGravity;
    }

    // Get all luminous bodies (stars) in the system
    final stars = bodies.where((body) => body.isLuminous).toList();

    if (stars.isEmpty) {
      return HabitabilityStatus.unknown;
    }

    // Calculate total energy received from all nearby stars
    double totalEnergyReceived = 0.0;
    bool hasNearbyLuminousStar = false;

    for (final star in stars) {
      final distance = (planet.position - star.position).length;

      // Skip if star is too dim to contribute meaningfully
      if (star.stellarLuminosity <
          SimulationConstants.minLuminosityForHabitableZone) {
        continue;
      }

      hasNearbyLuminousStar = true;

      // Calculate energy received using inverse square law
      // Energy ∝ Luminosity / distance²
      final energyFromStar = star.stellarLuminosity / (distance * distance);
      totalEnergyReceived += energyFromStar;
    }

    if (!hasNearbyLuminousStar) {
      return HabitabilityStatus.unknown;
    }

    // Convert total energy to equivalent distance from a Sun-like star
    final equivalentDistance = math.sqrt(
      SimulationConstants.solarLuminosity / totalEnergyReceived,
    );

    // Calculate habitable zone for a Sun-like star as reference
    final referenceInner =
        SimulationConstants.habitableZoneInnerMultiplier /
        SimulationConstants.simulationUnitsToAU;
    final referenceOuter =
        SimulationConstants.habitableZoneOuterMultiplier /
        SimulationConstants.simulationUnitsToAU;

    // Check for tidal locking first (close planets around small stars)
    if (_isTidallyLocked(planet, stars, equivalentDistance)) {
      return HabitabilityStatus.tidallyLocked;
    }

    // Check for radiation-related issues based on energy received
    if (_isHighRadiation(totalEnergyReceived)) {
      return HabitabilityStatus.highRadiation;
    }

    // Finally check temperature-based habitability
    if (equivalentDistance < referenceInner) {
      return HabitabilityStatus.tooHot;
    } else if (equivalentDistance > referenceOuter) {
      return HabitabilityStatus.tooCold;
    } else {
      return HabitabilityStatus.habitable;
    }
  }

  /// Update habitability status for all planets in the system
  void updateHabitabilityForAllBodies(List<Body> bodies) {
    for (final body in bodies) {
      if (body.canBeHabitable) {
        final newStatus = calculateHabitabilityStatus(body, bodies);
        body.updateHabitabilityStatus(newStatus);
      }
    }
  }

  /// Get all habitable zone boundaries for visualization
  /// Returns a list of maps containing star position and zone boundaries
  List<Map<String, dynamic>> getAllHabitableZones(List<Body> bodies) {
    final zones = <Map<String, dynamic>>[];

    for (final body in bodies) {
      if (body.isLuminous) {
        final boundaries = calculateHabitableZone(body);
        if (boundaries['inner']! > 0 && boundaries['outer']! > 0) {
          zones.add({
            'star': body,
            'position': body.position,
            'innerRadius': boundaries['inner']!,
            'outerRadius': boundaries['outer']!,
            'luminosity': body.stellarLuminosity,
          });
        }
      }
    }

    return zones;
  }

  /// Calculate the effective temperature received by a planet (simplified)
  /// Returns relative temperature compared to Earth (1.0 = Earth temperature)
  double calculateRelativeTemperature(Body planet, List<Body> allBodies) {
    final stars = allBodies.where((body) => body.isLuminous).toList();

    if (stars.isEmpty) {
      return 0.0; // No heat source
    }

    double totalEnergyReceived = 0.0;

    for (final star in stars) {
      final distance = (planet.position - star.position).length;

      if (star.stellarLuminosity <
          SimulationConstants.minLuminosityForHabitableZone) {
        continue;
      }

      // Energy received ∝ Luminosity / distance²
      final energyFromStar = star.stellarLuminosity / (distance * distance);
      totalEnergyReceived += energyFromStar;
    }

    // Convert to relative temperature (Earth = 1.0)
    // At 1 AU from Sun, we receive 1 unit of energy
    final earthEnergyReference =
        SimulationConstants.solarLuminosity /
        math.pow(1.0 / SimulationConstants.simulationUnitsToAU, 2);

    return totalEnergyReceived / earthEnergyReference;
  }

  /// Check if a planet is likely a gas giant
  /// Based on large size relative to mass (low density)
  bool _isGasGiant(Body planet) {
    // Gas giants are characterized by low density
    // Calculate rough density from mass and radius (assuming spherical)
    // Volume = (4/3) * π * r³
    final volume = (4.0 / 3.0) * math.pi * math.pow(planet.radius, 3);
    final density = planet.mass / volume;

    // Threshold for gas giant classification
    // Typical rocky planets have much higher density than gas giants
    const gasGiantDensityThreshold = 0.8;

    // Also require minimum size to be considered a gas giant
    const minGasGiantRadius = 3.0;

    return density < gasGiantDensityThreshold &&
        planet.radius > minGasGiantRadius;
  }

  /// Check if a planet is too small to maintain an atmosphere
  bool _isTooSmall(Body planet) {
    // Very small bodies cannot retain significant atmospheres
    // Based on mass and radius thresholds
    const minMassForAtmosphere = 0.005; // Much smaller than Earth
    const minRadiusForAtmosphere = 0.15; // Much smaller than Earth

    return planet.mass < minMassForAtmosphere ||
        planet.radius < minRadiusForAtmosphere;
  }

  /// Check if a planet has extreme gravity conditions
  bool _hasExtremeGravity(Body planet) {
    // Calculate surface gravity relative to Earth
    // g = GM/r² where G=1 in our simulation units
    final surfaceGravity = planet.mass / (planet.radius * planet.radius);

    // Earth-like gravity reference (mass ≈ 0.02, radius ≈ 0.6)
    const earthGravityReference = 0.02 / (0.6 * 0.6);
    final gravityRatio = surfaceGravity / earthGravityReference;

    // Consider extreme if gravity is more than 10x Earth's gravity
    const extremeGravityThreshold = 10.0;

    return gravityRatio > extremeGravityThreshold;
  }

  /// Check if energy received indicates dangerous radiation levels
  bool _isHighRadiation(double totalEnergyReceived) {
    // Very high energy levels suggest dangerous radiation
    // Compare to Earth's energy reference
    final earthEnergyReference =
        SimulationConstants.solarLuminosity /
        math.pow(1.0 / SimulationConstants.simulationUnitsToAU, 2);

    final energyRatio = totalEnergyReceived / earthEnergyReference;

    // Threshold for dangerous radiation (much higher than habitable zone limit)
    const highRadiationThreshold = 50.0;

    return energyRatio > highRadiationThreshold;
  }

  /// Check if a planet is likely tidally locked
  bool _isTidallyLocked(
    Body planet,
    List<Body> stars,
    double equivalentDistance,
  ) {
    // Tidal locking occurs when planets are very close to their stars
    // Especially around smaller, dimmer stars where habitable zones are close

    for (final star in stars) {
      final distance = (planet.position - star.position).length;

      // Convert to AU equivalent for comparison
      final distanceAU = distance * SimulationConstants.simulationUnitsToAU;

      // Tidal locking threshold - planets closer than ~0.1 AU are likely locked
      const tidalLockingDistanceAU = 0.1;

      if (distanceAU < tidalLockingDistanceAU) {
        return true;
      }
    }

    return false;
  }
}
