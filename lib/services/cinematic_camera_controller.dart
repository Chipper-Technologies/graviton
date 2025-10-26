import 'dart:math' as math;

import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/orbital_event.dart';
import 'package:graviton/services/orbital_prediction_engine.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/state/simulation_state.dart';
import 'package:graviton/state/ui_state.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Controller for cinematic camera techniques
///
/// This service orchestrates different AI-driven camera behaviors based on
/// the selected technique in the UI. It bridges the gap between technique
/// selection and actual camera movement.
class CinematicCameraController {
  final OrbitalPredictionEngine _predictionEngine = OrbitalPredictionEngine();

  // Predictive orbital state
  List<OrbitalEvent> _trackedEvents = [];
  OrbitalEvent? _currentTargetEvent;
  DateTime _lastPredictionUpdate = DateTime.now();
  static const Duration _predictionUpdateInterval = Duration(seconds: 2);

  // Camera transition state
  vm.Vector3? _targetLookAt;

  // Dynamic rotation state
  double _orbitTime = 0.0;
  double _orbitSpeed = 0.3; // Radians per second for orbital rotation
  double _verticalOscillation = 0.0;

  // Movement variation
  double _directionChangeTime = 0.0;
  double _currentOrbitDirection = 1.0; // 1.0 or -1.0 for different directions

  // Camera angle state for smooth transitions
  double _currentCameraYaw = 0.0;
  double _currentCameraPitch = 0.2;
  double _currentCameraRoll = 0.0;
  double _currentCameraDistance = 100.0;

  // Intelligent framing state
  List<Body> _currentFramedBodies = [];
  double _framingTransitionTime = 0.0;
  vm.Vector3 _previousCenter = vm.Vector3.zero();
  double _previousDistance = 100.0;
  bool _isTransitioning = false;
  double _transitionProgress = 0.0;

  // Multi-body framing state
  bool _isFramingMultipleBodies = false;
  List<Body> _allInterestingBodies = [];
  double _multiBodyFramingTime = 0.0;

  // Target locking state
  static const double _minTargetLockTime =
      15.0; // Minimum 15 seconds on each target
  List<Body>?
  _nextTargetBodies; // Queue the next target instead of switching immediately
  bool _hasQueuedTarget = false;
  double _lastTargetSwitchTime = 0.0; // Track when we last switched targets
  double _globalTime = 0.0; // Global timer that never resets

  /// Update camera based on selected technique
  void updateCamera(
    CinematicCameraTechnique technique,
    SimulationState simulation,
    CameraState camera,
    UIState ui,
    double deltaTime,
  ) {
    // Update global timer
    _globalTime += deltaTime;

    // Only apply cinematic techniques if simulation is running and has bodies
    if (!simulation.isRunning || simulation.bodies.isEmpty) {
      return;
    }

    switch (technique) {
      case CinematicCameraTechnique.manual:
        // Manual mode - do nothing, let user control camera
        break;

      case CinematicCameraTechnique.predictiveOrbital:
        _handlePredictiveOrbital(simulation, camera, deltaTime);
        break;

      case CinematicCameraTechnique.dynamicFraming:
        _handleDynamicFraming(simulation, camera, deltaTime);
        break;

      case CinematicCameraTechnique.physicsAware:
        _handlePhysicsAware(simulation, camera, deltaTime);
        break;

      case CinematicCameraTechnique.contextualShots:
        _handleContextualShots(simulation, camera, deltaTime);
        break;

      case CinematicCameraTechnique.emotionalPacing:
        _handleEmotionalPacing(simulation, camera, deltaTime);
        break;
    }
  }

  /// Handle predictive orbital camera technique
  void _handlePredictiveOrbital(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
  ) {
    // Get orbital predictions
    const timeFrame = 10.0;
    const timeStep = 0.1;
    final predictions = _predictionEngine.predictFuturePositions(
      simulation.bodies,
      timeFrame,
      timeStep: timeStep,
    );

    // Detect events using predictions
    final config = PredictiveOrbitalConfig.forScenario('three_body');
    final events = _predictionEngine.detectEvents(
      simulation.bodies,
      predictions,
      timeStep,
      config,
    );

    if (events.isNotEmpty) {
      // Focus on the most imminent dramatic event
      final targetEvent = events.first;

      if (_currentTargetEvent != targetEvent) {
        _currentTargetEvent = targetEvent;
      }

      if (_currentTargetEvent != null) {
        _updateCameraForEvent(
          simulation,
          camera,
          _currentTargetEvent!,
          deltaTime,
        );
      }
    } else {
      // No specific events - intelligently frame multiple bodies
      _updateIntelligentFraming(simulation, camera, deltaTime);
    }
  }

