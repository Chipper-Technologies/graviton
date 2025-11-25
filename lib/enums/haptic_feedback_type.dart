/// Haptic feedback types supported by haptic buttons
///
/// Defines the different types of haptic feedback that can be triggered
/// when interacting with haptic-enabled buttons in the application.
enum HapticFeedbackType {
  /// Light impact feedback - subtle tactile response
  lightImpact,

  /// Medium impact feedback - moderate tactile response
  mediumImpact,

  /// Heavy impact feedback - strong tactile response
  heavyImpact,

  /// Selection click feedback - crisp click-like response
  selectionClick,

  /// Vibrate feedback - continuous vibration pattern
  vibrate,
}
