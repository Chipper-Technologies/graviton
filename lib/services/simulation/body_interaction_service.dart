import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/core/constants/simulation_constants.dart';
import 'package:graviton/core/constants/ui_constants.dart';
import 'package:graviton/core/enums/add_body_mode.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/snack_bar_severity.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/services/simulation/body_placement_service.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/ui/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/camera_projection_utils.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/features/scenarios/presentation/widgets/scenario_editor_body_details_bottom_sheet.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Service for handling body interactions in the simulation viewport
///
/// This service centralizes all logic related to:
/// - Body hit detection (tap and hover)
/// - Body selection and focus
/// - Body placement and validation
/// - Body editor display
/// - Body movement and dragging
class BodyInteractionService {
  // Private constructor to prevent instantiation
  BodyInteractionService._();

  /// Handle tap on simulation viewport with debounce delay
  ///
  /// This method processes taps after a delay to distinguish them from drags.
  /// It handles:
  /// - Screenshot mode navigation
  /// - Body placement in add mode
  /// - Body selection
  /// - Deselection when tapping empty space
  static void handleTapWithDelay({
    required BuildContext context,
    required AppState appState,
    required Size size,
    required AppLocalizations l10n,
    required Offset tapPosition,
    required bool hasMoved,
    required bool mounted,
    VoidCallback? showSimulationControls,
    required void Function(
      BuildContext,
      AppState,
      ScreenshotModeService,
      AppLocalizations,
    )
    showScreenshotNavigationControls,
  }) {
    // Use Timer instead of Future.delayed to avoid async context issues
    Timer(UIConstants.tapDebounceDelay, () {
      if (!hasMoved && mounted) {
        FirebaseService.instance.logUIEventWithEnums(
          UIAction.tap,
          element: UIElement.simulationViewport,
        );

        // Check if screenshot mode is active and show navigation controls
        final screenshotService = ScreenshotModeService();
        if (screenshotService.isActive) {
          showScreenshotNavigationControls(
            context,
            appState,
            screenshotService,
            l10n,
          );
        } else if (appState.ui.isAddBodyModeActive) {
          // Add body mode is active - place a new body
          placeNewBodyAtTapLocation(
            context: context,
            appState: appState,
            size: size,
            tapPosition: tapPosition,
            l10n: l10n,
            mounted: mounted,
          );
        } else {
          // Check if we tapped on a body
          final tappedBodyIndex = findBodyAtTapLocation(
            appState: appState,
            size: size,
            tapPosition: tapPosition,
          );

          if (tappedBodyIndex != null) {
            // Tapped on a body - select it
            selectBody(
              appState: appState,
              bodyIndex: tappedBodyIndex,
              bodies: appState.simulation.bodies,
            );
          } else {
            // Tapped on empty space - deselect any currently selected body
            appState.camera.selectBody(null);
            showSimulationControls?.call();
          }
        }
      }
    });
  }

  /// Place a new body at the tap location
  ///
  /// This method:
  /// 1. Converts screen coordinates to world coordinates
  /// 2. Validates placement to prevent collisions
  /// 3. Creates a default body
  /// 4. Shows the body editor bottom sheet
  static void placeNewBodyAtTapLocation({
    required BuildContext context,
    required AppState appState,
    required Size size,
    required Offset tapPosition,
    required AppLocalizations l10n,
    required bool mounted,
  }) {
    // Convert screen coordinates to world coordinates
    final view = CameraProjectionUtils.buildViewMatrix(appState.camera);
    final proj = CameraProjectionUtils.buildProjectionMatrix(
      appState.camera,
      size.aspectRatio,
    );

    final worldPosition = BodyPlacementService.screenToWorld(
      screenPosition: tapPosition,
      screenSize: size,
      viewMatrix: view,
      projectionMatrix: proj,
      cameraPosition: appState.camera.eyePosition,
      cameraTarget: appState.camera.target,
      cameraDistance: appState.camera.distance,
    );

    // Create a default body at the tapped location
    // Use small planet-like defaults that won't disrupt most scenarios
    const defaultRadius = SimulationConstants.defaultNewBodyRadius;
    const defaultMass = SimulationConstants.defaultNewBodyMass;
    final bodies = appState.simulation.bodies;

    // Validate placement to prevent immediate collisions
    final isValid = BodyPlacementService.validatePlacement(
      position: worldPosition,
      radius: defaultRadius,
      existingBodyPositions: bodies.map((b) => b.position).toList(),
      existingRadii: bodies.map((b) => b.radius).toList(),
    );

    if (!isValid) {
      // Log analytics for invalid placement
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.tap,
        element: UIElement.simulationViewport,
        value: 'body_placement_too_close',
        additionalParams: {
          'reason': 'collision_risk',
          'body_count': bodies.length.toString(),
        },
      );

      // Show warning snackbar for invalid placement
      if (mounted) {
        GravitonSnackBar.show(
          context: context,
          message: l10n.bodyPlacementTooClose,
          severity: SnackBarSeverity.warning,
        );
      }
      return;
    }

