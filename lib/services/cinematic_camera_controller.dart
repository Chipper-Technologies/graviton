import 'dart:math' as math;

import 'package:graviton/constants/rendering_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/orbital_event.dart';
import 'package:graviton/services/orbital_prediction_engine.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Camera parameters specific to different simulation scenarios
class ScenarioCameraParameters {
  final double safetyMargin;
  final double minDistance;
  final double maxDistance;
  final double pitchSensitivity;
  final int targetLockFrames;
  final double orbitSpeed;

  const ScenarioCameraParameters({
    required this.safetyMargin,
    required this.minDistance,
    required this.maxDistance,
    required this.pitchSensitivity,
    required this.targetLockFrames,
    required this.orbitSpeed,
  });
}

/// Controller for cinematic camera techniques
///
/// This service orchestrates different AI-driven camera behaviors based on
/// the selected technique in the UI. It provides two main approaches:
///
/// **Predictive Orbital**: Focuses on predetermined tours and orbital predictions
/// - Solar system, earth-moon-sun, binary stars, asteroid belt, galaxy formation tours
/// - Uses orbital mechanics predictions to anticipate interesting events
/// - Smooth, cinematic transitions between predetermined viewpoints
/// - Best for educational scenarios with known orbital patterns
///
/// **Dynamic Framing**: Focuses on real-time dramatic interactions
/// - Dramatic targeting system for random scenarios
/// - Ultra-aggressive close-ups for chaotic interactions
/// - Emergency interruption of transitions for dramatic moments
/// - Ejection detection and close encounter prioritization
/// - Real-time framing validation to keep action in view
/// - Best for unpredictable scenarios requiring reactive camera work
class CinematicCameraController {
  final OrbitalPredictionEngine _predictionEngine = OrbitalPredictionEngine();

  // Dynamic rotation state
  double _orbitTime = 0.0;
  double _verticalOscillation = 0.0;

  // Movement variation
  double _directionChangeTime = 0.0;
  double _currentOrbitDirection = 1.0; // 1.0 or -1.0 for different directions

  // Camera angle state for smooth transitions
  double _currentCameraYaw = 0.0;
  double _currentCameraPitch = 0.2;
  double _currentCameraRoll = 0.0;

  // Intelligent framing state
  List<Body> _currentFramedBodies = [];
  List<Body> _targetFramedBodies = []; // The target we're transitioning TO
  vm.Vector3 _previousCenter = vm.Vector3.zero();
  double _previousDistance = 100.0;
  bool _isTransitioning = false;
  double _transitionProgress = 0.0;

  // Multi-body framing state
  bool _isFramingMultipleBodies = false;
  List<Body> _allInterestingBodies = [];
  double _multiBodyFramingTime = 0.0;

  // Target locking state
  List<Body>? _nextTargetBodies; // Queue the next target instead of switching immediately
  bool _hasQueuedTarget = false;
  int _framesSinceLastSwitch = 0; // Track frames since last switch
  int _totalFrames = 0; // Total frame counter

  // AI handoff state for smooth transitions
  vm.Vector3? _aiLastTarget;
  double? _aiLastDistance;

  // Earth-Moon-Sun specific AI state
  double? _emsAiBaseYaw;
  double? _emsAiBasePitch;
  double? _emsAiBaseRoll;

  // Scenario tracking for tour resets
  ScenarioType? _lastScenario;
  double _scenarioStartTime = 0.0;

  // Body count tracking for merger detection
  int _lastBodyCount = 0;

  /// Update camera based on selected technique
  void updateCamera(
    CinematicCameraTechnique technique,
    SimulationState simulation,
    CameraState camera,
    UIState ui,
    double deltaTime,
  ) {
    // Only update frame counter and apply cinematic techniques if simulation is running and not paused
    if (!simulation.isRunning || simulation.isPaused || simulation.bodies.isEmpty) {
      return;
    }

    // Clean up any stale body references that may have been removed during mergers
    _cleanupStaleBodyReferences(simulation.bodies);

    // Update frame counter only when simulation is actually advancing
    _totalFrames++;
    _framesSinceLastSwitch++;

    switch (technique) {
      case CinematicCameraTechnique.manual:
        // Manual mode - do nothing, let user control camera
        break;

      case CinematicCameraTechnique.predictiveOrbital:
        // Predictive orbital: Tours and orbital predictions
        // - Predetermined cinematic tours for specific scenarios
        // - Orbital mechanics predictions for event anticipation
        // - Smooth, educational camera movements
        _handlePredictiveOrbital(simulation, camera, deltaTime);
        break;

      case CinematicCameraTechnique.dynamicFraming:
        // Dynamic framing: Real-time dramatic interactions
        // - Dramatic targeting for random scenarios
        // - Ultra-aggressive close-ups for chaotic interactions
        // - Emergency transition interruption for dramatic moments
        // - Real-time framing validation and ejection detection
        _handleDynamicFraming(simulation, camera, deltaTime);
        break;
    }
  }

  /// Clean up stale body references that may have been removed during body mergers
  void _cleanupStaleBodyReferences(List<Body> currentBodies) {
    // Check for sudden body count changes (mergers/removals)
    final currentBodyCount = currentBodies.length;
    final significantChange = (currentBodyCount - _lastBodyCount).abs() >= 1;

    if (significantChange && _lastBodyCount > 0) {
      // Reset camera state when bodies merge/disappear to prevent stale references
      _isTransitioning = false;
      _transitionProgress = 0.0;
      _isFramingMultipleBodies = false;
      _multiBodyFramingTime = 0.0;
      _currentFramedBodies.clear();
      _targetFramedBodies.clear();
      _allInterestingBodies.clear();
      _hasQueuedTarget = false;
      _nextTargetBodies = null;
    }

    _lastBodyCount = currentBodyCount;

    // Check if any tracked bodies are no longer in the simulation
    _currentFramedBodies.removeWhere((trackedBody) => !currentBodies.contains(trackedBody));
    _targetFramedBodies.removeWhere((trackedBody) => !currentBodies.contains(trackedBody));
    _allInterestingBodies.removeWhere((trackedBody) => !currentBodies.contains(trackedBody));

    // If we've lost our tracked bodies due to mergers, reset the framing state
    if (_currentFramedBodies.isEmpty && _isTransitioning) {
      _isTransitioning = false;
      _transitionProgress = 0.0;
    }

    // Reset multi-body framing if we've lost too many bodies
    if (_isFramingMultipleBodies && _allInterestingBodies.length < 2) {
      _isFramingMultipleBodies = false;
      _multiBodyFramingTime = 0.0;
    }
  }

  /// Handle predictive orbital camera technique
  void _handlePredictiveOrbital(SimulationState simulation, CameraState camera, double deltaTime) {
    // For solar system, use direct tour instead of predictions
    if (simulation.currentScenario == ScenarioType.solarSystem) {
      _handleSolarSystemTour(simulation, camera, deltaTime);
      return;
    }

    // For Earth-Moon-Sun, use specialized tour
    if (simulation.currentScenario == ScenarioType.earthMoonSun) {
      _handleEarthMoonSunTour(simulation, camera, deltaTime);
      return;
    }

    // For Binary Stars, use specialized tour
    if (simulation.currentScenario == ScenarioType.binaryStars) {
      _handleBinaryStarTour(simulation, camera, deltaTime);
      return;
    }

    // For Asteroid Belt, use specialized tour
    if (simulation.currentScenario == ScenarioType.asteroidBelt) {
      _handleAsteroidBeltTour(simulation, camera, deltaTime);
      return;
    }

    // For Galaxy Formation, use specialized tour
    if (simulation.currentScenario == ScenarioType.galaxyFormation) {
      _handleGalaxyFormationTour(simulation, camera, deltaTime);
      return;
    }

    // For other scenarios, use orbital predictions to anticipate interesting events
    _handleOrbitalPredictions(simulation, camera, deltaTime);
  }

  /// Handle orbital predictions for scenarios without predetermined tours
  void _handleOrbitalPredictions(SimulationState simulation, CameraState camera, double deltaTime) {
    // Get orbital predictions
    const timeFrame = 10.0;
    const timeStep = 0.1;
    final predictions = _predictionEngine.predictFuturePositions(simulation.bodies, timeFrame, timeStep: timeStep);

    // Detect events using predictions
    final config = PredictiveOrbitalConfig.forScenario('three_body');
    final events = _predictionEngine.detectEvents(simulation.bodies, predictions, timeStep, config);

    if (events.isNotEmpty) {
      // Focus on the most imminent dramatic event
      final targetEvent = events.first;

      // Get the bodies involved in this event
      final involvedBodies = targetEvent.involvedBodies
          .where((index) => index < simulation.bodies.length)
          .map((index) => simulation.bodies[index])
          .toList();

      if (involvedBodies.isNotEmpty) {
        // Use standard orbital framing for predicted events
        _updateStandardOrbitalFraming(simulation, camera, deltaTime, involvedBodies);
        return;
      }
    }

    // No specific events - use standard orbital framing for all bodies
    _updateStandardOrbitalFraming(simulation, camera, deltaTime, simulation.bodies);
  }

  /// Standard orbital framing based on predictions (less aggressive than dynamic framing)
  void _updateStandardOrbitalFraming(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
    List<Body> targetBodies,
  ) {
    if (targetBodies.isEmpty) {
      return;
    }

    // Find the most interesting pair of bodies for orbital mechanics
    final candidates = _findMostInterestingBodies(targetBodies, simulation.currentScenario);

    // Update framed bodies with standard orbital logic (less dramatic than dynamic framing)
    if (candidates.isNotEmpty && _shouldUpdateFramedBodiesOrbital(candidates, simulation.currentScenario)) {
      _currentFramedBodies = candidates;
      _framesSinceLastSwitch = 0;

      // Start smooth transition for orbital technique
      _previousCenter = _currentFramedBodies.isNotEmpty ? _calculateCenter(_currentFramedBodies) : vm.Vector3.zero();
      _previousDistance = camera.distance;
      _isTransitioning = true;
      _transitionProgress = 0.0;
    }

    // Update camera to frame the current bodies with orbital mechanics focus
    _updateCameraForBodies(
      _currentFramedBodies.isNotEmpty ? _currentFramedBodies : targetBodies,
      camera,
      deltaTime,
      simulation.currentScenario,
    );
  }

  /// Orbital-specific logic for updating framed bodies (less dramatic than dynamic framing)
  bool _shouldUpdateFramedBodiesOrbital(List<Body> candidateBodies, ScenarioType scenario) {
    final cameraParams = _getScenarioCameraParameters(scenario);
    final minLockFrames = cameraParams.targetLockFrames;

    if (_currentFramedBodies.isEmpty) {
      if (candidateBodies.isNotEmpty) {
        _framesSinceLastSwitch = 0;
      }
      return true;
    }

    if (_isTransitioning) {
      return false; // Don't switch during transitions
    }
    if (_isFramingMultipleBodies) {
      return false;
    }

    // Standard orbital logic - less aggressive switching than dynamic framing
    return _framesSinceLastSwitch >= minLockFrames;
  }

