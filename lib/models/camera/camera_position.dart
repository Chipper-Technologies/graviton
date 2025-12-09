/// Camera position for screenshot presets
class CameraPosition {
  final double distance;
  final double yaw;
  final double pitch;
  final double roll;
  final double targetX;
  final double targetY;
  final double targetZ;

  const CameraPosition({
    required this.distance,
    this.yaw = 0.0,
    this.pitch = 0.0,
    this.roll = 0.0,
    this.targetX = 0.0,
    this.targetY = 0.0,
    this.targetZ = 0.0,
  });
}
