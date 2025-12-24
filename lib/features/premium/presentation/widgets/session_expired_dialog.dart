import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Dialog shown when a free tier user's session expires
///
/// Presents options to upgrade to premium or acknowledge the session ended.
class SessionExpiredDialog extends StatelessWidget {
  /// Callback when user chooses to upgrade
  final VoidCallback? onUpgrade;

  /// Callback when user dismisses without upgrading
  final VoidCallback? onDismiss;

  const SessionExpiredDialog({super.key, this.onUpgrade, this.onDismiss});

  /// Show the session expired dialog
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SessionExpiredDialog(
        onUpgrade: () => Navigator.pop(context, true),
        onDismiss: () => Navigator.pop(context, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
      ),
      icon: Container(
        padding: const EdgeInsets.all(AppTypography.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.uiRed.withValues(alpha: AppTypography.opacityMedium),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.timer_off,
          color: AppColors.uiRed,
          size: AppTypography.iconSizeXXLarge,
        ),
      ),
      title: Text(
        l10n.premiumSessionExpired,
        style: const TextStyle(
          color: AppColors.uiWhite,
          fontSize: AppTypography.fontSizeLarge,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.premiumSessionExpiredMessage,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontSize: AppTypography.fontSizeMedium,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTypography.spacingLarge),
          // Benefits reminder
          Container(
            padding: const EdgeInsets.all(AppTypography.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.uiAmber.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: Border.all(
                color: AppColors.uiAmber.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.uiAmber,
                  size: AppTypography.iconSizeMedium,
                ),
                const SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: Text(
                    l10n.premiumUnlimitedSessionsHint,
                    style: const TextStyle(
                      color: AppColors.uiAmber,
                      fontSize: AppTypography.fontSizeSmall,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text(
            l10n.closeButton,
            style: TextStyle(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onUpgrade,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.uiAmber,
            foregroundColor: AppColors.uiBlack,
          ),
          child: Text(l10n.premiumUpgrade),
        ),
      ],
    );
  }
}
