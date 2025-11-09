import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:graviton/models/custom_scenario.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for local storage of custom scenarios
///
/// Handles saving, loading, and managing custom simulation scenarios
/// created by users using SharedPreferences for cross-platform compatibility.
class CustomScenarioStorage {
  static const String _scenariosKey = 'custom_scenarios';

  /// Save a custom scenario to local storage
  static Future<void> saveScenario(CustomScenario scenario) async {
    try {
      await _saveToPreferences(scenario);
    } catch (e) {
      throw Exception('Failed to save scenario: $e');
    }
  }

  /// Load a custom scenario by name
  static Future<CustomScenario?> loadScenario(String scenarioName) async {
    try {
      return await _loadFromPreferences(scenarioName);
    } catch (e) {
      throw Exception('Failed to load scenario: $e');
    }
  }

  /// Get list of all saved scenarios
  static Future<List<CustomScenario>> getAllScenarios() async {
    try {
      return await _getAllFromPreferences();
    } catch (e) {
      throw Exception('Failed to load scenarios: $e');
    }
  }

  /// Delete a scenario by name
  static Future<void> deleteScenario(String scenarioName) async {
    try {
      await _deleteFromPreferences(scenarioName);
    } catch (e) {
      throw Exception('Failed to delete scenario: $e');
    }
  }

  /// Export scenario to JSON string (for sharing/export)
  static String exportScenarioToJson(CustomScenario scenario) {
    final json = scenario.toJson();
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  /// Import scenario from JSON string
  static CustomScenario importScenarioFromJson(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return CustomScenario.fromJson(json);
  }

  /// Check if a scenario with the given name exists
  static Future<bool> scenarioExists(String scenarioName) async {
    final scenarios = await _getAllFromPreferences();
    return scenarios.any((s) => s.metadata.name == scenarioName);
  }

  /// Get unique name for a scenario (handles duplicates)
  static Future<String> getUniqueScenarioName(String baseName) async {
    final scenarios = await _getAllFromPreferences();
    final existingNames = scenarios.map((s) => s.metadata.name).toSet();

    String uniqueName = baseName;
    int counter = 1;

    while (existingNames.contains(uniqueName)) {
      uniqueName = '$baseName ($counter)';
      counter++;
    }

    return uniqueName;
  }

  // =============================================================================
  // PRIVATE METHODS - SharedPreferences Implementation
  // =============================================================================

  static Future<void> _saveToPreferences(CustomScenario scenario) async {
    final prefs = await SharedPreferences.getInstance();
    final existingScenarios = await _getAllFromPreferences();

    // Remove existing scenario with same name if it exists
    existingScenarios.removeWhere(
      (s) => s.metadata.name == scenario.metadata.name,
    );

    // Add the new scenario
    existingScenarios.add(scenario);

    // Save back to preferences
    final jsonList = existingScenarios.map((s) => s.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_scenariosKey, jsonString);

    debugPrint('Saved scenario: ${scenario.metadata.name}');
  }

  static Future<CustomScenario?> _loadFromPreferences(
    String scenarioName,
  ) async {
    final scenarios = await _getAllFromPreferences();
    try {
      return scenarios.firstWhere((s) => s.metadata.name == scenarioName);
    } catch (e) {
      return null;
    }
  }

  static Future<List<CustomScenario>> _getAllFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_scenariosKey);

    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => CustomScenario.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Failed to parse scenarios from preferences: $e');
      return [];
    }
  }

  static Future<void> _deleteFromPreferences(String scenarioName) async {
    final prefs = await SharedPreferences.getInstance();
    final existingScenarios = await _getAllFromPreferences();

    final originalLength = existingScenarios.length;
    existingScenarios.removeWhere((s) => s.metadata.name == scenarioName);

    if (existingScenarios.length < originalLength) {
      final jsonList = existingScenarios.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_scenariosKey, jsonString);

      debugPrint('Deleted scenario: $scenarioName');
    }
  }

  /// Clear all scenarios (for debugging/testing)
  static Future<void> clearAllScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scenariosKey);
    debugPrint('Cleared all scenarios');
  }
}
