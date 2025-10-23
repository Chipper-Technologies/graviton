import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: l10n.toggleStatsTooltip,
                preferBelow: false,
                child: IconButton(
                  icon: Icon(
                    appState.ui.showStats
                        ? Icons.analytics
                        : Icons.analytics_outlined,
                  ),
                  onPressed: () => appState.ui.toggleStats(),
                ),
              ),
              Tooltip(
                message: l10n.autoRotateTooltip,
                preferBelow: false,
                child: IconButton(
                  icon: Icon(
                    appState.camera.autoRotate
                        ? Icons.rotate_right
                        : Icons.rotate_right_outlined,
                  ),
                  onPressed: () => appState.camera.toggleAutoRotate(),
                ),
              ),
              Tooltip(
                message: appState.camera.followMode
                    ? l10n.stopFollowingTooltip
                    : (appState.camera.selectedBody != null
                          ? l10n.followObjectTooltip
                          : l10n.selectObjectToFollowTooltip),
                preferBelow: false,
                child: IconButton(
                  icon: Icon(
                    appState.camera.followMode
                        ? Icons.track_changes
                        : Icons.track_changes_outlined,
                  ),
                  onPressed: appState.camera.selectedBody != null
                      ? () => appState.camera.toggleFollowMode(
                          appState.simulation.bodies,
                        )
                      : null, // Disabled when no object selected
                ),
              ),
              Tooltip(
                message: l10n.centerViewTooltip,
                preferBelow: false,
                child: IconButton(
                  icon: const Icon(Icons.center_focus_strong),
                  onPressed: () => appState.camera.resetView(
                    appState.simulation.currentScenario,
                  ),
                ),
              ),
              Tooltip(
                message: AppLocalizations.of(context)!.focusOnNearestTooltip,
                preferBelow: false,
                child: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: appState.simulation.bodies.isNotEmpty
                      ? () => appState.camera.focusOnNearestBody(
                          appState.simulation.bodies,
                        )
                      : null, // Disabled when no bodies
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
