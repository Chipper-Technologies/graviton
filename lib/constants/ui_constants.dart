/// UI interaction, timing, and layout constants for Graviton
class UIConstants {
  /// Private constructor to prevent instantiation.
  UIConstants._();

  // =============================================================================
  // TIMING CONSTANTS
  // =============================================================================

  /// Delay after navigation to allow screen to settle before actions
  static const Duration postNavigationDelay = Duration(milliseconds: 100);

  /// Duration for screen transition animations
  static const Duration screenTransitionDuration = Duration(milliseconds: 300);

  /// Delay before initialization tasks after app start
  static const Duration initializationDelay = Duration(milliseconds: 1000);

  /// Timeout for floating controls to auto-hide
  static const Duration floatingControlsTimeout = Duration(seconds: 3);

  /// Timeout for screenshot navigation prompt
  static const Duration screenshotNavigationTimeout = Duration(seconds: 4);

  /// Debounce delay for tap gestures to prevent double-taps
  static const Duration tapDebounceDelay = Duration(milliseconds: 50);

  /// Delay before showing maintenance dialog
  static const Duration maintenanceDialogDelay = Duration(milliseconds: 500);

  /// Delay before checking for changelog updates
  static const Duration changelogCheckDelay = Duration(milliseconds: 2000);

  // =============================================================================
  // UI INTERACTION CONSTANTS
  // =============================================================================

  /// Threshold for determining if bottom sheet is effectively closed
  /// (position < 0.15 is considered closed)
  static const double sheetClosedPositionThreshold = 0.15;

  // =============================================================================
  // UI LAYOUT CONSTANTS
  // =============================================================================

  /// Bottom sheet height as ratio of screen height (75%)
  static const double bottomSheetHeightRatio = 0.75;

  /// Bottom offset for floating controls positioning
  static const double floatingControlsBottomOffset = 20.0;

  /// Bottom offset for screenshot controls positioning
  static const double screenshotControlsBottomOffset = 140.0;
}
