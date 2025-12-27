import 'package:vector_math/vector_math_64.dart' as vm;

/// A lightweight serializable representation of camera state for network sync
///
/// Contains the essential camera properties needed to reconstruct the
/// host's camera view for live session viewers when camera sync is enabled.
///
/// Example usage:
/// ```dart
/// // Serialize camera state for transmission
/// final snapshot = CameraSnapshot.fromCameraState(cameraState);
/// final map = snapshot.toMap();
///
/// // Reconstruct from received data
/// final restored = CameraSnapshot.fromMap(map);
/// ```
class CameraSnapshot {
  /// Yaw rotation (horizontal rotation)
  final double yaw;

  /// Pitch rotation (vertical rotation)
  final double pitch;

  /// Roll rotation (tilt)
  final double roll;

  /// Camera distance from target
  final double distance;

  /// Camera target position
  final vm.Vector3 target;

  /// Whether follow mode is enabled
  final bool followMode;

  /// Index of the followed body (if following)
  final int? followedBodyIndex;

  /// Selected body index (for highlighting)
  final int? selectedBody;

  /// Whether auto-rotate is enabled
  final bool autoRotate;

  /// Field of view in degrees
  final double fieldOfView;

  /// Creates a new [CameraSnapshot] instance
  const CameraSnapshot({
    required this.yaw,
    required this.pitch,
    required this.roll,
    required this.distance,
    required this.target,
    required this.followMode,
    this.followedBodyIndex,
    this.selectedBody,
    required this.autoRotate,
    required this.fieldOfView,
  });

  /// Create a snapshot from a database map
  factory CameraSnapshot.fromMap(Map<String, dynamic> map) {
    return CameraSnapshot(
      yaw: (map['yaw'] as num?)?.toDouble() ?? 0.6,
      pitch: (map['pitch'] as num?)?.toDouble() ?? 0.3,
      roll: (map['roll'] as num?)?.toDouble() ?? 0.0,
      distance: (map['distance'] as num?)?.toDouble() ?? 300.0,
      target: _vector3FromList(map['target']),
      followMode: map['followMode'] as bool? ?? false,
      followedBodyIndex: map['followedBodyIndex'] as int?,
      selectedBody: map['selectedBody'] as int?,
      autoRotate: map['autoRotate'] as bool? ?? false,
      fieldOfView: (map['fieldOfView'] as num?)?.toDouble() ?? 60.0,
    );
  }

  /// Convert to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'yaw': yaw,
      'pitch': pitch,
      'roll': roll,
      'distance': distance,
      'target': [target.x, target.y, target.z],
      'followMode': followMode,
      if (followedBodyIndex != null) 'followedBodyIndex': followedBodyIndex,
      if (selectedBody != null) 'selectedBody': selectedBody,
      'autoRotate': autoRotate,
      'fieldOfView': fieldOfView,
    };
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
  String toString() =>
      'CameraSnapshot(yaw: $yaw, pitch: $pitch, distance: $distance, '
      'followMode: $followMode)';
}
