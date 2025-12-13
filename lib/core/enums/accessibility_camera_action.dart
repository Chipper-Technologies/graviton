/// Camera actions that can be announced for accessibility
///
/// This enum provides type safety and consistency for camera action
/// identification in accessibility announcements.
enum AccessibilityCameraAction {
  /// Camera view reset to default position
  reset('reset'),

  /// Camera focused on nearest celestial body
  focus('focus'),

  /// Camera now following selected celestial body
  follow('follow'),

  /// Camera stopped following celestial body
  unfollow('unfollow');

  const AccessibilityCameraAction(this.value);

  /// The string value used for action identification
  final String value;

  /// Create an AccessibilityCameraAction from a string value
  ///
  /// Returns the matching enum value or defaults to [reset] if no match is found.
  static AccessibilityCameraAction fromString(String value) {
    switch (value.toLowerCase()) {
      case 'reset':
        return AccessibilityCameraAction.reset;
      case 'focus':
        return AccessibilityCameraAction.focus;
      case 'follow':
        return AccessibilityCameraAction.follow;
      case 'unfollow':
        return AccessibilityCameraAction.unfollow;
      default:
        return AccessibilityCameraAction.reset; // Default fallback
    }
  }
}
