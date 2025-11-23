import 'package:flutter/material.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Social authentication button widget
///
/// A styled button for social authentication providers (Google, Apple, etc.).
/// Features consistent styling with icon and label layout.
class SocialAuthButton extends StatelessWidget {
  /// Icon to display on the button
  final IconData icon;

  /// Label text for the button
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.uiWhite,
        side: BorderSide(
          color: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacitySemiTransparent,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppTypography.spacingMedium,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppTypography.iconSizeMedium),
          const SizedBox(width: AppTypography.spacingSmall),
          Text(
            label,
            style: const TextStyle(fontSize: AppTypography.fontSizeMedium),
          ),
        ],
      ),
    );
  }
}
