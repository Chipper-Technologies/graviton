import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/haptic_utils.dart';
import 'package:graviton/widgets/camera_controls.dart';
import 'package:graviton/widgets/visuals_controls.dart';
import 'package:graviton/widgets/physics_controls.dart';
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
    _sheetPosition ??= ValueNotifier(0.25);
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

class _SlidingPanelBottomSheetState extends State<SlidingPanelBottomSheet>
    with TickerProviderStateMixin {
  late final PanelController _panelController;
  late final TabController _tabController;

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
    _tabController = TabController(length: 3, vsync: this);

    // Initialize ScrollControllers to prevent memory leaks
    _cameraScrollController = ScrollController();
    _visualsScrollController = ScrollController();
    _physicsScrollController = ScrollController();

    // Increment instance count for singleton management
    SlidingPanelBottomSheet._instanceCount++;

    // Register this instance for position updates
    SlidingPanelBottomSheet._currentInstance = this;

    // Initialize sheet position
    SlidingPanelBottomSheet.sheetPosition.value = _mediumHeight;

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

    _tabController.dispose();
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
          // Panel styling
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTypography.radiusXLarge),
          ),
          color: AppColors.uiBlack.withValues(alpha: AppTypography.opacityHigh),

          // Enable dragging and snapping
          isDraggable: true,
          panelSnapping: true,

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
    return Column(
      children: [
        // Header with drag handle and tabs
        _buildPanelHeader(context, appState, l10n),

        // Content area
        Expanded(child: _buildTabContent(context, appState, l10n)),
      ],
    );
  }

  /// Build the panel header with drag handle and tabs
  Widget _buildPanelHeader(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTypography.radiusXLarge),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityMedium,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          _buildDragHandle(context),

          // Tab bar
          _buildTabBar(context, appState, l10n),
        ],
      ),
    );
  }

  /// Build the drag handle
  Widget _buildDragHandle(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onInteraction?.call();
        // Animate to medium position on tap
        if (_panelController.isAttached) {
          _panelController.animatePanelToPosition(
            (_mediumHeight - _minHeight) / (_maxHeight - _minHeight),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
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
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
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
    );
  }

  /// Check if a tab is currently active based on state
  bool _isTabActive(int tabIndex, AppState appState) {
    // Simple implementation - could be expanded based on app state
    return _tabController.index == tabIndex;
  }

  /// Build the tab bar
  Widget _buildTabBar(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(alpha: AppTypography.opacityFaint),
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
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
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
        dividerColor: AppColors.transparentColor,
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
                const SizedBox(width: AppTypography.spacingSmall),
                Text(l10n.cameraLabel),
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
                const SizedBox(width: AppTypography.spacingSmall),
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
                      Icons.tune,
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
                const SizedBox(width: AppTypography.spacingSmall),
                Text(l10n.physicsSection),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the tab content
  Widget _buildTabContent(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityVeryHigh,
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          // Camera Controls Tab
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CameraControls(
              appState: appState,
              scrollController: _cameraScrollController,
            ),
          ),

          // Visuals Controls Tab
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: VisualsControls(
              appState: appState,
              scrollController: _visualsScrollController,
            ),
          ),

          // Physics Controls Tab
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PhysicsControls(
              appState: appState,
              scrollController: _physicsScrollController,
            ),
          ),
        ],
      ),
    );
  }
}
