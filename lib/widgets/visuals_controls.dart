import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/widgets/section_title.dart';

/// Visuals controls content for the persistent bottom sheet
class VisualsControls extends StatelessWidget {
  final AppState appState;
  final ScrollController scrollController;

  const VisualsControls({
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
            AppTypography.spacingXLarge +
            PlatformUtils.getBottomSheetSystemBarPadding(), // Platform-specific padding for system bar
      ),
      children: [
        SectionTitle(title: l10n.displayOptionsTitle),
        SizedBox(height: AppTypography.spacingMedium),

        _buildToggleOption(
          l10n.showTrailsTitle,
          l10n.showTrailsDescription,
          Icons.timeline,
          appState.ui.showTrails,
          () => appState.ui.toggleTrails(),
        ),

        _buildToggleOption(
          l10n.showLabelsTitle,
          l10n.showLabelsDescription,
          Icons.label,
          appState.ui.showLabels,
          () => appState.ui.toggleLabels(),
        ),

        _buildToggleOption(
          l10n.realisticColorsTitle,
          l10n.realisticColorsDescription,
          Icons.color_lens,
          appState.ui.useRealisticColors,
          () => appState.ui.toggleRealisticColors(),
        ),

        _buildToggleOption(
          l10n.habitableZonesLabel,
          l10n.habitableZonesDescription,
          Icons.eco,
          appState.ui.showHabitableZones,
          () => appState.ui.toggleHabitableZones(),
        ),

        _buildToggleOption(
          l10n.habitabilityIndicatorsLabel,
          l10n.habitabilityIndicatorsDescription,
          Icons.circle,
          appState.ui.showHabitabilityIndicators,
          () => appState.ui.toggleHabitabilityIndicators(),
        ),

        SizedBox(height: AppTypography.spacingXXLarge),

        SectionTitle(title: l10n.pathVisualizationTitle),
        SizedBox(height: AppTypography.spacingMedium),

        _buildToggleOption(
          l10n.showOrbitalPaths,
          l10n.showOrbitalPathsDescription,
          Icons.radio_button_unchecked,
          appState.ui.showOrbitalPaths,
          () => appState.ui.toggleOrbitalPaths(),
        ),

        if (appState.ui.showOrbitalPaths)
          _buildToggleOption(
            l10n.dualOrbitalPaths,
            l10n.dualOrbitalPathsDescription,
            Icons.donut_small,
            appState.ui.dualOrbitalPaths,
            () => appState.ui.toggleDualOrbitalPaths(),
          ),

        SizedBox(height: AppTypography.spacingXXLarge),

        SectionTitle(title: l10n.navigationAidsTitle),
        SizedBox(height: AppTypography.spacingMedium),

        _buildToggleOption(
          l10n.offScreenIndicatorsTitle,
          l10n.offScreenIndicatorsDescription,
          Icons.navigation,
          appState.ui.showOffScreenIndicators,
          () => appState.ui.toggleOffScreenIndicators(),
        ),
      ],
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
