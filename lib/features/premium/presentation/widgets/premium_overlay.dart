import 'package:flutter/material.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Widget that wraps content with an upgrade overlay when feature is locked
///
/// Unlike [PremiumGate], this shows the child but with a premium overlay
/// that indicates the feature requires an upgrade. The child is shown
/// with reduced opacity and pointer events are ignored.
///
/// Example:
/// ```dart
/// PremiumOverlay(
///   feature: PremiumFeature.cameraSync,
///   onTap: () => showPaywall(context),
///   child: CameraSyncControl(),
/// )
/// ```
class PremiumOverlay extends StatelessWidget {
  /// The premium feature to check
  final PremiumFeature feature;

  /// Widget to show (with overlay if locked)
  final Widget child;

  /// Callback when overlay is tapped
  final VoidCallback? onTap;

  const PremiumOverlay({
    required this.feature,
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<PremiumState>(
      builder: (context, premiumState, _) {
        if (premiumState.canUseFeature(feature)) {
          return child;
        }

        return Semantics(
          label: l10n.premiumFeatureRequiresPremium,
          button: true,
          hint: l10n.premiumUpgradeToPremium,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Unfocus any focused widget to prevent focus issues when
              // the paywall closes
              FocusScope.of(context).unfocus();
              onTap?.call();
            },
            child: Stack(
              children: [
                // Show child with reduced opacity
                ExcludeSemantics(
                  child: Opacity(
                    opacity: AppTypography.opacityMedium,
                    child: IgnorePointer(child: child),
                  ),
                ),
                // Premium badge overlay
                Positioned(
                  top: AppTypography.spacingXSmall,
                  right: AppTypography.spacingXSmall,
                  child: ExcludeSemantics(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTypography.spacingSmall,
                        vertical: AppTypography.spacingXXSmall,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.premiumPrimary,
                            AppColors.premiumSecondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppTypography.radiusMedium,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: AppTypography.iconSizeSmall,
                            color: AppColors.uiWhite,
                          ),
                          const SizedBox(width: AppTypography.spacingXXSmall),
                          Text(
                            l10n.premiumProBadge,
                            style: const TextStyle(
                              color: AppColors.uiWhite,
                              fontSize: AppTypography.fontSizeXSmall,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
