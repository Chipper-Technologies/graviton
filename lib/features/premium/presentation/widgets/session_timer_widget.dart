import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:provider/provider.dart';

/// Widget that displays remaining session time for free tier users
///
/// Shows a countdown timer that changes color as time runs low.
/// Hidden for premium users.
class SessionTimerWidget extends StatelessWidget {
  /// Whether the timer should be compact
  final bool compact;

  /// Callback when timer is tapped
  final VoidCallback? onTap;

  const SessionTimerWidget({this.compact = false, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<PremiumState>(
      builder: (context, premiumState, _) {
        // Don't show for premium users
        if (premiumState.hasPremiumAccess) {
          return const SizedBox.shrink();
        }

        final remainingTime = premiumState.remainingSessionTime;
        final isWarning = premiumState.shouldShowTimeWarning;
        final isExpired = remainingTime.inSeconds <= 0;

        final backgroundColor = isExpired
            ? AppColors.uiRed.withValues(alpha: AppTypography.opacityMedium)
            : isWarning
            ? AppColors.uiOrange.withValues(alpha: AppTypography.opacityMedium)
            : AppColors.spaceGradientDark.withValues(
                alpha: AppTypography.opacityHigh,
              );

        final textColor = isExpired || isWarning
            ? AppColors.uiWhite
            : AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityDisabled,
              );

        // Build semantic label for accessibility
        final semanticLabel = isExpired
            ? l10n.premiumSessionExpired
            : '${l10n.premiumTimeRemaining}: ${premiumState.formatRemainingTime()}';

        if (compact) {
          return Semantics(
            label: semanticLabel,
            liveRegion: isWarning,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingSmall,
                  vertical: AppTypography.spacingXSmall,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusSmall,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(
                        isExpired ? Icons.timer_off : Icons.timer_outlined,
                        size: AppTypography.iconSizeSmall,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: AppTypography.spacingXSmall),
                    ExcludeSemantics(
                      child: Text(
                        premiumState.formatRemainingTime(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: AppTypography.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Semantics(
          label: semanticLabel,
          liveRegion: isWarning,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
                vertical: AppTypography.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                border: isWarning || isExpired
                    ? Border.all(
                        color: isExpired ? AppColors.uiRed : AppColors.uiOrange,
                        width: 1.5,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      isExpired ? Icons.timer_off : Icons.timer_outlined,
                      size: AppTypography.iconSizeMedium,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: AppTypography.spacingSmall),
                  ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isExpired
                              ? l10n.premiumSessionExpired
                              : l10n.premiumTimeRemaining,
                          style: TextStyle(
                            color: textColor.withValues(
                              alpha: AppTypography.opacityHigh,
                            ),
                            fontSize: AppTypography.fontSizeXSmall,
                          ),
                        ),
                        Text(
                          premiumState.formatRemainingTime(),
                          style: TextStyle(
                            color: textColor,
                            fontSize: AppTypography.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWarning && !isExpired) ...[
                    const SizedBox(width: AppTypography.spacingSmall),
                    ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTypography.spacingSmall,
                          vertical: AppTypography.spacingXSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.uiWhite.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppTypography.radiusSmall,
                          ),
                        ),
                        child: Text(
                          l10n.premiumUpgrade,
                          style: const TextStyle(
                            color: AppColors.uiWhite,
                            fontSize: AppTypography.fontSizeXSmall,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
