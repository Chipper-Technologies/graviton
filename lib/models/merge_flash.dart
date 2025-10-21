import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a visual flash effect when bodies merge/collide
class MergeFlash {
  vm.Vector3 position;
  Color color;
  double age; // seconds

  MergeFlash(this.position, this.color, {this.age = 0});
}
