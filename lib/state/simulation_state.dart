import 'package:flutter/material.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/firebase_event.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/simulation_status.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:graviton/models/trail_point.dart';
import 'package:graviton/services/accessibility_service.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/services/simulation.dart' as physics;
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the simulation state and physics
class SimulationState extends ChangeNotifier {
  final physics.Simulation _simulation = physics.Simulation();

  SimulationStatus _status = SimulationStatus.stopped;
  double _timeScale = 4.0;
  int _stepCount = 0;

  // Store localization context for accessibility announcements
  AppLocalizations? _l10n;
  double _totalTime = 0.0;

  // SharedPreferences keys
  static const String _keyTimeScale = 'timeScale';
  static const String _keyScenario = 'scenario';

  /// Update localization context for accessibility announcements
  void updateLocalization(AppLocalizations l10n) {
    _l10n = l10n;
    // Also update simulation service localization
    _simulation.updateScenarioLocalization(l10n);
  }

  /// Initialize and load saved settings
  Future<void> initialize() async {
    // First, explicitly set the simulation to random scenario as the default
    _simulation.resetWithScenario(ScenarioType.random, l10n: _l10n);

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
      _timeScale = prefs.getDouble(_keyTimeScale) ?? 4.0;

      // Load saved scenario preference
      final savedScenarioName = prefs.getString(_keyScenario);

      if (savedScenarioName != null) {
        try {
          final savedScenario = ScenarioType.values.firstWhere(
            (s) => s.name == savedScenarioName,
          );
          _simulation.resetWithScenario(savedScenario, l10n: _l10n);
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
      _simulation.resetWithScenario(ScenarioType.random, l10n: _l10n);
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
  SimulationStatus get status => _status;
  bool get isRunning => _status.isAdvancing;
  bool get isPaused => _status == SimulationStatus.paused;
  double get timeScale => _timeScale;
  int get stepCount => _stepCount;
  double get totalTime => _totalTime;

  /// Set AppState reference for collision effects UI settings
  void setAppState(dynamic appState) {
    _simulation.appState = appState;
  }

  /// Convert simulation time to Earth years
  double get totalTimeInEarthYears =>
      _totalTime * SimulationConstants.simulationTimeToEarthYears;

  List<Body> get bodies => _simulation.bodies;
  List<List<TrailPoint>> get trails => _simulation.trails;
  List<MergeFlash> get mergeFlashes => _simulation.mergeFlashes;

  // Physics settings getters
  bool get enableRelativisticEffects => _simulation.enableRelativisticEffects;
  bool get showRelativisticGlow => _simulation.showRelativisticGlow;
  bool get enableTidalForces => _simulation.enableTidalForces;
  bool get showTidalVisualization => _simulation.showTidalVisualization;

  // Physics control
  void start() {
    if (_status.canStart) {
      _status = SimulationStatus.running;

      // Provide haptic feedback for simulation start
      HapticFeedbackService.instance.lightImpact();

      // Announce state change to screen readers
      if (_l10n != null) {
        AccessibilityService.instance.announceSimulationStateChange(
          'started',
          l10n: _l10n!,
        );
      }

      // Enhanced analytics for simulation start with context
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.simulationStarted,
        element: UIElement.simulationPlaybackControls,
        additionalParams: {
          'scenario': _simulation.currentScenario.name,
          'body_count': _simulation.bodies.length.toString(),
          'time_scale': _timeScale.toString(),
          'previous_status': _status == SimulationStatus.stopped
              ? 'stopped'
              : 'error',
        },
      );

      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.simulationStarted,
      );
      notifyListeners();
    }
  }

  void pause() {
    if (_status.canPause) {
      _status = SimulationStatus.paused;

      // Provide haptic feedback for simulation pause
      HapticFeedbackService.instance.selectionClick();

      // Announce state change to screen readers
      if (_l10n != null) {
        AccessibilityService.instance.announceSimulationStateChange(
          'paused',
          l10n: _l10n!,
        );
      }

      // Enhanced analytics for simulation pause
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.simulationPaused,
        element: UIElement.simulationPlaybackControls,
        additionalParams: {
          'scenario': _simulation.currentScenario.name,
          'body_count': _simulation.bodies.length.toString(),
          'time_scale': _timeScale.toString(),
          'step_count': _stepCount.toString(),
          'total_time_seconds': _totalTime.toStringAsFixed(1),
        },
      );

      FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationPaused);
    } else if (_status.canResume) {
      _status = SimulationStatus.running;

      // Provide haptic feedback for simulation resume
      HapticFeedbackService.instance.lightImpact();

      // Announce state change to screen readers
      if (_l10n != null) {
        AccessibilityService.instance.announceSimulationStateChange(
          'resumed',
          l10n: _l10n!,
        );
      }

      // Enhanced analytics for simulation resume
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.simulationResumed,
        element: UIElement.simulationPlaybackControls,
        additionalParams: {
          'scenario': _simulation.currentScenario.name,
          'body_count': _simulation.bodies.length.toString(),
          'time_scale': _timeScale.toString(),
          'step_count': _stepCount.toString(),
          'pause_duration_estimate':
              'unknown', // Could track this with timestamps
        },
      );

      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.simulationResumed,
      );
    }
    notifyListeners();
  }

  /// Pause the simulation if it's currently running
  void pauseSimulation() {
    if (_status.canPause) {
      _status = SimulationStatus.paused;

      // Provide haptic feedback for explicit pause
      HapticFeedbackService.instance.selectionClick();

      FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationPaused);
      notifyListeners();
    }
  }

  /// Resume the simulation if it's currently paused
  void resumeSimulation() {
    if (_status.canResume) {
      _status = SimulationStatus.running;

      // Provide haptic feedback for explicit resume
      HapticFeedbackService.instance.lightImpact();

      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.simulationResumed,
      );
      notifyListeners();
    }
  }

  void stop() {
    _status = SimulationStatus.stopped;

    // Provide haptic feedback for simulation stop
    HapticFeedbackService.instance.mediumImpact();

    // Enhanced analytics for simulation stop
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.simulationStopped,
      element: UIElement.simulationPlaybackControls,
      additionalParams: {
        'scenario': _simulation.currentScenario.name,
        'body_count': _simulation.bodies.length.toString(),
        'time_scale': _timeScale.toString(),
        'step_count': _stepCount.toString(),
        'total_time_seconds': _totalTime.toStringAsFixed(1),
        'session_duration_steps': _stepCount.toString(),
      },
    );

    FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationStopped);
    notifyListeners();
  }

  void reset() {
    final previousStepCount = _stepCount;
    final previousTotalTime = _totalTime;

    stop();

    // Reset physics simulation to current scenario, preserving custom gravity well settings
    _simulation.resetWithScenario(
      _simulation.currentScenario,
      l10n: _l10n,
      preserveCustomSettings: true,
    );
    _stepCount = 0;
    _totalTime = 0.0;

    // Provide haptic feedback for simulation reset
    HapticFeedbackService.instance.heavyImpact();

    // Enhanced analytics for simulation reset
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.simulationReset,
      element: UIElement.simulationLifecycleControls,
      additionalParams: {
        'scenario': _simulation.currentScenario.name,
        'body_count': _simulation.bodies.length.toString(),
        'time_scale': _timeScale.toString(),
        'previous_step_count': previousStepCount.toString(),
        'previous_total_time': previousTotalTime.toStringAsFixed(1),
        'reset_trigger':
            'manual', // Could be 'manual', 'automatic', 'scenario_change'
      },
    );

    FirebaseService.instance.logEventWithEnum(FirebaseEvent.simulationReset);
    notifyListeners();

    // Start immediately after
    start();
  }

  /// Reset simulation with a specific scenario and save the preference
  void resetWithScenario(
    ScenarioType scenario, {
    AppLocalizations? l10n,
    bool preserveCustomSettings = false,
  }) {
    stop();

    // Provide haptic feedback for scenario switching
    HapticFeedbackService.instance.mediumImpact();

    // Announce scenario change to screen readers
    if (_l10n != null) {
      AccessibilityService.instance.announceScenarioChange(
        scenario.name,
        l10n: _l10n!,
      );
    }

    // Reset physics simulation to the specified scenario
    _simulation.resetWithScenario(
      scenario,
      l10n: l10n ?? _l10n,
      preserveCustomSettings: preserveCustomSettings,
    );
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

    // For galaxy formation, avoid regeneration to preserve custom body properties
    if (currentScenario == ScenarioType.galaxyFormation) {
      // Skip regeneration - galaxy formation should preserve custom settings
      return;
    }

    resetWithScenario(
      currentScenario,
      l10n: l10n,
      preserveCustomSettings: true,
    );
  }

  void setTimeScale(double scale) {
    final oldScale = _timeScale;
    _timeScale = scale.clamp(0.1, 16.0);

    // Provide haptic feedback for significant speed changes
    final scaleChange = (_timeScale - oldScale).abs();
    if (scaleChange > 1.0) {
      // Major speed change
      HapticFeedbackService.instance.mediumImpact();
    } else if (scaleChange > 0.5) {
      // Moderate speed change
      HapticFeedbackService.instance.lightImpact();
    }

    // Special feedback for reaching extremes
    if (_timeScale >= 16.0 || _timeScale <= 0.1) {
      HapticFeedbackService.instance.heavyImpact();
    }

    // Enhanced analytics for time scale changes with performance context
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.simulationSpeedChanged,
      element: UIElement.timeScaleControls,
      value: _timeScale.toString(),
      additionalParams: {
        'previous_scale': oldScale.toString(),
        'new_scale': _timeScale.toString(),
        'scale_change': scaleChange.toString(),
        'body_count': _simulation.bodies.length.toString(),
        'simulation_status': _status.name,
        'at_extreme': (_timeScale >= 16.0 || _timeScale <= 0.1).toString(),
        'step_count': _stepCount.toString(),
        'scale_direction': _timeScale > oldScale ? 'increase' : 'decrease',
      },
    );

    // Keep the existing performance analytics as well
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.timeScaleAdjusted,
      element: UIElement.performanceMonitor,
      value: _timeScale.toString(),
      additionalParams: {
        'previous_scale': oldScale.toString(),
        'new_scale': _timeScale.toString(),
        'scale_change': scaleChange.toString(),
        'body_count': _simulation.bodies.length.toString(),
        'simulation_status': _status.name,
        'at_extreme': (_timeScale >= 16.0 || _timeScale <= 0.1).toString(),
        'step_count': _stepCount.toString(),
      },
    );

    _saveSetting(_keyTimeScale, _timeScale);
    FirebaseService.instance.logSettingsChange('time_scale', _timeScale);
    notifyListeners();
  }

  /// Update realistic colors setting in the simulation
  void setUseRealisticColors(bool useRealisticColors) {
    _simulation.setUseRealisticColors(useRealisticColors);
  }

  /// Update vibration setting in the simulation
  void setVibrationEnabled(bool enabled) {
    _simulation.setVibrationEnabled(enabled);
  }

  /// Toggle relativistic effects
  void toggleRelativisticEffects() {
    _simulation.updatePhysicsSettings(
      enableRelativisticEffects: !_simulation.enableRelativisticEffects,
    );
    notifyListeners();
  }

  /// Toggle relativistic glow visualization
  void toggleRelativisticGlow() {
    _simulation.updatePhysicsSettings(
      showRelativisticGlow: !_simulation.showRelativisticGlow,
    );
    notifyListeners();
  }

  /// Toggle tidal forces
  void toggleTidalForces() {
    _simulation.updatePhysicsSettings(
      enableTidalForces: !_simulation.enableTidalForces,
    );
    notifyListeners();
  }

  /// Toggle tidal visualization
  void toggleTidalVisualization() {
    _simulation.updatePhysicsSettings(
      showTidalVisualization: !_simulation.showTidalVisualization,
    );
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
    if (_status.isAdvancing) {
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
