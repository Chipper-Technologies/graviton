import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:graviton/state/ui_state.dart';

/// Service for managing haptic feedback throughout the app
class HapticFeedbackService {
  static HapticFeedbackService? _instance;
  static HapticFeedbackService get instance =>
      _instance ??= HapticFeedbackService._();

  HapticFeedbackService._();

  UIState? _uiState;
  bool? _manuallyEnabledUI;
  bool? _manuallyEnabledCollision;

  /// Check if the device supports vibration
  /// On web desktop, vibration is not supported (returns false)
  /// On web mobile and native platforms, vibration is supported (returns true)
  bool get _supportsVibration {
    if (kIsWeb) {
      // On web, haptic feedback only works on mobile devices with vibration motors
      // Desktop browsers will log intervention warnings if we try to vibrate
      // We disable haptics on web to avoid these warnings since most users
      // will be on desktop where it doesn't work anyway
      return false;
    }
    // Native platforms (iOS, Android, macOS) support haptics
    return true;
  }

  /// Initialize the service with UIState to check vibration settings
  void initialize(UIState uiState) {
    _uiState = uiState;
  }

  /// Manually set UI haptic feedback state (for testing or overrides)
  void setUIEnabled(bool enabled) {
    _manuallyEnabledUI = enabled;
  }

  /// Manually set collision haptic feedback state (for testing or overrides)
  void setCollisionEnabled(bool enabled) {
    _manuallyEnabledCollision = enabled;
  }

  /// Legacy method for backward compatibility - sets both UI and collision
  void setEnabled(bool enabled) {
    _manuallyEnabledUI = enabled;
    _manuallyEnabledCollision = enabled;
  }

  /// Check if UI haptic feedback is enabled
  bool get isUIEnabled {
    if (!_supportsVibration) return false;
    if (_manuallyEnabledUI != null) return _manuallyEnabledUI!;
    return _uiState?.enableUIHapticFeedback ?? true;
  }

  /// Check if collision haptic feedback is enabled
  bool get isCollisionEnabled {
    if (!_supportsVibration) return false;
    if (_manuallyEnabledCollision != null) return _manuallyEnabledCollision!;
    return _uiState?.enableCollisionHapticFeedback ?? true;
  }

  /// Legacy getter for backward compatibility - returns UI enabled state
  bool get isEnabled => isUIEnabled;

  /// Light haptic feedback for UI interactions like button taps
  Future<void> lightImpact() async {
    if (isUIEnabled) {
      try {
        await HapticFeedback.lightImpact();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Medium haptic feedback for more significant interactions
  Future<void> mediumImpact() async {
    if (isUIEnabled) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Heavy haptic feedback for important actions
  Future<void> heavyImpact() async {
    if (isUIEnabled) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Selection feedback for toggles and switches
  Future<void> selectionClick() async {
    if (isUIEnabled) {
      try {
        await HapticFeedback.selectionClick();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Vibration pattern feedback for errors or warnings
  Future<void> vibrate() async {
    if (isUIEnabled) {
      try {
        await HapticFeedback.vibrate();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Collision-specific haptic feedback
  Future<void> collisionImpact() async {
    if (isCollisionEnabled) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Collision-specific vibration feedback
  Future<void> collisionVibrate() async {
    if (isCollisionEnabled) {
      try {
        await HapticFeedback.vibrate();
      } catch (e) {
        // Silently handle platform errors
      }
    }
  }

  /// Energy-scaled collision haptic feedback based on collision intensity
  ///
  /// Uses different haptic feedback types based on the energy of the collision:
  /// - Low energy (< 10): Light impact
  /// - Medium energy (10-50): Medium impact
  /// - High energy (50-200): Heavy impact
  /// - Very high energy (>= 200): Vibration pattern
  Future<void> collisionWithEnergy(double energy) async {
    if (!isCollisionEnabled) return;

    try {
      if (energy < 10.0) {
        // Light collision - subtle feedback
        await HapticFeedback.lightImpact();
      } else if (energy < 50.0) {
        // Medium collision - moderate feedback
        await HapticFeedback.mediumImpact();
      } else if (energy < 200.0) {
        // Heavy collision - strong feedback
        await HapticFeedback.heavyImpact();
      } else {
        // Very energetic collision - maximum feedback with vibration
        await HapticFeedback.vibrate();
      }
    } catch (e) {
      // Silently handle platform errors
    }
  }

  /// Legacy light method for backward compatibility
  void light() => lightImpact();

  /// Legacy medium method for backward compatibility
  void medium() => mediumImpact();

  /// Legacy heavy method for backward compatibility
  void heavy() => heavyImpact();

  /// Legacy selection method for backward compatibility
  void selection() => selectionClick();
}
