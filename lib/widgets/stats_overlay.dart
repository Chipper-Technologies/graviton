import 'package:flutter/material.dart';

import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/localization_utils.dart';

/// Stats overlay widget to display simulation information
class StatsOverlay extends StatelessWidget {
  final AppState appState;

  const StatsOverlay({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      top: 16,
      left: 16,
      child: Opacity(
        opacity: appState.ui.uiOpacity,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.uiBlackOverlay,
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.simulationStats,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.uiWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              Text(
                '${l10n.stepsLabel}: ${l10n.stepsCount(appState.simulation.stepCount)}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.timeLabel}: ${l10n.timeFormatted(appState.simulation.totalTime.toStringAsFixed(1))}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.earthYearsLabel}: ${l10n.earthYearsFormatted(appState.simulation.totalTimeInEarthYears.toStringAsFixed(2))}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.speedStatsLabel}: ${l10n.speedFormatted(appState.simulation.timeScale.toStringAsFixed(1))}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.bodiesLabel}: ${l10n.bodiesCount(appState.simulation.bodies.length)}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.statusLabel}: ${appState.simulation.isPaused ? l10n.statusPaused : l10n.statusRunning}',
                style: TextStyle(
                  color: appState.simulation.isPaused
                      ? AppColors.uiStatusOrange
                      : AppColors.uiStatusGreen,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              Text(
                l10n.cameraLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.uiWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${l10n.distanceLabel}: ${l10n.distanceFormatted(appState.camera.distance.toStringAsFixed(1))}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.autoRotateLabel}: ${appState.camera.autoRotate ? l10n.autoRotateOn : l10n.autoRotateOff}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.yawLabel}: ${appState.camera.yaw.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.pitchLabel}: ${appState.camera.pitch.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.rollLabel}: ${appState.camera.roll.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              Text(
                '${l10n.zoomLabel}: ${appState.camera.distance.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: AppColors.uiWhite70,
                  fontSize: AppTypography.fontSizeSmall,
                ),
              ),
              const SizedBox(height: AppTypography.spacingSmall),
              // Only show habitability section if there are habitable bodies
              if (appState.simulation.bodies.any(
                (body) => body.canBeHabitable,
              )) ...[
                Text(
                  l10n.habitabilityLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...appState.simulation.bodies
                    .where((body) => body.canBeHabitable)
                    .map(
                      (body) => Text(
                        '${body.name}: ${LocalizationUtils.getLocalizedHabitabilityStatus(l10n, body.habitabilityStatus)}',
                        style: TextStyle(
                          color: Color(
                            body.habitabilityStatus.statusColor,
                          ).withValues(alpha: AppTypography.opacityHigh),
                          fontSize: AppTypography.fontSizeSmall,
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
