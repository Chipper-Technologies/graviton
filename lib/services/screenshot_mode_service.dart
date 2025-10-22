import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/screenshot_models.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for managing screenshot mode functionality
class ScreenshotModeService extends ChangeNotifier {
  static final ScreenshotModeService _instance = ScreenshotModeService._internal();
  factory ScreenshotModeService() => _instance;
  ScreenshotModeService._internal();

  bool _isScreenshotModeEnabled = false;
  int _currentPresetIndex = 0;
  bool _isActive = false;
  int _countdownSeconds = 0;
  bool _showCountdown = false;
  Timer? _countdownTimer;
  Completer<void>? _pendingApplyOperation;

  // Store original UI state for restoration
  Map<String, bool>? _originalUIState;

  /// Whether screenshot mode is available (dev mode only)
  bool get isAvailable => FlavorConfig.instance.isDevelopment;

  /// Whether screenshot mode is currently enabled
  bool get isEnabled => _isScreenshotModeEnabled && isAvailable;

  /// Whether a preset scene is currently active
  bool get isActive => _isActive;

  /// Whether to show countdown timer
  bool get showCountdown => _showCountdown;

  /// Current countdown seconds remaining
  int get countdownSeconds => _countdownSeconds;

  /// Current preset index
  int get currentPresetIndex => _currentPresetIndex;

  /// Number of available presets
  int get presetCount => ScreenshotPresets.getPresetCount();

  /// Current preset (requires localization context)
  ScreenshotPreset? getCurrentPreset(AppLocalizations l10n) => ScreenshotPresets.getPreset(_currentPresetIndex, l10n);

  /// All available presets (requires localization context)
  List<ScreenshotPreset> getPresets(AppLocalizations l10n) => ScreenshotPresets.getPresets(l10n);

  /// Simple test preset for unit testing when l10n is not available
  ScreenshotPreset? _getTestPreset() {
    if (_currentPresetIndex < 0 || _currentPresetIndex >= presetCount) return null;

    // Import the required classes for the test preset
    return ScreenshotPreset(
      name: 'Test Preset',
      description: 'Test preset for unit testing',
      scenarioType: ScenarioType.galaxyFormation,
      configuration: {'bodyCount': 100, 'centralMass': 10000.0, 'diskRadius': 1000.0, 'timeStep': 0.1},
      camera: const CameraPosition(distance: 300.0, yaw: 0.0, pitch: 0.0, roll: 0.0),
      cameraDistance: 12.8,
      cameraYaw: 0.0,
      cameraPitch: 0.0,
      cameraAutoRotate: false,
      showTrails: true,
      trailType: 'warm',
      showLabels: false,
      showOffScreenIndicators: false,
      timerSeconds: 0,
    );
  }

  /// Toggle screenshot mode on/off
  void toggleScreenshotMode() {
    _isScreenshotModeEnabled = !_isScreenshotModeEnabled;
    if (!_isScreenshotModeEnabled) {
      _isActive = false;
      _cancelPendingOperations();
    }
    notifyListeners();
  }

  /// Enable screenshot mode
  void enableScreenshotMode() {
    _isScreenshotModeEnabled = true;
    notifyListeners();
  }

  /// Disable screenshot mode
  void disableScreenshotMode() {
    _isScreenshotModeEnabled = false;
    _isActive = false;
    _cancelPendingOperations();
    notifyListeners();
  }

