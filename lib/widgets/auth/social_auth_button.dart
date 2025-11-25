import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';

/// Social authentication button widget
///
/// A beautifully styled button for social authentication providers (Google, Apple, etc.).
/// Features consistent cosmic-themed styling with icon/SVG, label, elevation, and haptic feedback.
///
/// Use [icon] for IconData-based branding, [assetPath] for SVG assets, or [animatedBorder] for
/// animated border effects.
class SocialAuthButton extends StatelessWidget {
  /// Icon to display on the button (e.g., Apple icon)
  final IconData? icon;

  /// Path to SVG asset for the button (e.g., 'assets/images/google-logo.svg')
  final String? assetPath;

  /// Whether to animate the border through multiple colors
  final bool animatedBorder;

  /// Label text for the button
  final String label;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    this.icon,
    this.assetPath,
    this.animatedBorder = false,
    required this.label,
    required this.onPressed,
  }) : assert(
         icon != null || assetPath != null,
         'Either icon or assetPath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    if (animatedBorder) {
      return _AnimatedBorderButton(
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
                  color: AppColors.uiWhite.withValues(
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

/// Internal widget for gradient border button
class _AnimatedBorderButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? assetPath;
  final VoidCallback onPressed;

  const _AnimatedBorderButton({
    required this.label,
    this.icon,
    this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: _GradientBorderPainter(),
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

/// Custom painter for gradient border
class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(AppTypography.radiusLarge),
    );

    final gradient = const LinearGradient(
      colors: [
        AppColors.googleBlue,
        AppColors.googleRed,
        AppColors.googleYellow,
        AppColors.googleGreen,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppTypography.borderThick;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
