import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/core/constants/ui_constants.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/utils/fullscreen_utils.dart';
import 'package:graviton/shared/widgets/layouts/sliding_panel_bottom_sheet.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for handling camera gestures and floating controls
///
/// This service centralizes camera-related gestures like three-finger panning
/// and fullscreen toggling, as well as floating controls visibility management.
class CameraGestureService {
  // Private constructor to prevent instantiation
  CameraGestureService._();

  /// Handle three-finger pan gesture to move camera target in view-relative directions
  ///
  /// This method converts screen-space deltas to world-space camera movement,
  /// scaling the sensitivity based on camera distance for consistent feel at all zoom levels.
  ///
  /// The camera is prevented from panning in follow mode to avoid breaking follow behavior.
  static void handleThreeFingerPan({
    required Offset screenDelta,
    required AppState appState,
  }) {
    final camera = appState.camera;

    // Don't allow panning in follow mode - it would break the follow behavior
    if (camera.followMode) {
      return;
    }

    // Convert screen delta to camera-relative movement
    // Pan sensitivity scales with distance for consistent feel at all zoom levels
    final panSensitivity =
        camera.distance * SimulationConstants.cameraPanSensitivityFactor;

    // Calculate camera's right and up vectors based on yaw angle
    // Right vector is perpendicular to the view direction (for horizontal pan)
    final cy = math.cos(camera.yaw);
    final sy = math.sin(camera.yaw);
    final rightVector = vm.Vector3(-cy, 0, sy);
    final upVector = RenderingConstants.worldUp;

    // Convert 2D screen delta to 3D world space delta
    // Positive dx for natural panning direction (drag right = pan right)
    // Positive dy inverted for natural vertical panning (drag up = pan up)
    final worldDelta =
        rightVector * (screenDelta.dx * panSensitivity) +
        upVector * (screenDelta.dy * panSensitivity);

    // Apply the delta to move the camera target in world space
    camera.pan(worldDelta);
  }

  /// Handle fullscreen mode toggle (triggered by double-tap on simulation viewport)
  ///
  /// This method manages the fullscreen transition, including:
  /// - Hiding floating controls during transition
  /// - Toggling fullscreen mode
  /// - Restoring floating controls after transition
  /// - Logging analytics events
  ///
  /// Parameters:
  /// - [context]: BuildContext for accessing mounted state
  /// - [appState]: AppState containing fullscreen state
  /// - [mounted]: Whether the widget is currently mounted
  /// - [onUpdate]: Callback to trigger setState for UI updates
  static Future<void> handleFullscreenToggle({
    required BuildContext context,
    required AppState appState,
    required bool mounted,
    required VoidCallback onUpdate,
  }) async {
    try {
      // Hide floating controls temporarily during fullscreen transition
      onUpdate();

      await FullscreenUtils.toggleFullscreen(appState, 'viewport_double_tap');

      // Force a rebuild after fullscreen toggle and show controls again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Refresh the sheet position to trigger floating controls repositioning
          SlidingPanelBottomSheet.refreshPosition();

          // Small delay to ensure layout has settled before showing controls
          Future.delayed(UIConstants.postNavigationDelay, () {
            if (mounted) {
              onUpdate();
            }
          });
        }
      });

      // Log the fullscreen toggle event (triggered by double-tap)
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.doubleTap,
        element: UIElement.simulationViewport,
        value: appState.ui.isFullscreen
            ? 'enter_fullscreen'
            : 'exit_fullscreen',
      );
    } catch (e) {
      debugPrint('Error toggling fullscreen: $e');
      // Restore floating controls on error
      if (mounted) {
        onUpdate();
      }
    }
  }

  /// Show floating controls and reset auto-hide timer
  ///
  /// This method manages the visibility of floating controls with an auto-hide timer.
  /// The timer is only set when the sheet is in closed position to avoid hiding controls
  /// when the user is actively interacting with the sheet.
  ///
  /// Parameters:
  /// - [mounted]: Whether the widget is currently mounted
  /// - [currentTimer]: Current timer instance (may be null)
  /// - [onUpdate]: Callback to trigger setState for UI updates
  ///
  /// Returns:
  /// - Updated timer instance that will hide controls after timeout
  static Timer? showFloatingControlsTemporarily({
    required bool mounted,
    required Timer? currentTimer,
    required VoidCallback onUpdate,
  }) {
    // Show controls immediately
    onUpdate();

    // Cancel existing timer
    currentTimer?.cancel();

    // Only set timer to hide controls when sheet is in closed position
    // If sheet is expanded (positions 2 or 3), keep controls visible
    final currentSheetPosition = SlidingPanelBottomSheet.sheetPosition.value;
    const minPosition = UIConstants.sheetClosedPositionThreshold;

    if (currentSheetPosition <= minPosition) {
      // Set timer to hide controls after 3 seconds of inactivity only when closed
      return Timer(UIConstants.floatingControlsTimeout, () {
        if (mounted) {
          // Double-check sheet position before hiding
          final sheetPosition = SlidingPanelBottomSheet.sheetPosition.value;
          if (sheetPosition <= minPosition) {
            onUpdate();
          }
        }
      });
    }

    return null;
  }

  /// Handle sheet position changes to manage floating controls visibility
  ///
  /// This method monitors sheet position changes and:
  /// - Cancels auto-hide timer when sheet is expanded
  /// - Restarts timer when sheet returns to closed position
  ///
  /// Parameters:
  /// - [mounted]: Whether the widget is currently mounted
  /// - [currentTimer]: Current timer instance (may be null)
  /// - [showFloatingControls]: Whether floating controls are currently visible
  /// - [onRestartTimer]: Callback to restart the auto-hide timer
  ///
  /// Returns:
  /// - Updated timer instance (null if timer was cancelled)
  static Timer? handleSheetPositionChanged({
    required bool mounted,
    required Timer? currentTimer,
    required bool showFloatingControls,
    required VoidCallback onRestartTimer,
  }) {
    const minPosition = UIConstants.sheetClosedPositionThreshold;
    final currentPosition = SlidingPanelBottomSheet.sheetPosition.value;

    if (mounted) {
      if (currentPosition > minPosition) {
        // Sheet is expanded (positions 2 or 3) - cancel any existing timer
        currentTimer?.cancel();
        return null;
      } else if (currentPosition <= minPosition && showFloatingControls) {
        // Sheet moved to closed position - restart timer if controls are currently showing
        onRestartTimer();
      }
    }

    return currentTimer;
  }
}
