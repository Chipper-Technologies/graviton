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
  changelog('changelog');

  const UIElement(this.value);

  /// The string value used in analytics
  final String value;
}
