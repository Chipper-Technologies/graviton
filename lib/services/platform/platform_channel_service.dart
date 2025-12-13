import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/core/constants/platform_channel_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/state/app_state.dart';

/// Service for handling platform channel messages
///
/// This service manages communication with native platform code (iOS/Android/macOS)
/// through method channels, handling simulation control commands sent from
/// widgets, shortcuts, or other platform-specific UI elements.
class PlatformChannelService {
  // Private constructor to prevent instantiation
  PlatformChannelService._();

  /// Setup the simulation method channel handler
  ///
  /// This method configures the handler for simulation-related method channel calls,
  /// enabling platform-specific UI elements (like widgets or shortcuts) to control
  /// the simulation state, camera, and UI settings.
  ///
  /// Supported methods:
  /// - showTutorial: Display the tutorial screen
  /// - selectBody: Show body selection dialog
  /// - togglePlayPause: Toggle simulation play/pause state
  /// - reset: Reset simulation to initial state
  /// - increaseSpeed: Increase time scale by adjustment factor
  /// - decreaseSpeed: Decrease time scale by adjustment factor
  /// - centerCamera: Reset camera to scenario default view
  /// - toggleStatistics: Toggle statistics overlay
  /// - toggleBodyLabels: Toggle body name labels
  /// - toggleTrails: Toggle orbital trails
  /// - zoomIn: Zoom in by 10%
  /// - zoomOut: Zoom out by 10%
  /// - actualSize: Reset camera to default view
  ///
  /// Parameters:
  /// - [context]: BuildContext for accessing mounted state and navigation
  /// - [appState]: AppState containing simulation, camera, and UI state
  /// - [mounted]: Whether the widget is currently mounted
  /// - [onShowTutorial]: Callback to show tutorial screen
  /// - [onSelectBody]: Callback to show body selection dialog
  static void setupSimulationChannel({
    required BuildContext context,
    required AppState appState,
    required bool mounted,
    required VoidCallback onShowTutorial,
    required VoidCallback onSelectBody,
  }) {
    final simulationChannel = MethodChannel(
      PlatformChannelConstants.simulation,
    );

    simulationChannel.setMethodCallHandler((call) async {
      if (!mounted) return;

      switch (call.method) {
        case 'showTutorial':
          onShowTutorial();
          break;

        case 'selectBody':
          // Show body selection dialog
          onSelectBody();
          break;

        // Handle all other simulation commands here since this handler
        // overrides the one in main.dart
        case 'togglePlayPause':
          appState.simulation.pause();
          break;

        case 'reset':
          appState.simulation.reset();
          break;

        case 'increaseSpeed':
          final currentSpeed = appState.simulation.timeScale;
          appState.simulation.setTimeScale(
            (currentSpeed * SimulationConstants.timeScaleAdjustmentFactor)
                .clamp(
                  SimulationConstants.minTimeScale,
                  SimulationConstants.maxTimeScale,
                ),
          );
          break;

        case 'decreaseSpeed':
          final currentSpeed = appState.simulation.timeScale;
          appState.simulation.setTimeScale(
            (currentSpeed / SimulationConstants.timeScaleAdjustmentFactor)
                .clamp(
                  SimulationConstants.minTimeScale,
                  SimulationConstants.maxTimeScale,
                ),
          );
          break;

        case 'centerCamera':
          appState.camera.resetView(appState.simulation.currentScenario);
          break;

        case 'toggleStatistics':
          appState.ui.toggleStats();
          break;

        case 'toggleBodyLabels':
          appState.ui.toggleLabels();
          break;

        case 'toggleTrails':
          appState.ui.toggleTrails();
          break;

        case 'zoomIn':
          appState.camera.zoom(-0.1); // Zoom in by reducing distance 10%
          break;

        case 'zoomOut':
          appState.camera.zoom(0.1); // Zoom out by increasing distance 10%
          break;

        case 'actualSize':
          appState.camera.resetView(appState.simulation.currentScenario);
          break;

        default:
          debugPrint('Unhandled simulation channel method: ${call.method}');
          break;
      }
    });
  }
}
