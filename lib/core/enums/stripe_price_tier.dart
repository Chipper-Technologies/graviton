/// Stripe payment tier identifiers
///
/// Used for web payments through Stripe Checkout.
/// Each tier corresponds to a price ID configured in the Stripe Dashboard.
enum StripePriceTier {
  /// Monthly subscription
  monthly,

  /// Yearly subscription
  yearly,

  /// Lifetime one-time purchase
  lifetime,
}
