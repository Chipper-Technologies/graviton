import 'package:flutter/material.dart';
import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/camera_controls.dart';
import 'package:graviton/widgets/visuals_controls.dart';
import 'package:graviton/widgets/physics_controls.dart';
import 'package:graviton/widgets/common/graviton_tabbed_view.dart';
import 'package:graviton/widgets/common/graviton_tab.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// A persistent bottom sheet using SlidingUpPanel that contains all control panels
/// in a tabbed interface. Uses snap points for 3-position behavior and should be
/// more resilient to frequent Consumer rebuilds.
class SlidingPanelBottomSheet extends StatefulWidget {
  const SlidingPanelBottomSheet({super.key, this.onInteraction});

  /// Callback triggered when user interacts with the bottom sheet
  final VoidCallback? onInteraction;

  // Static ValueNotifier to track sheet position for floating controls
  // Using a singleton pattern with proper lifecycle management
  static ValueNotifier<double>? _sheetPosition;
  static int _instanceCount = 0;

  // Public getter for sheet position - creates if needed
  static ValueNotifier<double> get sheetPosition {
    _sheetPosition ??= ValueNotifier(0.15); // Start at minimum height
    return _sheetPosition!;
  }

  // Static reference to the current state instance for updating position
  static _SlidingPanelBottomSheetState? _currentInstance;

  /// Refresh the sheet position to trigger floating controls repositioning
  /// This should be called when screen dimensions change (e.g., fullscreen transitions)
  static void refreshPosition() {
    // Update the position based on actual panel state if available
    _currentInstance?._updateSheetPosition();

    // Also force notify listeners by setting the value to itself as fallback
    if (_sheetPosition != null) {
      final currentValue = _sheetPosition!.value;
      _sheetPosition!.value = currentValue;
    }
  }

  /// Check if the bottom sheet is currently in an expanded state (beyond minimum)
  static bool get isExpanded {
    if (_sheetPosition == null || _currentInstance == null) {
      return false;
    }
    // Consider the sheet "expanded" if it's above the minimum height
    return _sheetPosition!.value >
        _SlidingPanelBottomSheetState._minHeight + 0.05;
  }

  /// Close the bottom sheet to minimum position
  static bool closePanel() {
    if (_currentInstance?._panelController.isAttached == true) {
      _currentInstance!._panelController.close();
      return true;
    }
    return false;
  }

  /// Dispose the static ValueNotifier when no instances are using it
  static void _disposeSheetPosition() {
    if (_instanceCount <= 0) {
      _sheetPosition?.dispose();
      _sheetPosition = null;
    }
  }

  @override
  State<SlidingPanelBottomSheet> createState() =>
      _SlidingPanelBottomSheetState();
}

class _SlidingPanelBottomSheetState extends State<SlidingPanelBottomSheet> {
  late final PanelController _panelController;
  int _currentTabIndex = 0;

  // ScrollControllers for each tab to prevent memory leaks
  late final ScrollController _cameraScrollController;
  late final ScrollController _visualsScrollController;
  late final ScrollController _physicsScrollController;

  // Snap positions
  static const double _minHeight = 0.15; // Small peek at bottom
  static const double _mediumHeight = 0.35; // Partial content
  static const double _maxHeight = 0.80; // Full controls

  @override
  void initState() {
    super.initState();

    _panelController = PanelController();

    // Initialize ScrollControllers to prevent memory leaks
    _cameraScrollController = ScrollController();
    _visualsScrollController = ScrollController();
    _physicsScrollController = ScrollController();

    // Increment instance count for singleton management
    SlidingPanelBottomSheet._instanceCount++;

    // Register this instance for position updates
    SlidingPanelBottomSheet._currentInstance = this;

    // Initialize sheet position to match the actual panel start position (minimum)
    SlidingPanelBottomSheet.sheetPosition.value = _minHeight;
  }

  @override
  void dispose() {
    // Clear the static reference
    if (SlidingPanelBottomSheet._currentInstance == this) {
      SlidingPanelBottomSheet._currentInstance = null;
    }

    // Decrement instance count and dispose static ValueNotifier if no instances remain
    SlidingPanelBottomSheet._instanceCount--;
    SlidingPanelBottomSheet._disposeSheetPosition();

    // Dispose ScrollControllers to prevent memory leaks
    _cameraScrollController.dispose();
    _visualsScrollController.dispose();
    _physicsScrollController.dispose();

    super.dispose();
  }

