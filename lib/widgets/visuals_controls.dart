import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/haptics/haptic_switch.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/services/firebase_service.dart';

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
        bottom:
            PlatformUtils.getBottomSheetSystemBarPadding(), // Platform-specific padding for system bar
      ),
      children: [
        SectionDivider.labeled(
          l10n.displayOptionsTitle,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        _buildToggleOption(
          l10n.showTrails,
          l10n.showTrailsDescription,
          Icons.timeline,
          appState.ui.showTrails,
          () => _toggleWithAnalytics(
            UIAction.trailDisplayToggle,
            UIElement.trailControls,
            'trails',
            appState.ui.showTrails,
            appState.ui.toggleTrails,
          ),
        ),

        _buildToggleOption(
          l10n.showLabelsTitle,
          l10n.showLabelsDescription,
          Icons.label,
          appState.ui.showLabels,
          () => _toggleWithAnalytics(
            UIAction.labelDisplayToggle,
            UIElement.labelControls,
            'labels',
            appState.ui.showLabels,
            appState.ui.toggleLabels,
          ),
        ),

        _buildToggleOption(
          l10n.realisticColors,
          l10n.realisticColorsDescription,
          Icons.color_lens,
          appState.ui.useRealisticColors,
          () => _toggleWithAnalytics(
            UIAction.realisticColorsToggle,
            UIElement.colorSchemeControls,
            'realistic_colors',
            appState.ui.useRealisticColors,
            appState.ui.toggleRealisticColors,
          ),
        ),

        _buildToggleOption(
          l10n.habitableZonesLabel,
          l10n.habitableZonesDescription,
          Icons.eco,
          appState.ui.showHabitableZones,
          () => _toggleWithAnalytics(
            UIAction.habitableZonesToggle,
            UIElement.habitableZoneControls,
            'habitable_zones',
            appState.ui.showHabitableZones,
            appState.ui.toggleHabitableZones,
          ),
        ),

        _buildToggleOption(
          l10n.habitabilityIndicatorsLabel,
          l10n.habitabilityIndicatorsDescription,
          Icons.circle,
          appState.ui.showHabitabilityIndicators,
          () => _toggleWithAnalytics(
            UIAction.habitabilityIndicatorsToggle,
            UIElement.habitableZoneControls,
            'habitability_indicators',
            appState.ui.showHabitabilityIndicators,
            appState.ui.toggleHabitabilityIndicators,
          ),
        ),

        _buildToggleOption(
          l10n.stellarCoronasTitle,
          l10n.stellarCoronasDescription,
          Icons.wb_sunny,
          appState.ui.showStellarCoronas,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.visualControls,
            'stellar_coronas',
            appState.ui.showStellarCoronas,
            appState.ui.toggleStellarCoronas,
          ),
        ),

        _buildToggleOption(
          l10n.atmosphericEffectsTitle,
          l10n.atmosphericEffectsDescription,
          Icons.cloud_circle,
          appState.ui.showAtmosphericEffects,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.visualControls,
            'atmospheric_effects',
            appState.ui.showAtmosphericEffects,
            appState.ui.toggleAtmosphericEffects,
          ),
        ),

        SectionDivider.labeled(
          l10n.lightingEffectsLabel,
          topSpacing: AppTypography.spacingSmall,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        _buildToggleOption(
          l10n.hemisphereLightingTitle,
          l10n.hemisphereLightingDescription,
          Icons.brightness_5,
          appState.ui.enableHemisphereLighting,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.hemisphereLightingToggle,
            'hemisphere_lighting',
            appState.ui.enableHemisphereLighting,
            appState.ui.toggleHemisphereLighting,
          ),
        ),

        _buildToggleOption(
          l10n.castShadowsTitle,
          l10n.castShadowsDescription,
          Icons.lens_blur,
          appState.ui.enableCastShadows,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.castShadowsToggle,
            'cast_shadows',
            appState.ui.enableCastShadows,
            appState.ui.toggleCastShadows,
          ),
        ),

        _buildToggleOption(
          l10n.specularHighlightsTitle,
          l10n.specularHighlightsDescription,
          Icons.auto_awesome,
          appState.ui.enableSpecularHighlights,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.specularHighlightsToggle,
            'specular_highlights',
            appState.ui.enableSpecularHighlights,
            appState.ui.toggleSpecularHighlights,
          ),
        ),

        SectionDivider.labeled(
          l10n.pathVisualizationTitle,
          topSpacing: AppTypography.spacingSmall,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        _buildToggleOption(
          l10n.showOrbitalPaths,
          l10n.showOrbitalPathsDescription,
          Icons.radio_button_unchecked,
          appState.ui.showOrbitalPaths,
          () => _toggleWithAnalytics(
            UIAction.orbitalPathsToggle,
            UIElement.orbitalPathControls,
            'orbital_paths',
            appState.ui.showOrbitalPaths,
            appState.ui.toggleOrbitalPaths,
          ),
        ),

        if (appState.ui.showOrbitalPaths)
          _buildToggleOption(
            l10n.dualOrbitalPaths,
            l10n.dualOrbitalPathsDescription,
            Icons.donut_small,
            appState.ui.dualOrbitalPaths,
            () => _toggleWithAnalytics(
              UIAction.dualOrbitalPathsToggle,
              UIElement.orbitalPathControls,
              'dual_orbital_paths',
              appState.ui.dualOrbitalPaths,
              appState.ui.toggleDualOrbitalPaths,
            ),
          ),

        SectionDivider.labeled(
          l10n.navigationAidsTitle,
          topSpacing: AppTypography.spacingSmall,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        _buildToggleOption(
          l10n.offScreenIndicatorsTitle,
          l10n.offScreenIndicatorsDescription,
          Icons.navigation,
          appState.ui.showOffScreenIndicators,
          () => _toggleWithAnalytics(
            UIAction.offscreenIndicatorsToggle,
            UIElement.navigationAidsControls,
            'offscreen_indicators',
            appState.ui.showOffScreenIndicators,
            appState.ui.toggleOffScreenIndicators,
          ),
        ),

        SectionDivider.labeled(
          l10n.collisionEffectsTitle,
          topSpacing: AppTypography.spacingSmall,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        _buildToggleOption(
          l10n.showCollisionDebris,
          l10n.showCollisionDebrisDescription,
          Icons.grain,
          appState.ui.showCollisionDebris,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.visualEffectsControls,
            'collision_debris',
            appState.ui.showCollisionDebris,
            appState.ui.toggleCollisionDebris,
          ),
        ),

        _buildToggleOption(
          l10n.showCollisionShockwaves,
          l10n.showCollisionShockwavesDescription,
          Icons.radio_button_unchecked,
          appState.ui.showCollisionShockwaves,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.visualEffectsControls,
            'collision_shockwaves',
            appState.ui.showCollisionShockwaves,
            appState.ui.toggleCollisionShockwaves,
          ),
        ),

        _buildToggleOption(
          l10n.showCollisionEjection,
          l10n.showCollisionEjectionDescription,
          Icons.cloud,
          appState.ui.showCollisionEjection,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.visualEffectsControls,
            'collision_ejection',
            appState.ui.showCollisionEjection,
            appState.ui.toggleCollisionEjection,
          ),
        ),

        _buildToggleOption(
          l10n.showCollisionPlasmaJets,
          l10n.showCollisionPlasmaJetsDescription,
          Icons.bolt,
          appState.ui.showCollisionPlasmaJets,
          () => _toggleWithAnalytics(
            UIAction.visualEffectToggle,
            UIElement.visualEffectsControls,
            'collision_plasma_jets',
            appState.ui.showCollisionPlasmaJets,
            appState.ui.toggleCollisionPlasmaJets,
          ),
          isLast: true,
        ),
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
        color: AppColors.transparentColor,
        child: Semantics(
          label: title,
          hint: description,
          value: isEnabled ? 'enabled' : 'disabled',
          toggled: isEnabled,
          button: true,
          onTap: onToggle,
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
      ),
    );
  }

  /// Helper method to track analytics for toggle operations
  void _toggleWithAnalytics(
    UIAction action,
    UIElement element,
    String settingName,
    bool currentValue,
    VoidCallback toggleFunction,
  ) {
    // Track analytics before toggling
    FirebaseService.instance.logUIEventWithEnums(
      action,
      element: element,
      value: (!currentValue).toString(),
      additionalParams: {
        'setting': settingName,
        'previous_state': currentValue.toString(),
        'new_state': (!currentValue).toString(),
      },
    );

    // Execute the toggle function
    toggleFunction();
  }
}
