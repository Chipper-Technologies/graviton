import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graviton/core/enums/firebase_event.dart';
import 'package:graviton/core/enums/premium_tier.dart';
import 'package:graviton/features/premium/data/premium_service.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/data/usage_tracking_service.dart';
import 'package:graviton/features/premium/domain/premium_limits.dart';
import 'package:graviton/features/premium/domain/premium_pricing.dart';
import 'package:graviton/features/premium/domain/usage_data.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// State provider for premium subscription management
///
/// Provides reactive access to premium status, usage data, and subscription
/// functionality. Integrates with [PremiumService] and [UsageTrackingService].
class PremiumState extends ChangeNotifier {
  final PremiumService _premiumService;
  final UsageTrackingService _usageService;

  bool _isLoading = false;
  String? _error;
  Timer? _sessionTimer;
  Duration _remainingSessionTime = Duration.zero;
  bool _sessionExpired = false;

  /// Callback when session expires
  VoidCallback? onSessionExpired;

  /// Create a new premium state
  PremiumState({
    PremiumService? premiumService,
    UsageTrackingService? usageService,
  }) : _premiumService = premiumService ?? PremiumService.instance,
       _usageService = usageService ?? UsageTrackingService.instance;

  /// Whether the service is loading
  bool get isLoading => _isLoading;

  /// Current error message
  String? get error => _error;

  /// Current premium tier
  PremiumTier get tier => _premiumService.currentTier;

  /// Whether user has premium access
  bool get hasPremiumAccess => _premiumService.hasPremiumAccess;

  /// Whether user is on free tier
  bool get isFreeTier => tier == PremiumTier.free;

  /// Current usage limits
  PremiumLimits get limits => _premiumService.limits;

  /// Current pricing (with any user discounts applied)
  PremiumPricing get pricing => _premiumService.pricing;

  /// Current usage data
  UsageData get usageData => _usageService.usageData;

  /// Remaining session time for free users
  Duration get remainingSessionTime => _remainingSessionTime;

  /// Whether session has expired
  bool get sessionExpired => _sessionExpired;

  /// Whether user can start a new session
  bool get canStartSession {
    if (hasPremiumAccess) return true;
    return _usageService.canStartSession(limits.freeSessionsPerDay);
  }

  /// Number of sessions remaining today
  int get sessionsRemainingToday {
    if (hasPremiumAccess) return -1; // Unlimited
    return (limits.freeSessionsPerDay - usageData.sessionsHostedToday).clamp(
      0,
      limits.freeSessionsPerDay,
    );
  }

  /// Whether duration limit has been exceeded
  bool get hasExceededDurationLimit {
    if (hasPremiumAccess) return false;
    return _usageService.hasExceededDurationLimit(
      limits.freeSessionDurationMinutes,
    );
  }

  /// Maximum viewers allowed
  int get maxViewers {
    return hasPremiumAccess ? limits.premiumMaxViewers : limits.freeMaxViewers;
  }

  /// Available subscription packages
  ///
  /// On web, RevenueCat offerings are not available and this will return `null`.
  Offerings? get offerings {
    if (kIsWeb) {
      return null;
    }
    return _premiumService.offerings;
  }

  /// Monthly package
  ///
  /// On web, RevenueCat packages are not available and this will return `null`.
  Package? get monthlyPackage {
    if (kIsWeb) {
      return null;
    }
    return _premiumService.monthlyPackage;
  }

  /// Annual package
  ///
  /// On web, RevenueCat packages are not available and this will return `null`.
  Package? get annualPackage {
    if (kIsWeb) {
      return null;
    }
    return _premiumService.annualPackage;
  }

  /// Lifetime package
  ///
  /// On web, RevenueCat packages are not available and this will return `null`.
  Package? get lifetimePackage {
    if (kIsWeb) {
      return null;
    }
    return _premiumService.lifetimePackage;
  }

