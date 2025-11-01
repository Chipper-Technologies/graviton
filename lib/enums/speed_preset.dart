import 'dart:core';
import 'package:flutter/material.dart';

/// Represents predefined speed settings for the simulation
enum SpeedPreset {
  /// Quarter speed (0.25x)
  quarterSpeed(0.25, 'Quarter Speed', Icons.slow_motion_video),

  /// Half speed (0.5x)
  halfSpeed(0.5, 'Half Speed', Icons.play_arrow),

  /// Normal speed (1.0x) - default
  normal(1.0, 'Normal', Icons.play_arrow),

  /// Double speed (2.0x)
  double(2.0, 'Double', Icons.fast_forward),

  /// Fast speed (4.0x)
  fast(4.0, 'Fast', Icons.fast_forward),

  /// Very fast speed (8.0x)
  veryFast(8.0, 'Very Fast', Icons.fast_forward),

  /// Maximum speed (16.0x)
  maximum(16.0, 'Maximum', Icons.fast_forward);

  const SpeedPreset(this.multiplier, this.displayName, this.icon);

  /// The speed multiplier value
  final num multiplier;

  /// Human-readable display name
  final String displayName;

  /// Icon representing this speed
  final IconData icon;
}

/// Extension methods for SpeedPreset
extension SpeedPresetExtension on SpeedPreset {
  /// Get formatted speed string (e.g., "1.0x")
  String get formattedSpeed =>
      '${multiplier.toStringAsFixed(multiplier == multiplier.toInt() ? 0 : 1)}x';

  /// Get localization key for this speed preset
  String get localizationKey {
    switch (this) {
      case SpeedPreset.quarterSpeed:
        return 'speedQuarter';
      case SpeedPreset.halfSpeed:
        return 'speedHalf';
      case SpeedPreset.normal:
        return 'speedNormal';
      case SpeedPreset.double:
        return 'speedDouble';
      case SpeedPreset.fast:
        return 'speedFast';
      case SpeedPreset.veryFast:
        return 'speedVeryFast';
      case SpeedPreset.maximum:
        return 'speedMaximum';
    }
  }

  /// Find the closest preset for a given multiplier
  static SpeedPreset fromMultiplier(num multiplier) {
    return SpeedPreset.values.reduce(
      (a, b) =>
          (a.multiplier - multiplier).abs() < (b.multiplier - multiplier).abs()
          ? a
          : b,
    );
  }

  /// Get all available speed presets
  static List<SpeedPreset> get allPresets => SpeedPreset.values;

  /// Get presets suitable for UI display (excluding very fast options)
  static List<SpeedPreset> get commonPresets => [
    SpeedPreset.quarterSpeed,
    SpeedPreset.halfSpeed,
    SpeedPreset.normal,
    SpeedPreset.double,
    SpeedPreset.fast,
  ];
}
