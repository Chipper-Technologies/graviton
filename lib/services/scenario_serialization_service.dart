import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/custom_scenario.dart';

/// Service for converting between internal simulation objects and JSON format
class ScenarioSerializationService {
  /// Convert a list of Body objects to a CustomScenario JSON structure
  static CustomScenario fromBodies({
    required List<Body> bodies,
    required ScenarioMetadata metadata,
    ScenarioConfiguration? configuration,
    PhysicsSettings? physics,
    ParticleSystemsConfig? particleSystems,
    ObjectivesConfig? objectives,
  }) {
    return CustomScenario(
      version: '1.0.0',
      metadata: metadata,
      configuration: configuration ?? _defaultConfiguration(bodies.length),
      physics: physics ?? _defaultPhysics(),
      bodies: bodies.map(_bodyToBodyData).toList(),
      particleSystems: particleSystems ?? const ParticleSystemsConfig(),
      objectives: objectives,
    );
  }

  /// Convert a CustomScenario to a list of Body objects
  static List<Body> toBodies(CustomScenario scenario) {
    return scenario.bodies.map(_bodyDataToBody).toList();
  }

  /// Convert a CustomScenario to JSON string
  static String toJsonString(CustomScenario scenario) {
    return const JsonEncoder.withIndent('  ').convert(scenario.toJson());
  }

