import 'package:flutter/material.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Widget that shows upgrade prompt when free tier limits are reached
///
/// Displays a visually prominent banner with a gradient background,
/// title, description, and upgrade button. Automatically hidden
/// for premium users.
///
/// Example:
/// ```dart
/// UpgradeBanner(
///   title: 'Session Limit Reached',
///   description: 'Upgrade to Premium for unlimited sessions.',
///   onUpgrade: () => showPaywall(context),
/// )
/// ```
class UpgradeBanner extends StatelessWidget {
  /// Title text
  final String title;

  /// Description text
  final String description;

  /// Callback when upgrade button is tapped
  final VoidCallback? onUpgrade;

  /// Callback when dismiss button is tapped
  final VoidCallback? onDismiss;

  const UpgradeBanner({
    required this.title,
    required this.description,
    this.onUpgrade,
    this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<PremiumState>(
      builder: (context, premiumState, _) {
        // Don't show if user has premium
        if (premiumState.hasPremiumAccess) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(AppTypography.spacingLarge),
          padding: const EdgeInsets.all(AppTypography.spacingLarge),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.spaceVibrantPurple, AppColors.galaxyIndigo],
            ),
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: AppColors.uiPurple.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
                blurRadius: AppTypography.spacingSmall,
                offset: const Offset(0, AppTypography.spacingXSmall),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTypography.spacingSmall),
                    decoration: BoxDecoration(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusSmall,
                      ),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: AppColors.uiAmber,
                      size: AppTypography.iconSizeMedium,
                    ),
                  ),
                  const SizedBox(width: AppTypography.spacingMedium),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (onDismiss != null)
                    IconButton(
                      onPressed: onDismiss,
                      icon: Icon(
                        Icons.close,
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                        size: AppTypography.iconSizeMedium,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontSize: AppTypography.fontSizeMedium,
                ),
              ),
              const SizedBox(height: AppTypography.spacingLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.uiAmber,
                    foregroundColor: AppColors.backgroundBlack,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTypography.spacingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusSmall,
                      ),
                    ),
                  ),
                  child: Text(
                    l10n.premiumUpgradeToPremium,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
