import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/models/firebase/camera_snapshot.dart';

/// A lightweight serializable representation of a [Body] for network sync
///
/// Contains only the essential properties needed to reconstruct body state
/// for live session viewing. Visual-only properties like trail data are
/// not included to minimize bandwidth.
///
/// Example usage:
/// ```dart
/// // Serialize a body for transmission
/// final snapshot = BodySnapshot.fromBody(body);
/// final map = snapshot.toMap();
///
/// // Reconstruct from received data
/// final restored = BodySnapshot.fromMap(map);
/// restored.applyTo(body);
/// ```
class BodySnapshot {
  /// Body name (used as identifier)
  final String name;

  /// Position in 3D space
  final vm.Vector3 position;

  /// Velocity vector
  final vm.Vector3 velocity;

  /// Mass of the body
  final double mass;

  /// Visual radius
  final double radius;

  /// Display color (as int value)
  final int colorValue;

  /// Whether this is a planet (vs star/moon)
  final bool isPlanet;

  /// Type of celestial body
  final BodyType bodyType;

  /// Stellar luminosity (for stars)
  final double stellarLuminosity;

  /// Current habitability status
  final HabitabilityStatus habitabilityStatus;

  /// Surface temperature in Kelvin
  final double temperature;

  /// Creates a new [BodySnapshot] instance
  const BodySnapshot({
    required this.name,
    required this.position,
    required this.velocity,
    required this.mass,
    required this.radius,
    required this.colorValue,
    required this.isPlanet,
    required this.bodyType,
    required this.stellarLuminosity,
    required this.habitabilityStatus,
    required this.temperature,
  });

  /// Create a snapshot from a [Body] instance
  factory BodySnapshot.fromBody(Body body) {
    return BodySnapshot(
      name: body.name,
      position: body.position.clone(),
      velocity: body.velocity.clone(),
      mass: body.mass,
      radius: body.radius,
      colorValue: body.color.toARGB32(),
      isPlanet: body.isPlanet,
      bodyType: body.bodyType,
      stellarLuminosity: body.stellarLuminosity,
      habitabilityStatus: body.habitabilityStatus,
      temperature: body.temperature,
    );
  }

  /// Create a snapshot from a database map
  factory BodySnapshot.fromMap(Map<String, dynamic> map) {
    return BodySnapshot(
      name: map['name'] as String? ?? '',
      position: _vector3FromList(map['position']),
      velocity: _vector3FromList(map['velocity']),
      mass: (map['mass'] as num?)?.toDouble() ?? 1.0,
      radius: (map['radius'] as num?)?.toDouble() ?? 10.0,
      colorValue: map['colorValue'] as int? ?? 0xFFFFFFFF,
      isPlanet: map['isPlanet'] as bool? ?? false,
      bodyType: BodyType.values[map['bodyType'] as int? ?? 0],
      stellarLuminosity: (map['stellarLuminosity'] as num?)?.toDouble() ?? 0.0,
      habitabilityStatus:
          HabitabilityStatus.values[map['habitabilityStatus'] as int? ?? 0],
      temperature: (map['temperature'] as num?)?.toDouble() ?? 273.15,
    );
  }

  /// Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': [position.x, position.y, position.z],
      'velocity': [velocity.x, velocity.y, velocity.z],
      'mass': mass,
      'radius': radius,
      'colorValue': colorValue,
      'isPlanet': isPlanet,
      'bodyType': bodyType.index,
      'stellarLuminosity': stellarLuminosity,
      'habitabilityStatus': habitabilityStatus.index,
      'temperature': temperature,
    };
  }

  /// Apply this snapshot's state to an existing [Body]
  ///
  /// Updates position, velocity, and other dynamic properties.
  void applyTo(Body body) {
    body.position.setFrom(position);
    body.velocity.setFrom(velocity);
    body.mass = mass;
    body.radius = radius;
    body.color = Color(colorValue);
    body.isPlanet = isPlanet;
    body.bodyType = bodyType;
    body.stellarLuminosity = stellarLuminosity;
    body.habitabilityStatus = habitabilityStatus;
    body.temperature = temperature;
  }

  /// Create a new [Body] from this snapshot
  Body toBody() {
    return Body(
      name: name,
      position: position.clone(),
      velocity: velocity.clone(),
      mass: mass,
      radius: radius,
      color: Color(colorValue),
      isPlanet: isPlanet,
      bodyType: bodyType,
      stellarLuminosity: stellarLuminosity,
      habitabilityStatus: habitabilityStatus,
      temperature: temperature,
    );
  }

  static vm.Vector3 _vector3FromList(dynamic list) {
    if (list is List && list.length >= 3) {
      return vm.Vector3(
        (list[0] as num).toDouble(),
        (list[1] as num).toDouble(),
        (list[2] as num).toDouble(),
      );
    }
    return vm.Vector3.zero();
  }

  @override
  String toString() => 'BodySnapshot(name: $name, pos: $position)';
}

