import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/camera_controls.dart';
import 'package:graviton/widgets/visuals_controls.dart';
import 'package:graviton/widgets/physics_controls.dart';
import 'package:provider/provider.dart';

/// A persistent bottom sheet that contains all control panels (Camera, Visuals, Physics)
/// in a tabbed interface. The sheet is partially visible at the bottom and can be
/// pulled up to reveal the full controls.
class PersistentBottomSheet extends StatefulWidget {
  const PersistentBottomSheet({super.key, this.onInteraction});

  /// Callback triggered when user interacts with the bottom sheet
  final VoidCallback? onInteraction;

  // Static ValueNotifier to track sheet position for floating controls
  static final ValueNotifier<double> _sheetPosition = ValueNotifier(0.25);

  // Public getter for sheet position
  static ValueNotifier<double> get sheetPosition => _sheetPosition;

  @override
  State<PersistentBottomSheet> createState() => _PersistentBottomSheetState();
}

class _PersistentBottomSheetState extends State<PersistentBottomSheet>
    with TickerProviderStateMixin {
  late final DraggableScrollableController _dragController;
  late final TabController _tabController;

  // Control the visibility of the sheet
  static const double _minChildSize =
      0.15; // Small peek at bottom for drag handle
  static const double _initialChildSize = 0.25; // Start with more visible area
  static const double _maxChildSize = 0.80; // Can expand to 80% of screen

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize sheet position
    PersistentBottomSheet.sheetPosition.value = _initialChildSize;

    // Listen to sheet position changes
    _dragController.addListener(() {
      final previousSize = PersistentBottomSheet.sheetPosition.value;
      final currentSize = _dragController.size;

      // Update sheet position
      PersistentBottomSheet.sheetPosition.value = currentSize;

      // Trigger interaction callback if position actually changed
      if ((currentSize - previousSize).abs() > 0.001) {
        widget.onInteraction?.call();
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Add haptic feedback for tab navigation
        HapticUtils.navigate();
        setState(() {
          // Force rebuild when tab changes to update active states
        });
      }
    });
  }

  @override
  void dispose() {
    _dragController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final l10n = AppLocalizations.of(context)!;

        return DraggableScrollableSheet(
          controller: _dragController,
          initialChildSize: _initialChildSize,
          minChildSize: _minChildSize,
          maxChildSize: _maxChildSize,
          snap: true,
          snapSizes: const [_minChildSize, 0.35, _maxChildSize],
          expand: false, // Allow proper sizing
          shouldCloseOnMinExtent: false, // Prevent closing when at minimum
          builder: (context, scrollController) {
            return Stack(
              clipBehavior:
                  Clip.none, // Allow floating controls to extend outside
              children: [
                // Main bottom sheet container with gesture absorption
                GestureDetector(
                  // Absorb all taps to prevent pass-through to simulation
                  onTap: () {},
                  onPanDown: (_) {},
                  onPanStart: (_) {},
                  onPanUpdate: (_) {},
                  onPanEnd: (_) {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.uiBlack.withValues(
                        alpha: AppTypography.opacityVeryHigh,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTypography.radiusXLarge),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.uiBlack.withValues(
                            alpha: AppTypography.opacityMedium,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Handle and tab bar section (always visible)
                        _buildHeaderSection(context, appState, l10n),

                        // Content section (scrollable)
                        Expanded(
                          child: _buildContentSection(
                            context,
                            appState,
                            scrollController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle - prominent and easy to grab
          GestureDetector(
            onTap: () {
              widget.onInteraction?.call();
              // Expand to medium size on tap for better discoverability
              if (_dragController.isAttached) {
                _dragController.animateTo(
                  0.35,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            onPanDown: (details) {
              // Trigger interaction callback when drag starts
              widget.onInteraction?.call();
            },
            child: Container(
              width: double.infinity, // Full width for easier targeting
              padding: const EdgeInsets.symmetric(
                vertical: 20, // Larger touch area
                horizontal: 16,
              ),
              child: Center(
                child: Column(
                  children: [
                    // More prominent drag handle
                    Container(
                      width: 80, // Wider visual handle
                      height: 5, // Slightly thicker
                      decoration: BoxDecoration(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh, // More visible
                        ),
                        borderRadius: AppTypography.createRadius(
                          AppTypography.radiusMedium, // More rounded
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.uiBlack.withValues(
                              alpha: AppTypography.opacityMedium,
                            ),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Secondary indicator for better visibility
                    Container(
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityMedium,
                        ),
                        borderRadius: AppTypography.createRadius(
                          AppTypography.radiusSmall,
                        ),
                      ),
                    ),
                    // Hint text when collapsed to improve discoverability
                    ValueListenableBuilder<double>(
                      valueListenable: PersistentBottomSheet.sheetPosition,
                      builder: (context, position, child) {
                        // Show hint when sheet is in minimum state
                        final isMinimized = position <= (_minChildSize + 0.05);
                        if (!isMinimized) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Tap or swipe up for controls',
                            style: TextStyle(
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityMedium,
                              ),
                              fontSize: AppTypography.fontSizeSmall,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab bar with interaction detection
          GestureDetector(
            onPanDown: (details) {
              // Trigger interaction callback when drag starts
              widget.onInteraction?.call();
            },
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityMediumHigh,
                ),
                borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityVeryFaint,
                  ),
                  width: 1,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMedium,
                      ),
                      AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                    ],
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.uiWhite,
                unselectedLabelColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityMediumHigh,
                ),
                labelStyle: const TextStyle(
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Icon(
                              Icons.videocam,
                              size: AppTypography.iconSizeLarge,
                              color: _isTabActive(0, appState)
                                  ? AppColors.primaryColor
                                  : null,
                            ),
                            // Active indicator dot
                            if (_isTabActive(0, appState))
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.uiOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Text(l10n.bottomNavCameraLabel),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Icon(
                              Icons.palette,
                              size: AppTypography.iconSizeLarge,
                              color: _isTabActive(1, appState)
                                  ? AppColors.primaryColor
                                  : null,
                            ),
                            // Active indicator dot
                            if (_isTabActive(1, appState))
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.uiOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Text(l10n.bottomNavVisualsLabel),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Icon(
                              Icons.science,
                              size: AppTypography.iconSizeLarge,
                              color: _isTabActive(2, appState)
                                  ? AppColors.primaryColor
                                  : null,
                            ),
                            // Active indicator dot
                            if (_isTabActive(2, appState))
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.uiOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Text(l10n.bottomNavPhysicsLabel),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    AppState appState,
    ScrollController scrollController,
  ) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Camera controls content only
        _buildCameraContent(context, appState, scrollController),

        // Visuals controls content only
        _buildVisualsContent(context, appState, scrollController),

        // Physics controls content only
        _buildPhysicsContent(context, appState, scrollController),
      ],
    );
  }

  Widget _buildCameraContent(
    BuildContext context,
    AppState appState,
    ScrollController scrollController,
  ) {
    return CameraControls(
      appState: appState,
      scrollController: scrollController,
    );
  }

  Widget _buildVisualsContent(
    BuildContext context,
    AppState appState,
    ScrollController scrollController,
  ) {
    return VisualsControls(
      appState: appState,
      scrollController: scrollController,
    );
  }

  Widget _buildPhysicsContent(
    BuildContext context,
    AppState appState,
    ScrollController scrollController,
  ) {
    return PhysicsControls(
      appState: appState,
      scrollController: scrollController,
    );
  }

  /// Check if a tab should show as "active" based on app state
  bool _isTabActive(int tabIndex, AppState appState) {
    switch (tabIndex) {
      case 0: // Camera
        return appState.ui.cinematicCameraTechnique !=
            CinematicCameraTechnique.manual;
      case 1: // Visuals
        return appState.ui.showTrails ||
            appState.ui.showLabels ||
            appState.ui.useRealisticColors;
      case 2: // Physics
        return appState.ui.globalGravityFields ||
            appState.ui.showStats ||
            appState.ui.showEquipotentialSurfaces ||
            appState.ui.showGravityFieldIndicators;
      default:
        return false;
    }
  }
}
