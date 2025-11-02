/// UI actions that can be performed for analytics tracking
///
/// This enum provides type safety and consistency for UI action identification
/// in Firebase analytics event logging.
enum UIAction {
  /// Tap gesture
  tap('tap'),

  /// Double tap gesture
  doubleTap('double_tap'),

  /// Dialog opened
  dialogOpened('dialog_opened'),

  /// Scenario selected
  scenarioSelected('scenario_selected'),

  /// Button pressed
  buttonPressed('button_pressed'),

  /// Gesture started
  gestureStart('gesture_start'),

  /// Body selected
  bodySelected('body_selected'),

  /// Camera focus
  cameraFocus('camera_focus'),

  /// Follow mode enabled
  followModeEnabled('follow_mode_enabled'),

  /// Follow mode disabled
  followModeDisabled('follow_mode_disabled'),

  /// Camera reset
  cameraReset('camera_reset'),

  /// Camera auto zoom
  cameraAutoZoom('camera_auto_zoom'),

  /// Auto rotate toggle
  autoRotateToggle('auto_rotate_toggle'),

  /// Invert pitch toggle
  invertPitchToggle('invert_pitch_toggle'),

  /// Galactic plane mode toggle
  galacticPlaneModeToggle('galactic_plane_mode_toggle'),

  /// Camera center action
  cameraCenter('camera_center'),

  /// Camera follow toggle
  followToggle('follow_toggle'),

  /// Tutorial started
  tutorialStarted('tutorial_started'),

  /// Tutorial completed
  tutorialCompleted('tutorial_completed'),

  /// Changelog shown
  changelogShown('changelog_shown'),

  /// Changelog completed
  changelogCompleted('changelog_completed');

  const UIAction(this.value);

  /// The string value used in analytics
  final String value;
}
