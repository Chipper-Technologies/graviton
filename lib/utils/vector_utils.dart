import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart' as vm;

/// Vector and 3D math utilities for orbital mechanics and spatial calculations
class VectorUtils {
  VectorUtils._(); // Private constructor to prevent instantiation

  /// Generate a 3D position from distance, angle, and height
  static vm.Vector3 positionFromPolar(double distance, double angle, double height) {
    return vm.Vector3(distance * math.cos(angle), distance * math.sin(angle), height);
  }

  /// Generate orbital velocity perpendicular to radius vector
  static vm.Vector3 orbitalVelocityFromAngle(
    double orbitalSpeed,
    double angle, {
    double randomness = 0.0,
    math.Random? random,
  }) {
    final tangentAngle = angle + math.pi / 2; // perpendicular to radius
    final rand = random ?? math.Random();

    return vm.Vector3(
      orbitalSpeed * math.cos(tangentAngle) + (randomness > 0 ? (rand.nextDouble() - 0.5) * randomness : 0.0),
      orbitalSpeed * math.sin(tangentAngle) + (randomness > 0 ? (rand.nextDouble() - 0.5) * randomness : 0.0),
      0.0,
    );
  }

  /// Generate 3D orbital velocity with Z component
  static vm.Vector3 orbital3DVelocity(
    double orbitalSpeed,
    double angle,
    double zVelocity, {
    double randomness = 0.0,
    math.Random? random,
  }) {
    final baseVelocity = orbitalVelocityFromAngle(orbitalSpeed, angle, randomness: randomness, random: random);
    return vm.Vector3(baseVelocity.x, baseVelocity.y, zVelocity);
  }

  /// Calculate angle between two vectors in radians
  static double angleBetween(vm.Vector3 v1, vm.Vector3 v2) {
    final dot = v1.dot(v2);
    final lengths = v1.length * v2.length;
    if (lengths == 0) return 0.0;

    final cosAngle = (dot / lengths).clamp(-1.0, 1.0);
    return math.acos(cosAngle);
  }

  /// Project vector a onto vector b
  static vm.Vector3 projectOnto(vm.Vector3 a, vm.Vector3 b) {
    final bLengthSquared = b.length2;
    if (bLengthSquared == 0) return vm.Vector3.zero();

    final dotProduct = a.dot(b);
    return b * (dotProduct / bLengthSquared);
  }

  /// Reflect vector v across normal n
  static vm.Vector3 reflect(vm.Vector3 v, vm.Vector3 n) {
    final normalizedN = n.normalized();
    return v - normalizedN * (2.0 * v.dot(normalizedN));
  }

  /// Rotate vector around the Z-axis by angle (in radians)
  static vm.Vector3 rotateZ(vm.Vector3 vector, double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return vm.Vector3(vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos, vector.z);
  }

  /// Rotate vector around the Y-axis by angle (in radians)
  static vm.Vector3 rotateY(vm.Vector3 vector, double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return vm.Vector3(vector.x * cos + vector.z * sin, vector.y, -vector.x * sin + vector.z * cos);
  }

  /// Rotate vector around the X-axis by angle (in radians)
  static vm.Vector3 rotateX(vm.Vector3 vector, double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return vm.Vector3(vector.x, vector.y * cos - vector.z * sin, vector.y * sin + vector.z * cos);
  }

  /// Generate random unit vector (uniformly distributed on unit sphere)
  static vm.Vector3 randomUnitVector([math.Random? random]) {
    final rand = random ?? math.Random();

    // Use Marsaglia's method for uniform distribution on sphere
    double x1, x2, w;

    do {
      x1 = 2.0 * rand.nextDouble() - 1.0;
      x2 = 2.0 * rand.nextDouble() - 1.0;
      w = x1 * x1 + x2 * x2;
    } while (w >= 1.0);

    final factor = 2.0 * math.sqrt(1.0 - w);
    return vm.Vector3(x1 * factor, x2 * factor, 2.0 * w - 1.0);
  }

