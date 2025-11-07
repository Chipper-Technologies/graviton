/// Enum representing different types of custom messages
enum CustomMessageType {
  info,
  warning,
  success,
  announcement,
  promotion,
  update;

  /// Get the config value for remote config
  String get configValue {
    switch (this) {
      case CustomMessageType.info:
        return 'info';
      case CustomMessageType.warning:
        return 'warning';
      case CustomMessageType.success:
        return 'success';
      case CustomMessageType.announcement:
        return 'announcement';
      case CustomMessageType.promotion:
        return 'promotion';
      case CustomMessageType.update:
        return 'update';
    }
  }

  /// Get display name for the message type
  String get displayName {
    switch (this) {
      case CustomMessageType.info:
        return 'Info';
      case CustomMessageType.warning:
        return 'Warning';
      case CustomMessageType.success:
        return 'Success';
      case CustomMessageType.announcement:
        return 'Announcement';
      case CustomMessageType.promotion:
        return 'Promotion';
      case CustomMessageType.update:
        return 'Update';
    }
  }

  /// Get localization key for the message type title
  String get localizationKey {
    switch (this) {
      case CustomMessageType.info:
        return 'newsTitle'; // Info messages use newsTitle
      case CustomMessageType.warning:
        return 'warningTitle';
      case CustomMessageType.success:
        return 'successTitle';
      case CustomMessageType.announcement:
        return 'announcementTitle';
      case CustomMessageType.promotion:
        return 'promotionTitle';
      case CustomMessageType.update:
        return 'updateRequiredTitle';
    }
  }
}

/// Extension for parsing CustomMessageType from string
extension CustomMessageTypeExtension on CustomMessageType {
  static CustomMessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'warning':
        return CustomMessageType.warning;
      case 'success':
        return CustomMessageType.success;
      case 'announcement':
        return CustomMessageType.announcement;
      case 'promotion':
        return CustomMessageType.promotion;
      case 'update':
        return CustomMessageType.update;
      case 'info':
      default:
        return CustomMessageType.info;
    }
  }
}
