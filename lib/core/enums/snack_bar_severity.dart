/// Severity levels for SnackBar notifications
///
/// This enum defines the different severity levels for app-wide notifications,
/// each with its own visual styling and semantic meaning.
enum SnackBarSeverity {
  /// Informational messages (blue theme)
  /// Used for neutral information, tips, or general status updates
  info,

  /// Success messages (green theme)
  /// Used for successful operations, confirmations, and positive feedback
  success,

  /// Warning messages (orange theme)
  /// Used for cautionary messages, potential issues, or important notices
  warning,

  /// Error messages (red theme)
  /// Used for failures, critical issues, and problems requiring attention
  error,
}