  /// Handle dedicated solar system tour with smooth transitions
  void _handleSolarSystemTour(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    final stars = bodies.where((b) => b.bodyType == BodyType.star).toList();
    final planets = bodies.where((b) => b.bodyType == BodyType.planet).toList();

    if (stars.isEmpty) {
      _updateIntelligentFraming(simulation, camera, deltaTime);
      return;
    }

    // Sort planets by distance from star
    if (planets.isNotEmpty) {
      planets.sort((a, b) {
        final distA = (a.position - stars[0].position).length;
        final distB = (b.position - stars[0].position).length;
        return distA.compareTo(distB);
      });
    }

    // Create target list: only planets for the cycling phase
    final planetsOnly = planets;

    // Tour phases: pan+zoom to sun (4s) → focus on sun (2s) → cycling through planets (5s each) → transition back to wide (3s) → restart cycle
    final currentTime = _totalFrames / 60.0;
    final panZoomDuration = 4.0; // Shortened from 8s to 4s for faster pan+zoom
    final sunFocusDuration = 2.0; // Reduced from 6s to 2s for shorter sun focus
    final targetDuration = 5.0;
    final wideTransitionDuration = 3.0;
    final totalCycleDuration =
        panZoomDuration + sunFocusDuration + (planetsOnly.length * targetDuration) + wideTransitionDuration;
    final cycleTime = currentTime % totalCycleDuration; // Restart the entire cycle

    double targetDistance;
    vm.Vector3 targetCenter;

    if (cycleTime < panZoomDuration) {
      // Phase 1: Smooth pan and zoom from wide view to sun over 8 seconds
      final zoomProgress = cycleTime / panZoomDuration;
      final t = _easeInOutQuad(zoomProgress);

      // Interpolate from wide view to sun focus
      final wideCenter = _calculateCenter(bodies);
      final wideDistance =
          _calculateSafeDistance(bodies, wideCenter, simulation.currentScenario) * 2.5; // Extra wide start
      final sunCenter = stars[0].position;
      final sunDistance = _calculateSafeDistance([stars[0]], sunCenter, simulation.currentScenario);

      targetCenter = _lerpVector3(wideCenter, sunCenter, t);
      targetDistance = _lerpDouble(wideDistance, sunDistance, t);
    } else if (cycleTime < panZoomDuration + sunFocusDuration) {
      // Phase 2: Stay focused on the sun with gentle movement, then start transitioning to Mercury
      final focusProgress = (cycleTime - panZoomDuration) / sunFocusDuration;

      if (focusProgress < 0.6) {
        // First 60% of phase: stay on sun
        final sunCenter = stars[0].position;
        final sunDistance = _calculateSafeDistance([stars[0]], sunCenter, simulation.currentScenario);

        // Add subtle movement while focused on sun
        final gentleMovement = math.sin(focusProgress * math.pi * 6) * 0.05; // Reduced movement

        targetCenter = sunCenter;
        targetDistance = sunDistance * (1.0 + gentleMovement);
      } else {
        // Last 40% of phase: start transitioning to Mercury
        final transitionProgress = (focusProgress - 0.6) / 0.4;
        final t = _easeInOutQuad(transitionProgress);

        final sunCenter = stars[0].position;
        final sunDistance = _calculateSafeDistance([stars[0]], sunCenter, simulation.currentScenario);

        // Get Mercury (first planet)
        final mercury = planetsOnly[0];
        final mercuryCenter = mercury.position;
        final mercuryDistance =
            _calculateSafeDistance([mercury], mercuryCenter, simulation.currentScenario) * 0.6; // Closer to planets

        // Smooth transition from sun to Mercury
        targetCenter = _lerpVector3(sunCenter, mercuryCenter, t);
        targetDistance = _lerpDouble(
          sunDistance,
          mercuryDistance * 1.2,
          t,
        ); // Start a bit further from Mercury but still closer
      }
    } else if (cycleTime < panZoomDuration + sunFocusDuration + (planetsOnly.length * targetDuration)) {
      // Phase 3: Continuous movement between planets - no pause at each target
      final targetCycleTime = cycleTime - panZoomDuration - sunFocusDuration;
      final targetIndex = (targetCycleTime / targetDuration).floor(); // Simplified - no modulo needed
      final timeInCurrentTarget =
          targetCycleTime - (targetIndex * targetDuration); // Time within current target's duration
      final transitionDuration = targetDuration; // Use full duration for smooth continuous movement

      // Ensure we don't go beyond the planet array bounds
      final safeTargetIndex = targetIndex.clamp(0, planetsOnly.length - 1);

      // Determine current and next targets
      final currentTargetBody = planetsOnly[safeTargetIndex];

      // Check if we're on the last planet and should transition to wide view instead of next planet
      final isLastPlanet = safeTargetIndex == planetsOnly.length - 1;

      if (isLastPlanet) {
        // Last planet (Neptune) - just stay focused on it for the full duration
        targetCenter = currentTargetBody.position;
        targetDistance =
            _calculateSafeDistance([currentTargetBody], targetCenter, simulation.currentScenario) *
            0.6; // Closer to planets
      } else {
        // Regular planet transition to next planet
        final nextTargetIndex = safeTargetIndex + 1; // No modulo since we handle last planet separately
        final nextTargetBody = planetsOnly[nextTargetIndex];

        // Always in transition - continuous movement to next target
        final transitionProgress = timeInCurrentTarget / transitionDuration;
        final t = _easeInOutQuad(transitionProgress);

        // Calculate current target parameters with enhanced safety
        final currentCenter = currentTargetBody.position;
        final currentDistance =
            _calculateTransitionSafeDistance([currentTargetBody], currentCenter, simulation.currentScenario) *
            0.8; // Conservative distance for planets

        // Calculate next target's orbital position and approach from behind
        final nextCenter = nextTargetBody.position;
        final nextDistance =
            _calculateTransitionSafeDistance([nextTargetBody], nextCenter, simulation.currentScenario) *
            0.8; // Conservative distance for planets

        if (nextTargetBody.bodyType == BodyType.planet && stars.isNotEmpty) {
          // For planets, create smooth orbital path transition using actual orbital mechanics
          final starPosition = stars[0].position;

          // Calculate the orbital positions relative to the star
          final currentToStar = currentCenter - starPosition;
          final nextToStar = nextCenter - starPosition;

          // Use actual orbital radii
          final currentOrbitRadius = currentToStar.length;
          final nextOrbitRadius = nextToStar.length;

          // Calculate angular positions to determine shortest path
          final currentAngle = math.atan2(currentToStar.z, currentToStar.x);
          final nextAngle = math.atan2(nextToStar.z, nextToStar.x);

          // Calculate the angular difference and determine shortest path
          var angleDiff = nextAngle - currentAngle;

          // Normalize angle difference to [-π, π]
          while (angleDiff > math.pi) {
            angleDiff -= 2 * math.pi;
          }
          while (angleDiff < -math.pi) {
            angleDiff += 2 * math.pi;
          }

          // If the angular difference is greater than π/2, consider using the opposite direction
          final useShortestPath = angleDiff.abs() > math.pi / 2;
          final shouldReverseDirection = useShortestPath && angleDiff.abs() > math.pi;

          // Create a smooth path that follows the optimal orbital flow
          final progressAlongOrbit = t;
          final smoothT = _easeInOutQuad(progressAlongOrbit);

          // Calculate optimal intermediate position that keeps target visible
          vm.Vector3 calculateVisibleIntermediatePosition(double progress) {
            // Always ensure we can see the target planet during transition
            final currentToTarget = nextCenter - currentCenter;
            final targetVisibilityOffset = currentToTarget.normalized() * (currentToTarget.length * 0.3);

            if (useShortestPath && shouldReverseDirection) {
              // Use the shorter arc in the opposite direction
              final reverseAngleDiff = angleDiff > 0 ? angleDiff - 2 * math.pi : angleDiff + 2 * math.pi;
              final intermediateAngle = currentAngle + reverseAngleDiff * progress;
              final avgRadius = (currentOrbitRadius + nextOrbitRadius) * 0.5;

              final basePosition =
                  starPosition +
                  vm.Vector3(avgRadius * math.cos(intermediateAngle), 0.0, avgRadius * math.sin(intermediateAngle));

              // Adjust position to keep target in view
              return basePosition + targetVisibilityOffset * (1.0 - progress);
            } else {
              // Use direct path with target visibility consideration
              final directPath = _lerpVector3(currentCenter, nextCenter, progress);

              // Add orbital arc for more natural movement while keeping target visible
              if (currentOrbitRadius > 0 && nextOrbitRadius > 0) {
                final avgRadius = (currentOrbitRadius + nextOrbitRadius) * 0.5;
                final arcHeight = avgRadius * 0.1 * math.sin(progress * math.pi); // Reduced arc
                final toDirectPath = directPath - starPosition;
                final arcOffset = toDirectPath.normalized() * arcHeight;
                return directPath + arcOffset + targetVisibilityOffset * (1.0 - progress * 0.5);
              }

              return directPath + targetVisibilityOffset * (1.0 - progress);
            }
          }

          // Calculate distance that ensures both planets remain visible
          final maxPlanetDistance = (currentCenter - nextCenter).length;
          final targetVisibleDistance = math.max(
            maxPlanetDistance * 1.2, // Ensure both planets fit in frame
            math.max(currentDistance, nextDistance) * 1.5, // Minimum safe distance
          );

          if (smoothT < 0.2) {
            // First 20%: Pull back to get both planets in view, with emphasis on target
            final lookAheadT = smoothT / 0.2;
            final intermediatePos = calculateVisibleIntermediatePosition(0.3); // Look ahead position
            targetCenter = _lerpVector3(currentCenter, intermediatePos, _easeInOutQuad(lookAheadT));
            targetDistance = _lerpDouble(currentDistance, targetVisibleDistance, _easeInOutQuad(lookAheadT));
          } else if (smoothT < 0.8) {
            // Middle 60%: Smoothly transition along path while keeping target visible
            final transitionT = (smoothT - 0.2) / 0.6;
            final intermediatePos = calculateVisibleIntermediatePosition(transitionT);

            // Ensure we're always oriented towards the target
            final targetDirection = (nextCenter - intermediatePos).normalized();
            final adjustedPos = intermediatePos + targetDirection * maxPlanetDistance * 0.1;

            targetCenter = adjustedPos;
            targetDistance = targetVisibleDistance * (1.0 + math.sin(transitionT * math.pi) * 0.1);
          } else {
            // Last 20%: Focus smoothly on the target planet
            final focusT = (smoothT - 0.8) / 0.2;
            final intermediatePos = calculateVisibleIntermediatePosition(0.9);
            targetCenter = _lerpVector3(intermediatePos, nextCenter, _easeInOutQuad(focusT));
            targetDistance = _lerpDouble(targetVisibleDistance, nextDistance, _easeInOutQuad(focusT));
          }
        } else {
          // For non-planets (like stars), use improved interpolation with look-ahead
          final smoothT = _easeInOutQuad(t);

          // Calculate a position that can see both current and next targets
          final bothTargetsCenter = (currentCenter + nextCenter) * 0.5;
          final bothTargetsDistance = math.max(
            (currentCenter - nextCenter).length * 0.6,
            math.max(currentDistance, nextDistance) * 1.1,
          );

          if (smoothT < 0.2) {
            // First 20%: Move to see both targets
            final lookAheadT = smoothT / 0.2;
            targetCenter = _lerpVector3(currentCenter, bothTargetsCenter, lookAheadT);
            targetDistance = _lerpDouble(currentDistance, bothTargetsDistance, lookAheadT);
          } else if (smoothT < 0.8) {
            // Middle 60%: Smooth transition while maintaining view
            final transitionT = (smoothT - 0.2) / 0.6;
            targetCenter = _lerpVector3(bothTargetsCenter, bothTargetsCenter, transitionT);
            targetDistance = bothTargetsDistance;
          } else {
            // Last 20%: Focus on target
            final focusT = (smoothT - 0.8) / 0.2;
            targetCenter = _lerpVector3(bothTargetsCenter, nextCenter, focusT);
            targetDistance = _lerpDouble(bothTargetsDistance, nextDistance, focusT);
          }
        }
      }
    } else {
      // Phase 4: Transition back to wide view to restart the cycle
      final wideTransitionTime = cycleTime - panZoomDuration - sunFocusDuration - (planetsOnly.length * targetDuration);
      final transitionProgress = wideTransitionTime / wideTransitionDuration;
      final t = _easeInOutQuad(transitionProgress);

      // Get the last planet position and transition to wide view
      final lastPlanet = planetsOnly.last;
      final lastPlanetCenter = lastPlanet.position;
      final lastPlanetDistance = _calculateSafeDistance([lastPlanet], lastPlanetCenter, simulation.currentScenario);

      // Transition to wide view
      final wideCenter = _calculateCenter(bodies);
      final wideDistance = _calculateSafeDistance(bodies, wideCenter, simulation.currentScenario) * 2.5;

      targetCenter = _lerpVector3(lastPlanetCenter, wideCenter, t);
      targetDistance = _lerpDouble(lastPlanetDistance, wideDistance, t);
    }

    // Enhanced oscillation with proper cycling - slowed down
    _orbitTime += deltaTime * 0.3; // Slower orbit speed
    _verticalOscillation += deltaTime * 0.4; // Slower vertical movement

    // Determine system/orbital direction and counter-rotate camera
    double cameraYaw = _orbitTime;

    if (stars.isNotEmpty && planets.isNotEmpty) {
      // Calculate overall system rotation direction
      // Use the most massive planet or first planet as reference
      final referencePlanet = planets.reduce((a, b) => a.mass > b.mass ? a : b);
      final toStar = stars[0].position - referencePlanet.position;
      final velocity = referencePlanet.velocity;

      // Cross product to determine if system rotates clockwise or counter-clockwise
      // In 2D: cross product z-component = x1*y2 - y1*x2
      final crossZ = toStar.x * velocity.y - toStar.y * velocity.x;

      // If cross product is positive, system rotates counter-clockwise, so camera should go clockwise (negative)
      final systemOrbitDirection = crossZ > 0 ? -1.0 : 1.0;
      cameraYaw = _orbitTime * systemOrbitDirection;
    }

    // Fix oscillation to properly cycle - use abs to prevent getting stuck at minimum
    final pitchBase = 0.25; // Base height above plane
    final pitchRange = 0.2; // Oscillation range
    final pitchOscillation =
        pitchBase + math.sin(_verticalOscillation).abs() * pitchRange; // Always positive oscillation

    final distanceOscillation = 1.0 + math.sin(_orbitTime * 0.4) * 0.25; // Slower and less distance variation
    final yawVariation = cameraYaw + math.sin(_orbitTime * 0.2) * 0.15; // Slower yaw variation

    camera.setCameraParameters(
      yaw: yawVariation,
      pitch: pitchOscillation, // No clamp needed since it's always positive
      roll: math.sin(_orbitTime * 0.3) * 0.03, // Slower and subtler roll
      distance: targetDistance * distanceOscillation,
      target: targetCenter,
    );
  }

  /// Intelligently frame multiple bodies with stable camera movement (no aggressive roll)
  void _updateIntelligentFramingStable(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    if (bodies.length < 2) {
      return;
    }

    // Find all interesting body pairs and check for conflicts
    final allInterestingPairs = _findAllInterestingPairs(bodies);
    final topPair = _getBestTargetBodies(bodies); // Use queued target if available

    // Check if there are multiple competing interesting pairs
    final shouldFrameMultiple = _shouldFrameMultipleBodies(allInterestingPairs, topPair);

    if (shouldFrameMultiple && !_isFramingMultipleBodies) {
      // Start framing multiple bodies
      _isFramingMultipleBodies = true;
      _multiBodyFramingTime = 0.0;
      _allInterestingBodies = _getUniqueInterestingBodies(allInterestingPairs);

      // Start transition from current pair to all interesting bodies
      if (_currentFramedBodies.isNotEmpty) {
        _isTransitioning = true;
        _transitionProgress = 0.0;

        vm.Vector3 currentCenter = vm.Vector3.zero();
        for (final body in _currentFramedBodies) {
          currentCenter += body.position;
        }
        currentCenter /= _currentFramedBodies.length.toDouble();
        _previousCenter = currentCenter;

        _previousDistance = _calculateSafeDistance(_currentFramedBodies, currentCenter, simulation.currentScenario);
      } else {
        // Initialize from current camera state
        _isTransitioning = true;
        _transitionProgress = 0.0;
        _previousCenter = camera.target.clone();
        _previousDistance = camera.distance;
        _currentCameraYaw = camera.yaw;
        _currentCameraPitch = camera.pitch;
        _currentCameraRoll = camera.roll;
      }
    } else if (!shouldFrameMultiple && _isFramingMultipleBodies) {
      // Check if we've been framing multiple bodies long enough to make a decision
      if (_multiBodyFramingTime > 8.0) {
        // Longer decision time (8 seconds)
        _isFramingMultipleBodies = false;

        // Smoothly transition back to the best pair
        if (_shouldUpdateFramedBodies(topPair, simulation.currentScenario)) {
          _isTransitioning = true;
          _transitionProgress = 0.0;

          // Store current multi-body state for transition
          vm.Vector3 currentCenter = vm.Vector3.zero();
          for (final body in _allInterestingBodies) {
            currentCenter += body.position;
          }
          currentCenter /= _allInterestingBodies.length.toDouble();
          _previousCenter = currentCenter;

          _previousDistance = _calculateSafeDistance(_allInterestingBodies, currentCenter, simulation.currentScenario);

          // Determine which target to switch to (queued target takes priority)
          final targetBodies = _hasQueuedTarget && _nextTargetBodies != null ? _nextTargetBodies! : topPair;
          _targetFramedBodies = targetBodies;

          // Clear queued target since we're switching
          _hasQueuedTarget = false;
          _nextTargetBodies = null;
        }
      }
    }

    // Update timing
    _multiBodyFramingTime += deltaTime;

    // Check if we should switch to a new pair when not framing multiple bodies
    if (!_isFramingMultipleBodies && _shouldUpdateFramedBodies(topPair, simulation.currentScenario)) {
      _isTransitioning = true;
      _transitionProgress = 0.0;

      // Store current camera state
      _previousCenter = camera.target.clone();
      _previousDistance = camera.distance;
      _currentCameraYaw = camera.yaw;
      _currentCameraPitch = camera.pitch;
      _currentCameraRoll = camera.roll;

      _targetFramedBodies = topPair;
      _currentFramedBodies = List.from(topPair);
    }

    // Handle transitions with stable movement
    if (_isTransitioning) {
      _transitionProgress += deltaTime * 0.5; // Slower transitions for stability
      if (_transitionProgress >= 1.0) {
        _transitionProgress = 1.0;
        _isTransitioning = false;
      }
    }

    // Update camera parameters based on current state
    _updateStableCameraParameters(simulation, camera, deltaTime);
  }

  /// Update stable camera parameters without aggressive roll movements
  void _updateStableCameraParameters(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;

    final targetBodies = _isFramingMultipleBodies ? _allInterestingBodies : _currentFramedBodies;

    if (targetBodies.isEmpty) {
      targetBodies.addAll(bodies.take(2));
    }

    // Calculate center of target bodies
    vm.Vector3 targetCenter = vm.Vector3.zero();
    for (final body in targetBodies) {
      targetCenter += body.position;
    }
    targetCenter /= targetBodies.length.toDouble();

    // Calculate optimal distance for framing
    double targetDistance = _calculateSafeDistance(targetBodies, targetCenter, simulation.currentScenario);

    // Stable camera angles with minimal movement
    double yaw = 0.0;
    double pitch = 0.0;
    double roll = 0.0;

    // Only use stable oscillations during transitions
    if (_isTransitioning && _transitionProgress < 1.0) {
      final t = _transitionProgress;
      targetCenter = _previousCenter + (targetCenter - _previousCenter) * t;
      targetDistance = _previousDistance + (targetDistance - _previousDistance) * t;

      // Gentle angle interpolation - but NO ROLL for stable framing
      yaw = _currentCameraYaw * (1.0 - t);
      pitch = _currentCameraPitch * (1.0 - t);
      roll = 0.0; // Always zero roll for stable framing
    } else {
      // Stable position with minimal dynamic movement
      _orbitTime += deltaTime * 0.2; // Slower time progression

      // Very subtle oscillations for natural movement
      yaw = math.sin(_orbitTime * 0.3) * 0.02; // Minimal yaw variation
      pitch = math.sin(_orbitTime * 0.4).abs() * 0.15 + 0.05; // Gentle pitch
      roll = 0.0; // No roll for stable framing
    }

    camera.setCameraParameters(yaw: yaw, pitch: pitch, roll: roll, distance: targetDistance, target: targetCenter);
  }

