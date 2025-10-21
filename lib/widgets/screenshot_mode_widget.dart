import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:provider/provider.dart';

/// Widget for controlling screenshot mode
class ScreenshotModeWidget extends StatelessWidget {
  const ScreenshotModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenshotService = ScreenshotModeService();
    final l10n = AppLocalizations.of(context)!;

    if (!screenshotService.isAvailable) {
      return const SizedBox.shrink(); // Hide in production
    }

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return ListenableBuilder(
          listenable: screenshotService,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Screenshot Mode Toggle
                SwitchListTile(
                  title: Text(l10n.screenshotMode),
                  subtitle: Text(l10n.screenshotModeSubtitle),
                  value: screenshotService.isEnabled,
                  onChanged: (v) {
                    if (v) {
                      screenshotService.enableScreenshotMode();
                    } else {
                      screenshotService.disableScreenshotMode();
                      // Resume simulation when screenshot mode is disabled
                      if (appState.simulation.isPaused) {
                        appState.simulation.pause(); // Toggle pause to resume
                      }
                    }
                  },
                  secondary: const Icon(Icons.camera_alt),
                ),

                // Hide UI Toggle (only show when screenshot mode is enabled)
                if (screenshotService.isEnabled) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SwitchListTile(
                      title: Text(l10n.hideUIInScreenshotMode),
                      subtitle: Text(l10n.hideUIInScreenshotModeSubtitle),
                      value: appState.ui.hideUIInScreenshotMode,
                      onChanged: (v) => appState.ui.toggleHideUIInScreenshotMode(),
                      secondary: const Icon(Icons.visibility_off),
                    ),
                  ),
                ],

                // Preset Selection (only show when enabled)
                if (screenshotService.isEnabled) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.scenePreset, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.uiBorderGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: screenshotService.currentPresetIndex,
                              isExpanded: true,
                              items: List.generate(
                                screenshotService.presetCount,
                                (index) => DropdownMenuItem<int>(
                                  value: index,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        screenshotService.getPresetDisplayName(index, l10n),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        screenshotService.getPresetDescription(index, l10n),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onChanged: (index) {
                                if (index != null) {
                                  screenshotService.setPreset(index);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Apply/Navigation Buttons
                        Row(
                          children: [
                            // Previous button
                            IconButton(
                              onPressed: () => screenshotService.previousPreset(),
                              icon: const Icon(Icons.arrow_back_ios),
                              tooltip: l10n.previousPreset,
                            ),

                            // Apply preset button
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  screenshotService.applyCurrentPreset(
                                    l10n: l10n,
                                    simulationState: appState.simulation,
                                    cameraState: appState.camera,
                                    uiState: appState.ui,
                                  );
                                  Navigator.of(context).pop(); // Close settings dialog

                                  // Show a snackbar to inform user
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.appliedPreset(
                                          screenshotService.getPresetDisplayName(
                                            screenshotService.currentPresetIndex,
                                            l10n,
                                          ),
                                        ),
                                      ),
                                      duration: const Duration(seconds: 3),
                                      action: SnackBarAction(
                                        label: l10n.deactivate,
                                        onPressed: () {
                                          screenshotService.deactivate(uiState: appState.ui);
                                          // Resume simulation when deactivating
                                          if (appState.simulation.isPaused) {
                                            appState.simulation.pause(); // Toggle pause to resume
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.camera),
                                label: Text(l10n.applyScene),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),

                            // Next button
                            IconButton(
                              onPressed: () => screenshotService.nextPreset(),
                              icon: const Icon(Icons.arrow_forward_ios),
                              tooltip: l10n.nextPreset,
                            ),
                          ],
                        ),

                        // Active indicator
                        if (screenshotService.isActive) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.sceneActive,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
