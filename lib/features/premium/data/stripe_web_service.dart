import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/enums/firebase_event.dart';
import 'package:graviton/core/enums/stripe_price_tier.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for handling Stripe web payments
///
/// This service handles premium subscription purchases on web using Stripe
/// Checkout. It works by redirecting users to Stripe-hosted checkout pages
/// using Payment Links configured in the Stripe Dashboard.
///
/// ## Setup Required
/// 1. Create payment links in Stripe Dashboard for each tier
/// 2. Configure the price IDs in config/prod-web.json
/// 3. Set up webhooks to update Firebase Auth custom claims
///
/// ## Usage
/// ```dart
/// final success = await StripeWebService.launchCheckout(
///   tier: StripePriceTier.yearly,
///   userId: 'firebase-user-id',
/// );
/// ```
class StripeWebService {
  StripeWebService._();

  /// Whether Stripe is properly configured
  static bool get isConfigured {
    return AppConfig.stripeMonthlyPaymentLink.isNotEmpty &&
        AppConfig.stripeYearlyPaymentLink.isNotEmpty &&
        AppConfig.stripeLifetimePaymentLink.isNotEmpty;
  }

  /// Get the Stripe Payment Link URL for a tier
  ///
  /// Payment Links should be created in Stripe Dashboard.
  /// These URLs look like: https://buy.stripe.com/xxx
  static String getPaymentLink(StripePriceTier tier) {
    switch (tier) {
      case StripePriceTier.monthly:
        return AppConfig.stripeMonthlyPaymentLink;
      case StripePriceTier.yearly:
        return AppConfig.stripeYearlyPaymentLink;
      case StripePriceTier.lifetime:
        return AppConfig.stripeLifetimePaymentLink;
    }
  }

  /// Get the Stripe price ID for a tier (for analytics/logging)
  @Deprecated('Use getPaymentLink instead for checkout URLs')
  static String getPriceId(StripePriceTier tier) {
    // Extract price ID from payment link URL or return tier name
    return tier.name;
  }

  /// Get the checkout URL for a tier
  ///
  /// This constructs a Stripe Payment Link URL. Payment Links should be
  /// created in the Stripe Dashboard with the following settings:
  /// - Allow promotional codes: Yes
  /// - Collect email: Required
  /// - Collect customer address: No
  /// - After payment: Redirect to app URL
  ///
  /// The [userId] is passed as client_reference_id to link the purchase
  /// to the Firebase user.
  static Uri getCheckoutUrl({
    required StripePriceTier tier,
    required String userId,
    String? email,
  }) {
    final paymentLink = getPaymentLink(tier);

    // Build query parameters for the Payment Link
    // Stripe Payment Links support these query parameters:
    // - client_reference_id: Links purchase to your user
    // - prefilled_email: Pre-fills the customer's email
    final queryParams = <String, String>{
      'client_reference_id': userId,
      if (email != null) 'prefilled_email': email,
    };

    // Use the Payment Link URL directly from config
    // These are created in Stripe Dashboard > Payment Links
    // and look like: https://buy.stripe.com/xyz123
    return Uri.parse(paymentLink).replace(queryParameters: queryParams);
  }

  /// Launch Stripe Checkout for a purchase
  ///
  /// Opens the Stripe-hosted checkout page in the browser.
  /// Returns true if the checkout was launched successfully.
  ///
  /// Note: The actual purchase verification happens via webhooks.
  /// After the user completes payment, Stripe sends a webhook to
  /// the backend which updates the user's premium status.
  static Future<bool> launchCheckout({
    required StripePriceTier tier,
    required String userId,
    String? email,
  }) async {
    if (!kIsWeb) {
      debugPrint('StripeWebService is only available on web');
      return false;
    }

    if (!isConfigured) {
      debugPrint('Stripe is not configured. Check config files.');
      return false;
    }

    final url = getCheckoutUrl(tier: tier, userId: userId, email: email);

    try {
      // Log checkout initiated
      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.stripePurchaseInitiated,
        parameters: {'tier': tier.name},
      );

      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint('Failed to launch Stripe checkout URL: $url');
        FirebaseService.instance.logEventWithEnum(
          FirebaseEvent.stripePurchaseFailed,
          parameters: {'reason': 'launch_failed'},
        );
      }

      return launched;
    } catch (e) {
      debugPrint('Error launching Stripe checkout: $e');
      FirebaseService.instance.logEventWithEnum(
        FirebaseEvent.stripePurchaseFailed,
        parameters: {'reason': e.toString()},
      );
      return false;
    }
  }

  /// Verify purchase status after checkout
  ///
  /// This should be called after the user returns from Stripe Checkout
  /// to check if their purchase was successful. The actual verification
  /// is done by refreshing the user's ID token, which contains the
  /// updated custom claims set by the webhook handler.
  static Future<bool> verifyPurchase() async {
    if (!kIsWeb) return false;

    try {
      // Force refresh the Firebase ID token to get updated custom claims
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // Force refresh token to get updated claims
      await user.getIdToken(true);
      final idTokenResult = await user.getIdTokenResult(true);

      // Check if premium claim is set
      final claims = idTokenResult.claims;
      final isPremium = claims?['premium'] == true;

      if (isPremium) {
        FirebaseService.instance.logEventWithEnum(
          FirebaseEvent.stripePurchaseCompleted,
        );
      }

      return isPremium;
    } catch (e) {
      debugPrint('Error verifying Stripe purchase: $e');
      return false;
    }
  }
}
