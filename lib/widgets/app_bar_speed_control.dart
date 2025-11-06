import 'package:flutter/material.dart';
import 'package:graviton/enums/speed_preset.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Compact speed control for the app bar
class AppBarSpeedControl extends StatelessWidget {
  const AppBarSpeedControl({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final timeScale = appState.simulation.timeScale;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityFaint,
            ),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            border: Border.all(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityVeryFaint,
              ),
              width: 1,
            ),
          ),
          child: PopupMenuButton<double>(
            tooltip: l10n.speedLabel,
            onSelected: (value) {
              HapticFeedbackService.instance.selection();
              appState.simulation.setTimeScale(value);
            },
            itemBuilder: (context) => SpeedPreset.values
                .map(
                  (preset) => _buildSpeedMenuItem(
                    preset.multiplier.toDouble(),
                    preset.formattedSpeed,
                    preset.getLocalizedDisplayName(l10n),
                    preset.icon,
                  ),
                )
                .toList(),
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              side: BorderSide(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityVeryFaint,
                ),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.speed,
                  size: AppTypography.iconSizeSmall,
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityVeryHigh,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  SpeedPresetExtension.fromMultiplier(timeScale).formattedSpeed,
                  style: const TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeSmall - 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 1),
                Icon(
                  Icons.arrow_drop_down,
                  size: AppTypography.iconSizeSmall,
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMediumHigh,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<double> _buildSpeedMenuItem(
    double value,
    String speed,
    String description,
    IconData icon,
  ) {
    return PopupMenuItem<double>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: AppTypography.iconSizeMedium,
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityHigh,
            ),
          ),
          const SizedBox(width: AppTypography.spacingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                speed,
                style: const TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMediumHigh,
                  ),
                  fontSize: AppTypography.fontSizeXSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
