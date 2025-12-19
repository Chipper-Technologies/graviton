import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/ui/keyboard_navigation_service.dart';
import 'package:graviton/services/ui/screenshot_mode_service.dart';
import 'package:graviton/shared/painters/graviton_painter.dart';
import 'package:graviton/shared/widgets/controls/screenshot_countdown.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/camera_projection_utils.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:graviton/widgets/overlays/body_labels_overlay.dart';
import 'package:graviton/widgets/overlays/body_property_editor_overlay.dart';
import 'package:graviton/widgets/overlays/camera_visual_aids_overlay.dart';
import 'package:graviton/widgets/overlays/offscreen_indicators_overlay.dart';
import 'package:graviton/widgets/overlays/stats_overlay.dart';
import 'package:graviton/widgets/semantics/semantic_live_region.dart';
import 'package:graviton/widgets/semantics/semantic_simulation_canvas.dart';

/// The main simulation viewport widget that handles all rendering and interaction
///
/// This widget manages:
/// - 3D visualization with GravitonPainter
/// - Mouse/touch gesture handling (zoom, pan, rotate, roll)
/// - Body selection and movement
/// - Overlay rendering (labels, indicators, stats)
/// - Scroll events for zoom and pan
class SimulationViewportWidget extends StatefulWidget {
  final AppState appState;
  final List<StarData> stars;
  final GlobalKey simulationViewportKey;
  final bool shouldHideUI;
  final ScreenshotModeService screenshotModeService;
  final VoidCallback showFloatingControlsTemporarily;

  // Callbacks for body interaction
  final void Function(BuildContext, AppState, Size, AppLocalizations, Offset)
  onTap;
  final void Function(AppState) onFullscreenToggle;
  final void Function(Offset, AppState) onThreeFingerPan;
  final void Function(AppState, Size, Offset) onBodyMovement;
  final void Function(AppState, int, List<Body>) onBodySelected;
  final void Function(BuildContext, AppState) onBodyPropertiesRequested;
  final VoidCallback? onShowSimulationControls;

  // Mouse hover state callback (optional)
  final ValueChanged<bool>? onHoverStateChanged;

  // Body detection callback
  final int? Function(AppState, Size, Offset?) findBodyAtTapLocation;
  final int? Function(AppState, Size, Offset?) findBodyAtHoverLocation;

  const SimulationViewportWidget({
    super.key,
    required this.appState,
    required this.stars,
    required this.simulationViewportKey,
    required this.shouldHideUI,
    required this.screenshotModeService,
    required this.showFloatingControlsTemporarily,
    required this.onTap,
    required this.onFullscreenToggle,
    required this.onThreeFingerPan,
    required this.onBodyMovement,
    required this.onBodySelected,
    required this.onBodyPropertiesRequested,
    this.onHoverStateChanged,
    required this.findBodyAtTapLocation,
    required this.findBodyAtHoverLocation,
    this.onShowSimulationControls,
  });

  @override
  State<SimulationViewportWidget> createState() =>
      _SimulationViewportWidgetState();
}

class _SimulationViewportWidgetState extends State<SimulationViewportWidget> {
  Offset? _lastPan;
  bool _isDragging = false;
  bool _hasMoved = false;
  double? _lastTwoFingerRotation;
  bool _isHoveringOverBody = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final view = CameraProjectionUtils.buildViewMatrix(
          widget.appState.camera,
        );

        return Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              final scrollDeltaY = event.scrollDelta.dy;
              final scrollDeltaX = event.scrollDelta.dx;

