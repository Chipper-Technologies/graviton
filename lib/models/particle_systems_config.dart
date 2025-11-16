import 'package:graviton/models/particle_system_data.dart';

/// Configuration for particle systems in scenarios
class ParticleSystemsConfig {
  final ParticleSystemData? asteroidBelt;
  final ParticleSystemData? kuiperBelt;

  const ParticleSystemsConfig({this.asteroidBelt, this.kuiperBelt});

  factory ParticleSystemsConfig.fromJson(Map<String, dynamic> json) {
    return ParticleSystemsConfig(
      asteroidBelt: json['asteroidBelt'] != null
          ? ParticleSystemData.fromJson(json['asteroidBelt'])
          : null,
      kuiperBelt: json['kuiperBelt'] != null
          ? ParticleSystemData.fromJson(json['kuiperBelt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (asteroidBelt != null) 'asteroidBelt': asteroidBelt!.toJson(),
      if (kuiperBelt != null) 'kuiperBelt': kuiperBelt!.toJson(),
    };
  }
}
