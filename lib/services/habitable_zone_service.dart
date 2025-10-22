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

  /// Calculate the habitability status of a planet considering all stars in the system
  HabitabilityStatus calculateHabitabilityStatus(
    Body planet,
    List<Body> allBodies,
  ) {
    if (!planet.canBeHabitable) {
      return HabitabilityStatus.unknown;
    }

    final stars = allBodies.where((body) => body.isLuminous).toList();

    if (stars.isEmpty) {
      return HabitabilityStatus.unknown;
    }

    // For multiple stars, we need to calculate the combined effect
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

    // Determine habitability status
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
}
