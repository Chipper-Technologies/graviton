import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';

/// Represents a celestial body in the simulation
class Body {
  vm.Vector3 position;
  vm.Vector3 velocity;
  double mass;
  double radius; // visual size only
  Color color;
  bool isPlanet; // larger gravitational influence, fixed or slow-moving
  String name; // descriptive name for the body

  // Habitability properties
  BodyType bodyType;
  double
  stellarLuminosity; // relative to Sun (1.0 = Sun's luminosity), only relevant for stars
  HabitabilityStatus habitabilityStatus;
  double temperature; // surface temperature in Kelvin (for planets/moons)
  bool
  _showGravityWell; // whether to display gravity well visualization for this body

  bool
  _isOrbitalPlacementActive; // whether orbital placement mode is currently active for this body

  bool
  _useRealisticColor; // whether to use realistic color based on stellar classification (only applies to stars)

  // Orbital parameters (used when orbital placement is active)
  double _orbitRadius; // distance from central body
  double _orbitPhase; // orbital phase (0 to 2π)
  double _orbitInclination; // orbital inclination (0 to π/2)

  // Getter and setter for showGravityWell
  bool get showGravityWell => _showGravityWell;
  set showGravityWell(bool value) {
    if (_showGravityWell != value) {
      _showGravityWell = value;
    }
  }

  // Getter and setter for isOrbitalPlacementActive
  bool get isOrbitalPlacementActive => _isOrbitalPlacementActive;
  set isOrbitalPlacementActive(bool value) {
    if (_isOrbitalPlacementActive != value) {
      _isOrbitalPlacementActive = value;
    }
  }

  // Getter and setter for useRealisticColor
  bool get useRealisticColor => _useRealisticColor;
  set useRealisticColor(bool value) {
    if (_useRealisticColor != value) {
      _useRealisticColor = value;
    }
  }

  // Getters and setters for orbital parameters
  double get orbitRadius => _orbitRadius;
  set orbitRadius(double value) {
    if (_orbitRadius != value) {
      _orbitRadius = value;
    }
  }

  double get orbitPhase => _orbitPhase;
  set orbitPhase(double value) {
    if (_orbitPhase != value) {
      _orbitPhase = value;
    }
  }

  double get orbitInclination => _orbitInclination;
  set orbitInclination(double value) {
    if (_orbitInclination != value) {
      _orbitInclination = value;
    }
  }

  Body({
    required this.position,
    required this.velocity,
    required this.mass,
    required this.radius,
    required this.color,
    required this.name,
    this.isPlanet = false,
    this.bodyType = BodyType.planet,
    this.stellarLuminosity = 0.0,
    this.habitabilityStatus = HabitabilityStatus.unknown,
    this.temperature =
        SimulationConstants.kelvinToCelsiusOffset, // Default to 0°C
    bool showGravityWell = false, // Disabled by default
    bool isOrbitalPlacementActive = false, // Disabled by default
    bool useRealisticColor = true, // Default to realistic color for stars
    double orbitRadius = SimulationConstants.defaultOrbitRadius,
    double orbitPhase = 0.0, // Default phase (0 to 2π)
    double orbitInclination = 0.0, // Default inclination (0 to π/2)
  }) : _showGravityWell = showGravityWell,
       _isOrbitalPlacementActive = isOrbitalPlacementActive,
       _useRealisticColor = useRealisticColor,
       _orbitRadius = orbitRadius,
       _orbitPhase = orbitPhase,
       _orbitInclination = orbitInclination;

  /// Whether this body is a star that emits light
  bool get isLuminous => bodyType.isLuminous;

  /// Whether this body can potentially be habitable
  bool get canBeHabitable => bodyType.canBeHabitable;

  /// Get temperature in Celsius
  double get temperatureCelsius =>
      temperature - SimulationConstants.kelvinToCelsiusOffset;

  /// Get temperature in Fahrenheit
  double get temperatureFahrenheit =>
      (temperature - SimulationConstants.kelvinToCelsiusOffset) * 9 / 5 + 32;

  /// Whether this planet has a reasonable temperature for life (0-100°C)
  bool get hasReasonableTemperature =>
      canBeHabitable && temperatureCelsius >= -50 && temperatureCelsius <= 150;

  /// Get temperature category for display
  String get temperatureCategory {
    if (!canBeHabitable) return 'temperatureNotApplicable';
    final celsius = temperatureCelsius;
    if (celsius < -100) return 'temperatureFrozen';
    if (celsius < 0) return 'temperatureCold';
    if (celsius < 50) return 'temperatureModerate';
    if (celsius < 150) return 'temperatureHot';
    return 'temperatureScorching';
  }

  /// Update habitability status (called by HabitableZoneService)
  void updateHabitabilityStatus(HabitabilityStatus newStatus) {
    habitabilityStatus = newStatus;
  }

  /// Update surface temperature based on stellar heating
  void updateTemperature(double newTemperature) {
    temperature = newTemperature;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Body &&
        other.position == position &&
        other.velocity == velocity &&
        other.mass == mass &&
        other.radius == radius &&
        other.color == color &&
        other.name == name &&
        other.isPlanet == isPlanet &&
        other.bodyType == bodyType &&
        other.stellarLuminosity == stellarLuminosity &&
        other.habitabilityStatus == habitabilityStatus &&
        other.temperature == temperature &&
        other.showGravityWell == showGravityWell &&
        other.isOrbitalPlacementActive == isOrbitalPlacementActive &&
        other.useRealisticColor == useRealisticColor &&
        other.orbitRadius == orbitRadius &&
        other.orbitPhase == orbitPhase &&
        other.orbitInclination == orbitInclination;
  }

  @override
  int get hashCode {
    return Object.hash(
      position,
      velocity,
      mass,
      radius,
      color,
      name,
      isPlanet,
      bodyType,
      stellarLuminosity,
      habitabilityStatus,
      temperature,
      showGravityWell,
      isOrbitalPlacementActive,
      useRealisticColor,
      Object.hash(orbitRadius, orbitPhase, orbitInclination),
    );
  }
}