  /// Update camera to focus on a specific orbital event
  void _updateCameraForEvent(
    SimulationState simulation,
    CameraState camera,
    OrbitalEvent event,
    double deltaTime,
  ) {
    // Get the bodies involved in this event
    final involvedBodies = event.involvedBodies
        .where((index) => index < simulation.bodies.length)
        .map((index) => simulation.bodies[index])
        .toList();

    if (involvedBodies.isNotEmpty) {
      _updateCameraForBodies(involvedBodies, camera, deltaTime);
    }
  }

  /// Intelligently frame multiple bodies with dynamic movement
  void _updateIntelligentFraming(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
  ) {
    final bodies = simulation.bodies;
    if (bodies.length < 2) {
      return;
    }

    // Find all interesting body pairs and check for conflicts
    final allInterestingPairs = _findAllInterestingPairs(bodies);
    final topPair = _getBestTargetBodies(
      bodies,
    ); // Use queued target if available

    // Check if there are multiple competing interesting pairs
    final shouldFrameMultiple = _shouldFrameMultipleBodies(
      allInterestingPairs,
      topPair,
    );

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

        double maxDist = 0.0;
        for (final body in _currentFramedBodies) {
          final distance = (body.position - currentCenter).length;
          maxDist = math.max(maxDist, distance);
        }
        _previousDistance = math.max(maxDist * 3.0, 25.0);
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
        if (_shouldUpdateFramedBodies(topPair)) {
          _isTransitioning = true;
          _transitionProgress = 0.0;

          // Store current multi-body state for transition
          vm.Vector3 currentCenter = vm.Vector3.zero();
          for (final body in _allInterestingBodies) {
            currentCenter += body.position;
          }
          currentCenter /= _allInterestingBodies.length.toDouble();
          _previousCenter = currentCenter;

          double maxDist = 0.0;
          for (final body in _allInterestingBodies) {
            final distance = (body.position - currentCenter).length;
            maxDist = math.max(maxDist, distance);
          }
          _previousDistance = math.max(maxDist * 3.0, 25.0);

          _currentFramedBodies = topPair;
          _framingTransitionTime = 0.0;

          // Clear queued target since we're switching
          _hasQueuedTarget = false;
          _nextTargetBodies = null;
        }
      }
    } else if (!_isFramingMultipleBodies) {
      // Normal pair-based framing with target locking
      // Check if we should switch targets based on current framed bodies vs new candidates
      final candidateBodies = _findMostInterestingBodies(bodies);

      if (_shouldUpdateFramedBodies(candidateBodies)) {
        // Determine which target to switch to BEFORE starting transition
        final targetBodies = _hasQueuedTarget && _nextTargetBodies != null
            ? _nextTargetBodies!
            : candidateBodies;

        _isTransitioning = true;
        _transitionProgress = 0.0;

        if (_currentFramedBodies.isNotEmpty) {
          vm.Vector3 currentCenter = vm.Vector3.zero();
          for (final body in _currentFramedBodies) {
            currentCenter += body.position;
          }
          currentCenter /= _currentFramedBodies.length.toDouble();
          _previousCenter = currentCenter;

          double maxDist = 0.0;
          for (final body in _currentFramedBodies) {
            final distance = (body.position - currentCenter).length;
            maxDist = math.max(maxDist, distance);
          }
          _previousDistance = math.max(maxDist * 3.0, 25.0);

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

        // Update to new target atomically
        _currentFramedBodies = targetBodies;
        _framingTransitionTime = 0.0;

        // Clear queued target since we're switching to it
        _hasQueuedTarget = false;
        _nextTargetBodies = null;
      }
    }

    _framingTransitionTime += deltaTime;
    if (_isFramingMultipleBodies) {
      _multiBodyFramingTime += deltaTime;
    }

    // Handle transitions
    if (_isTransitioning) {
      _transitionProgress +=
          deltaTime *
          0.25; // Slower 4 second transitions for more graceful movement
      if (_transitionProgress >= 1.0) {
        _isTransitioning = false;
        _transitionProgress = 1.0;
      }
    }

    // Update camera based on current mode
    final bodiesToFrame = _isFramingMultipleBodies
        ? _allInterestingBodies
        : _currentFramedBodies;

    // Only update camera if we have bodies to frame and we're not in an inconsistent state
    if (bodiesToFrame.isNotEmpty) {
      _updateCameraForBodies(bodiesToFrame, camera, deltaTime);
    }
  }

  /// Find the most interesting pair of bodies to focus on
  List<Body> _findMostInterestingBodies(List<Body> bodies) {
    if (bodies.length == 2) {
      return bodies;
    }

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
            ((_currentFramedBodies.contains(body1) &&
                _currentFramedBodies.contains(body2)))) {
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

  /// Check if we should update the currently framed bodies with target locking
  bool _shouldUpdateFramedBodies(List<Body> candidateBodies) {
    if (_currentFramedBodies.isEmpty) {
      if (candidateBodies.isNotEmpty) {
        print(
          '🎥 Initial target selection at time ${_globalTime.toStringAsFixed(1)}s',
        );
        _lastTargetSwitchTime = _globalTime;
      }
      return true;
    }
    if (_isTransitioning) return false; // Don't switch during transitions
    if (_isFramingMultipleBodies)
      return false; // Don't switch during multi-body framing

    // Calculate time since last target switch using global timer
    final timeSinceSwitch = _globalTime - _lastTargetSwitchTime;

    // Check if we have a queued target that's ready to be used
    if (_hasQueuedTarget &&
        _nextTargetBodies != null &&
        timeSinceSwitch >= _minTargetLockTime) {
      // Time to switch to the queued target
      print(
        '🎥 Switching to queued target after ${timeSinceSwitch.toStringAsFixed(1)}s',
      );
      _lastTargetSwitchTime = _globalTime;
      return true;
    }

    // Force minimum lock time - no switching allowed during this period
    if (timeSinceSwitch < _minTargetLockTime) {
      // During lock time, queue up better targets for later (only consider candidate bodies)
      final currentScore = _scoreBodiesPair(
        _currentFramedBodies[0],
        _currentFramedBodies[1],
        [],
      );
      final candidateScore = _scoreBodiesPair(
        candidateBodies[0],
        candidateBodies[1],
        [],
      );

      if (candidateScore > currentScore * 1.3 && !_hasQueuedTarget) {
        // 30% better
        print(
          '🎥 Queuing better target (${(candidateScore / currentScore * 100).toStringAsFixed(0)}% of current) - ${(_minTargetLockTime - timeSinceSwitch).toStringAsFixed(1)}s remaining',
        );
        _nextTargetBodies = candidateBodies;
        _hasQueuedTarget = true;
      }
      return false; // Don't switch yet
    }

    // If no queued target and enough time has passed, check if candidate is dramatically better
    if (!_hasQueuedTarget) {
      final currentScore = _scoreBodiesPair(
        _currentFramedBodies[0],
        _currentFramedBodies[1],
        [],
      );
      final candidateScore = _scoreBodiesPair(
        candidateBodies[0],
        candidateBodies[1],
        [],
      );

      if (candidateScore > currentScore * 1.8) {
        // 80% better to switch without queue
        print(
          '🎥 Immediate switch due to 80% better score after ${timeSinceSwitch.toStringAsFixed(1)}s',
        );
        _lastTargetSwitchTime = _globalTime;
        return true;
      }
    }

    return false;
  }

  /// Get the best target bodies (does not consider timing - just finds best available)
  List<Body> _getBestTargetBodies(List<Body> bodies) {
    // Always return the best available target, timing is handled elsewhere
    return _findMostInterestingBodies(bodies);
  }

  /// Update camera to optimally frame a set of bodies
  void _updateCameraForBodies(
    List<Body> bodies,
    CameraState camera,
    double deltaTime,
  ) {
    if (bodies.isEmpty) return;

    // Calculate the target center point and distance
    vm.Vector3 targetCenter = vm.Vector3.zero();
    for (final body in bodies) {
      targetCenter += body.position;
    }
    targetCenter /= bodies.length.toDouble();

    // Find the maximum distance from center
    double maxDistance = 0.0;
    for (final body in bodies) {
      final distance = (body.position - targetCenter).length;
      maxDistance = math.max(maxDistance, distance);
    }

    // Calculate optimal camera distance to frame all bodies
    final targetOptimalDistance = math.max(maxDistance * 3.0, 25.0);

    // Update orbit time and direction changes (for target calculation)
    _orbitTime += deltaTime * _orbitSpeed * _currentOrbitDirection;
    _verticalOscillation += deltaTime * 0.6;
    _directionChangeTime += deltaTime;

    // Occasionally change direction for more natural movement
    if (_directionChangeTime > 10.0 + math.Random().nextDouble() * 6.0) {
      _currentOrbitDirection *= -1.0;
      _directionChangeTime = 0.0;
      _orbitSpeed = 0.15 + math.Random().nextDouble() * 0.3;
    }

    // Calculate target camera parameters with natural variation
    final baseRadius = targetOptimalDistance;
    final radiusVariation = 1.0 + math.sin(_orbitTime * 0.4) * 0.3;
    final targetRadius = baseRadius * radiusVariation;

    final pitchVariation = math.sin(_verticalOscillation) * 0.6;
    final targetPitch = 0.2 + pitchVariation;
    final targetYaw = _orbitTime;
    final targetRoll = math.sin(_orbitTime * 0.3) * 0.1;

    // Use smooth transition for both position and camera angles
    vm.Vector3 center;
    double optimalDistance;
    double currentYaw;
    double currentPitch;
    double currentRoll;

    if (_isTransitioning && _transitionProgress < 1.0) {
      // Smooth transition between previous and current states
      final t = _easeInOutQuad(_transitionProgress);
      center = _lerpVector3(_previousCenter, targetCenter, t);
      optimalDistance = _lerpDouble(
        _previousDistance,
        targetOptimalDistance,
        t,
      );

      // Smoothly transition camera angles too
      currentYaw = _lerpDouble(_currentCameraYaw, targetYaw, t);
      currentPitch = _lerpDouble(_currentCameraPitch, targetPitch, t);
      currentRoll = _lerpDouble(_currentCameraRoll, targetRoll, t);

      // Update current values for next frame
      _currentCameraYaw = currentYaw;
      _currentCameraPitch = currentPitch;
      _currentCameraRoll = currentRoll;
      _currentCameraDistance = optimalDistance;
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
      _currentCameraDistance = optimalDistance;
    }

    // Apply camera transformation with smooth values
    camera.setCameraParameters(
      yaw: currentYaw,
      pitch: currentPitch,
      roll: currentRoll,
      distance: optimalDistance,
      target: center,
    );
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
  bool _shouldFrameMultipleBodies(
    List<List<Body>> allPairs,
    List<Body> topPair,
  ) {
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
    _trackedEvents.clear();
    _currentTargetEvent = null;
    _targetLookAt = null;
    _orbitTime = 0.0;
    _verticalOscillation = 0.0;
    _currentFramedBodies.clear();
    _framingTransitionTime = 0.0;
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
    _currentCameraDistance = 100.0;
    _hasQueuedTarget = false;
    _nextTargetBodies = null;
    _lastTargetSwitchTime = 0.0;
    _globalTime = 0.0;
  }

  /// Placeholder implementations for other techniques
  void _handleDynamicFraming(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
  ) {
    // TODO: Implement dynamic framing - adjusts FOV and distance based on scene content
  }

  void _handlePhysicsAware(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
  ) {
    // TODO: Implement physics-aware camera - follows physics principles for movement
  }

  void _handleContextualShots(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
  ) {
    // TODO: Implement contextual shots - AI chooses optimal angles based on simulation state
  }

  void _handleEmotionalPacing(
    SimulationState simulation,
    CameraState camera,
    double deltaTime,
  ) {
    // TODO: Implement emotional pacing - adjusts camera speed based on simulation tension
  }

  /// Utility functions for smooth transitions

  /// Quadratic ease-in-out function for smooth transitions
  double _easeInOutQuad(double t) {
    return t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;
  }

  /// Linear interpolation between two Vector3 points
  vm.Vector3 _lerpVector3(vm.Vector3 a, vm.Vector3 b, double t) {
    return a + (b - a) * t;
  }

  /// Linear interpolation between two double values
  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