  /// Intelligently frame multiple bodies with dynamic movement
  void _updateIntelligentFraming(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    if (bodies.length < 2) {
      return;
    }

    // Find all interesting body pairs and check for conflicts
    final allInterestingPairs = _findAllInterestingPairs(bodies);
    final topPair = _getBestTargetBodies(bodies); // Use queued target if available

    // Check if there are multiple competing interesting pairs
    final shouldFrameMultiple = _shouldFrameMultipleBodies(allInterestingPairs, topPair);

    if (shouldFrameMultiple && !_isFramingMultipleBodies) {
      // Start framing multiple bodies
      _isFramingMultipleBodies = true;
      _multiBodyFramingTime = 0.0;
      _allInterestingBodies = _getUniqueInterestingBodies(allInterestingPairs);

      // Start transition from current pair to all interesting bodies
      if (_currentFramedBodies.isNotEmpty) {
        _isTransitioning = true;
        _transitionProgress = 0.0;

        vm.Vector3 currentCenter = vm.Vector3.zero();
        for (final body in _currentFramedBodies) {
          currentCenter += body.position;
        }
        currentCenter /= _currentFramedBodies.length.toDouble();
        _previousCenter = currentCenter;

        _previousDistance = _calculateSafeDistance(_currentFramedBodies, currentCenter, simulation.currentScenario);
      } else {
        // Initialize from current camera state
        _isTransitioning = true;
        _transitionProgress = 0.0;
        _previousCenter = camera.target.clone();
        _previousDistance = camera.distance;
        _currentCameraYaw = camera.yaw;
        _currentCameraPitch = camera.pitch;
        _currentCameraRoll = camera.roll;
      }
    } else if (!shouldFrameMultiple && _isFramingMultipleBodies) {
      // Check if we've been framing multiple bodies long enough to make a decision
      if (_multiBodyFramingTime > 8.0) {
        // Longer decision time (8 seconds)
        _isFramingMultipleBodies = false;

        // Smoothly transition back to the best pair
        if (_shouldUpdateFramedBodies(topPair, simulation.currentScenario)) {
          _isTransitioning = true;
          _transitionProgress = 0.0;

          // Store current multi-body state for transition
          vm.Vector3 currentCenter = vm.Vector3.zero();
          for (final body in _allInterestingBodies) {
            currentCenter += body.position;
          }
          currentCenter /= _allInterestingBodies.length.toDouble();
          _previousCenter = currentCenter;

          _previousDistance = _calculateSafeDistance(_allInterestingBodies, currentCenter, simulation.currentScenario);

          // Determine which target to switch to (queued target takes priority)
          final targetBodies = _hasQueuedTarget && _nextTargetBodies != null ? _nextTargetBodies! : topPair;
          _targetFramedBodies = targetBodies;

          // Clear queued target since we're switching
          _hasQueuedTarget = false;
          _nextTargetBodies = null;
        }
      }
    } else if (!_isFramingMultipleBodies) {
      // Normal pair-based framing with target locking
      // Check if we should switch targets based on current framed bodies vs new candidates
      final candidateBodies = _findMostInterestingBodies(bodies, simulation.currentScenario);

      if (_shouldUpdateFramedBodies(candidateBodies, simulation.currentScenario)) {
        // Determine which target to switch to BEFORE starting transition
        final targetBodies = _hasQueuedTarget && _nextTargetBodies != null ? _nextTargetBodies! : candidateBodies;

        // Store the old framed bodies for transition calculations
        final oldFramedBodies = List<Body>.from(_currentFramedBodies);

        // Update current target immediately to prevent rapid switching
        _currentFramedBodies = List.from(targetBodies);

        _isTransitioning = true;
        _transitionProgress = 0.0;
        _targetFramedBodies = targetBodies; // Set the target we're transitioning TO

        // Clear queued target since we're using it
        if (_hasQueuedTarget) {
          _hasQueuedTarget = false;
          _nextTargetBodies = null;
        }

        if (oldFramedBodies.isNotEmpty) {
          vm.Vector3 currentCenter = vm.Vector3.zero();
          for (final body in oldFramedBodies) {
            currentCenter += body.position;
          }
          currentCenter /= oldFramedBodies.length.toDouble();
          _previousCenter = currentCenter;

          _previousDistance = _calculateSafeDistance(oldFramedBodies, currentCenter, simulation.currentScenario);

          // Store current camera angles for smooth transition
          _currentCameraYaw = _currentCameraYaw;
          _currentCameraPitch = _currentCameraPitch;
          _currentCameraRoll = _currentCameraRoll;
        } else {
          // Initialize from current camera state
          _previousCenter = camera.target.clone();
          _previousDistance = camera.distance;
          _currentCameraYaw = camera.yaw;
          _currentCameraPitch = camera.pitch;
          _currentCameraRoll = camera.roll;
        }

        // DON'T update _currentFramedBodies yet - wait for transition to complete

        // Clear queued target since we're switching to it
        _hasQueuedTarget = false;
        _nextTargetBodies = null;
      }
    }

    if (_isFramingMultipleBodies) {
      _multiBodyFramingTime += deltaTime;
    }

    // Handle transitions
    if (_isTransitioning) {
      _transitionProgress += deltaTime * 0.25; // Slower 4 second transitions for more graceful movement
      if (_transitionProgress >= 1.0) {
        _isTransitioning = false;
        _transitionProgress = 1.0;

        // Complete the transition - switch to the target bodies
        if (_targetFramedBodies.isNotEmpty) {
          _currentFramedBodies = _targetFramedBodies;
          _targetFramedBodies = []; // Clear target
        }
      }
    }

    // Update camera based on current mode
    List<Body> bodiesToFrame;

    if (_isFramingMultipleBodies) {
      bodiesToFrame = _allInterestingBodies;
    } else if (_isTransitioning && _targetFramedBodies.isNotEmpty) {
      // During transition, use the target bodies for camera calculation
      bodiesToFrame = _targetFramedBodies;
    } else {
      bodiesToFrame = _currentFramedBodies;
    }

    // Only update camera if we have bodies to frame and we're not in an inconsistent state
    if (bodiesToFrame.isNotEmpty) {
      _updateCameraForBodies(bodiesToFrame, camera, deltaTime, simulation.currentScenario);
    }
  }

  /// Find the most interesting pair of bodies to focus on with hierarchical targeting
  List<Body> _findMostInterestingBodies(List<Body> bodies, ScenarioType scenario) {
    // For random scenarios, filter out ejected bodies to focus on the main action
    List<Body> filteredBodies = bodies;
    if (bodies.length > 2) {
      // For scenarios with more than 2 bodies, check for ejections
      filteredBodies = _filterEjectedBodies(bodies, scenario);
    }

    // For star-containing scenarios, implement cinematic sequencing
    final hasStars = filteredBodies.any((body) => body.bodyType == BodyType.star);
    if (hasStars) {
      return _findCinematicTargets(filteredBodies, scenario);
    }

    // For non-star scenarios with 2 bodies, return them directly
    if (filteredBodies.length == 2) {
      return filteredBodies;
    }

    // Fallback to standard scoring for non-star scenarios with 3+ bodies
    // Use specialized random scenario scoring for more dramatic targeting
    if (scenario == ScenarioType.random) {
      return _findMostDramaticPair(filteredBodies);
    }
    return _findBestScoredPair(filteredBodies);
  }

  /// Implement solar system tour: zoom to center, visit each planet, zoom out
  List<Body> _findSolarSystemTargets(List<Body> bodies) {
    final stars = bodies.where((b) => b.bodyType == BodyType.star).toList();
    final planets = bodies.where((b) => b.bodyType == BodyType.planet).toList();

    if (stars.isEmpty) {
      return _findBestScoredPair(bodies);
    }

    // Sort planets by distance from star for systematic tour
    if (planets.isNotEmpty && stars.isNotEmpty) {
      planets.sort((a, b) {
        final distA = (a.position - stars[0].position).length;
        final distB = (b.position - stars[0].position).length;
        return distA.compareTo(distB);
      });
    }

    // SIMPLE tour timing - 8 seconds per planet
    final currentTime = _totalFrames / 60.0;
    final phaseDuration = 8.0;
    final totalPhases = planets.length + 1; // planets + whole system
    final currentPhase = ((currentTime / phaseDuration) % totalPhases).floor();

    if (currentPhase < planets.length) {
      // Visit each planet individually
      return [planets[currentPhase]];
    }

    // Final phase: Show whole system
    return [stars[0]]; // Focus back on star for wide view
  }

  /// Filter out ejected bodies that are too far from the main action
  List<Body> _filterEjectedBodies(List<Body> bodies, ScenarioType scenario) {
    if (bodies.length <= 2) {
      return bodies;
    }

    // Calculate center of mass for the system
    vm.Vector3 centerOfMass = vm.Vector3.zero();
    double totalMass = 0.0;
    for (final body in bodies) {
      centerOfMass += body.position * body.mass;
      totalMass += body.mass;
    }
    centerOfMass /= totalMass;

    // Calculate distances from center of mass
    final bodyDistances = <MapEntry<Body, double>>[];
    for (final body in bodies) {
      final distance = (body.position - centerOfMass).length;
      bodyDistances.add(MapEntry(body, distance));
    }

    // Sort by distance
    bodyDistances.sort((a, b) => a.value.compareTo(b.value));

    // Calculate median distance to identify outliers
    final medianDistance = bodyDistances[bodyDistances.length ~/ 2].value;

    // Check if all bodies are widely separated (all ejected scenario)
    final minDistance = bodyDistances[0].value;
    final maxDistance = bodyDistances.last.value;
    final separationRatio = maxDistance / (minDistance + 1.0); // +1 to avoid division by zero

    // If separation ratio is very high, all bodies are likely ejected
    if (separationRatio > 2.5 && bodies.length > 2) {
      // Much more aggressive threshold (was 5.0) - detect ejections earlier
      // Find the closest pair among all bodies for focused tracking
      double closestPairDistance = double.infinity;
      List<Body> closestPair = [];

      for (int i = 0; i < bodies.length; i++) {
        for (int j = i + 1; j < bodies.length; j++) {
          final distance = (bodies[i].position - bodies[j].position).length;
          if (distance < closestPairDistance) {
            closestPairDistance = distance;
            closestPair = [bodies[i], bodies[j]];
          }
        }
      }

      // Always focus on the closest pair - even if they're not super close
      if (closestPair.length == 2) {
        return closestPair; // Always focus on the closest pair for random scenarios
      }
    }

    // More aggressive normal filtering for active interactions
    // Filter out bodies that are farther than 1.2x median distance (was 1.5x)
    final ejectionThreshold = medianDistance * 1.2; // More aggressive ejection filtering
    final filteredBodies = <Body>[];

    for (final entry in bodyDistances) {
      if (entry.value <= ejectionThreshold) {
        filteredBodies.add(entry.key);
      }
    }

    // For random scenarios, be extremely aggressive about focusing on close pairs
    if (scenario == ScenarioType.random && bodies.length > 2) {
      // Find the two closest bodies using efficient O(n²) algorithm without copying
      double closestPairDistance = double.infinity;
      Body? closestBody1, closestBody2;

      for (int i = 0; i < bodies.length; i++) {
        for (int j = i + 1; j < bodies.length; j++) {
          final distance = (bodies[i].position - bodies[j].position).length;
          if (distance < closestPairDistance) {
            closestPairDistance = distance;
            closestBody1 = bodies[i];
            closestBody2 = bodies[j];
          }
        }
      }

      if (closestBody1 != null && closestBody2 != null) {
        // Find the distance from closest pair to the nearest third body
        double thirdBodyDistance = double.infinity;
        for (final body in bodies) {
          if (body != closestBody1 && body != closestBody2) {
            final distToFirst = (body.position - closestBody1.position).length;
            final distToSecond = (body.position - closestBody2.position).length;
            final minDist = math.min(distToFirst, distToSecond);
            if (minDist < thirdBodyDistance) {
              thirdBodyDistance = minDist;
            }
          }
        }

        // If the closest pair is much closer to each other than to the third body, focus on them
        if (thirdBodyDistance > closestPairDistance * 2.0) {
          return [closestBody1, closestBody2];
        }
      }
    }

    // For random scenarios, prefer just the 2 closest bodies for tight action
    if (filteredBodies.length < 2 && bodies.length >= 2) {
      // Always use the 2 closest bodies for maximum action focus
      return [bodyDistances[0].key, bodyDistances[1].key];
    }

    return filteredBodies.isNotEmpty ? filteredBodies : bodies;
  }

  /// Implement cinematic targeting that showcases stars first, then planets/moons
  List<Body> _findCinematicTargets(List<Body> bodies, ScenarioType scenario) {
    final stars = bodies.where((b) => b.bodyType == BodyType.star).toList();
    final planets = bodies.where((b) => b.bodyType == BodyType.planet).toList();
    final moons = bodies.where((b) => b.bodyType == BodyType.moon).toList();

    // Solar system gets special tour treatment
    if (scenario == ScenarioType.solarSystem && planets.length >= 2) {
      return _findSolarSystemTargets(bodies);
    }

    // Other star scenarios use the 3-phase system
    // Phase 1: Focus on stars for dramatic wide shots (longer duration)
    // Phase 2: Transition to star-planet interactions
    // Phase 3: Show planet-moon details (shorter duration)

    final currentTime = _totalFrames / 60.0; // Convert frames to approximate seconds
    final phaseDuration = 30.0; // 30 seconds per phase (increased from 20)
    final currentPhase = ((currentTime / phaseDuration) % 3).floor();

    // Remove debug logging

    switch (currentPhase) {
      case 0: // Phase 1: Star focus (0-30s of each cycle)
        if (stars.length >= 2) {
          // Binary stars - most dramatic
          return [stars[0], stars[1]];
        } else if (stars.isNotEmpty && planets.isNotEmpty) {
          // Star-planet for scale and context
          return [stars[0], planets[0]];
        }
        break;

      case 1: // Phase 2: Star-planet interactions (30-60s of each cycle)
        if (stars.isNotEmpty && planets.isNotEmpty) {
          return [stars[0], planets[0]];
        } else if (stars.length >= 2) {
          return [stars[0], stars[1]];
        }
        break;

      case 2: // Phase 3: Planet-moon details (60-90s of each cycle)
        if (planets.isNotEmpty && moons.isNotEmpty) {
          // Focus on planet first, moon second - this ensures planet is primary target
          return [planets[0], moons[0]];
        } else if (planets.length >= 2) {
          return [planets[0], planets[1]];
        } else if (stars.isNotEmpty && planets.isNotEmpty) {
          return [stars[0], planets[0]];
        }
        break;
    }

    // Fallback to best scored pair if phases don't match available bodies
    return _findBestScoredPair(bodies);
  }

