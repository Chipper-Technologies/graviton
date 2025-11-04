import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/painters/gradient_grid_painter.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/camera_controls.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';
import 'package:graviton/widgets/physics_controls.dart';
import 'package:graviton/widgets/visuals_controls.dart';
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
            height: 34 + MediaQuery.of(context).padding.bottom,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.uiBlack, width: 4.0),
              ),
            ),
            child: Stack(
              children: [
                // Background layer - slightly transparent black to match Android system bar
                Positioned.fill(
                  child: Container(
                    color: AppColors.uiBlack.withValues(
                      alpha: AppTypography.opacityVeryHigh,
                    ),
                  ),
                ),

                // Purple grid overlay with gradient fade
                Positioned.fill(
                  child: CustomPaint(
                    painter: GradientGridPainter(
                      gridSize: 6.0,
                      gridColor: AppColors.primaryColor,
                      opacity: 0.03, // Slightly higher opacity for visibility
                    ),
                  ),
                ),

                // Button row with borders
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Row(
                    children: [
                      // Left border for Camera button
                      Container(
                        width: 4,
                        height: double.infinity,
                        color: AppColors.uiBlack,
                      ),

                      // Camera button
                      Expanded(
                        child: _buildTabButton(
                          context: context,
                          icon: Icons.videocam,
                          label: l10n.bottomNavCameraLabel,
                          tooltip: l10n.cameraTooltip,
                          onPressed: () =>
                              _showCameraBottomSheet(context, appState),
                          isActive:
                              appState.ui.cinematicCameraTechnique !=
                              CinematicCameraTechnique.manual,
                          isFirst: true,
                        ),
                      ),

                      // Vertical border between Camera and Visuals
                      Container(
                        width: 4,
                        height: double.infinity,
                        color: AppColors.uiBlack,
                      ),

                      // Visuals button
                      Expanded(
                        child: _buildTabButton(
                          context: context,
                          icon: Icons.palette,
                          label: l10n.bottomNavVisualsLabel,
                          tooltip: l10n.visualsTooltip,
                          onPressed: () =>
                              _showVisualsBottomSheet(context, appState),
                          isActive:
                              appState.ui.showTrails ||
                              appState.ui.showLabels ||
                              appState.ui.useRealisticColors,
                        ),
                      ),

                      // Vertical border between Visuals and Physics
                      Container(
                        width: 4,
                        height: double.infinity,
                        color: AppColors.uiBlack,
                      ),

                      // Physics button
                      Expanded(
                        child: _buildTabButton(
                          context: context,
                          icon: Icons.science,
                          label: l10n.bottomNavPhysicsLabel,
                          tooltip: l10n.physicsTooltip,
                          onPressed: () =>
                              _showPhysicsBottomSheet(context, appState),
                          isActive:
                              appState.ui.globalGravityFields ||
                              appState.ui.showStats ||
                              appState.ui.showEquipotentialSurfaces ||
                              appState.ui.showGravityFieldIndicators,
                          isLast: true,
                        ),
                      ),

                      // Right border for Physics button
                      Container(
                        width: 4,
                        height: double.infinity,
                        color: AppColors.uiBlack,
                      ),
                    ],
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
        builder: (context, scrollController) => CameraControls(
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
        builder: (context, scrollController) => VisualsControls(
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
        builder: (context, scrollController) => PhysicsControls(
          appState: appState,
          scrollController: scrollController,
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String tooltip,
    required VoidCallback? onPressed,
    required bool isActive,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isEnabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        color: Colors.transparent,
        child: HapticInkWell(
          onTap: onPressed,
          splashColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityDisabled,
          ),
          highlightColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityBarely,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppTypography.radiusMedium),
            topRight: Radius.circular(AppTypography.radiusMedium),
          ),
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                // Purple gradient overlay for active buttons
                if (isActive)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTypography.radiusMedium),
                          topRight: Radius.circular(AppTypography.radiusMedium),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryColor.withValues(
                              alpha: AppTypography.opacityFaint,
                            ),
                            AppColors.primaryColor.withValues(
                              alpha: AppTypography.opacityVeryFaint,
                            ),
                            AppColors.primaryColor.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.4, 0.7],
                        ),
                      ),
                    ),
                  ),

                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          // Border/stroke layer
                          Icon(
                            icon,
                            color: !isEnabled
                                ? AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityDisabled,
                                  )
                                : isActive
                                ? AppColors.primaryColor
                                : AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityHigh,
                                  ),
                            size: AppTypography.iconSizeXLarge,
                            shadows: [
                              // Create sharp stroke with dense shadow pattern
                              Shadow(
                                offset: const Offset(-2.0, 0.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(2.0, 0.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(0.0, -2.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(0.0, 2.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(-1.0, -1.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(1.0, -1.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(1.0, 1.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                              Shadow(
                                offset: const Offset(-1.0, 1.0),
                                color: !isEnabled
                                    ? AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      )
                                    : isActive
                                    ? AppColors.uiBlack
                                    : AppColors.uiBlack.withValues(
                                        alpha: AppTypography.opacityMedium,
                                      ),
                              ),
                            ],
                          ),
                          // Fill layer
                          Icon(
                            icon,
                            color: !isEnabled
                                ? AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityDisabled,
                                  )
                                : isActive
                                ? AppColors.primaryColor
                                : AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityHigh,
                                  ),
                            size: AppTypography.iconSizeXLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        label,
                        style: TextStyle(
                          color: !isEnabled
                              ? AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacityDisabled,
                                )
                              : isActive
                              ? AppColors.uiWhite
                              : AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacityHigh,
                                ),
                          fontSize: AppTypography.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
