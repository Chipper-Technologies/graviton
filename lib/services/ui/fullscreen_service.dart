import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/services/firebase/firebase_service.dart';

/// Service for managing fullscreen mode functionality
///
/// This service handles:
/// - Toggling fullscreen state
/// - Managing system UI overlay visibility
/// - Providing smooth transitions between modes
/// - Notifying listeners of state changes
class FullscreenService extends ChangeNotifier {
  static final FullscreenService _instance = FullscreenService._internal();
  static FullscreenService get instance => _instance;

  FullscreenService._internal();

  bool _isFullscreen = false;
  bool _isTransitioning = false;

  /// Whether the app is currently in fullscreen mode
  bool get isFullscreen => _isFullscreen;

  /// Whether a transition is currently in progress
  bool get isTransitioning => _isTransitioning;

  /// Enter fullscreen mode
  ///
  /// Hides all UI elements and system overlays for immersive experience
  Future<void> enterFullscreen([String? trigger]) async {
    if (_isFullscreen || _isTransitioning) return;

    _isTransitioning = true;
    notifyListeners();

    try {
      // Hide system UI overlays
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive,
        overlays: [], // Hide all system UI
      );

      _isFullscreen = true;

      // Log fullscreen entry analytics
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.fullscreenEntered,
        element: UIElement.fullscreenControls,
        additionalParams: {
          'trigger': trigger ?? 'unknown',
          'system_ui_mode': 'immersive',
          'overlays_hidden': 'true',
        },
      );
    } catch (e) {
      debugPrint('Error entering fullscreen: $e');

      // Log fullscreen entry error
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.navigationError,
        element: UIElement.fullscreenControls,
        value: 'enter_fullscreen_failed',
        additionalParams: {
          'error': e.toString(),
          'trigger': trigger ?? 'unknown',
        },
      );
    } finally {
      _isTransitioning = false;
      notifyListeners();
    }
  }

  /// Exit fullscreen mode
  ///
  /// Restores all UI elements and system overlays
  Future<void> exitFullscreen([String? trigger]) async {
    if (!_isFullscreen || _isTransitioning) return;

    _isTransitioning = true;
    notifyListeners();

    try {
      // Restore system UI overlays
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values, // Show all system UI
      );

      _isFullscreen = false;

      // Log fullscreen exit analytics
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.fullscreenExited,
        element: UIElement.fullscreenControls,
        additionalParams: {
          'trigger': trigger ?? 'unknown',
          'system_ui_mode': 'edge_to_edge',
          'overlays_restored': 'true',
        },
      );
    } catch (e) {
      debugPrint('Error exiting fullscreen: $e');

      // Log fullscreen exit error
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.navigationError,
        element: UIElement.fullscreenControls,
        value: 'exit_fullscreen_failed',
        additionalParams: {
          'error': e.toString(),
          'trigger': trigger ?? 'unknown',
        },
      );
    } finally {
      _isTransitioning = false;
      notifyListeners();
    }
  }

  /// Toggle between fullscreen and normal mode
  Future<void> toggleFullscreen([String? trigger]) async {
    if (_isTransitioning) return;

    final wasFullscreen = _isFullscreen;

    // Log toggle action before attempting the change
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.fullscreenToggled,
      element: UIElement.fullscreenToggle,
      value: wasFullscreen ? 'exit' : 'enter',
      additionalParams: {
        'previous_state': wasFullscreen ? 'fullscreen' : 'windowed',
        'requested_state': wasFullscreen ? 'windowed' : 'fullscreen',
        'trigger': trigger ?? 'toggle_button',
      },
    );

    if (_isFullscreen) {
      await exitFullscreen(trigger ?? 'toggle');
    } else {
      await enterFullscreen(trigger ?? 'toggle');
    }
  }

  /// Force exit fullscreen (useful for cleanup)
  void forceExitFullscreen([String? reason]) {
    if (_isFullscreen) {
      _isFullscreen = false;
      _isTransitioning = false;
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values,
      );

      // Log forced fullscreen exit
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.fullscreenExited,
        element: UIElement.systemUIControls,
        value: 'forced',
        additionalParams: {
          'reason': reason ?? 'force_cleanup',
          'method': 'force_exit',
          'system_ui_mode': 'edge_to_edge',
        },
      );

      notifyListeners();
    }
  }

  /// Reset service state (useful for testing)
  void reset() {
    _isFullscreen = false;
    _isTransitioning = false;
    notifyListeners();
  }
}
