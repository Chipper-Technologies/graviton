/// Enumeration of premium features available in Graviton.
///
/// Each feature represents a capability that is restricted for free users
/// and fully available for premium subscribers.
enum PremiumFeature {
  /// Camera synchronization for live sessions.
  ///
  /// Allows the host to share their camera view with all connected viewers,
  /// creating a synchronized viewing experience.
  cameraSync,

  /// Password protection for sessions.
  ///
  /// Enables the host to set a password that viewers must enter
  /// to join the session, adding a layer of privacy.
  passwordProtection,

  /// Unlimited session duration.
  ///
  /// Free users have a time limit per session, while premium users
  /// can run sessions indefinitely.
  unlimitedSessionDuration,

  /// Unlimited viewers per session.
  ///
  /// Free users are limited to a certain number of concurrent viewers,
  /// while premium users can host unlimited viewers.
  unlimitedViewers,

  /// Unlimited sessions per day.
  ///
  /// Free users can only create a limited number of sessions per day,
  /// while premium users have no daily session limit.
  unlimitedSessionsPerDay,
}
