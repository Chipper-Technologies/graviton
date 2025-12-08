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

  /// Screen opened
  screenOpened('screen_opened'),

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
  changelogCompleted('changelog_completed'),

  /// Scenario creation started
  scenarioCreationStarted('scenario_creation_started'),

  /// Scenario creation completed
  scenarioCreationCompleted('scenario_creation_completed'),

  /// Scenario creation canceled
  scenarioCreationCanceled('scenario_creation_canceled'),

  /// Scenario editing started
  scenarioEditingStarted('scenario_editing_started'),

  /// Scenario editing completed
  scenarioEditingCompleted('scenario_editing_completed'),

  /// Scenario editing canceled
  scenarioEditingCanceled('scenario_editing_canceled'),

  /// Body added to scenario
  bodyAdded('body_added'),

  /// Body removed from scenario
  bodyRemoved('body_removed'),

  /// Body edited in scenario
  bodyEdited('body_edited'),

  /// Tab changed in editor
  tabChanged('tab_changed'),

  /// Scenario saved
  scenarioSaved('scenario_saved'),

  /// Scenario exported
  scenarioExported('scenario_exported'),

  /// Scenario imported
  scenarioImported('scenario_imported'),

  /// Scenario tested
  scenarioTested('scenario_tested'),

  /// Custom scenario deleted
  customScenarioDeleted('custom_scenario_deleted'),

  /// Custom scenario loaded
  customScenarioLoaded('custom_scenario_loaded'),

  // Physics Controls Analytics (High Priority)
  /// Gravity fields toggle
  gravityFieldsToggle('gravity_fields_toggle'),

  /// Equipotential surfaces toggle
  equipotentialSurfacesToggle('equipotential_surfaces_toggle'),

  /// Gravity field indicators toggle
  gravityFieldIndicatorsToggle('gravity_field_indicators_toggle'),

  /// Gravity field color scheme changed
  gravityFieldColorSchemeChanged('gravity_field_color_scheme_changed'),

  /// Relativistic effects toggle
  relativisticEffectsToggle('relativistic_effects_toggle'),

  /// Relativistic glow visualization toggle
  relativisticGlowToggle('relativistic_glow_toggle'),

  /// Tidal forces toggle
  tidalForcesToggle('tidal_forces_toggle'),

  /// Tidal visualization toggle
  tidalVisualizationToggle('tidal_visualization_toggle'),

  /// Physics setting adjusted
  physicsSettingAdjusted('physics_setting_adjusted'),

  // Visual Controls Analytics (High Priority)
  /// Trail display toggle
  trailDisplayToggle('trail_display_toggle'),

  /// Label display toggle
  labelDisplayToggle('label_display_toggle'),

  /// Realistic colors toggle
  realisticColorsToggle('realistic_colors_toggle'),

  /// Habitable zones toggle
  habitableZonesToggle('habitable_zones_toggle'),

  /// Habitability indicators toggle
  habitabilityIndicatorsToggle('habitability_indicators_toggle'),

  /// Orbital paths toggle
  orbitalPathsToggle('orbital_paths_toggle'),

  /// Dual orbital paths toggle
  dualOrbitalPathsToggle('dual_orbital_paths_toggle'),

  /// Offscreen indicators toggle
  offscreenIndicatorsToggle('offscreen_indicators_toggle'),

  /// Display setting changed
  displaySettingChanged('display_setting_changed'),

  // Camera & Navigation Analytics (High Priority)
  /// Camera technique selected
  cameraTechniqueSelected('camera_technique_selected'),

  /// Camera speed adjusted
  cameraSpeedAdjusted('camera_speed_adjusted'),

  /// Manual camera controls used
  manualCameraControlsUsed('manual_camera_controls_used'),

  /// Viewport gesture started
  viewportGestureStart('viewport_gesture_start'),

  /// Viewport gesture ended
  viewportGestureEnd('viewport_gesture_end'),

  /// Zoom level changed
  zoomLevelChanged('zoom_level_changed'),

  /// Pan operation
  panOperation('pan_operation'),

  /// Body tap interaction
  bodyTapInteraction('body_tap_interaction'),

  /// Viewport double tap
  viewportDoubleTap('viewport_double_tap'),

  // Scenario Management Analytics (High Priority)
  /// Scenario property modified
  scenarioPropertyModified('scenario_property_modified'),

  /// Body parameter edited
  bodyParameterEdited('body_parameter_edited'),

  /// Scenario physics setting changed
  scenarioPhysicsSettingChanged('scenario_physics_setting_changed'),

  /// Scenario validation error
  scenarioValidationError('scenario_validation_error'),

  /// Scenario preview launched
  scenarioPreviewLaunched('scenario_preview_launched'),

  /// Scenario test run started
  scenarioTestRunStarted('scenario_test_run_started'),

  /// Scenario test run completed
  scenarioTestRunCompleted('scenario_test_run_completed'),

  /// Scenario renamed
  scenarioRenamed('scenario_renamed'),

  /// Scenario duplicated
  scenarioDuplicated('scenario_duplicated'),

  /// Scenario export format selected
  scenarioExportFormatSelected('scenario_export_format_selected'),

  /// Scenario import attempted
  scenarioImportAttempted('scenario_import_attempted'),

  // Performance Analytics (High Priority)
  /// Frame rate degradation detected
  frameRateDegradation('frame_rate_degradation'),

  /// Memory usage spike detected
  memoryUsageSpike('memory_usage_spike'),

  /// Rendering performance issue
  renderingPerformanceIssue('rendering_performance_issue'),

  /// Physics calculation slowdown
  physicsCalculationSlowdown('physics_calculation_slowdown'),

  /// Time scale adjusted
  timeScaleAdjusted('time_scale_adjusted'),

  // Help & Educational Analytics (Medium Priority)
  /// Help section accessed
  helpSectionAccessed('help_section_accessed'),

  /// Tooltip interaction
  tooltipInteraction('tooltip_interaction'),

  /// Feature discovery
  featureDiscovery('feature_discovery'),

  /// Tutorial segment completed
  tutorialSegmentCompleted('tutorial_segment_completed'),

  /// Physics concept exploration
  physicsConceptExploration('physics_concept_exploration'),

  /// Changelog item expanded
  changelogItemExpanded('changelog_item_expanded'),

  /// About section navigation
  aboutSectionNavigation('about_section_navigation'),

  /// External link followed
  externalLinkFollowed('external_link_followed'),

  // Error Analytics (Medium Priority)
  /// Scenario load failed
  scenarioLoadFailed('scenario_load_failed'),

  /// Physics calculation error
  physicsCalculationError('physics_calculation_error'),

  /// UI interaction blocked
  uiInteractionBlocked('ui_interaction_blocked'),

  /// Invalid configuration attempted
  invalidConfigurationAttempted('invalid_configuration_attempted'),

  /// Resource limit reached
  resourceLimitReached('resource_limit_reached'),

  /// Dialog dismiss method
  dialogDismissMethod('dialog_dismiss_method'),

  /// Navigation error
  navigationError('navigation_error'),

  // Simulation Control Analytics (Low Priority)
  /// Simulation started
  simulationStarted('simulation_started'),

  /// Simulation stopped
  simulationStopped('simulation_stopped'),

  /// Simulation paused
  simulationPaused('simulation_paused'),

  /// Simulation resumed
  simulationResumed('simulation_resumed'),

  /// Simulation reset
  simulationReset('simulation_reset'),

  /// Simulation speed changed
  simulationSpeedChanged('simulation_speed_changed'),

  // Keyboard Navigation Analytics (Low Priority)
  /// Keyboard shortcut used
  keyboardShortcutUsed('keyboard_shortcut_used'),

  /// Accessibility navigation used
  accessibilityNavigation('accessibility_navigation'),

  /// Focus navigation
  focusNavigation('focus_navigation'),

  /// Semantic action performed
  semanticActionPerformed('semantic_action_performed'),

  /// Keyboard vs touch interaction pattern
  inputMethodUsed('input_method_used'),

  // Fullscreen Mode Analytics (Low Priority)
  /// Fullscreen entered
  fullscreenEntered('fullscreen_entered'),

  /// Fullscreen exited
  fullscreenExited('fullscreen_exited'),

  /// Fullscreen toggled
  fullscreenToggled('fullscreen_toggled'),

  /// System UI visibility changed
  systemUIVisibilityChanged('system_ui_visibility_changed'),

  /// Visual effect toggle
  visualEffectToggle('visual_effect_toggle');

  const UIAction(this.value);

  /// The string value used in analytics
  final String value;
}
