import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';

import 'body.dart';

/// Represents a preset astronomical scenario with predefined celestial bodies
class PresetScenario {
  final ScenarioType type;
  final String name;
  final String description;
  final List<Body> bodies;
  final IconData icon;
  final Color primaryColor;

  const PresetScenario({
    required this.type,
    required this.name,
    required this.description,
    required this.bodies,
    required this.icon,
    required this.primaryColor,
  });
}
