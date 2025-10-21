import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';

/// Represents a celestial body in the simulation
class Body {
  vm.Vector3 position;
  vm.Vector3 velocity;
  double mass; // arbitrary units
  double radius; // visual size only
  Color color;
  bool isPlanet; // larger gravitational influence, fixed or slow-moving
  String name; // descriptive name for the body

  // Habitability properties
  BodyType bodyType;
  double stellarLuminosity; // relative to Sun (1.0 = Sun's luminosity), only relevant for stars
  HabitabilityStatus habitabilityStatus;

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
  });

  /// Whether this body is a star that emits light
  bool get isLuminous => bodyType.isLuminous;

  /// Whether this body can potentially be habitable
  bool get canBeHabitable => bodyType.canBeHabitable;

  /// Update habitability status (called by HabitableZoneService)
  void updateHabitabilityStatus(HabitabilityStatus newStatus) {
    habitabilityStatus = newStatus;
  }
}
