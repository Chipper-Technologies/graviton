import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/haptic_feedback_service.dart';

import 'camera_state.dart';
import 'physics_state.dart';
import 'simulation_state.dart';
import 'ui_state.dart';

/// Manages application-wide state and coordinates other state managers
class AppState extends ChangeNotifier {
  final SimulationState simulation = SimulationState();
  final UIState ui = UIState();
  final CameraState camera = CameraState();
  final PhysicsState physics = PhysicsState();

  bool _isInitialized = false;
  String? _lastError;
  String? _lastLanguageCode;

  bool get isInitialized => _isInitialized;
  String? get lastError => _lastError;

  AppState() {
    // Initialize synchronously first, then load settings
    _initializeSync();
  }

  void _initializeSync() {
    // Listen to child state changes
    simulation.addListener(_onChildStateChanged);
    ui.addListener(_onUIStateChanged); // Use specific UI listener
    camera.addListener(_onChildStateChanged);
    physics.addListener(_onChildStateChanged);

    _isInitialized = true;
    notifyListeners();
  }

  /// Initialize UI settings from persistent storage
  Future<void> initializeAsync() async {
    await ui.initialize();
    await simulation.initialize();
    await physics.initialize();

    // Initialize realistic colors setting in simulation
    simulation.setUseRealisticColors(ui.useRealisticColors);

    // Initialize vibration setting in simulation
    simulation.setVibrationEnabled(ui.enableVibration);

    // Initialize haptic feedback service
    HapticFeedbackService.instance.initialize(ui);

    // Now that simulation is initialized with bodies, ensure gravity wells are properly set
    // if global gravity fields was enabled from saved settings
    if (ui.globalGravityFields) {
      _ensureAllBodiesHaveGravityWellsEnabled();
    }

    // Set optimal camera zoom for initial scenario
    camera.resetViewForScenario(simulation.currentScenario, simulation.bodies);
  }

  void _onChildStateChanged() {
    notifyListeners();
  }

  bool _languageChanged = false;

  void _onUIStateChanged() {
    // Handle language changes when UI state changes
    final currentLanguageCode = ui.selectedLanguageCode;
    if (_lastLanguageCode != currentLanguageCode) {
      _lastLanguageCode = currentLanguageCode;
      _languageChanged = true; // Flag for later handling
    }

    // Handle global gravity fields toggle
    // When global gravity fields is enabled, set all bodies to show gravity wells by default
    // so users can then individually toggle them off
    if (ui.globalGravityFields) {
      _ensureAllBodiesHaveGravityWellsEnabled();
    } else {
      // When global gravity fields is disabled, turn off all gravity wells
      _disableAllGravityWells();
    }

    // Propagate realistic colors setting to simulation
    simulation.setUseRealisticColors(ui.useRealisticColors);

    // Propagate vibration setting to simulation
    simulation.setVibrationEnabled(ui.enableVibration);

    notifyListeners();
  }

  /// When global gravity fields is enabled, ensure all bodies have showGravityWell = true
  /// so they can be individually toggled off by the user
  void _ensureAllBodiesHaveGravityWellsEnabled() {
    final bodies = simulation.bodies;
    bool anyChanged = false;
    for (final body in bodies) {
      if (!body.showGravityWell) {
        body.showGravityWell = true;
        anyChanged = true;
      }
    }
    // If we changed any bodies, mark simulation as changed and notify listeners
    if (anyChanged) {
      simulation.simulation.markChanged();
      notifyListeners();
    }
  }

  /// When global gravity fields is disabled, turn off all gravity wells
  void _disableAllGravityWells() {
    final bodies = simulation.bodies;
    bool anyChanged = false;
    for (final body in bodies) {
      if (body.showGravityWell) {
        body.showGravityWell = false;
        anyChanged = true;
      }
    }
    // If we changed any bodies, mark simulation as changed and notify listeners
    if (anyChanged) {
      simulation.simulation.markChanged();
      notifyListeners();
    }
  }

  /// Check if there's a pending language change and handle it
  bool checkForPendingLanguageChange() {
    if (_languageChanged) {
      _languageChanged = false;
      return true;
    }

    return false;
  }

  void setError(String error) {
    _lastError = error;
    notifyListeners();
  }

  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  void resetAll() {
    simulation.reset();

    // Apply performance optimizations based on current scenario and body count
    ui.applyPerformanceOptimizationsForScenario(
      simulation.simulation.currentScenario,
      simulation.bodies.length,
    );

    // Reset camera with optimal zoom for current scenario
    camera.resetViewForScenario(
      simulation.simulation.currentScenario,
      simulation.bodies,
    );
    clearError();
  }

  /// Switch to a scenario with appropriate physics settings
  void switchToScenarioWithPhysics(
    ScenarioType scenario, {
    AppLocalizations? l10n,
  }) {
    // Update physics state for the new scenario
    physics.switchToScenario(scenario);

    // Reset simulation with the new scenario
    simulation.resetWithScenario(scenario, l10n: l10n);

    // Apply the physics settings for this scenario
    simulation.applyPhysicsSettings(physics.currentSettings);

    // Apply performance optimizations based on scenario type and body count
    ui.applyPerformanceOptimizationsForScenario(
      scenario,
      simulation.bodies.length,
    );

    // Reset camera view
    camera.resetViewForScenario(scenario, simulation.bodies);
  }

  /// Initialize language tracking on first app load
  void initializeLanguageTracking(AppLocalizations l10n) {
    _lastLanguageCode = ui.selectedLanguageCode;
    // Regenerate scenario with correct localization on first load
    if (_isInitialized &&
        simulation.currentScenario != ScenarioType.galaxyFormation) {
      simulation.regenerateScenarioWithLocalization(l10n);
      camera.resetViewForScenario(
        simulation.currentScenario,
        simulation.bodies,
      );
    }
  }

  /// Handle language change with proper localization context
  void handleLanguageChangeWithContext(AppLocalizations l10n) {
    simulation.regenerateScenarioWithLocalization(l10n);
    camera.resetViewForScenario(simulation.currentScenario, simulation.bodies);
  }

  @override
  void dispose() {
    simulation.removeListener(_onChildStateChanged);
    ui.removeListener(_onChildStateChanged);
    camera.removeListener(_onChildStateChanged);
    physics.removeListener(_onChildStateChanged);
    simulation.dispose();
    ui.dispose();
    camera.dispose();
    super.dispose();
  }
}
