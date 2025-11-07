import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/widgets/camera_mode_option.dart';
import 'package:graviton/widgets/camera_action_button.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';
import 'package:graviton/widgets/common/haptic_switch.dart';
import 'package:graviton/widgets/common/haptic_slider_option.dart';
import 'package:graviton/widgets/section_title.dart';

/// Camera controls content for the persistent bottom sheet
class CameraControls extends StatelessWidget {
  final AppState appState;
  final ScrollController scrollController;

  const CameraControls({
    super.key,
    required this.appState,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      controller: scrollController,
      padding: EdgeInsets.only(
        left: AppTypography.spacingXLarge,
        right: AppTypography.spacingXLarge,
        top: AppTypography.spacingLarge,
        bottom:
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

          const SizedBox(height: AppTypography.spacingXXLarge),

          _buildToggleOption(
            l10n.autoRotateTitle,
            l10n.invertPitchControlsDescription, // Reusing existing description as placeholder
            Icons.rotate_right,
            appState.camera.autoRotate,
            () => appState.camera.toggleAutoRotate(),
          ),

          const SizedBox(height: AppTypography.spacingMedium),

          _buildToggleOption(
            l10n.invertPitchControlsLabel,
            l10n.invertPitchControlsDescription,
            Icons.swap_vert,
            appState.camera.invertPitch,
            () => appState.camera.toggleInvertPitch(),
            isLast: true,
          ),
        ],

        // Camera Settings - Combined FOV, Speed, and Visual Aids
        const SizedBox(height: AppTypography.spacingLarge),

        SectionTitle(title: l10n.cameraSettingsTitle),
        const SizedBox(height: AppTypography.spacingMedium),

        HapticSliderOption.detailed(
          label: l10n.fieldOfViewLabel,
          value: appState.camera.fieldOfView,
          min: 30.0,
          max: 120.0,
          divisions: 90,
          icon: Icons.camera_alt,
          onChanged: (value) {
            appState.camera.setFieldOfView(value);
          },
          formatter: (value) => '${value.round()}°',
        ),

        // Camera Speed Control (only for AI techniques)
        if (appState.ui.cinematicCameraTechnique !=
            CinematicCameraTechnique.manual) ...[
          const SizedBox(height: AppTypography.spacingLarge),

          HapticSliderOption.detailed(
            label: l10n.cameraSpeedLabel,
            value: appState.ui.cameraSpeed,
            min: 0.1,
            max: 3.0,
            divisions: 29,
            icon: Icons.speed,
            onChanged: (value) {
              appState.ui.setCameraSpeed(value);
            },
            formatter: (value) => '${value.toStringAsFixed(1)}x',
          ),
        ],

        const SizedBox(height: AppTypography.spacingLarge),

        _buildToggleOption(
          l10n.crosshairsTitle,
          l10n.crosshairsDescription,
          Icons.center_focus_strong,
          appState.camera.showCrosshairs,
          () => appState.camera.toggleCrosshairs(),
          isLast: true,
        ),

        SizedBox(height: AppTypography.spacingXXLarge),
      ],
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    IconData icon,
    bool isEnabled,
    VoidCallback onToggle, {
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppTypography.spacingSmall),
      child: Material(
        color: Colors.transparent,
        child: HapticInkWell(
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
                HapticSwitch(
                  value: isEnabled,
                  onChanged: (_) => onToggle(),
                  activeColor: AppColors.primaryColor,
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
