import 'package:flutter/material.dart';

/// Shadow geometry information for cast shadow rendering
///
/// Contains the calculated geometry for rendering umbra and penumbra
/// regions of a shadow cast by one celestial body onto another.
class ShadowInfo {
  /// Screen-space center position of the shadow
  final Offset shadowCenter;

  /// Radius of the umbra (full shadow) region in screen pixels
  final double umbraRadius;

  /// Radius of the penumbra (partial shadow) region in screen pixels
  final double penumbraRadius;

  /// Creates shadow geometry information
  ///
  /// All parameters are required:
  /// - [shadowCenter]: Screen-space position where shadow is centered
  /// - [umbraRadius]: Size of full shadow region
  /// - [penumbraRadius]: Size of partial shadow region (must be >= umbraRadius)
  ShadowInfo({
    required this.shadowCenter,
    required this.umbraRadius,
    required this.penumbraRadius,
  });
}
