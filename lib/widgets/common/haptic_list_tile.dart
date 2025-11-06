import 'package:flutter/material.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Enhanced ListTile with haptic feedback for navigation actions
///
/// This widget provides a ListTile with automatic haptic feedback when tapped.
/// It's specifically designed for navigation items in drawers and menus.
class HapticListTile extends StatelessWidget {
  /// The primary widget to display before the title
  final Widget? leading;

  /// The primary content of the list tile
  final Widget? title;

  /// Additional content displayed below the title
  final Widget? subtitle;

  /// The primary action when the tile is tapped
  final VoidCallback? onTap;

  /// The padding for the tile content
  final EdgeInsetsGeometry? contentPadding;

  /// Whether the tile is dense
  final bool dense;

  /// Maximum number of lines for subtitle
  final int? maxLines;

  /// How subtitle text should be clipped
  final TextOverflow? overflow;

  const HapticListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
    this.contentPadding,
    this.dense = false,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: onTap != null
          ? () {
              HapticUtils.navigate();
              onTap!();
            }
          : null,
      contentPadding: contentPadding,
      dense: dense,
    );
  }
}
