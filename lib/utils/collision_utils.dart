import 'dart:math' as math;

import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/merge_flash.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Collision detection and merge utilities for physics simulation
class CollisionUtils {
  CollisionUtils._(); // Private constructor to prevent instantiation

  /// Check if two bodies are colliding based on their positions and radii
  static bool areColliding(Body body1, Body body2) {
    final distance = (body2.position - body1.position).length;
    final collisionRadius = _calculateCollisionRadius(body1, body2);
    return distance <= collisionRadius;
  }

  /// Calculate collision radius between two bodies
  static double _calculateCollisionRadius(Body body1, Body body2) {
    // Ultra-small collision radius - bodies almost never collide
    return (body1.radius + body2.radius) *
        SimulationConstants.collisionRadiusMultiplier;
  }

  /// Calculate collision distance between two bodies
  static double calculateCollisionDistance(Body body1, Body body2) {
    return (body2.position - body1.position).length;
  }

  /// Merge two bodies using conservation of mass and momentum
  static Body mergeBodies(Body body1, Body body2) {
    final totalMass = body1.mass + body2.mass;

    // Conservation of momentum: p = mv
    final momentum1 = body1.velocity * body1.mass;
    final momentum2 = body2.velocity * body2.mass;
    final totalMomentum = momentum1 + momentum2;
    final newVelocity = totalMomentum / totalMass;

    // Center of mass position
    final newPosition =
        (body1.position * body1.mass + body2.position * body2.mass) / totalMass;

    // Combined radius (volume conservation: V = (4/3)πr³)
    final volume1 = (4.0 / 3.0) * math.pi * math.pow(body1.radius, 3);
    final volume2 = (4.0 / 3.0) * math.pi * math.pow(body2.radius, 3);
    final totalVolume = volume1 + volume2;
    final newRadius = math
        .pow(totalVolume / ((4.0 / 3.0) * math.pi), 1.0 / 3.0)
        .toDouble();

    // Choose color based on more massive body
    final newColor = body1.mass >= body2.mass ? body1.color : body2.color;

    // Choose name based on more massive body
    final newName = body1.mass >= body2.mass ? body1.name : body2.name;

    // Determine if merged body is a planet (if either was a planet)
    final isPlanet = body1.isPlanet || body2.isPlanet;

    // Choose body type based on more massive body
    final bodyType = body1.mass >= body2.mass ? body1.bodyType : body2.bodyType;

    // Stellar luminosity: sum for stars, zero for planets
    final stellarLuminosity = body1.stellarLuminosity + body2.stellarLuminosity;

    return Body(
      position: newPosition,
      velocity: newVelocity,
      mass: totalMass,
      radius: newRadius,
      color: newColor,
      name: newName,
      isPlanet: isPlanet,
      bodyType: bodyType,
      stellarLuminosity: stellarLuminosity,
    );
  }

  /// Create merge flash effect at collision point
  static MergeFlash createMergeFlash(Body body1, Body body2) {
    // Flash position at center of mass
    final flashPosition =
        (body1.position * body1.mass + body2.position * body2.mass) /
        (body1.mass + body2.mass);

    // Flash color based on more massive body
    final flashColor = body1.mass >= body2.mass ? body1.color : body2.color;
    return MergeFlash(flashPosition, flashColor);
  }

  /// Calculate collision impact velocity
  static double calculateImpactVelocity(Body body1, Body body2) {
    final relativeVelocity = body2.velocity - body1.velocity;
    final positionDiff = (body2.position - body1.position).normalized();
    return relativeVelocity.dot(positionDiff).abs();
  }

  /// Calculate reduced mass for two-body collision
  static double calculateReducedMass(double mass1, double mass2) {
    if (mass1 <= 0 || mass2 <= 0) return 0.0;
    return (mass1 * mass2) / (mass1 + mass2);
  }

  /// Detect all collisions in a list of bodies
  /// Returns list of collision pairs (indices)
  static List<List<int>> detectAllCollisions(List<Body> bodies) {
    final collisions = <List<int>>[];

    for (int i = 0; i < bodies.length; i++) {
      for (int j = i + 1; j < bodies.length; j++) {
        if (areColliding(bodies[i], bodies[j])) {
          collisions.add([i, j]);
        }
      }
    }

    return collisions;
  }

