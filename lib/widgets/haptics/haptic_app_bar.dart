import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';

/// A common AppBar widget with consistent styling and haptic back button
///
/// This widget provides a standardized AppBar implementation that can be used
/// across all screens in the app. It includes:
/// - Consistent styling (colors, elevation, etc.)
/// - Haptic feedback for the back button with tooltip
/// - Optional custom actions
/// - Proper theme integration
class HapticAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the AppBar
  final String title;

  /// Optional actions to display in the AppBar
  final List<Widget>? actions;

  /// Whether to show the back button (defaults to true when there's a route to pop)
  final bool automaticallyImplyLeading;

  /// Custom leading widget (overrides the default back button)
  final Widget? leading;

  /// Optional custom background color (defaults to theme color)
  final Color? backgroundColor;

  /// Optional custom foreground color (defaults to theme color)
  final Color? foregroundColor;

  /// Optional elevation (defaults to 0)
  final double? elevation;

  /// Optional title spacing (defaults to AppBar default)
  final double? titleSpacing;

  const HapticAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.titleSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Add horizontal padding for web and desktop platforms
    final isWebOrDesktop =
        kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;

    final horizontalPadding = isWebOrDesktop
        ? AppTypography.spacingMedium
        : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: AppBar(
        title: Text(title),
        backgroundColor:
            backgroundColor ??
            AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            ),
        foregroundColor: foregroundColor ?? AppColors.uiWhite,
        elevation: elevation ?? 0,
        surfaceTintColor: AppColors.transparentColor,
        shadowColor: AppColors.transparentColor,
        automaticallyImplyLeading: false,
        titleSpacing: titleSpacing,
        leading:
            leading ??
            (automaticallyImplyLeading && Navigator.of(context).canPop()
                ? HapticIconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n?.backButtonTooltip ?? 'Back',
                  )
                : null),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
