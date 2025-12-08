import 'dart:math' as math;

import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/constants/tidal_constants.dart';
import 'package:graviton/models/body.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Utility functions for tidal force calculations and Roche limit analysis
///
/// Provides tidal tensor calculations, Roche limit computation,
/// and helper functions for tidal disruption detection.
class TidalForceUtils {
  // Private constructor to prevent instantiation
  TidalForceUtils._();

  /// Calculate the tidal tensor at a body's position
  ///
  /// The tidal tensor represents the gradient of the gravitational field:
  /// T_ij = -GM/r³ * (3r_i*r_j/r² - δ_ij)
  ///
  /// This describes how gravitational forces vary across the body,
  /// causing differential forces that can deform or disrupt the body.
  ///
  /// Parameters:
  /// - [body]: The body experiencing tidal forces
  /// - [otherBodies]: Other bodies that contribute to tidal forces
  /// - [maxBodies]: Maximum number of nearest bodies to consider (for performance)
  ///
  /// Returns 3x3 tidal tensor as `List<List<double>>`
  static List<List<double>> calculateTidalTensor(
    Body body,
    List<Body> otherBodies, {
    int maxBodies = TidalConstants.maxTidalBodies,
  }) {
    // Initialize tensor to zeros
    final tensor = List.generate(3, (_) => List.filled(3, 0.0));

    // Filter and sort bodies by mass and distance
    final significantBodies = _findSignificantTidalBodies(
      body,
      otherBodies,
      maxBodies,
    );

    for (final other in significantBodies) {
      if (other == body) continue;

      final r = other.position - body.position;
      final distance = r.length;

      // Skip if too close (would cause numerical instability)
      if (distance < body.radius * TidalConstants.minDistanceMultiplier) {
        continue;
      }

      final r2 = distance * distance;
      final r3 = distance * r2;

      final gm = SimulationConstants.gravitationalConstant * other.mass;

      // Calculate tidal tensor components
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          // Kronecker delta: δ_ij = 1 if i==j, else 0
          final delta = (i == j) ? 1.0 : 0.0;

          // T_ij = -GM/r³ * (3r_i*r_j/r² - δ_ij)
          final component = -gm / r3 * (3.0 * r[i] * r[j] / r2 - delta);

          // Clamp to prevent numerical overflow
          final clamped = component.clamp(
            -TidalConstants.maxTidalEigenvalue,
            TidalConstants.maxTidalEigenvalue,
          );

          tensor[i][j] += clamped;
        }
      }
    }

    return tensor;
  }

  /// Calculate magnitude of tidal stress from tidal tensor
  ///
  /// Returns the Frobenius norm of the tidal tensor, which represents
  /// the overall strength of tidal forces
  static double calculateTidalStress(List<List<double>> tidalTensor) {
    double sumSquares = 0.0;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        sumSquares += tidalTensor[i][j] * tidalTensor[i][j];
      }
    }

    return math.sqrt(sumSquares);
  }

  /// Calculate principal axes of tidal tensor (eigenvalues and eigenvectors)
  ///
  /// Returns a map with 'eigenvalues' and 'eigenvectors' keys
  /// Eigenvalues represent stretch/compression along principal axes
  /// Eigenvectors represent the directions of principal axes
  static Map<String, dynamic> calculatePrincipalAxes(
    List<List<double>> tidalTensor,
  ) {
    // For a 3x3 symmetric matrix, we can use analytical or iterative methods
    // For now, we'll use a simplified approach for the dominant axis

    // Find the trace (sum of diagonal elements)
    final trace = tidalTensor[0][0] + tidalTensor[1][1] + tidalTensor[2][2];

    // Estimate dominant eigenvalue (largest magnitude)
    double maxEigenvalue = 0.0;
    vm.Vector3 maxEigenvector = vm.Vector3(1.0, 0.0, 0.0);

    // Power iteration to find dominant eigenvector (simplified)
    vm.Vector3 v = vm.Vector3(1.0, 1.0, 1.0).normalized();
    for (int i = 0; i < 10; i++) {
      // Matrix-vector multiplication: Av = T * v
      final av = vm.Vector3(
        tidalTensor[0][0] * v.x +
            tidalTensor[0][1] * v.y +
            tidalTensor[0][2] * v.z,
        tidalTensor[1][0] * v.x +
            tidalTensor[1][1] * v.y +
            tidalTensor[1][2] * v.z,
        tidalTensor[2][0] * v.x +
            tidalTensor[2][1] * v.y +
            tidalTensor[2][2] * v.z,
      );

      final length = av.length;
      if (length > 0) {
        v = av.normalized();
        maxEigenvalue = length;
      }
    }

    maxEigenvector = v;

    return {
      'eigenvalues': [maxEigenvalue, trace / 3.0, trace / 3.0], // Simplified
      'eigenvectors': [maxEigenvector, vm.Vector3.zero(), vm.Vector3.zero()],
    };
  }

  /// Calculate Roche limit for tidal disruption
  ///
  /// The Roche limit is the distance at which tidal forces from a primary body
  /// equal the self-gravity holding a secondary body together.
  ///
  /// For rigid bodies: d = 2.456 * R_primary * (ρ_primary/ρ_secondary)^(1/3)
  /// For fluid bodies: d = 2.44 * R_primary * (ρ_primary/ρ_secondary)^(1/3)
  ///
  /// Parameters:
  /// - [primaryMass]: Mass of the primary body (e.g., planet)
  /// - [primaryRadius]: Radius of the primary body
  /// - [secondaryMass]: Mass of the secondary body (e.g., moon)
  /// - [secondaryRadius]: Radius of the secondary body
  /// - [useRigid]: If true, use rigid body formula; otherwise fluid body
  ///
  /// Returns Roche limit distance in simulation units
  static double calculateRocheLimit(
    double primaryMass,
    double primaryRadius,
    double secondaryMass,
    double secondaryRadius, {
    bool useRigid = TidalConstants.useRigidBodyApproximation,
  }) {
    if (primaryRadius <= 0 ||
        secondaryRadius <= 0 ||
        primaryMass <= 0 ||
        secondaryMass <= 0) {
      return 0.0;
    }

    // Calculate volume densities (assuming spherical bodies)
    // ρ = mass / (4/3 * π * r³)
    final primaryVolume = (4.0 / 3.0) * math.pi * math.pow(primaryRadius, 3);
    final secondaryVolume =
        (4.0 / 3.0) * math.pi * math.pow(secondaryRadius, 3);

    final primaryDensity = primaryMass / primaryVolume;
    final secondaryDensity = secondaryMass / secondaryVolume;

    // Density ratio
    final densityRatio = primaryDensity / secondaryDensity;

    // Roche limit multiplier (rigid vs fluid)
    final multiplier = useRigid
        ? TidalConstants.rocheLimitMultiplierRigid
        : TidalConstants.rocheLimitMultiplierFluid;

    // Roche limit = multiplier * R_primary * (ρ_primary/ρ_secondary)^(1/3)
    return multiplier * primaryRadius * math.pow(densityRatio, 1.0 / 3.0);
  }

  /// Check if a body is within its Roche limit relative to another body
  ///
  /// Returns true if the bodies are closer than the Roche limit,
  /// indicating potential tidal disruption
  static bool isWithinRocheLimit(
    Body body1,
    Body body2, {
    double threshold = TidalConstants.tidalDisruptionThreshold,
  }) {
    final distance = (body1.position - body2.position).length;

    // Calculate Roche limit (considering body1 as secondary)
    final rocheLimit1 = calculateRocheLimit(
      body2.mass,
      body2.radius,
      body1.mass,
      body1.radius,
    );

    // Calculate Roche limit (considering body2 as secondary)
    final rocheLimit2 = calculateRocheLimit(
      body1.mass,
      body1.radius,
      body2.mass,
      body2.radius,
    );

    // Use the more conservative (larger) Roche limit
    final effectiveRocheLimit = math.max(rocheLimit1, rocheLimit2);

    return distance < effectiveRocheLimit * threshold;
  }

  /// Calculate tidal heating rate for a body
  ///
  /// Tidal heating occurs when tidal stress deforms the body,
  /// converting mechanical energy to heat (e.g., Io's volcanoes)
  ///
  /// Parameters:
  /// - [tidalStress]: Magnitude of tidal stress
  /// - [bodyMass]: Mass of the body
  /// - [bodyRadius]: Radius of the body
  ///
  /// Returns heating rate in simulation energy units per time
  static double calculateTidalHeating(
    double tidalStress,
    double bodyMass,
    double bodyRadius,
  ) {
    if (!TidalConstants.enableTidalHeating) return 0.0;

    // Simplified tidal heating model
    // Heating ∝ tidal_stress² * volume * efficiency
    final volume = (4.0 / 3.0) * math.pi * math.pow(bodyRadius, 3);
    final heatingRate =
        TidalConstants.tidalHeatingEfficiency *
        tidalStress *
        tidalStress *
        volume *
        bodyMass;

    return heatingRate;
  }

  /// Find significant bodies that contribute to tidal forces
  ///
  /// Filters bodies by minimum mass and sorts by distance and mass
  /// to find the most significant tidal force sources
  static List<Body> _findSignificantTidalBodies(
    Body targetBody,
    List<Body> allBodies,
    int maxBodies,
  ) {
    // Filter by minimum mass
    final massiveBodies = allBodies.where((b) {
      return b != targetBody && b.mass >= TidalConstants.minTidalSourceMass;
    }).toList();

    // Sort by tidal influence (mass/distance³ is proportional to tidal force)
    massiveBodies.sort((a, b) {
      final distA = (a.position - targetBody.position).length;
      final distB = (b.position - targetBody.position).length;

      // Avoid division by zero
      if (distA == 0) return -1;
      if (distB == 0) return 1;

      final influenceA = a.mass / (distA * distA * distA);
      final influenceB = b.mass / (distB * distB * distB);

      return influenceB.compareTo(influenceA); // Sort descending
    });

    // Return top N bodies
    return massiveBodies.take(maxBodies).toList();
  }

  /// Check if tidal effects should be visualized for a body
  ///
  /// Returns true if tidal stress exceeds the minimum display threshold
  static bool shouldVisualizeTidalForces(double tidalStress) {
    return tidalStress >= TidalConstants.minTidalStressDisplay;
  }

  /// Get tidal stress category for UI display
  ///
  /// Returns:
  /// - 'none': Negligible tidal stress
  /// - 'low': Detectable but safe
  /// - 'moderate': Significant tidal forces
  /// - 'high': Approaching critical levels
  /// - 'critical': Tidal disruption imminent
  static String getTidalStressCategory(double tidalStress) {
    if (tidalStress < TidalConstants.minTidalStressDisplay) {
      return 'none';
    } else if (tidalStress < TidalConstants.criticalTidalStress * 0.3) {
      return 'low';
    } else if (tidalStress < TidalConstants.criticalTidalStress * 0.6) {
      return 'moderate';
    } else if (tidalStress < TidalConstants.criticalTidalStress) {
      return 'high';
    } else {
      return 'critical';
    }
  }

  /// Calculate tidal elongation direction
  ///
  /// Returns the direction of maximum tidal stretch (towards the source)
  static vm.Vector3 calculateTidalElongationDirection(
    Body body,
    Body tidalSource,
  ) {
    final direction = tidalSource.position - body.position;
    return direction.normalized();
  }

  /// Estimate tidal disruption time
  ///
  /// Returns approximate time until disruption based on current approach rate
  /// Returns double.infinity if not approaching or not within Roche limit
  static double estimateDisruptionTime(
    Body body1,
    Body body2, {
    double threshold = TidalConstants.tidalDisruptionThreshold,
  }) {
    if (!isWithinRocheLimit(body1, body2, threshold: threshold)) {
      return double.infinity;
    }

    final distance = (body1.position - body2.position).length;
    final relativeVelocity = body2.velocity - body1.velocity;
    final approachRate = relativeVelocity.dot(
      (body2.position - body1.position).normalized(),
    );

    // If moving apart, no disruption
    if (approachRate >= 0) return double.infinity;

    // Calculate Roche limit
    final rocheLimit = math.max(
      calculateRocheLimit(body2.mass, body2.radius, body1.mass, body1.radius),
      calculateRocheLimit(body1.mass, body1.radius, body2.mass, body2.radius),
    );

    // Time to reach Roche limit
    final distanceToRoche = distance - rocheLimit;
    if (distanceToRoche <= 0) return 0.0;

    return distanceToRoche / approachRate.abs();
  }
}
