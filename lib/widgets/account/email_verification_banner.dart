import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/auth_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';

/// Email verification banner widget
///
/// Displays the user's email verification status with action buttons
/// to send verification emails and check verification status.
class EmailVerificationBanner extends StatelessWidget {
  /// Callback for sending verification email
  final VoidCallback onSendVerification;

  /// Callback for checking verification status
  final VoidCallback onCheckVerification;

  /// Whether verification email is being sent
  final bool isSendingVerification;

  /// Whether verification status is being checked
  final bool isCheckingVerification;

  const EmailVerificationBanner({
    required this.onSendVerification,
    required this.onCheckVerification,
    required this.isSendingVerification,
    required this.isCheckingVerification,
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
            Row(
              children: [
                Expanded(
                  child: HapticElevatedButton(
                    onPressed: isSendingVerification
                        ? null
                        : onSendVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.uiYellow,
                      foregroundColor: AppColors.uiBlack,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTypography.spacingMedium,
                      ),
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
                        : Text(l10n.sendVerificationEmail),
                  ),
                ),
                const SizedBox(width: AppTypography.spacingMedium),
                Expanded(
                  child: HapticElevatedButton(
                    onPressed: isCheckingVerification
                        ? null
                        : onCheckVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityDisabled,
                      ),
                      foregroundColor: AppColors.uiWhite,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTypography.spacingMedium,
                      ),
                    ),
                    child: isCheckingVerification
                        ? const SizedBox(
                            height: AppTypography.iconSizeMedium,
                            width: AppTypography.iconSizeMedium,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.uiWhite,
                              ),
                            ),
                          )
                        : Text(l10n.checkVerificationStatus),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
