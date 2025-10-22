import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

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
  String _userBehaviorTracking = 'standard';
  String _abTestGroup = 'control';

  // Maintenance & Communication
  bool _maintenanceMode = false;
  String _maintenanceMessage = 'Scheduled maintenance in progress';
  bool _newsBannerEnabled = false;
  String _newsBannerText = '';
  String _emergencyNotification = '';

  /// Initialize the remote config service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _setDefaults();
      await _fetchAndActivate();
      _loadValues();
      _initialized = true;
      debugPrint('RemoteConfigService initialized successfully');
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
      'user_behavior_tracking': 'standard',
      'ab_test_group': 'control',

      // Maintenance & Communication
      'maintenance_mode': false,
      'maintenance_message': 'Scheduled maintenance in progress',
      'news_banner_enabled': false,
      'news_banner_text': '',
      'emergency_notification': '',
    });
  }

  /// Fetch and activate remote config
  Future<void> _fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      debugPrint('Remote config fetched and activated');
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
    _userBehaviorTracking = _remoteConfig.getString('user_behavior_tracking');
    _abTestGroup = _remoteConfig.getString('ab_test_group');

    // Maintenance & Communication
    _maintenanceMode = _remoteConfig.getBool('maintenance_mode');
    _maintenanceMessage = _remoteConfig.getString('maintenance_message');
    _newsBannerEnabled = _remoteConfig.getBool('news_banner_enabled');
    _newsBannerText = _remoteConfig.getString('news_banner_text');
    _emergencyNotification = _remoteConfig.getString('emergency_notification');

    debugPrint(
      'Remote config values loaded: '
      'analytics_rate=$_analyticsSamplingRate, '
      'maintenance=$_maintenanceMode, '
      'news_banner=$_newsBannerEnabled, '
      'ab_test=$_abTestGroup',
    );
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
  String get userBehaviorTracking => _userBehaviorTracking;
  String get abTestGroup => _abTestGroup;

  // Maintenance & Communication Getters
  bool get maintenanceMode => _maintenanceMode;
  String get maintenanceMessage => _maintenanceMessage;
  bool get newsBannerEnabled => _newsBannerEnabled;
  String get newsBannerText => _newsBannerText;
  String get emergencyNotification => _emergencyNotification;

  /// Check if analytics should be sampled for this user
  bool shouldSampleAnalytics() {
    return _analyticsSamplingRate >= 1.0 ||
        (DateTime.now().millisecondsSinceEpoch % 1000) / 1000.0 <
            _analyticsSamplingRate;
  }

  /// Check if user behavior tracking is enabled
  bool get isUserBehaviorTrackingEnabled => _userBehaviorTracking != 'disabled';

  /// Check if enhanced tracking is enabled
  bool get isEnhancedTrackingEnabled => _userBehaviorTracking == 'enhanced';

  /// Check if there's an active notification to show
  bool get hasActiveNotification =>
      _emergencyNotification.isNotEmpty ||
      (_newsBannerEnabled && _newsBannerText.isNotEmpty);

  /// Get the current active notification text
  String get activeNotificationText {
    if (_emergencyNotification.isNotEmpty) {
      return _emergencyNotification;
    }
    if (_newsBannerEnabled && _newsBannerText.isNotEmpty) {
      return _newsBannerText;
    }
    return '';
  }

  /// Check if this is an emergency notification (takes priority)
  bool get isEmergencyNotification => _emergencyNotification.isNotEmpty;
}
