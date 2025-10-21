import 'package:vector_math/vector_math_64.dart' as vm;

/// Data class for orbital parameters
class OrbitalParameters {
  final vm.Vector3 center;
  final double semiMajorAxis;
  final double semiMinorAxis;
  final double eccentricity;
  final double inclination;
  final double argumentOfPeriapsis;

  OrbitalParameters({
    required this.center,
    required this.semiMajorAxis,
    required this.semiMinorAxis,
    required this.eccentricity,
    required this.inclination,
    required this.argumentOfPeriapsis,
  });
}