  /// Initialize the premium state
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    try {
      await _premiumService.initialize();
      await _usageService.initialize();
      _updateRemainingTime();
    } catch (e) {
      _setError('Failed to initialize premium: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Login user
  Future<void> login(String userId) async {
    await _premiumService.login(userId);
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    await _premiumService.logout();
    notifyListeners();
  }

  /// Refresh premium status from server
  ///
  /// This is useful after a web Stripe purchase to verify the updated status.
  Future<void> refreshPremiumStatus() async {
    _setLoading(true);
    try {
      // Re-initialize to refresh status
      await _premiumService.initialize();
      _updateRemainingTime();
    } catch (e) {
      _setError('Failed to refresh premium status: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Check if a feature requires premium
  bool doesFeatureRequirePremium(PremiumFeature feature) {
    return _premiumService.doesFeatureRequirePremium(feature);
  }

  /// Check if user can use a feature
  bool canUseFeature(PremiumFeature feature) {
    return _premiumService.canUseFeature(feature);
  }

  /// Start tracking a session
  void startSessionTracking() {
    _usageService.startSession();
    _startSessionTimer();
    notifyListeners();

    // Log analytics
    if (!hasPremiumAccess) {
      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.freeSessionStarted,
        parameters: {
          'sessions_today': usageData.sessionsHostedToday,
          'tier': tier.name,
        },
      );
    }
  }

  /// Stop tracking a session
  void stopSessionTracking() {
    final wasActive = usageData.isInSession;
    _usageService.endSession();
    _stopSessionTimer();
    notifyListeners();

    // Log analytics
    if (!hasPremiumAccess && wasActive) {
      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.freeSessionEnded,
        parameters: {
          'duration_seconds':
              limits.freeSessionDurationMinutes * 60 -
              _remainingSessionTime.inSeconds,
          'tier': tier.name,
        },
      );
    }
  }

  /// Start the session countdown timer
  void _startSessionTimer() {
    if (hasPremiumAccess) return;

    _sessionExpired = false;
    _updateRemainingTime();
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemainingTime();

      if (_remainingSessionTime.inSeconds <= 0 && !_sessionExpired) {
        _sessionExpired = true;
        _stopSessionTimer();
        onSessionExpired?.call();

        // Log session expired
        FirebaseService.instance.logEventWithEnum(
          FirebaseEvent.freeSessionEnded,
          parameters: {'reason': 'expired', 'tier': tier.name},
        );
      }
    });
  }

  /// Stop the session timer
  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// Reset session expired state (call when starting a new session)
  void resetSessionExpired() {
    _sessionExpired = false;
    notifyListeners();
  }

  /// Update remaining session time
  void _updateRemainingTime() {
    final remainingSeconds = _usageService.getRemainingSessionTime(
      limits.freeSessionDurationMinutes,
    );
    _remainingSessionTime = Duration(seconds: remainingSeconds);
    notifyListeners();
  }

  /// Purchase a subscription package
  Future<bool> purchasePackage(Package package) async {
    _setLoading(true);
    _clearError();

    // Log purchase started
    FirebaseService.instance.logEventWithEnum(
      FirebaseEvent.purchaseStarted,
      parameters: {
        'package_id': package.identifier,
        'product_id': package.storeProduct.identifier,
        'price': package.storeProduct.priceString,
      },
    );

    try {
      final success = await _premiumService.purchasePackage(package);
      notifyListeners();

      if (success) {
        // Log purchase completed
        FirebaseService.instance.logEventWithEnum(
          FirebaseEvent.purchaseCompleted,
          parameters: {
            'package_id': package.identifier,
            'product_id': package.storeProduct.identifier,
            'new_tier': tier.name,
          },
        );
      } else {
        // Log purchase cancelled
        FirebaseService.instance.logEventWithEnum(
          FirebaseEvent.purchaseCancelled,
          parameters: {'package_id': package.identifier},
        );
      }

      return success;
    } catch (e) {
      _setError('Purchase failed: $e');

      // Log purchase failed
      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.purchaseFailed,
        parameters: {'package_id': package.identifier, 'error': e.toString()},
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    _setLoading(true);
    _clearError();

    // Log restore started
    FirebaseService.instance.logEventWithEnum(
      FirebaseEvent.purchaseRestoreStarted,
    );

    try {
      final success = await _premiumService.restorePurchases();
      notifyListeners();

      if (success) {
        // Log restore completed
        FirebaseService.instance.logEventWithEnum(
          FirebaseEvent.purchaseRestoreCompleted,
          parameters: {'new_tier': tier.name},
        );
      }

      return success;
    } catch (e) {
      _setError('Restore failed: $e');

      // Log restore failed
      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.purchaseRestoreFailed,
        parameters: {'error': e.toString()},
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Format remaining time as string
  String formatRemainingTime() {
    final minutes = _remainingSessionTime.inMinutes;
    final seconds = _remainingSessionTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Whether to show session time warning (under 2 minutes)
  bool get shouldShowTimeWarning {
    if (hasPremiumAccess) return false;
    return _remainingSessionTime.inSeconds > 0 &&
        _remainingSessionTime.inMinutes < 2;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    _stopSessionTimer();
    super.dispose();
  }
}