  /// Generate random vector within a sphere of given radius
  static vm.Vector3 randomVectorInSphere(double radius, [math.Random? random]) {
    final rand = random ?? math.Random();
    final unitVector = randomUnitVector(rand);
    final r = math.pow(rand.nextDouble(), 1.0 / 3.0) * radius; // Cube root for uniform distribution
    return unitVector * r;
  }

  /// Generate random position within orbital range constraints
  static vm.Vector3 randomOrbitalPosition(
    double minDistance,
    double maxDistance,
    double heightRange, [
    math.Random? random,
  ]) {
    final rand = random ?? math.Random();
    final angle = rand.nextDouble() * 2 * math.pi;
    final distance = minDistance + rand.nextDouble() * (maxDistance - minDistance);
    final height = (rand.nextDouble() - 0.5) * heightRange;
    return positionFromPolar(distance, angle, height);
  }

  /// Calculate distance between two points
  static double distance(vm.Vector3 p1, vm.Vector3 p2) {
    return (p2 - p1).length;
  }

  /// Calculate squared distance (faster than distance when only comparing)
  static double distanceSquared(vm.Vector3 p1, vm.Vector3 p2) {
    return (p2 - p1).length2;
  }

  /// Clamp vector components to specified ranges
  static vm.Vector3 clampComponents(vm.Vector3 vector, double minValue, double maxValue) {
    return vm.Vector3(
      vector.x.clamp(minValue, maxValue),
      vector.y.clamp(minValue, maxValue),
      vector.z.clamp(minValue, maxValue),
    );
  }

  /// Linear interpolation between two vectors
  static vm.Vector3 lerp(vm.Vector3 a, vm.Vector3 b, double t) {
    return a + (b - a) * t.clamp(0.0, 1.0);
  }

  /// Spherical linear interpolation between two unit vectors
  static vm.Vector3 slerp(vm.Vector3 a, vm.Vector3 b, double t) {
    final clampedT = t.clamp(0.0, 1.0);

    // Normalize inputs
    final normA = a.normalized();
    final normB = b.normalized();

    final dot = normA.dot(normB).clamp(-1.0, 1.0);
    final theta = math.acos(dot.abs()) * clampedT;

    if (theta < 1e-6) {
      return lerp(normA, normB, clampedT);
    }

    final relativeVec = (normB - normA * dot).normalized();
    return normA * math.cos(theta) + relativeVec * math.sin(theta);
  }

  /// Convert cartesian coordinates to spherical (r, theta, phi)
  static vm.Vector3 toSpherical(vm.Vector3 cartesian) {
    final r = cartesian.length;
    if (r == 0) return vm.Vector3.zero();

    final theta = math.atan2(cartesian.y, cartesian.x);
    final phi = math.acos(cartesian.z / r);

    return vm.Vector3(r, theta, phi);
  }

  /// Convert spherical coordinates (r, theta, phi) to cartesian
  static vm.Vector3 fromSpherical(double r, double theta, double phi) {
    final sinPhi = math.sin(phi);
    return vm.Vector3(r * sinPhi * math.cos(theta), r * sinPhi * math.sin(theta), r * math.cos(phi));
  }

  /// Check if point is within a sphere
  static bool isWithinSphere(vm.Vector3 point, vm.Vector3 center, double radius) {
    return distanceSquared(point, center) <= radius * radius;
  }

  /// Find closest point on a line segment to a given point
  static vm.Vector3 closestPointOnSegment(vm.Vector3 point, vm.Vector3 segmentStart, vm.Vector3 segmentEnd) {
    final segment = segmentEnd - segmentStart;
    final pointToStart = point - segmentStart;

    final segmentLengthSq = segment.length2;
    if (segmentLengthSq == 0) return segmentStart;

    final t = pointToStart.dot(segment) / segmentLengthSq;
    final clampedT = t.clamp(0.0, 1.0);
    return segmentStart + segment * clampedT;
  }
}
