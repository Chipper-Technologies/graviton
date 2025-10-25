import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages physics settings per scenario with persistence
class PhysicsState extends ChangeNotifier {
  static const String _keyPhysicsSettings = 'physics_settings_per_scenario';

  // Per-scenario physics settings storage
  final Map<ScenarioType, PhysicsSettings> _scenarioSettings = {};

  // Current active physics settings
  PhysicsSettings _currentSettings = PhysicsSettings.defaults();
  ScenarioType _currentScenario = ScenarioType.random;

  PhysicsSettings get currentSettings => _currentSettings;
  ScenarioType get currentScenario => _currentScenario;

  /// Initialize physics state from persistent storage
  Future<void> initialize() async {
    await _loadSettings();
  }

  /// Load per-scenario settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_keyPhysicsSettings);

      if (settingsJson != null) {
        final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);

        // Load each scenario's settings
        for (final entry in settingsMap.entries) {
          final scenarioType = _parseScenarioType(entry.key);
          if (scenarioType != null) {
            _scenarioSettings[scenarioType] = PhysicsSettings.fromMap(
              entry.value,
            );
          }
        }
      }
    } catch (e) {
      // If loading fails, we'll use defaults
      debugPrint('Failed to load physics settings: $e');
    }
  }

  /// Save per-scenario settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert scenario settings to serializable format
      final Map<String, dynamic> settingsMap = {};
      for (final entry in _scenarioSettings.entries) {
        settingsMap[entry.key.name] = entry.value.toMap();
      }

      await prefs.setString(_keyPhysicsSettings, jsonEncode(settingsMap));
    } catch (e) {
      debugPrint('Failed to save physics settings: $e');
    }
  }

  /// Switch to a different scenario and load appropriate physics settings
  void switchToScenario(ScenarioType scenario) {
    _currentScenario = scenario;

    // Load saved settings for this scenario, or use defaults
    _currentSettings =
        _scenarioSettings[scenario] ?? PhysicsSettings.forScenario(scenario);

    notifyListeners();
  }

  /// Update physics settings for the current scenario
  void updateCurrentSettings(PhysicsSettings newSettings) {
    _currentSettings = newSettings;
    _scenarioSettings[_currentScenario] = newSettings;

    // Save to persistent storage
    _saveSettings();

    notifyListeners();
  }

  /// Update individual physics parameter for current scenario
  void updateParameter({
    double? gravitationalConstant,
    double? softening,
    double? collisionRadiusMultiplier,
    int? maxTrailPoints,
    double? trailFadeRate,
    double? vibrationThrottleTime,
    bool? vibrationEnabled,
  }) {
    final updatedSettings = _currentSettings.copyWith(
      gravitationalConstant: gravitationalConstant,
      softening: softening,
      collisionRadiusMultiplier: collisionRadiusMultiplier,
      maxTrailPoints: maxTrailPoints,
      trailFadeRate: trailFadeRate,
      vibrationThrottleTime: vibrationThrottleTime,
      vibrationEnabled: vibrationEnabled,
    );

    updateCurrentSettings(updatedSettings);
  }

  /// Reset current scenario to default physics settings
  void resetCurrentToDefaults() {
    final defaultSettings = PhysicsSettings.forScenario(_currentScenario);
    updateCurrentSettings(defaultSettings);
  }

  /// Reset all scenarios to their default settings
  void resetAllToDefaults() {
    _scenarioSettings.clear();
    _currentSettings = PhysicsSettings.forScenario(_currentScenario);
    _saveSettings();
    notifyListeners();
  }

  /// Check if current settings differ from scenario defaults
  bool get hasCustomSettings {
    return _currentSettings.isDifferentFromDefaults(_currentScenario);
  }

  /// Get settings for a specific scenario (for debugging/inspection)
  PhysicsSettings getSettingsForScenario(ScenarioType scenario) {
    return _scenarioSettings[scenario] ?? PhysicsSettings.forScenario(scenario);
  }

  /// Parse scenario type from string (for deserialization)
  ScenarioType? _parseScenarioType(String scenarioName) {
    try {
      return ScenarioType.values.firstWhere((e) => e.name == scenarioName);
    } catch (e) {
      return null;
    }
  }

  /// Get a summary of all scenario customizations (for debugging)
  Map<ScenarioType, bool> getCustomizationSummary() {
    final summary = <ScenarioType, bool>{};
    for (final scenario in ScenarioType.values) {
      final settings = getSettingsForScenario(scenario);
      summary[scenario] = settings.isDifferentFromDefaults(scenario);
    }
    return summary;
  }
}
