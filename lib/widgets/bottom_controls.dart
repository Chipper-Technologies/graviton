import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Bottom control bar with camera and UI toggle buttons
class BottomControls extends StatelessWidget {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final l10n = AppLocalizations.of(context)!;

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Stats toggle (standalone)
                _buildControlButton(
                  context: context,
                  icon: appState.ui.showStats
                      ? Icons.analytics
                      : Icons.analytics_outlined,
                  label: l10n.statsLabel,
                  tooltip: l10n.toggleStatsTooltip,
                  onPressed: () => appState.ui.toggleStats(),
                  isActive: appState.ui.showStats,
                ),

                // Visual separator
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.uiWhite.withValues(alpha: 0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),

                // Camera controls group
                _buildControlButton(
                  context: context,
                  icon: Icons.my_location,
                  label: l10n.selectLabel,
                  tooltip: l10n.focusOnNearestTooltip,
                  onPressed:
                      (appState.simulation.bodies.isNotEmpty &&
                          appState.ui.cinematicCameraTechnique ==
                              CinematicCameraTechnique.manual)
                      ? () => appState.camera.focusOnNearestBody(
                          appState.simulation.bodies,
                        )
                      : null,
                ),

                _buildControlButton(
                  context: context,
                  icon: appState.camera.followMode
                      ? Icons.track_changes
                      : Icons.track_changes_outlined,
                  label: l10n.followLabel,
                  tooltip: appState.camera.followMode
                      ? l10n.stopFollowingTooltip
                      : (appState.camera.selectedBody != null
                            ? l10n.followObjectTooltip
                            : l10n.selectObjectToFollowTooltip),
                  onPressed:
                      (appState.camera.selectedBody != null &&
                          appState.ui.cinematicCameraTechnique ==
                              CinematicCameraTechnique.manual)
                      ? () => appState.camera.toggleFollowMode(
                          appState.simulation.bodies,
                        )
                      : null,
                  isActive: appState.camera.followMode,
                ),

                _buildControlButton(
                  context: context,
                  icon: Icons.center_focus_strong,
                  label: l10n.centerLabel,
                  tooltip: l10n.centerViewTooltip,
                  onPressed:
                      appState.ui.cinematicCameraTechnique ==
                          CinematicCameraTechnique.manual
                      ? () => appState.camera.resetView(
                          appState.simulation.currentScenario,
                        )
                      : null,
                ),

                _buildControlButton(
                  context: context,
                  icon: appState.camera.autoRotate
                      ? Icons.rotate_right
                      : Icons.rotate_right_outlined,
                  label: l10n.rotateLabel,
                  tooltip: l10n.autoRotateTooltip,
                  onPressed:
                      appState.ui.cinematicCameraTechnique ==
                          CinematicCameraTechnique.manual
                      ? () => appState.camera.toggleAutoRotate()
                      : null,
                  isActive: appState.camera.autoRotate,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String tooltip,
    required VoidCallback? onPressed,
    bool isActive = false,
  }) {
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingSmall,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: isActive
                  ? Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isEnabled
                      ? (isActive
                            ? AppColors.primaryColor
                            : AppColors.uiWhite.withValues(alpha: 0.9))
                      : AppColors.uiWhite.withValues(alpha: 0.3),
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled
                        ? (isActive
                              ? AppColors.primaryColor
                              : AppColors.uiWhite.withValues(alpha: 0.8))
                        : AppColors.uiWhite.withValues(alpha: 0.3),
                    fontSize: AppTypography.fontSizeXSmall,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
