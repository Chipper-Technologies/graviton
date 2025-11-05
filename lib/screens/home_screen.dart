import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/haptic_feedback_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/services/changelog_service.dart';
import 'package:graviton/services/version_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:graviton/widgets/auto_pause_dialog_wrapper.dart';
import 'package:graviton/widgets/body_labels_overlay.dart';
import 'package:graviton/widgets/body_property_editor_overlay.dart';
import 'package:graviton/widgets/body_properties_dialog.dart';
import 'package:graviton/widgets/persistent_bottom_sheet.dart';
import 'package:graviton/widgets/changelog_dialog.dart';
import 'package:graviton/widgets/common/haptic_gesture_detector.dart';
import 'package:graviton/widgets/common/haptic_icon_button.dart';
import 'package:graviton/widgets/common/haptic_ink_well.dart';
import 'package:graviton/widgets/common/haptic_text_button.dart';
import 'package:graviton/screens/developer_tools_screen.dart';
import 'package:graviton/screens/help_screen.dart';
import 'package:graviton/screens/application_settings_screen.dart';
import 'package:graviton/widgets/options_drawer.dart';
import 'package:graviton/widgets/maintenance_dialog.dart';
import 'package:graviton/widgets/offscreen_indicators_overlay.dart';
import 'package:graviton/screens/scenario_selection_screen.dart';
import 'package:graviton/screens/about_screen.dart';
import 'package:graviton/screens/physics_settings_screen.dart';
import 'package:graviton/widgets/screenshot_countdown.dart';
import 'package:graviton/widgets/stats_overlay.dart';
import 'package:graviton/widgets/version_check_dialog.dart';
import 'package:graviton/widgets/tutorial_overlay.dart';
import 'package:graviton/widgets/app_bar_speed_control.dart';
import 'package:graviton/services/onboarding_service.dart';
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

    // Check for app updates and maintenance after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionCheckDialog.showIfRequired(context);
      // Show maintenance/notification dialogs after version check
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          MaintenanceDialog.showIfNeeded(context);
        }
      });
      // Check if first-time user needs tutorial
      _checkFirstTimeUser();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _floatingControlsTimer?.cancel();
    _screenshotModeService.removeListener(_onScreenshotModeChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          _selectObjectAtTapLocation(appState, size, tapPosition);
        }
      }
    });
  }

  void _selectObjectAtTapLocation(
    AppState appState,
    Size size,
    Offset? tapPosition,
  ) {
    final bodies = appState.simulation.bodies;
    if (bodies.isEmpty) return;

    // If we don't have a tap position, fall back to cycling
    if (tapPosition == null) {
      final currentSelection = appState.camera.selectedBody ?? -1;
      final nextSelection = (currentSelection + 1) % bodies.length;
      _selectBody(appState, nextSelection, bodies);
      return;
    }

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

    // Select the closest body if found, otherwise deselect and show controls
    if (closestBodyIndex != null) {
      _selectBody(appState, closestBodyIndex, bodies);
    } else {
      // No body was tapped - deselect current selection and show controls
      appState.camera.selectBody(null);
      _showSimulationControls?.call();
    }
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

    // Set timer to hide controls after 3 seconds of inactivity
    _floatingControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showFloatingControls = false;
        });
      }
    });
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
    return vm.makePerspectiveMatrix(vm.radians(60.0), aspect, 0.1, 4000.0);
  }

  /// Handle screenshot mode changes to control system UI visibility
  void _onScreenshotModeChanged() {
    if (_screenshotModeService.isActive) {
      // Hide system navigation buttons for clean screenshots
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive,
        overlays: [SystemUiOverlay.top], // Keep status bar but hide navigation
      );
    } else {
      // Restore normal system UI
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values, // Show all system UI
      );
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
                  appState.setError('Failed to switch scenario: $e');
                }
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

  void _showBodyPropertiesDialog(BuildContext context, AppState appState) {
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

    AutoPauseDialogWrapper.show<void>(
      context: context,
      child: BodyPropertiesDialog(
        body: selectedBody,
        bodyIndex: selectedIndex,
        onBodyChanged: (updatedBody) {
          // The dialog updates the body directly, trigger a rebuild
          // by notifying that body properties have changed
          appState.simulation.notifyBodyPropertiesChanged();
        },
      ),
    );
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

  void _checkFirstTimeUser() async {
    final hasSeenTutorial = await OnboardingService.hasSeenTutorial();
    if (!hasSeenTutorial && mounted) {
      // Show tutorial after a short delay to let the app initialize
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _showTutorial(context);
        }
      });
    } else {
      // For existing users, check for new changelogs with a longer delay to ensure Firebase is ready
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _checkForNewChangelogs(context);
        }
      });
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
              title: Text('Changelog'),
              content: Text(
                'No changelog available for version $currentVersion',
              ),
              actions: [
                HapticTextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading changelog: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AppState>(
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
            _screenshotModeService.isActive &&
            appState.ui.hideUIInScreenshotMode;

        return Scaffold(
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
              : AppBar(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
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
                            margin: const EdgeInsets.only(right: 8),
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
                      Flexible(
                        child: Text(
                          l10n.appTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                  actions: [
                    // Speed control - now prominent in app bar
                    const AppBarSpeedControl(),

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
                        useRealisticColors: appState.ui.useRealisticColors,
                        showOrbitalPaths: appState.ui.showOrbitalPaths,
                        dualOrbitalPaths: appState.ui.dualOrbitalPaths,
                        showHabitableZones: appState.ui.showHabitableZones,
                        showHabitabilityIndicators:
                            appState.ui.showHabitabilityIndicators,
                        selectedBodyIndex: appState.camera.selectedBody,
                        followMode: appState.camera.followMode,
                        cameraDistance: appState.camera.distance,
                        globalGravityFields: appState.ui.globalGravityFields,
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
                    if (!shouldHideUI && appState.camera.selectedBody != null)
                      BodyPropertyEditorOverlay(
                        bodies: appState.simulation.bodies,
                        viewMatrix: view,
                        projMatrix: _buildProjection(size.aspectRatio),
                        screenSize: size,
                        selectedBodyIndex: appState.camera.selectedBody,
                        onPropertyIconTapped: () =>
                            _showBodyPropertiesDialog(context, appState),
                      ),
                    if (appState.ui.showStats) StatsOverlay(appState: appState),
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
                        child: PersistentBottomSheet(
                          onInteraction: _showFloatingControlsTemporarily,
                        ),
                      ),

                    // Floating simulation controls positioned above the bottom sheet
                    if (!shouldHideUI && _showFloatingControls)
                      ValueListenableBuilder<double>(
                        valueListenable: PersistentBottomSheet.sheetPosition,
                        builder: (context, sheetPosition, child) {
                          final screenHeight = MediaQuery.of(
                            context,
                          ).size.height;
                          final sheetTopPosition =
                              screenHeight * (1 - sheetPosition);

                          return Positioned(
                            bottom:
                                screenHeight -
                                sheetTopPosition +
                                20, // Position above the sheet using bottom positioning
                            right: 32,
                            child: Consumer<AppState>(
                              builder: (context, appState, child) {
                                final l10n = AppLocalizations.of(context)!;
                                return _buildFloatingSimulationControls(
                                  context,
                                  appState,
                                  l10n,
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
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
                  tooltip: 'Previous Scene',
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
                  tooltip: 'Next Scene',
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
            // Remove overlay if still present
            try {
              overlayEntry.remove();
            } catch (e) {
              // Overlay already removed, ignore
            }

            // Close the snackbar first
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            // Deactivate screenshot mode and ensure simulation is unpaused
            screenshotService.deactivate(
              uiState: appState.ui,
              simulationState: appState.simulation,
            );
          },
        ),
      ),
    );
  }

  /// Build floating simulation controls that appear above the bottom sheet
  Widget _buildFloatingSimulationControls(
    BuildContext context,
    AppState appState,
    AppLocalizations l10n,
  ) {
    return Material(
      color: Colors.transparent,
      elevation:
          8, // Add elevation to ensure proper rendering above other content
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause Button
          _buildCircularControlButton(
            icon: appState.simulation.isPaused ? Icons.play_arrow : Icons.pause,
            onPressed: () {
              // Provide haptic feedback for play/pause button
              HapticFeedbackService.instance.light();

              // Reset floating controls timer when button is pressed
              _showFloatingControlsTemporarily();

              FirebaseService.instance.logUIEventWithEnums(
                UIAction.buttonPressed,
                element: UIElement.simulationControl,
                value: appState.simulation.isPaused ? 'play' : 'pause',
              );
              appState.simulation.pause();
            },
            tooltip: appState.simulation.isPaused
                ? l10n.playButton
                : l10n.pauseButton,
            isPrimary: true,
          ),

          const SizedBox(width: AppTypography.spacingSmall),

          // Reset Button
          _buildCircularControlButton(
            icon: Icons.refresh,
            onPressed: () {
              // Provide medium haptic feedback for reset button (more significant action)
              HapticFeedbackService.instance.medium();

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
            isDark: true, // Make reset button darker
          ),
        ],
      ),
    );
  }

  /// Build a circular control button for the simulation controls
  Widget _buildCircularControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isPrimary = false,
    bool isDark = false,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        color: AppColors.transparentColor,
        child: HapticInkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTypography.radiusXXLarge),
          splashColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityMedium,
          ),
          highlightColor: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityFaint,
          ),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPrimary
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityNearlyOpaque,
                    )
                  : isDark
                  ? AppColors.uiBlack.withValues(
                      alpha: AppTypography.opacityHigh,
                    ) // Dark background for reset button
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityVeryFaint,
                    ),
              borderRadius: BorderRadius.circular(AppTypography.radiusXXLarge),
              border: isPrimary
                  ? null
                  : Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityFaint,
                      ),
                      width: 1,
                    ),
            ),
            child: Icon(
              icon,
              color: isPrimary
                  ? AppColors.uiWhite
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityNearlyOpaque,
                    ),
              size: AppTypography.iconSizeMedium,
            ),
          ),
        ),
      ),
    );
  }
}
