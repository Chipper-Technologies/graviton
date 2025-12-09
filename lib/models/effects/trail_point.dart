import 'package:vector_math/vector_math_64.dart' as vm;

/// Represents a point in a body's trail
class TrailPoint {
  vm.Vector3 pos;
  double alpha; // 0..1

  TrailPoint(this.pos, this.alpha);
}
