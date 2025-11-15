import 'package:flutter/material.dart';

/// Menu item configuration for GravitonPopupMenu
///
/// This model defines the configuration for individual menu items in popup
/// menus throughout the Graviton app, providing a consistent structure for
/// menu item data including labels, icons, colors, and callback actions.
class GravitonMenuItemConfig {
  final String value;
  final String labelKey;
  final String hintKey;
  final IconData icon;
  final Color? iconColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GravitonMenuItemConfig({
    required this.value,
    required this.labelKey,
    required this.hintKey,
    required this.icon,
    this.iconColor,
    this.borderColor,
    this.onTap,
  });
}
