import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';

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

  // Relativistic effects properties
  double
  properTime; // proper time elapsed for this body (relativistic time dilation)
  double timeDilationFactor; // γ factor from special relativity
  bool
  _showRelativisticGlow; // whether to show visual glow for high-velocity bodies

  // Tidal force properties
  double tidalStress; // magnitude of tidal stress experienced by this body
  vm.Vector3 tidalAxisMajor; // direction of major tidal axis (stretching)
  vm.Vector3 tidalAxisMinor; // direction of minor tidal axis (compression)
  bool _showTidalForces; // whether to show tidal force visualization
  double tidalHeating; // heating from tidal forces (energy per unit time)

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

  // Getter and setter for showRelativisticGlow
  bool get showRelativisticGlow => _showRelativisticGlow;
  set showRelativisticGlow(bool value) {
    if (_showRelativisticGlow != value) {
      _showRelativisticGlow = value;
    }
  }

  // Getter and setter for showTidalForces
  bool get showTidalForces => _showTidalForces;
  set showTidalForces(bool value) {
    if (_showTidalForces != value) {
      _showTidalForces = value;
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
    // Relativistic properties
    this.properTime = 0.0, // Start at zero proper time
    this.timeDilationFactor = 1.0, // No dilation initially (γ = 1)
    bool showRelativisticGlow = false, // Disabled by default
    // Tidal force properties
    this.tidalStress = 0.0, // No tidal stress initially
    vm.Vector3? tidalAxisMajor, // Optional, defaults to zero vector
    vm.Vector3? tidalAxisMinor, // Optional, defaults to zero vector
    bool showTidalForces = false, // Disabled by default
    this.tidalHeating = 0.0, // No tidal heating initially
  }) : _showGravityWell = showGravityWell,
       _isOrbitalPlacementActive = isOrbitalPlacementActive,
       _useRealisticColor = useRealisticColor,
       _orbitRadius = orbitRadius,
       _orbitPhase = orbitPhase,
       _orbitInclination = orbitInclination,
       _showRelativisticGlow = showRelativisticGlow,
       _showTidalForces = showTidalForces,
       tidalAxisMajor = tidalAxisMajor ?? vm.Vector3.zero(),
       tidalAxisMinor = tidalAxisMinor ?? vm.Vector3.zero();

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
        other.orbitInclination == orbitInclination &&
        other.properTime == properTime &&
        other.timeDilationFactor == timeDilationFactor &&
        other.showRelativisticGlow == showRelativisticGlow &&
        other.tidalStress == tidalStress &&
        other.tidalAxisMajor == tidalAxisMajor &&
        other.tidalAxisMinor == tidalAxisMinor &&
        other.showTidalForces == showTidalForces &&
        other.tidalHeating == tidalHeating;
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
      Object.hash(
        orbitRadius,
        orbitPhase,
        orbitInclination,
        properTime,
        timeDilationFactor,
        showRelativisticGlow,
        tidalStress,
        tidalAxisMajor,
        tidalAxisMinor,
        showTidalForces,
        tidalHeating,
      ),
    );
  }
}
