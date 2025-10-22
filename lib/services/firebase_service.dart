import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/enums/firebase_event.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/services/remote_config_service.dart';

/// Service class for managing Firebase functionality
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;
  FirebaseRemoteConfig? _remoteConfig;
  bool _isInitialized = false;

  FirebaseAnalytics? get analytics => _analytics;
  FirebaseCrashlytics? get crashlytics => _crashlytics;
  FirebaseRemoteConfig? get remoteConfig => _remoteConfig;
  bool get isInitialized => _isInitialized;

  /// Initialize Firebase services
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Configure Crashlytics
      await _configureCrashlytics();

      // Configure Remote Config
      await _configureRemoteConfig();

      // Mark as initialized before logging
      _isInitialized = true;

      // Log initialization
      await logEventWithEnum(
        FirebaseEvent.appInitialized,
        parameters: {
          'platform': defaultTargetPlatform.name,
          'debug_mode': kDebugMode.toString(),
        },
      );

      debugPrint('Firebase services initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing Firebase services: $e');
      // Don't throw here - app should continue to work without Firebase
      // Only record error if crashlytics was successfully initialized
      try {
        await _crashlytics?.recordError(e, stackTrace, fatal: false);
      } catch (_) {
        // Ignore if crashlytics isn't available
      }
    }
  }

  /// Configure Firebase Crashlytics
  Future<void> _configureCrashlytics() async {
    // Enable Crashlytics collection in release mode only
    await _crashlytics?.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Pass all uncaught errors from the framework to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      _crashlytics?.recordFlutterFatalError(details);
    };

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics?.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Configure Firebase Remote Config
  Future<void> _configureRemoteConfig() async {
    await _remoteConfig?.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 1) // Short interval for development
            : const Duration(hours: 1), // Longer interval for production
      ),
    );

    // Set default values
    await _remoteConfig?.setDefaults(_getDefaultRemoteConfigValues());

    // Fetch and activate
    try {
      await _remoteConfig?.fetchAndActivate();
    } catch (e) {
      debugPrint('Error fetching remote config: $e');
      // Continue with defaults if fetch fails
    }
  }

  /// Get default Remote Config values
  Map<String, dynamic> _getDefaultRemoteConfigValues() {
    return {
      'feature_enhanced_graphics': false,
      'feature_advanced_controls': true,
      'max_simulation_speed': 16.0,
      'min_simulation_speed': 0.1,
      'default_time_scale': 8.0,
      'enable_vibration': true,
      'show_debug_info': kDebugMode,
      'maintenance_mode': false,
      'maintenance_message':
          'The app is currently under maintenance. Please try again later.',
      'force_update_version': '0.0.0',
      'update_message':
          'A new version is available. Please update to continue.',
    };
  }

  /// Log an analytics event with remote config sampling
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (_analytics == null || !_isInitialized) {
      debugPrint('Analytics not available, skipping event: $name');
      return;
    }

    try {
      // Get remote config service instance
      final remoteConfigService = RemoteConfigService.instance;

      // Check if we should sample this event
      if (!remoteConfigService.shouldSampleAnalytics()) {
        debugPrint('Event $name skipped due to sampling rate');
        return;
      }

      // Add A/B test group to parameters if available
      final enhancedParameters = <String, Object>{
        if (parameters != null) ...parameters,
        'ab_test_group': remoteConfigService.abTestGroup,
      };

      await _analytics!.logEvent(name: name, parameters: enhancedParameters);
      debugPrint(
        'Logged analytics event: $name with parameters: $enhancedParameters',
      );
    } catch (e) {
      debugPrint('Error logging analytics event $name: $e');
    }
  }

  /// Log an analytics event with type-safe enum
  Future<void> logEventWithEnum(
    FirebaseEvent event, {
    Map<String, Object>? parameters,
  }) async {
    await logEvent(event.value, parameters: parameters);
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    if (!_isInitialized) {
      debugPrint('Firebase not initialized, skipping screen view: $screenName');
      return;
    }

    try {
      await _analytics?.logScreenView(screenName: screenName);
    } catch (e) {
      debugPrint('Error logging screen view $screenName: $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperty(String name, String? value) async {
    if (!_isInitialized) {
      debugPrint('Firebase not initialized, skipping user property: $name');
      return;
    }

    try {
      await _analytics?.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('Error setting user property $name: $e');
    }
  }

  /// Set user ID for analytics
  Future<void> setUserId(String? userId) async {
    if (!_isInitialized) {
      debugPrint('Firebase not initialized, skipping user ID');
      return;
    }

    try {
      await _analytics?.setUserId(id: userId);
    } catch (e) {
      debugPrint('Error setting user ID: $e');
    }
  }

  /// Record custom error
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics?.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('Error recording crash: $e');
    }
  }

  /// Set custom key for crash reporting
  Future<void> setCrashKey(String key, Object value) async {
    try {
      await _crashlytics?.setCustomKey(key, value);
    } catch (e) {
      debugPrint('Error setting crash key $key: $e');
    }
  }

  /// Get Remote Config value as bool
  bool getRemoteConfigBool(String key) {
    try {
      return _remoteConfig?.getBool(key) ??
          (_getDefaultRemoteConfigValues()[key] as bool? ?? false);
    } catch (e) {
      debugPrint('Error getting remote config bool $key: $e');
      return _getDefaultRemoteConfigValues()[key] as bool? ?? false;
    }
  }

  /// Get Remote Config value as double
  double getRemoteConfigDouble(String key) {
    try {
      return _remoteConfig?.getDouble(key) ??
          (_getDefaultRemoteConfigValues()[key] as double? ?? 0.0);
    } catch (e) {
      debugPrint('Error getting remote config double $key: $e');
      return _getDefaultRemoteConfigValues()[key] as double? ?? 0.0;
    }
  }

  /// Get Remote Config value as string
  String getRemoteConfigString(String key) {
    try {
      return _remoteConfig?.getString(key) ??
          (_getDefaultRemoteConfigValues()[key] as String? ?? '');
    } catch (e) {
      debugPrint('Error getting remote config string $key: $e');
      return _getDefaultRemoteConfigValues()[key] as String? ?? '';
    }
  }

  /// Force refresh Remote Config
  Future<bool> refreshRemoteConfig() async {
    try {
      return await _remoteConfig?.fetchAndActivate() ?? false;
    } catch (e) {
      debugPrint('Error refreshing remote config: $e');
      return false;
    }
  }

  /// Simulation specific analytics
  Future<void> logSimulationEvent(
    String action, {
    String? scenario,
    double? timeScale,
    int? stepCount,
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'action': action,
      if (scenario != null) 'scenario': scenario,
      if (timeScale != null) 'time_scale': timeScale,
      if (stepCount != null) 'step_count': stepCount,
      ...?additionalParams,
    };

    await logEvent('simulation_$action', parameters: params);
  }

  /// UI interaction analytics
  Future<void> logUIEvent(
    String action, {
    String? element,
    String? value,
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'action': action,
      if (element != null) 'element': element,
      if (value != null) 'value': value,
      ...?additionalParams,
    };

    await logEvent('ui_$action', parameters: params);
  }

  /// UI interaction analytics with type-safe enums
  Future<void> logUIEventWithEnums(
    UIAction action, {
    UIElement? element,
    String? value,
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'action': action.value,
      if (element != null) 'element': element.value,
      if (value != null) 'value': value,
      ...?additionalParams,
    };

    await logEvent('ui_${action.value}', parameters: params);
  }

  /// Settings change analytics
  Future<void> logSettingsChange(String setting, Object value) async {
    await logEventWithEnum(
      FirebaseEvent.settingsChanged,
      parameters: {'setting': setting, 'value': value.toString()},
    );
  }

  /// Performance analytics
  Future<void> logPerformanceEvent(
    String metric, {
    double? value,
    String? unit,
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'metric': metric,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      ...?additionalParams,
    };

    await logEventWithEnum(FirebaseEvent.performanceMetric, parameters: params);
  }

  /// Error analytics
  Future<void> logErrorEvent(
    String errorType, {
    String? errorMessage,
    String? context,
    Map<String, Object>? additionalParams,
  }) async {
    final params = <String, Object>{
      'error_type': errorType,
      if (errorMessage != null) 'error_message': errorMessage,
      if (context != null) 'context': context,
      ...?additionalParams,
    };

    await logEventWithEnum(FirebaseEvent.appError, parameters: params);
  }
}
