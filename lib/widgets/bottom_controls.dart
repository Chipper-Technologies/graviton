import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/bottom_tab_button.dart';
import 'package:graviton/widgets/camera_bottom_sheet.dart';
import 'package:graviton/widgets/visuals_bottom_sheet.dart';
import 'package:graviton/widgets/physics_bottom_sheet.dart';
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
            height: 80,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTypography.spacingLarge,
              vertical: AppTypography.spacingSmall,
            ),
            child: Row(
              children: [
                // Camera controls
                Expanded(
                  child: BottomTabButton(
                    icon: Icons.videocam,
                    label: l10n.bottomNavCameraLabel,
                    tooltip: l10n.cameraTooltip,
                    onPressed: () => _showCameraBottomSheet(context, appState),
                    isActive:
                        appState.ui.cinematicCameraTechnique !=
                        CinematicCameraTechnique.manual,
                  ),
                ),

                const SizedBox(width: AppTypography.spacingMedium),

                // Visuals controls
                Expanded(
                  child: BottomTabButton(
                    icon: Icons.palette,
                    label: l10n.bottomNavVisualsLabel,
                    tooltip: l10n.visualsTooltip,
                    onPressed: () => _showVisualsBottomSheet(context, appState),
                    isActive:
                        appState.ui.showTrails ||
                        appState.ui.showLabels ||
                        appState.ui.useRealisticColors,
                  ),
                ),

                const SizedBox(width: AppTypography.spacingMedium),

                // Physics controls
                Expanded(
                  child: BottomTabButton(
                    icon: Icons.science,
                    label: l10n.bottomNavPhysicsLabel,
                    tooltip: l10n.physicsTooltip,
                    onPressed: () => _showPhysicsBottomSheet(context, appState),
                    isActive:
                        appState.ui.globalGravityFields ||
                        appState.ui.showStats,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCameraBottomSheet(BuildContext context, AppState appState) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    const bottomNavHeight = 80.0; // Height of our bottom navigation

    // Calculate max height so sheet stays below bottom nav
    final maxSheetHeight =
        screenHeight - bottomNavHeight - bottomPadding - 60; // Extra margin
    final maxChildSize = (maxSheetHeight / screenHeight).clamp(0.1, 0.8);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true, // Allow tap outside to dismiss
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: (maxChildSize * 0.75).clamp(0.3, 0.6), // 75% of max
        minChildSize: 0.25, // Reasonable min size for dismissal
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => CameraBottomSheet(
          appState: appState,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showVisualsBottomSheet(BuildContext context, AppState appState) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    const bottomNavHeight = 80.0; // Height of our bottom navigation

    // Calculate max height so sheet stays below bottom nav
    final maxSheetHeight =
        screenHeight - bottomNavHeight - bottomPadding - 60; // Extra margin
    final maxChildSize = (maxSheetHeight / screenHeight).clamp(0.1, 0.8);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true, // Allow tap outside to dismiss
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: (maxChildSize * 0.75).clamp(0.3, 0.6), // 75% of max
        minChildSize: 0.25, // Reasonable min size for dismissal
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => VisualsBottomSheet(
          appState: appState,
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _showPhysicsBottomSheet(BuildContext context, AppState appState) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    const bottomNavHeight = 80.0; // Height of our bottom navigation

    // Calculate max height so sheet stays below bottom nav
    final maxSheetHeight =
        screenHeight - bottomNavHeight - bottomPadding - 60; // Extra margin
    final maxChildSize = (maxSheetHeight / screenHeight).clamp(0.1, 0.8);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true, // Allow tap outside to dismiss
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: (maxChildSize * 0.75).clamp(0.3, 0.6), // 75% of max
        minChildSize: 0.25, // Reasonable min size for dismissal
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => PhysicsBottomSheet(
          appState: appState,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
