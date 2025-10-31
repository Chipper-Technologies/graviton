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

  // Getter and setter for showGravityWell
  bool get showGravityWell => _showGravityWell;
  set showGravityWell(bool value) {
    if (_showGravityWell != value) {
      _showGravityWell = value;
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
  }) : _showGravityWell = showGravityWell;

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
}
