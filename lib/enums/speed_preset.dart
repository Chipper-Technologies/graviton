import 'dart:core';
import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Represents predefined speed settings for the simulation
enum SpeedPreset {
  /// Quarter speed (0.25x)
  quarterSpeed(0.25, Icons.slow_motion_video),

  /// Half speed (0.5x)
  halfSpeed(0.5, Icons.play_arrow),

  /// Normal speed (1.0x) - default
  normal(1.0, Icons.play_arrow),

  /// Double speed (2.0x)
  double(2.0, Icons.fast_forward),

  /// Fast speed (4.0x)
  fast(4.0, Icons.fast_forward),

  /// Very fast speed (8.0x)
  veryFast(8.0, Icons.fast_forward),

  /// Maximum speed (16.0x)
  maximum(16.0, Icons.fast_forward);

  const SpeedPreset(this.multiplier, this.icon);

  /// The speed multiplier value
  final num multiplier;

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

  /// Get localized display name
  String getLocalizedDisplayName(AppLocalizations l10n) {
    switch (this) {
      case SpeedPreset.quarterSpeed:
        return l10n.speedQuarter;
      case SpeedPreset.halfSpeed:
        return l10n.speedHalf;
      case SpeedPreset.normal:
        return l10n.speedNormal;
      case SpeedPreset.double:
        return l10n.speedDouble;
      case SpeedPreset.fast:
        return l10n.speedFast;
      case SpeedPreset.veryFast:
        return l10n.speedVeryFast;
      case SpeedPreset.maximum:
        return l10n.speedMaximum;
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
