import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/scenario_config.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Manages camera and 3D view state
class CameraState extends ChangeNotifier {
  double _yaw = 0.6; // Default camera angles for most scenarios
  double _pitch = 0.3;
  double _roll = 0.0;
  double _distance = 300.0; // Default distance for most scenarios
  vm.Vector3 _target = vm.Vector3.zero();
  int? _selectedBody;
  bool _autoRotate = false;
  double _autoRotateSpeed = 0.2;

  // Follow object mode
  bool _followMode = false;
  int? _followedBodyIndex;
  double _followDistance = 15.0; // Close follow distance

  // Camera controls
  bool _invertPitch = false; // Toggle to invert pitch controls

  // Getters
  double get yaw => _yaw;
  double get pitch => _pitch;
  double get roll => _roll;
  double get distance => _distance;
  vm.Vector3 get target => _target;
  int? get selectedBody => _selectedBody;
  bool get autoRotate => _autoRotate;
  double get autoRotateSpeed => _autoRotateSpeed;
  bool get followMode => _followMode;
  int? get followedBodyIndex => _followedBodyIndex;
  double get followDistance => _followDistance;
  bool get invertPitch => _invertPitch;

  vm.Vector3 get eyePosition {
    final cp = math.cos(_pitch);
    final sp = math.sin(_pitch);
    final cy = math.cos(_yaw);
    final sy = math.sin(_yaw);
    final dir = vm.Vector3(cp * sy, sp, cp * cy);
    return _target + dir * _distance;
  }

  // Camera controls
  void rotate(double deltaYaw, double deltaPitch) {
    _yaw += deltaYaw;
    // Apply pitch inversion if enabled
    _pitch += _invertPitch ? -deltaPitch : deltaPitch;

    // In follow mode, maintain the follow distance
    if (_followMode) {
      _distance = _followDistance;
    }

    notifyListeners();
  }

  void rotateRoll(double deltaRoll) {
    _roll += deltaRoll;

    // Normalize roll to keep it within reasonable bounds
    _roll = _roll % (2 * math.pi);
    notifyListeners();
  }

  void zoom(double delta) {
    if (_followMode) {
      // In follow mode, adjust follow distance instead of regular distance
      _followDistance = (_followDistance * (1 + delta)).clamp(5.0, 100.0);
      _distance = _followDistance;
    } else {
      // Increased max zoom to 2000.0 to view entire solar system (Neptune at ~1505)
      _distance = (_distance * (1 + delta)).clamp(5.0, 2000.0);
    }

    notifyListeners();
  }

  /// Enhanced zoom that considers selected body for better focus
  void zoomTowardBody(double delta, List<Body> bodies) {
    if (_selectedBody != null && _selectedBody! >= 0 && _selectedBody! < bodies.length) {
      // If a body is selected, smoothly adjust target toward that body while zooming
      final selectedBodyPosition = bodies[_selectedBody!].position;
      final zoomStrength = (delta < 0 ? -delta : delta).clamp(0.0, 0.3); // Increased adjustment strength

      // Interpolate target toward selected body (more aggressively when zooming in)
      final targetWeight = delta < 0 ? zoomStrength * 3.0 : zoomStrength * 1.5; // Zoom in = more focus
      _target = _target * (1.0 - targetWeight) + selectedBodyPosition * targetWeight;
    }

    // Apply the zoom
    zoom(delta);
  }

  void pan(vm.Vector3 delta) {
    _target += delta;
    notifyListeners();
  }

  void setTarget(vm.Vector3 newTarget) {
    _target = newTarget;
    notifyListeners();
  }

  void selectBody(int? bodyIndex) {
    _selectedBody = bodyIndex;
    FirebaseService.instance.logUIEvent('body_selected', element: 'camera', value: bodyIndex?.toString() ?? 'none');
    notifyListeners();
  }

