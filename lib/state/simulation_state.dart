import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/firebase_event.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the simulation state and physics
class SimulationState extends ChangeNotifier {
  final physics.Simulation _simulation = physics.Simulation();

  bool _isRunning = false;
  bool _isPaused = false;
  double _timeScale = 8.0;
  int _stepCount = 0;
  double _totalTime = 0.0;

  // SharedPreferences keys
  static const String _keyTimeScale = 'timeScale';
  static const String _keyScenario = 'scenario';

  /// Initialize and load saved settings
  Future<void> initialize() async {
    // First, explicitly set the simulation to random scenario as the default
    _simulation.resetWithScenario(ScenarioType.random);

    // Then load settings, which may override the scenario if one was saved
    await _loadSettings();

    notifyListeners();
  }

  /// Get the current scenario for camera optimization
  ScenarioType get currentScenario => _simulation.currentScenario;

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _timeScale = prefs.getDouble(_keyTimeScale) ?? 8.0;

      // Load saved scenario preference
      final savedScenarioName = prefs.getString(_keyScenario);

      if (savedScenarioName != null) {
        try {
          final savedScenario = ScenarioType.values.firstWhere(
            (s) => s.name == savedScenarioName,
          );
          _simulation.resetWithScenario(savedScenario);
        } catch (e) {
          // If saved scenario is invalid, keep the default (random)
        }
      }

      notifyListeners();
    } catch (e) {
      // If SharedPreferences fails (e.g., in tests), use default values
    }
  }

  /// Save a specific setting to SharedPreferences
  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      // Ignore errors (e.g., in tests where binding isn't initialized)
    }
  }

  /// Save the current scenario to preferences
  Future<void> _saveScenario() async {
    await _saveSetting(_keyScenario, _simulation.currentScenario.name);
  }

  /// Clear saved scenario preference and is is om (for debugging)
  Future<void> clearSavedScenario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyScenario);
      // Reset to default scenario
      _simulation.resetWithScenario(ScenarioType.random);
      notifyListeners();
    } catch (e) {
      // Ignore errors
    }
  }

  /// Check what scenario is saved (for debugging)
  Future<String?> getSavedScenario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_keyScenario);
      return saved;
    } catch (e) {
      return null;
    }
  }

  // Getters
  physics.Simulation get simulation => _simulation;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  double get timeScale => _timeScale;
  int get stepCount => _stepCount;
  double get totalTime => _totalTime;

  /// Convert simulation time to Earth years
  double get totalTimeInEarthYears =>
      _totalTime * SimulationConstants.simulationTimeToEarthYears;

  List<Body> get bodies => _simulation.bodies;
  List<List<TrailPoint>> get trails => _simulation.trails;
  List<MergeFlash> get mergeFlashes => _simulation.mergeFlashes;

  // Physics control
  void start() {
    _isRunning = true;
    FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationStarted);
    notifyListeners();
  }

  void pause() {
    _isPaused = !_isPaused;
    FirebaseService.instance.logEventWithEnum(
      _isPaused
          ? FirebaseEvent.simulationPaused
          : FirebaseEvent.simulationResumed,
    );
    notifyListeners();
  }

  void stop() {
    _isRunning = false;
    _isPaused = false;
    FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationStopped);
    notifyListeners();
  }

  void reset() {
    stop();

    // Reset physics simulation to current scenario
    _simulation.reset(); // This will use the current scenario
    _stepCount = 0;
    _totalTime = 0.0;

    FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationReset);
    notifyListeners();

    // Start immediately after
    start();
  }

  /// Reset simulation with a specific scenario and save the preference
  void resetWithScenario(ScenarioType scenario, {AppLocalizations? l10n}) {
    stop();

    // Reset physics simulation to the specified scenario
    _simulation.resetWithScenario(scenario, l10n: l10n);
    _stepCount = 0;
    _totalTime = 0.0;

    // Save the scenario preference
    _saveScenario();

    FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationReset);
    notifyListeners();

    // Start immediately after
    start();
  }

  /// Regenerate the current scenario with new localization
  void regenerateScenarioWithLocalization(AppLocalizations l10n) {
    final currentScenario = _simulation.currentScenario;
    resetWithScenario(currentScenario, l10n: l10n);
  }

  void setTimeScale(double scale) {
    _timeScale = scale.clamp(0.1, 16.0);
    _saveSetting(_keyTimeScale, _timeScale);
    FirebaseService.instance.logSettingsChange('time_scale', _timeScale);
    notifyListeners();
  }

  /// Apply physics settings to the simulation
  void applyPhysicsSettings(PhysicsSettings settings) {
    _simulation.updatePhysicsSettings(
      gravitationalConstant: settings.gravitationalConstant,
      softening: settings.softening,
      collisionRadiusMultiplier: settings.collisionRadiusMultiplier,
      maxTrailPoints: settings.maxTrailPoints,
      trailFadeRate: settings.trailFadeRate,
      vibrationThrottleTime: settings.vibrationThrottleTime,
      vibrationEnabled: settings.vibrationEnabled,
    );
  }

  void step(double deltaTime) {
    if (_isRunning && !_isPaused) {
      const baseDt = 1 / 240.0;
      int steps = (_timeScale * 4).clamp(1, 48).toInt();
      for (int i = 0; i < steps; i++) {
        _simulation.stepRK4(baseDt);
        _stepCount++;
        _totalTime += baseDt;
      }

      // Update habitability calculations (throttled for performance)
      _simulation.updateHabitability(deltaTime);

      notifyListeners();
    }
  }

  /// Notify that body properties have been updated externally
  void notifyBodyPropertiesChanged() {
    notifyListeners();
  }
}
