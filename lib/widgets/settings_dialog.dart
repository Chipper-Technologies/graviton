import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/onboarding_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/screenshot_mode_widget.dart';
import 'package:graviton/widgets/tutorial_overlay.dart';
import 'package:provider/provider.dart';

/// Dialog for adjusting simulation settings
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
          ),
          child: Container(
            constraints: AppConstraints.dialogMedium,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title with close button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.uiOrangeAccent.withValues(alpha: 0.15),
                        AppColors.uiOrangeAccent.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTypography.radiusXLarge),
                      topRight: Radius.circular(AppTypography.radiusXLarge),
                    ),
                  ),
                  padding: EdgeInsets.all(AppTypography.spacingLarge),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: AppColors.uiOrangeAccent,
                        size: 28,
                      ),
                      SizedBox(width: AppTypography.spacingMedium),
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Flexible(
                  child: Padding(
                    padding: AppConstraints.dialogPadding,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Speed Control
                          Text(
                            l10n.speedLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.sectionTitlePurple),
                          ),
                          SizedBox(height: AppTypography.spacingSmall),
                          Row(
                            children: [
                              const Icon(Icons.speed, size: 20),
                              SizedBox(width: AppTypography.spacingSmall),
                              Text(
                                '${appState.simulation.timeScale.toStringAsFixed(1)}x',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          SizedBox(height: AppTypography.spacingXSmall),
                          SizedBox(
                            width: double.infinity,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                inactiveTrackColor: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(
                                      alpha: AppTypography.opacityVeryFaint,
                                    ),
                                activeTrackColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                              child: Slider(
                                min: 0.1,
                                max: 16.0,
                                divisions: 159,
                                value: appState.simulation.timeScale.clamp(
                                  0.1,
                                  16.0,
                                ),
                                label:
                                    '${appState.simulation.timeScale.toStringAsFixed(1)}x',
                                onChanged: (v) =>
                                    appState.simulation.setTimeScale(v),
                              ),
                            ),
                          ),

                          Divider(color: AppColors.uiDividerGrey),
                          SizedBox(height: AppTypography.spacingSmall),

                          // Trails Section
                          Text(
                            l10n.trailsLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.sectionTitlePurple),
                          ),
                          SizedBox(height: AppTypography.spacingSmall),

                          // Trails Toggle
                          SwitchListTile(
                            title: Text(l10n.showTrails),
                            subtitle: Text(
                              l10n.showTrailsDescription,
                              style: TextStyle(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            value: appState.ui.showTrails,
                            onChanged: (v) => appState.ui.toggleTrails(),
                            secondary: const Icon(Icons.timeline),
                          ),

                          // Orbital Paths Toggle
                          SwitchListTile(
                            title: Text(l10n.showOrbitalPaths),
                            subtitle: Text(
                              l10n.showOrbitalPathsDescription,
                              style: TextStyle(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            value: appState.ui.showOrbitalPaths,
                            onChanged: (v) => appState.ui.toggleOrbitalPaths(),
                            secondary: const Icon(Icons.radio_button_unchecked),
                          ),

                          // Dual Orbital Paths Toggle (only show if orbital paths are enabled)
                          if (appState.ui.showOrbitalPaths)
                            SwitchListTile(
                              title: Text(l10n.dualOrbitalPaths),
                              subtitle: Text(
                                l10n.dualOrbitalPathsDescription,
                                style: TextStyle(
                                  color: AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacitySemiTransparent,
                                  ),
                                ),
                              ),
                              value: appState.ui.dualOrbitalPaths,
                              onChanged: (v) =>
                                  appState.ui.toggleDualOrbitalPaths(),
                              secondary: const Icon(Icons.donut_small),
                            ),

                          SizedBox(height: AppTypography.spacingLarge),

                          // Body Labels Toggle
                          SwitchListTile(
                            title: Text(l10n.toggleLabelsTooltip),
                            subtitle: Text(
                              l10n.showLabelsDescription,
                              style: TextStyle(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            value: appState.ui.showLabels,
                            onChanged: (v) => appState.ui.toggleLabels(),
                            secondary: const Icon(Icons.label),
                          ),

                          // Off-Screen Indicators Toggle
                          SwitchListTile(
                            title: Text(l10n.offScreenIndicatorsTitle),
                            subtitle: Text(
                              l10n.offScreenIndicatorsDescription,
                              style: TextStyle(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            value: appState.ui.showOffScreenIndicators,
                            onChanged: (v) =>
                                appState.ui.toggleOffScreenIndicators(),
                            secondary: const Icon(Icons.navigation),
                          ),

                          Divider(color: AppColors.uiDividerGrey),
                          SizedBox(height: AppTypography.spacingSmall),

                          // Habitability Section - only show if there are planets or moons
                          ..._buildHabitabilitySection(context, l10n, appState),

                          // Camera Controls Section
                          Text(
                            l10n.cameraControlsLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.sectionTitlePurple),
                          ),
                          SizedBox(height: AppTypography.spacingSmall),

                          // Invert Pitch Toggle
                          SwitchListTile(
                            title: Text(l10n.invertPitchControlsLabel),
                            subtitle: Text(
                              l10n.invertPitchControlsDescription,
                              style: TextStyle(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            value: appState.camera.invertPitch,
                            onChanged: (v) =>
                                appState.camera.toggleInvertPitch(),
                            secondary: const Icon(Icons.swap_vert),
                          ),

                          SizedBox(height: AppTypography.spacingLarge),

                          // Cinematic Camera Technique Selection
                          Container(
                            padding: EdgeInsets.all(AppTypography.spacingLarge),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.uiBorderGrey),
                              borderRadius: BorderRadius.circular(
                                AppTypography.radiusMedium,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with icon and text
                                Row(
                                  children: [
                                    const Icon(Icons.smart_toy),
                                    SizedBox(
                                      width: AppTypography.spacingMedium,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.cinematicCameraTechniqueLabel,
                                          ),
                                          Text(
                                            l10n.cinematicCameraTechniqueDescription,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.uiWhite
                                                      .withValues(
                                                        alpha: AppTypography
                                                            .opacitySemiTransparent,
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppTypography.spacingMedium),
                                // Dropdown below
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownButton<CinematicCameraTechnique>(
                                    value: appState.ui.cinematicCameraTechnique,
                                    underline: Container(),
                                    isExpanded: true,
                                    onChanged:
                                        (CinematicCameraTechnique? newValue) {
                                          if (newValue != null) {
                                            appState.ui
                                                .setCinematicCameraTechnique(
                                                  newValue,
                                                );
                                          }
                                        },
                                    items: CinematicCameraTechnique.values
                                        .map(
                                          (
                                            technique,
                                          ) => DropdownMenuItem<CinematicCameraTechnique>(
                                            value: technique,
                                            child: SizedBox(
                                              height:
                                                  44, // Ensure we fit within the dropdown constraints
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    technique.displayName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          height:
                                                              1.1, // Tighter line height
                                                        ),
                                                  ),
                                                  Text(
                                                    technique.description,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: Theme.of(context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color
                                                              ?.withValues(
                                                                alpha: AppTypography
                                                                    .opacityHigh,
                                                              ),
                                                          height:
                                                              1.1, // Tighter line height
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines:
                                                        1, // Reduce to 1 line to fit
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: AppTypography.spacingLarge),
                          Divider(color: AppColors.uiDividerGrey),

                          // Screenshot Mode Section (Dev only)
                          if (ScreenshotModeService().isAvailable) ...[
                            Text(
                              l10n.marketingLabel,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.sectionTitlePurple,
                                  ),
                            ),
                            SizedBox(height: AppTypography.spacingSmall),
                            const ScreenshotModeWidget(),
                            SizedBox(height: AppTypography.spacingLarge),
                            Divider(color: AppColors.uiDividerGrey),
                          ],

                          // Language Section
                          Text(
                            l10n.languageLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.sectionTitlePurple),
                          ),
                          SizedBox(height: AppTypography.spacingSmall),

                          // Language Selection
                          Container(
                            padding: EdgeInsets.all(AppTypography.spacingLarge),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.uiBorderGrey),
                              borderRadius: BorderRadius.circular(
                                AppTypography.radiusMedium,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with icon and text
                                Row(
                                  children: [
                                    const Icon(Icons.language),
                                    SizedBox(
                                      width: AppTypography.spacingMedium,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(l10n.languageLabel),
                                          Text(
                                            l10n.languageDescription,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.uiWhite
                                                      .withValues(
                                                        alpha: AppTypography
                                                            .opacitySemiTransparent,
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppTypography.spacingMedium),
                                // Dropdown below
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownButton<String?>(
                                    value: appState.ui.selectedLanguageCode,
                                    underline: Container(),
                                    isExpanded: true,
                                    onChanged: (String? newValue) {
                                      appState.ui.setLanguage(newValue);
                                    },
                                    items: [
                                      DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text(l10n.languageSystem),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'en',
                                        child: Text(l10n.languageEnglish),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'de',
                                        child: Text(l10n.languageGerman),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'es',
                                        child: Text(l10n.languageSpanish),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'fr',
                                        child: Text(l10n.languageFrench),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'zh',
                                        child: Text(l10n.languageChinese),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'ja',
                                        child: Text(l10n.languageJapanese),
                                      ),
                                      DropdownMenuItem<String?>(
                                        value: 'ko',
                                        child: Text(l10n.languageKorean),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Realistic Colors Toggle
                          SizedBox(height: AppTypography.spacingLarge),
                          Divider(color: AppColors.uiDividerGrey),
                          SwitchListTile(
                            title: Text(l10n.realisticColors),
                            subtitle: Text(
                              l10n.realisticColorsDescription,
                              style: TextStyle(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacitySemiTransparent,
                                ),
                              ),
                            ),
                            value: appState.ui.useRealisticColors,
                            onChanged: (v) =>
                                appState.ui.toggleRealisticColors(),
                            secondary: const Icon(Icons.palette),
                          ),

                          // Trail Color Selection (only show when NOT using realistic colors)
                          if (appState.ui.showTrails &&
                              !appState.ui.useRealisticColors) ...[
                            SizedBox(height: AppTypography.spacingLarge),
                            Text(
                              l10n.trailColorLabel,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: AppTypography.spacingSmall),
                            Row(
                              children: [
                                Expanded(
                                  child: SegmentedButton<bool>(
                                    segments: [
                                      ButtonSegment<bool>(
                                        value: true,
                                        label: Text(l10n.warmTrails),
                                        icon: const Icon(
                                          Icons.local_fire_department,
                                          size: 16,
                                        ),
                                      ),
                                      ButtonSegment<bool>(
                                        value: false,
                                        label: Text(l10n.coolTrails),
                                        icon: const Icon(
                                          Icons.ac_unit,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                    selected: {appState.ui.useWarmTrails},
                                    onSelectionChanged: (Set<bool> selection) {
                                      if (selection.isNotEmpty) {
                                        final useWarm = selection.first;
                                        if (useWarm !=
                                            appState.ui.useWarmTrails) {
                                          appState.ui.toggleWarmTrails();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // Tutorial Section (moved to bottom)
                          SizedBox(height: AppTypography.spacingLarge),
                          Divider(color: AppColors.uiDividerGrey),
                          SizedBox(height: AppTypography.spacingLarge),
                          Text(
                            l10n.helpAndObjectivesTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.sectionTitlePurple),
                          ),
                          SizedBox(height: AppTypography.spacingLarge),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _showTutorialFromSettings(context),
                                  icon: const Icon(Icons.school),
                                  label: Text(l10n.tutorialButton),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppTypography.spacingMedium,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                              ),
                              // Debug: Reset tutorial state (only in debug mode)
                              if (kDebugMode) ...[
                                SizedBox(width: AppTypography.spacingMedium),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () =>
                                        _resetTutorialState(context),
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: Text(l10n.resetTutorialButton),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppTypography.spacingMedium,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build habitability section only if there are planets or moons
  List<Widget> _buildHabitabilitySection(
    BuildContext context,
    AppLocalizations l10n,
    AppState appState,
  ) {
    final hasPlanetsOrMoons = appState.simulation.bodies.any(
      (body) =>
          body.bodyType == BodyType.planet || body.bodyType == BodyType.moon,
    );

    if (!hasPlanetsOrMoons) {
      return []; // Return empty list if no planets/moons
    }

    return [
      Text(
        l10n.habitabilityLabel,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: AppColors.sectionTitlePurple),
      ),
      SizedBox(height: AppTypography.spacingSmall),

      // Habitable Zones Toggle
      SwitchListTile(
        title: Text(l10n.habitableZonesLabel),
        subtitle: Text(
          l10n.habitableZonesDescription,
          style: TextStyle(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacitySemiTransparent,
            ),
          ),
        ),
        value: appState.ui.showHabitableZones,
        onChanged: (v) => appState.ui.toggleHabitableZones(),
        secondary: const Icon(Icons.circle_outlined),
      ),

      SizedBox(height: AppTypography.spacingLarge),

      // Habitability Indicators Toggle
      SwitchListTile(
        title: Text(l10n.habitabilityIndicatorsLabel),
        subtitle: Text(
          l10n.habitabilityIndicatorsDescription,
          style: TextStyle(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacitySemiTransparent,
            ),
          ),
        ),
        value: appState.ui.showHabitabilityIndicators,
        onChanged: (v) => appState.ui.toggleHabitabilityIndicators(),
        secondary: const Icon(Icons.public),
      ),

      SizedBox(height: AppTypography.spacingLarge),
      Divider(color: AppColors.uiDividerGrey),
      SizedBox(height: AppTypography.spacingLarge),
    ];
  }

  /// Show tutorial overlay from settings
  void _showTutorialFromSettings(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tutorialStarted,
      element: UIElement.tutorial,
    );

    final currentContext = context;

    // Close the settings dialog first
    Navigator.of(context).pop();

    // Then show the tutorial
    showDialog<void>(
      context: currentContext,
      barrierDismissible: false,
      builder: (dialogContext) => TutorialOverlay(
        onComplete: () async {
          await OnboardingService.markTutorialCompleted();
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }

          FirebaseService.instance.logUIEventWithEnums(
            UIAction.tutorialCompleted,
            element: UIElement.tutorial,
          );
        },
      ),
    );
  }

  /// Reset tutorial state for testing (debug only)
  void _resetTutorialState(BuildContext context) async {
    await OnboardingService.resetTutorialState();
    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tutorialResetMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