  /// Standard scoring-based pair selection (original logic)
  List<Body> _findBestScoredPair(List<Body> bodies) {
    // Score body pairs based on multiple factors
    double bestScore = 0.0;
    List<Body> bestPair = [bodies[0], bodies[1]];

    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final body1 = bodies[i];
        final body2 = bodies[j];
        double score = _scoreBodiesPair(body1, body2, bodies);

        // Add "stickiness" bonus if this is the current pair being tracked
        if (_currentFramedBodies.isNotEmpty &&
            _currentFramedBodies.length == 2 &&
            ((_currentFramedBodies.contains(body1) && _currentFramedBodies.contains(body2)))) {
          score *= 1.3; // 30% bonus for currently tracked pair (hysteresis)
        }

        if (score > bestScore) {
          bestScore = score;
          bestPair = [body1, body2];
        }
      }
    }

    return bestPair;
  }

  /// Score a pair of bodies based on their interaction interest
  double _scoreBodiesPair(Body body1, Body body2, List<Body> allBodies) {
    double score = 0.0;

    // Count body types for stability scoring
    double stabilityBonus = 0.0;
    int starCount = 0;
    int planetCount = 0;
    int moonCount = 0;

    if (body1.bodyType == BodyType.star) {
      starCount++;
    }
    if (body2.bodyType == BodyType.star) {
      starCount++;
    }
    if (body1.bodyType == BodyType.planet) {
      planetCount++;
    }
    if (body2.bodyType == BodyType.planet) {
      planetCount++;
    }
    if (body1.bodyType == BodyType.moon) {
      moonCount++;
    }
    if (body2.bodyType == BodyType.moon) {
      moonCount++;
    }

    // Prioritize stable, important gravitational relationships
    if (starCount == 2) {
      stabilityBonus = 6.0; // Binary stars - excellent stability and drama
    } else if (starCount == 1 && planetCount == 1) {
      stabilityBonus = 5.5; // Star-planet - primary orbital relationship
    } else if (starCount == 1 && moonCount == 0) {
      stabilityBonus = 4.0; // Star with asteroid/other - good stability
    } else if (planetCount == 2) {
      stabilityBonus = 3.0; // Two planets - good stability
    } else if (planetCount == 1 && moonCount == 0) {
      stabilityBonus = 2.0; // Planet with asteroid/other - decent stability
    } else if (starCount == 1 && moonCount == 1) {
      stabilityBonus = 1.5; // Star-moon - acceptable but less ideal
    } else if (planetCount == 1 && moonCount == 1) {
      stabilityBonus = 1.0; // Planet-moon - acceptable but not ideal
    } else if (moonCount >= 1) {
      stabilityBonus = -2.0; // Discourage moon-moon or moon-only pairs
    }

    score += stabilityBonus;

    // Distance factor - closer bodies are more interesting
    final distance = (body1.position - body2.position).length;
    final maxDistance = _getMaxDistance(allBodies);
    final distanceScore = 1.0 - (distance / maxDistance);
    score += distanceScore * 2.0;

    // Relative velocity - bodies moving relative to each other are interesting
    final relativeVelocity = (body1.velocity - body2.velocity).length;
    score += math.min(relativeVelocity * 0.1, 1.0);

    // Mass factor - more massive bodies are generally more interesting
    final massScore = (body1.mass + body2.mass) / _getTotalMass(allBodies);
    score += massScore;

    return score;
  }

  /// Find the most dramatic pair for random scenarios - prioritizes chaos and close encounters
  List<Body> _findMostDramaticPair(List<Body> bodies) {
    if (bodies.length < 2) {
      return bodies;
    }

    double bestScore = 0.0;
    List<Body> bestPair = [bodies[0], bodies[1]];

    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final body1 = bodies[i];
        final body2 = bodies[j];
        double score = _scoreDramaticInteraction(body1, body2, bodies);

        // Add "stickiness" bonus if this is the current pair being tracked
        if (_currentFramedBodies.isNotEmpty &&
            _currentFramedBodies.length == 2 &&
            _isSameBodiesPair(body1, body2, _currentFramedBodies[0], _currentFramedBodies[1])) {
          score *= 2.5; // Much stronger stickiness for dramatic moments (was 1.4)

          // Extra stickiness for very close interactions
          final currentDistance = (body1.position - body2.position).length;
          if (currentDistance < 10.0) {
            score *= 1.5; // Additional bonus for staying with close encounters
          }
        }

        if (score > bestScore) {
          bestScore = score;
          // Ensure consistent ordering to prevent body identity swapping
          // Order by mass (heavier body first) to maintain stable identity
          if (body1.mass >= body2.mass) {
            bestPair = [body1, body2];
          } else {
            bestPair = [body2, body1];
          }
        }
      }
    }

    return bestPair;
  }

  /// Score dramatic interactions for random scenarios
  double _scoreDramaticInteraction(Body body1, Body body2, List<Body> allBodies) {
    double score = 0.0;

    // Distance factor - Use smoother function to avoid dramatic score swings
    final distance = (body1.position - body2.position).length;
    // Use a more stable logarithmic-based scoring to prevent sudden jumps
    final stabilizedDistance = math.max(1.0, distance); // Prevent division by zero
    final closeEncounterBonus =
        RenderingConstants.dramaticScoringCloseEncounterBase /
        (1.0 + stabilizedDistance * RenderingConstants.dramaticScoringDistanceFalloff); // More gradual falloff
    score += closeEncounterBonus;

    // Relative velocity - high speed interactions are dramatic
    final relativeVelocity = (body1.velocity - body2.velocity).length;
    score += relativeVelocity * RenderingConstants.dramaticScoringVelocityMultiplier; // Much higher weight for speed

    // Combined mass for impact potential
    final combinedMass = body1.mass + body2.mass;
    score +=
        combinedMass * RenderingConstants.dramaticScoringMassMultiplier; // Reduced mass importance vs proximity/speed

    // Acceleration toward each other (potential collision or close flyby)
    final relativePosition = body2.position - body1.position;
    final relativeVelocityVector = body2.velocity - body1.velocity;

    // Dot product to see if they're moving toward each other
    final approachingFactor = relativePosition.dot(relativeVelocityVector);
    if (approachingFactor < 0) {
      // Negative means approaching - HUGE bonus for incoming collisions
      score +=
          (-approachingFactor) *
          RenderingConstants.dramaticScoringApproachingMultiplier; // Massive bonus for approaching bodies
    }

    // Imminent collision detection - extremely close and approaching
    if (distance < RenderingConstants.dramaticScoringCollisionDistance && approachingFactor < 0) {
      score += RenderingConstants.dramaticScoringCollisionBonus; // Massive bonus for imminent collisions
    }

    // Orbital instability bonus - erratic movement patterns
    final body1Speed = body1.velocity.length;
    final body2Speed = body2.velocity.length;
    final speedDifference = (body1Speed - body2Speed).abs();
    score +=
        speedDifference * RenderingConstants.dramaticScoringInstabilityMultiplier; // Higher bonus for chaotic motion

    return score;
  }

  /// Check if we should update the currently framed bodies with target locking
  bool _shouldUpdateFramedBodies(List<Body> candidateBodies, ScenarioType scenario) {
    // Get scenario-specific parameters
    final cameraParams = _getScenarioCameraParameters(scenario);
    final minLockFrames = cameraParams.targetLockFrames;

    if (_currentFramedBodies.isEmpty) {
      if (candidateBodies.isNotEmpty) {
        _framesSinceLastSwitch = 0; // Reset frame counter
      }
      return true;
    }

    // Special handling for random scenarios during transitions
    if (scenario == ScenarioType.random && _isTransitioning && candidateBodies.length >= 2) {
      // Check if there's a highly dramatic interaction happening that we should interrupt for
      final candidateScore = _scoreDramaticInteraction(candidateBodies[0], candidateBodies[1], candidateBodies);
      final candidateDistance = (candidateBodies[0].position - candidateBodies[1].position).length;
      final isEmergentDrama = candidateDistance < 5.0 || candidateScore > 80.0; // Very high drama threshold

      if (isEmergentDrama) {
        // Force transition to complete immediately for dramatic moments
        _transitionProgress = 1.0;
        _isTransitioning = false;
        return true; // Allow immediate switch to dramatic interaction
      }
    }

    if (_isTransitioning) {
      return false; // Don't switch during transitions (except random drama above)
    }
    if (_isFramingMultipleBodies) {
      return false; // Don't switch during multi-body framing
    }

    // Special stability check for dynamic framing - prevent rapid switching during plane crossings
    if (scenario == ScenarioType.random && _currentFramedBodies.length == 2 && candidateBodies.length >= 2) {
      // Check if the candidate bodies are the same as current (using robust comparison)
      if (_isSameBodiesPair(candidateBodies[0], candidateBodies[1], _currentFramedBodies[0], _currentFramedBodies[1])) {
        // Same bodies - no need to switch
        return false;
      }

      // For dynamic framing, require longer lock time to prevent trail confusion during plane crossings
      final dynamicFramingMinLock = minLockFrames * 2; // Double the minimum lock time
      if (_framesSinceLastSwitch < dynamicFramingMinLock) {
        return false; // Stay locked longer for dynamic framing stability
      }
    }

    // Special handling for random scenarios - prioritize dramatic interactions
    if (scenario == ScenarioType.random && _currentFramedBodies.length == 2 && candidateBodies.length >= 2) {
      final currentScore = _scoreDramaticInteraction(_currentFramedBodies[0], _currentFramedBodies[1], candidateBodies);
      final candidateScore = _scoreDramaticInteraction(candidateBodies[0], candidateBodies[1], candidateBodies);

      // Check if current interaction is highly dramatic (close encounter or collision)
      final currentDistance = (_currentFramedBodies[0].position - _currentFramedBodies[1].position).length;
      final isHighlyDramatic = currentDistance < 8.0 || currentScore > 50.0;

      if (isHighlyDramatic) {
        // During highly dramatic moments, require MUCH higher score to switch
        final requiredImprovement = candidateScore > currentScore * 3.0; // Need 3x better score
        if (!requiredImprovement && _framesSinceLastSwitch < minLockFrames * 2) {
          return false; // Stay locked on dramatic moment longer
        }
      }

      // For less dramatic moments, use standard threshold but still be selective
      if (candidateScore <= currentScore * 1.8) {
        // Need 80% better score
        return false;
      }
    }

    // For star scenarios, apply cinematic phase targeting with normal locking
    final hasStars = candidateBodies.any((body) => body.bodyType == BodyType.star);
    if (hasStars) {
      // Calculate current phase and allow override every phase change
      final currentTime = _totalFrames / 60.0;
      final phaseDuration = 30.0;
      final phaseProgress = (currentTime % phaseDuration) / phaseDuration;

      // Allow switch at the beginning of each phase (first 3 seconds)
      if (phaseProgress < 0.1 && _framesSinceLastSwitch > 180) {
        // 3 second minimum
        _framesSinceLastSwitch = 0;
        return true;
      }

      // Also use the existing override logic
      if (_shouldOverrideForStarScenarioPhase(candidateBodies, scenario)) {
        _framesSinceLastSwitch = 0;
        return true;
      }
    }

    // Check if we have a queued target that's ready to be used
    if (_hasQueuedTarget && _nextTargetBodies != null && _framesSinceLastSwitch >= minLockFrames) {
      // Time to switch to the queued target
      _framesSinceLastSwitch = 0; // Reset frame counter
      return true;
    }

    // Force minimum lock frames - ABSOLUTELY no switching allowed during this period
    if (_framesSinceLastSwitch < minLockFrames) {
      // During lock frames, we can queue targets but NEVER switch
      if (!_hasQueuedTarget && candidateBodies.length >= 2 && _currentFramedBodies.length >= 2) {
        final currentScore = _scoreBodiesPair(_currentFramedBodies[0], _currentFramedBodies[1], []);
        final candidateScore = _scoreBodiesPair(candidateBodies[0], candidateBodies[1], []);

        if (candidateScore > currentScore * 1.5) {
          // 50% better - queue for later
          _nextTargetBodies = candidateBodies;
          _hasQueuedTarget = true;
        }
      }
      // ALWAYS return false during lock frames - no exceptions
      return false;
    }

    // After lock frames expire, be very conservative about switching
    if (!_hasQueuedTarget && candidateBodies.length >= 2 && _currentFramedBodies.length >= 2) {
      final currentScore = _scoreBodiesPair(_currentFramedBodies[0], _currentFramedBodies[1], []);
      final candidateScore = _scoreBodiesPair(candidateBodies[0], candidateBodies[1], []);

      // Require massive improvement to switch without queue (2x better)
      if (candidateScore > currentScore * 2.0) {
        _framesSinceLastSwitch = 0; // Reset frame counter
        return true;
      }
    }

    return false;
  }

  /// Check if current cinematic phase suggests a different target type for star scenarios
  bool _shouldOverrideForStarScenarioPhase(List<Body> candidateBodies, ScenarioType scenario) {
    if (_currentFramedBodies.isEmpty || candidateBodies.isEmpty) return false;
    if (scenario != ScenarioType.earthMoonSun && scenario != ScenarioType.binaryStars) {
      return false;
    }

    // Get current target types
    final currentTypes = _currentFramedBodies.map((b) => b.bodyType).toSet();
    final candidateTypes = candidateBodies.map((b) => b.bodyType).toSet();

    // Calculate current phase
    final currentTime = _totalFrames / 60.0;
    final phaseDuration = 30.0;
    final currentPhase = ((currentTime / phaseDuration) % 3).floor();

    // Only suggest override if candidates actually offer what the phase wants
    switch (currentPhase) {
      case 0: // Phase 1: Star focus
        final wantStars = candidateTypes.contains(BodyType.star);
        final haveStars = currentTypes.contains(BodyType.star);
        if (wantStars && !haveStars && _framesSinceLastSwitch > 180) {
          // 3 seconds minimum - less aggressive
          return true;
        }
        break;

      case 1: // Phase 2: Star-planet interactions
        final wantStarPlanet = candidateTypes.contains(BodyType.star) && candidateTypes.contains(BodyType.planet);
        final haveStarPlanet = currentTypes.contains(BodyType.star) && currentTypes.contains(BodyType.planet);
        if (wantStarPlanet && !haveStarPlanet && _framesSinceLastSwitch > 180) {
          return true;
        }
        break;

      case 2: // Phase 3: Planet-moon focus
        final wantPlanetMoon = candidateTypes.contains(BodyType.planet) && candidateTypes.contains(BodyType.moon);
        final wantPlanetOnly = candidateTypes.contains(BodyType.planet);
        final havePlanetMoon = currentTypes.contains(BodyType.planet) && currentTypes.contains(BodyType.moon);
        final havePlanetOnly = currentTypes.contains(BodyType.planet) && !currentTypes.contains(BodyType.star);

        if ((wantPlanetMoon && !havePlanetMoon) || (wantPlanetOnly && !havePlanetOnly)) {
          if (_framesSinceLastSwitch > 180) {
            return true;
          }
        }
        break;
    }

    return false;
  }

  /// Determine the weighting for primary body based on cinematic phase and body types
  double _getPrimaryBodyWeight(List<Body> bodies) {
    if (bodies.length != 2) return 1.0;

    final body1 = bodies[0];
    final body2 = bodies[1];

    // Calculate current phase
    final currentTime = _totalFrames / 60.0;
    final phaseDuration = 30.0;
    final currentPhase = ((currentTime / phaseDuration) % 3).floor();

    // For planet-moon pairs in phase 3, focus heavily on the planet
    if (currentPhase == 2) {
      if (body1.bodyType == BodyType.planet && body2.bodyType == BodyType.moon) {
        return 0.95; // 95% focus on planet, 5% on moon (almost pure planet focus)
      } else if (body1.bodyType == BodyType.moon && body2.bodyType == BodyType.planet) {
        return 0.05; // 5% focus on moon, 95% on planet (swap order)
      }
    }

    // For star-planet pairs, balance based on phase
    if ((body1.bodyType == BodyType.star && body2.bodyType == BodyType.planet) ||
        (body1.bodyType == BodyType.planet && body2.bodyType == BodyType.star)) {
      switch (currentPhase) {
        case 0: // Star focus phase
          return body1.bodyType == BodyType.star ? 0.85 : 0.15; // Heavy star focus
        case 1: // Star-planet interaction phase
          return body1.bodyType == BodyType.star ? 0.6 : 0.4; // Balanced but star-leaning
        case 2: // Planet focus phase
          return body1.bodyType == BodyType.planet ? 0.85 : 0.15; // Heavy planet focus
      }
    }

    // For binary stars, always balance
    if (body1.bodyType == BodyType.star && body2.bodyType == BodyType.star) {
      return 0.5; // Perfect balance for binary stars
    }

    // Default weighting (70/30 toward primary)
    return 0.7;
  }

  /// Get the best target bodies (does not consider timing - just finds best available)
  List<Body> _getBestTargetBodies(List<Body> bodies) {
    // Always return the best available target, timing is handled elsewhere
    return _findMostInterestingBodies(bodies, ScenarioType.threeBodyClassic); // Default scenario
  }

  /// Update camera to optimally frame a set of bodies
  void _updateCameraForBodies(List<Body> bodies, CameraState camera, double deltaTime, ScenarioType scenario) {
    if (bodies.isEmpty) {
      return;
    }

    // Calculate the target center point with cinematic phase awareness
    vm.Vector3 targetCenter = vm.Vector3.zero();
    if (bodies.length == 1) {
      targetCenter = bodies[0].position;
    } else if (bodies.length == 2) {
      // Determine weighting based on cinematic phase and body types
      final primaryWeight = _getPrimaryBodyWeight(bodies);
      final secondaryWeight = 1.0 - primaryWeight;
      targetCenter = bodies[0].position * primaryWeight + bodies[1].position * secondaryWeight;
    } else {
      // For more than 2 bodies, use standard average
      for (final body in bodies) {
        targetCenter += body.position;
      }
      targetCenter /= bodies.length.toDouble();
    }

    // For random scenarios, add center smoothing to reduce chaotic camera movement
    if (scenario == ScenarioType.random) {
      // Smooth the target center with previous center to reduce jitter
      const smoothingFactor = 0.4;
      if (_previousCenter.length > 0) {
        targetCenter = _previousCenter * (1.0 - smoothingFactor) + targetCenter * smoothingFactor;
      }
    }

    // Calculate optimal camera distance using scenario-aware parameters
    final targetOptimalDistance = _calculateSafeDistance(bodies, targetCenter, scenario);

    // Get scenario-specific parameters for orbit behavior
    final cameraParams = _getScenarioCameraParameters(scenario);

    // Update orbit time and direction changes with scenario-specific speed
    _orbitTime += deltaTime * cameraParams.orbitSpeed * _currentOrbitDirection;

    // Only oscillate vertically for non-solar system scenarios
    if (scenario != ScenarioType.solarSystem) {
      _verticalOscillation += deltaTime * 0.6;
    }
    _directionChangeTime += deltaTime;

    // Occasionally change direction for more natural movement
    if (_directionChangeTime > 10.0 + math.Random().nextDouble() * 6.0) {
      _currentOrbitDirection *= -1.0;
      _directionChangeTime = 0.0;
    }

    // Calculate target camera parameters with natural variation
    final baseRadius = targetOptimalDistance;
    final radiusVariation = 1.0 + math.sin(_orbitTime * 0.4) * 0.3;
    final targetRadius = baseRadius * radiusVariation;

    // For solar system, maintain a stable pitch above the plane
    final pitchVariation = scenario == ScenarioType.solarSystem ? 0.0 : math.sin(_verticalOscillation) * 0.6;
    final targetPitch = scenario == ScenarioType.solarSystem
        ? 0.3 +
              math.sin(_verticalOscillation) *
                  0.15 // Gentle oscillation above the plane
        : 0.2 + pitchVariation;
    final targetYaw = _orbitTime;
    // Disable barrel roll for solar system scenarios
    final targetRoll = scenario == ScenarioType.solarSystem ? 0.0 : math.sin(_orbitTime * 0.3) * 0.1;

    // Use smooth transition for both position and camera angles
    vm.Vector3 center;
    double optimalDistance;
    double currentYaw;
    double currentPitch;
    double currentRoll;

    // For random scenarios, use much faster transitions to keep up with action
    if (_isTransitioning && _transitionProgress < 1.0) {
      // Much faster transition for random scenarios
      final transitionSpeed = scenario == ScenarioType.random ? 4.0 : 1.5;
      _transitionProgress += deltaTime * transitionSpeed;

      if (_transitionProgress >= 1.0) {
        _transitionProgress = 1.0;
        _isTransitioning = false;
      }

      // Smooth transition between previous and current states
      final t = _easeInOutQuad(_transitionProgress);
      center = _lerpVector3(_previousCenter, targetCenter, t);
      optimalDistance = _lerpDouble(_previousDistance, targetOptimalDistance, t);

      // Smoothly transition camera angles too
      currentYaw = _lerpDouble(_currentCameraYaw, targetYaw, t);
      currentPitch = _lerpDouble(_currentCameraPitch, targetPitch, t);
      currentRoll = _lerpDouble(_currentCameraRoll, targetRoll, t);

      // Update current values for next frame
      _currentCameraYaw = currentYaw;
      _currentCameraPitch = currentPitch;
      _currentCameraRoll = currentRoll;
    } else {
      center = targetCenter;
      optimalDistance = targetRadius; // Use the varied radius
      currentYaw = targetYaw;
      currentPitch = targetPitch;
      currentRoll = targetRoll;

      // Initialize current values if not transitioning
      _currentCameraYaw = currentYaw;
      _currentCameraPitch = currentPitch;
      _currentCameraRoll = currentRoll;
    }

    // Apply camera transformation with smooth values
    camera.setCameraParameters(
      yaw: currentYaw,
      pitch: currentPitch,
      roll: currentRoll,
      distance: optimalDistance,
      target: center,
    );

    // For random scenarios, do real-time framing validation to ensure bodies stay visible
    if (scenario == ScenarioType.random) {
      _validateAndCorrectFraming(bodies, camera, scenario);
    }
  }

  /// Real-time validation to ensure bodies are properly framed
  void _validateAndCorrectFraming(List<Body> bodies, CameraState camera, ScenarioType scenario) {
    if (bodies.isEmpty) return;

    // Calculate screen positions to check if bodies are visible
    const fieldOfViewRadians = math.pi / 3; // 60-degree FOV

    // Get current camera state
    final target = camera.target;
    final distance = camera.distance;

    // Check if any body is too far from the target center
    bool needsFramingCorrection = false;
    double maxDistanceFromCenter = 0.0;

    for (final body in bodies) {
      // Calculate distance from target center
      final distanceFromCenter = (body.position - target).length;
      maxDistanceFromCenter = math.max(maxDistanceFromCenter, distanceFromCenter);

      // If body is getting close to the edge of the view frustum, we need correction
      final fieldOfViewRadius = distance * math.tan(fieldOfViewRadians / 2.0);
      if (distanceFromCenter > fieldOfViewRadius * 0.6) {
        // 60% of view radius as threshold
        needsFramingCorrection = true;
        break;
      }
    }

    // Apply immediate correction if needed
    if (needsFramingCorrection) {
      // Calculate a more conservative distance that keeps all bodies visible
      final fieldOfViewTan = math.tan(fieldOfViewRadians / 2.0);
      final requiredDistance = (maxDistanceFromCenter * 2.2) / fieldOfViewTan; // More conservative margin

      // Apply correction with some smoothing to avoid jarring changes
      final correctedDistance = _lerpDouble(distance, math.max(requiredDistance, distance * 1.1), 0.4);
      camera.setCameraParameters(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: correctedDistance,
        target: target,
      );
    }
  }

  /// Calculate safe camera distance to keep all bodies visible (scenario-aware)
  double _calculateSafeDistance(List<Body> bodies, vm.Vector3 center, ScenarioType scenario) {
    if (bodies.isEmpty) {
      return 100.0;
    }

    // Find the maximum distance from center
    double maxDistance = 0.0;
    for (final body in bodies) {
      final distance = (body.position - center).length;
      maxDistance = math.max(maxDistance, distance);
    }

    // Enhanced safety margin - more conservative for random scenarios to ensure framing
    double guaranteedSafetyMargin = 1.8; // Default for most scenarios
    if (scenario == ScenarioType.random) {
      guaranteedSafetyMargin = 1.3; // Still dramatic but ensures bodies stay in frame
    }

    // Calculate optimal camera distance based on field of view
    final fieldOfViewRadians = math.pi / 3; // Assume 60-degree FOV

    // Calculate required distance to fit all bodies in FOV with extra margin
    final baseFovDistance = (maxDistance * 2.0 * guaranteedSafetyMargin) / math.tan(fieldOfViewRadians / 2.0);

    // For random scenarios, check if we're framing widely separated bodies
    // Only apply wide framing if we didn't filter down to an interacting pair
    bool framingAllSeparatedBodies = false;
    if (scenario == ScenarioType.random && bodies.length > 2) {
      // Calculate the spread of bodies to detect "frame everything" mode
      final distances = bodies.map((body) => (body.position - center).length).toList();
      distances.sort();
      final minDist = distances.first;
      final maxDist = distances.last;
      final spread = maxDist / (minDist + 1.0);

      // If spread is high and we're tracking many bodies, we're in "frame everything" mode
      framingAllSeparatedBodies = spread > 5.0 && bodies.length > 2;
    }

    // Get scenario-specific camera parameters for min/max constraints
    final cameraParams = _getScenarioCameraParameters(scenario);

    // For random scenarios with all separated bodies, use even wider framing
    double adjustedSafetyMargin = guaranteedSafetyMargin;
    if (framingAllSeparatedBodies) {
      adjustedSafetyMargin = 2.2; // Even wider margin to frame all separated bodies
    }

    // Apply pitch correction to account for viewing angle
    final pitchAngle = scenario == ScenarioType.solarSystem
        ? 0.3 // Fixed angle above the plane for solar system
        : 0.2 + math.sin(_verticalOscillation) * 0.6; // Current pitch

    final pitchCorrection = 1.0 + math.sin(pitchAngle.abs()) * 0.3; // Reduced sensitivity

    // Calculate final safe distance
    final safeDistance = baseFovDistance * pitchCorrection * adjustedSafetyMargin;

    // Check if we're primarily focusing on stars for special handling
    final starBodies = bodies.where((body) => body.bodyType == BodyType.star);
    final isStarFocused =
        starBodies.isNotEmpty && (scenario == ScenarioType.earthMoonSun || scenario == ScenarioType.binaryStars);

    // Apply star-specific adjustments while maintaining safety
    double finalDistance = safeDistance;
    if (isStarFocused && bodies.length <= 2) {
      // Only apply close-up factor when focusing on individual stars or binary pairs
      final starCloseUpFactor = scenario == ScenarioType.binaryStars ? 0.8 : 0.9; // Less aggressive
      finalDistance = safeDistance * starCloseUpFactor;
    }

    // Special handling for solar system planet tours
    if (scenario == ScenarioType.solarSystem && bodies.length == 1) {
      // When focusing on a single planet, get close but maintain visibility
      final planetBody = bodies.first;
      if (planetBody.bodyType == BodyType.planet) {
        // Set distance relative to planet size with safety margin
        finalDistance = math.max(planetBody.radius * 12.0, safeDistance * 0.6); // Increased from 8x
      }
    }

    // Ensure we stay within scenario limits but prioritize keeping bodies in frame
    final minSafeDistance = math.max(cameraParams.minDistance, maxDistance * 1.2);
    return math.max(math.min(finalDistance, cameraParams.maxDistance), minSafeDistance);
  }

  /// Ensure all specified bodies remain in frame during transitions
  /// This method calculates a conservative distance that guarantees visibility
  double _calculateTransitionSafeDistance(List<Body> allRelevantBodies, vm.Vector3 center, ScenarioType scenario) {
    if (allRelevantBodies.isEmpty) return 100.0;

    // Find the maximum distance from center for ALL relevant bodies
    double maxDistance = 0.0;
    for (final body in allRelevantBodies) {
      final distance = (body.position - center).length;
      maxDistance = math.max(maxDistance, distance);
    }

    // Use a very conservative safety margin for transitions
    const double transitionSafetyMargin = 2.5; // Extra wide to guarantee visibility

    // Calculate required distance to fit all bodies in FOV
    final fieldOfViewRadians = math.pi / 3; // Assume 60-degree FOV
    final requiredDistance = (maxDistance * 2.0 * transitionSafetyMargin) / math.tan(fieldOfViewRadians / 2.0);

    // Apply minimal pitch correction for transitions
    final pitchCorrection = 1.2; // Conservative correction

    // Get scenario limits
    final cameraParams = _getScenarioCameraParameters(scenario);
    final safeTransitionDistance = requiredDistance * pitchCorrection;

    // Ensure we respect scenario limits while prioritizing visibility
    final minDistance = math.max(cameraParams.minDistance, maxDistance * 1.5);
    return math.max(math.min(safeTransitionDistance, cameraParams.maxDistance), minDistance);
  }

  /// Get camera parameters based on simulation scenario
  ScenarioCameraParameters _getScenarioCameraParameters(ScenarioType scenario) {
    switch (scenario) {
      case ScenarioType.galaxyFormation:
        // Galaxy formation needs to show the big picture of star formation
        return ScenarioCameraParameters(
          safetyMargin: 2.0, // More distance to see galaxy structure
          minDistance: 80.0, // Further back for galactic scale
          maxDistance: 800.0, // Very wide shots
          pitchSensitivity: 0.3, // Less pitch correction
          targetLockFrames: 900, // 15 seconds - longer locks for galaxy evolution
          orbitSpeed: 0.15, // Slower, more majestic movement
        );

      case ScenarioType.solarSystem:
        // Solar system needs dynamic framing for planet tour
        return ScenarioCameraParameters(
          safetyMargin: 1.5, // Balanced for both close-ups and wide shots
          minDistance: 12.0, // Close planet views
          maxDistance: 600.0, // Wide enough for full system view
          pitchSensitivity: 0.35, // Moderate sensitivity
          targetLockFrames: 480, // 8 seconds - matches tour timing
          orbitSpeed: 0.2, // Slower, more majestic movement
        );

      case ScenarioType.binaryStars:
        // Binary stars need dramatic close-ups of stellar interactions
        return ScenarioCameraParameters(
          safetyMargin: 1.05, // Extremely close dramatic shots
          minDistance: 2.5, // Very close to stars for dramatic surface views
          maxDistance: 150.0, // Tighter shots for binary orbits
          pitchSensitivity: 0.5,
          targetLockFrames: 480, // 8 seconds - faster switching for action
          orbitSpeed: 0.35, // Faster for dramatic effect
        );

      case ScenarioType.earthMoonSun:
        // Earth-Moon-Sun needs dramatic close-ups while educational
        return ScenarioCameraParameters(
          safetyMargin: 1.15, // Much closer view of Earth-Moon system and Sun
          minDistance: 3.0, // Very close to see stellar surface details
          maxDistance: 180.0, // Tighter framing for dramatic star views
          pitchSensitivity: 0.4,
          targetLockFrames: 600, // 10 seconds - educational pace
          orbitSpeed: 0.2, // Slow and steady for learning
        );

      case ScenarioType.asteroidBelt:
        // Asteroid belt needs to show swarms and individual rocks
        return ScenarioCameraParameters(
          safetyMargin: 1.5, // Medium distance for asteroid swarms
          minDistance: 15.0, // Close enough to see individual asteroids
          maxDistance: 450.0, // Wide enough for belt structure
          pitchSensitivity: 0.4,
          targetLockFrames: 540, // 9 seconds - moderate switching
          orbitSpeed: 0.3, // Dynamic movement through asteroids
        );

      case ScenarioType.random:
        // Random: Extremely aggressive close-up shots for maximum drama
        return ScenarioCameraParameters(
          safetyMargin: 0.8, // Get as close as possible without clipping
          minDistance: 1.5, // Ultra-close dramatic shots (was 3.0)
          maxDistance: 35.0, // Very tight maximum framing (was 60.0)
          pitchSensitivity: 0.6, // High sensitivity for dynamic angles
          targetLockFrames: 360, // 6 seconds - faster switching for intense action
          orbitSpeed: 0.4, // More dynamic movement for chaos
        );

      case ScenarioType.threeBodyClassic:
      case ScenarioType.collisionDemo:
      case ScenarioType.deepSpace:
        // Default: Balanced for other scenarios
        return ScenarioCameraParameters(
          safetyMargin: 1.4, // Versatile distance
          minDistance: 15.0, // Close dramatic shots
          maxDistance: 400.0, // Reasonable wide shots
          pitchSensitivity: 0.5,
          targetLockFrames: 600, // 10 seconds - standard locks
          orbitSpeed: 0.3, // Standard speed
        );
    }
  }

  /// Get maximum distance between any two bodies
  double _getMaxDistance(List<Body> bodies) {
    double maxDist = 0.0;
    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final dist = (bodies[i].position - bodies[j].position).length;
        maxDist = math.max(maxDist, dist);
      }
    }
    return maxDist;
  }

  /// Get total mass of all bodies
  double _getTotalMass(List<Body> bodies) {
    return bodies.fold(0.0, (sum, body) => sum + body.mass);
  }

  /// Find all interesting body pairs with their scores
  List<List<Body>> _findAllInterestingPairs(List<Body> bodies) {
    final pairs = <List<Body>>[];
    final scores = <double>[];

    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        final body1 = bodies[i];
        final body2 = bodies[j];
        final score = _scoreBodiesPair(body1, body2, bodies);

        if (score > 1.5) {
          // Higher threshold for what's considered interesting
          pairs.add([body1, body2]);
          scores.add(score);
        }
      }
    }

    // Sort by score (highest first)
    final indexedPairs = List.generate(pairs.length, (i) => i);
    indexedPairs.sort((a, b) => scores[b].compareTo(scores[a]));

    return indexedPairs.map((i) => pairs[i]).toList();
  }

  /// Check if we should frame multiple bodies due to competing interests
  bool _shouldFrameMultipleBodies(List<List<Body>> allPairs, List<Body> topPair) {
    if (allPairs.length < 2) return false;

    final topScore = _scoreBodiesPair(topPair[0], topPair[1], []);
    final secondScore = _scoreBodiesPair(allPairs[1][0], allPairs[1][1], []);

    // Only switch to multi-body if scores are very close (within 15%) and reasonably high
    return secondScore > topScore * 0.85 && topScore > 2.0;
  }

  /// Get unique bodies from all interesting pairs
  List<Body> _getUniqueInterestingBodies(List<List<Body>> pairs) {
    final uniqueBodies = <Body>{};

    // Take up to 3 most interesting pairs to avoid too wide framing
    final pairsToConsider = pairs.take(3);

    for (final pair in pairsToConsider) {
      uniqueBodies.addAll(pair);
    }

    return uniqueBodies.toList();
  }

  /// Reset controller state (useful when switching techniques)
  void reset() {
    _orbitTime = 0.0;
    _verticalOscillation = 0.0;
    _currentFramedBodies.clear();
    _directionChangeTime = 0.0;
    _currentOrbitDirection = 1.0;
    _previousCenter = vm.Vector3.zero();
    _previousDistance = 100.0;
    _isTransitioning = false;
    _transitionProgress = 0.0;
    _isFramingMultipleBodies = false;
    _allInterestingBodies.clear();
    _multiBodyFramingTime = 0.0;
    _currentCameraYaw = 0.0;
    _currentCameraPitch = 0.2;
    _currentCameraRoll = 0.0;
    _hasQueuedTarget = false;
    _nextTargetBodies = null;
    _framesSinceLastSwitch = 0;
    _totalFrames = 0;
    _targetFramedBodies.clear();
    _lastBodyCount = 0;
  }

  /// Handle dedicated Earth-Moon-Sun tour with AI control and never targeting moon
  void _handleEarthMoonSunTour(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    if (bodies.length < 3) return;

    // Identify the bodies - Sun (largest), Earth (medium), Moon (smallest)
    final sortedBodies = List<Body>.from(bodies)..sort((a, b) => b.mass.compareTo(a.mass));

    final sun = sortedBodies[0]; // Largest mass
    final earth = sortedBodies[1]; // Medium mass
    // Note: Moon is sortedBodies[2] (smallest mass) but not directly targeted in tours

    // Tour cycle: Wide View (1s) → Sun Focus (4s) → Earth Focus (4s) → Wide Return (2s) → repeat
    // Note: Never targets the moon directly
    const double wideViewDuration = 1.0; // Brief overview
    const double sunFocusDuration = 4.0; // AI explores the sun
    const double earthFocusDuration = 4.0; // AI explores earth (moon visible but not targeted)
    const double wideReturnDuration = 2.0; // Return to wide view
    const double totalCycleDuration = wideViewDuration + sunFocusDuration + earthFocusDuration + wideReturnDuration;

    final cycleTime = (_totalFrames / 60.0) % totalCycleDuration;

    // Reset AI state at start of new cycle
    if (cycleTime < 0.1) {
      // First frame of cycle
      _emsAiBaseYaw = null;
      _emsAiBasePitch = null;
      _emsAiBaseRoll = null;
    }

    if (cycleTime < wideViewDuration) {
      // Phase 1: AI-controlled wide view
      final allBodies = [sun, earth]; // Include earth but not moon in wide framing
      final wideCenter = _calculateCenter(allBodies);
      final wideDistance =
          _calculateSafeDistance(allBodies, wideCenter, simulation.currentScenario) * 0.8; // Closer starting view

      // Set wide view position and let AI control movement
      camera.setCameraParameters(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: wideDistance,
        target: wideCenter,
      );

      // Custom AI movement for Earth-Moon-Sun wide view
      _orbitTime += deltaTime * 0.3;
      final yawMovement = math.sin(_orbitTime * 0.4) * 0.02;
      final pitchMovement = math.sin(_orbitTime * 0.6) * 0.01;
      final rollMovement = math.sin(_orbitTime * 0.2) * 0.005;

      camera.setCameraParameters(
        yaw: camera.yaw + yawMovement,
        pitch: math.max(0.1, math.min(0.5, camera.pitch + pitchMovement)),
        roll: camera.roll + rollMovement,
        distance: wideDistance,
        target: wideCenter,
      );

      return; // Exit early since AI handled the camera directly
    } else if (cycleTime < wideViewDuration + sunFocusDuration) {
      // Phase 2: AI-controlled zoom to and exploration of the sun
      final sunTime = cycleTime - wideViewDuration;
      final progress = sunTime / sunFocusDuration;
      final smoothT = _easeInOutQuad(progress);

      // Calculate sun focus parameters
      final startCenter = _calculateCenter([sun, earth]);
      final startDistance = _calculateSafeDistance([sun, earth], startCenter, simulation.currentScenario) * 0.8;
      final sunDistance =
          _calculateSafeDistance([sun], sun.position, simulation.currentScenario) * 3.5; // Stay further from sun

      // Initialize AI base state when starting this phase
      if (sunTime < 0.1) {
        // First frame of sun focus
        _emsAiBaseYaw = camera.yaw;
        _emsAiBasePitch = camera.pitch;
        _emsAiBaseRoll = camera.roll;
      }

      // Smooth transition to sun
      final targetCenter = _lerpVector3(startCenter, sun.position, smoothT);
      final targetDistance = _lerpDouble(startDistance, sunDistance, smoothT);

      // Custom AI movement for sun exploration using base state
      _orbitTime += deltaTime * 0.35;
      final yawMovement = math.sin(_orbitTime * 0.8) * 0.025;
      final pitchMovement = math.sin(_orbitTime * 0.6) * 0.012;
      final rollMovement = math.sin(_orbitTime * 0.4) * 0.008;

      // Apply transition position with AI movement relative to base state
      camera.setCameraParameters(
        yaw: (_emsAiBaseYaw ?? camera.yaw) + yawMovement,
        pitch: math.max(0.1, math.min(0.4, (_emsAiBasePitch ?? camera.pitch) + pitchMovement)),
        roll: (_emsAiBaseRoll ?? camera.roll) + rollMovement,
        distance: targetDistance,
        target: targetCenter,
      );

      return; // Exit early since AI handled the camera directly
    } else if (cycleTime < wideViewDuration + sunFocusDuration + earthFocusDuration) {
      // Phase 3: AI-controlled transition to and exploration of earth (moon visible but not targeted)
      final earthTime = cycleTime - wideViewDuration - sunFocusDuration;
      final progress = earthTime / earthFocusDuration;
      final smoothT = _easeInOutQuad(progress);

      // Calculate earth focus parameters - frame earth but moon may be visible
      final earthDistance = _calculateSafeDistance([earth], earth.position, simulation.currentScenario) * 1.8;

      // Calculate starting position from end of sun phase to avoid jumps
      final sunDistance = _calculateSafeDistance([sun], sun.position, simulation.currentScenario) * 3.5;

      // Initialize AI base state when starting this phase
      if (earthTime < 0.1) {
        // First frame of earth focus
        _emsAiBaseYaw = camera.yaw;
        _emsAiBasePitch = camera.pitch;
        _emsAiBaseRoll = camera.roll;
      }

      // Smooth transition from sun to earth (start from sun's final position and distance)
      final targetCenter = _lerpVector3(sun.position, earth.position, smoothT);
      final targetDistance = _lerpDouble(sunDistance, earthDistance, smoothT);

      // Custom AI movement for earth exploration using base state
      _orbitTime += deltaTime * 0.4;
      final yawMovement = math.sin(_orbitTime * 0.5) * 0.03;
      final pitchMovement = math.sin(_orbitTime * 0.7) * 0.015;
      final rollMovement = math.sin(_orbitTime * 0.3) * 0.008;

      // Apply transition with AI movement in single call
      camera.setCameraParameters(
        yaw: (_emsAiBaseYaw ?? camera.yaw) + yawMovement,
        pitch: math.max(0.1, math.min(0.4, (_emsAiBasePitch ?? camera.pitch) + pitchMovement)),
        roll: (_emsAiBaseRoll ?? camera.roll) + rollMovement,
        distance: targetDistance,
        target: targetCenter,
      );

      return; // Exit early since AI handled the camera directly
    } else {
      // Phase 4: Smooth return to wide view with simultaneous zoom-out and reorientation
      final returnTime = cycleTime - wideViewDuration - sunFocusDuration - earthFocusDuration;
      final progress = returnTime / wideReturnDuration;
      final smoothT = _easeInOutQuad(progress);

      // Get current position and transition back to wide view
      final currentCenter = camera.target;
      final currentDistance = camera.distance;
      final currentYaw = camera.yaw;
      final currentPitch = camera.pitch;
      final currentRoll = camera.roll;

      // Calculate wide view parameters
      final allBodies = [sun, earth]; // Include earth but not moon in wide framing
      final wideCenter = _calculateCenter(allBodies);
      final wideDistance =
          _calculateSafeDistance(allBodies, wideCenter, simulation.currentScenario) * 0.8; // Match closer starting view

      // Start zoom out and reorientation simultaneously
      final targetCenter = _lerpVector3(currentCenter, wideCenter, smoothT);
      final targetDistance = _lerpDouble(currentDistance, wideDistance, smoothT);

      // Reorient camera angles simultaneously with zoom-out
      final targetYaw = currentYaw + (smoothT * 0.08);
      final targetPitch = _lerpDouble(currentPitch, 0.3, smoothT);
      final targetRoll = _lerpDouble(currentRoll, 0.0, smoothT);

      // Apply simultaneous zoom-out and reorientation
      camera.setCameraParameters(
        yaw: targetYaw,
        pitch: targetPitch,
        roll: targetRoll,
        distance: targetDistance,
        target: targetCenter,
      );

      return; // Exit early since we handled the camera directly
    }
  }

  /// Handle cinematic tour for binary star systems
  void _handleBinaryStarTour(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    if (bodies.length < 2) return;

    // Identify stars and planets - sort by mass, stars are typically the largest
    final sortedBodies = List<Body>.from(bodies)..sort((a, b) => b.mass.compareTo(a.mass));

    // Take the two most massive bodies as binary stars
    final star1 = sortedBodies[0]; // Primary star (largest mass)
    final star2 = sortedBodies[1]; // Secondary star (second largest mass)

    // Filter for actual planets only - exclude moons and other small bodies
    final planets = sortedBodies.length > 2
        ? sortedBodies.sublist(2).where((body) => body.bodyType == BodyType.planet).toList()
        : <Body>[];

    // Tour cycle: Quick Wide View (1s) → Zoom In (4s) → Direct Planet Transition (2s) → Planet Survey (3s) → Wide View Return (2s) → repeat
    const double wideViewDuration = 1.0; // Very brief overview - start zooming in quickly
    const double zoomInDuration = 4.0; // Zoom in to binary stars
    const double planetTransitionDuration = 2.0; // Direct transition from binary to planets
    const double planetSurveyDuration = 3.0; // Survey any planets
    const double wideViewReturnDuration = 2.0; // Return to wide view before repeating
    const double totalCycleDuration =
        wideViewDuration + zoomInDuration + planetTransitionDuration + planetSurveyDuration + wideViewReturnDuration;

    final cycleTime = (_totalFrames / 60.0) % totalCycleDuration;

    vm.Vector3 targetCenter;
    double targetDistance;

    if (cycleTime < wideViewDuration) {
      // Phase 1: Pure AI-controlled wide view (no zoom yet)
      final allBodies = planets.isNotEmpty ? [star1, star2, ...planets] : [star1, star2];
      final wideCenter = _calculateCenter(allBodies);
      final wideDistance =
          _calculateSafeDistance(allBodies, wideCenter, simulation.currentScenario) * 1.2; // Closer wide view

      // Set wide view position and let AI control movement
      camera.setCameraParameters(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: wideDistance,
        target: wideCenter,
      );

      // Let AI intelligent framing take over for dynamic wide view movement
      // But avoid calling _updateIntelligentFraming if it has scenario-specific overrides
      // Instead, implement our own AI-like movement for binary star scenarios
      if (simulation.currentScenario == ScenarioType.binaryStars) {
        // Implement custom AI-like movement for binary star wide view
        _orbitTime += deltaTime * 0.3;
        final yawMovement = math.sin(_orbitTime * 0.4) * 0.02;
        final pitchMovement = math.sin(_orbitTime * 0.6) * 0.01;
        final rollMovement = math.sin(_orbitTime * 0.2) * 0.005;

        camera.setCameraParameters(
          yaw: camera.yaw + yawMovement,
          pitch: math.max(0.1, math.min(0.5, camera.pitch + pitchMovement)),
          roll: camera.roll + rollMovement,
          distance: wideDistance,
          target: wideCenter,
        );
      } else {
        _updateIntelligentFraming(simulation, camera, deltaTime);
      }

      // Store AI's final position AFTER AI has updated the camera for smooth handoff to zoom phase
      _aiLastTarget = vm.Vector3.copy(camera.target);
      _aiLastDistance = camera.distance;

      return; // Exit early since AI handled the camera directly
    } else if (cycleTime < wideViewDuration + zoomInDuration) {
      // Phase 2: AI-controlled zoom from wide view to binary stars close-up
      final zoomTime = cycleTime - wideViewDuration;
      final progress = zoomTime / zoomInDuration;
      final smoothT = _easeInOutQuad(progress);

      // Use AI's stored final position as starting point, or fallback to current camera
      final startCenter = _aiLastTarget ?? camera.target;
      final startDistance = _aiLastDistance ?? camera.distance;

      // Calculate target binary position
      final binaryCenter = _calculateCenter([star1, star2]);
      final starSeparation = (star1.position - star2.position).length;
      final binaryDistance = starSeparation * 1.5; // Close-up view of binary stars

      // Smooth zoom transition from AI's final position to binary close-up
      final targetCenter = _lerpVector3(startCenter, binaryCenter, smoothT);
      final targetDistance = _lerpDouble(startDistance, binaryDistance, smoothT);

      // Set the basic zoom target and distance
      camera.setCameraParameters(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: targetDistance,
        target: targetCenter,
      );

      // Now let AI control the camera movement during the zoom
      if (simulation.currentScenario == ScenarioType.binaryStars) {
        // Implement custom AI-like movement during zoom to binary stars
        _orbitTime += deltaTime * 0.35;
        final yawMovement = math.sin(_orbitTime * 0.8) * 0.025; // More dynamic during zoom
        final pitchMovement = math.sin(_orbitTime * 0.6) * 0.012;
        final rollMovement = math.sin(_orbitTime * 0.4) * 0.008;

        camera.setCameraParameters(
          yaw: camera.yaw + yawMovement,
          pitch: math.max(0.1, math.min(0.4, camera.pitch + pitchMovement)),
          roll: camera.roll + rollMovement,
          distance: targetDistance,
          target: targetCenter,
        );
      } else {
        _updateIntelligentFraming(simulation, camera, deltaTime);
      }

      return; // Exit early since AI handled the camera directly
    } else if (cycleTime < wideViewDuration + zoomInDuration + planetTransitionDuration) {
      // Phase 3: Direct transition from binary stars to planets (if planets exist)
      final transitionTime = cycleTime - wideViewDuration - zoomInDuration;
      final progress = transitionTime / planetTransitionDuration;

      if (planets.isNotEmpty) {
        // Direct smooth transition from binary center to first planet
        final smoothT = _easeInOutQuad(progress);

        final binaryCenter = _calculateCenter([star1, star2]);
        final firstPlanet = planets[0];

        // Use camera's current distance as starting point
        final currentCameraDistance = camera.distance;
        final planetDistance =
            _calculateTransitionSafeDistance([firstPlanet], firstPlanet.position, simulation.currentScenario) * 0.8;

        // Smoothly transition target position and distance
        targetCenter = _lerpVector3(binaryCenter, firstPlanet.position, smoothT);
        targetDistance = _lerpDouble(currentCameraDistance, planetDistance, smoothT);

        // Simple, stable angle transitions without complex calculations
        final startYaw = camera.yaw;
        final startRoll = camera.roll;

        // Target stable viewing angles for the planet (avoid extreme angles)
        final targetYaw = startYaw + (smoothT * 0.05); // Much less spinning - was 0.2, now 0.05
        final targetPitch = 0.25; // Safe, stable pitch for planet viewing
        final targetRoll = startRoll * (1.0 - smoothT); // Gradually reduce roll

        // Apply smooth, stable transitions
        camera.setCameraParameters(
          yaw: targetYaw,
          pitch: targetPitch,
          roll: targetRoll,
          distance: targetDistance,
          target: targetCenter,
        );
        return;
      } else {
        // No planets - continue focusing on binary system
        final binaryCenter = _calculateCenter([star1, star2]);
        final binaryDistance = _calculateSafeDistance([star1, star2], binaryCenter, simulation.currentScenario) * 0.9;

        targetCenter = binaryCenter;

        // Add gentle movement during transition period
        final systemVariation = math.sin(progress * math.pi * 2) * 0.06;
        targetDistance = binaryDistance * (1.0 + systemVariation);

        // Apply binary system movement directly and return early
        camera.setCameraParameters(
          yaw: camera.yaw,
          pitch: camera.pitch,
          roll: camera.roll,
          distance: targetDistance,
          target: targetCenter,
        );
        return; // Exit early since we handled the camera directly
      }
    } else if (cycleTime < wideViewDuration + zoomInDuration + planetTransitionDuration + planetSurveyDuration) {
      // Phase 4: Planet survey (if planets exist)
      final surveyTime = cycleTime - wideViewDuration - zoomInDuration - planetTransitionDuration;
      final progress = surveyTime / planetSurveyDuration;

      if (planets.isNotEmpty) {
        // Cycle through planets
        final planetIndex = (progress * planets.length).floor() % planets.length;
        final planetProgress = (progress * planets.length) % 1.0;
        final currentPlanet = planets[planetIndex];

        if (planetIndex > 0 && planetProgress < 0.3) {
          // Transition between planets (not needed for first planet since we transition in Phase 3)
          final transitionT = planetProgress / 0.3;
          final smoothT = _easeInOutQuad(transitionT);

          final previousPlanet = planets[planetIndex - 1];
          final previousDistance =
              _calculateSafeDistance([previousPlanet], previousPlanet.position, simulation.currentScenario) * 1.5;
          final currentDistance =
              _calculateSafeDistance([currentPlanet], currentPlanet.position, simulation.currentScenario) * 1.5;

          targetCenter = _lerpVector3(previousPlanet.position, currentPlanet.position, smoothT);
          targetDistance = _lerpDouble(previousDistance, currentDistance, smoothT);

          // Apply transition directly and return early
          camera.setCameraParameters(
            yaw: camera.yaw,
            pitch: camera.pitch,
            roll: camera.roll,
            distance: targetDistance,
            target: targetCenter,
          );
          return; // Exit early since we handled the transition directly
        } else {
          // Focus on current planet with AI-controlled cinematic movement
          targetCenter = currentPlanet.position;
          final baseDistance =
              _calculateSafeDistance([currentPlanet], currentPlanet.position, simulation.currentScenario) * 1.5;

          // Set the basic target and distance, then let AI handle all camera movements
          camera.setCameraParameters(
            yaw: camera.yaw, // Keep current angles initially
            pitch: camera.pitch,
            roll: camera.roll,
            distance: baseDistance,
            target: targetCenter,
          );

          // Now let the intelligent framing system control roll, yaw, pitch, pan, etc.
          // But avoid calling _updateIntelligentFraming if it has scenario-specific overrides
          if (simulation.currentScenario == ScenarioType.binaryStars) {
            // Implement custom AI-like movement for planet exploration in binary star systems
            _orbitTime += deltaTime * 0.4;
            final yawMovement = math.sin(_orbitTime * 0.5) * 0.03;
            final pitchMovement = math.sin(_orbitTime * 0.7) * 0.015;
            final rollMovement = math.sin(_orbitTime * 0.3) * 0.008;

            camera.setCameraParameters(
              yaw: camera.yaw + yawMovement,
              pitch: math.max(0.1, math.min(0.4, camera.pitch + pitchMovement)),
              roll: camera.roll + rollMovement,
              distance: baseDistance,
              target: targetCenter,
            );
          } else {
            _updateIntelligentFraming(simulation, camera, deltaTime);
          }
          return; // Exit early since AI handled the camera directly
        }
      } else {
        // No planets - continue focusing on binary system with different movement
        final binaryCenter = _calculateCenter([star1, star2]);
        final binaryDistance = _calculateSafeDistance([star1, star2], binaryCenter, simulation.currentScenario) * 0.9;

        targetCenter = binaryCenter;

        // Add gentle close-up movement of the binary system
        final systemVariation = math.sin(progress * math.pi * 3) * 0.06;
        targetDistance = binaryDistance * (1.0 + systemVariation);

        // Apply binary system movement directly and return early
        camera.setCameraParameters(
          yaw: camera.yaw,
          pitch: camera.pitch,
          roll: camera.roll,
          distance: targetDistance,
          target: targetCenter,
        );
        return; // Exit early since we handled the camera directly
      }
    } else {
      // Phase 5: Return to wide view with AI control before restarting cycle
      final returnTime =
          cycleTime - wideViewDuration - zoomInDuration - planetTransitionDuration - planetSurveyDuration;
      final progress = returnTime / wideViewReturnDuration;

      if (progress < 0.7) {
        // First 70% of Phase 5: Let AI control the camera from current planet position
        // Start AI movement immediately without static camera position

        // Let AI intelligent framing take over for dynamic movement
        // But avoid calling _updateIntelligentFraming if it has scenario-specific overrides
        if (simulation.currentScenario == ScenarioType.binaryStars) {
          // Implement custom AI-like movement for binary star return phase
          // Make it more dynamic to avoid the "sitting there" feeling
          _orbitTime += deltaTime * 0.4; // Faster movement
          final yawMovement = math.sin(_orbitTime * 0.8) * 0.035; // More pronounced
          final pitchMovement = math.sin(_orbitTime * 0.6) * 0.018; // More dynamic
          final rollMovement = math.sin(_orbitTime * 0.7) * 0.01; // More roll

          camera.setCameraParameters(
            yaw: camera.yaw + yawMovement,
            pitch: math.max(0.1, math.min(0.5, camera.pitch + pitchMovement)),
            roll: camera.roll + rollMovement,
            distance: camera.distance,
            target: camera.target,
          );
        } else {
          _updateIntelligentFraming(simulation, camera, deltaTime);
        }
        return; // Exit early since AI handled the camera directly
      } else {
        // Last 30% of Phase 5: Start zooming out immediately while smoothly reorienting
        final transitionProgress = (progress - 0.7) / 0.3; // 0.0 to 1.0 over last 30%
        final smoothT = _easeInOutQuad(transitionProgress);

        // Get current position (where AI is/was) and start transitioning immediately
        final currentCenter = camera.target;
        final currentDistance = camera.distance;
        final currentYaw = camera.yaw;
        final currentPitch = camera.pitch;
        final currentRoll = camera.roll;

        // Calculate wide view parameters for next cycle
        final allBodies = planets.isNotEmpty ? [star1, star2, ...planets] : [star1, star2];
        final wideCenter = _calculateCenter(allBodies);
        final wideDistance = _calculateSafeDistance(allBodies, wideCenter, simulation.currentScenario) * 1.2;

        // Start zoom out and reorientation simultaneously for dynamic transition
        final targetCenter = _lerpVector3(currentCenter, wideCenter, smoothT);
        final targetDistance = _lerpDouble(currentDistance, wideDistance, smoothT);

        // Reorient camera angles simultaneously with zoom-out for fluid movement
        final targetYaw = currentYaw + (smoothT * 0.08); // Slightly more rotation during zoom-out
        final targetPitch = _lerpDouble(currentPitch, 0.3, smoothT); // Move to neutral wide view angle
        final targetRoll = _lerpDouble(currentRoll, 0.0, smoothT); // Reduce roll to neutral

        // Apply simultaneous zoom-out and reorientation for cinematic effect
        camera.setCameraParameters(
          yaw: targetYaw,
          pitch: targetPitch,
          roll: targetRoll,
          distance: targetDistance,
          target: targetCenter,
        );
        return; // Exit early since we handled the camera directly
      }
    }
  }

  /// Handles cinematic tour for asteroid belt scenarios with AI-controlled phases
  void _handleAsteroidBeltTour(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    if (bodies.isEmpty) return;

    // Find central star (typically the largest body)
    final sortedBodies = List<Body>.from(bodies)..sort((a, b) => b.mass.compareTo(a.mass));
    final centralStar = sortedBodies.isNotEmpty ? sortedBodies.first : null;
    if (centralStar == null) return;

    // Find asteroids/small bodies for the tour
    final asteroids = bodies
        .where((body) => body.bodyType == BodyType.asteroid || body.bodyType == BodyType.planet)
        .toList();

    if (asteroids.isEmpty) return;

    // Enhanced phase timing with AI control periods
    const double wideViewDuration = 2.0; // Wide view to center star + inner planets
    const double centralStarAIDuration = 2.0; // AI control at central star
    const double outerTransitionDuration = 2.0; // Transition to outer planets
    const double outerPlanetAIDuration = 2.0; // AI control at outer planet
    const double wideViewReturnDuration = 2.0; // Return to starting wide view
    const double totalCycleDuration =
        wideViewDuration +
        centralStarAIDuration +
        outerTransitionDuration +
        outerPlanetAIDuration +
        wideViewReturnDuration;

    final cycleTime = (_totalFrames / 60.0) % totalCycleDuration;

    if (cycleTime < wideViewDuration) {
      // Phase 1: Start wide → zoom to center star while keeping inner planets in frame
      final progress = cycleTime / wideViewDuration;
      final smoothT = _easeInOutQuad(progress);

      // Calculate starting wide view to see everything
      final allBodies = [centralStar, ...asteroids];
      final wideCenter = _calculateCenter(allBodies);
      const wideDistance = 50.0; // Farther starting distance to see the full scene

      // Target: center star with inner planets visible
      final innerPlanets = asteroids
          .where(
            (body) => (body.position - centralStar.position).length < 3.0, // Inner region
          )
          .toList();
      final innerBodies = [centralStar, ...innerPlanets];
      final innerCenter = _calculateCenter(innerBodies);
      const innerDistance = 20.0; // Distance to see center star + inner planets

      // Smooth transition from wide view to inner system
      final targetCenter = _lerpVector3(wideCenter, innerCenter, smoothT);
      final targetDistance = _lerpDouble(wideDistance, innerDistance, smoothT);

      camera.setCameraParameters(yaw: 0.0, pitch: 0.25, roll: 0.0, distance: targetDistance, target: targetCenter);

      // Store position for next phase
      _aiLastTarget = vm.Vector3.copy(targetCenter);
      _aiLastDistance = targetDistance;

      return; // Exit early since we handled the camera directly
    } else if (cycleTime < wideViewDuration + centralStarAIDuration) {
      // Phase 2: AI control at central star

      // Set up the target for central star + inner planets
      final innerPlanets = asteroids
          .where(
            (body) => (body.position - centralStar.position).length < 3.0, // Inner region
          )
          .toList();
      final innerBodies = [centralStar, ...innerPlanets];
      final innerCenter = _calculateCenter(innerBodies);
      const innerDistance = 20.0;

      // Set the basic target and distance, then let AI handle movement
      camera.setCameraParameters(
        yaw: camera.yaw, // Keep current angles initially
        pitch: camera.pitch,
        roll: camera.roll,
        distance: innerDistance,
        target: innerCenter,
      );

      // Add AI-controlled cinematic movement
      _orbitTime += deltaTime * 0.3;
      final yawMovement = math.sin(_orbitTime * 0.6) * 0.02;
      final pitchMovement = math.sin(_orbitTime * 0.8) * 0.01;
      final rollMovement = math.sin(_orbitTime * 0.4) * 0.005;

      camera.setCameraParameters(
        yaw: camera.yaw + yawMovement,
        pitch: math.max(0.15, math.min(0.35, camera.pitch + pitchMovement)),
        roll: camera.roll + rollMovement,
        distance: innerDistance,
        target: innerCenter,
      );

      return; // Exit early since AI handled the camera directly
    } else if (cycleTime < wideViewDuration + centralStarAIDuration + outerTransitionDuration) {
      // Phase 3: Transition from current AI position to outer planets
      final transitionTime = cycleTime - wideViewDuration - centralStarAIDuration;
      final progress = transitionTime / outerTransitionDuration;
      final smoothT = _easeInOutQuad(progress);

      // Start from current camera position (where AI left off)
      final startCenter = camera.target;
      final startDistance = camera.distance;

      // Target: Find the farthest asteroid/planet for dramatic transition
      if (asteroids.isNotEmpty) {
        // Sort asteroids by distance from central star, get the farthest one
        final sortedByDistance = List<Body>.from(asteroids);
        sortedByDistance.sort((a, b) {
          final distA = (a.position - centralStar.position).length;
          final distB = (b.position - centralStar.position).length;
          return distB.compareTo(distA); // Sort descending (farthest first)
        });

        final farthestBody = sortedByDistance.first;
        final outerCenter = farthestBody.position;
        const outerDistance = 25.0; // Good distance to see the target body

        // Smooth transition from current AI position to the farthest body
        final targetCenter = _lerpVector3(startCenter, outerCenter, smoothT);
        final targetDistance = _lerpDouble(startDistance, outerDistance, smoothT);

        // Also smoothly transition camera angles from current AI position
        final startYaw = camera.yaw;
        final startPitch = camera.pitch;
        final startRoll = camera.roll;

        // Target angles for outer planet viewing
        const targetYaw = 0.0;
        const targetPitch = 0.25;
        const targetRoll = 0.0;

        final transitionYaw = _lerpDouble(startYaw, targetYaw, smoothT);
        final transitionPitch = _lerpDouble(startPitch, targetPitch, smoothT);
        final transitionRoll = _lerpDouble(startRoll, targetRoll, smoothT);

        camera.setCameraParameters(
          yaw: transitionYaw,
          pitch: transitionPitch,
          roll: transitionRoll,
          distance: targetDistance,
          target: targetCenter,
        );
      }

      return; // Exit early since we handled the camera directly
    } else if (cycleTime < wideViewDuration + centralStarAIDuration + outerTransitionDuration + outerPlanetAIDuration) {
      // Phase 4: AI control at outer planet

      // Find the farthest body again for consistency
      if (asteroids.isNotEmpty) {
        final sortedByDistance = List<Body>.from(asteroids);
        sortedByDistance.sort((a, b) {
          final distA = (a.position - centralStar.position).length;
          final distB = (b.position - centralStar.position).length;
          return distB.compareTo(distA); // Sort descending (farthest first)
        });

        final farthestBody = sortedByDistance.first;
        const outerDistance = 25.0;

        // Set the basic target and distance, then let AI handle movement
        camera.setCameraParameters(
          yaw: camera.yaw, // Keep current angles initially
          pitch: camera.pitch,
          roll: camera.roll,
          distance: outerDistance,
          target: farthestBody.position,
        );

        // Add AI-controlled cinematic movement around the outer planet
        _orbitTime += deltaTime * 0.4;
        final yawMovement = math.sin(_orbitTime * 0.7) * 0.025;
        final pitchMovement = math.sin(_orbitTime * 0.5) * 0.012;
        final rollMovement = math.sin(_orbitTime * 0.6) * 0.008;

        camera.setCameraParameters(
          yaw: camera.yaw + yawMovement,
          pitch: math.max(0.1, math.min(0.4, camera.pitch + pitchMovement)),
          roll: camera.roll + rollMovement,
          distance: outerDistance,
          target: farthestBody.position,
        );
      }

      return; // Exit early since AI handled the camera directly
    } else {
      // Phase 5: Return to starting wide view
      final returnTime =
          cycleTime - wideViewDuration - centralStarAIDuration - outerTransitionDuration - outerPlanetAIDuration;
      final progress = returnTime / wideViewReturnDuration;
      final smoothT = _easeInOutQuad(progress);

      // Get current position and transition to starting position
      final currentCenter = camera.target;
      final currentDistance = camera.distance;
      final currentYaw = camera.yaw;
      final currentPitch = camera.pitch;
      final currentRoll = camera.roll;

      // Calculate wide view parameters for next cycle - use SAME distance as Phase 1
      final allBodies = [centralStar, ...asteroids];
      final wideCenter = _calculateCenter(allBodies);
      const wideDistance = 50.0; // Same fixed distance as Phase 1 starting position

      // Smooth transition back to starting position
      final targetCenter = _lerpVector3(currentCenter, wideCenter, smoothT);
      final targetDistance = _lerpDouble(currentDistance, wideDistance, smoothT);

      // Return to exact starting angles from Phase 1
      final targetYaw = _lerpDouble(currentYaw, 0.0, smoothT); // Return to starting yaw
      final targetPitch = _lerpDouble(currentPitch, 0.25, smoothT); // Return to starting pitch
      final targetRoll = _lerpDouble(currentRoll, 0.0, smoothT); // Return to starting roll

      // Apply smooth transition back to starting state
      camera.setCameraParameters(
        yaw: targetYaw,
        pitch: targetPitch,
        roll: targetRoll,
        distance: targetDistance,
        target: targetCenter,
      );
      return; // Exit early since we handled the camera directly
    }
  }

  /// Handles cinematic tour for galaxy formation scenarios
  void _handleGalaxyFormationTour(SimulationState simulation, CameraState camera, double deltaTime) {
    final bodies = simulation.bodies;
    if (bodies.isEmpty) return;

    // Check if scenario changed and reset timing if needed
    if (_lastScenario != simulation.currentScenario) {
      _lastScenario = simulation.currentScenario;
      _scenarioStartTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    }

    // Find the supermassive black hole (typically the most massive body)
    final sortedBodies = List<Body>.from(bodies)..sort((a, b) => b.mass.compareTo(a.mass));
    final blackHole = sortedBodies.isNotEmpty ? sortedBodies.first : null;
    if (blackHole == null) return;

    // Find other interesting bodies (stars)
    final stars = bodies
        .where((body) => body != blackHole && (body.bodyType == BodyType.star || body.bodyType == BodyType.planet))
        .toList();

    if (stars.isEmpty) return;

    // 6-phase tour structure
    const double wideViewDuration = 4.0; // Wide galaxy view with gentle movement
    const double blackHoleTransitionDuration = 12.0; // Much slower transition with orbital movement
    const double blackHoleAIDuration = 6.0; // Extended AI control at black hole
    const double starTransitionDuration = 6.0; // Slower transition to random star
    const double starAIDuration = 6.0; // Extended AI control at star
    const double returnDuration = 8.0; // Slower return with orbital movement
    const double totalCycleDuration =
        wideViewDuration +
        blackHoleTransitionDuration +
        blackHoleAIDuration +
        starTransitionDuration +
        starAIDuration +
        returnDuration;

    // Use scenario start time to ensure tour always begins from the wide view
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final timeSinceScenarioStart = currentTime - _scenarioStartTime;
    final cycleTime = timeSinceScenarioStart % totalCycleDuration;

    if (cycleTime < wideViewDuration) {
      // Phase 1: Wide galaxy view with gentle pitch/yaw/roll movement

      // Calculate wide view to see the entire galaxy
      final allBodies = [blackHole, ...stars];
      final galaxyCenter = _calculateCenter(allBodies);
      const wideDistance = 600.0; // Much wider to see full galactic structure

      // Very gentle camera movement for dramatic galactic overview
      // Start from default galaxy formation camera angles
      final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
      final gentleYaw = 0.77 + math.sin(time * 0.1) * 0.05; // Start from default yaw (0.77)
      final gentlePitch = -0.89 + math.sin(time * 0.08) * 0.05; // Start from default pitch (-0.89)
      final gentleRoll = 0.0 + math.sin(time * 0.06) * 0.03; // Start from default roll (0.0)

      camera.setCameraParameters(
        yaw: gentleYaw,
        pitch: gentlePitch,
        roll: gentleRoll,
        distance: wideDistance,
        target: galaxyCenter,
      );

      return; // Exit early since we handled the camera directly
    } else if (cycleTime < wideViewDuration + blackHoleTransitionDuration) {
      // Phase 2: Transition from wide view to black hole with orbital movement
      final transitionTime = cycleTime - wideViewDuration;
      final progress = transitionTime / blackHoleTransitionDuration;
      final smoothT = _easeInOutQuad(progress);

      // Start from ACTUAL wide galaxy view distance (match Phase 1)
      final allBodies = [blackHole, ...stars];
      final startCenter = _calculateCenter(allBodies);
      const startDistance = 600.0; // Match the actual wide view distance

      // Target: black hole
      final blackHoleCenter = blackHole.position;
      const blackHoleDistance = 40.0; // Close enough to see the black hole's accretion disk

      // Add sweeping orbital movement around the galaxy as we zoom in
      final orbitProgress = progress * 2.0 * math.pi * 0.8; // More complete orbit for dramatic sweep
      final orbitRadius = (1.0 - progress) * 120.0; // Larger orbital radius for more dramatic sweep
      final orbitX = math.cos(orbitProgress) * orbitRadius;
      final orbitY = math.sin(orbitProgress) * orbitRadius;
      final orbitZ = math.sin(orbitProgress * 0.5) * orbitRadius * 0.3; // Add vertical sweep component
      final orbitOffset = vm.Vector3(orbitX, orbitY, orbitZ);

      // Smooth transition from actual wide view (600.0) to black hole (40.0) with sweeping movement
      final targetCenter = _lerpVector3(startCenter + orbitOffset, blackHoleCenter, smoothT);
      final targetDistance = _lerpDouble(startDistance, blackHoleDistance, smoothT);

      // Smoothly transition camera angles with dramatic orbital influence
      final startYaw = 0.77; // Default galaxy yaw
      final startPitch = -0.89; // Default galaxy pitch
      final orbitYawInfluence = orbitProgress * 0.6; // More pronounced orbital yaw influence
      final orbitPitchInfluence = math.sin(orbitProgress * 0.5) * 0.2; // Vertical sweep affects pitch
      final targetYaw = _lerpDouble(startYaw + orbitYawInfluence, 0.0, smoothT);
      final targetPitch = _lerpDouble(startPitch + orbitPitchInfluence, 0.25, smoothT);

      camera.setCameraParameters(
        yaw: targetYaw,
        pitch: targetPitch,
        roll: 0.0,
        distance: targetDistance,
        target: targetCenter,
      );

      return; // Exit early since we handled the camera directly
    } else if (cycleTime < wideViewDuration + blackHoleTransitionDuration + blackHoleAIDuration) {
      // Phase 3: AI control around black hole

      // Set up the black hole as target
      const blackHoleDistance = 40.0;

      // Set the basic target and distance, then let AI handle movement
      camera.setCameraParameters(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: blackHoleDistance,
        target: blackHole.position,
      );

      // Add dramatic AI-controlled movement around the black hole
      _orbitTime += deltaTime * 0.4; // Slower, more majestic movement

      // Create orbital movement with varying distance and angles
      final orbitRadius = 0.12; // Slightly reduced orbital movement
      final verticalMotion = 0.06; // More controlled vertical movement
      final rollIntensity = 0.04; // Reduced roll for smoothness

      // Add some variety with different movement patterns
      final time = _orbitTime;
      final yawMovement = math.sin(time * 0.8) * orbitRadius + math.sin(time * 0.3) * 0.02; // Combined movements
      final pitchMovement = math.sin(time * 0.6) * verticalMotion;
      final rollMovement = math.sin(time * 0.4) * rollIntensity;
      final distanceVariation = 35.0 + math.sin(time * 0.3) * 6.0; // Slower distance changes

      // Add occasional dramatic sweeps
      final sweepTime = time * 0.2;
      final dramaticSweep = math.sin(sweepTime) * 0.03;

      camera.setCameraParameters(
        yaw: camera.yaw + yawMovement + dramaticSweep,
        pitch: math.max(0.0, math.min(0.6, camera.pitch + pitchMovement)),
        roll: camera.roll + rollMovement,
        distance: distanceVariation,
        target: blackHole.position,
      );

      return; // Exit early since AI handled the camera directly
    } else if (cycleTime <
        wideViewDuration + blackHoleTransitionDuration + blackHoleAIDuration + starTransitionDuration) {
      // Phase 4: Transition from black hole to random star
      final transitionTime = cycleTime - wideViewDuration - blackHoleTransitionDuration - blackHoleAIDuration;
      final progress = transitionTime / starTransitionDuration;
      final smoothT = _easeInOutQuad(progress);

      // Start from current black hole position
      final startCenter = camera.target;
      final startDistance = camera.distance;

      // Target: pick a random star (but consistent per cycle)
      // Use scenario start time + cycle count to seed randomness consistently per cycle
      final cycleCount = (_totalFrames ~/ (60 * totalCycleDuration));
      final cycleSeed = (_scenarioStartTime * 1000).toInt() + cycleCount;
      final cycleRandom = math.Random(cycleSeed);
      final starIndex = cycleRandom.nextInt(stars.length);
      final targetStar = stars[starIndex];
      const starDistance = 30.0; // Good distance to see the star

      // Smooth transition
      final targetCenter = _lerpVector3(startCenter, targetStar.position, smoothT);
      final targetDistance = _lerpDouble(startDistance, starDistance, smoothT);

      // Also smooth transition of camera angles
      final startYaw = camera.yaw;
      final startPitch = camera.pitch;
      final startRoll = camera.roll;

      final targetYaw = _lerpDouble(startYaw, 0.0, smoothT);
      final targetPitch = _lerpDouble(startPitch, 0.3, smoothT);
      final targetRoll = _lerpDouble(startRoll, 0.0, smoothT);

      camera.setCameraParameters(
        yaw: targetYaw,
        pitch: targetPitch,
        roll: targetRoll,
        distance: targetDistance,
        target: targetCenter,
      );

      return; // Exit early since we handled the camera directly
    } else if (cycleTime <
        wideViewDuration +
            blackHoleTransitionDuration +
            blackHoleAIDuration +
            starTransitionDuration +
            starAIDuration) {
      // Phase 5: AI control around the random star

      // Pick the same random star as in transition (consistent per cycle)
      final cycleCount = (_totalFrames ~/ (60 * totalCycleDuration));
      final cycleSeed = (_scenarioStartTime * 1000).toInt() + cycleCount;
      final cycleRandom = math.Random(cycleSeed);
      final starIndex = cycleRandom.nextInt(stars.length);
      final targetStar = stars[starIndex];
      const starDistance = 30.0;

      // Set the basic target and distance, then let AI handle movement
      camera.setCameraParameters(
        yaw: camera.yaw,
        pitch: camera.pitch,
        roll: camera.roll,
        distance: starDistance,
        target: targetStar.position,
      );

      // Add dynamic AI-controlled movement around the star
      _orbitTime += deltaTime * 0.3; // Slower, more contemplative movement

      // Create gentle orbital movement around the star
      final orbitRadius = 0.08; // Reduced orbital movement
      final verticalMotion = 0.04; // Gentler vertical exploration
      final rollIntensity = 0.025; // Subtle roll movement

      // Add layered movement patterns for organic feel
      final time = _orbitTime;
      final yawMovement = math.sin(time * 0.5) * orbitRadius + math.sin(time * 1.3) * 0.015; // Layered movement
      final pitchMovement = math.sin(time * 0.7) * verticalMotion;
      final rollMovement = math.sin(time * 0.3) * rollIntensity;
      final distanceVariation = 28.0 + math.sin(time * 0.25) * 4.0; // Gentler distance breathing

      // Add subtle focus pulls (closer inspection moments)
      final focusPull = math.sin(time * 0.15) * 2.0;

      camera.setCameraParameters(
        yaw: camera.yaw + yawMovement,
        pitch: math.max(0.1, math.min(0.5, camera.pitch + pitchMovement)),
        roll: camera.roll + rollMovement,
        distance: distanceVariation + focusPull,
        target: targetStar.position,
      );

      return; // Exit early since AI handled the camera directly
    } else {
      // Phase 6: Return to wide galaxy view with orbital movement
      final returnTime =
          cycleTime -
          wideViewDuration -
          blackHoleTransitionDuration -
          blackHoleAIDuration -
          starTransitionDuration -
          starAIDuration;
      final progress = returnTime / returnDuration;
      final smoothT = _easeInOutQuad(progress);

      // Get current position and transition back to wide view
      final currentCenter = camera.target;
      final currentDistance = camera.distance;
      final currentYaw = camera.yaw;
      final currentPitch = camera.pitch;
      final currentRoll = camera.roll;

      // Calculate wide view parameters
      final allBodies = [blackHole, ...stars];
      final wideCenter = _calculateCenter(allBodies);
      const wideDistance = 600.0; // Same wide distance as Phase 1

      // Add orbital movement around the galaxy as we zoom out
      final orbitProgress = progress * 2.0 * math.pi * 0.5; // Slightly more than zoom-in for variety
      final orbitRadius = progress * 60.0; // Orbital radius increases as we zoom out
      final orbitX = math.cos(orbitProgress + math.pi) * orbitRadius; // Start from opposite side
      final orbitY = math.sin(orbitProgress + math.pi) * orbitRadius;
      final orbitOffset = vm.Vector3(orbitX, orbitY, 0.0);

      // Smooth transition back to wide view with orbital movement
      final targetCenter = _lerpVector3(currentCenter, wideCenter + orbitOffset, smoothT);
      final targetDistance = _lerpDouble(currentDistance, wideDistance, smoothT);

      // Return to default galaxy formation camera angles with orbital influence
      final orbitYawInfluence = math.sin(orbitProgress) * 0.2; // Orbital movement affects yaw
      final targetYaw = _lerpDouble(currentYaw, 0.77 + orbitYawInfluence, smoothT); // Default galaxy yaw + orbit
      final targetPitch = _lerpDouble(currentPitch, -0.89, smoothT); // Default galaxy pitch
      final targetRoll = _lerpDouble(currentRoll, 0.0, smoothT); // Default galaxy roll

      camera.setCameraParameters(
        yaw: targetYaw,
        pitch: targetPitch,
        roll: targetRoll,
        distance: targetDistance,
        target: targetCenter,
      );
      return; // Exit early since we handled the camera directly
    }
  }

  /// Handle dynamic framing camera technique - focuses on dramatic real-time interactions
  void _handleDynamicFraming(SimulationState simulation, CameraState camera, double deltaTime) {
    // For solar system, use intelligent framing but with stable camera movement (no barrel roll)
    if (simulation.currentScenario == ScenarioType.solarSystem) {
      _updateIntelligentFramingStable(simulation, camera, deltaTime);
      return;
    }

    // Dynamic framing uses intelligent framing with dramatic targeting and real-time adaptation
    // This is where all our dramatic targeting work for random scenarios lives
    _updateIntelligentFraming(simulation, camera, deltaTime);
  }

  vm.Vector3 _calculateCenter(List<Body> bodies) {
    if (bodies.isEmpty) {
      return vm.Vector3.zero();
    }

    vm.Vector3 center = vm.Vector3.zero();
    for (final body in bodies) {
      center += body.position;
    }
    return center / bodies.length.toDouble();
  }

  double _easeInOutQuad(double t) {
    return t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;
  }

  vm.Vector3 _lerpVector3(vm.Vector3 a, vm.Vector3 b, double t) {
    return a + (b - a) * t;
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  /// Check if two body pairs represent the same bodies (robust to object identity changes)
  ///
  /// This method implements complex velocity-aware position tolerance matching to handle
  /// the challenge of tracking body identity across frames when object references may
  /// change during mergers or simulation updates. In dynamic scenarios, body objects
  /// can be recreated, merged, or have their references invalidated, making simple
  /// object identity comparison unreliable.
  ///
  /// The velocity-aware approach adapts the position tolerance based on how fast the
  /// bodies are moving, allowing for more lenient matching when bodies are in rapid
  /// motion (where position differences between frames are naturally larger) while
  /// maintaining precision for slower-moving bodies.
  ///
  /// Example tolerance calculation (velocities are in simulation units per time step):
  /// - Two planets moving at velocities 0.5 and 1.2 units/time step
  /// - Average velocity: (0.5 + 1.2) / 2 = 0.85 units/time step
  /// - Base tolerance: 1.0 units (from RenderingConstants.bodyMatchingBaseTolerance)
  /// - Velocity component: 0.85 * 0.5 = 0.425 units (using velocityScaling = 0.5)
  /// - Final tolerance: min(1.0 + 0.425, 5.0) = 1.425 units (capped at maxTolerance)
  /// - Bodies are considered "same" if their positions differ by less than 1.425 units
  ///
  /// This ensures continuous tracking of the same physical bodies even when their
  /// object representations change, which is critical for maintaining smooth camera
  /// transitions and avoiding jarring perspective changes in dramatic scenarios.
  bool _isSameBodiesPair(Body body1, Body body2, Body tracked1, Body tracked2) {
    // Compare by position similarity since body objects can change during mergers
    // Use velocity-aware tolerance that adapts based on bodies' speeds

    // Step 1: Extract velocity magnitudes for all four bodies
    final velocityMagnitude1 = body1.velocity.length;
    final velocityMagnitude2 = body2.velocity.length;
    final trackedVelocityMagnitude1 = tracked1.velocity.length;
    final trackedVelocityMagnitude2 = tracked2.velocity.length;

    // Step 2: Calculate average velocity magnitude for the entire body pair
    // This represents the overall motion intensity of the tracked system
    final avgVelocity =
        (velocityMagnitude1 + velocityMagnitude2 + trackedVelocityMagnitude1 + trackedVelocityMagnitude2) / 4.0;

    // Step 3: Calculate adaptive tolerance using velocity-aware formula
    // Formula: tolerance = base + (avgVelocity * scaling), capped at maximum
    // - Base tolerance: minimum matching precision for slow-moving bodies
    // - Velocity component: additional tolerance proportional to motion speed
    // - Maximum cap: prevents tolerance from becoming too lenient for very fast bodies
    final adaptiveTolerance = math.min(
      RenderingConstants.bodyMatchingBaseTolerance + (avgVelocity * RenderingConstants.bodyMatchingVelocityScaling),
      RenderingConstants.bodyMatchingMaxTolerance,
    );

    // Step 4: Extract current positions for distance comparison
    final pos1 = body1.position;
    final pos2 = body2.position;
    final trackedPos1 = tracked1.position;
    final trackedPos2 = tracked2.position;

    // Step 5: Check both possible body correspondence patterns
    // Pattern 1: body1↔tracked1 AND body2↔tracked2 (same order)
    final match1 = (pos1 - trackedPos1).length < adaptiveTolerance && (pos2 - trackedPos2).length < adaptiveTolerance;

    // Pattern 2: body1↔tracked2 AND body2↔tracked1 (swapped order)
    // This handles cases where body indices may have been reordered during simulation updates
    final match2 = (pos1 - trackedPos2).length < adaptiveTolerance && (pos2 - trackedPos1).length < adaptiveTolerance;

    // Step 6: Return true if either correspondence pattern matches
    return match1 || match2;
  }
}
