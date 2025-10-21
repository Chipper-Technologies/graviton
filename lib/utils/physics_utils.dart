import 'dart:math' as math;

import 'package:graviton/constants/simulation_constants.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Physics utility functions for gravitational calculations and energy computations
class PhysicsUtils {
  PhysicsUtils._(); // Private constructor to prevent instantiation

  /// Calculate gravitational acceleration using inverse square law
  /// Returns acceleration vector that body1 experiences from body2
  static vm.Vector3 calculateGravitationalAcceleration(
    vm.Vector3 pos1,
    vm.Vector3 pos2,
    double mass2, {
    double softening = SimulationConstants.softening,
  }) {
    final r = pos2 - pos1;
    final dist2 = r.length2 + softening;
    final invR = 1.0 / math.sqrt(dist2);
    final invR3 = invR * invR * invR;
    return r * (SimulationConstants.gravitationalConstant * mass2 * invR3);
  }

  /// Calculate energy received using inverse square law
  /// Energy ∝ Luminosity / distance²
  static double calculateEnergyReceived(double luminosity, double distance) {
    if (distance <= 0 || luminosity <= 0) return 0.0;
    return luminosity / (distance * distance);
  }

  /// Calculate total energy received from multiple luminous sources
  static double calculateTotalEnergyReceived(
    vm.Vector3 receiverPosition,
    List<MapEntry<vm.Vector3, double>> luminousSources,
  ) {
    double totalEnergy = 0.0;

    for (final source in luminousSources) {
      final distance = (receiverPosition - source.key).length;
      if (distance > 0 && source.value > 0) {
        totalEnergy += calculateEnergyReceived(source.value, distance);
      }
    }

    return totalEnergy;
  }

  /// Convert energy to equivalent distance from a reference star
  /// Used for habitability calculations
  static double energyToEquivalentDistance(double totalEnergy, double referenceLuminosity) {
    if (totalEnergy <= 0 || referenceLuminosity <= 0) return double.infinity;
    return math.sqrt(referenceLuminosity / totalEnergy);
  }

  /// Calculate relative temperature compared to Earth (1.0 = Earth temperature)
  static double calculateRelativeTemperature(double totalEnergyReceived, double earthEnergyReference) {
    if (earthEnergyReference <= 0) return 0.0;
    return totalEnergyReceived / earthEnergyReference;
  }

  /// Calculate Earth's energy reference for temperature calculations
  static double calculateEarthEnergyReference() {
    final earthDistanceFromSun = 1.0 / SimulationConstants.simulationUnitsToAU;
    return SimulationConstants.solarLuminosity / math.pow(earthDistanceFromSun, 2);
  }

  /// Calculate habitable zone boundaries for a given stellar luminosity
  /// Returns inner and outer distances in simulation units
  static Map<String, double> calculateHabitableZoneBoundaries(double luminosity) {
    if (luminosity < SimulationConstants.minLuminosityForHabitableZone) {
      return {'inner': 0.0, 'outer': 0.0};
    }

    final sqrtLuminosity = math.sqrt(luminosity);

    // Calculate boundaries in AU
    final innerAU = SimulationConstants.habitableZoneInnerMultiplier * sqrtLuminosity;
    final outerAU = SimulationConstants.habitableZoneOuterMultiplier * sqrtLuminosity;

    // Convert to simulation units
    final innerDistance = innerAU / SimulationConstants.simulationUnitsToAU;
    final outerDistance = outerAU / SimulationConstants.simulationUnitsToAU;

    return {'inner': innerDistance, 'outer': outerDistance};
  }

  /// Calculate orbital velocity for circular orbit
  static double calculateOrbitalVelocity(double totalMass, double distance) {
    if (distance <= 0 || totalMass <= 0) return 0.0;
    return math.sqrt(SimulationConstants.gravitationalConstant * totalMass / distance);
  }

  /// Calculate escape velocity from a massive body
  static double calculateEscapeVelocity(double mass, double radius) {
    if (radius <= 0 || mass <= 0) return 0.0;
    return math.sqrt(2 * SimulationConstants.gravitationalConstant * mass / radius);
  }

  /// Calculate kinetic energy of a body
  static double calculateKineticEnergy(double mass, vm.Vector3 velocity) {
    return 0.5 * mass * velocity.length2;
  }

  /// Calculate potential energy between two bodies
  static double calculatePotentialEnergy(
    double mass1,
    double mass2,
    double distance, {
    double softening = SimulationConstants.softening,
  }) {
    if (distance <= 0) return 0.0;
    final effectiveDistance = math.sqrt(distance * distance + softening);
    return -SimulationConstants.gravitationalConstant * mass1 * mass2 / effectiveDistance;
  }

  /// Calculate total system energy (kinetic + potential)
  static double calculateSystemEnergy(List<double> masses, List<vm.Vector3> positions, List<vm.Vector3> velocities) {
    if (masses.length != positions.length || masses.length != velocities.length) {
      throw ArgumentError('All lists must have the same length');
    }

    double totalKinetic = 0.0;
    double totalPotential = 0.0;

    // Calculate kinetic energy
    for (int i = 0; i < masses.length; i++) {
      totalKinetic += calculateKineticEnergy(masses[i], velocities[i]);
    }

    // Calculate potential energy
    for (int i = 0; i < masses.length; i++) {
      for (int j = i + 1; j < masses.length; j++) {
        final distance = (positions[i] - positions[j]).length;
        totalPotential += calculatePotentialEnergy(masses[i], masses[j], distance);
      }
    }

    return totalKinetic + totalPotential;
  }

  /// Calculate center of mass for a system of bodies
  static vm.Vector3 calculateCenterOfMass(List<double> masses, List<vm.Vector3> positions) {
    if (masses.length != positions.length || masses.isEmpty) {
      return vm.Vector3.zero();
    }

    double totalMass = 0.0;
    vm.Vector3 weightedPosition = vm.Vector3.zero();

    for (int i = 0; i < masses.length; i++) {
      totalMass += masses[i];
      weightedPosition += positions[i] * masses[i];
    }

    if (totalMass > 0) {
      return weightedPosition / totalMass;
    }

    return vm.Vector3.zero();
  }

  /// Calculate system momentum
  static vm.Vector3 calculateSystemMomentum(List<double> masses, List<vm.Vector3> velocities) {
    if (masses.length != velocities.length) {
      return vm.Vector3.zero();
    }

    vm.Vector3 totalMomentum = vm.Vector3.zero();
    for (int i = 0; i < masses.length; i++) {
      totalMomentum += velocities[i] * masses[i];
    }

    return totalMomentum;
  }
}
