/// Configuration settings for custom scenarios
class ScenarioConfiguration {
  final double? optimalCameraDistance;
  final double cameraDistanceMultiplier;
  final int expectedBodyCount;

  const ScenarioConfiguration({
    this.optimalCameraDistance,
    required this.cameraDistanceMultiplier,
    required this.expectedBodyCount,
  });

  factory ScenarioConfiguration.fromJson(Map<String, dynamic> json) {
    return ScenarioConfiguration(
      optimalCameraDistance: json['optimalCameraDistance'] as double?,
      cameraDistanceMultiplier: json['cameraDistanceMultiplier'] as double,
      expectedBodyCount: json['expectedBodyCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (optimalCameraDistance != null)
        'optimalCameraDistance': optimalCameraDistance,
      'cameraDistanceMultiplier': cameraDistanceMultiplier,
      'expectedBodyCount': expectedBodyCount,
    };
  }
}
