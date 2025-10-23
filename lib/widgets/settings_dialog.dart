import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/services/onboarding_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/screenshot_mode_widget.dart';
import 'package:graviton/widgets/tutorial_overlay.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/services/firebase_service.dart';
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
          child: Container(
            width: 400,
            constraints: const BoxConstraints(maxHeight: 600),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title with close button
                Row(
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(width: 8),
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
                const SizedBox(height: 16),
                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Speed Control
                        Text(
                          l10n.speedLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.speed, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${appState.simulation.timeScale.toStringAsFixed(1)}x',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                        const SizedBox(height: 8),

                        // Trails Section
                        Text(
                          l10n.trailsLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        // Trails Toggle
                        SwitchListTile(
                          title: Text(l10n.showTrails),
                          subtitle: Text(l10n.showTrailsDescription),
                          value: appState.ui.showTrails,
                          onChanged: (v) => appState.ui.toggleTrails(),
                          secondary: const Icon(Icons.timeline),
                        ),

                        // Orbital Paths Toggle
                        SwitchListTile(
                          title: Text(l10n.showOrbitalPaths),
                          subtitle: Text(l10n.showOrbitalPathsDescription),
                          value: appState.ui.showOrbitalPaths,
                          onChanged: (v) => appState.ui.toggleOrbitalPaths(),
                          secondary: const Icon(Icons.radio_button_unchecked),
                        ),

                        // Dual Orbital Paths Toggle (only show if orbital paths are enabled)
                        if (appState.ui.showOrbitalPaths)
                          SwitchListTile(
                            title: Text(l10n.dualOrbitalPaths),
                            subtitle: Text(l10n.dualOrbitalPathsDescription),
                            value: appState.ui.dualOrbitalPaths,
                            onChanged: (v) =>
                                appState.ui.toggleDualOrbitalPaths(),
                            secondary: const Icon(Icons.donut_small),
                          ),

                        const SizedBox(height: 16),

                        // Body Labels Toggle
                        SwitchListTile(
                          title: Text(l10n.toggleLabelsTooltip),
                          subtitle: Text(l10n.showLabelsDescription),
                          value: appState.ui.showLabels,
                          onChanged: (v) => appState.ui.toggleLabels(),
                          secondary: const Icon(Icons.label),
                        ),

                        // Off-Screen Indicators Toggle
                        SwitchListTile(
                          title: Text(l10n.offScreenIndicatorsTitle),
                          subtitle: Text(l10n.offScreenIndicatorsDescription),
                          value: appState.ui.showOffScreenIndicators,
                          onChanged: (v) =>
                              appState.ui.toggleOffScreenIndicators(),
                          secondary: const Icon(Icons.navigation),
                        ),

                        Divider(color: AppColors.uiDividerGrey),
                        const SizedBox(height: 8),

                        // Habitability Section - only show if there are planets or moons
                        ..._buildHabitabilitySection(context, l10n, appState),

                        // Tutorial Section
                        Divider(color: AppColors.uiDividerGrey),
                        const SizedBox(height: 16),
                        Text(
                          l10n.helpAndObjectivesTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showTutorialFromSettings(context),
                            icon: const Icon(Icons.school),
                            label: Text(l10n.showTutorialTooltip),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Debug: Reset tutorial state (only in debug mode)
                        if (kDebugMode)
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: () => _resetTutorialState(context),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Reset Tutorial State (Debug)'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Gravity Wells Toggle - Commented out for reimplementation later
                        // SwitchListTile(
                        //   title: Text(l10n.gravityWellsLabel),
                        //   subtitle: Text(l10n.gravityWellsDescription),
                        //   value: appState.ui.showGravityWells,
                        //   onChanged: (v) => appState.ui.toggleGravityWells(),
                        //   secondary: const Icon(Icons.waves),
                        // ),

                        // Divider(color: AppColors.uiDividerGrey),
                        const SizedBox(height: 16),

                        // Camera Controls Section
                        Text(
                          l10n.cameraControlsLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        // Invert Pitch Toggle
                        SwitchListTile(
                          title: Text(l10n.invertPitchControlsLabel),
                          subtitle: Text(l10n.invertPitchControlsDescription),
                          value: appState.camera.invertPitch,
                          onChanged: (v) => appState.camera.toggleInvertPitch(),
                          secondary: const Icon(Icons.swap_vert),
                        ),

                        const SizedBox(height: 16),
                        Divider(color: AppColors.uiDividerGrey),

                        // Screenshot Mode Section (Dev only)
                        if (ScreenshotModeService().isAvailable) ...[
                          Text(
                            l10n.marketingLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const ScreenshotModeWidget(),
                          const SizedBox(height: 16),
                          Divider(color: AppColors.uiDividerGrey),
                        ],

                        // Language Section
                        Text(
                          l10n.languageLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        // Language Selection
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.uiBorderGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with icon and text
                              Row(
                                children: [
                                  const Icon(Icons.language),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(l10n.languageLabel),
                                        Text(
                                          l10n.languageDescription,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
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

                        // Trail Color Selection
                        if (appState.ui.showTrails) ...[
                          const SizedBox(height: 16),
                          Divider(color: AppColors.uiDividerGrey),
                          Text(
                            l10n.trailColorLabel,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
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
                                      icon: const Icon(Icons.ac_unit, size: 16),
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
                      ],
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
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),

      // Habitable Zones Toggle
      SwitchListTile(
        title: Text(l10n.habitableZonesLabel),
        subtitle: Text(l10n.habitableZonesDescription),
        value: appState.ui.showHabitableZones,
        onChanged: (v) => appState.ui.toggleHabitableZones(),
        secondary: const Icon(Icons.circle_outlined),
      ),

      const SizedBox(height: 16),

      // Habitability Indicators Toggle
      SwitchListTile(
        title: Text(l10n.habitabilityIndicatorsLabel),
        subtitle: Text(l10n.habitabilityIndicatorsDescription),
        value: appState.ui.showHabitabilityIndicators,
        onChanged: (v) => appState.ui.toggleHabitabilityIndicators(),
        secondary: const Icon(Icons.public),
      ),

      const SizedBox(height: 16),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tutorial state reset! Restart app to see first-time experience.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