  /// Calculate time to collision for two bodies (if on collision course)
  /// Returns null if bodies are not on collision course
  static double? calculateTimeToCollision(Body body1, Body body2) {
    final relativePosition = body2.position - body1.position;
    final relativeVelocity = body2.velocity - body1.velocity;

    // If relative velocity is zero, no collision (parallel motion)
    if (relativeVelocity.length < 1e-10) return null;

    // Project relative position onto relative velocity
    final projectedDistance =
        -relativePosition.dot(relativeVelocity) / relativeVelocity.length2;

    // If projection is negative, bodies are moving away from each other
    if (projectedDistance < 0) return null;

    // Calculate closest approach point
    final closestApproachPosition =
        relativePosition + relativeVelocity * projectedDistance;
    final closestApproachDistance = closestApproachPosition.length;

    // Check if closest approach is within collision radius
    final collisionRadius = _calculateCollisionRadius(body1, body2);
    if (closestApproachDistance > collisionRadius) return null;

    return projectedDistance;
  }

  /// Check if point is inside body
  static bool isPointInsideBody(vm.Vector3 point, Body body) {
    final distance = (point - body.position).length;
    return distance <= body.radius;
  }

  /// Calculate collision normal vector (from body1 to body2)
  static vm.Vector3 calculateCollisionNormal(Body body1, Body body2) {
    final diff = body2.position - body1.position;
    final length = diff.length;

    if (length < 1e-10) {
      // Bodies are at the same position, return arbitrary normal
      return vm.Vector3(1, 0, 0);
    }

    return diff / length;
  }

  /// Calculate elastic collision velocities (rarely used in gravity simulation)
  static Map<String, vm.Vector3> calculateElasticCollision(
    Body body1,
    Body body2,
  ) {
    final mass1 = body1.mass;
    final mass2 = body2.mass;
    final totalMass = mass1 + mass2;

    if (totalMass <= 0) {
      return {
        'velocity1': body1.velocity.clone(),
        'velocity2': body2.velocity.clone(),
      };
    }

    final normal = calculateCollisionNormal(body1, body2);

    // Relative velocity in collision normal direction
    final relativeVelocity = body2.velocity - body1.velocity;
    final velocityAlongNormal = relativeVelocity.dot(normal);

    // If velocities are separating, no collision response needed
    if (velocityAlongNormal > 0) {
      return {
        'velocity1': body1.velocity.clone(),
        'velocity2': body2.velocity.clone(),
      };
    }

    // Calculate collision impulse
    final impulse = 2 * velocityAlongNormal / (mass1 + mass2);

    // Update velocities
    final newVelocity1 = body1.velocity + normal * (impulse * mass2);
    final newVelocity2 = body2.velocity - normal * (impulse * mass1);

    return {'velocity1': newVelocity1, 'velocity2': newVelocity2};
  }

  /// Calculate kinetic energy lost in collision
  static double calculateEnergyLoss(
    Body body1Before,
    Body body2Before,
    Body mergedBody,
  ) {
    final kineticBefore =
        0.5 * body1Before.mass * body1Before.velocity.length2 +
        0.5 * body2Before.mass * body2Before.velocity.length2;

    final kineticAfter = 0.5 * mergedBody.mass * mergedBody.velocity.length2;
    return kineticBefore - kineticAfter;
  }

  /// Check if collision would be energetically favorable
  static bool isCollisionEnergeticallyFavorable(Body body1, Body body2) {
    // In gravitational systems, mergers generally release binding energy
    // This is a simplified check based on kinetic vs potential energy
    final distance = (body2.position - body1.position).length;
    final relativeSpeed = (body2.velocity - body1.velocity).length;

    final kineticEnergy =
        0.5 *
        CollisionUtils.calculateReducedMass(body1.mass, body2.mass) *
        relativeSpeed *
        relativeSpeed;

    final potentialEnergy =
        SimulationConstants.gravitationalConstant *
        body1.mass *
        body2.mass /
        distance;

    // Collision is favorable if kinetic energy is comparable to potential energy
    return kineticEnergy >= 0.1 * potentialEnergy;
  }
}
