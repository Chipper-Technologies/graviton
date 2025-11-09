import 'package:flutter/material.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:graviton/services/custom_scenario_storage.dart';
import 'package:graviton/services/scenario_serialization_service.dart';
import 'package:graviton/theme/app_colors.dart';

/// Service for managing custom scenarios and integrating them with the simulation system
///
/// This service bridges the gap between user-created custom scenarios and the existing
/// preset scenario system, allowing custom scenarios to be loaded and used just like
/// built-in scenarios.
class CustomScenarioManager {
  /// Singleton instance
  static final CustomScenarioManager _instance =
      CustomScenarioManager._internal();

  /// Access the singleton instance
  static CustomScenarioManager get instance => _instance;

  CustomScenarioManager._internal();

  /// Currently loaded custom scenario (if any)
  CustomScenario? _currentCustomScenario;

  /// Get the currently loaded custom scenario
  CustomScenario? get currentCustomScenario => _currentCustomScenario;

  /// Check if we're currently using a custom scenario
  bool get hasCustomScenario => _currentCustomScenario != null;

  /// Get the name of the current custom scenario (for display purposes)
  String? get currentCustomScenarioName =>
      _currentCustomScenario?.metadata.name;

  /// Load a custom scenario by name and prepare it for simulation
  Future<List<Body>> loadCustomScenario(String scenarioName) async {
    try {
      final scenario = await CustomScenarioStorage.loadScenario(scenarioName);
      if (scenario == null) {
        throw Exception('Custom scenario not found: $scenarioName');
      }

      _currentCustomScenario = scenario;

      // Convert the custom scenario to Body objects that the simulation can use
      return ScenarioSerializationService.toBodies(scenario);
    } catch (e) {
      debugPrint('Failed to load custom scenario: $e');
      rethrow;
    }
  }

  /// Clear the currently loaded custom scenario
  void clearCurrentCustomScenario() {
    _currentCustomScenario = null;
  }

