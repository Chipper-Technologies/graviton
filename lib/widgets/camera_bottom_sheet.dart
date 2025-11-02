import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/widgets/bottom_sheet_handle.dart';
import 'package:graviton/widgets/bottom_sheet_header.dart';
import 'package:graviton/widgets/camera_mode_option.dart';
import 'package:graviton/widgets/camera_action_button.dart';
import 'package:graviton/widgets/section_title.dart';

/// Camera controls bottom sheet
class CameraBottomSheet extends StatelessWidget {
  final AppState appState;
  final ScrollController scrollController;

  const CameraBottomSheet({
    super.key,
    required this.appState,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityMediumHigh,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTypography.radiusXXLarge),
        ),
      ),
      child: Column(
        children: [
          const BottomSheetHandle(),

          BottomSheetHeader(
            icon: Icons.videocam,
            title: l10n.bottomNavCameraLabel,
          ),

          // Controls
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: AppTypography.spacingXLarge,
                right: AppTypography.spacingXLarge,
                top: AppTypography.spacingXLarge,
                bottom:
                    AppTypography.spacingXLarge +
                    PlatformUtils.getBottomSheetSystemBarPadding(), // Platform-specific padding for system bar
              ),
              children: [
                // AI Camera Mode Selection
                SectionTitle(title: l10n.aiCameraModesTitle),
                const SizedBox(height: AppTypography.spacingMedium),

                CameraModeOption(
                  title: l10n.manualControlTitle,
                  description: l10n.manualControlDescription,
                  mode: CinematicCameraTechnique.manual,
                  icon: Icons.pan_tool,
                  isSelected:
                      appState.ui.cinematicCameraTechnique ==
                      CinematicCameraTechnique.manual,
                  onTap: () => appState.ui.setCinematicCameraTechnique(
                    CinematicCameraTechnique.manual,
                  ),
                ),

                CameraModeOption(
                  title: l10n.predictiveOrbitalTitle,
                  description: l10n.predictiveOrbitalDescription,
                  mode: CinematicCameraTechnique.predictiveOrbital,
                  icon: Icons.auto_awesome,
                  isSelected:
                      appState.ui.cinematicCameraTechnique ==
                      CinematicCameraTechnique.predictiveOrbital,
                  onTap: () => appState.ui.setCinematicCameraTechnique(
                    CinematicCameraTechnique.predictiveOrbital,
                  ),
                ),

                CameraModeOption(
                  title: l10n.dynamicFramingTitle,
                  description: l10n.dynamicFramingDescription,
                  mode: CinematicCameraTechnique.dynamicFraming,
                  icon: Icons.crop_free,
                  isSelected:
                      appState.ui.cinematicCameraTechnique ==
                      CinematicCameraTechnique.dynamicFraming,
                  onTap: () => appState.ui.setCinematicCameraTechnique(
                    CinematicCameraTechnique.dynamicFraming,
                  ),
                ),

                const SizedBox(height: AppTypography.spacingXXLarge),

                // Manual Controls (only show if manual mode)
                if (appState.ui.cinematicCameraTechnique ==
                    CinematicCameraTechnique.manual) ...[
                  SectionTitle(title: l10n.manualControlsTitle),
                  const SizedBox(height: AppTypography.spacingMedium),

                  Row(
                    children: [
                      Expanded(
                        child: CameraActionButton(
                          label: l10n.selectNearestTitle,
                          icon: Icons.my_location,
                          onPressed: appState.simulation.bodies.isNotEmpty
                              ? () => appState.camera.focusOnNearestBody(
                                  appState.simulation.bodies,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppTypography.spacingMedium),
                      Expanded(
                        child: CameraActionButton(
                          label: appState.camera.followMode
                              ? l10n.stopFollowTitle
                              : l10n.followTitle,
                          icon: appState.camera.followMode
                              ? Icons.track_changes
                              : Icons.track_changes_outlined,
                          onPressed: appState.camera.selectedBody != null
                              ? () => appState.camera.toggleFollowMode(
                                  appState.simulation.bodies,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTypography.spacingMedium),

                  Row(
                    children: [
                      Expanded(
                        child: CameraActionButton(
                          label: l10n.centerViewTitle,
                          icon: Icons.center_focus_strong,
                          onPressed: () => appState.camera.resetView(
                            appState.simulation.currentScenario,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTypography.spacingMedium),
                      Expanded(
                        child: CameraActionButton(
                          label: appState.camera.autoRotate
                              ? l10n.stopRotateTitle
                              : l10n.autoRotateTitle,
                          icon: appState.camera.autoRotate
                              ? Icons.rotate_right
                              : Icons.rotate_right_outlined,
                          onPressed: () => appState.camera.toggleAutoRotate(),
                        ),
                      ),
                    ],
                  ),
                ],

                // Camera Movement Controls (only show if manual mode)
                if (appState.ui.cinematicCameraTechnique ==
                    CinematicCameraTechnique.manual) ...[
                  const SizedBox(height: AppTypography.spacingXXLarge),

                  SectionTitle(title: l10n.manualControlsTitle),
                  const SizedBox(height: AppTypography.spacingMedium),

                  _buildToggleOption(
                    l10n.autoRotateTitle,
                    l10n.invertPitchControlsDescription, // Reusing existing description as placeholder
                    Icons.rotate_right,
                    appState.camera.autoRotate,
                    () => appState.camera.toggleAutoRotate(),
                  ),
                ],

                SizedBox(height: AppTypography.spacingXXLarge),

                SectionTitle(title: l10n.cameraControlsLabel),
                SizedBox(height: AppTypography.spacingMedium),

                _buildToggleOption(
                  l10n.invertPitchControlsLabel,
                  l10n.invertPitchControlsDescription,
                  Icons.swap_vert,
                  appState.camera.invertPitch,
                  () => appState.camera.toggleInvertPitch(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    IconData icon,
    bool isEnabled,
    VoidCallback onToggle,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: isEnabled
                  ? Border.all(
                      color: AppColors.primaryColor,
                      width: AppTypography.borderThin,
                    )
                  : Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityDisabled,
                      ),
                      width: AppTypography.borderThin,
                    ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isEnabled
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                  size: AppTypography.iconSizeXXLarge,
                ),
                SizedBox(width: AppTypography.spacingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isEnabled
                              ? AppColors.primaryColor
                              : AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (_) => onToggle(),
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityFaint,
                  ),
                  inactiveThumbColor: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                  inactiveTrackColor: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityDisabled,
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
