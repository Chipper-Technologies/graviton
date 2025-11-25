import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/rainbow_border_button.dart';

/// Social authentication button widget
///
/// A beautifully styled button for social authentication providers (Google, GitHub, Apple, etc.).
/// Features consistent cosmic-themed styling with icon/SVG, label, elevation, and haptic feedback.
///
/// Use [icon] for IconData-based branding, [assetPath] for SVG assets.
/// Customize the border with [borderColor] or use [rainbowBorder] for a gradient effect.
class SocialAuthButton extends StatelessWidget {
  /// Icon to display on the button (e.g., Apple icon)
  final IconData? icon;

  /// Path to SVG asset for the button (e.g., 'assets/images/google-logo.svg')
  final String? assetPath;

  /// Custom border color (overrides default semi-transparent white)
  final Color? borderColor;

  /// Whether to use a rainbow gradient border (takes precedence over borderColor)
  final bool rainbowBorder;

  /// Label text for the button
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    this.icon,
    this.assetPath,
    this.borderColor,
    this.rainbowBorder = false,
    required this.label,
    required this.onPressed,
  }) : assert(
         icon != null || assetPath != null,
         'Either icon or assetPath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    if (rainbowBorder) {
      return RainbowBorderButton(
        label: label,
        icon: icon,
        assetPath: assetPath,
        onPressed: onPressed,
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              foregroundColor: AppColors.uiWhite,
              padding: EdgeInsets.symmetric(
                vertical: AppTypography.spacingLarge,
                horizontal: AppTypography.spacingMedium,
              ),
              elevation: AppTypography.spacingXSmall,
              shadowColor: AppColors.uiBlack.withValues(
                alpha: AppTypography.opacityFaint,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
                side: BorderSide(
                  color:
                      borderColor ??
                      AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                  width: AppTypography.borderThin,
                ),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityBarely,
                  );
                }
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  );
                }
                return null;
              }),
            ),
        onPressed: () {
          HapticUtils.tap();
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              SvgPicture.asset(
                assetPath!,
                width: AppTypography.iconSizeLarge,
                height: AppTypography.iconSizeLarge,
              )
            else
              Icon(
                icon!,
                size: AppTypography.iconSizeLarge,
                color: AppColors.uiWhite,
              ),
            SizedBox(width: AppTypography.spacingMedium),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppColors.uiWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
