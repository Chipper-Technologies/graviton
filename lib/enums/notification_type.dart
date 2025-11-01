/// Represents different types of notifications in the app
enum NotificationType {
  /// Error notifications (high priority)
  error,

  /// Warning notifications (medium priority)
  warning,

  /// Information notifications (low priority)
  info,

  /// Success notifications (confirmation)
  success,

  /// Debug notifications (development only)
  debug,
}

/// Extension methods for NotificationType
extension NotificationTypeExtension on NotificationType {
  /// Get string value for storage/serialization
  String get value {
    switch (this) {
      case NotificationType.error:
        return 'error';
      case NotificationType.warning:
        return 'warning';
      case NotificationType.info:
        return 'info';
      case NotificationType.success:
        return 'success';
      case NotificationType.debug:
        return 'debug';
    }
  }

  /// Create from string value
  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'error':
        return NotificationType.error;
      case 'warning':
        return NotificationType.warning;
      case 'info':
        return NotificationType.info;
      case 'success':
        return NotificationType.success;
      case 'debug':
        return NotificationType.debug;
      default:
        return NotificationType.info; // Safe default
    }
  }

  /// Priority level (0 = highest, 4 = lowest)
  int get priority {
    switch (this) {
      case NotificationType.error:
        return 0;
      case NotificationType.warning:
        return 1;
      case NotificationType.success:
        return 2;
      case NotificationType.info:
        return 3;
      case NotificationType.debug:
        return 4;
    }
  }

  /// Whether this notification type should be shown in production
  bool get showInProduction {
    switch (this) {
      case NotificationType.debug:
        return false;
      default:
        return true;
    }
  }

  /// Whether this notification should auto-dismiss
  bool get autoDismiss {
    switch (this) {
      case NotificationType.error:
        return false; // Require user action
      case NotificationType.warning:
        return false; // Require user action
      default:
        return true; // Auto-dismiss after timeout
    }
  }

  /// Auto-dismiss duration in seconds (if applicable)
  int get dismissDurationSeconds {
    switch (this) {
      case NotificationType.success:
        return 3;
      case NotificationType.info:
        return 5;
      case NotificationType.debug:
        return 2;
      default:
        return 0; // No auto-dismiss
    }
  }

  /// Display name for UI
  String get displayName {
    switch (this) {
      case NotificationType.error:
        return 'Error';
      case NotificationType.warning:
        return 'Warning';
      case NotificationType.info:
        return 'Info';
      case NotificationType.success:
        return 'Success';
      case NotificationType.debug:
        return 'Debug';
    }
  }

  /// Icon name/identifier for UI
  String get iconName {
    switch (this) {
      case NotificationType.error:
        return 'error';
      case NotificationType.warning:
        return 'warning';
      case NotificationType.info:
        return 'info';
      case NotificationType.success:
        return 'check_circle';
      case NotificationType.debug:
        return 'bug_report';
    }
  }
}