/// A complete snapshot of simulation state for network sync
///
/// Contains all body states plus simulation parameters needed to
/// reconstruct the simulation view for live session viewers.
///
/// Example usage:
/// ```dart
/// // Create snapshot from current simulation
/// final snapshot = SimulationSnapshot.fromSimulation(
///   bodies: simulationState.bodies,
///   isRunning: simulationState.isRunning,
///   timeScale: simulationState.timeScale,
///   totalTime: simulationState.totalTime,
/// );
///
/// // Serialize for transmission
/// final map = snapshot.toMap();
///
/// // Reconstruct on viewer side
/// final restored = SimulationSnapshot.fromMap(map);
/// ```
class SimulationSnapshot {
  /// List of body snapshots
  final List<BodySnapshot> bodies;

  /// Whether the simulation is currently running
  final bool isRunning;

  /// Current time scale
  final double timeScale;

  /// Total simulation time elapsed
  final double totalTime;

  /// Step count
  final int stepCount;

  /// Timestamp when snapshot was taken
  final DateTime timestamp;

  /// Optional camera state for synced viewing
  ///
  /// When provided, viewers will see the host's camera position,
  /// rotation, and follow mode. When null, viewers have free camera control.
  final CameraSnapshot? camera;

  /// Creates a new [SimulationSnapshot] instance
  const SimulationSnapshot({
    required this.bodies,
    required this.isRunning,
    required this.timeScale,
    required this.totalTime,
    required this.stepCount,
    required this.timestamp,
    this.camera,
  });

  /// Create a snapshot from current simulation state
  ///
  /// [camera] Optional camera snapshot for synced viewing.
  /// When provided, viewers will see the host's camera position.
  factory SimulationSnapshot.fromSimulation({
    required List<Body> bodies,
    required bool isRunning,
    required double timeScale,
    required double totalTime,
    required int stepCount,
    CameraSnapshot? camera,
  }) {
    return SimulationSnapshot(
      bodies: bodies.map(BodySnapshot.fromBody).toList(),
      isRunning: isRunning,
      timeScale: timeScale,
      totalTime: totalTime,
      stepCount: stepCount,
      timestamp: DateTime.now(),
      camera: camera,
    );
  }

  /// Create a snapshot from a database map
  factory SimulationSnapshot.fromMap(Map<String, dynamic> map) {
    final bodiesList = map['bodies'] as List<dynamic>? ?? [];
    final cameraData = map['camera'];
    return SimulationSnapshot(
      bodies: bodiesList
          .map((b) => BodySnapshot.fromMap(Map<String, dynamic>.from(b as Map)))
          .toList(),
      isRunning: map['isRunning'] as bool? ?? false,
      timeScale: (map['timeScale'] as num?)?.toDouble() ?? 1.0,
      totalTime: (map['totalTime'] as num?)?.toDouble() ?? 0.0,
      stepCount: map['stepCount'] as int? ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      camera: cameraData != null
          ? CameraSnapshot.fromMap(Map<String, dynamic>.from(cameraData as Map))
          : null,
    );
  }

  /// Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'bodies': bodies.map((b) => b.toMap()).toList(),
      'isRunning': isRunning,
      'timeScale': timeScale,
      'totalTime': totalTime,
      'stepCount': stepCount,
      'timestamp': timestamp.millisecondsSinceEpoch,
      if (camera != null) 'camera': camera!.toMap(),
    };
  }

  /// Check if this snapshot is stale (older than threshold)
  bool isStale({Duration threshold = const Duration(seconds: 5)}) {
    return DateTime.now().difference(timestamp) > threshold;
  }

  /// Whether this snapshot includes camera sync data
  bool get hasCameraSync => camera != null;

  @override
  String toString() =>
      'SimulationSnapshot(bodies: ${bodies.length}, '
      'isRunning: $isRunning, timeScale: $timeScale, '
      'cameraSync: $hasCameraSync)';
}
