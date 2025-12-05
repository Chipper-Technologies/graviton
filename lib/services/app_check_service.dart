import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/services/remote_config_service.dart';
import 'package:graviton/utils/platform_utils.dart';

/// Service for managing Firebase App Check
///
/// App Check protects Firebase backend resources (Firestore, Cloud Functions,
/// Storage, Remote Config) from abuse by ensuring requests come from legitimate
/// instances of your app.
///
/// Platform Support:
/// - Android: Uses Play Integrity API (requires Google Play Services)
/// - iOS: Uses DeviceCheck API (requires iOS 11+)
/// - Web: Uses reCAPTCHA v3
/// - Debug: Uses debug token provider for development/testing
class AppCheckService {
  static final AppCheckService _instance = AppCheckService._internal();
  static AppCheckService get instance => _instance;

  AppCheckService._internal();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initialize Firebase App Check
  ///
  /// This should be called after Firebase.initializeApp() but before
  /// accessing any Firebase services.
  ///
  /// In production:
  /// - Android uses Play Integrity API
  /// - iOS uses DeviceCheck API
  /// - Web uses reCAPTCHA v3
  ///
  /// In debug mode:
  /// - Uses debug token provider
  /// - Requires debug token from Firebase Console
  ///
  /// Example:
  /// ```dart
  /// await Firebase.initializeApp();
  /// await AppCheckService.instance.initialize();
  /// // Now safe to use Firestore, Functions, etc.
  /// ```
  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('AppCheckService: Already initialized');
      return;
    }

    // Check if App Check is enabled via Remote Config
    final remoteConfig = RemoteConfigService.instance;
    if (remoteConfig.appCheckEnabled == false) {
      debugPrint('AppCheckService: Disabled via Remote Config');
      return;
    }

    try {
      if (kDebugMode) {
        // Debug mode - use debug token provider
        debugPrint('AppCheckService: Initializing in DEBUG mode');
        await FirebaseAppCheck.instance.activate(
          // Debug provider for development
          providerAndroid: AndroidDebugProvider(),
          providerApple: AppleDebugProvider(),
          providerWeb: ReCaptchaV3Provider('debug-recaptcha-key'),
        );
        debugPrint('AppCheckService: Debug mode activated');
        debugPrint(
          'AppCheckService: Get debug token from console: '
          'https://console.firebase.google.com/project/_/appcheck/apps',
        );
      } else {
        // Production mode - use platform-specific providers
        debugPrint('AppCheckService: Initializing in PRODUCTION mode');

        if (PlatformUtils.isAndroid) {
          // Android uses Play Integrity API
          await FirebaseAppCheck.instance.activate(
            providerAndroid: AndroidPlayIntegrityProvider(),
          );
          debugPrint('AppCheckService: Android Play Integrity activated');
        } else if (PlatformUtils.isIOS || PlatformUtils.isMacOS) {
          // iOS/macOS uses DeviceCheck API
          await FirebaseAppCheck.instance.activate(
            providerApple: AppleDeviceCheckProvider(),
          );
          debugPrint('AppCheckService: iOS/macOS DeviceCheck activated');
        } else {
          // Web or other platforms
          const recaptchaSiteKey = String.fromEnvironment(
            'firebase.recaptchaSiteKey',
            defaultValue: '',
          );

          if (recaptchaSiteKey.isEmpty) {
            debugPrint(
              'AppCheckService: Warning - No reCAPTCHA site key configured for web',
            );
            // Still activate with empty key to maintain compatibility
            await FirebaseAppCheck.instance.activate(
              providerWeb: ReCaptchaV3Provider(recaptchaSiteKey),
            );
          } else {
            await FirebaseAppCheck.instance.activate(
              providerWeb: ReCaptchaV3Provider(recaptchaSiteKey),
            );
            debugPrint('AppCheckService: Web reCAPTCHA v3 activated');
          }
        }
      }

      _initialized = true;
      debugPrint('AppCheckService: Initialization complete');
    } catch (e) {
      debugPrint('AppCheckService: Initialization failed: $e');
      // Don't rethrow - allow app to continue without App Check
      // Firebase services will still work, just without protection
    }
  }

  /// Get the current App Check token
  ///
  /// Returns null if App Check is not initialized or token fetch fails.
  ///
  /// Example:
  /// ```dart
  /// final token = await AppCheckService.instance.getToken();
  /// if (token != null) {
  ///   print('App Check token: ${token.substring(0, 20)}...');
  /// }
  /// ```
  Future<String?> getToken({bool forceRefresh = false}) async {
    if (!_initialized) {
      debugPrint('AppCheckService: Cannot get token - not initialized');
      return null;
    }

    try {
      final token = await FirebaseAppCheck.instance.getToken(forceRefresh);
      return token;
    } catch (e) {
      debugPrint('AppCheckService: Failed to get token: $e');
      return null;
    }
  }

  /// Enable or disable token auto-refresh
  ///
  /// When enabled, App Check will automatically refresh tokens before
  /// they expire.
  ///
  /// Example:
  /// ```dart
  /// AppCheckService.instance.setTokenAutoRefreshEnabled(true);
  /// ```
  void setTokenAutoRefreshEnabled(bool enabled) {
    try {
      FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(enabled);
      debugPrint(
        'AppCheckService: Token auto-refresh ${enabled ? "enabled" : "disabled"}',
      );
    } catch (e) {
      debugPrint('AppCheckService: Failed to set auto-refresh: $e');
    }
  }

  /// Check if App Check is available on this platform
  ///
  /// Returns true if the platform supports App Check.
  bool isPlatformSupported() {
    return PlatformUtils.isAndroid ||
        PlatformUtils.isIOS ||
        PlatformUtils.isMacOS ||
        kIsWeb;
  }

  /// Reset the service (primarily for testing)
  void reset() {
    _initialized = false;
    debugPrint('AppCheckService: Reset complete');
  }
}
