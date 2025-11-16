/// Physics settings specific to custom scenario JSON configuration
class ScenarioPhysicsSettings {
  final double gravitationalConstant;
  final double softening;
  final double timeScale;
  final double collisionRadiusMultiplier;
  final int maxTrailPoints;
  final double trailFadeRate;

  const ScenarioPhysicsSettings({
    required this.gravitationalConstant,
    required this.softening,
    required this.timeScale,
    required this.collisionRadiusMultiplier,
    required this.maxTrailPoints,
    required this.trailFadeRate,
  });

  factory ScenarioPhysicsSettings.fromJson(Map<String, dynamic> json) {
    return ScenarioPhysicsSettings(
      gravitationalConstant: json['gravitationalConstant'] as double,
      softening: json['softening'] as double,
      timeScale: json['timeScale'] as double,
      collisionRadiusMultiplier: json['collisionRadiusMultiplier'] as double,
      maxTrailPoints: json['maxTrailPoints'] as int,
      trailFadeRate: json['trailFadeRate'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gravitationalConstant': gravitationalConstant,
      'softening': softening,
      'timeScale': timeScale,
      'collisionRadiusMultiplier': collisionRadiusMultiplier,
      'maxTrailPoints': maxTrailPoints,
      'trailFadeRate': trailFadeRate,
    };
  }
}
