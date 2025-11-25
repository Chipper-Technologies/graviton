import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Terms and privacy acceptance checkbox widget
///
/// Displays a checkbox with inline links to Terms of Service and Privacy Policy.
class TermsAcceptanceCheckbox extends StatelessWidget {
  /// Current acceptance state
  final bool isAccepted;

  /// Callback when checkbox value changes
  final ValueChanged<bool> onChanged;

  /// Callback when Terms of Service is tapped
  final VoidCallback? onTermsTapped;

  /// Callback when Privacy Policy is tapped
  final VoidCallback? onPrivacyTapped;

  const TermsAcceptanceCheckbox({
    required this.isAccepted,
    required this.onChanged,
    this.onTermsTapped,
    this.onPrivacyTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isAccepted,
          onChanged: (value) => onChanged(value ?? false),
          activeColor: AppColors.primaryColor,
          checkColor: AppColors.uiWhite,
          side: BorderSide(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityMedium,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppTypography.spacingSmall),
            child: Text.rich(
              TextSpan(
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                ),
                children: [
                  TextSpan(text: l10n.acceptTermsAndPrivacy),
                  const TextSpan(text: ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: HapticTextButton(
                      onPressed: onTermsTapped ?? () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.termsOfService,
                        style: AppTypography.smallText.copyWith(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: HapticTextButton(
                      onPressed: onPrivacyTapped ?? () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.privacyPolicy,
                        style: AppTypography.smallText.copyWith(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
