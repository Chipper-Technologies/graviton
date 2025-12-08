import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/haptics/haptic_slider_option.dart';
import 'package:graviton/widgets/common/toggle_option.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/enums/gravity_field_color_scheme.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/services/firebase_service.dart';

/// Physics controls content for the persistent bottom sheet
class PhysicsControls extends StatelessWidget {
  final AppState appState;
  final ScrollController scrollController;

  const PhysicsControls({
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
          l10n.physicsVisualizationTitle,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        ToggleOption(
          title: l10n.gravityFieldsTitle,
          description: l10n.gravityFieldsDescription,
          icon: Icons.scatter_plot,
          isEnabled: appState.ui.globalGravityFields,
          onChanged: (_) {
            // Track analytics before toggling
            FirebaseService.instance.logUIEventWithEnums(
              UIAction.gravityFieldsToggle,
              element: UIElement.gravityFieldControls,
              value: (!appState.ui.globalGravityFields).toString(),
              additionalParams: {
                'previous_state': appState.ui.globalGravityFields.toString(),
              },
            );
            appState.ui.toggleGlobalGravityFields();
          },
        ),

        if (appState.ui.globalGravityFields) ...[
          ToggleOption(
            title: l10n.equipotentialSurfacesLabel,
            description: l10n.equipotentialSurfacesDescription,
            icon: Icons.layers,
            isEnabled: appState.ui.showEquipotentialSurfaces,
            onChanged: (_) {
              // Track analytics before toggling
              FirebaseService.instance.logUIEventWithEnums(
                UIAction.equipotentialSurfacesToggle,
                element: UIElement.equipotentialSurfaces,
                value: (!appState.ui.showEquipotentialSurfaces).toString(),
                additionalParams: {
                  'previous_state': appState.ui.showEquipotentialSurfaces
                      .toString(),
                  'gravity_fields_enabled': appState.ui.globalGravityFields
                      .toString(),
                },
              );
              appState.ui.toggleEquipotentialSurfaces();
            },
          ),

          ToggleOption(
            title: l10n.gravityFieldIndicatorsLabel,
            description: l10n.gravityFieldIndicatorsDescription,
            icon: Icons.my_location,
            isEnabled: appState.ui.showGravityFieldIndicators,
            onChanged: (_) {
              // Track analytics before toggling
              FirebaseService.instance.logUIEventWithEnums(
                UIAction.gravityFieldIndicatorsToggle,
                element: UIElement.gravityFieldIndicators,
                value: (!appState.ui.showGravityFieldIndicators).toString(),
                additionalParams: {
                  'previous_state': appState.ui.showGravityFieldIndicators
                      .toString(),
                  'gravity_fields_enabled': appState.ui.globalGravityFields
                      .toString(),
                },
              );
              appState.ui.toggleGravityFieldIndicators();
            },
          ),

          Container(
            margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityHigh,
                      ),
                      size: AppTypography.iconSizeXXLarge,
                    ),
                    SizedBox(width: AppTypography.spacingLarge),
                    Text(
                      l10n.gravityFieldColorSchemeLabel,
                      style: TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTypography.spacingMedium),
                _buildColorSchemeOption(
                  l10n.gravityColorSchemeClassic,
                  'classic',
                  appState,
                ),
                _buildColorSchemeOption(
                  l10n.gravityColorSchemeSpectral,
                  'spectral',
                  appState,
                ),
                _buildColorSchemeOption(
                  l10n.gravityColorSchemeMonochrome,
                  'monochrome',
                  appState,
                ),
                _buildColorSchemeOption(
                  l10n.gravityColorSchemeNeon,
                  'neon',
                  appState,
                ),
                _buildColorSchemeOption(
                  l10n.gravityColorSchemeEmerald,
                  'emerald',
                  appState,
                ),
              ],
            ),
          ),
        ],

        // Simulation Speed Section
        ToggleOption(
          title: l10n.relativisticEffectsTitle,
          description: l10n.relativisticEffectsDescription,
          icon: Icons.flare,
          isEnabled: appState.simulation.enableRelativisticEffects,
          onChanged: (_) {
            // Track analytics before toggling
            FirebaseService.instance.logUIEventWithEnums(
              UIAction.relativisticEffectsToggle,
              element: UIElement.relativisticEffectsControls,
              value: (!appState.simulation.enableRelativisticEffects)
                  .toString(),
              additionalParams: {
                'previous_state': appState.simulation.enableRelativisticEffects
                    .toString(),
              },
            );
            appState.simulation.toggleRelativisticEffects();
          },
        ),

        if (appState.simulation.enableRelativisticEffects) ...[
          ToggleOption(
            title: l10n.relativisticGlowTitle,
            description: l10n.relativisticGlowDescription,
            icon: Icons.brightness_7,
            isEnabled: appState.simulation.showRelativisticGlow,
            onChanged: (_) {
              // Track analytics before toggling
              FirebaseService.instance.logUIEventWithEnums(
                UIAction.relativisticGlowToggle,
                element: UIElement.relativisticGlowVisualization,
                value: (!appState.simulation.showRelativisticGlow).toString(),
                additionalParams: {
                  'previous_state': appState.simulation.showRelativisticGlow
                      .toString(),
                  'relativistic_effects_enabled': appState
                      .simulation
                      .enableRelativisticEffects
                      .toString(),
                },
              );
              appState.simulation.toggleRelativisticGlow();
            },
          ),
        ],

        ToggleOption(
          title: l10n.tidalForcesTitle,
          description: l10n.tidalForcesDescription,
          icon: Icons.water,
          isEnabled: appState.simulation.enableTidalForces,
          onChanged: (_) {
            // Track analytics before toggling
            FirebaseService.instance.logUIEventWithEnums(
              UIAction.tidalForcesToggle,
              element: UIElement.tidalForcesControls,
              value: (!appState.simulation.enableTidalForces).toString(),
              additionalParams: {
                'previous_state': appState.simulation.enableTidalForces
                    .toString(),
              },
            );
            appState.simulation.toggleTidalForces();
          },
        ),

        if (appState.simulation.enableTidalForces) ...[
          ToggleOption(
            title: l10n.tidalVisualizationTitle,
            description: l10n.tidalVisualizationDescription,
            icon: Icons.waves,
            isEnabled: appState.simulation.showTidalVisualization,
            onChanged: (_) {
              // Track analytics before toggling
              FirebaseService.instance.logUIEventWithEnums(
                UIAction.tidalVisualizationToggle,
                element: UIElement.tidalVisualization,
                value: (!appState.simulation.showTidalVisualization).toString(),
                additionalParams: {
                  'previous_state': appState.simulation.showTidalVisualization
                      .toString(),
                  'tidal_forces_enabled': appState.simulation.enableTidalForces
                      .toString(),
                },
              );
              appState.simulation.toggleTidalVisualization();
            },
          ),
        ],

        SectionDivider.labeled(
          l10n.simulationSpeed,
          topSpacing: AppTypography.spacingSmall,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        HapticSliderOption.detailed(
          label: l10n.speedLabel,
          value: appState.simulation.timeScale.clamp(0.1, 16.0),
          min: 0.1,
          max: 16.0,
          divisions: 29,
          icon: Icons.speed,
          onChanged: (value) {
            appState.simulation.setTimeScale(value);
          },
          formatter: (value) => '${NumberUtils.formatDecimal(value, 1)}x',
        ),

        SizedBox(height: AppTypography.spacingMedium),

        // Quick Speed Presets
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSpeedPresetButton(context, appState, 0.5, l10n.speedHalf),
            _buildSpeedPresetButton(context, appState, 1.0, l10n.speedNormal),
            _buildSpeedPresetButton(context, appState, 2.0, l10n.speedDouble),
            _buildSpeedPresetButton(context, appState, 8.0, l10n.speedVeryFast),
            _buildSpeedPresetButton(context, appState, 16.0, l10n.speedMaximum),
          ],
        ),

        SectionDivider.labeled(
          l10n.debugStatisticsTitle,
          topSpacing: AppTypography.spacingLarge,
          bottomSpacing: AppTypography.spacingMedium,
        ),

        ToggleOption(
          title: l10n.showStatisticsTitle,
          description: l10n.showStatisticsDescription,
          icon: Icons.analytics,
          isEnabled: appState.ui.showStats,
          onChanged: (_) => appState.ui.toggleStats(),
          isLast: !appState.ui.showStats, // Only last when stats are hidden
        ),

        if (appState.ui.showStats) ...[
          SectionDivider.labeled(
            l10n.currentStatisticsTitle,
            topSpacing: AppTypography.spacingSmall,
            bottomSpacing: AppTypography.spacingMedium,
          ),

          Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityBarely,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityDisabled,
                ),
                width: AppTypography.borderThin,
              ),
            ),
            child: Column(
              children: [
                _buildStatRow(
                  l10n.bodiesLabel,
                  '${appState.simulation.bodies.length}',
                ),
                SizedBox(height: AppTypography.spacingSmall),
                _buildStatRow(
                  l10n.timeScaleStatLabel,
                  '${NumberUtils.formatDecimal(appState.simulation.timeScale, 1)}x',
                ),
                if (appState.camera.selectedBody != null &&
                    appState.camera.selectedBody! <
                        appState.simulation.bodies.length) ...[
                  SizedBox(height: AppTypography.spacingSmall),
                  _buildStatRow(
                    l10n.selectedStatLabel,
                    appState
                        .simulation
                        .bodies[appState.camera.selectedBody!]
                        .name,
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityHigh,
            ),
            fontSize: AppTypography.fontSizeMedium,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.uiWhite,
            fontSize: AppTypography.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSchemeOption(
    String label,
    String scheme,
    AppState appState,
  ) {
    final isSelected = appState.ui.gravityFieldColorScheme.name == scheme;

    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingXSmall),
      child: Material(
        color: AppColors.transparentColor,
        child: HapticInkWell(
          onTap: () {
            final colorScheme = GravityFieldColorScheme.values.firstWhere(
              (e) => e.name == scheme,
              orElse: () => GravityFieldColorScheme.classic,
            );

            // Track analytics before changing color scheme
            FirebaseService.instance.logUIEventWithEnums(
              UIAction.gravityFieldColorSchemeChanged,
              element: UIElement.gravityFieldColorScheme,
              value: colorScheme.name,
              additionalParams: {
                'previous_scheme': appState.ui.gravityFieldColorScheme.name,
                'new_scheme': colorScheme.name,
                'gravity_fields_enabled': appState.ui.globalGravityFields
                    .toString(),
              },
            );

            appState.ui.setGravityFieldColorScheme(colorScheme);
          },
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    )
                  : AppColors.transparentColor,
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: isSelected
                  ? Border.all(
                      color: AppColors.primaryColor,
                      width: AppTypography.borderThin,
                    )
                  : null,
            ),
            child: Row(
              children: [
                if (isSelected)
                  Icon(
                    Icons.radio_button_checked,
                    color: AppColors.primaryColor,
                    size: AppTypography.iconSizeLarge,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityMedium,
                    ),
                    size: AppTypography.iconSizeLarge,
                  ),
                SizedBox(width: AppTypography.spacingMedium),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                    fontSize: AppTypography.fontSizeMedium,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedPresetButton(
    BuildContext context,
    AppState appState,
    double speed,
    String label,
  ) {
    final isActive = (appState.simulation.timeScale - speed).abs() < 0.1;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTypography.spacingXSmall),
        child: Material(
          color: AppColors.transparentColor,
          child: HapticInkWell(
            onTap: () => appState.simulation.setTimeScale(speed),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppTypography.spacingSmall,
                horizontal: AppTypography.spacingXSmall,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityFaint,
                      )
                    : AppColors.transparentColor,
                borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityDisabled,
                        ),
                  width: AppTypography.borderThin,
                ),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                  fontSize: AppTypography.fontSizeXSmall,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
