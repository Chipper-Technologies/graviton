import 'package:flutter/material.dart';
import 'package:graviton/theme/app_typography.dart';

/// A reusable dialog title widget that provides consistent styling and
/// proper text overflow handling across all dialog implementations.
///
/// This widget follows the pattern of Row + Icon + SizedBox + Expanded(Text)
/// to prevent title text overflow while maintaining consistent visual design.
class DialogTitle extends StatelessWidget {
  /// The title text to display
  final String title;

  /// The icon to display before the title
  final IconData icon;

  /// The color of the icon (defaults to theme primary color)
  final Color? iconColor;

  /// The size of the icon (defaults to AppTypography.iconSizeXXLarge)
  final double? iconSize;

  /// The text style for the title (defaults to theme titleLarge with bold weight)
  final TextStyle? titleStyle;

  /// Additional spacing between icon and text (defaults to AppTypography.spacingMedium)
  final double spacing;

  /// Optional trailing widget (e.g., close button)
  final Widget? trailing;

  const DialogTitle({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.spacing = AppTypography.spacingMedium,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
          size: iconSize ?? AppTypography.iconSizeXXLarge,
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Allow wrapping to 2 lines for very long titles
          ),
        ),
        if (trailing != null) ...[SizedBox(width: spacing), trailing!],
      ],
    );
  }
}