  void focusOnBody(int bodyIndex, List<Body> bodies) {
    if (bodyIndex >= 0 && bodyIndex < bodies.length) {
      _target = bodies[bodyIndex].position.clone();
      _selectedBody = bodyIndex;
      FirebaseService.instance.logUIEvent('camera_focus', element: 'body', value: bodyIndex.toString());
      notifyListeners();
    }
  }

  /// Find and focus on the nearest body to the current camera target
  void focusOnNearestBody(List<Body> bodies) {
    if (bodies.isEmpty) return;

    int nearestIndex = 0;
    double nearestDistance = (_target - bodies[0].position).length;

    for (int i = 1; i < bodies.length; i++) {
      final distance = (_target - bodies[i].position).length;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestIndex = i;
      }
    }

    focusOnBody(nearestIndex, bodies);
  }

  /// Toggle follow mode for the currently selected body
  void toggleFollowMode(List<Body> bodies) {
    if (_selectedBody != null && _selectedBody! >= 0 && _selectedBody! < bodies.length) {
      _followMode = !_followMode;

      if (_followMode) {
        _followedBodyIndex = _selectedBody;
        _distance = _followDistance; // Set close follow distance
        updateFollowTarget(bodies); // Initial target update
        FirebaseService.instance.logUIEvent(
          'follow_mode_enabled',
          element: 'camera_controls',
          value: _selectedBody.toString(),
        );
      } else {
        _followedBodyIndex = null;
        // Reset to a reasonable distance when stopping follow mode
        _distance = 600.0;
        // Clear selection when unfollowing to prevent object dragging
        _selectedBody = null;
        FirebaseService.instance.logUIEvent('follow_mode_disabled', element: 'camera_controls');
      }

      notifyListeners();
    }
  }

  /// Set which body to follow (enables follow mode)
  void setFollowBody(int bodyIndex, List<Body> bodies) {
    if (bodyIndex >= 0 && bodyIndex < bodies.length) {
      _followMode = true;
      _followedBodyIndex = bodyIndex;
      _selectedBody = bodyIndex;
      _distance = _followDistance;
      updateFollowTarget(bodies);
      notifyListeners();
    }
  }

  /// Disable follow mode
  void stopFollowing() {
    _followMode = false;
    _followedBodyIndex = null;
    notifyListeners();
  }

  /// Update camera target to follow the tracked body (called each frame)
  void updateFollowTarget(List<Body> bodies) {
    if (_followMode && _followedBodyIndex != null && _followedBodyIndex! >= 0 && _followedBodyIndex! < bodies.length) {
      _target = bodies[_followedBodyIndex!].position.clone();
    }
  }

  void resetView([ScenarioType? scenario]) {
    if (scenario == ScenarioType.galaxyFormation) {
      // Special camera settings for galaxy formation
      _yaw = 0.77; // Perfect yaw for horizontal galaxy view
      _pitch = -0.89; // Perfect pitch for horizontal galaxy view
      _roll = 0.0; // No roll - keep normal touch controls
      _distance = 600.0; // Galaxy viewing distance
    } else if (scenario == ScenarioType.solarSystem) {
      // Custom camera settings for solar system
      _yaw = 0.82;
      _pitch = 0.41;
      _roll = 5.90;
      _distance = 1200.0; // Solar system viewing distance
    } else {
      // Default camera settings for other scenarios or when scenario is null
      _yaw = 0.6;
      _pitch = 0.3;
      _roll = 0.0;
      _distance = 300.0; // Default distance
    }

    _target = vm.Vector3.zero(); // Look at center
    _selectedBody = null;
    _autoRotate = false;
    _followMode = false;
    _followedBodyIndex = null;
    FirebaseService.instance.logUIEvent('camera_reset', element: 'camera_controls');
    notifyListeners();
  }

  /// Reset view with optimal zoom for a specific scenario
  void resetViewForScenario(ScenarioType scenario, List<Body> bodies) {
    // Special camera settings for galaxy formation
    if (scenario == ScenarioType.galaxyFormation) {
      _yaw = 0.77; // Perfect yaw for horizontal galaxy view
      _pitch = -0.89; // Perfect pitch for horizontal galaxy view
      _roll = 0.0; // No roll - keep normal touch controls
    } else if (scenario == ScenarioType.solarSystem) {
      // Custom camera settings for solar system
      _yaw = 0.82;
      _pitch = 0.41;
      _roll = 5.90;
    } else {
      // Default angles for other scenarios
      _yaw = 0.6;
      _pitch = 0.3;
      _roll = 0.0;
    }

    _target = _calculateOptimalTarget(bodies);
    _distance = _calculateOptimalDistance(scenario, bodies);
    _selectedBody = null;
    _autoRotate = false;
    _followMode = false;
    _followedBodyIndex = null;
    FirebaseService.instance.logUIEvent('camera_auto_zoom', element: 'scenario', value: scenario.name);
    notifyListeners();
  }

  /// Calculate optimal camera distance to fit all bodies in view
  double _calculateOptimalDistance(ScenarioType scenario, List<Body> bodies) {
    if (bodies.isEmpty) return 50.0;

    // Check if scenario has a fixed optimal distance
    final config = ScenarioConfig.defaults[scenario];
    if (config?.optimalCameraDistance != null) {
      return config!.optimalCameraDistance!;
    }

    // Auto-calculate distance based on body positions
    final boundingRadius = _calculateBoundingRadius(bodies);
    final multiplier = config?.cameraDistanceMultiplier ?? 1.2;

    // Calculate distance needed to fit bounding sphere in view
    // Assumes ~60° field of view, so distance = radius / tan(30°)
    final optimalDistance = (boundingRadius * multiplier) / math.tan(math.pi / 6);

    // Clamp to reasonable bounds
    return optimalDistance.clamp(20.0, 2000.0);
  }

  /// Calculate optimal camera target (center of mass or geometric center)
  vm.Vector3 _calculateOptimalTarget(List<Body> bodies) {
    if (bodies.isEmpty) return vm.Vector3.zero();

    // Calculate center of mass
    vm.Vector3 centerOfMass = vm.Vector3.zero();
    double totalMass = 0.0;

    for (final body in bodies) {
      centerOfMass += body.position * body.mass;
      totalMass += body.mass;
    }

    if (totalMass > 0) {
      centerOfMass /= totalMass;
      return centerOfMass;
    }

    // Fallback to geometric center
    vm.Vector3 geometricCenter = vm.Vector3.zero();
    for (final body in bodies) {
      geometricCenter += body.position;
    }

    return geometricCenter / bodies.length.toDouble();
  }

  /// Calculate the radius of the smallest sphere that contains all bodies
  double _calculateBoundingRadius(List<Body> bodies) {
    if (bodies.isEmpty) return 10.0;

    final center = _calculateOptimalTarget(bodies);
    double maxDistance = 0.0;

    for (final body in bodies) {
      final distance = (body.position - center).length + body.radius;
      maxDistance = math.max(maxDistance, distance);
    }

    return math.max(maxDistance, 10.0); // Minimum radius of 10
  }

  void toggleAutoRotate() {
    _autoRotate = !_autoRotate;

    FirebaseService.instance.logUIEvent(
      'auto_rotate_toggle',
      element: 'camera_controls',
      value: _autoRotate.toString(),
    );

    notifyListeners();
  }

  void toggleInvertPitch() {
    _invertPitch = !_invertPitch;

    FirebaseService.instance.logUIEvent(
      'invert_pitch_toggle',
      element: 'camera_controls',
      value: _invertPitch.toString(),
    );

    notifyListeners();
  }

  void setAutoRotateSpeed(double speed) {
    _autoRotateSpeed = speed.clamp(0.1, 2.0);
    notifyListeners();
  }

  void updateAutoRotation(double deltaTime) {
    if (_autoRotate) {
      _yaw += _autoRotateSpeed * deltaTime;

      // In follow mode, maintain the follow distance during auto-rotation
      if (_followMode) {
        _distance = _followDistance;
      }

      notifyListeners();
    }
  }
}
