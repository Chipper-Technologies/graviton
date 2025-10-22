/// Firebase Analytics event names for consistent logging
///
/// This enum provides type safety and consistency for Firebase Analytics
/// event names throughout the application.
enum FirebaseEvent {
  /// Application lifecycle events
  appInitialized('app_initialized'),
  appStart('app_start'),
  appError('app_error'),

  /// Simulation lifecycle events
  simulationStarted('simulation_started'),
  simulationPaused('simulation_paused'),
  simulationResumed('simulation_resumed'),
  simulationStopped('simulation_stopped'),
  simulationReset('simulation_reset'),

  /// Settings and configuration events
  settingsChanged('settings_changed'),

  /// Performance monitoring events
  performanceMetric('performance_metric'),

  /// UI interaction events (prefixed dynamically)
  uiInteraction('ui_'), // Base prefix for UI events

  /// Simulation events (prefixed dynamically)
  simulationAction('simulation_'); // Base prefix for simulation events

  const FirebaseEvent(this.value);

  /// The string value used in Firebase Analytics
  final String value;

  /// Create a UI event name with the given action
  static String uiEvent(String action) => 'ui_$action';

  /// Create a simulation event name with the given action
  static String simulationEvent(String action) => 'simulation_$action';
}
