import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Future<void> enterFullscreen() async {
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
    } catch (e) {
      debugPrint('Error entering fullscreen: $e');
    } finally {
      _isTransitioning = false;
      notifyListeners();
    }
  }

  /// Exit fullscreen mode
  ///
  /// Restores all UI elements and system overlays
  Future<void> exitFullscreen() async {
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
    } catch (e) {
      debugPrint('Error exiting fullscreen: $e');
    } finally {
      _isTransitioning = false;
      notifyListeners();
    }
  }

  /// Toggle between fullscreen and normal mode
  Future<void> toggleFullscreen() async {
    if (_isTransitioning) return;

    if (_isFullscreen) {
      await exitFullscreen();
    } else {
      await enterFullscreen();
    }
  }

  /// Force exit fullscreen (useful for cleanup)
  void forceExitFullscreen() {
    if (_isFullscreen) {
      _isFullscreen = false;
      _isTransitioning = false;
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values,
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