    // Start with zero velocity by default for more predictable behavior
    // Users can adjust velocity in the body editor if needed
    final velocity = vm.Vector3.zero();

    // Create the new body with default properties
    // Small mass and radius to avoid disrupting existing scenarios
    final newBody = Body(
      name: l10n.bodyNewDefault,
      mass: defaultMass,
      radius: defaultRadius,
      position: worldPosition,
      velocity: velocity,
      color: AppColors.stellarGType,
      bodyType: BodyType.star, // Default to star for new bodies
      useRealisticColor:
          appState.ui.useRealisticColors, // Use global setting as default
    );

    // Log analytics event for body placement attempt
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tap,
      element: UIElement.simulationViewport,
      value: 'body_placement_initiated',
      additionalParams: {
        'body_count': bodies.length.toString(),
        'scenario': appState.simulation.currentScenario.name,
      },
    );

    // Show the body editor bottom sheet
    showBodyEditorForNewBody(
      context: context,
      appState: appState,
      newBody: newBody,
      l10n: l10n,
      mounted: mounted,
    );
  }

  /// Show the body editor bottom sheet for a newly placed body
  ///
  /// This method:
  /// 1. Pauses the simulation
  /// 2. Shows the modal bottom sheet with body editor
  /// 3. Handles real-time body updates
  /// 4. Resumes simulation on close
  /// 5. Deactivates add body mode if cancelled
  static void showBodyEditorForNewBody({
    required BuildContext context,
    required AppState appState,
    required Body newBody,
    required AppLocalizations l10n,
    required bool mounted,
  }) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.dialogOpened,
      element: UIElement.bodyProperties,
    );

    // Pause simulation while editing
    final wasPlaying = !appState.simulation.isPaused;
    if (wasPlaying) {
      appState.simulation.pause();
    }

    // Keep a reference to the original body for tracking
    Body trackedBody = newBody;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: RenderingConstants.bottomSheetMaxWidth,
            height:
                MediaQuery.of(context).size.height *
                UIConstants.bottomSheetHeightRatio,
            child: ScenarioEditorBodyDetailsBottomSheet(
              body: trackedBody,
              onBodyChanged: (updatedBody) {
                // Add or update the body in the simulation with real-time updates
                final bodyIndex = appState.simulation.bodies.indexOf(
                  trackedBody,
                );

                if (bodyIndex == -1) {
                  // First time - add the body
                  appState.simulation.simulation.addBody(updatedBody);
                  trackedBody = updatedBody;

                  // Log successful body addition
                  FirebaseService.instance.logUIEventWithEnums(
                    UIAction.buttonPressed,
                    element: UIElement.body,
                    value: 'body_added_successfully',
                    additionalParams: {
                      'body_mass': updatedBody.mass.toStringAsExponential(2),
                      'body_radius': updatedBody.radius.toString(),
                      'total_body_count': appState.simulation.bodies.length
                          .toString(),
                      'scenario': appState.simulation.currentScenario.name,
                    },
                  );

                  // Show success message
                  if (mounted) {
                    GravitonSnackBar.show(
                      context: context,
                      message: l10n.bodyPlacedSuccessfully,
                      severity: SnackBarSeverity.success,
                    );
                  }
                } else {
                  // Update existing body in real-time
                  appState.simulation.simulation.updateBody(
                    bodyIndex,
                    updatedBody,
                  );
                  trackedBody = updatedBody;
                }
                // Don't close the sheet - let user continue editing
              },
              availableCentralBodies: appState.simulation.bodies,
              isAddMode: true,
            ),
          ),
        ),
      ),
    ).then((_) {
      // Resume simulation if it was playing
      if (wasPlaying) {
        appState.simulation.resumeSimulation();
      }

      // Deactivate add body mode if user cancelled
      if (appState.ui.isAddBodyModeActive) {
        // Log cancellation
        FirebaseService.instance.logUIEventWithEnums(
          UIAction.dialogOpened,
          element: UIElement.bodyProperties,
          value: 'body_placement_cancelled',
        );
        appState.ui.setAddBodyMode(AddBodyMode.inactive);
      }
    });
  }

  /// Show the body properties bottom sheet for an existing body
  ///
  /// This method displays a modal bottom sheet for editing properties of an
  /// existing body in the simulation. It pauses the simulation during editing
  /// and resumes it afterward.
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing the bottom sheet
  /// - [appState]: AppState containing simulation and body data
  /// - [mounted]: Whether the widget is currently mounted
  static void showBodyPropertiesBottomSheet({
    required BuildContext context,
    required AppState appState,
    required bool mounted,
  }) {
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
        builder: (context, setSheetState) => Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: RenderingConstants.bottomSheetMaxWidth,
            height:
                MediaQuery.of(context).size.height *
                UIConstants.bottomSheetHeightRatio,
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
      ),
    ).then((_) {
      // Resume simulation if it was playing
      if (wasPlaying) {
        appState.simulation.resumeSimulation();
      }
    });
  }

  /// Common helper to find the body at a given screen position
  ///
  /// This method projects all bodies to screen space and checks if any
  /// are within the hit radius of the given screen position.
  ///
  /// The hit radius scales with camera distance to maintain consistent
  /// hit detection at different zoom levels.
  ///
  /// Returns the index of the closest body within hit radius, or null if none found.
  static int? _findBodyAtScreenPosition({
    required AppState appState,
    required Size size,
    required Offset? screenPosition,
    required double baseHitRadius,
    required double distanceScaleFactor,
  }) {
    final bodies = appState.simulation.bodies;
    if (bodies.isEmpty || screenPosition == null) return null;

    final view = CameraProjectionUtils.buildViewMatrix(appState.camera);
    final proj = CameraProjectionUtils.buildProjectionMatrix(
      appState.camera,
      size.aspectRatio,
    );

    int? closestBodyIndex;
    double closestDistance = double.infinity;

    for (int i = 0; i < bodies.length; i++) {
      final body = bodies[i];

      final screenPos = CameraProjectionUtils.projectToScreen(
        body.position,
        view,
        proj,
        size,
      );

      if (screenPos != null) {
        final distance = (screenPosition - screenPos).distance;
        final distanceScale = math.max(
          1.0,
          appState.camera.distance / distanceScaleFactor,
        );
        final hitRadius = baseHitRadius * distanceScale;

        if (distance <= hitRadius && distance < closestDistance) {
          closestDistance = distance;
          closestBodyIndex = i;
        }
      }
    }

    return closestBodyIndex;
  }

  /// Find the body at the given tap location
  ///
  /// Uses a generous hit radius (40.0) to make tap selection easier.
  ///
  /// Returns the body index if a body is found, null otherwise.
  static int? findBodyAtTapLocation({
    required AppState appState,
    required Size size,
    required Offset? tapPosition,
  }) {
    return _findBodyAtScreenPosition(
      appState: appState,
      size: size,
      screenPosition: tapPosition,
      baseHitRadius: 40.0, // Generous hit radius for tap
      distanceScaleFactor: 300.0,
    );
  }

  /// Find the body at the given hover location (more precise than tap)
  ///
  /// Uses a smaller hit radius (15.0) for hover precision.
  ///
  /// Returns the body index if a body is found, null otherwise.
  static int? findBodyAtHoverLocation({
    required AppState appState,
    required Size size,
    required Offset? hoverPosition,
  }) {
    return _findBodyAtScreenPosition(
      appState: appState,
      size: size,
      screenPosition: hoverPosition,
      baseHitRadius: 15.0, // Smaller hit radius for hover precision
      distanceScaleFactor: 400.0,
    );
  }

  /// Select a body and update camera focus
  ///
  /// This method:
  /// 1. Selects the body in the camera
  /// 2. If follow mode is active, starts following the body
  /// 3. Otherwise, focuses camera on the body
  /// 4. Logs analytics events
  static void selectBody({
    required AppState appState,
    required int bodyIndex,
    required List<Body> bodies,
  }) {
    final selectedBody = bodies[bodyIndex];
    appState.camera.selectBody(bodyIndex);

    // If follow mode is active, immediately start following the newly selected body
    if (appState.camera.followMode) {
      appState.camera.setFollowBody(bodyIndex, bodies);

      FirebaseService.instance.logUIEventWithEnums(
        UIAction.followToggle,
        element: UIElement.cameraControls,
        value: 'body_${selectedBody.name}',
        additionalParams: {
          'body_type': selectedBody.bodyType.name,
          'body_index': bodyIndex.toString(),
        },
      );
    } else {
      // Focus on the selected body for better viewing
      appState.camera.focusOnBody(bodyIndex, bodies);
    }

    FirebaseService.instance.logUIEventWithEnums(
      UIAction.bodyTapInteraction,
      element: UIElement.viewportCanvas,
      value: 'body_selected',
      additionalParams: {
        'body_name': selectedBody.name,
        'body_type': selectedBody.bodyType.name,
        'body_index': bodyIndex.toString(),
        'follow_mode': appState.camera.followMode.toString(),
        'camera_technique': appState.ui.cinematicCameraTechnique.name,
      },
    );
  }

  /// Handle body movement by converting screen position to world coordinates
  ///
  /// This method implements ray-plane intersection to determine the new
  /// 3D position of the body based on the 2D screen position.
  ///
  /// The plane is perpendicular to the camera view direction and passes
  /// through the body's current position, ensuring the body stays at
  /// the same depth relative to the camera.
  ///
  /// Parameters:
  /// - [appState]: Current application state
  /// - [screenSize]: Size of the screen/viewport
  /// - [screenPosition]: Current screen position of the drag
  /// - [onUpdate]: Callback to trigger UI rebuild
  static void handleBodyMovement({
    required AppState appState,
    required Size screenSize,
    required Offset screenPosition,
    required VoidCallback onUpdate,
  }) {
    final bodyIndex = appState.ui.movingBodyIndex;
    if (bodyIndex == null || bodyIndex >= appState.simulation.bodies.length) {
      return;
    }

    final body = appState.simulation.bodies[bodyIndex];

    // Build view and projection matrices
    final view = CameraProjectionUtils.buildViewMatrix(appState.camera);
    final proj = CameraProjectionUtils.buildProjectionMatrix(
      appState.camera,
      screenSize.aspectRatio,
    );
    final vp = proj * view;

    // Calculate the plane at the body's current depth
    // Plane is perpendicular to view direction, passing through the body
    final cameraPos = appState.camera.eyePosition;
    final viewDir = (appState.camera.target - cameraPos).normalized();
    final planePoint = body.position;

    // Convert screen position to normalized device coordinates
    final ndcX = (screenPosition.dx / screenSize.width) * 2.0 - 1.0;
    final ndcY = 1.0 - (screenPosition.dy / screenSize.height) * 2.0;

    // Create ray from camera through screen position
    // Unproject the near and far points
    final vpInv = vm.Matrix4.identity();
    if (vpInv.copyInverse(vp) == 0.0) {
      return; // Matrix not invertible
    }

    final nearClip = vpInv * vm.Vector4(ndcX, ndcY, -1.0, 1.0);
    final farClip = vpInv * vm.Vector4(ndcX, ndcY, 1.0, 1.0);

    final near = vm.Vector3(
      nearClip.x / nearClip.w,
      nearClip.y / nearClip.w,
      nearClip.z / nearClip.w,
    );
    final far = vm.Vector3(
      farClip.x / farClip.w,
      farClip.y / farClip.w,
      farClip.z / farClip.w,
    );

    final rayDir = (far - near).normalized();

    // Ray-plane intersection
    // Plane equation: dot(viewDir, point - planePoint) = 0
    final denom = viewDir.dot(rayDir);
    if (denom.abs() < 1e-6) {
      return; // Ray parallel to plane
    }

    final t = viewDir.dot(planePoint - near) / denom;
    if (t < 0) {
      return; // Intersection behind ray origin
    }

    final newPosition = near + (rayDir * t);

    // Update the body's position directly (Body is mutable)
    body.position = newPosition;

    // Reset velocity to prevent drift while dragging
    body.velocity = vm.Vector3.zero();

    // Trigger UI update to show the body following the finger
    onUpdate();
  }
}
