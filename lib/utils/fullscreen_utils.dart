import 'package:flutter/services.dart';
import 'package:graviton/services/ui/fullscreen_service.dart';
import 'package:graviton/state/app_state.dart';

/// Utility functions for managing fullscreen mode
class FullscreenUtils {
  FullscreenUtils._();

  /// Enter fullscreen mode with proper state management
  ///
  /// This function:
  /// 1. Updates the UI state
  /// 2. Manages system UI overlays
  /// 3. Handles any errors gracefully
  static Future<void> enterFullscreen(
    AppState appState, [
    String? trigger,
  ]) async {
    try {
      // Update UI state first
      appState.ui.setFullscreen(true);

      // Use the fullscreen service to handle system UI
      await FullscreenService.instance.enterFullscreen(trigger ?? 'utils');
    } catch (e) {
      // If something goes wrong, revert the state
      appState.ui.setFullscreen(false);
      throw Exception('Failed to enter fullscreen: $e');
    }
  }

  /// Exit fullscreen mode with proper state management
  ///
  /// This function:
  /// 1. Updates the UI state
  /// 2. Restores system UI overlays
  /// 3. Handles any errors gracefully
  static Future<void> exitFullscreen(
    AppState appState, [
    String? trigger,
  ]) async {
    try {
      // Update UI state first
      appState.ui.setFullscreen(false);

      // Use the fullscreen service to handle system UI
      await FullscreenService.instance.exitFullscreen(trigger ?? 'utils');
    } catch (e) {
      // If something goes wrong, revert the state
      appState.ui.setFullscreen(true);
      throw Exception('Failed to exit fullscreen: $e');
    }
  }

  /// Toggle fullscreen mode
  ///
  /// This is the main function that should be called when the user
  /// taps the simulation to toggle fullscreen mode
  static Future<void> toggleFullscreen(
    AppState appState, [
    String? trigger,
  ]) async {
    if (appState.ui.isFullscreen) {
      await exitFullscreen(appState, trigger ?? 'toggle');
    } else {
      await enterFullscreen(appState, trigger ?? 'toggle');
    }
  }

  /// Check if the device supports fullscreen mode
  ///
  /// Currently returns true for all platforms, but could be extended
  /// to check for specific platform capabilities
  static bool isFullscreenSupported() {
    return true; // All platforms support hiding system UI
  }

  /// Get the appropriate system UI mode for fullscreen
  static SystemUiMode getFullscreenMode() {
    return SystemUiMode.immersive;
  }

  /// Get the appropriate system UI mode for normal view
  static SystemUiMode getNormalMode() {
    return SystemUiMode.edgeToEdge;
  }

  /// Get the system overlays for fullscreen mode
  static List<SystemUiOverlay> getFullscreenOverlays() {
    return []; // Hide all overlays
  }

  /// Get the system overlays for normal mode
  static List<SystemUiOverlay> getNormalOverlays() {
    return SystemUiOverlay.values; // Show all overlays
  }

  /// Force exit fullscreen (useful for cleanup or error recovery)
  static Future<void> forceExitFullscreen(
    AppState appState, [
    String? reason,
  ]) async {
    appState.ui.setFullscreen(false);
    FullscreenService.instance.forceExitFullscreen(
      reason ?? 'utils_force_exit',
    );
  }

  /// Reset fullscreen state (useful for testing)
  static void resetFullscreenState(AppState appState) {
    appState.ui.setFullscreen(false);
    FullscreenService.instance.reset();
  }
}
