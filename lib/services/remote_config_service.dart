import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/enums/ab_test_group.dart';
import 'package:graviton/enums/custom_message_type.dart';
import 'package:graviton/enums/user_behavior_tracking_mode.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Service for managing all Firebase Remote Config features
class RemoteConfigService {
  static RemoteConfigService? _instance;
  static RemoteConfigService get instance =>
      _instance ??= RemoteConfigService._();

  RemoteConfigService._();

  late FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  // Analytics & A/B Testing
  double _analyticsSamplingRate = 0.1;
  bool _crashReportingEnabled = true;
  bool _performanceMonitoringEnabled = true;
  UserBehaviorTrackingMode _userBehaviorTracking =
      UserBehaviorTrackingMode.essential;
  ABTestGroup _abTestGroup = ABTestGroup.control;

  // Maintenance & Communication
  bool _maintenanceMode = false;
  String _maintenanceMessage = '';
  bool _newsBannerEnabled = false;
  String _newsBannerText = '';
  String _emergencyNotification = '';

  // Custom Messages
  bool _customMessageEnabled = false;
  String _customMessageText = '';
  CustomMessageType _customMessageType = CustomMessageType.info;
  String _customMessageTitle = '';
  String _customMessageActionText = '';
  String _customMessageActionUrl = '';
  bool _customMessageDismissible = true;
  bool _customMessagePersistent = false;
  String _customMessageExpiry = '';