  /// Update sheet position based on actual panel state
  /// This ensures the ValueNotifier matches the real panel position
  void _updateSheetPosition() {
    if (_panelController.isAttached &&
        SlidingPanelBottomSheet._sheetPosition != null) {
      // Get the current panel position (0.0 to 1.0)
      final panelPosition = _panelController.panelPosition;
      // Convert to our scale: min to max
      final currentSize =
          _minHeight + (panelPosition * (_maxHeight - _minHeight));
      SlidingPanelBottomSheet._sheetPosition!.value = currentSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final l10n = AppLocalizations.of(context)!;

        return SlidingUpPanel(
          controller: _panelController,
          minHeight: MediaQuery.of(context).size.height * _minHeight,
          maxHeight: MediaQuery.of(context).size.height * _maxHeight,
          snapPoint: _mediumHeight, // 35% - our medium position
          color: Colors.transparent,
          boxShadow: const [],

          // Enable dragging and snapping with improved behavior
          isDraggable: true,
          panelSnapping: true,

          // Disable parallax to prevent bounce issues
          parallaxEnabled: false,
          parallaxOffset: 0.0,

          // Callbacks for position tracking
          onPanelSlide: (position) {
            // position is 0.0 (closed) to 1.0 (open)
            // Convert to our scale: min to max
            final currentSize =
                _minHeight + (position * (_maxHeight - _minHeight));

            final previousSize = SlidingPanelBottomSheet.sheetPosition.value;
            SlidingPanelBottomSheet.sheetPosition.value = currentSize;

            // Trigger interaction callback if position actually changed
            if ((currentSize - previousSize).abs() > 0.001) {
              widget.onInteraction?.call();
            }
          },

          onPanelOpened: () {
            SlidingPanelBottomSheet.sheetPosition.value = _maxHeight;
            widget.onInteraction?.call();
          },

          onPanelClosed: () {
            SlidingPanelBottomSheet.sheetPosition.value = _minHeight;
            widget.onInteraction?.call();
          },

          // Panel content
          panel: _buildPanelContent(context, appState, l10n),

          // Body content - transparent to let parent handle it
          body: const SizedBox.expand(),
        );
      },
    );
  }

  /// Build the panel content with tabs
  Widget _buildPanelContent(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSideBorders =
        screenWidth > RenderingConstants.bottomSheetMaxWidth;

    // Wrap in Material to ensure proper hit testing and prevent tap pass-through
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: RenderingConstants.bottomSheetMaxWidth,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              // Drag handle
              _buildDragHandle(context),

              // Tabbed content using GravitonTabbedView
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.uiBlack.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    border: showSideBorders
                        ? Border(
                            left: BorderSide(
                              color: AppColors.primaryColor.withValues(
                                alpha: AppTypography.opacityHigh,
                              ),
                              width: 2,
                            ),
                            right: BorderSide(
                              color: AppColors.primaryColor.withValues(
                                alpha: AppTypography.opacityHigh,
                              ),
                              width: 2,
                            ),
                          )
                        : null,
                  ),
                  child: GravitonTabbedView(
                    initialIndex: _currentTabIndex,
                    onTabChanged: (index) {
                      HapticUtils.navigate();
                      setState(() {
                        _currentTabIndex = index;
                      });
                    },
                    onTabTap: () {
                      // When a tab is tapped and panel is at minimum position,
                      // expand it to medium position
                      if (_panelController.isAttached) {
                        final currentPosition = _panelController.panelPosition;

                        // If panel is in position 1 (closed/minimum), slide to position 2 (medium)
                        if (currentPosition <= 0.1) {
                          _panelController.animatePanelToPosition(
                            (_mediumHeight - _minHeight) /
                                (_maxHeight - _minHeight),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      }
                    },
                    tabs: [
                      GravitonTab(
                        icon: Icons.videocam,
                        label: l10n.cameraLabel,
                        isActive: _currentTabIndex == 0,
                      ),
                      GravitonTab(
                        icon: Icons.palette,
                        label: l10n.bottomNavVisualsLabel,
                        isActive: _currentTabIndex == 1,
                      ),
                      GravitonTab(
                        icon: Icons.tune,
                        label: l10n.physicsSection,
                        isActive: _currentTabIndex == 2,
                      ),
                    ],
                    children: [
                      // Camera Controls Tab
                      Container(
                        color: AppColors.transparentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CameraControls(
                          appState: appState,
                          scrollController: _cameraScrollController,
                        ),
                      ),

                      // Visuals Controls Tab
                      Container(
                        color: AppColors.transparentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: VisualsControls(
                          appState: appState,
                          scrollController: _visualsScrollController,
                        ),
                      ),

                      // Physics Controls Tab
                      Container(
                        color: AppColors.transparentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: PhysicsControls(
                          appState: appState,
                          scrollController: _physicsScrollController,
                        ),
                      ),
                    ],
                  ), // End GravitonTabbedView
                ), // End Container with borders
              ), // End Expanded
            ],
          ), // End Column
        ), // End Material
      ), // End Container
    ); // End Center
  }

  /// Build the drag handle
  Widget _buildDragHandle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSideBorders =
        screenWidth > RenderingConstants.bottomSheetMaxWidth;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTypography.radiusXLarge),
        ),
        border: showSideBorders
            ? Border(
                top: BorderSide(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  width: 2,
                ),
                left: BorderSide(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  width: 2,
                ),
                right: BorderSide(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  width: 2,
                ),
              )
            : Border(
                top: BorderSide(
                  color: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  width: 2,
                ),
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
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            widget.onInteraction?.call();

            // Check current panel position and only animate to medium if currently at minimum
            if (_panelController.isAttached) {
              final currentPosition = _panelController.panelPosition;

              // If panel is in position 1 (closed/minimum), slide to position 2 (medium)
              // Position 0.0 = minimum, so anything close to 0.0 is position 1
              if (currentPosition <= 0.1) {
                // Small threshold for "closed" state
                _panelController.animatePanelToPosition(
                  (_mediumHeight - _minHeight) / (_maxHeight - _minHeight),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              }
              // If already at medium or above, don't do anything (let normal drag behavior handle it)
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Center(
              child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
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
            ),
          ),
        ),
      ),
    );
  }
}
