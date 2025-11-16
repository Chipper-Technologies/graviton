import 'package:graviton/models/success_criteria.dart';
import 'package:graviton/models/chaos_events.dart';

/// Objectives configuration for scenarios
class ObjectivesConfig {
  final bool enabled;
  final String primary;
  final String? secondary;
  final int? timeLimit;
  final SuccessCriteria? successCriteria;
  final ChaosEvents? chaosEvents;

  const ObjectivesConfig({
    required this.enabled,
    required this.primary,
    this.secondary,
    this.timeLimit,
    this.successCriteria,
    this.chaosEvents,
  });

  factory ObjectivesConfig.fromJson(Map<String, dynamic> json) {
    return ObjectivesConfig(
      enabled: json['enabled'] as bool,
      primary: json['primary'] as String,
      secondary: json['secondary'] as String?,
      timeLimit: json['timeLimit'] as int?,
      successCriteria: json['successCriteria'] != null
          ? SuccessCriteria.fromJson(json['successCriteria'])
          : null,
      chaosEvents: json['chaosEvents'] != null
          ? ChaosEvents.fromJson(json['chaosEvents'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'primary': primary,
      if (secondary != null) 'secondary': secondary,
      if (timeLimit != null) 'timeLimit': timeLimit,
      if (successCriteria != null) 'successCriteria': successCriteria!.toJson(),
      if (chaosEvents != null) 'chaosEvents': chaosEvents!.toJson(),
    };
  }
}