  /// Get all available custom scenarios for display in scenario selection
  Future<List<CustomScenarioSummary>> getAvailableCustomScenarios() async {
    try {
      final scenarios = await CustomScenarioStorage.getAllScenarios();
      return scenarios
          .map(
            (scenario) => CustomScenarioSummary(
              name: scenario.metadata.name,
              description: scenario.metadata.description,
              bodyCount: scenario.bodies.length,
              difficulty: scenario.metadata.difficulty,
              educationalFocus: scenario.metadata.educationalFocus,
              tags: scenario.metadata.tags,
              createdAt: scenario.metadata.createdAt,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Failed to load custom scenarios: $e');
      return [];
    }
  }

  /// Delete a custom scenario
  Future<void> deleteCustomScenario(String scenarioName) async {
    try {
      await CustomScenarioStorage.deleteScenario(scenarioName);

      // Clear current scenario if it was deleted
      if (_currentCustomScenario?.metadata.name == scenarioName) {
        _currentCustomScenario = null;
      }
    } catch (e) {
      debugPrint('Failed to delete custom scenario: $e');
      rethrow;
    }
  }

  /// Check if a custom scenario exists
  Future<bool> scenarioExists(String scenarioName) async {
    return await CustomScenarioStorage.scenarioExists(scenarioName);
  }

  /// Export a custom scenario to JSON string for sharing
  Future<String> exportScenarioToJson(String scenarioName) async {
    final scenario = await CustomScenarioStorage.loadScenario(scenarioName);
    if (scenario == null) {
      throw Exception('Custom scenario not found: $scenarioName');
    }
    return CustomScenarioStorage.exportScenarioToJson(scenario);
  }

  /// Import a custom scenario from JSON string
  Future<void> importScenarioFromJson(
    String jsonString, {
    String? newName,
  }) async {
    try {
      final scenario = CustomScenarioStorage.importScenarioFromJson(jsonString);

      // Use new name if provided, otherwise ensure uniqueness
      String finalName = newName ?? scenario.metadata.name;
      if (await CustomScenarioStorage.scenarioExists(finalName)) {
        finalName = await CustomScenarioStorage.getUniqueScenarioName(
          finalName,
        );
      }

      // Create updated scenario with new name if needed
      final updatedScenario = finalName != scenario.metadata.name
          ? CustomScenario(
              version: scenario.version,
              metadata: ScenarioMetadata(
                name: finalName,
                description: scenario.metadata.description,
                author: scenario.metadata.author,
                createdAt: DateTime.now(),
                educationalFocus: scenario.metadata.educationalFocus,
                tags: scenario.metadata.tags,
                difficulty: scenario.metadata.difficulty,
              ),
              configuration: scenario.configuration,
              physics: scenario.physics,
              bodies: scenario.bodies,
              particleSystems: scenario.particleSystems,
              objectives: scenario.objectives,
            )
          : scenario;

      await CustomScenarioStorage.saveScenario(updatedScenario);
    } catch (e) {
      debugPrint('Failed to import custom scenario: $e');
      rethrow;
    }
  }

  /// Test a custom scenario by loading it temporarily (without setting as current)
  Future<List<Body>> previewCustomScenario(String scenarioName) async {
    try {
      final scenario = await CustomScenarioStorage.loadScenario(scenarioName);
      if (scenario == null) {
        throw Exception('Custom scenario not found: $scenarioName');
      }

      // Convert to bodies without setting as current scenario
      return ScenarioSerializationService.toBodies(scenario);
    } catch (e) {
      debugPrint('Failed to preview custom scenario: $e');
      rethrow;
    }
  }

  /// Create a duplicate of an existing custom scenario
  Future<String> duplicateScenario(
    String scenarioName, {
    String? newName,
  }) async {
    try {
      final scenario = await CustomScenarioStorage.loadScenario(scenarioName);
      if (scenario == null) {
        throw Exception('Custom scenario not found: $scenarioName');
      }

      // Generate unique name
      final baseName = newName ?? '${scenario.metadata.name} (Copy)';
      final uniqueName = await CustomScenarioStorage.getUniqueScenarioName(
        baseName,
      );

      // Create duplicate with new name and updated timestamp
      final duplicate = CustomScenario(
        version: scenario.version,
        metadata: ScenarioMetadata(
          name: uniqueName,
          description: scenario.metadata.description,
          author: scenario.metadata.author,
          createdAt: DateTime.now(),
          educationalFocus: scenario.metadata.educationalFocus,
          tags: scenario.metadata.tags,
          difficulty: scenario.metadata.difficulty,
        ),
        configuration: scenario.configuration,
        physics: scenario.physics,
        bodies: scenario.bodies,
        particleSystems: scenario.particleSystems,
        objectives: scenario.objectives,
      );

      await CustomScenarioStorage.saveScenario(duplicate);
      return uniqueName;
    } catch (e) {
      debugPrint('Failed to duplicate custom scenario: $e');
      rethrow;
    }
  }
}

/// Summary information about a custom scenario (for UI display)
class CustomScenarioSummary {
  final String name;
  final String description;
  final int bodyCount;
  final String difficulty;
  final String educationalFocus;
  final List<String> tags;
  final DateTime? createdAt;

  const CustomScenarioSummary({
    required this.name,
    required this.description,
    required this.bodyCount,
    required this.difficulty,
    required this.educationalFocus,
    required this.tags,
    this.createdAt,
  });

  /// Create a formatted body count string for UI display
  String get bodyCountDisplay =>
      '$bodyCount ${bodyCount == 1 ? 'body' : 'bodies'}';

  /// Create a formatted difficulty display with capitalization
  String get difficultyDisplay =>
      difficulty.substring(0, 1).toUpperCase() + difficulty.substring(1);

  /// Get a color for the difficulty level
  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.uiGreen;
      case 'intermediate':
        return AppColors.uiOrange;
      case 'advanced':
        return AppColors.uiRed;
      default:
        return AppColors.primaryColor;
    }
  }

  /// Create a formatted date string for UI display
  String get createdAtDisplay {
    if (createdAt == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }
}
