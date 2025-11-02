import 'package:flutter/material.dart';

/// Data structure for cached sunspot information used in solar rendering
///
/// This model stores precomputed sunspot properties to avoid recalculating
/// them on every frame, improving rendering performance.
class SunspotData {
  /// Center position of the sunspot relative to a base coordinate system
  final Offset center;

  /// Radius of the sunspot
  final double radius;

  /// Gradient for the penumbra (outer lighter region) of the sunspot
  final RadialGradient penumbraGradient;

  /// Gradient for the umbra (dark center) of the sunspot
  final RadialGradient umbraGradient;

  /// Bounding rectangle for the penumbra
  final Rect penumbraRect;

  /// Bounding rectangle for the umbra
  final Rect umbraRect;

  /// Creates a new sunspot data instance
  const SunspotData({
    required this.center,
    required this.radius,
    required this.penumbraGradient,
    required this.umbraGradient,
    required this.penumbraRect,
    required this.umbraRect,
  });
}
