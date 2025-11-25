/// Screen modes for account management navigation
///
/// Defines the different views/screens available in the account management flow.
/// Used to manage the single-screen navigation pattern for account-related operations.
enum ScreenMode {
  /// Main account view showing user profile and options
  accountView,

  /// Sign in/create account form view
  signIn,

  /// Avatar selection grid view
  avatarSelection,

  /// Edit display name form view
  editName,

  /// Delete account confirmation view
  deleteConfirmation,
}
