import 'package:flutter/services.dart';

/// Utility class for safe haptic feedback that handles cases where
/// services binding is not initialized (e.g., during testing)
class SafeHapticFeedback {
  /// Check if haptic feedback is available
  static bool get _isAvailable {
    try {
      // Try to access the binding to see if it's available
      ServicesBinding.instance;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Provides light impact haptic feedback if available
  static void lightImpact() {
    if (!_isAvailable) return;
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      // Haptic feedback not available (likely during testing)
      // Silently ignore - this is expected behavior
    }
  }

  /// Provides medium impact haptic feedback if available
  static void mediumImpact() {
    if (!_isAvailable) return;
    try {
      HapticFeedback.mediumImpact();
    } catch (e) {
      // Haptic feedback not available (likely during testing)
      // Silently ignore - this is expected behavior
    }
  }

  /// Provides heavy impact haptic feedback if available
  static void heavyImpact() {
    if (!_isAvailable) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      // Haptic feedback not available (likely during testing)
      // Silently ignore - this is expected behavior
    }
  }

  /// Provides selection click haptic feedback if available
  static void selectionClick() {
    if (!_isAvailable) return;
    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      // Haptic feedback not available (likely during testing)
      // Silently ignore - this is expected behavior
    }
  }

  /// Provides vibrate haptic feedback if available
  static void vibrate() {
    if (!_isAvailable) return;
    try {
      HapticFeedback.vibrate();
    } catch (e) {
      // Haptic feedback not available (likely during testing)
      // Silently ignore - this is expected behavior
    }
  }
}