  /// Initialize the remote config service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _setDefaults();
      await _fetchAndActivate();
      _loadValues();
      _initialized = true;
    } catch (e) {
      debugPrint('RemoteConfigService initialization failed: $e');
    }
  }

  /// Set default values for all remote config parameters
  Future<void> _setDefaults() async {
    await _remoteConfig.setDefaults({
      // Analytics & A/B Testing
      'analytics_sampling_rate': 0.1,
      'crash_reporting_enabled': true,
      'performance_monitoring_enabled': true,
      'user_behavior_tracking': UserBehaviorTrackingMode.essential.configValue,
      'ab_test_group': ABTestGroup.control.configValue,

      // Maintenance & Communication
      'maintenance_mode': false,
      'maintenance_message': '',
      'news_banner_enabled': false,
      'news_banner_text': '',
      'emergency_notification': '',

      // Custom Messages
      'custom_message_enabled': false,
      'custom_message_text': '',
      'custom_message_type': 'info',
      'custom_message_title': '',
      'custom_message_action_text': '',
      'custom_message_action_url': '',
      'custom_message_dismissible': true,
      'custom_message_persistent': false,
      'custom_message_expiry': '',
    });
  }

  /// Fetch and activate remote config
  Future<void> _fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint('Failed to fetch remote config: $e');
    }
  }

  /// Load all values from remote config
  void _loadValues() {
    // Analytics & A/B Testing
    _analyticsSamplingRate = _remoteConfig.getDouble('analytics_sampling_rate');
    _crashReportingEnabled = _remoteConfig.getBool('crash_reporting_enabled');
    _performanceMonitoringEnabled = _remoteConfig.getBool(
      'performance_monitoring_enabled',
    );
    _userBehaviorTracking = UserBehaviorTrackingModeExtension.fromString(
      _remoteConfig.getString('user_behavior_tracking'),
    );
    _abTestGroup = ABTestGroupExtension.fromString(
      _remoteConfig.getString('ab_test_group'),
    );

    // Maintenance & Communication
    _maintenanceMode = _remoteConfig.getBool('maintenance_mode');
    _maintenanceMessage = _remoteConfig.getString('maintenance_message');
    _newsBannerEnabled = _remoteConfig.getBool('news_banner_enabled');
    _newsBannerText = _remoteConfig.getString('news_banner_text');
    _emergencyNotification = _remoteConfig.getString('emergency_notification');

    // Custom Messages
    _customMessageEnabled = _remoteConfig.getBool('custom_message_enabled');
    _customMessageText = _remoteConfig.getString('custom_message_text');
    _customMessageType = CustomMessageTypeExtension.fromString(
      _remoteConfig.getString('custom_message_type'),
    );
    _customMessageTitle = _remoteConfig.getString('custom_message_title');
    _customMessageActionText = _remoteConfig.getString(
      'custom_message_action_text',
    );
    _customMessageActionUrl = _remoteConfig.getString(
      'custom_message_action_url',
    );
    _customMessageDismissible = _remoteConfig.getBool(
      'custom_message_dismissible',
    );
    _customMessagePersistent = _remoteConfig.getBool(
      'custom_message_persistent',
    );
    _customMessageExpiry = _remoteConfig.getString('custom_message_expiry');
  }

  /// Refresh remote config values
  Future<void> refresh() async {
    if (!_initialized) return;

    try {
      await _fetchAndActivate();
      _loadValues();
    } catch (e) {
      debugPrint('Failed to refresh remote config: $e');
    }
  }

  // Analytics & A/B Testing Getters
  double get analyticsSamplingRate => _analyticsSamplingRate;
  bool get crashReportingEnabled => _crashReportingEnabled;
  bool get performanceMonitoringEnabled => _performanceMonitoringEnabled;
  UserBehaviorTrackingMode get userBehaviorTracking => _userBehaviorTracking;
  ABTestGroup get abTestGroup => _abTestGroup;

  // Maintenance & Communication Getters
  bool get maintenanceMode => _maintenanceMode;
  String get maintenanceMessage => _maintenanceMessage;

  /// Get localized maintenance message with fallback to remote config value
  String getMaintenanceMessage(AppLocalizations l10n) {
    // If remote config provides a custom message, use it
    if (_maintenanceMessage.isNotEmpty) {
      return _maintenanceMessage;
    }
    // Otherwise use localized fallback
    return l10n.scheduledMaintenanceInProgress;
  }

  bool get newsBannerEnabled => _newsBannerEnabled;
  String get newsBannerText => _newsBannerText;
  String get emergencyNotification => _emergencyNotification;

  // Custom Message Getters
  bool get customMessageEnabled => _customMessageEnabled;
  String get customMessageText => _customMessageText;
  CustomMessageType get customMessageType => _customMessageType;
  String get customMessageTitle => _customMessageTitle;
  String get customMessageActionText => _customMessageActionText;
  String get customMessageActionUrl => _customMessageActionUrl;
  bool get customMessageDismissible => _customMessageDismissible;
  bool get customMessagePersistent => _customMessagePersistent;
  String get customMessageExpiry => _customMessageExpiry;

  /// Check if analytics should be sampled for this user
  bool shouldSampleAnalytics() {
    return _analyticsSamplingRate >= 1.0 ||
        (DateTime.now().millisecondsSinceEpoch % 1000) / 1000.0 <
            _analyticsSamplingRate;
  }

  /// Check if user behavior tracking is enabled
  bool get isUserBehaviorTrackingEnabled =>
      _userBehaviorTracking.allowsAnalytics;

  /// Check if enhanced tracking is enabled
  bool get isEnhancedTrackingEnabled =>
      _userBehaviorTracking == UserBehaviorTrackingMode.full;

  /// Check if there's an active notification to show
  bool get hasActiveNotification =>
      _emergencyNotification.isNotEmpty ||
      (_newsBannerEnabled && _newsBannerText.isNotEmpty) ||
      _hasActiveCustomMessage;

  /// Check if there's an active custom message
  bool get _hasActiveCustomMessage {
    if (!_customMessageEnabled || _customMessageText.isEmpty) {
      return false;
    }

    // Check if message has expired
    if (_customMessageExpiry.isNotEmpty) {
      try {
        final expiryDate = DateTime.parse(_customMessageExpiry);
        if (DateTime.now().isAfter(expiryDate)) {
          return false;
        }
      } catch (e) {
        debugPrint('Invalid custom message expiry date: $_customMessageExpiry');
      }
    }

    return true;
  }

  /// Get the current active notification text
  String get activeNotificationText {
    // Emergency notifications take highest priority
    if (_emergencyNotification.isNotEmpty) {
      return _emergencyNotification;
    }

    // Custom messages take priority over news banner
    if (_hasActiveCustomMessage) {
      return _customMessageText;
    }

    // Fall back to news banner
    if (_newsBannerEnabled && _newsBannerText.isNotEmpty) {
      return _newsBannerText;
    }

    return '';
  }

  /// Get the current active notification title
  String get activeNotificationTitle {
    if (_emergencyNotification.isNotEmpty) {
      return ''; // Emergency notifications use default title
    }

    if (_hasActiveCustomMessage && _customMessageTitle.isNotEmpty) {
      return _customMessageTitle;
    }

    return ''; // Use default title for other types
  }

  /// Get the current notification type for styling
  String get activeNotificationType {
    if (_emergencyNotification.isNotEmpty) {
      return 'emergency';
    }

    if (_hasActiveCustomMessage) {
      return _customMessageType.configValue;
    }

    if (_newsBannerEnabled && _newsBannerText.isNotEmpty) {
      return 'news';
    }

    return 'info';
  }

  /// Get the current notification type as enum (preferred over string version)
  CustomMessageType get activeNotificationTypeEnum {
    if (_emergencyNotification.isNotEmpty) {
      return CustomMessageType
          .warning; // Emergency notifications are warning type
    }

    if (_hasActiveCustomMessage) {
      return _customMessageType;
    }

    if (_newsBannerEnabled && _newsBannerText.isNotEmpty) {
      return CustomMessageType.info; // News banners are info type
    }

    return CustomMessageType.info; // Default to info
  }

  /// Check if this is an emergency notification (takes priority)
  bool get isEmergencyNotification => _emergencyNotification.isNotEmpty;

  /// Check if current notification has action button
  bool get hasNotificationAction =>
      _hasActiveCustomMessage &&
      _customMessageActionText.isNotEmpty &&
      _customMessageActionUrl.isNotEmpty;

  /// Check if current notification is dismissible
  bool get isNotificationDismissible {
    if (_emergencyNotification.isNotEmpty) {
      return true; // Emergency notifications are always dismissible
    }

    if (_hasActiveCustomMessage) {
      return _customMessageDismissible;
    }

    return true; // News banners are dismissible by default
  }
}
