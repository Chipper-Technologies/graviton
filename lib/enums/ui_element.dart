/// UI elements that can be interacted with for analytics tracking
///
/// This enum provides type safety and consistency for UI element identification
/// in Firebase analytics event logging.
enum UIElement {
  /// Main simulation viewport
  simulationViewport('simulation_viewport'),

  /// Scenario selection dialog
  scenarioSelection('scenario_selection'),

  /// Scenario dialog within scenario selection
  scenarioDialog('scenario_dialog'),

  /// Settings dialog
  settings('settings'),

  /// Simulation control buttons (play/pause/reset)
  simulationControl('simulation_control'),

  /// Camera control gestures and interactions
  cameraControls('camera_controls'),

  /// Camera object/state
  camera('camera'),

  /// Body selection and interaction
  body('body'),

  /// Scenario-related interactions
  scenario('scenario'),

  /// Help dialog
  help('help'),

  /// Tutorial overlay
  tutorial('tutorial'),

  /// Body properties dialog
  bodyProperties('body_properties'),

  /// Physics/simulation settings dialog
  physicsSettings('physics_settings'),

  /// Changelog dialog
  changelog('changelog'),

  /// About screen/dialog
  about('about'),

  /// Developer tools screen/dialog
  developerTools('developer_tools'),

  /// Scenario editor screen
  scenarioEditor('scenario_editor'),

  /// Scenario editor body list tab
  scenarioEditorBodies('scenario_editor_bodies'),

  /// Scenario editor settings tab
  scenarioEditorSettings('scenario_editor_settings'),

  /// Scenario editor preview tab
  scenarioEditorPreview('scenario_editor_preview'),

  /// Custom scenarios tab
  customScenariosTab('custom_scenarios_tab'),

  /// Preset scenarios tab
  presetScenariosTab('preset_scenarios_tab'),

  /// Body editor dialog
  bodyEditor('body_editor'),

  /// Scenario metadata panel
  scenarioMetadata('scenario_metadata'),

  /// Scenario physics panel
  scenarioPhysics('scenario_physics'),

  // Physics Controls Elements
  /// Physics visualization controls
  physicsVisualization('physics_visualization'),

  /// Gravity field controls
  gravityFieldControls('gravity_field_controls'),

  /// Equipotential surfaces controls
  equipotentialSurfaces('equipotential_surfaces'),

  /// Gravity field indicators controls
  gravityFieldIndicators('gravity_field_indicators'),

  /// Gravity field color scheme selector
  gravityFieldColorScheme('gravity_field_color_scheme'),

  // Visual Controls Elements
  /// Visual display controls
  visualDisplayControls('visual_display_controls'),

  /// Trail visualization controls
  trailControls('trail_controls'),

  /// Label display controls
  labelControls('label_controls'),

  /// Color scheme controls
  colorSchemeControls('color_scheme_controls'),

  /// Habitable zone controls
  habitableZoneControls('habitable_zone_controls'),

  /// Orbital path controls
  orbitalPathControls('orbital_path_controls'),

  /// Navigation aids controls
  navigationAidsControls('navigation_aids_controls'),

  // Camera & Viewport Elements
  /// Simulation viewport/canvas
  viewportCanvas('viewport_canvas'),

  /// Camera technique selector
  cameraTechniqueSelector('camera_technique_selector'),

  /// Camera speed controls
  cameraSpeedControls('camera_speed_controls'),

  /// Manual camera controls
  manualCameraControls('manual_camera_controls'),

  /// Camera action buttons
  cameraActionButtons('camera_action_buttons'),

  // Help & Educational Elements
  /// Help documentation
  helpDocumentation('help_documentation'),

  /// Tooltip system
  tooltipSystem('tooltip_system'),

  /// Tutorial overlay
  tutorialOverlay('tutorial_overlay'),

  /// Changelog viewer
  changelogViewer('changelog_viewer'),

  /// About information
  aboutInformation('about_information'),

  /// External links
  externalLinks('external_links'),

  // Performance Elements
  /// Performance monitor
  performanceMonitor('performance_monitor'),

  /// Frame rate indicator
  frameRateIndicator('frame_rate_indicator'),

  /// Memory usage indicator
  memoryUsageIndicator('memory_usage_indicator'),

  // Simulation Control Elements
  /// Simulation playback controls
  simulationPlaybackControls('simulation_playback_controls'),

  /// Time scale controls
  timeScaleControls('time_scale_controls'),

  /// Simulation lifecycle controls
  simulationLifecycleControls('simulation_lifecycle_controls'),

  // Keyboard Navigation Elements
  /// Keyboard shortcuts system
  keyboardShortcuts('keyboard_shortcuts'),

  /// Accessibility navigation
  accessibilityNavigation('accessibility_navigation'),

  /// Focus management system
  focusManagement('focus_management'),

  /// Semantic navigation controls
  semanticNavigation('semantic_navigation'),

  // Fullscreen Elements
  /// Fullscreen controls
  fullscreenControls('fullscreen_controls'),

  /// System UI controls
  systemUIControls('system_ui_controls'),

  /// Fullscreen toggle button
  fullscreenToggle('fullscreen_toggle');

  const UIElement(this.value);

  /// The string value used in analytics
  final String value;
}
