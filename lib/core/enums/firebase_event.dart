/// Firebase Analytics event names for consistent logging
///
/// This enum provides type safety and consistency for Firebase Analytics
/// event names throughout the application.
enum FirebaseEvent {
  /// Application lifecycle events
  appInitialized('app_initialized'),
  appStart('app_start'),
  appError('app_error'),

  /// Simulation lifecycle events
  simulationStarted('simulation_started'),
  simulationPaused('simulation_paused'),
  simulationResumed('simulation_resumed'),
  simulationStopped('simulation_stopped'),
  simulationReset('simulation_reset'),

  /// Sharing events
  simulationShared('simulation_shared'),
  simulationImageShared('simulation_image_shared'),
  simulationStateShared('simulation_state_shared'),
  shareDialogOpened('share_dialog_opened'),
  shareCancelled('share_cancelled'),
  shareFailed('share_failed'),

  /// Settings and configuration events
  settingsChanged('settings_changed'),

  /// Performance monitoring events
  performanceMetric('performance_metric'),

  /// Premium and subscription events
  paywallOpened('paywall_opened'),
  paywallClosed('paywall_closed'),
  purchaseStarted('purchase_started'),
  purchaseCompleted('purchase_completed'),
  purchaseFailed('purchase_failed'),
  purchaseCancelled('purchase_cancelled'),
  purchaseRestoreStarted('purchase_restore_started'),
  purchaseRestoreCompleted('purchase_restore_completed'),
  purchaseRestoreFailed('purchase_restore_failed'),
  subscriptionExpired('subscription_expired'),
  trialStarted('trial_started'),
  trialConverted('trial_converted'),
  premiumFeatureAccessed('premium_feature_accessed'),
  premiumFeatureBlocked('premium_feature_blocked'),
  sessionLimitReached('session_limit_reached'),
  durationLimitReached('duration_limit_reached'),
  freeSessionStarted('free_session_started'),
  freeSessionEnded('free_session_ended'),

  /// Stripe web payment events
  stripePurchaseInitiated('stripe_purchase_initiated'),
  stripePurchaseCompleted('stripe_purchase_completed'),
  stripePurchaseFailed('stripe_purchase_failed'),

  /// UI interaction events (prefixed dynamically)
  uiInteraction('ui_'), // Base prefix for UI events

  /// Simulation events (prefixed dynamically)
  simulationAction('simulation_'); // Base prefix for simulation events

  const FirebaseEvent(this.value);

  /// The string value used in Firebase Analytics
  final String value;

  /// Create a UI event name with the given action
  static String uiEvent(String action) => 'ui_$action';

  /// Create a simulation event name with the given action
  static String simulationEvent(String action) => 'simulation_$action';
}
