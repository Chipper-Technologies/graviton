import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/core/constants/ui_constants.dart';
import 'package:graviton/core/enums/cinematic_camera_technique.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/core/enums/snack_bar_severity.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/features/auth/presentation/widgets/avatar_button.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/models/firebase/camera_snapshot.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/models/ui/dialog_action.dart';
import 'package:graviton/services/camera/camera_gesture_service.dart';
import 'package:graviton/services/camera/cinematic_camera_controller.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/platform/platform_channel_service.dart';
import 'package:graviton/services/simulation/body_interaction_service.dart';
import 'package:graviton/services/ui/fullscreen_service.dart';
import 'package:graviton/services/ui/keyboard_navigation_service.dart';
import 'package:graviton/services/ui/navigation_service.dart';
import 'package:graviton/services/ui/screenshot_mode_service.dart';
import 'package:graviton/shared/widgets/controls/screenshot_countdown.dart';
import 'package:graviton/shared/widgets/controls/share_action_button.dart';
import 'package:graviton/shared/widgets/dialogs/body_selection_dialog.dart';
import 'package:graviton/shared/widgets/dialogs/maintenance_dialog.dart';
import 'package:graviton/shared/widgets/dialogs/version_check_dialog.dart';
import 'package:graviton/shared/widgets/layouts/options_drawer.dart';
import 'package:graviton/shared/widgets/layouts/sliding_panel_bottom_sheet.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/camera_projection_utils.dart';
import 'package:graviton/utils/platform_utils.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:graviton/widgets/body_creation/body_creation_mode_toggle.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/interaction/interaction_lock_toggle.dart';
import 'package:graviton/widgets/overlays/body_property_editor_overlay.dart';
import 'package:graviton/widgets/overlays/camera_visual_aids_overlay.dart';
import 'package:graviton/widgets/overlays/stats_overlay.dart';
import 'package:graviton/widgets/semantics/semantic_live_region.dart';
import 'package:graviton/widgets/simulation/simulation_viewport_widget.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:graviton/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:provider/provider.dart';

