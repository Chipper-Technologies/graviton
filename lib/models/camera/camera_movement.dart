import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/core/enums/camera_movement_type.dart';

/// Camera movement instructions for smooth transitions
class CameraMovement {
  final vm.Vector3 startPosition;
  final vm.Vector3 endPosition;
  final vm.Vector3 startTarget;
  final vm.Vector3 endTarget;
  final double duration;
  final CameraMovementType type;

  const CameraMovement({
    required this.startPosition,
    required this.endPosition,
    required this.startTarget,
    required this.endTarget,
    required this.duration,
    required this.type,
  });
}
