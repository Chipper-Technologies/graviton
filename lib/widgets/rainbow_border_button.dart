import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graviton/painters/gradient_border_painter.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Social authentication button with rainbow gradient border
///
/// A special variant of social auth button featuring a rainbow gradient border
/// using Google brand colors. Used primarily for Google sign-in buttons.
class RainbowBorderButton extends StatelessWidget {
  /// Icon to display on the button (e.g., Apple icon)
  final IconData? icon;

  /// Path to SVG asset for the button (e.g., 'assets/images/google-logo.svg')
  final String? assetPath;

  /// Label text for the button
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  const RainbowBorderButton({
    super.key,
    this.icon,
    this.assetPath,
    required this.label,
    required this.onPressed,
  }) : assert(
         icon != null || assetPath != null,
         'Either icon or assetPath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: GradientBorderPainter(),
        child: Container(
          margin: EdgeInsets.all(AppTypography.borderThick),
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
                    borderRadius: BorderRadius.circular(
                      AppTypography.radiusLarge,
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
        ),
      ),
    );
  }
}
