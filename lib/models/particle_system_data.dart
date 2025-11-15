/// Individual particle system configuration
class ParticleSystemData {
  final bool enabled;
  final double innerRadius;
  final double outerRadius;
  final int particleCount;
  final double centralMass;
  final double gravitationalConstant;
  final String baseColor;
  final double colorVariation;
  final bool useXZPlane;
  final double minSize;
  final double maxSize;

  const ParticleSystemData({
    required this.enabled,
    required this.innerRadius,
    required this.outerRadius,
    required this.particleCount,
    required this.centralMass,
    required this.gravitationalConstant,
    required this.baseColor,
    required this.colorVariation,
    required this.useXZPlane,
    required this.minSize,
    required this.maxSize,
  });

  factory ParticleSystemData.fromJson(Map<String, dynamic> json) {
    return ParticleSystemData(
      enabled: json['enabled'] as bool,
      innerRadius: json['innerRadius'] as double,
      outerRadius: json['outerRadius'] as double,
      particleCount: json['particleCount'] as int,
      centralMass: json['centralMass'] as double,
      gravitationalConstant: json['gravitationalConstant'] as double,
      baseColor: json['baseColor'] as String,
      colorVariation: json['colorVariation'] as double,
      useXZPlane: json['useXZPlane'] as bool,
      minSize: json['minSize'] as double,
      maxSize: json['maxSize'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'innerRadius': innerRadius,
      'outerRadius': outerRadius,
      'particleCount': particleCount,
      'centralMass': centralMass,
      'gravitationalConstant': gravitationalConstant,
      'baseColor': baseColor,
      'colorVariation': colorVariation,
      'useXZPlane': useXZPlane,
      'minSize': minSize,
      'maxSize': maxSize,
    };
  }
}
