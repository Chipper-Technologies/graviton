import 'package:graviton/services/ui/haptic_feedback_service.dart';

/// Utility class for common haptic feedback patterns
class HapticUtils {
  HapticUtils._();

  /// Light tap feedback for buttons, links, and general interactions
  static Future<void> tap() => HapticFeedbackService.instance.lightImpact();

  /// Selection feedback for toggles, switches, and radio buttons
  static Future<void> toggle() =>
      HapticFeedbackService.instance.selectionClick();

  /// Medium feedback for important actions like saves, confirmations
  static Future<void> confirm() =>
      HapticFeedbackService.instance.mediumImpact();

  /// Heavy feedback for critical actions like deletions, errors
  static Future<void> impact() => HapticFeedbackService.instance.heavyImpact();

  /// Error feedback for validation failures, crashes
  static Future<void> error() => HapticFeedbackService.instance.vibrate();

  /// Success feedback for completions, achievements
  static Future<void> success() =>
      HapticFeedbackService.instance.mediumImpact();

  /// Navigation feedback for page transitions, drawer opens
  static Future<void> navigate() =>
      HapticFeedbackService.instance.lightImpact();

  /// Drag feedback for gesture interactions
  static Future<void> drag() => HapticFeedbackService.instance.selectionClick();

  /// Long press feedback for context menus, drag starts
  static Future<void> longPress() =>
      HapticFeedbackService.instance.mediumImpact();

  /// Notification feedback for alerts, messages
  static Future<void> notification() =>
      HapticFeedbackService.instance.mediumImpact();
}
