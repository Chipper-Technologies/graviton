/// Connection status for live session features
///
/// Represents the current state of the connection to a live session,
/// used for displaying appropriate UI feedback to users.
enum LiveSessionConnectionStatus {
  /// Not connected to any session
  disconnected,

  /// Attempting to connect to a session
  connecting,

  /// Successfully connected and receiving data
  connected,

  /// Connection lost, attempting to reconnect
  reconnecting,

  /// Connection failed with an error
  error,
}

/// Extension methods for [LiveSessionConnectionStatus]
extension LiveSessionConnectionStatusExtension on LiveSessionConnectionStatus {
  /// Whether this status indicates an active connection
  bool get isActive =>
      this == LiveSessionConnectionStatus.connected ||
      this == LiveSessionConnectionStatus.reconnecting;

  /// Whether this status indicates a connection in progress
  bool get isConnecting =>
      this == LiveSessionConnectionStatus.connecting ||
      this == LiveSessionConnectionStatus.reconnecting;

  /// Whether this status indicates a problem
  bool get hasIssue =>
      this == LiveSessionConnectionStatus.error ||
      this == LiveSessionConnectionStatus.reconnecting;

  /// Get the localization key for this status
  String get localizationKey {
    switch (this) {
      case LiveSessionConnectionStatus.disconnected:
        return 'liveSessionStatusDisconnected';
      case LiveSessionConnectionStatus.connecting:
        return 'liveSessionStatusConnecting';
      case LiveSessionConnectionStatus.connected:
        return 'liveSessionStatusConnected';
      case LiveSessionConnectionStatus.reconnecting:
        return 'liveSessionStatusReconnecting';
      case LiveSessionConnectionStatus.error:
        return 'liveSessionStatusError';
    }
  }
}
