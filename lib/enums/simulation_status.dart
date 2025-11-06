/// Represents the current status of the physics simulation
enum SimulationStatus {
  /// Simulation is not running and not paused (initial state)
  stopped,

  /// Simulation is actively running and updating
  running,

  /// Simulation is running but temporarily paused
  paused,

  /// Simulation encountered an error and cannot continue
  error,
}

/// Extension methods for SimulationStatus
extension SimulationStatusExtension on SimulationStatus {
  /// Whether the simulation is in an active state (can be paused/resumed)
  bool get isActive =>
      this == SimulationStatus.running || this == SimulationStatus.paused;

  /// Whether the simulation is currently advancing time
  bool get isAdvancing => this == SimulationStatus.running;

  /// Whether the simulation can be started
  bool get canStart =>
      this == SimulationStatus.stopped || this == SimulationStatus.error;

  /// Whether the simulation can be paused
  bool get canPause => this == SimulationStatus.running;

  /// Whether the simulation can be resumed
  bool get canResume => this == SimulationStatus.paused;

  /// Whether the simulation can be stopped
  bool get canStop =>
      this == SimulationStatus.running || this == SimulationStatus.paused;

  /// Display name for the status (for localization keys)
  String get localizationKey {
    switch (this) {
      case SimulationStatus.stopped:
        return 'statusStopped';
      case SimulationStatus.running:
        return 'statusRunning';
      case SimulationStatus.paused:
        return 'statusPaused';
      case SimulationStatus.error:
        return 'statusError';
    }
  }

  /// Icon associated with this status
  String get iconName {
    switch (this) {
      case SimulationStatus.stopped:
        return 'stop';
      case SimulationStatus.running:
        return 'play';
      case SimulationStatus.paused:
        return 'pause';
      case SimulationStatus.error:
        return 'error';
    }
  }
}
