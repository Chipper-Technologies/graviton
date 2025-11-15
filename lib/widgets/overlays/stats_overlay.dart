import 'package:flutter/material.dart';

import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/enums/auto_rotate_status.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/enums/simulation_status.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/localization_utils.dart';
import 'package:graviton/utils/number_utils.dart';

/// Stats overlay widget to display simulation information
class StatsOverlay extends StatelessWidget {
  final AppState appState;

  const StatsOverlay({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Opacity(
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
              '${l10n.timeLabel}: ${l10n.timeFormatted(NumberUtils.formatDecimal(appState.simulation.totalTime, 1))}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.earthYearsLabel}: ${l10n.earthYearsFormatted(NumberUtils.formatDecimal(appState.simulation.totalTimeInEarthYears, 2))}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.speedLabel}: ${l10n.speedFormatted(NumberUtils.formatDecimal(appState.simulation.timeScale, 1))}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.bodiesLabel}: ${l10n.stepsCount(appState.simulation.bodies.length)}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.statusLabel}: ${_getStatusText(appState.simulation.status, l10n)}',
              style: TextStyle(
                color: _getStatusColor(appState.simulation.status),
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
              '${l10n.distanceLabel}: ${l10n.distanceFormatted(NumberUtils.formatDistance(appState.camera.distance))}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.autoRotateLabel}: ${appState.camera.autoRotateStatus.isEnabled ? l10n.autoRotateOn : l10n.autoRotateOff}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.yawLabel}: ${NumberUtils.formatDecimal(appState.camera.yaw, 2)}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.pitchLabel}: ${NumberUtils.formatDecimal(appState.camera.pitch, 2)}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.rollLabel}: ${NumberUtils.formatDecimal(appState.camera.roll, 2)}',
              style: const TextStyle(
                color: AppColors.uiWhite70,
                fontSize: AppTypography.fontSizeSmall,
              ),
            ),
            Text(
              '${l10n.zoomLabel}: ${NumberUtils.formatDistance(appState.camera.distance)}',
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
    );
  }

  String _getStatusText(SimulationStatus status, AppLocalizations l10n) {
    switch (status) {
      case SimulationStatus.stopped:
        return l10n.statusStopped;
      case SimulationStatus.running:
        return l10n.statusRunning;
      case SimulationStatus.paused:
        return l10n.statusPaused;
      case SimulationStatus.error:
        return l10n.statusError;
    }
  }

  Color _getStatusColor(SimulationStatus status) {
    switch (status) {
      case SimulationStatus.stopped:
        return AppColors.uiWhite.withValues(alpha: 0.7);
      case SimulationStatus.running:
        return AppColors.uiStatusGreen;
      case SimulationStatus.paused:
        return AppColors.uiStatusOrange;
      case SimulationStatus.error:
        return AppColors.uiRed;
    }
  }
}