  /// Cancel any pending apply operations
  void _cancelPendingOperations() {
    if (_pendingApplyOperation != null && !_pendingApplyOperation!.isCompleted) {
      _pendingApplyOperation!.complete();
    }
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  /// Set the current preset by index
  void setPreset(int index) {
    if (index >= 0 && index < presetCount) {
      _currentPresetIndex = index;
      notifyListeners();
    }
  }

  /// Apply the current preset to the simulation
  Future<void> applyCurrentPreset({
    required SimulationState simulationState,
    required CameraState cameraState,
    required dynamic uiState, // UIState but avoiding import cycle
    AppLocalizations? l10n, // Optional for testing
  }) async {
    final preset = l10n != null ? getCurrentPreset(l10n) : _getTestPreset(); // Use test preset when l10n is null
    if (preset == null || !isEnabled) return;

    try {
      // Cancel any existing countdown timer when applying new preset
      _countdownTimer?.cancel();
      _countdownTimer = null;

      // Cancel any pending apply operation
      if (_pendingApplyOperation != null && !_pendingApplyOperation!.isCompleted) {
        _pendingApplyOperation!.complete();
      }
      _pendingApplyOperation = Completer<void>();

      // Store original UI state ONLY if this is the first preset activation
      // (don't overwrite if we're switching between presets)
      if (!_isActive) {
        _storeOriginalUIState(uiState);
      } else {
        // If switching between presets, restore to original state first
        _restoreOriginalUIState(uiState);
        // Add a small delay to ensure restoration takes effect
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // Set active state
      _isActive = true;

      // Reset previous state before applying new preset
      _resetCameraState(cameraState);

      // Apply scenario configuration based on preset
      _applyScenarioConfiguration(preset, simulationState);

      // Wait a frame to ensure simulation is fully set up before applying camera
      final currentOperation = _pendingApplyOperation;
      Future.microtask(() async {
        // Check if operation was cancelled
        if (currentOperation != null && currentOperation.isCompleted) return;

        await Future.delayed(const Duration(milliseconds: 100));

        // Check again if operation was cancelled
        if (currentOperation != null && currentOperation.isCompleted) return;

        // Wait an additional moment for camera reset to take effect
        await Future.delayed(const Duration(milliseconds: 50));

        // Check one more time if operation was cancelled
        if (currentOperation != null && currentOperation.isCompleted) return;

        // Apply camera position after simulation and reset are ready
        _applyCameraPosition(preset, cameraState);

        // Apply trail settings from preset
        _applyTrailSettings(preset, uiState);

        // Apply label settings based on preset configuration
        _applyLabelSettings(uiState, preset);

        // Apply additional visual settings
        _applyVisualSettings(uiState, preset);

        // Apply body focus settings
        _applyBodyFocus(preset, simulationState, cameraState);

        // Start scene normally and pause after delay
        if (preset.showTrails) {
          _startSceneAndPauseAfterDelay(simulationState, preset);
        } else {
          // Just start the simulation and pause after delay
          simulationState.start();

          // Handle timer setting
          if (preset.timerSeconds <= 0) {
            // Immediate pause for timerSeconds 0 or negative
            _countdownSeconds = 0;
            _showCountdown = false;
            if (!simulationState.isPaused) {
              simulationState.pause();
            }
            notifyListeners();
          } else {
            // Start countdown using preset's timer setting
            _countdownSeconds = preset.timerSeconds;
            _showCountdown = true;
            notifyListeners();

            // Update countdown every second
            _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              _countdownSeconds--;
              notifyListeners();

              if (_countdownSeconds <= 0) {
                timer.cancel();
                _countdownTimer = null;
                _showCountdown = false;
                if (!simulationState.isPaused) {
                  simulationState.pause();
                }
                notifyListeners();
              }
            });
          }
        }

        notifyListeners();

        // Mark operation as complete
        if (currentOperation != null && !currentOperation.isCompleted) {
          currentOperation.complete();
        }
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error applying screenshot preset: $e');
    }
  }

  /// Apply scenario configuration
  void _applyScenarioConfiguration(ScreenshotPreset preset, SimulationState simulationState) {
    ScenarioType scenarioType = preset.scenarioType;

    // Reset simulation with the appropriate scenario
    simulationState.resetWithScenario(scenarioType);
  }

  /// Apply camera position and enhanced camera settings
  void _applyCameraPosition(ScreenshotPreset preset, CameraState cameraState) {
    final camera = preset.camera;

    // Apply distance/zoom - use cameraDistance if specified, otherwise use camera.distance
    final targetDistance = preset.cameraDistance ?? camera.distance;
    // Use multiple small zoom steps to reach target distance more accurately
    final currentDistance = cameraState.distance;
    if ((targetDistance - currentDistance).abs() > 0.1) {
      final zoomFactor = (targetDistance / currentDistance) - 1.0;
      cameraState.zoom(zoomFactor);
    }

    // Apply rotations more directly by calculating total needed rotation
    final targetYaw = preset.cameraYaw ?? camera.yaw;
    final targetPitch = preset.cameraPitch ?? camera.pitch;
    final targetRoll = camera.roll;

    // Calculate deltas from current position
    final deltaYaw = targetYaw - cameraState.yaw;
    final deltaPitch = targetPitch - cameraState.pitch;
    final deltaRoll = targetRoll - cameraState.roll;

    // Apply rotations if significant differences exist
    if (deltaYaw.abs() > 0.01 || deltaPitch.abs() > 0.01) {
      cameraState.rotate(deltaYaw, deltaPitch);
    }

    if (deltaRoll.abs() > 0.01) {
      cameraState.rotateRoll(deltaRoll);
    }

    // Apply auto-rotate setting
    if (preset.cameraAutoRotate != null) {
      if (preset.cameraAutoRotate! != cameraState.autoRotate) {
        cameraState.toggleAutoRotate();
      }
    }

    // Set camera target if specified
    if (camera.targetX != 0.0 || camera.targetY != 0.0 || camera.targetZ != 0.0) {
      final target = vm.Vector3(camera.targetX, camera.targetY, camera.targetZ);
      cameraState.setTarget(target);
    }
  }

  /// Apply trail settings from preset
  void _applyTrailSettings(ScreenshotPreset preset, dynamic uiState) {
    // Enable trails if specified in preset
    if (preset.showTrails && !uiState.showTrails) {
      uiState.toggleTrails();
    } else if (!preset.showTrails && uiState.showTrails) {
      uiState.toggleTrails();
    }

    // Set trail color based on preset
    final wantWarmTrails = preset.trailType == 'warm';
    if (wantWarmTrails != uiState.useWarmTrails) {
      uiState.toggleWarmTrails();
    }
  }

  /// Apply label settings based on preset configuration
  void _applyLabelSettings(dynamic uiState, ScreenshotPreset preset) {
    // Apply label visibility based on preset configuration
    if (preset.showLabels && !uiState.showLabels) {
      // Show labels if preset wants them and they're currently hidden
      uiState.toggleLabels();
    } else if (!preset.showLabels && uiState.showLabels) {
      // Hide labels if preset doesn't want them and they're currently shown
      uiState.toggleLabels();
    }
  }

  /// Apply additional visual settings based on preset configuration
  void _applyVisualSettings(dynamic uiState, ScreenshotPreset preset) {
    // Apply orbital paths setting - if not specified, default to true
    final wantOrbitalPaths = preset.showOrbitalPaths ?? true;
    if (wantOrbitalPaths && !uiState.showOrbitalPaths) {
      uiState.toggleOrbitalPaths();
    } else if (!wantOrbitalPaths && uiState.showOrbitalPaths) {
      uiState.toggleOrbitalPaths();
    }

    // Apply habitable zones setting - if not specified, default to false
    final wantHabitableZones = preset.showHabitableZones ?? false;
    debugPrint(
      'Screenshot: Preset ${preset.name} wants showHabitableZones: $wantHabitableZones, current: ${uiState.showHabitableZones}',
    );

    if (wantHabitableZones && !uiState.showHabitableZones) {
      debugPrint('Screenshot: Enabling habitable zones for preset');
      uiState.toggleHabitableZones();
    } else if (!wantHabitableZones && uiState.showHabitableZones) {
      debugPrint('Screenshot: Disabling habitable zones for preset');
      uiState.toggleHabitableZones();
    }

    // Apply gravity wells setting - if not specified, default to false
    final wantGravityWells = preset.showGravityWells ?? false;
    if (wantGravityWells && !uiState.showGravityWells) {
      uiState.toggleGravityWells();
    } else if (!wantGravityWells && uiState.showGravityWells) {
      uiState.toggleGravityWells();
    }

    // Apply off-screen indicators setting
    if (preset.showOffScreenIndicators != null) {
      if (preset.showOffScreenIndicators! && !uiState.showOffScreenIndicators) {
        uiState.toggleOffScreenIndicators();
      } else if (!preset.showOffScreenIndicators! && uiState.showOffScreenIndicators) {
        uiState.toggleOffScreenIndicators();
      }
    }
  }

  /// Apply body focus settings based on preset configuration
  void _applyBodyFocus(ScreenshotPreset preset, SimulationState simulationState, CameraState cameraState) {
    // Clear any existing selection first
    cameraState.selectBody(null);

    // Disable follow mode if it's currently active (will re-enable if needed)
    if (cameraState.followMode) {
      cameraState.toggleFollowMode(simulationState.bodies);
    }

    int? targetBodyIndex;

    // Find target body by index
    if (preset.focusBodyIndex != null) {
      if (preset.focusBodyIndex! >= 0 && preset.focusBodyIndex! < simulationState.bodies.length) {
        targetBodyIndex = preset.focusBodyIndex;
      }
    }

    // Find target body by name (if index not specified or invalid)
    if (targetBodyIndex == null && preset.focusBodyName != null) {
      final bodies = simulationState.bodies;
      for (int i = 0; i < bodies.length; i++) {
        if (bodies[i].name.toLowerCase().contains(preset.focusBodyName!.toLowerCase())) {
          targetBodyIndex = i;
          break;
        }
      }
    }

    // Apply body selection
    if (targetBodyIndex != null) {
      cameraState.selectBody(targetBodyIndex);

      // Enable follow mode if requested
      if (preset.enableFollowMode == true) {
        // Check if follow mode is not already enabled
        if (!cameraState.followMode) {
          cameraState.toggleFollowMode(simulationState.bodies);
        }

        // Override follow distance with preset camera distance
        final targetDistance = preset.cameraDistance ?? preset.camera.distance;
        if (targetDistance != cameraState.distance) {
          final zoomFactor = (targetDistance / cameraState.distance) - 1.0;
          cameraState.zoom(zoomFactor);
        }
      }
    }
  }

  /// Start scene normally and pause after specified seconds for screenshot
  void _startSceneAndPauseAfterDelay(SimulationState simulationState, ScreenshotPreset preset) {
    // Start the simulation normally
    simulationState.start();

    // Handle timer setting
    if (preset.timerSeconds <= 0) {
      // Immediate pause for timerSeconds 0 or negative
      _countdownSeconds = 0;
      _showCountdown = false;
      if (!simulationState.isPaused) {
        simulationState.pause(); // This toggles pause state just like the app bar button
      }
      notifyListeners();
    } else {
      // Start countdown using preset's timer setting
      _countdownSeconds = preset.timerSeconds;
      _showCountdown = true;
      notifyListeners();

      // Update countdown every second
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _countdownSeconds--;
        notifyListeners();

        if (_countdownSeconds <= 0) {
          timer.cancel();
          _countdownTimer = null;
          _showCountdown = false;
          if (!simulationState.isPaused) {
            simulationState.pause(); // This toggles pause state just like the app bar button
          }
          notifyListeners();
        }
      });
    }
  }

