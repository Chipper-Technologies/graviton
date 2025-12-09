/// Enum representing the menu items in the app bar more menu
enum AppBarMenuItem {
  /// Scenario selection menu item
  scenarios('scenarios'),

  /// Physics settings menu item
  physics('physics'),

  /// Visual & behavior settings menu item
  settings('settings'),

  /// Help & objectives menu item
  help('help'),

  /// About app menu item
  about('about'),

  /// Developer tools menu item (debug only)
  developerTools('developer_tools');

  /// Create an app bar menu item with the given string value
  const AppBarMenuItem(this.value);

  /// The string value used for menu item identification
  final String value;

  /// Get an AppBarMenuItem from its string value
  static AppBarMenuItem? fromValue(String value) {
    for (final item in AppBarMenuItem.values) {
      if (item.value == value) {
        return item;
      }
    }
    return null;
  }

  @override
  String toString() => value;
}