              // Check if horizontal scroll is being used (side scroller)
              if (scrollDeltaX.abs() > scrollDeltaY.abs()) {
                // Handle horizontal scroll for panning (like three-finger pan)
                final screenDelta = Offset(scrollDeltaX, 0.0);
                widget.onThreeFingerPan(screenDelta, widget.appState);

                widget.showFloatingControlsTemporarily();

                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.viewportGestureStart,
                  element: UIElement.viewportCanvas,
                  value: 'horizontal_scroll_pan',
                  additionalParams: {
                    'scroll_delta_x': scrollDeltaX.toString(),
                    'input_method': 'mouse_side_scroller',
                    'camera_technique':
                        widget.appState.ui.cinematicCameraTechnique.name,
                    'follow_mode': widget.appState.camera.followMode.toString(),
                  },
                );
              } else {
                // Handle vertical mouse wheel scroll for zoom
                final zoomDelta = scrollDeltaY * 0.001;

                widget.appState.camera.zoomTowardBody(
                  zoomDelta,
                  widget.appState.simulation.bodies,
                );

                widget.showFloatingControlsTemporarily();

                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.zoomLevelChanged,
                  element: UIElement.viewportCanvas,
                  value: scrollDeltaY < 0
                      ? 'scroll_zoom_in'
                      : 'scroll_zoom_out',
                  additionalParams: {
                    'scroll_delta': scrollDeltaY.toString(),
                    'camera_distance': widget.appState.camera.distance
                        .toString(),
                    'input_method': 'mouse_wheel',
                  },
                );
              }
            }
          },
          child: MouseRegion(
            cursor: _isHoveringOverBody
                ? SystemMouseCursors.click
                : MouseCursor.defer,
            onHover: (event) {
              final bodyIndex = widget.findBodyAtHoverLocation(
                widget.appState,
                size,
                event.localPosition,
              );

              if ((_isHoveringOverBody && bodyIndex == null) ||
                  (!_isHoveringOverBody && bodyIndex != null)) {
                setState(() {
                  _isHoveringOverBody = bodyIndex != null;
                });
                widget.onHoverStateChanged?.call(_isHoveringOverBody);
              }
            },
            child: HapticGestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) {
                widget.showFloatingControlsTemporarily();
                widget.onTap(
                  context,
                  widget.appState,
                  size,
                  l10n,
                  details.localPosition,
                );
              },
              onDoubleTap: () {
                widget.showFloatingControlsTemporarily();
                widget.onFullscreenToggle(widget.appState);

                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.doubleTap,
                  element: UIElement.simulationViewport,
                  value: 'fullscreen_toggle',
                );
              },
              onScaleStart: (d) {
                _lastPan = d.focalPoint;
                _isDragging = false;
                _hasMoved = false;
                _lastTwoFingerRotation = null;

                if (d.pointerCount == 1) {
                  final tappedBodyIndex = widget.findBodyAtTapLocation(
                    widget.appState,
                    size,
                    d.focalPoint,
                  );

                  // Only start body movement if interaction is not locked
                  if (tappedBodyIndex != null &&
                      !widget.appState.ui.isInteractionLocked) {
                    widget.appState.camera.selectBody(tappedBodyIndex);
                    widget.appState.ui.startBodyMovement(tappedBodyIndex);
                  }
                }

                widget.onShowSimulationControls?.call();
                widget.showFloatingControlsTemporarily();

                _logGestureStart(d.pointerCount);
              },
              onScaleUpdate: (d) {
                final pos = d.focalPoint;
                final delta = pos - (_lastPan ?? pos);

                if (delta.distance > 2.0) {
                  if (!_hasMoved) {
                    _hasMoved = true;
                  }
                  if (delta.distance > 5.0 && !_isDragging) {
                    _isDragging = true;
                  }
                }

                if (widget.appState.ui.isBodyMovementModeActive &&
                    widget.appState.ui.movingBodyIndex != null &&
                    d.pointerCount == 1) {
                  widget.onBodyMovement(widget.appState, size, pos);
                } else if (d.pointerCount >= 3) {
                  widget.onThreeFingerPan(delta, widget.appState);
                } else if (d.pointerCount >= 2) {
                  final dz = (1 - d.scale) * 0.1;
                  widget.appState.camera.zoomTowardBody(
                    dz,
                    widget.appState.simulation.bodies,
                  );

                  if (_lastTwoFingerRotation != null) {
                    final deltaRotation = d.rotation - _lastTwoFingerRotation!;
                    widget.appState.camera.rotateRoll(deltaRotation);
                  }
                  _lastTwoFingerRotation = d.rotation;
                } else {
                  final deltaYaw = -delta.dx * 0.01;
                  final deltaPitch = -delta.dy * 0.01;
                  widget.appState.camera.rotate(deltaYaw, deltaPitch);
                }
                _lastPan = pos;
              },
              onScaleEnd: (_) {
                if (_hasMoved || _isDragging) {
                  FirebaseService.instance.logUIEventWithEnums(
                    UIAction.viewportGestureEnd,
                    element: UIElement.viewportCanvas,
                    value: _lastTwoFingerRotation != null
                        ? 'zoom_rotate'
                        : widget.appState.ui.isBodyMovementModeActive
                        ? 'body_movement'
                        : 'pan_rotate',
                    additionalParams: {
                      'had_movement': _hasMoved.toString(),
                      'was_dragging': _isDragging.toString(),
                      'camera_technique':
                          widget.appState.ui.cinematicCameraTechnique.name,
                      'follow_mode': widget.appState.camera.followMode
                          .toString(),
                      'body_movement_mode': widget
                          .appState
                          .ui
                          .isBodyMovementModeActive
                          .toString(),
                    },
                  );
                }

                if (widget.appState.ui.isBodyMovementModeActive) {
                  final movedBodyIndex = widget.appState.ui.movingBodyIndex;
                  if (movedBodyIndex != null &&
                      movedBodyIndex <
                          widget.appState.simulation.trails.length) {
                    widget.appState.simulation.trails[movedBodyIndex].clear();
                  }

                  widget.appState.ui.stopBodyMovement();
                }

                _lastPan = null;
                _isDragging = false;
                _hasMoved = false;
                _lastTwoFingerRotation = null;

                if (!widget.appState.camera.followMode) {
                  widget.appState.camera.selectBody(null);
                }
              },
              child: KeyboardNavigationService.instance.createKeyboardListener(
                child: SemanticSimulationCanvas(
                  bodies: widget.appState.simulation.bodies,
                  status: widget.appState.simulation.status,
                  timeScale: widget.appState.simulation.timeScale,
                  stepCount: widget.appState.simulation.stepCount,
                  cameraDistance: widget.appState.camera.distance,
                  autoRotate: widget.appState.camera.autoRotate,
                  followMode: widget.appState.camera.followMode,
                  followingBodyName: widget.appState.camera.selectedBody != null
                      ? l10n.bodySelectedTemplate(
                          widget.appState.camera.selectedBody.toString(),
                        )
                      : null,
                  onTap: widget.showFloatingControlsTemporarily,
                  onCenter: () => widget.appState.camera.resetView(
                    widget.appState.simulation.currentScenario,
                  ),
                  onToggleRotate: () =>
                      widget.appState.camera.toggleAutoRotate(),
                  child: Stack(
                    children: [
                      RepaintBoundary(
                        key: widget.simulationViewportKey,
                        child: Container(
                          color: AppColors.backgroundBlack,
                          child: Stack(
                            children: [
                              CustomPaint(
                                painter: GravitonPainter(
                                  sim: widget.appState.simulation.simulation,
                                  view: view,
                                  proj:
                                      CameraProjectionUtils.buildProjectionMatrix(
                                        widget.appState.camera,
                                        size.aspectRatio,
                                      ),
                                  stars: widget.stars,
                                  showTrails: widget.appState.ui.showTrails,
                                  useWarmTrails:
                                      widget.appState.ui.useWarmTrails,
                                  useRealisticColors:
                                      widget.appState.ui.useRealisticColors,
                                  showOrbitalPaths:
                                      widget.appState.ui.showOrbitalPaths,
                                  dualOrbitalPaths:
                                      widget.appState.ui.dualOrbitalPaths,
                                  showHabitableZones:
                                      widget.appState.ui.showHabitableZones,
                                  showHabitabilityIndicators: widget
                                      .appState
                                      .ui
                                      .showHabitabilityIndicators,
                                  selectedBodyIndex:
                                      widget.appState.camera.selectedBody,
                                  followMode: widget.appState.camera.followMode,
                                  cameraDistance:
                                      widget.appState.camera.distance,
                                  globalGravityFields:
                                      widget.appState.ui.globalGravityFields,
                                  gravityFieldColorScheme: widget
                                      .appState
                                      .ui
                                      .gravityFieldColorScheme,
                                  showEquipotentialSurfaces: widget
                                      .appState
                                      .ui
                                      .showEquipotentialSurfaces,
                                  showStellarCoronas:
                                      widget.appState.ui.showStellarCoronas,
                                  showAtmosphericEffects:
                                      widget.appState.ui.showAtmosphericEffects,
                                  showGravityFieldIndicators: widget
                                      .appState
                                      .ui
                                      .showGravityFieldIndicators,
                                  movingBodyIndex:
                                      widget.appState.ui.movingBodyIndex,
                                  enableHemisphereLighting: widget
                                      .appState
                                      .ui
                                      .enableHemisphereLighting,
                                  enableCastShadows:
                                      widget.appState.ui.enableCastShadows,
                                  enableSpecularHighlights: widget
                                      .appState
                                      .ui
                                      .enableSpecularHighlights,
                                  showRelativisticGlow: widget
                                      .appState
                                      .simulation
                                      .showRelativisticGlow,
                                  showTidalVisualization: widget
                                      .appState
                                      .simulation
                                      .showTidalVisualization,
                                ),
                                child: const SizedBox.expand(),
                              ),
                              if (widget.appState.ui.showLabels)
                                BodyLabelsOverlay(
                                  bodies: widget.appState.simulation.bodies,
                                  viewMatrix: view,
                                  projMatrix:
                                      CameraProjectionUtils.buildProjectionMatrix(
                                        widget.appState.camera,
                                        size.aspectRatio,
                                      ),
                                  screenSize: size,
                                  l10n: l10n,
                                ),
                              if (widget.appState.ui.showOffScreenIndicators)
                                OffScreenIndicatorsOverlay(
                                  bodies: widget.appState.simulation.bodies,
                                  viewMatrix: view,
                                  projMatrix:
                                      CameraProjectionUtils.buildProjectionMatrix(
                                        widget.appState.camera,
                                        size.aspectRatio,
                                      ),
                                  screenSize: size,
                                  selectedBodyIndex:
                                      widget.appState.camera.selectedBody,
                                  onIndicatorTapped: (bodyIndex) {
                                    widget.onBodySelected(
                                      widget.appState,
                                      bodyIndex,
                                      widget.appState.simulation.bodies,
                                    );
                                  },
                                ),
                              if (!widget.shouldHideUI &&
                                  widget.appState.camera.selectedBody != null)
                                BodyPropertyEditorOverlay(
                                  bodies: widget.appState.simulation.bodies,
                                  viewMatrix: view,
                                  projMatrix:
                                      CameraProjectionUtils.buildProjectionMatrix(
                                        widget.appState.camera,
                                        size.aspectRatio,
                                      ),
                                  screenSize: size,
                                  selectedBodyIndex:
                                      widget.appState.camera.selectedBody,
                                  onPropertyIconTapped: () =>
                                      widget.onBodyPropertiesRequested(
                                        context,
                                        widget.appState,
                                      ),
                                ),
                              if (!widget.shouldHideUI)
                                CameraVisualAidsOverlay(
                                  bodies: widget.appState.simulation.bodies,
                                  viewMatrix: view,
                                  projMatrix:
                                      CameraProjectionUtils.buildProjectionMatrix(
                                        widget.appState.camera,
                                        size.aspectRatio,
                                      ),
                                  screenSize: size,
                                  selectedBodyIndex:
                                      widget.appState.camera.selectedBody,
                                  cameraDistance:
                                      widget.appState.camera.distance,
                                  showCrosshairs:
                                      widget.appState.camera.showCrosshairs,
                                ),
                              if (widget.appState.ui.showStats)
                                Positioned(
                                  top:
                                      MediaQuery.of(context).padding.top +
                                      kToolbarHeight +
                                      16,
                                  left: 16,
                                  child: SemanticLiveRegion(
                                    currentValue:
                                        '${widget.appState.simulation.stepCount}',
                                    dataType: l10n.simulationStepsLabel,
                                    child: StatsOverlay(
                                      appState: widget.appState,
                                    ),
                                  ),
                                ),
                              ScreenshotCountdown(
                                screenshotService: widget.screenshotModeService,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _logGestureStart(int pointerCount) {
    if (pointerCount >= 3) {
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.viewportGestureStart,
        element: UIElement.viewportCanvas,
        value: 'three_finger_pan',
        additionalParams: {
          'pointer_count': pointerCount.toString(),
          'camera_technique': widget.appState.ui.cinematicCameraTechnique.name,
          'follow_mode': widget.appState.camera.followMode.toString(),
        },
      );
    } else if (pointerCount >= 2) {
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.viewportGestureStart,
        element: UIElement.viewportCanvas,
        value: 'multi_touch_zoom',
        additionalParams: {
          'pointer_count': pointerCount.toString(),
          'camera_technique': widget.appState.ui.cinematicCameraTechnique.name,
          'follow_mode': widget.appState.camera.followMode.toString(),
        },
      );
    } else {
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.viewportGestureStart,
        element: UIElement.viewportCanvas,
        value: 'pan_rotate',
        additionalParams: {
          'camera_technique': widget.appState.ui.cinematicCameraTechnique.name,
          'follow_mode': widget.appState.camera.followMode.toString(),
        },
      );
    }
  }
}
