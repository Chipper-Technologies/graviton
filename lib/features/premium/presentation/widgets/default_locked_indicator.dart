import 'package:flutter/material.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// Default widget shown when a premium feature is locked
///
/// Displays a compact indicator with a lock icon and "Premium" text,
/// styled with amber colors to draw attention.
///
/// Example:
/// ```dart
/// DefaultLockedIndicator(feature: PremiumFeature.cameraSync)
/// ```
class DefaultLockedIndicator extends StatelessWidget {
  /// The locked premium feature
  final PremiumFeature feature;

  const DefaultLockedIndicator({required this.feature, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.premiumFeatureRequiresPremium,
      button: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTypography.spacingMedium,
          vertical: AppTypography.spacingSmall,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.premiumPrimary.withValues(
                alpha: AppTypography.opacityFaint,
              ),
              AppColors.premiumSecondary.withValues(
                alpha: AppTypography.opacityFaint,
              ),
            ],
          ),
          borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
          border: Border.all(
            color: AppColors.premiumPrimary.withValues(
              alpha: AppTypography.opacityMedium,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: AppTypography.iconSizeSmall,
              color: AppColors.premiumPrimary,
              semanticLabel: null, // Handled by parent Semantics
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            ExcludeSemantics(
              child: Text(
                l10n.premiumTierPremium,
                style: const TextStyle(
                  color: AppColors.premiumPrimary,
                  fontSize: AppTypography.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