  /// Get the next preset (for easy cycling)
  void nextPreset() {
    final nextIndex = (_currentPresetIndex + 1) % presetCount;
    setPreset(nextIndex);
  }

  /// Get the previous preset (for easy cycling)
  void previousPreset() {
    final prevIndex = _currentPresetIndex == 0 ? presetCount - 1 : _currentPresetIndex - 1;
    setPreset(prevIndex);
  }

  /// Deactivate screenshot mode (return to normal simulation)
  void deactivate({dynamic uiState, dynamic simulationState}) {
    // Cancel any pending operations first
    _cancelPendingOperations();

    // Restore original UI state if we have a uiState reference
    if (uiState != null) {
      _restoreOriginalUIState(uiState);
    }

    // Force resume simulation by ensuring it's running and not paused
    if (simulationState != null) {
      // Start the simulation if not running
      if (!simulationState.isRunning) {
        simulationState.start();
      }
      // Force unpause if paused (might need multiple calls due to timing)
      if (simulationState.isPaused) {
        simulationState.pause(); // First attempt
      }
      // Double-check and force unpause again if still paused
      Future.delayed(const Duration(milliseconds: 50), () {
        if (simulationState.isPaused) {
          simulationState.pause(); // Second attempt with delay
        }
      });
    }

    _isActive = false;
    _showCountdown = false;
    _countdownSeconds = 0;
    notifyListeners();
  }