  /// Parse a JSON string into a CustomScenario
  static CustomScenario fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return CustomScenario.fromJson(json);
  }

  /// Validate a JSON string before parsing
  static ScenarioValidationResult validateJsonString(
    String jsonString, [
    AppLocalizations? l10n,
  ]) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return _validateScenarioJson(json, l10n);
    } catch (e) {
      return ScenarioValidationResult(
        isValid: false,
        errors: [
          l10n?.invalidJsonFormat(e.toString()) ??
              'Invalid JSON format: ${e.toString()}',
        ],
      );
    }
  }

  /// Convert Body to BodyData for JSON serialization
  static BodyData _bodyToBodyData(Body body) {
    return BodyData(
      name: body.name,
      position: [body.position.x, body.position.y, body.position.z],
      velocity: [body.velocity.x, body.velocity.y, body.velocity.z],
      mass: body.mass,
      radius: body.radius,
      color: _colorToHex(body.color),
      bodyType: body.bodyType.name,
      stellarLuminosity: body.stellarLuminosity,
      temperature: body.temperature,
      showGravityWell: body.showGravityWell,
      isPlanet: body.isPlanet,
      habitabilityStatus: body.habitabilityStatus.name,
    );
  }

  /// Convert BodyData from JSON to Body object
  static Body _bodyDataToBody(BodyData bodyData) {
    return Body(
      name: bodyData.name,
      position: vm.Vector3(
        bodyData.position[0],
        bodyData.position[1],
        bodyData.position[2],
      ),
      velocity: vm.Vector3(
        bodyData.velocity[0],
        bodyData.velocity[1],
        bodyData.velocity[2],
      ),
      mass: bodyData.mass,
      radius: bodyData.radius,
      color: _hexToColor(bodyData.color),
      bodyType: _stringToBodyType(bodyData.bodyType),
      stellarLuminosity: bodyData.stellarLuminosity,
      temperature: bodyData.temperature,
      showGravityWell: bodyData.showGravityWell,
      isPlanet: bodyData.isPlanet,
      habitabilityStatus: _stringToHabitabilityStatus(
        bodyData.habitabilityStatus,
      ),
    );
  }

  /// Convert Color to hex string
  static String _colorToHex(Color color) {
    return '#${(color.a * 255).round().toRadixString(16).padLeft(2, '0')}'
            '${(color.r * 255).round().toRadixString(16).padLeft(2, '0')}'
            '${(color.g * 255).round().toRadixString(16).padLeft(2, '0')}'
            '${(color.b * 255).round().toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  /// Convert hex string to Color
  static Color _hexToColor(String hex) {
    final hexCode = hex.replaceFirst('#', '');
    if (hexCode.length == 6) {
      return Color(int.parse('FF$hexCode', radix: 16));
    } else if (hexCode.length == 8) {
      return Color(int.parse(hexCode, radix: 16));
    }
    throw ArgumentError('Invalid hex color format: $hex');
  }

  /// Convert string to BodyType enum
  static BodyType _stringToBodyType(String typeString) {
    for (final type in BodyType.values) {
      if (type.name == typeString) {
        return type;
      }
    }
    throw ArgumentError('Invalid body type: $typeString');
  }

  /// Convert string to HabitabilityStatus enum
  static HabitabilityStatus _stringToHabitabilityStatus(String statusString) {
    for (final status in HabitabilityStatus.values) {
      if (status.name == statusString) {
        return status;
      }
    }
    throw ArgumentError('Invalid habitability status: $statusString');
  }

  /// Create default configuration
  static ScenarioConfiguration _defaultConfiguration(int bodyCount) {
    return ScenarioConfiguration(
      optimalCameraDistance: null, // Auto-calculate
      cameraDistanceMultiplier: 1.2,
      expectedBodyCount: bodyCount,
    );
  }

  /// Create default physics settings
  static PhysicsSettings _defaultPhysics() {
    return const PhysicsSettings(
      gravitationalConstant: 1.2,
      softening: 0.1,
      timeScale: 1.0,
      collisionRadiusMultiplier: 1.0,
      maxTrailPoints: 500,
      trailFadeRate: 0.95,
    );
  }

  /// Validate scenario JSON structure
  static ScenarioValidationResult _validateScenarioJson(
    Map<String, dynamic> json, [
    AppLocalizations? l10n,
  ]) {
    final List<String> errors = [];

    // Check required top-level fields
    if (!json.containsKey('version')) {
      errors.add(
        l10n?.missingRequiredFieldVersion ?? 'Missing required field: version',
      );
    }
    if (!json.containsKey('metadata')) {
      errors.add(
        l10n?.missingRequiredFieldMetadata ??
            'Missing required field: metadata',
      );
    }
    if (!json.containsKey('configuration')) {
      errors.add(
        l10n?.missingRequiredFieldConfiguration ??
            'Missing required field: configuration',
      );
    }
    if (!json.containsKey('physics')) {
      errors.add(
        l10n?.missingRequiredFieldPhysics ?? 'Missing required field: physics',
      );
    }
    if (!json.containsKey('bodies')) {
      errors.add(
        l10n?.missingRequiredFieldBodies ?? 'Missing required field: bodies',
      );
    }
    if (!json.containsKey('particleSystems')) {
      errors.add(
        l10n?.missingRequiredFieldParticleSystems ??
            'Missing required field: particleSystems',
      );
    }

    if (errors.isNotEmpty) {
      return ScenarioValidationResult(isValid: false, errors: errors);
    }

    // Validate metadata
    final metadata = json['metadata'] as Map<String, dynamic>;
    if (!metadata.containsKey('name') || (metadata['name'] as String).isEmpty) {
      errors.add(
        l10n?.scenarioNameRequired ??
            'Scenario name is required and cannot be empty',
      );
    }
    if (metadata.containsKey('name') &&
        (metadata['name'] as String).length > 100) {
      errors.add(
        l10n?.scenarioNameTooLong ??
            'Scenario name must be 100 characters or less',
      );
    }

    // Validate bodies
    final bodies = json['bodies'] as List;
    if (bodies.isEmpty) {
      errors.add(
        l10n?.atLeastOneBodyIsRequired ?? 'At least one body is required',
      );
    }
    if (bodies.length > 50) {
      errors.add(l10n?.maximum50BodiesAllowed ?? 'Maximum 50 bodies allowed');
    }

    // Validate each body
    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i] as Map<String, dynamic>;
      final bodyErrors = _validateBodyData(body, i, l10n);
      errors.addAll(bodyErrors);
    }

    // Validate physics settings
    final physics = json['physics'] as Map<String, dynamic>;
    final physicsErrors = _validatePhysicsSettings(physics, l10n);
    errors.addAll(physicsErrors);

    return ScenarioValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validate individual body data
  static List<String> _validateBodyData(
    Map<String, dynamic> body,
    int index, [
    AppLocalizations? l10n,
  ]) {
    final List<String> errors = [];
    final String prefix = l10n?.bodyIndex(index) ?? 'Body $index';

    // Check required fields
    if (!body.containsKey('name') || (body['name'] as String).isEmpty) {
      errors.add(l10n?.bodyNameRequired(prefix) ?? '$prefix: name is required');
    }

    if (!body.containsKey('position') ||
        (body['position'] as List).length != 3) {
      errors.add(
        l10n?.bodyPositionInvalid(prefix) ??
            '$prefix: position must be a 3D array [x, y, z]',
      );
    } else {
      final pos = body['position'] as List;
      for (int i = 0; i < 3; i++) {
        if (pos[i] is! num || !pos[i].isFinite) {
          errors.add(
            l10n?.bodyPositionComponentInvalid(prefix, i) ??
                '$prefix: position[$i] must be a finite number',
          );
        }
      }
    }

    if (!body.containsKey('velocity') ||
        (body['velocity'] as List).length != 3) {
      errors.add(
        l10n?.bodyVelocityInvalid(prefix) ??
            '$prefix: velocity must be a 3D array [vx, vy, vz]',
      );
    } else {
      final vel = body['velocity'] as List;
      for (int i = 0; i < 3; i++) {
        if (vel[i] is! num || !vel[i].isFinite) {
          errors.add(
            l10n?.bodyVelocityComponentInvalid(prefix, i) ??
                '$prefix: velocity[$i] must be a finite number',
          );
        }
      }
    }

    // Validate numeric ranges
    if (body.containsKey('mass')) {
      final mass = body['mass'];
      if (mass is! num || mass <= 0 || mass > 1000) {
        errors.add(
          l10n?.bodyMassInvalid(prefix) ??
              '$prefix: mass must be between 0.001 and 1000',
        );
      }
    }

    if (body.containsKey('radius')) {
      final radius = body['radius'];
      if (radius is! num || radius <= 0 || radius > 50) {
        errors.add(
          l10n?.bodyRadiusInvalid(prefix) ??
              '$prefix: radius must be between 0.1 and 50',
        );
      }
    }

    // Validate color format
    if (body.containsKey('color')) {
      final color = body['color'] as String;
      if (!_isValidHexColor(color)) {
        errors.add(
          l10n?.bodyColorInvalid(prefix) ??
              '$prefix: color must be valid hex format (#RRGGBB or #AARRGGBB)',
        );
      }
    }

    // Validate enums
    if (body.containsKey('bodyType')) {
      final bodyType = body['bodyType'] as String;
      if (!BodyType.values.any((type) => type.name == bodyType)) {
        errors.add(
          l10n?.bodyTypeInvalid(prefix, bodyType) ??
              '$prefix: invalid bodyType "$bodyType"',
        );
      }
    }

    return errors;
  }

  /// Validate physics settings
  static List<String> _validatePhysicsSettings(
    Map<String, dynamic> physics, [
    AppLocalizations? l10n,
  ]) {
    final List<String> errors = [];

    final fieldsToValidate = {
      'gravitationalConstant': (0.1, 10.0),
      'softening': (0.0, 1.0),
      'timeScale': (0.1, 16.0),
      'collisionRadiusMultiplier': (0.1, 10.0),
      'trailFadeRate': (0.1, 1.0),
    };

    for (final field in fieldsToValidate.keys) {
      if (physics.containsKey(field)) {
        final value = physics[field];
        final range = fieldsToValidate[field]!;
        if (value is! num || value < range.$1 || value > range.$2) {
          errors.add(
            l10n?.physicsFieldRangeError(field, range.$1, range.$2) ??
                '$field must be between ${range.$1} and ${range.$2}',
          );
        }
      }
    }

    if (physics.containsKey('maxTrailPoints')) {
      final value = physics['maxTrailPoints'];
      if (value is! int || value < 10 || value > 5000) {
        errors.add(
          l10n?.maxTrailPointsInvalid ??
              'maxTrailPoints must be between 10 and 5000',
        );
      }
    }

    return errors;
  }

  /// Check if a string is a valid hex color
  static bool _isValidHexColor(String hex) {
    final pattern = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');
    return pattern.hasMatch(hex);
  }
}

/// Result of scenario validation
class ScenarioValidationResult {
  final bool isValid;
  final List<String> errors;

  const ScenarioValidationResult({required this.isValid, required this.errors});
}
