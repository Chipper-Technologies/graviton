import 'package:graviton/utils/number_utils.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/core/enums/orbital_event_type.dart';

/// Represents a predicted orbital event that the camera can focus on
class OrbitalEvent {
  final DateTime timestamp;
  final OrbitalEventType type;
  final List<int> involvedBodies;
  final vm.Vector3 eventPosition;
  final vm.Vector3 optimalCameraPosition;
  final double dramaticScore;
  final String description;

  /// Cached string representation to avoid expensive formatting on repeated calls
  String? _cachedToString;

  OrbitalEvent({
    required this.timestamp,
    required this.type,
    required this.involvedBodies,
    required this.eventPosition,
    required this.optimalCameraPosition,
    required this.dramaticScore,
    required this.description,
  });

  @override
  String toString() {
    // Use cached value if available to avoid expensive formatting calls
    _cachedToString ??=
        'OrbitalEvent($type, score: ${NumberUtils.formatDecimal(dramaticScore, 2)}, bodies: $involvedBodies)';
    return _cachedToString!;
  }
}
