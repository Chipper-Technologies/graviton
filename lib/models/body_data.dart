import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';

/// Body data for custom scenarios
class BodyData {
  final String name;
  final List<double> position;
  final List<double> velocity;
  final double mass;
  final double radius;
  final String color;
  final BodyType bodyType;
  final double stellarLuminosity;
  final double temperature;
  final bool showGravityWell;
  final bool isPlanet;
  final HabitabilityStatus habitabilityStatus;

  const BodyData({
    required this.name,
    required this.position,
    required this.velocity,
    required this.mass,
    required this.radius,
    required this.color,
    required this.bodyType,
    required this.stellarLuminosity,
    required this.temperature,
    required this.showGravityWell,
    required this.isPlanet,
    required this.habitabilityStatus,
  });

  factory BodyData.fromJson(Map<String, dynamic> json) {
    return BodyData(
      name: json['name'] as String,
      position: List<double>.from(json['position']),
      velocity: List<double>.from(json['velocity']),
      mass: json['mass'] as double,
      radius: json['radius'] as double,
      color: json['color'] as String,
      bodyType: BodyType.values.firstWhere(
        (type) => type.name == json['bodyType'],
        orElse: () => BodyType.planet,
      ),
      stellarLuminosity: json['stellarLuminosity'] as double,
      temperature: json['temperature'] as double,
      showGravityWell: json['showGravityWell'] as bool,
      isPlanet: json['isPlanet'] as bool,
      habitabilityStatus: HabitabilityStatus.values.firstWhere(
        (status) => status.name == json['habitabilityStatus'],
        orElse: () => HabitabilityStatus.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'velocity': velocity,
      'mass': mass,
      'radius': radius,
      'color': color,
      'bodyType': bodyType.name,
      'stellarLuminosity': stellarLuminosity,
      'temperature': temperature,
      'showGravityWell': showGravityWell,
      'isPlanet': isPlanet,
      'habitabilityStatus': habitabilityStatus.name,
    };
  }
}
