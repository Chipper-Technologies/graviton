/// Enumeration of simulation states for accessibility announcements
enum AccessibilitySimulationState {
  /// Simulation has been started
  started,

  /// Simulation is currently running
  running,

  /// Simulation has been paused
  paused,

  /// Simulation has been resumed from pause
  resumed,

  /// Simulation has been stopped
  stopped,

  /// Simulation has been reset
  reset;

  /// Get the localization key for this state
  String get localizationKey {
    switch (this) {
      case AccessibilitySimulationState.started:
        return 'accessibilitySimulationStarted';
      case AccessibilitySimulationState.running:
        return 'accessibilitySimulationRunning';
      case AccessibilitySimulationState.paused:
        return 'accessibilitySimulationPaused';
      case AccessibilitySimulationState.resumed:
        return 'accessibilitySimulationResumed';
      case AccessibilitySimulationState.stopped:
        return 'accessibilitySimulationStopped';
      case AccessibilitySimulationState.reset:
        return 'accessibilitySimulationReset';
    }
  }

  /// Get the context localization key for this state
  String get contextLocalizationKey {
    switch (this) {
      case AccessibilitySimulationState.started:
      case AccessibilitySimulationState.running:
        return 'accessibilitySimulationStartedContext';
      case AccessibilitySimulationState.paused:
        return 'accessibilitySimulationPausedContext';
      case AccessibilitySimulationState.resumed:
        return 'accessibilitySimulationResumedContext';
      case AccessibilitySimulationState.stopped:
        return 'accessibilitySimulationStoppedContext';
      case AccessibilitySimulationState.reset:
        return 'accessibilitySimulationResetContext';
    }
  }

  /// Create from string representation
  static AccessibilitySimulationState fromString(String state) {
    switch (state.toLowerCase()) {
      case 'started':
      case 'running':
        return AccessibilitySimulationState.started;
      case 'paused':
        return AccessibilitySimulationState.paused;
      case 'resumed':
        return AccessibilitySimulationState.resumed;
      case 'stopped':
        return AccessibilitySimulationState.stopped;
      case 'reset':
        return AccessibilitySimulationState.reset;
      default:
        return AccessibilitySimulationState.started;
    }
  }
}
