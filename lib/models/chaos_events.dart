/// Chaos events configuration
class ChaosEvents {
  final bool enabled;
  final int frequency;
  final List<String> types;

  const ChaosEvents({
    required this.enabled,
    required this.frequency,
    required this.types,
  });

  factory ChaosEvents.fromJson(Map<String, dynamic> json) {
    return ChaosEvents(
      enabled: json['enabled'] as bool,
      frequency: json['frequency'] as int,
      types: List<String>.from(json['types']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'frequency': frequency, 'types': types};
  }
}