  /// Get preset name for dropdown display
  String getPresetDisplayName(int index, AppLocalizations l10n) {
    final preset = ScreenshotPresets.getPreset(index, l10n);
    return preset?.name ?? 'Unknown';
  }

  /// Get preset description for UI
  String getPresetDescription(int index, AppLocalizations l10n) {
    final preset = ScreenshotPresets.getPreset(index, l10n);
    return preset?.description ?? '';
  }

  /// Store original UI state before applying preset changes
  void _storeOriginalUIState(dynamic uiState) {
    _originalUIState = {
      'showLabels': uiState.showLabels,
      'showHabitableZones': uiState.showHabitableZones,
      'showOrbitalPaths': uiState.showOrbitalPaths,
      'showGravityWells': uiState.showGravityWells,
      'showOffScreenIndicators': uiState.showOffScreenIndicators,
    };
  }

  /// Restore original UI state when deactivating
  void _restoreOriginalUIState(dynamic uiState) {
    if (_originalUIState == null) return;

    // Restore each UI setting to its original state
    if (_originalUIState!['showLabels'] != uiState.showLabels) {
      uiState.toggleLabels();
    }
    if (_originalUIState!['showHabitableZones'] != uiState.showHabitableZones) {
      uiState.toggleHabitableZones();
    }
    if (_originalUIState!['showOrbitalPaths'] != uiState.showOrbitalPaths) {
      uiState.toggleOrbitalPaths();
    }
    if (_originalUIState!['showGravityWells'] != uiState.showGravityWells) {
      uiState.toggleGravityWells();
    }
    if (_originalUIState!['showOffScreenIndicators'] != uiState.showOffScreenIndicators) {
      uiState.toggleOffScreenIndicators();
    }

    // Clear stored state
    _originalUIState = null;
  }

  /// Reset camera state to clean slate before applying new preset
  void _resetCameraState(CameraState cameraState) {
    // Clear any selected body
    cameraState.selectBody(null);

    // Disable follow mode if active
    if (cameraState.followMode) {
      cameraState.toggleFollowMode([]);
    }

    // Disable auto-rotate if it's active
    if (cameraState.autoRotate) {
      cameraState.toggleAutoRotate();
    }

    // Reset camera to default view to ensure clean slate
    cameraState.resetView();
  }
}
