import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/painters/graviton_painter.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:graviton/widgets/body_labels_overlay.dart';
import 'package:graviton/widgets/bottom_controls.dart';
import 'package:graviton/widgets/copyright_text.dart';
import 'package:graviton/widgets/maintenance_dialog.dart';
import 'package:graviton/widgets/offscreen_indicators_overlay.dart';
import 'package:graviton/widgets/scenario_selection_dialog.dart';
import 'package:graviton/widgets/screenshot_countdown.dart';
import 'package:graviton/widgets/settings_dialog.dart';
import 'package:graviton/widgets/stats_overlay.dart';
import 'package:graviton/widgets/version_check_dialog.dart';
import 'package:graviton/widgets/help_dialog.dart';
import 'package:graviton/widgets/tutorial_overlay.dart';
import 'package:graviton/services/onboarding_service.dart';
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
  late final ScreenshotModeService _screenshotModeService;

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

    // Push trails if enabled and simulation is running (not paused)
    if (appState.ui.showTrails && !appState.simulation.isPaused) {
      appState.simulation.simulation.pushTrails(1 / 240.0);
    }
  }

  void _handleTapWithDelay(
    BuildContext context,
    AppState appState,
    Size size,
    AppLocalizations l10n,
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
          _selectObjectAtTapLocation(appState, size);
        }
      }
    });
  }

  void _selectObjectAtTapLocation(AppState appState, Size size) {
    // For now, cycle through objects on tap (simple selection mechanism)
    // TODO: Implement proper screen-space to world-space collision detection
    final bodies = appState.simulation.bodies;
    if (bodies.isEmpty) return;

    final currentSelection = appState.camera.selectedBody ?? -1;
    final nextSelection = (currentSelection + 1) % bodies.length;

    appState.camera.selectBody(nextSelection);

    // Focus on the selected body for better zoom behavior
    appState.camera.focusOnBody(nextSelection, bodies);
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

  void _showScenarioSelection(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.dialogOpened,
      element: UIElement.scenarioSelection,
    );

    showDialog<void>(
      context: context,
      builder: (context) => ScenarioSelectionDialog(
        currentScenario: appState.simulation.simulation.currentScenario,
        onScenarioSelected: (scenario) {
          final l10n = AppLocalizations.of(context)!;
          FirebaseService.instance.logUIEventWithEnums(
            UIAction.scenarioSelected,
            element: UIElement.scenarioDialog,
            value: scenario.name,
          );
          appState.simulation.resetWithScenario(scenario, l10n: l10n);
          // Auto-zoom camera to fit the new scenario
          appState.camera.resetViewForScenario(
            scenario,
            appState.simulation.bodies,
          );
        },
      ),
    );
  }

  void _showSettings(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.dialogOpened,
      element: UIElement.settings,
    );
    showDialog<void>(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  void _showHelpDialog(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.dialogOpened,
      element: UIElement.help,
    );
    showDialog<void>(
      context: context,
      builder: (context) => const HelpDialog(),
    );
  }

  void _showTutorial(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tutorialStarted,
      element: UIElement.tutorial,
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TutorialOverlay(
        onComplete: () async {
          await OnboardingService.markTutorialCompleted();
          if (context.mounted) {
            Navigator.of(context).pop();
          }

          FirebaseService.instance.logUIEventWithEnums(
            UIAction.tutorialCompleted,
            element: UIElement.tutorial,
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
            appState.handleLanguageChangeWithContext(l10n);
          }
        });

        final shouldHideUI =
            _screenshotModeService.isActive &&
            appState.ui.hideUIInScreenshotMode;

        return Scaffold(
          appBar: shouldHideUI
              ? null
              : AppBar(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.uiWhite.withValues(
                              alpha: AppTypography.opacityVeryFaint,
                            ),
                            width: 1.5,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/app-logo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(l10n.appTitle),
                    ],
                  ),
                  backgroundColor: AppColors.uiBlack.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                  actions: [
                    IconButton(
                      tooltip: l10n.showHelpTooltip,
                      onPressed: () => _showHelpDialog(context),
                      icon: const Icon(Icons.help_outline),
                    ),
                    IconButton(
                      tooltip: l10n.settingsTooltip,
                      onPressed: () => _showSettings(context),
                      icon: const Icon(Icons.settings),
                    ),
                    IconButton(
                      tooltip: l10n.selectScenarioTooltip,
                      onPressed: () => _showScenarioSelection(context),
                      icon: const Icon(Icons.science),
                    ),
                    IconButton(
                      tooltip: appState.simulation.isPaused
                          ? l10n.playButton
                          : l10n.pauseButton,
                      onPressed: () {
                        final action = appState.simulation.isPaused
                            ? 'play'
                            : 'pause';
                        FirebaseService.instance.logUIEventWithEnums(
                          UIAction.buttonPressed,
                          element: UIElement.simulationControl,
                          value: action,
                        );
                        appState.simulation.pause();
                      },
                      icon: Icon(
                        appState.simulation.isPaused
                            ? Icons.play_arrow
                            : Icons.pause,
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.resetButton,
                      onPressed: () {
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

                        // Reset timing to prevent timing issues after reset
                        _lastElapsed = Duration.zero;
                        appState.resetAll();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              final view = _buildView();

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _handleTapWithDelay(context, appState, size, l10n);
                },
                onScaleStart: (d) {
                  _lastPan = d.focalPoint;
                  _isDragging = false; // Reset dragging state
                  _hasMoved = false; // Reset movement flag
                  _lastTwoFingerRotation = null; // Reset rotation tracking
                  // Don't clear selection on drag start - let user drag selected objects

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
                        showOrbitalPaths: appState.ui.showOrbitalPaths,
                        dualOrbitalPaths: appState.ui.dualOrbitalPaths,
                        showHabitableZones: appState.ui.showHabitableZones,
                        showHabitabilityIndicators:
                            appState.ui.showHabitabilityIndicators,
                        showGravityWells: appState.ui.showGravityWells,
                        selectedBodyIndex: appState.camera.selectedBody,
                        followMode: appState.camera.followMode,
                        cameraDistance: appState.camera.distance,
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
                      ),
                    if (appState.ui.showStats) StatsOverlay(appState: appState),
                    ScreenshotCountdown(
                      screenshotService: _screenshotModeService,
                    ),
                    if (!shouldHideUI) const CopyrightText(),
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: shouldHideUI ? null : const BottomControls(),
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
              borderRadius: BorderRadius.circular(8),
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
                IconButton(
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
                IconButton(
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
}
