import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/constants/premium_constants.dart';
import 'package:graviton/core/enums/premium_tier.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/domain/premium_limits.dart';
import 'package:graviton/features/premium/domain/premium_pricing.dart';
import 'package:graviton/services/firebase/remote_config_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Service for managing premium subscriptions via RevenueCat
///
/// Handles subscription status, purchases, and entitlement checks.
/// Integrates with Remote Config for dynamic pricing and limits.
class PremiumService {
  static PremiumService? _instance;
  static PremiumService get instance => _instance ??= PremiumService._();

  PremiumService._();

  bool _initialized = false;
  PremiumTier _currentTier = PremiumTier.free;
  CustomerInfo? _customerInfo;
  Offerings? _offerings;
  String? _currentUserId;

  /// Whether the service is initialized
  bool get isInitialized => _initialized;

  /// Current premium tier
  PremiumTier get currentTier => _currentTier;

  /// Whether user has premium access
  ///
  /// Returns true if:
  /// - User has a premium/lifetime subscription, OR
  /// - Paywall is globally disabled AND user is authenticated
  bool get hasPremiumAccess {
    // Check for actual subscription
    if (_currentTier.hasPremiumAccess) return true;

    // Check if paywall is globally disabled for authenticated users
    if (RemoteConfigService.instance.premiumPaywallDisabled &&
        _currentUserId != null) {
      return true;
    }

    return false;
  }

  /// Current customer info from RevenueCat
  CustomerInfo? get customerInfo => _customerInfo;

  /// Available offerings
  Offerings? get offerings => _offerings;

  /// Get premium limits from Remote Config
  PremiumLimits get limits => RemoteConfigService.instance.premiumLimits;

  /// Get premium pricing from Remote Config (with user discounts applied)
  PremiumPricing get pricing =>
      RemoteConfigService.instance.getPricingForUser(_currentUserId);

  /// Initialize the premium service
  Future<void> initialize() async {
    if (_initialized) return;

    // Skip RevenueCat initialization on web (use Stripe instead)
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    try {
      // Configure RevenueCat
      final configuration = PurchasesConfiguration(_getApiKey());
      await Purchases.configure(configuration);

      // Get initial customer info
      await _refreshCustomerInfo();

      // Listen for customer info changes
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);

      _initialized = true;
      debugPrint('PremiumService initialized');
    } catch (e) {
      debugPrint('PremiumService initialization failed: $e');
      _initialized = true; // Mark as initialized even on failure
    }
  }

  /// Get the appropriate API key based on platform
  ///
  /// Reads from config file (revenuecat.apiKey).
  /// Throws if not configured.
  String _getApiKey() {
    final configKey = AppConfig.revenueCatApiKey;
    if (configKey.isEmpty) {
      throw StateError(
        'RevenueCat API key not configured. '
        'Add revenuecat.apiKey to your config file.',
      );
    }
    return configKey;
  }

  /// Handle customer info updates
  void _onCustomerInfoUpdated(CustomerInfo info) {
    _customerInfo = info;
    _updateTierFromCustomerInfo();
  }

  /// Refresh customer info from RevenueCat
  Future<void> _refreshCustomerInfo() async {
    if (kIsWeb) return;

    try {
      _customerInfo = await Purchases.getCustomerInfo();
      _updateTierFromCustomerInfo();
      await _fetchOfferings();
    } catch (e) {
      debugPrint('Failed to refresh customer info: $e');
    }
  }

  /// Update tier based on customer entitlements
  void _updateTierFromCustomerInfo() {
    if (_customerInfo == null) {
      _currentTier = PremiumTier.free;
      return;
    }

    final entitlements = _customerInfo!.entitlements.active;

    if (entitlements.containsKey(PremiumConstants.lifetimeEntitlementId)) {
      _currentTier = PremiumTier.lifetime;
    } else if (entitlements.containsKey(
      PremiumConstants.premiumEntitlementId,
    )) {
      _currentTier = PremiumTier.premium;
    } else {
      _currentTier = PremiumTier.free;
    }
  }

  /// Fetch available offerings
  Future<void> _fetchOfferings() async {
    if (kIsWeb) return;

    try {
      _offerings = await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Failed to fetch offerings: $e');
    }
  }

  /// Login user to RevenueCat
  Future<void> login(String userId) async {
    if (kIsWeb) {
      _currentUserId = userId;
      return;
    }

    try {
      _currentUserId = userId;
      final result = await Purchases.logIn(userId);
      _customerInfo = result.customerInfo;
      _updateTierFromCustomerInfo();
    } catch (e) {
      debugPrint('Failed to login to RevenueCat: $e');
    }
  }

  /// Logout user from RevenueCat
  Future<void> logout() async {
    if (kIsWeb) {
      _currentUserId = null;
      _currentTier = PremiumTier.free;
      return;
    }

    try {
      _currentUserId = null;
      _customerInfo = await Purchases.logOut();
      _updateTierFromCustomerInfo();
    } catch (e) {
      debugPrint('Failed to logout from RevenueCat: $e');
    }
  }

  /// Purchase a subscription package
  Future<bool> purchasePackage(Package package) async {
    if (kIsWeb) {
      // Web uses Stripe - handled separately
      return false;
    }

    try {
      // ignore: deprecated_member_use
      final result = await Purchases.purchasePackage(package);
      _customerInfo = result.customerInfo;
      _updateTierFromCustomerInfo();
      return hasPremiumAccess;
    } on PurchasesErrorCode catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }

  /// Restore previous purchases
  Future<bool> restorePurchases() async {
    if (kIsWeb) {
      // Web uses Stripe - handled separately
      return false;
    }

    try {
      _customerInfo = await Purchases.restorePurchases();
      _updateTierFromCustomerInfo();
      return hasPremiumAccess;
    } catch (e) {
      debugPrint('Restore purchases failed: $e');
      return false;
    }
  }

  /// Get the monthly subscription package
  Package? get monthlyPackage {
    return _offerings?.current?.monthly;
  }

  /// Get the annual subscription package
  Package? get annualPackage {
    return _offerings?.current?.annual;
  }

  /// Get the lifetime package
  Package? get lifetimePackage {
    return _offerings?.current?.lifetime;
  }

  /// Check if a feature requires premium
  bool doesFeatureRequirePremium(PremiumFeature feature) {
    switch (feature) {
      case PremiumFeature.cameraSync:
        return limits.cameraSyncRequiresPremium;
      case PremiumFeature.passwordProtection:
        return limits.passwordRequiresPremium;
      case PremiumFeature.unlimitedSessionDuration:
      case PremiumFeature.unlimitedViewers:
      case PremiumFeature.unlimitedSessionsPerDay:
        return true;
    }
  }

  /// Check if user can use a premium feature
  bool canUseFeature(PremiumFeature feature) {
    if (hasPremiumAccess) return true;
    return !doesFeatureRequirePremium(feature);
  }

  /// Reset for testing purposes
  @visibleForTesting
  static void resetInstance() {
    _instance = null;
  }

  /// Set instance for testing
  @visibleForTesting
  static void setInstance(PremiumService service) {
    _instance = service;
  }
}
