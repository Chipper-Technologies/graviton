import 'package:flutter/material.dart';
import 'package:graviton/models/body.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Data class for storing offscreen indicator information
class IndicatorData {
  /// Index of the body in the bodies list
  final int bodyIndex;

  /// The celestial body this indicator represents
  final Body body;

  /// Screen position where the indicator should be displayed
  final Offset position;

  /// Direction vector pointing from screen center to the offscreen body
  final vm.Vector2 direction;

  const IndicatorData({
    required this.bodyIndex,
    required this.body,
    required this.position,
    required this.direction,
  });

  /// Creates a copy of this indicator data with updated values
  IndicatorData copyWith({
    int? bodyIndex,
    Body? body,
    Offset? position,
    vm.Vector2? direction,
  }) {
    return IndicatorData(
      bodyIndex: bodyIndex ?? this.bodyIndex,
      body: body ?? this.body,
      position: position ?? this.position,
      direction: direction ?? this.direction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IndicatorData &&
        other.bodyIndex == bodyIndex &&
        other.body == body &&
        other.position == position &&
        other.direction.x == direction.x &&
        other.direction.y == direction.y;
  }

  @override
  int get hashCode {
    return bodyIndex.hashCode ^
        body.hashCode ^
        position.hashCode ^
        direction.hashCode;
  }

  @override
  String toString() {
    return 'IndicatorData('
        'bodyIndex: $bodyIndex, '
        'body: ${body.name}, '
        'position: $position, '
        'direction: $direction'
        ')';
  }
}
