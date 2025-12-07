import 'dart:math' as math;

import 'package:graviton/constants/relativistic_constants.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Utility functions for relativistic physics calculations
///
/// Provides Post-Newtonian (PN) corrections for high-speed gravitational
/// interactions, time dilation calculations, and relativistic visualization helpers.
class RelativisticPhysicsUtils {
  // Private constructor to prevent instantiation
  RelativisticPhysicsUtils._();

  /// Calculate the Lorentz factor (γ) for a given velocity
  ///
  /// γ = 1 / √(1 - v²/c²)
  ///
  /// Parameters:
  /// - [velocity]: Velocity vector in simulation units
  /// - [speedOfLight]: Speed of light in simulation units
  ///
  /// Returns Lorentz factor, clamped to prevent numerical overflow
  static double calculateLorentzFactor(
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    final v2 = velocity.length2;
    final c2 = speedOfLight * speedOfLight;
    final beta2 = v2 / c2;

    // Clamp beta to maxBeta to prevent exceeding speed of light
    final clampedBeta2 = math.min(
      beta2,
      RelativisticConstants.maxBeta * RelativisticConstants.maxBeta,
    );

    // Prevent division by zero or negative sqrt for v >= c
    if (clampedBeta2 >= 1.0) {
      return 1.0 / math.sqrt(1.0 - 0.9999); // Very high but finite
    }

    return 1.0 / math.sqrt(1.0 - clampedBeta2);
  }

  /// Calculate beta (v/c) for a given velocity
  ///
  /// Returns the velocity as a fraction of the speed of light
  static double calculateBeta(
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    if (speedOfLight <= 0) return 0.0;
    return velocity.length / speedOfLight;
  }

  /// Apply velocity cap to prevent exceeding speed of light
  ///
  /// If [RelativisticConstants.enforceSpeedLimit] is true, this clamps
  /// velocities to maxBeta * c
  static vm.Vector3 capVelocity(
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    if (!RelativisticConstants.enforceSpeedLimit) return velocity;

    final beta = calculateBeta(velocity, speedOfLight: speedOfLight);
    if (beta > RelativisticConstants.maxBeta) {
      // Scale velocity down to maxBeta * c
      final scale =
          (RelativisticConstants.maxBeta * speedOfLight) / velocity.length;
      return velocity * scale;
    }

    return velocity;
  }

  /// Calculate time dilation factor for proper time progression
  ///
  /// Δτ = Δt / γ where τ is proper time and t is coordinate time
  ///
  /// Returns the factor by which proper time is dilated
  static double calculateTimeDilation(
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    final gamma = calculateLorentzFactor(velocity, speedOfLight: speedOfLight);
    return 1.0 / gamma;
  }

  /// Calculate 1PN (first-order Post-Newtonian) acceleration correction
  ///
  /// Adds relativistic corrections to classical Newtonian gravity:
  /// - Velocity-dependent terms
  /// - Gravitational time dilation
  /// - Reduced mass effects
  ///
  /// Based on the 1PN approximation from Einstein-Infeld-Hoffmann equations
  ///
  /// Parameters:
  /// - [position1]: Position of body 1
  /// - [velocity1]: Velocity of body 1
  /// - [position2]: Position of body 2 (source of gravity)
  /// - [velocity2]: Velocity of body 2
  /// - [mass2]: Mass of body 2
  /// - [speedOfLight]: Speed of light in simulation units
  /// - [softening]: Softening parameter for numerical stability
  ///
  /// Returns corrected acceleration vector
  static vm.Vector3 calculate1PNAcceleration(
    vm.Vector3 position1,
    vm.Vector3 velocity1,
    vm.Vector3 position2,
    vm.Vector3 velocity2,
    double mass2, {
    double speedOfLight = RelativisticConstants.speedOfLight,
    double softening = SimulationConstants.softening,
  }) {
    // Classical Newtonian acceleration
    final r = position2 - position1;
    final dist2 = r.length2 + softening;
    final distance = math.sqrt(dist2);
    final invR = 1.0 / distance;
    final invR3 = invR * invR * invR;

    final gm = SimulationConstants.gravitationalConstant * mass2;
    final classicalAccel = r * (gm * invR3);

    // If 1PN corrections are disabled, return classical result
    if (!RelativisticConstants.enable1PNCorrection) {
      return classicalAccel;
    }

    // Calculate velocities and their magnitudes
    final v1Squared = velocity1.length2;
    final v2Squared = velocity2.length2;
    final v1DotV2 = velocity1.dot(velocity2);

    final c2 = speedOfLight * speedOfLight;

    // Relative velocity
    final vRel = velocity1 - velocity2;

    // Radial component of relative velocity
    final nHat = r * invR; // Unit vector from body1 to body2
    final vRadial = vRel.dot(nHat);

    // 1PN correction terms (simplified Einstein-Infeld-Hoffmann)
    // Full derivation from: Will, Theory and Experiment in Gravitational Physics

    // Term 1: Velocity-dependent correction
    final velocityCoeff = -(4.0 * gm * invR / c2);
    final velocityTerm = classicalAccel * velocityCoeff;

    // Term 2: v² correction
    final v2Coeff = (-v1Squared / c2 - 2.0 * v2Squared / c2);
    final v2Term = classicalAccel * v2Coeff;

    // Term 3: (v·r)² correction
    final radialCoeff = (4.0 * gm * invR * vRadial * vRadial / c2);
    final radialTerm = nHat * radialCoeff;

    // Term 4: Cross-velocity term
    final crossCoeff = (4.0 * v1DotV2 * gm * invR / c2);
    final crossTerm = (velocity1 - velocity2) * crossCoeff;

    // Combine all 1PN correction terms
    final pnCorrection = velocityTerm + v2Term + radialTerm + crossTerm;

    return classicalAccel + pnCorrection;
  }

