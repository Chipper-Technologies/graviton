import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/painters/graviton_painter.dart';
import 'package:graviton/services/cinematic_camera_controller.dart';
import 'package:graviton/services/custom_scenario_manager.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/services/keyboard_navigation_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/services/changelog_service.dart';
import 'package:graviton/services/version_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:graviton/widgets/auto_pause_dialog_wrapper.dart';
import 'package:graviton/widgets/overlays/body_labels_overlay.dart';
import 'package:graviton/widgets/overlays/body_property_editor_overlay.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_details_bottom_sheet.dart';
import 'package:graviton/widgets/sliding_panel_bottom_sheet.dart';
import 'package:graviton/widgets/semantics/semantic_simulation_canvas.dart';
import 'package:graviton/widgets/semantics/semantic_live_region.dart';
import 'package:graviton/widgets/changelog_dialog.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_circular_button.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:graviton/screens/developer_tools_screen.dart';
import 'package:graviton/screens/help_screen.dart';
import 'package:graviton/screens/application_settings_screen.dart';
import 'package:graviton/widgets/options_drawer.dart';
import 'package:graviton/widgets/maintenance_dialog.dart';
import 'package:graviton/widgets/overlays/offscreen_indicators_overlay.dart';
import 'package:graviton/widgets/overlays/camera_visual_aids_overlay.dart';
import 'package:graviton/screens/scenario_selection_screen.dart';
import 'package:graviton/screens/simulation_info_screen.dart';
import 'package:graviton/screens/about_screen.dart';
import 'package:graviton/screens/physics_settings_screen.dart';
import 'package:graviton/widgets/screenshot_countdown.dart';
import 'package:graviton/widgets/overlays/stats_overlay.dart';
import 'package:graviton/widgets/version_check_dialog.dart';
import 'package:graviton/widgets/overlays/tutorial_overlay.dart';
import 'package:graviton/services/onboarding_service.dart';
import 'package:graviton/services/fullscreen_service.dart';
import 'package:graviton/utils/fullscreen_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

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
  Offset? _lastPan;
  late final List<StarData> _stars = StarGenerator.generateStars(
    1500,
  ); // More stars with enhanced data, using default radius

  Duration _lastElapsed = Duration.zero;
  bool _isDragging = false; // Track if we're currently dragging
  bool _hasMoved = false; // Track if any movement occurred during gesture
  double? _lastTwoFingerRotation; // Track rotation angle for two-finger roll
  bool _languageInitialized = false;
  bool _tutorialJustCompleted = false; // Flag to track tutorial completion
  late final ScreenshotModeService _screenshotModeService;
  final CinematicCameraController _cinematicCameraController =
      CinematicCameraController();
  CinematicCameraTechnique? _lastCameraTechnique;
  ScenarioType? _lastScenario;

  // Function to show simulation controls
  VoidCallback? _showSimulationControls;

  // Floating controls visibility state
  bool _showFloatingControls = false;
  Timer? _floatingControlsTimer;

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

    // Check for app updates and maintenance after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for version dialog to complete before proceeding
      final versionDialogWasShown = await VersionCheckDialog.showIfRequired(
        context,
      );

      // Show maintenance/notification dialogs after version check
      Future.delayed(const Duration(milliseconds: 500), () {
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
    if (elapsed - _lastElapsed < Duration(milliseconds: 16)) {
      return; // 60 FPS cap
    }

    final appState = Provider.of<AppState>(context, listen: false);
    // Calculate deltaTime, but clamp it to prevent huge jumps after reset
    double deltaTime = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    deltaTime = deltaTime.clamp(
      0.0,
      1.0 / 30.0,
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
      appState.simulation.simulation.pushTrails(1 / 240.0);
    }
  }

  void _handleTapWithDelay(
    BuildContext context,
    AppState appState,
    Size size,
    AppLocalizations l10n,
    Offset tapPosition,
  ) {
    // Use Timer instead of Future.delayed to avoid async context issues
    Timer(const Duration(milliseconds: 50), () {
      if (!_hasMoved && mounted) {
        FirebaseService.instance.logUIEventWithEnums(
          UIAction.tap,
          element: UIElement.simulationViewport,
        );

        // Check if screenshot mode is active and show navigation controls
        final screenshotService = ScreenshotModeService();
        if (screenshotService.isActive) {
          _showScreenshotNavigationControls(
            context,
            appState,
            screenshotService,
            l10n,
          );
        } else {
          // First check if we tapped on a body
          final tappedBodyIndex = _findBodyAtTapLocation(
            appState,
            size,
            tapPosition,
          );

          if (tappedBodyIndex != null) {
            // Tapped on a body - select it without toggling fullscreen
            _selectBody(appState, tappedBodyIndex, appState.simulation.bodies);
          } else {
            // Tapped on empty space - toggle fullscreen mode
            _handleFullscreenToggle(appState);

            // Deselect any currently selected body and show controls
            appState.camera.selectBody(null);
            _showSimulationControls?.call();
          }
        }
      }
    });
  }

  /// Find the body at the given tap location
  /// Returns the body index if a body is found, null otherwise
  int? _findBodyAtTapLocation(
    AppState appState,
    Size size,
    Offset? tapPosition,
  ) {
    final bodies = appState.simulation.bodies;
    if (bodies.isEmpty || tapPosition == null) return null;

    // Find the body closest to the tap position
    final view = _buildView();
    final proj = _buildProjection(size.aspectRatio);

    int? closestBodyIndex;
    double closestDistance = double.infinity;
    const double baseHitRadius = 40.0; // Base hit radius in pixels

    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i];

      // Project 3D world position to 2D screen coordinates
      final screenPos = _projectToScreen(body.position, view, proj, size);

      if (screenPos != null) {
        final distance = (tapPosition - screenPos).distance;

        // Use a generous hit radius that scales with camera distance
        final distanceScale = math.max(1.0, appState.camera.distance / 300.0);
        final hitRadius = baseHitRadius * distanceScale;

        // Check if tap is within body's hit radius and is the closest
        if (distance <= hitRadius && distance < closestDistance) {
          closestDistance = distance;
          closestBodyIndex = i;
        }
      }
    }

    return closestBodyIndex;
  }

  void _selectBody(AppState appState, int bodyIndex, List<Body> bodies) {
    appState.camera.selectBody(bodyIndex);

    // If follow mode is active, immediately start following the newly selected body
    if (appState.camera.followMode) {
      appState.camera.setFollowBody(bodyIndex, bodies);

      FirebaseService.instance.logUIEventWithEnums(
        UIAction.followToggle,
        element: UIElement.cameraControls,
        value: 'body_$bodyIndex',
      );
    } else {
      // Focus on the selected body for better viewing
      appState.camera.focusOnBody(bodyIndex, bodies);
    }

    FirebaseService.instance.logUIEventWithEnums(
      UIAction.bodySelected,
      element: UIElement.simulationViewport,
      value: 'body_$bodyIndex',
    );
  }

  /// Show floating controls and reset auto-hide timer
  void _showFloatingControlsTemporarily() {
    setState(() {
      _showFloatingControls = true;
    });

    // Cancel existing timer
    _floatingControlsTimer?.cancel();

    // Only set timer to hide controls when sheet is in closed position
    // If sheet is expanded (positions 2 or 3), keep controls visible
    final currentSheetPosition = SlidingPanelBottomSheet.sheetPosition.value;
    const minPosition = 0.15; // Closed position

    if (currentSheetPosition <= minPosition) {
      // Set timer to hide controls after 3 seconds of inactivity only when closed
      _floatingControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          // Double-check sheet position before hiding
          final sheetPosition = SlidingPanelBottomSheet.sheetPosition.value;
          if (sheetPosition <= minPosition) {
            setState(() {
              _showFloatingControls = false;
            });
          }
        }
      });
    }
  }

  /// Project a 3D world position to 2D screen coordinates
  Offset? _projectToScreen(
    vm.Vector3 worldPos,
    vm.Matrix4 view,
    vm.Matrix4 proj,
    Size screenSize,
  ) {
    // Transform world position to homogeneous coordinates
    final homogeneousPos = vm.Vector4(worldPos.x, worldPos.y, worldPos.z, 1.0);

    // Transform to camera space then to clip space
    final clipPos = proj * view * homogeneousPos;

    // Check if point is in front of camera (w should be positive)
    if (clipPos.w <= 0) return null;

    // Convert to normalized device coordinates (NDC)
    final ndc = vm.Vector3(
      clipPos.x / clipPos.w,
      clipPos.y / clipPos.w,
      clipPos.z / clipPos.w,
    );

    // Check if point is within the viewing frustum
    if (ndc.z > 1.0 || ndc.z < -1.0) return null;

    // Convert NDC to screen coordinates
    final screenX = (ndc.x + 1.0) * 0.5 * screenSize.width;
    final screenY = (1.0 - ndc.y) * 0.5 * screenSize.height; // Flip Y axis

    return Offset(screenX, screenY);
  }

  vm.Matrix4 _buildView() {
    final appState = Provider.of<AppState>(context, listen: false);
    final eye = appState.camera.eyePosition;
    final target = appState.camera.target;

    // Calculate the forward vector (from eye to target)
    final forward = (target - eye).normalized();

    // Calculate the right vector (cross product of forward and world up)
    final worldUp = vm.Vector3(0, 1, 0);
    final right = forward.cross(worldUp).normalized();

    // Calculate the up vector (cross product of right and forward)
    final up = right.cross(forward).normalized();

    // Apply roll rotation around the forward vector (Z-axis in camera space)
    final roll = appState.camera.roll;
    final cosRoll = math.cos(roll);
    final sinRoll = math.sin(roll);

    // Rotate the up vector by the roll angle
    final rolledUp = up * cosRoll - right * sinRoll;

    return vm.makeViewMatrix(eye, target, rolledUp);
  }

  vm.Matrix4 _buildProjection(double aspect) {
    final appState = context.read<AppState>();
    return vm.makePerspectiveMatrix(
      vm.radians(appState.camera.fieldOfView),
      aspect,
      0.1,
      4000.0,
    );
  }

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
    const minPosition = 0.15; // Closed position
    final currentPosition = SlidingPanelBottomSheet.sheetPosition.value;

    if (mounted) {
      if (currentPosition > minPosition) {
        // Sheet is expanded (positions 2 or 3) - cancel any existing timer
        _floatingControlsTimer?.cancel();
      } else if (currentPosition <= minPosition && _showFloatingControls) {
        // Sheet moved to closed position - restart timer if controls are currently showing
        _showFloatingControlsTemporarily();
      }
    }
  }

  /// Handle screenshot mode changes to control system UI visibility
  void _onScreenshotModeChanged() {
    // The FullscreenService now handles system UI changes for screenshot mode
    // when fullscreen is enabled. This method is kept for potential future
    // screenshot-specific UI handling that doesn't involve fullscreen.

    // Currently no additional UI changes needed here since fullscreen
    // is handled by the ScreenshotModeService via FullscreenService
  }

  /// Handle fullscreen mode toggle
  void _handleFullscreenToggle(AppState appState) async {
    try {
      // Hide floating controls temporarily during fullscreen transition
      setState(() {
        _showFloatingControls = false;
      });

      await FullscreenUtils.toggleFullscreen(appState);

      // Force a rebuild after fullscreen toggle and show controls again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Refresh the sheet position to trigger floating controls repositioning
          SlidingPanelBottomSheet.refreshPosition();

          // Small delay to ensure layout has settled before showing controls
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() {
                _showFloatingControls = true;
              });
            }
          });
        }
      });

      // Log the fullscreen toggle event
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.tap,
        element: UIElement.simulationViewport,
        value: appState.ui.isFullscreen
            ? 'enter_fullscreen'
            : 'exit_fullscreen',
      );
    } catch (e) {
      debugPrint('Error toggling fullscreen: $e');
      // Restore floating controls on error
      if (mounted) {
        setState(() {
          _showFloatingControls = true;
        });
      }
    }
  }

  void _showScenarioSelectionScreen(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.scenarioSelection,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScenarioSelectionScreen(
              currentScenario: appState.simulation.simulation.currentScenario,
              onScenarioSelected: (scenario) {
                final l10n = AppLocalizations.of(context)!;
                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.scenarioSelected,
                  element: UIElement.scenarioDialog,
                  value: scenario.name,
                );

                // Close the screen first to avoid navigator conflicts
                Navigator.of(context).pop();

                // Then perform the scenario switch with proper error handling
                try {
                  appState.simulation.resetWithScenario(scenario, l10n: l10n);
                  // Reset cinematic camera controller for new scenario
                  _cinematicCameraController.reset();

                  // Use a timer instead of post-frame callback for more reliable execution
                  Future.delayed(const Duration(milliseconds: 100), () {
                    try {
                      // Auto-zoom camera to fit the new scenario
                      if (appState.simulation.bodies.isNotEmpty) {
                        appState.camera.resetViewForScenario(
                          scenario,
                          appState.simulation.bodies,
                        );
                      }
                    } catch (e) {
                      // Silently handle any camera reset errors
                      debugPrint('Camera reset error: $e');
                    }
                  });
                } catch (e) {
                  // Handle any simulation reset errors
                  debugPrint('Scenario switch error: $e');
                  appState.setError(
                    l10n.failedToSwitchScenarioError(e.toString()),
                  );
                }
              },
              onCustomScenarioSelected: (scenarioName) {
                final l10n = AppLocalizations.of(context)!;
                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.scenarioSelected,
                  element: UIElement.scenarioDialog,
                  value: 'custom:$scenarioName',
                );

                // Close the screen first to avoid navigator conflicts
                Navigator.of(context).pop();

                // Load custom scenario
                _loadCustomScenario(context, scenarioName, l10n);
              },
            ),
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Future<void> _loadCustomScenario(
    BuildContext context,
    String scenarioName,
    AppLocalizations l10n,
  ) async {
    final appState = Provider.of<AppState>(context, listen: false);

    try {
      // Load the custom scenario using the custom scenario manager
      final customManager = CustomScenarioManager.instance;
      await customManager.loadCustomScenario(scenarioName);

      // Switch to custom scenario type to trigger the custom scenario loading
      appState.simulation.resetWithScenario(ScenarioType.custom, l10n: l10n);

      // Reset cinematic camera controller for new scenario
      _cinematicCameraController.reset();

      // Use a timer instead of post-frame callback for more reliable execution
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          // Auto-zoom camera to fit the new scenario
          if (appState.simulation.bodies.isNotEmpty) {
            appState.camera.resetViewForScenario(
              ScenarioType.custom,
              appState.simulation.bodies,
            );
          }
        } catch (e) {
          // Silently handle any camera reset errors
          debugPrint('Camera reset error: $e');
        }
      });

      // Show success message
      if (context.mounted) {
        GravitonSnackBar.success(
          context: context,
          message: l10n.accessibilityNewScenarioLoaded,
        );
      }
    } catch (e) {
      // Handle custom scenario loading errors
      debugPrint('Custom scenario loading error: $e');
      appState.setError(l10n.failedToSwitchScenarioError(e.toString()));
    }
  }

  void _showApplicationSettingsScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.settings,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ApplicationSettingsScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false, // This makes the route transparent
      ),
    );
  }

  void _showHelpScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.help,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HelpScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false, // This makes the route transparent
      ),
    );
  }

  void _showSimulationInfoScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.settings,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SimulationInfoScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false, // This makes the route transparent
      ),
    );
  }

  void _showAboutScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.about,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AboutScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false,
      ),
    );
  }

  void _showDeveloperToolsScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.developerTools,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DeveloperToolsScreen(),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false, // This makes the route transparent
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tutorialStarted,
      element: UIElement.tutorial,
    );

    AutoPauseDialogWrapper.show<void>(
      context: context,
      barrierDismissible: false,
      child: TutorialOverlay(
        onComplete: () async {
          await OnboardingService.markTutorialCompleted();
          if (context.mounted) {
            Navigator.of(context).pop();

            // Set flag to trigger changelog check in next build cycle
            setState(() {
              _tutorialJustCompleted = true;
            });
          }

          FirebaseService.instance.logUIEventWithEnums(
            UIAction.tutorialCompleted,
            element: UIElement.tutorial,
          );
        },
      ),
    );
  }

  void _showBodyPropertiesBottomSheet(BuildContext context, AppState appState) {
    final selectedIndex = appState.camera.selectedBody;
    if (selectedIndex == null ||
        selectedIndex < 0 ||
        selectedIndex >= appState.simulation.bodies.length) {
      return;
    }

    final selectedBody = appState.simulation.bodies[selectedIndex];

    FirebaseService.instance.logUIEventWithEnums(
      UIAction.dialogOpened,
      element: UIElement.bodyProperties,
    );

    // Pause simulation while editing
    final wasPlaying = !appState.simulation.isPaused;
    if (wasPlaying) {
      appState.simulation.pause();
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ScenarioEditorBodyDetailsBottomSheet(
            body: selectedBody,
            onBodyChanged: (updatedBody) {
              // Update the body in the simulation
              appState.simulation.bodies[selectedIndex] = updatedBody;
              appState.simulation.notifyBodyPropertiesChanged();
              // Update sheet state for immediate visual feedback
              setSheetState(() {});
            },
            availableCentralBodies:
                [], // Not needed for editing existing bodies
            isAddMode: false,
          ),
        ),
      ),
    ).then((_) {
      // Resume simulation if it was playing
      if (wasPlaying) {
        appState.simulation.resumeSimulation();
      }
    });
  }

  void _showPhysicsSettingsScreen(BuildContext context, AppState appState) {
    final sim = appState.simulation.simulation;

    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.physicsSettings,
    );

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: PhysicsSettingsScreen(
              gravitationalConstant: sim.gravitationalConstant,
              softening: sim.softening,
              timeScale: appState.simulation.timeScale,
              collisionRadiusMultiplier: sim.collisionRadiusMultiplier,
              maxTrailPoints: sim.maxTrail,
              trailFadeRate: sim.fadeRate,
              vibrationThrottleTime: sim.vibrationThrottleTime,
              vibrationEnabled: sim.vibrationEnabled,
              currentScenario: sim.currentScenario,
              onSettingsChanged: (settings) {
                // Apply physics settings to simulation
                sim.updatePhysicsSettings(
                  gravitationalConstant: settings['gravitationalConstant'],
                  softening: settings['softening'],
                  collisionRadiusMultiplier:
                      settings['collisionRadiusMultiplier'],
                  maxTrailPoints: settings['maxTrailPoints']?.round(),
                  trailFadeRate: settings['trailFadeRate'],
                  vibrationThrottleTime: settings['vibrationThrottleTime'],
                  vibrationEnabled: settings['vibrationEnabled'],
                );

                // Update time scale if provided
                if (settings['timeScale'] != null) {
                  appState.simulation.setTimeScale(settings['timeScale']);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _checkFirstTimeUser({bool versionDialogWasShown = false}) async {
    final hasSeenTutorial = await OnboardingService.hasSeenTutorial();
    if (!hasSeenTutorial && mounted) {
      // Show tutorial after a short delay to let the app initialize
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _showTutorial(context);
        }
      });
    } else {
      // For existing users, check for new changelogs only if no version dialog was shown
      // This prevents dialog conflicts - if user needs to update, focus on that first
      if (!versionDialogWasShown) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            _checkForNewChangelogs(context);
          }
        });
      }
      // If version dialog was shown, skip changelog entirely to avoid overwhelming the user
    }
  }

  Future<void> _checkForNewChangelogs(BuildContext context) async {
    try {
      if (!context.mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);

      // Ensure version service is initialized
      await VersionService.instance.initialize();

      // Get current app version
      final currentVersion = VersionService.instance.appVersion;
      if (currentVersion.isEmpty) {
        return;
      }

      // Check if user should see changelog for this version
      if (!appState.ui.shouldShowChangelogFor(currentVersion)) {
        return; // Already seen changelog for this version
      }

      // Initialize and fetch changelogs using the shared method with fallback logic
      await ChangelogService.instance.initialize();

      final changelogsToShow = await ChangelogService.instance
          .fetchChangelogsWithFallback(currentVersion: currentVersion);

      if (changelogsToShow.isNotEmpty && mounted) {
        // Show changelog dialog with available changelogs
        _showChangelogDialog(changelogsToShow);
      }
    } catch (e) {
      // Silently fail - app should continue normally
    }
  }

  void _showChangelogDialog(List<ChangelogVersion> changelogs) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.changelogShown,
      element: UIElement.changelog,
    );

    AutoPauseDialogWrapper.show<void>(
      context: context,
      barrierDismissible: false,
      child: ChangelogDialog(
        changelogs: changelogs,
        onComplete: () async {
          if (context.mounted) {
            Navigator.of(context).pop();

            // Mark the latest changelog version as seen
            final appState = Provider.of<AppState>(context, listen: false);
            final currentVersion = VersionService.instance.appVersion;
            appState.ui.setLastSeenChangelogVersion(currentVersion);
          }

          FirebaseService.instance.logUIEventWithEnums(
            UIAction.changelogCompleted,
            element: UIElement.changelog,
          );
        },
      ),
    );
  }

  Future<void> _showCurrentVersionChangelog() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Initialize changelog service
      await ChangelogService.instance.initialize();

      // Get changelogs for current version
      final changelogsToShow = await ChangelogService.instance
          .fetchChangelogsWithFallback(currentVersion: currentVersion);

      if (changelogsToShow.isNotEmpty && mounted) {
        // Show changelog dialog with available changelogs
        _showChangelogDialog(changelogsToShow);
      } else {
        // Show a simple message if no changelog available
        if (mounted) {
          showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.changelogHometitle),
              content: Text(
                AppLocalizations.of(
                  context,
                )!.noChangelogAvailableForVersionHome(currentVersion),
              ),
              actions: [
                HapticTextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.closeButton),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        GravitonSnackBar.error(
          context: context,
          message: AppLocalizations.of(
            context,
          )!.errorLoadingChangelogEHome(e.toString()),
        );
      }
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

    // If bottom sheet is already closed, show exit confirmation
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
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (mounted && context.mounted) {
                  _checkForNewChangelogs(context);
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
              onShowChangelog: _showCurrentVersionChangelog,
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
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedbackService.instance.lightImpact();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          );
                        },
                        child: Tooltip(
                          message: l10n.aboutButtonTooltip,
                          child: Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacityVeryFaint,
                                ),
                                width: 1.5,
                              ),
                              image: DecorationImage(
                                image: AssetImage(AppConfig.appLogoPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                final view = _buildView();

                return HapticGestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    // Show floating controls on tap
                    _showFloatingControlsTemporarily();
                    _handleTapWithDelay(
                      context,
                      appState,
                      size,
                      l10n,
                      details.localPosition,
                    );
                  },
                  onDoubleTap: () {
                    // Show floating controls on double-tap
                    _showFloatingControlsTemporarily();

                    // Double-tap to reset camera view
                    appState.camera.resetView(
                      appState.simulation.currentScenario,
                    );

                    FirebaseService.instance.logUIEventWithEnums(
                      UIAction.doubleTap,
                      element: UIElement.cameraControls,
                      value: 'reset_view',
                    );
                  },
                  onScaleStart: (d) {
                    _lastPan = d.focalPoint;
                    _isDragging = false; // Reset dragging state
                    _hasMoved = false; // Reset movement flag
                    _lastTwoFingerRotation = null; // Reset rotation tracking
                    // Don't clear selection on drag start - let user drag selected objects

                    // Show simulation controls when starting camera interaction
                    _showSimulationControls?.call();

                    // Show floating controls on interaction
                    _showFloatingControlsTemporarily();

                    if (d.pointerCount >= 2) {
                      FirebaseService.instance.logUIEventWithEnums(
                        UIAction.gestureStart,
                        element: UIElement.cameraControls,
                        value: 'multi_touch',
                      );
                    } else {
                      FirebaseService.instance.logUIEventWithEnums(
                        UIAction.gestureStart,
                        element: UIElement.cameraControls,
                        value: 'single_touch',
                      );
                    }
                  },
                  onScaleUpdate: (d) {
                    final pos = d.focalPoint;
                    final delta = pos - (_lastPan ?? pos);

                    // Mark as dragging if there's significant movement
                    if (delta.distance > 2.0) {
                      if (!_hasMoved) {
                        _hasMoved = true;
                      }
                      if (delta.distance > 5.0 && !_isDragging) {
                        _isDragging = true;
                      }
                    }

                    if (d.pointerCount >= 2) {
                      // Handle two-finger gestures: zoom and roll
                      final dz = (1 - d.scale) * 0.1;
                      appState.camera.zoomTowardBody(
                        dz,
                        appState.simulation.bodies,
                      );

                      // Handle roll rotation
                      if (_lastTwoFingerRotation != null) {
                        final deltaRotation =
                            d.rotation - _lastTwoFingerRotation!;
                        appState.camera.rotateRoll(deltaRotation);
                      }
                      _lastTwoFingerRotation = d.rotation;
                    } else {
                      // Always rotate camera when dragging
                      // Object movement is disabled for better UX
                      final deltaYaw = -delta.dx * 0.01;
                      final deltaPitch = -delta.dy * 0.01;
                      appState.camera.rotate(deltaYaw, deltaPitch);
                    }
                    _lastPan = pos;
                  },
                  onScaleEnd: (_) {
                    _lastPan = null;
                    _isDragging = false; // Reset drag state
                    _hasMoved = false; // Reset movement flag
                    _lastTwoFingerRotation = null; // Reset rotation tracking
                    // Don't clear selection if in follow mode
                    if (!appState.camera.followMode) {
                      appState.camera.selectBody(null);
                    }
                  },
                  child: KeyboardNavigationService.instance.createKeyboardListener(
                    child: SemanticSimulationCanvas(
                      bodies: appState.simulation.bodies,
                      status: appState.simulation.status,
                      timeScale: appState.simulation.timeScale,
                      stepCount: appState.simulation.stepCount,
                      cameraDistance: appState.camera.distance,
                      autoRotate: appState.camera.autoRotate,
                      followMode: appState.camera.followMode,
                      followingBodyName: appState.camera.selectedBody != null
                          ? (AppLocalizations.of(context)?.bodySelectedTemplate(
                                  '${appState.camera.selectedBody}',
                                  appState.camera.selectedBody.toString(),
                                ) ??
                                'Body ${appState.camera.selectedBody}')
                          : null,
                      onTap: () {
                        // Show floating controls on tap
                        _showFloatingControlsTemporarily();
                      },
                      onCenter: () => appState.camera.resetView(
                        appState.simulation.currentScenario,
                      ),
                      onToggleRotate: () => appState.camera.toggleAutoRotate(),
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: GravitonPainter(
                              sim: appState.simulation.simulation,
                              view: view,
                              proj: _buildProjection(size.aspectRatio),
                              stars: _stars,
                              showTrails: appState.ui.showTrails,
                              useWarmTrails: appState.ui.useWarmTrails,
                              useRealisticColors:
                                  appState.ui.useRealisticColors,
                              showOrbitalPaths: appState.ui.showOrbitalPaths,
                              dualOrbitalPaths: appState.ui.dualOrbitalPaths,
                              showHabitableZones:
                                  appState.ui.showHabitableZones,
                              showHabitabilityIndicators:
                                  appState.ui.showHabitabilityIndicators,
                              selectedBodyIndex: appState.camera.selectedBody,
                              followMode: appState.camera.followMode,
                              cameraDistance: appState.camera.distance,
                              globalGravityFields:
                                  appState.ui.globalGravityFields,
                              gravityFieldColorScheme:
                                  appState.ui.gravityFieldColorScheme,
                              showEquipotentialSurfaces:
                                  appState.ui.showEquipotentialSurfaces,
                              showGravityFieldIndicators:
                                  appState.ui.showGravityFieldIndicators,
                            ),
                            child: const SizedBox.expand(),
                          ),
                          if (appState.ui.showLabels)
                            BodyLabelsOverlay(
                              bodies: appState.simulation.bodies,
                              viewMatrix: view,
                              projMatrix: _buildProjection(size.aspectRatio),
                              screenSize: size,
                              l10n: AppLocalizations.of(context),
                            ),
                          if (appState.ui.showOffScreenIndicators)
                            OffScreenIndicatorsOverlay(
                              bodies: appState.simulation.bodies,
                              viewMatrix: view,
                              projMatrix: _buildProjection(size.aspectRatio),
                              screenSize: size,
                              selectedBodyIndex: appState.camera.selectedBody,
                              onIndicatorTapped: (bodyIndex) {
                                _selectBody(
                                  appState,
                                  bodyIndex,
                                  appState.simulation.bodies,
                                );
                              },
                            ),
                          // Body property editor overlay for selected bodies
                          if (!shouldHideUI &&
                              appState.camera.selectedBody != null)
                            BodyPropertyEditorOverlay(
                              bodies: appState.simulation.bodies,
                              viewMatrix: view,
                              projMatrix: _buildProjection(size.aspectRatio),
                              screenSize: size,
                              selectedBodyIndex: appState.camera.selectedBody,
                              onPropertyIconTapped: () =>
                                  _showBodyPropertiesBottomSheet(
                                    context,
                                    appState,
                                  ),
                            ),
                          // Camera visual aids overlay
                          if (!shouldHideUI)
                            CameraVisualAidsOverlay(
                              bodies: appState.simulation.bodies,
                              viewMatrix: view,
                              projMatrix: _buildProjection(size.aspectRatio),
                              screenSize: size,
                              selectedBodyIndex: appState.camera.selectedBody,
                              cameraDistance: appState.camera.distance,
                              showCrosshairs: appState.camera.showCrosshairs,
                            ),
                          if (appState.ui.showStats)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: SemanticLiveRegion(
                                currentValue:
                                    '${appState.simulation.stepCount}',
                                dataType: l10n.simulationStepsLabel,
                                child: StatsOverlay(appState: appState),
                              ),
                            ),
                          ScreenshotCountdown(
                            screenshotService: _screenshotModeService,
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
                                  valueListenable:
                                      SlidingPanelBottomSheet.sheetPosition,
                                  builder: (context, sheetPosition, child) {
                                    // Always show controls when sheet is expanded (positions 2 or 3)
                                    // Only use timer logic when sheet is closed (position 1)
                                    const minPosition = 0.15; // Closed position
                                    final shouldShowControls =
                                        sheetPosition > minPosition ||
                                        _showFloatingControls;

                                    if (!shouldShowControls) {
                                      return const SizedBox.shrink();
                                    }

                                    final screenHeight = MediaQuery.of(
                                      context,
                                    ).size.height;

                                    // sheetPosition represents the fraction of screen height the sheet occupies
                                    // So the floating controls should be positioned above the sheet
                                    // at screenHeight * sheetPosition + 20 from the bottom
                                    final bottomPosition =
                                        screenHeight * sheetPosition + 20;

                                    return Positioned(
                                      bottom: bottomPosition,
                                      left: 32,
                                      right: 32,
                                      child: Builder(
                                        builder: (context) {
                                          final l10n = AppLocalizations.of(
                                            context,
                                          )!;
                                          return _buildFloatingSimulationControls(
                                            context,
                                            appState,
                                            l10n,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
      autoHideTimer = Timer(const Duration(seconds: 4), () {
        try {
          overlayEntry.remove();
        } catch (e) {
          // Overlay already removed, ignore
        }
      });
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 140, // Well above the snackbar
        left: 16,
        right: 16,
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
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

    // Also show the deactivate snackbar below
    GravitonSnackBar.info(
      context: context,
      message: l10n.appliedPreset(
        screenshotService.getPresetDisplayName(
          screenshotService.currentPresetIndex,
          l10n,
        ),
      ),
      duration: const Duration(seconds: 3),
      actionLabel: l10n.deactivate,
      onActionPressed: () {
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
    );
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
          // Info Button (far left)
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
