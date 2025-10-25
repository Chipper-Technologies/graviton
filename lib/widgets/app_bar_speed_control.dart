import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
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
            color: AppColors.uiBlack.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            border: Border.all(
              color: AppColors.uiWhite.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: PopupMenuButton<double>(
            tooltip: l10n.speedLabel,
            onSelected: (value) => appState.simulation.setTimeScale(value),
            itemBuilder: (context) => [
              _buildSpeedMenuItem(
                0.1,
                '0.1x',
                'Slow Motion',
                Icons.slow_motion_video,
              ),
              _buildSpeedMenuItem(0.5, '0.5x', 'Half Speed', Icons.play_arrow),
              _buildSpeedMenuItem(1.0, '1.0x', 'Normal', Icons.play_arrow),
              _buildSpeedMenuItem(2.0, '2.0x', 'Double', Icons.fast_forward),
              _buildSpeedMenuItem(4.0, '4.0x', 'Fast', Icons.fast_forward),
              _buildSpeedMenuItem(8.0, '8.0x', 'Very Fast', Icons.fast_forward),
              _buildSpeedMenuItem(16.0, '16.0x', 'Maximum', Icons.fast_forward),
            ],
            color: AppColors.uiBlack.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              side: BorderSide(
                color: AppColors.uiWhite.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.speed,
                  size: 14,
                  color: AppColors.uiWhite.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 3),
                Text(
                  '${timeScale.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeSmall - 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 1),
                Icon(
                  Icons.arrow_drop_down,
                  size: 14,
                  color: AppColors.uiWhite.withValues(alpha: 0.6),
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
          Icon(icon, size: 16, color: AppColors.uiWhite.withValues(alpha: 0.7)),
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
                  color: AppColors.uiWhite.withValues(alpha: 0.6),
                  fontSize: AppTypography.fontSizeSmall - 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