/// Main screen for Graviton
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Ticker _ticker;

  late final List<StarData> _stars = StarGenerator.generateStars(
    1500,
  ); // More stars with enhanced data, using default radius

  Duration _lastElapsed = Duration.zero;
  DateTime _lastBroadcast = DateTime.now();

  /// Interval between live session broadcasts (5 times per second)
  static const Duration _broadcastInterval = Duration(milliseconds: 200);

  final bool _hasMoved = false; // Track if any movement occurred during gesture

  bool _languageInitialized = false;
  bool _tutorialJustCompleted = false; // Flag to track tutorial completion
  late final ScreenshotModeService _screenshotModeService;
  final CinematicCameraController _cinematicCameraController =
      CinematicCameraController();
  CinematicCameraTechnique? _lastCameraTechnique;
  ScenarioType? _lastScenario;

  // GlobalKey for capturing simulation viewport as image
  final GlobalKey _simulationViewportKey = GlobalKey();

  // Function to show simulation controls
  VoidCallback? _showSimulationControls;

  // Floating controls visibility state
  bool _showFloatingControls = false;
  Timer? _floatingControlsTimer;

  // Cursor state for body hover detection

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();

    // Initialize screenshot mode service and listen for changes
    _screenshotModeService = ScreenshotModeService();
    _screenshotModeService.addListener(_onScreenshotModeChanged);

    // Add app lifecycle observer to handle system UI restoration
    WidgetsBinding.instance.addObserver(this);

    // Listen to sheet position changes to manage floating controls visibility
    SlidingPanelBottomSheet.sheetPosition.addListener(_onSheetPositionChanged);

    // Register keyboard navigation callbacks
    _registerKeyboardCallbacks();

    // Setup platform channel for simulation control
    _setupSimulationChannel();

    // Check for app updates and maintenance after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for version dialog to complete before proceeding
      final versionDialogWasShown = await VersionCheckDialog.showIfRequired(
        context,
      );

      // Show maintenance/notification dialogs after version check
      Future.delayed(UIConstants.maintenanceDialogDelay, () {
        if (mounted) {
          MaintenanceDialog.showIfNeeded(context);
        }
      });

      // Check if first-time user needs tutorial, with awareness of version dialog
      _checkFirstTimeUser(versionDialogWasShown: versionDialogWasShown);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _floatingControlsTimer?.cancel();
    _screenshotModeService.removeListener(_onScreenshotModeChanged);
    SlidingPanelBottomSheet.sheetPosition.removeListener(
      _onSheetPositionChanged,
    );
    WidgetsBinding.instance.removeObserver(this);

    // Ensure fullscreen mode is exited when screen is disposed
    // Use FullscreenService directly to avoid Provider access on disposed context
    if (FullscreenService.instance.isFullscreen) {
      FullscreenService.instance.exitFullscreen();
    }

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Handle screen metrics changes (e.g., when exiting fullscreen)
    // This ensures floating controls are repositioned correctly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Refresh the sheet position to trigger floating controls repositioning
        SlidingPanelBottomSheet.refreshPosition();
        setState(() {
          // Trigger rebuild with updated MediaQuery values
        });
      }
    });
  }

  void _onTick(Duration elapsed) {
    if (elapsed - _lastElapsed <
        Duration(milliseconds: SimulationConstants.targetFpsMilliseconds)) {
      return; // 60 FPS cap
    }

    final appState = Provider.of<AppState>(context, listen: false);
    // Calculate deltaTime, but clamp it to prevent huge jumps after reset
    double deltaTime = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    deltaTime = deltaTime.clamp(
      0.0,
      SimulationConstants.maxDeltaTime,
    ); // Max 30 FPS worth of time per frame
    _lastElapsed = elapsed;

    // Update simulation
    appState.simulation.step(deltaTime);

    // Update camera follow target (must be after simulation step)
    appState.camera.updateFollowTarget(appState.simulation.bodies);

    // Update camera auto-rotation
    appState.camera.updateAutoRotation(deltaTime);

    // Check if camera technique changed and reset controller if needed
    if (_lastCameraTechnique != appState.ui.cinematicCameraTechnique) {
      _cinematicCameraController.reset();
      _lastCameraTechnique = appState.ui.cinematicCameraTechnique;
    }

    // Check if scenario changed and reset controller if needed
    if (_lastScenario != appState.simulation.currentScenario) {
      _cinematicCameraController.reset();
      _lastScenario = appState.simulation.currentScenario;
    }

    // Update cinematic camera controller based on selected technique
    _cinematicCameraController.updateCamera(
      appState.ui.cinematicCameraTechnique,
      appState.simulation,
      appState.camera,
      appState.ui,
      deltaTime,
    );

    // Push trails if enabled and simulation is running (not paused)
    if (appState.ui.showTrails &&
        appState.simulation.isRunning &&
        !appState.simulation.isPaused) {
      appState.simulation.simulation.pushTrails(
        SimulationConstants.trailUpdateFrequency,
      );
    }

    // Broadcast simulation state if hosting a live session
    _broadcastIfHosting(appState);

    // Apply camera sync from host if viewing a live session
    _applyCameraSyncIfViewing(appState);
  }

  /// Broadcasts simulation state to viewers if hosting a live session.
  ///
  /// Only broadcasts at [_broadcastInterval] intervals to avoid flooding.
  /// Includes camera state if [LiveSessionState.syncCameraWithViewers] is enabled.
  void _broadcastIfHosting(AppState appState) {
    final liveSession = appState.liveSession;
    if (!liveSession.isHosting) return;

    final now = DateTime.now();
    if (now.difference(_lastBroadcast) < _broadcastInterval) return;

    _lastBroadcast = now;

    // Build camera snapshot if camera sync is enabled
    CameraSnapshot? cameraSnapshot;
    if (liveSession.syncCameraWithViewers) {
      final camera = appState.camera;
      cameraSnapshot = CameraSnapshot(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: camera.distance,
        target: camera.target,
        followMode: camera.followMode,
        followedBodyIndex: camera.followedBodyIndex,
        selectedBody: camera.selectedBody,
        autoRotate: camera.autoRotate,
        fieldOfView: camera.fieldOfView,
      );
    }

    final snapshot = SimulationSnapshot.fromSimulation(
      bodies: appState.simulation.bodies,
      isRunning: appState.simulation.isRunning && !appState.simulation.isPaused,
      timeScale: appState.simulation.timeScale,
      totalTime: appState.simulation.totalTime,
      stepCount: appState.simulation.stepCount,
      camera: cameraSnapshot,
    );
    liveSession.broadcastState(snapshot);
  }

  /// Applies camera state from the host when viewing a live session.
  ///
  /// Only applies camera sync if the host has camera sync enabled and
  /// the received snapshot includes camera data.
  void _applyCameraSyncIfViewing(AppState appState) {
    final liveSession = appState.liveSession;
    if (!liveSession.isViewing) return;

    final snapshot = liveSession.latestSnapshot;
    if (snapshot == null || !snapshot.hasCameraSync) return;

    // Apply camera state from the host
    appState.camera.applySnapshot(snapshot.camera!);
  }

  void _handleTapWithDelay(
    BuildContext context,
    AppState appState,
    Size size,
    AppLocalizations l10n,
    Offset tapPosition,
  ) {
    BodyInteractionService.handleTapWithDelay(
      context: context,
      appState: appState,
      size: size,
      l10n: l10n,
      tapPosition: tapPosition,
      hasMoved: _hasMoved,
      mounted: mounted,
      showSimulationControls: _showSimulationControls,
      showScreenshotNavigationControls: _showScreenshotNavigationControls,
    );
  }

  /// Find the body at the given tap location
  /// Returns the body index if a body is found, null otherwise
  int? _findBodyAtTapLocation(
    AppState appState,
    Size size,
    Offset? tapPosition,
  ) {
    return BodyInteractionService.findBodyAtTapLocation(
      appState: appState,
      size: size,
      tapPosition: tapPosition,
    );
  }

  /// Find the body at the given hover location (more precise than tap)
  /// Returns the body index if a body is found, null otherwise
  int? _findBodyAtHoverLocation(
    AppState appState,
    Size size,
    Offset? hoverPosition,
  ) {
    return BodyInteractionService.findBodyAtHoverLocation(
      appState: appState,
      size: size,
      hoverPosition: hoverPosition,
    );
  }

  void _selectBody(AppState appState, int bodyIndex, List<Body> bodies) {
    BodyInteractionService.selectBody(
      appState: appState,
      bodyIndex: bodyIndex,
      bodies: bodies,
    );
  }

  /// Show floating controls and reset auto-hide timer
  void _showFloatingControlsTemporarily() {
    setState(() {
      _showFloatingControls = true;
    });
    _floatingControlsTimer =
        CameraGestureService.showFloatingControlsTemporarily(
          mounted: mounted,
          currentTimer: _floatingControlsTimer,
          onUpdate: () => setState(() {
            _showFloatingControls = !_showFloatingControls;
          }),
        );
  }

  /// Project a 3D world position to 2D screen coordinates

  /// Register keyboard navigation callbacks for accessibility
  void _registerKeyboardCallbacks() {
    KeyboardNavigationService.instance.registerCallbacks(
      onPlayPause: () {
        final appState = context.read<AppState>();
        if (appState.simulation.isPaused) {
          appState.simulation.resumeSimulation();
        } else {
          appState.simulation.pause();
        }
      },
      onReset: () {
        final appState = context.read<AppState>();
        appState.resetAll();
      },
      onCenterCamera: () {
        final appState = context.read<AppState>();
        appState.camera.resetView(appState.simulation.currentScenario);
      },
      onToggleAutoRotate: () {
        final appState = context.read<AppState>();
        appState.camera.toggleAutoRotate();
      },
      onToggleTrails: () {
        final appState = context.read<AppState>();
        appState.ui.toggleTrails();
      },
      onToggleStats: () {
        final appState = context.read<AppState>();
        appState.ui.toggleStats();
      },
      onToggleLabels: () {
        final appState = context.read<AppState>();
        appState.ui.toggleLabels();
      },
      onOpenSettings: () {
        // Open the end drawer if not already open
        final scaffoldState = _scaffoldKey.currentState;
        if (scaffoldState != null) {
          if (scaffoldState.isEndDrawerOpen) {
            Navigator.of(context).pop();
          } else {
            scaffoldState.openEndDrawer();
          }
        }
      },
    );
  }

  /// Handle sheet position changes to manage floating controls visibility
  void _onSheetPositionChanged() {
    _floatingControlsTimer = CameraGestureService.handleSheetPositionChanged(
      mounted: mounted,
      currentTimer: _floatingControlsTimer,
      showFloatingControls: _showFloatingControls,
      onRestartTimer: _showFloatingControlsTemporarily,
    );
  }

  /// Handle screenshot mode changes to control system UI visibility
  void _onScreenshotModeChanged() {
    // The FullscreenService now handles system UI changes for screenshot mode
    // when fullscreen is enabled. This method is kept for potential future
    // screenshot-specific UI handling that doesn't involve fullscreen.

    // Currently no additional UI changes needed here since fullscreen
    // is handled by the ScreenshotModeService via FullscreenService
  }

  /// Handle fullscreen mode toggle (triggered by double-tap on simulation viewport)
  void _handleFullscreenToggle(AppState appState) async {
    await CameraGestureService.handleFullscreenToggle(
      context: context,
      appState: appState,
      mounted: mounted,
      onUpdate: () => setState(() {
        _showFloatingControls = !_showFloatingControls;
      }),
    );
  }

  /// Handle three-finger pan gesture to move camera target in view-relative directions
  void _handleThreeFingerPan(Offset screenDelta, AppState appState) {
    CameraGestureService.handleThreeFingerPan(
      screenDelta: screenDelta,
      appState: appState,
    );
  }

  /// Handle body movement by converting screen position to world coordinates
  void _handleBodyMovement(
    AppState appState,
    Size screenSize,
    Offset screenPosition,
  ) {
    BodyInteractionService.handleBodyMovement(
      appState: appState,
      screenSize: screenSize,
      screenPosition: screenPosition,
      onUpdate: () => setState(() {}),
    );
  }

  void _showScenarioSelectionScreen(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    NavigationService.showScenarioSelectionScreen(
      context,
      appState,
      _cinematicCameraController.reset,
    );
  }

  void _showApplicationSettingsScreen(BuildContext context) {
    NavigationService.showApplicationSettingsScreen(context);
  }

  void _showHelpScreen(BuildContext context) {
    NavigationService.showHelpScreen(context);
  }

  void _showSimulationInfoScreen(BuildContext context) {
    NavigationService.showSimulationInfoScreen(context);
  }

  void _showAboutScreen(BuildContext context) {
    NavigationService.showAboutScreen(context);
  }

  void _showAccountManagementScreen(BuildContext context) {
    NavigationService.showAccountManagementScreen(context);
  }

  void _showDeveloperToolsScreen(BuildContext context) {
    NavigationService.showDeveloperToolsScreen(context);
  }

  /// Setup platform channel for macOS simulation commands
  void _setupSimulationChannel() {
    final appState = Provider.of<AppState>(context, listen: false);
    PlatformChannelService.setupSimulationChannel(
      context: context,
      appState: appState,
      mounted: mounted,
      onShowTutorial: () => _showTutorial(context),
      onSelectBody: () => _showBodySelectionDialog(context, appState),
    );
  }

  void _showTutorial(BuildContext context) {
    NavigationService.showTutorial(context, () {
      // Set flag to trigger changelog check in next build cycle
      setState(() {
        _tutorialJustCompleted = true;
      });
    });
  }

  void _showBodySelectionDialog(BuildContext context, AppState appState) {
    BodySelectionDialog.show(
      context: context,
      bodies: appState.simulation.bodies,
      selectedIndex: appState.camera.selectedBody,
    ).then((selectedIndex) {
      if (selectedIndex != null && context.mounted) {
        _selectBody(appState, selectedIndex, appState.simulation.bodies);
        // Show body properties after selection
        _showBodyPropertiesBottomSheet(context, appState);
      }
    });
  }

  void _showBodyPropertiesBottomSheet(BuildContext context, AppState appState) {
    BodyInteractionService.showBodyPropertiesBottomSheet(
      context: context,
      appState: appState,
      mounted: mounted,
    );
  }

  void _showPhysicsSettingsScreen(BuildContext context, AppState appState) {
    NavigationService.showPhysicsSettingsScreen(context, appState);
  }

  void _checkFirstTimeUser({bool versionDialogWasShown = false}) async {
    if (mounted) {
      await NavigationService.checkFirstTimeUser(context, () {
        // Set flag to trigger changelog check in next build cycle
        setState(() {
          _tutorialJustCompleted = true;
        });
      }, versionDialogWasShown: versionDialogWasShown);
    }
  }

  /// Handle the back button behavior
  /// Returns true to allow pop, false to prevent it
  bool _handleBackButton() {
    // If the bottom sheet is expanded, close it instead of exiting
    if (SlidingPanelBottomSheet.isExpanded) {
      SlidingPanelBottomSheet.closePanel();
      return false; // Prevent app exit
    }

    // On web and desktop, allow immediate exit without confirmation
    if (PlatformUtils.isWeb || PlatformUtils.isDesktop) {
      exit(0);
    }

    // On mobile, show exit confirmation dialog
    _showExitConfirmationDialog();
    return false; // Prevent immediate exit
  }

  /// Show confirmation dialog before exiting the app
  void _showExitConfirmationDialog() {
    final l10n = AppLocalizations.of(context)!;

    BaseConfirmationDialog.show<bool>(
      context: context,
      title: l10n.exitAppTitle,
      message: l10n.exitAppMessage,
      actions: [
        DialogAction(
          text: l10n.cancel,
          onPressed: () => Navigator.of(context).pop(false),
          textColor: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityHigh,
          ),
        ),
        DialogAction(
          text: l10n.exit,
          onPressed: () => Navigator.of(context).pop(true),
          textColor: AppColors.primaryColor,
        ),
      ],
    ).then((shouldExit) {
      if (shouldExit == true) {
        // Exit the app using dart:io exit
        exit(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false, // Always handle manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackButton();
        }
      },
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          // Handle language initialization and changes after build completes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_languageInitialized) {
              _languageInitialized = true;
              appState.initializeLanguageTracking(l10n);
            } else if (appState.checkForPendingLanguageChange()) {
              // Skip language change handling for galaxy formation to preserve custom body properties
              if (appState.simulation.currentScenario !=
                  ScenarioType.galaxyFormation) {
                appState.handleLanguageChangeWithContext(l10n);
              }
            }

            // Check for changelog after tutorial completion
            if (_tutorialJustCompleted) {
              _tutorialJustCompleted = false; // Reset flag
              // Add a small delay to ensure the UI is stable
              Future.delayed(UIConstants.initializationDelay, () {
                if (mounted && context.mounted) {
                  NavigationService.checkForNewChangelogs(context);
                }
              });
            }
          });

          final shouldHideUI =
              (_screenshotModeService.isActive &&
                  appState.ui.hideUIInScreenshotMode) ||
              appState.ui.isFullscreen;

          return Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            endDrawer: OptionsDrawer(
              onShowHelp: () => _showHelpScreen(context),
              onShowSettings: () => _showApplicationSettingsScreen(context),
              onShowScenarios: () => _showScenarioSelectionScreen(context),
              onShowPhysicsSettings: () =>
                  _showPhysicsSettingsScreen(context, appState),
              onShowAbout: () => _showAboutScreen(context),
              onShowDeveloperTools: () => _showDeveloperToolsScreen(context),
              onShowChangelog: () =>
                  NavigationService.showCurrentVersionChangelog(context),
              onShowAccount: () => _showAccountManagementScreen(context),
              onShowLiveSession: () =>
                  LiveSessionScreen.show(context, appState: appState),
            ),
            appBar: shouldHideUI
                ? null
                : HapticAppBar(
                    title: l10n.appTitle,
                    backgroundColor: AppColors.transparentColor,
                    titleSpacing: AppTypography
                        .spacingXLarge, // More space between logo and title
                    leading: Padding(
                      padding: const EdgeInsets.only(
                        left: AppTypography
                            .spacingLarge, // More space on the left
                      ),
                      child: HapticGestureDetector(
                        onTap: () {
                          NavigationService.showAboutScreen(context);
                        },
                        child: Tooltip(
                          message: l10n.aboutButtonTooltip,
                          child: Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.symmetric(
                              vertical: AppTypography.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacityVeryFaint,
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: kIsWeb
                                  ? Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.spaceGradientDark,
                                            AppColors.spaceGradientDarker,
                                          ],
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        AppConfig.gravitonLogoPath,
                                        width: 28,
                                        height: 28,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : Image.asset(
                                      AppConfig.appLogoPath,
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      // Live session connection status indicator - tappable to show session screen
                      Tooltip(
                        message: l10n.liveSessionIndicatorTooltip,
                        child: HapticInkWell(
                          onTap: () => LiveSessionScreen.show(
                            context,
                            appState: appState,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppTypography.radiusSmall,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(AppTypography.spacingSmall),
                            child: ConnectionStatusIndicator(
                              showLabel: false,
                              compact: true,
                            ),
                          ),
                        ),
                      ),
                      // Avatar button
                      AvatarButton(
                        onTap: () {
                          NavigationService.showAccountManagementScreen(
                            context,
                          );
                        },
                      ),
                      SizedBox(width: AppTypography.spacingSmall),
                      // Options drawer toggle
                      Builder(
                        builder: (context) => HapticIconButton(
                          icon: const Icon(Icons.menu),
                          tooltip: l10n.moreOptionsTooltip,
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ],
                  ),
            body: Stack(
              children: [
                SimulationViewportWidget(
                  appState: appState,
                  stars: _stars,
                  simulationViewportKey: _simulationViewportKey,
                  shouldHideUI: shouldHideUI,
                  screenshotModeService: _screenshotModeService,
                  showFloatingControlsTemporarily:
                      _showFloatingControlsTemporarily,
                  onTap: _handleTapWithDelay,
                  onFullscreenToggle: _handleFullscreenToggle,
                  onThreeFingerPan: _handleThreeFingerPan,
                  onBodyMovement: _handleBodyMovement,
                  onBodySelected: _selectBody,
                  onBodyPropertiesRequested: _showBodyPropertiesBottomSheet,
                  findBodyAtTapLocation: _findBodyAtTapLocation,
                  findBodyAtHoverLocation: _findBodyAtHoverLocation,
                  onShowSimulationControls: _showSimulationControls,
                ),
                // Body property editor overlay for selected bodies (outside viewport)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    final view = CameraProjectionUtils.buildViewMatrix(
                      appState.camera,
                    );
                    return Stack(
                      children: [
                        if (!shouldHideUI &&
                            appState.camera.selectedBody != null)
                          BodyPropertyEditorOverlay(
                            bodies: appState.simulation.bodies,
                            viewMatrix: view,
                            projMatrix:
                                CameraProjectionUtils.buildProjectionMatrix(
                                  appState.camera,
                                  size.aspectRatio,
                                ),
                            screenSize: size,
                            selectedBodyIndex: appState.camera.selectedBody,
                            onPropertyIconTapped: () =>
                                _showBodyPropertiesBottomSheet(
                                  context,
                                  appState,
                                ),
                          ),
                        if (!shouldHideUI)
                          CameraVisualAidsOverlay(
                            bodies: appState.simulation.bodies,
                            viewMatrix: view,
                            projMatrix:
                                CameraProjectionUtils.buildProjectionMatrix(
                                  appState.camera,
                                  size.aspectRatio,
                                ),
                            screenSize: size,
                            selectedBodyIndex: appState.camera.selectedBody,
                            cameraDistance: appState.camera.distance,
                            showCrosshairs: appState.camera.showCrosshairs,
                          ),
                        if (appState.ui.showStats)
                          Positioned(
                            top:
                                MediaQuery.of(context).padding.top +
                                kToolbarHeight +
                                AppTypography.spacingLarge,
                            left: AppTypography.spacingLarge,
                            child: SemanticLiveRegion(
                              currentValue: '${appState.simulation.stepCount}',
                              dataType: l10n.simulationStepsLabel,
                              child: StatsOverlay(appState: appState),
                            ),
                          ),
                        ScreenshotCountdown(
                          screenshotService: _screenshotModeService,
                        ),
                      ],
                    );
                  },
                ),
                // Persistent bottom sheet positioned at bottom of screen
                if (!shouldHideUI)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: MediaQuery.of(context).size.height,
                    child: SlidingPanelBottomSheet(
                      onInteraction: _showFloatingControlsTemporarily,
                    ),
                  ),
                // Floating simulation controls positioned above the bottom sheet
                if (!shouldHideUI)
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      return ValueListenableBuilder<double>(
                        valueListenable: SlidingPanelBottomSheet.sheetPosition,
                        builder: (context, sheetPosition, child) {
                          const minPosition =
                              UIConstants.sheetClosedPositionThreshold;
                          final shouldShowControls =
                              sheetPosition > minPosition ||
                              _showFloatingControls;

                          if (!shouldShowControls) {
                            return const SizedBox.shrink();
                          }

                          final screenHeight = MediaQuery.of(
                            context,
                          ).size.height;
                          final bottomPosition =
                              screenHeight * sheetPosition +
                              UIConstants.floatingControlsBottomOffset;

                          return Positioned(
                            bottom: bottomPosition,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      RenderingConstants.bottomSheetMaxWidth,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTypography.spacingXXXLarge,
                                ),
                                child: Builder(
                                  builder: (context) {
                                    final l10n = AppLocalizations.of(context)!;
                                    return _buildFloatingSimulationControls(
                                      context,
                                      appState,
                                      l10n,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ), // Close Stack
          );
        },
      ), // Close Consumer
    ); // Close PopScope
  }

  void _showScreenshotNavigationControls(
    BuildContext context,
    AppState appState,
    ScreenshotModeService screenshotService,
    AppLocalizations l10n,
  ) {
    // Show navigation buttons overlay
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    // Create a timer that can be reset when buttons are pressed
    Timer? autoHideTimer;

    void resetAutoHideTimer() {
      autoHideTimer?.cancel();
      autoHideTimer = Timer(UIConstants.screenshotNavigationTimeout, () {
        try {
          overlayEntry.remove();
        } catch (e) {
          // Overlay already removed, ignore
        }
      });
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: UIConstants
            .screenshotControlsBottomOffset, // Well above the snackbar
        left: AppTypography.spacingLarge,
        right: AppTypography.spacingLarge,
        child: Material(
          color: AppColors.transparentColor,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityFaint,
                  ),
                  blurRadius: AppTypography.radiusMedium,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTypography.spacingLarge,
              vertical: AppTypography.spacingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous button
                HapticIconButton(
                  onPressed: () async {
                    screenshotService.previousPreset();
                    await screenshotService.applyCurrentPreset(
                      l10n: l10n,
                      simulationState: appState.simulation,
                      cameraState: appState.camera,
                      uiState: appState.ui,
                    );

                    resetAutoHideTimer(); // Reset timer to keep controls visible
                  },
                  icon: const Icon(Icons.skip_previous),
                  tooltip: AppLocalizations.of(context)!.previousSceneTooltip,
                ),

                // Current preset info
                Expanded(
                  child: Text(
                    screenshotService.getPresetDisplayName(
                      screenshotService.currentPresetIndex,
                      l10n,
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),

                // Next button
                HapticIconButton(
                  onPressed: () async {
                    screenshotService.nextPreset();
                    await screenshotService.applyCurrentPreset(
                      l10n: l10n,
                      simulationState: appState.simulation,
                      cameraState: appState.camera,
                      uiState: appState.ui,
                    );

                    resetAutoHideTimer(); // Reset timer to keep controls visible
                  },
                  icon: const Icon(Icons.skip_next),
                  tooltip: AppLocalizations.of(context)!.nextSceneTooltip,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Start the initial timer
    resetAutoHideTimer();

    // Capture the scaffold messenger
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbars first
    scaffoldMessenger.clearSnackBars();

    // Show the preset name snackbar with action button
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          l10n.appliedPreset(
            screenshotService.getPresetDisplayName(
              screenshotService.currentPresetIndex,
              l10n,
            ),
          ),
        ),
        duration: UIConstants.screenshotNavigationTimeout,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          left: AppTypography.spacingLarge,
          right: AppTypography.spacingLarge,
          bottom: AppTypography.spacingLarge,
        ),
        action: SnackBarAction(
          label: l10n.deactivate,
          onPressed: () {
            // Remove overlay if still present
            try {
              overlayEntry.remove();
            } catch (e) {
              // Overlay already removed, ignore
            }

            // Deactivate screenshot mode and ensure simulation is unpaused
            screenshotService.deactivate(
              uiState: appState.ui,
              simulationState: appState.simulation,
            );
          },
        ),
      ),
    );

    // Manually dismiss snackbar after duration (action buttons prevent auto-dismiss)
    Future.delayed(UIConstants.screenshotNavigationTimeout, () {
      scaffoldMessenger.hideCurrentSnackBar();
    });
  }

  /// Build floating simulation controls that appear above the bottom sheet
  Widget _buildFloatingSimulationControls(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Material(
      color: AppColors.transparentColor,
      elevation: 0, // Remove shadow background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Info Button
              HapticCircularButton(
                icon: Icons.info_outline,
                onTap: () {
                  // Reset floating controls timer when button is pressed
                  _showFloatingControlsTemporarily();

                  FirebaseService.instance.logUIEventWithEnums(
                    UIAction.buttonPressed,
                    element: UIElement.simulationControl,
                    value: 'info',
                  );

                  // Show simulation info screen
                  _showSimulationInfoScreen(context);
                },
                size: 36,
                iconColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityNearlyOpaque,
                ),
                backgroundColor: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                borderColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
                tooltip: l10n.aboutButtonTooltip,
                semanticsLabel: l10n.aboutButtonTooltip,
              ),

              const SizedBox(width: AppTypography.spacingSmall),

              // Add Body Mode Toggle
              BodyCreationModeToggle(
                isActive: appState.ui.isAddBodyModeActive,
                onToggle: () {
                  // Reset floating controls timer when button is pressed
                  _showFloatingControlsTemporarily();

                  appState.ui.toggleAddBodyMode();

                  // Show instructional snackbar when activated
                  if (appState.ui.isAddBodyModeActive && mounted) {
                    GravitonSnackBar.show(
                      context: context,
                      message: l10n.tapToPlaceBody,
                      severity: SnackBarSeverity.info,
                    );
                  }
                },
              ),

              const SizedBox(width: AppTypography.spacingSmall),

              // Interaction Lock Toggle
              InteractionLockToggle(
                isLocked: appState.ui.isInteractionLocked,
                onToggle: () {
                  // Reset floating controls timer when button is pressed
                  _showFloatingControlsTemporarily();

                  appState.ui.toggleInteractionLock();

                  // Show feedback snackbar
                  if (mounted) {
                    GravitonSnackBar.show(
                      context: context,
                      message: appState.ui.isInteractionLocked
                          ? l10n.interactionLocked
                          : l10n.interactionUnlocked,
                      severity: SnackBarSeverity.info,
                    );
                  }
                },
              ),

              const SizedBox(width: AppTypography.spacingSmall),

              // Share Button
              HapticCircularButton(
                icon: Icons.share,
                onTap: () async {
                  // Reset floating controls timer when button is pressed
                  _showFloatingControlsTemporarily();

                  FirebaseService.instance.logUIEventWithEnums(
                    UIAction.buttonPressed,
                    element: UIElement.simulationControl,
                    value: 'share',
                  );

                  // Show share dialog
                  final shareButton = ShareActionButton(
                    simulationState: appState.simulation,
                    repaintBoundaryKey: _simulationViewportKey,
                  );
                  await shareButton.showShareOptions(context);
                },
                size: 36,
                iconColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityNearlyOpaque,
                ),
                backgroundColor: AppColors.uiBlack.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                borderColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
                tooltip: l10n.share,
                semanticsLabel: l10n.share,
              ),
            ],
          ),

          // Play/Pause and Reset buttons (far right)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Play/Pause Button
              appState.simulation.isPaused
                  ? HapticCircularButton.play(
                      onTap: () {
                        // Reset floating controls timer when button is pressed
                        _showFloatingControlsTemporarily();

                        FirebaseService.instance.logUIEventWithEnums(
                          UIAction.buttonPressed,
                          element: UIElement.simulationControl,
                          value: 'play',
                        );
                        appState.simulation.pause();
                      },
                      tooltip: l10n.playButton,
                      semanticsLabel: l10n.playButton,
                    )
                  : HapticCircularButton.pause(
                      onTap: () {
                        // Reset floating controls timer when button is pressed
                        _showFloatingControlsTemporarily();

                        FirebaseService.instance.logUIEventWithEnums(
                          UIAction.buttonPressed,
                          element: UIElement.simulationControl,
                          value: 'pause',
                        );
                        appState.simulation.pause();
                      },
                      tooltip: l10n.pauseButton,
                      semanticsLabel: l10n.pauseButton,
                    ),

              const SizedBox(width: AppTypography.spacingSmall),

              // Reset Button
              HapticCircularButton.reset(
                onTap: () {
                  // Reset floating controls timer when button is pressed
                  _showFloatingControlsTemporarily();

                  FirebaseService.instance.logUIEventWithEnums(
                    UIAction.buttonPressed,
                    element: UIElement.simulationControl,
                    value: 'reset',
                  );

                  // Check if screenshot mode is active and deactivate it first
                  final screenshotService = ScreenshotModeService();
                  if (screenshotService.isActive) {
                    screenshotService.deactivate(uiState: appState.ui);
                  }

                  appState.resetAll();
                },
                tooltip: l10n.resetButton,
                semanticsLabel: l10n.resetButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