  /// Calculate 2PN (second-order Post-Newtonian) acceleration correction
  ///
  /// More accurate but computationally expensive. Includes:
  /// - Higher-order velocity terms
  /// - Frame dragging effects
  /// - Spin-orbit coupling (if spin data available)
  ///
  /// Currently returns 1PN result as placeholder
  /// TODO: Implement full 2PN corrections
  static vm.Vector3 calculate2PNAcceleration(
    vm.Vector3 position1,
    vm.Vector3 velocity1,
    vm.Vector3 position2,
    vm.Vector3 velocity2,
    double mass2, {
    double speedOfLight = RelativisticConstants.speedOfLight,
    double softening = SimulationConstants.softening,
  }) {
    // If 2PN corrections are disabled, fall back to 1PN
    if (!RelativisticConstants.enable2PNCorrection) {
      return calculate1PNAcceleration(
        position1,
        velocity1,
        position2,
        velocity2,
        mass2,
        speedOfLight: speedOfLight,
        softening: softening,
      );
    }

    // TODO: Implement full 2PN corrections
    // For now, return 1PN result
    return calculate1PNAcceleration(
      position1,
      velocity1,
      position2,
      velocity2,
      mass2,
      speedOfLight: speedOfLight,
      softening: softening,
    );
  }

  /// Check if body should use relativistic corrections
  ///
  /// Returns true if velocity exceeds the relativistic threshold
  static bool shouldUseRelativisticCorrections(vm.Vector3 velocity) {
    return velocity.length > RelativisticConstants.relativisticThreshold;
  }

  /// Calculate relativistic momentum
  ///
  /// p = γmv where γ is the Lorentz factor
  static vm.Vector3 calculateRelativisticMomentum(
    double mass,
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    final gamma = calculateLorentzFactor(velocity, speedOfLight: speedOfLight);
    return velocity * (mass * gamma);
  }

  /// Calculate relativistic kinetic energy
  ///
  /// KE = (γ - 1)mc² where γ is the Lorentz factor
  static double calculateRelativisticKineticEnergy(
    double mass,
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    final gamma = calculateLorentzFactor(velocity, speedOfLight: speedOfLight);
    final c2 = speedOfLight * speedOfLight;
    return (gamma - 1.0) * mass * c2;
  }

  /// Update proper time for a body based on time dilation
  ///
  /// Δτ = Δt / γ
  ///
  /// Parameters:
  /// - [currentProperTime]: Current proper time
  /// - [coordinateTimeStep]: Time step in coordinate time
  /// - [velocity]: Current velocity vector
  ///
  /// Returns updated proper time
  static double updateProperTime(
    double currentProperTime,
    double coordinateTimeStep,
    vm.Vector3 velocity, {
    double speedOfLight = RelativisticConstants.speedOfLight,
  }) {
    final dilationFactor = calculateTimeDilation(
      velocity,
      speedOfLight: speedOfLight,
    );
    return currentProperTime + (coordinateTimeStep * dilationFactor);
  }

  /// Check if relativistic effects should be visualized
  ///
  /// Returns true if velocity is high enough to warrant visual effects
  static bool shouldShowRelativisticEffects(vm.Vector3 velocity) {
    final beta = calculateBeta(velocity);
    return beta > RelativisticConstants.minVisualizationBeta;
  }

  /// Get relativistic color shift factor for visualization
  ///
  /// Returns value from 0.0 to 1.0 indicating strength of color shift
  /// Higher velocities return higher values
  static double getColorShiftFactor(vm.Vector3 velocity) {
    final beta = calculateBeta(velocity);
    if (beta < RelativisticConstants.minVisualizationBeta) return 0.0;

    // Normalize to 0-1 range based on maxBeta
    return math.min(
      1.0,
      (beta - RelativisticConstants.minVisualizationBeta) /
          (RelativisticConstants.maxBeta -
              RelativisticConstants.minVisualizationBeta),
    );
  }
}
