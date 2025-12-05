import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';

/// Email verification banner widget
///
/// Displays the user's email verification status with a button
/// to resend the verification email.
class EmailVerificationBanner extends StatelessWidget {
  /// Callback for resending verification email
  final VoidCallback onResendVerification;

  /// Whether verification email is being sent
  final bool isSendingVerification;

  const EmailVerificationBanner({
    required this.onResendVerification,
    required this.isSendingVerification,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isVerified = AuthService.instance.isEmailVerified;

    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      decoration: BoxDecoration(
        color: (isVerified ? AppColors.stellarGType : AppColors.uiYellow)
            .withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: Border.all(
          color: isVerified ? AppColors.stellarGType : AppColors.uiYellow,
          width: AppTypography.borderMedium,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.warning,
                color: isVerified ? AppColors.stellarGType : AppColors.uiYellow,
                size: AppTypography.iconSizeLarge,
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Text(
                  isVerified ? l10n.emailVerified : l10n.emailNotVerified,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (!isVerified) ...[
            const SizedBox(height: AppTypography.spacingMedium),
            Text(
              l10n.verifyEmailMessage,
              style: AppTypography.smallText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
              ),
            ),
            const SizedBox(height: AppTypography.spacingMedium),
            HapticElevatedButton(
              onPressed: isSendingVerification ? null : onResendVerification,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uiYellow,
                foregroundColor: AppColors.uiBlack,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTypography.spacingMedium,
                ),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: isSendingVerification
                  ? const SizedBox(
                      height: AppTypography.iconSizeMedium,
                      width: AppTypography.iconSizeMedium,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.uiBlack,
                        ),
                      ),
                    )
                  : Text(l10n.resendVerificationEmail),
            ),
          ],
        ],
      ),
    );
  }
}
