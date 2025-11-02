import 'dart:math' as math;
import 'package:graviton/models/body.dart';
import 'package:graviton/models/orbital_event.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Physics-based prediction engine for orbital mechanics
///
/// This service uses numerical integration to predict future positions
/// of celestial bodies and identify dramatic orbital events for cinematic
/// camera positioning.
class OrbitalPredictionEngine {
  /// Predict future positions of bodies using numerical integration
  ///
  /// Uses the same RK4 integration method as the main simulation
  /// to maintain accuracy and consistency.
  List<List<vm.Vector3>> predictFuturePositions(
    List<Body> currentBodies,
    double timeframeSeconds, {
    double timeStep = 0.1,
  }) {
    // Create working copies of bodies to avoid modifying originals
    final workingBodies = currentBodies
        .map(
          (body) => Body(
            name: body.name,
            mass: body.mass,
            position: body.position.clone(),
            velocity: body.velocity.clone(),
            color: body.color,
            radius: body.radius,
            isPlanet: body.isPlanet,
            bodyType: body.bodyType,
            stellarLuminosity: body.stellarLuminosity,
            habitabilityStatus: body.habitabilityStatus,
            temperature: body.temperature,
          ),
        )
        .toList();

    final predictions = <List<vm.Vector3>>[];

    // Initialize prediction arrays
    for (int i = 0; i < workingBodies.length; i++) {
      predictions.add([workingBodies[i].position.clone()]);
    }

    final numSteps = (timeframeSeconds / timeStep).round();

    // Run prediction simulation
    for (int step = 0; step < numSteps; step++) {
      _stepRK4(workingBodies, timeStep);

      // Store positions
      for (int i = 0; i < workingBodies.length; i++) {
        predictions[i].add(workingBodies[i].position.clone());
      }
    }

    return predictions;
  }

  /// Detect orbital events from predicted positions
  List<OrbitalEvent> detectEvents(
    List<Body> currentBodies,
    List<List<vm.Vector3>> predictions,
    double timeStep,
    PredictiveOrbitalConfig config,
  ) {
    final events = <OrbitalEvent>[];

    // Detect close approaches
    for (int i = 0; i < currentBodies.length; i++) {
      for (int j = i + 1; j < currentBodies.length; j++) {
        final closeEvents = _detectCloseApproaches(
          predictions[i],
          predictions[j],
          [i, j],
          timeStep,
          config,
        );
        events.addAll(closeEvents);
      }
    }

    // Detect orbital extrema (periapsis/apoapsis)
    for (int i = 0; i < currentBodies.length; i++) {
      final extremaEvents = _detectOrbitalExtrema(
        predictions[i],
        i,
        timeStep,
        config,
      );
      events.addAll(extremaEvents);
    }

    // Sort by dramatic score and time
    events.sort((a, b) {
      final scoreComparison = b.dramaticScore.compareTo(a.dramaticScore);
      if (scoreComparison != 0) return scoreComparison;
      return a.timestamp.compareTo(b.timestamp);
    });

    // Limit to max tracked events
    return events.take(config.maxTrackedEvents).toList();
  }

  /// Calculate optimal camera position for viewing an orbital event
  vm.Vector3 calculateOptimalCameraPosition(
    OrbitalEvent event,
    List<Body> bodies,
    PredictiveOrbitalConfig config,
  ) {
    // For close approaches, position camera to show both bodies
    if (event.type == OrbitalEventType.closeApproach &&
        event.involvedBodies.length >= 2) {
      return _calculateCloseApproachCameraPosition(event, bodies, config);
    }

    // For single-body events, use rule of thirds
    return _calculateSingleBodyCameraPosition(event, bodies, config);
  }

  // Private helper methods

  /// RK4 integration step for physics prediction
  void _stepRK4(List<Body> bodies, double dt) {
    final k1 = <vm.Vector3>[];
    final k2 = <vm.Vector3>[];
    final k3 = <vm.Vector3>[];
    final k4 = <vm.Vector3>[];

    // Calculate k1
    for (final body in bodies) {
      k1.add(_calculateAcceleration(body, bodies));
    }

    // Calculate k2
    for (int i = 0; i < bodies.length; i++) {
      final tempBody = Body(
        name: bodies[i].name,
        mass: bodies[i].mass,
        position: bodies[i].position + bodies[i].velocity * (dt / 2),
        velocity: bodies[i].velocity + k1[i] * (dt / 2),
        color: bodies[i].color,
        radius: bodies[i].radius,
        isPlanet: bodies[i].isPlanet,
        bodyType: bodies[i].bodyType,
      );
      k2.add(_calculateAcceleration(tempBody, bodies));
    }

    // Calculate k3
    for (int i = 0; i < bodies.length; i++) {
      final tempBody = Body(
        name: bodies[i].name,
        mass: bodies[i].mass,
        position:
            bodies[i].position +
            bodies[i].velocity * (dt / 2) +
            k1[i] * (dt * dt / 4),
        velocity: bodies[i].velocity + k2[i] * (dt / 2),
        color: bodies[i].color,
        radius: bodies[i].radius,
        isPlanet: bodies[i].isPlanet,
        bodyType: bodies[i].bodyType,
      );
      k3.add(_calculateAcceleration(tempBody, bodies));
    }

    // Calculate k4
    for (int i = 0; i < bodies.length; i++) {
      final tempBody = Body(
        name: bodies[i].name,
        mass: bodies[i].mass,
        position:
            bodies[i].position +
            bodies[i].velocity * dt +
            k2[i] * (dt * dt / 2),
        velocity: bodies[i].velocity + k3[i] * dt,
        color: bodies[i].color,
        radius: bodies[i].radius,
        isPlanet: bodies[i].isPlanet,
        bodyType: bodies[i].bodyType,
      );
      k4.add(_calculateAcceleration(tempBody, bodies));
    }

    // Update positions and velocities
    for (int i = 0; i < bodies.length; i++) {
      final accelerationAvg = (k1[i] + k2[i] * 2 + k3[i] * 2 + k4[i]) / 6;
      bodies[i].position +=
          bodies[i].velocity * dt + accelerationAvg * (dt * dt / 2);
      bodies[i].velocity += accelerationAvg * dt;
    }
  }

  /// Calculate gravitational acceleration for a body
  vm.Vector3 _calculateAcceleration(Body body, List<Body> allBodies) {
    vm.Vector3 acceleration = vm.Vector3.zero();

    for (final other in allBodies) {
      if (other == body) continue;

      final r = other.position - body.position;
      final distance = r.length;

      if (distance > SimulationConstants.softening) {
        final force =
            SimulationConstants.gravitationalConstant *
            other.mass /
            math.pow(
              distance * distance +
                  SimulationConstants.softening * SimulationConstants.softening,
              1.5,
            );
        acceleration += r * force;
      }
    }

    return acceleration;
  }

  /// Detect close approach events between two bodies
  List<OrbitalEvent> _detectCloseApproaches(
    List<vm.Vector3> positions1,
    List<vm.Vector3> positions2,
    List<int> bodyIndices,
    double timeStep,
    PredictiveOrbitalConfig config,
  ) {
    final events = <OrbitalEvent>[];
    double minDistance = double.infinity;
    int minDistanceIndex = -1;

    // Find minimum distance point
    for (int i = 0; i < positions1.length; i++) {
      final distance = (positions1[i] - positions2[i]).length;
      if (distance < minDistance) {
        minDistance = distance;
        minDistanceIndex = i;
      }
    }

    // Only create event if distance is dramatic enough
    if (minDistance < 100.0 && minDistanceIndex >= 0) {
      // Threshold for "close"
      final dramaticScore = _calculateCloseApproachScore(minDistance, config);

      if (dramaticScore >= config.minDramaticScore) {
        final eventPosition =
            (positions1[minDistanceIndex] + positions2[minDistanceIndex]) / 2;
        final timestamp = DateTime.now().add(
          Duration(milliseconds: (minDistanceIndex * timeStep * 1000).round()),
        );

        events.add(
          OrbitalEvent(
            timestamp: timestamp,
            type: OrbitalEventType.closeApproach,
            involvedBodies: bodyIndices,
            eventPosition: eventPosition,
            optimalCameraPosition: _calculateOptimalViewingPosition(
              eventPosition,
              minDistance,
            ),
            dramaticScore: dramaticScore,
            description:
                'Close approach: ${minDistance.toStringAsFixed(1)} units',
          ),
        );
      }
    }

    return events;
  }

  /// Detect orbital extrema (periapsis/apoapsis) for a single body
  List<OrbitalEvent> _detectOrbitalExtrema(
    List<vm.Vector3> positions,
    int bodyIndex,
    double timeStep,
    PredictiveOrbitalConfig config,
  ) {
    final events = <OrbitalEvent>[];

    // Simple extrema detection - find local minima and maxima of distance from origin
    for (int i = 1; i < positions.length - 1; i++) {
      final prevDist = positions[i - 1].length;
      final currDist = positions[i].length;
      final nextDist = positions[i + 1].length;

      final isMinimum = currDist < prevDist && currDist < nextDist;
      final isMaximum = currDist > prevDist && currDist > nextDist;

      if (isMinimum || isMaximum) {
        final eventType = isMinimum
            ? OrbitalEventType.periapsis
            : OrbitalEventType.apoapsis;
        final dramaticScore = _calculateExtremaScore(
          currDist,
          eventType,
          config,
        );

        if (dramaticScore >= config.minDramaticScore) {
          final timestamp = DateTime.now().add(
            Duration(milliseconds: (i * timeStep * 1000).round()),
          );

          events.add(
            OrbitalEvent(
              timestamp: timestamp,
              type: eventType,
              involvedBodies: [bodyIndex],
              eventPosition: positions[i],
              optimalCameraPosition: _calculateOptimalViewingPosition(
                positions[i],
                currDist,
              ),
              dramaticScore: dramaticScore,
              description:
                  '${isMinimum ? 'Periapsis' : 'Apoapsis'}: ${currDist.toStringAsFixed(1)} units',
            ),
          );
        }
      }
    }

    return events;
  }

  /// Calculate dramatic score for close approach events
  double _calculateCloseApproachScore(
    double distance,
    PredictiveOrbitalConfig config,
  ) {
    // Closer = more dramatic (inverse relationship)
    final proximityScore = math.max(0.0, 1.0 - (distance / 100.0));

    // Apply drama level
    return proximityScore * config.dramaLevel;
  }

  /// Calculate dramatic score for orbital extrema
  double _calculateExtremaScore(
    double distance,
    OrbitalEventType type,
    PredictiveOrbitalConfig config,
  ) {
    // Periapsis (close to center) is more dramatic than apoapsis
    final baseScore = type == OrbitalEventType.periapsis ? 0.6 : 0.4;

    // Adjust based on distance (extreme distances are more interesting)
    final distanceScore = distance < 10.0
        ? 1.0
        : (distance > 1000.0 ? 0.8 : 0.5);

    return baseScore * distanceScore * config.dramaLevel;
  }

  /// Calculate optimal viewing position for an event
  vm.Vector3 _calculateOptimalViewingPosition(
    vm.Vector3 eventPosition,
    double distance,
  ) {
    // Position camera at a good viewing distance and angle
    final viewingDistance = math.max(distance * 3.0, 50.0);

    // Use rule of thirds positioning
    final offset = vm.Vector3(
      viewingDistance * 0.6, // Slightly off-center
      viewingDistance * 0.3, // Elevated view
      viewingDistance * 0.8, // Depth
    );

    return eventPosition + offset;
  }

  /// Calculate camera position for close approach events
  vm.Vector3 _calculateCloseApproachCameraPosition(
    OrbitalEvent event,
    List<Body> bodies,
    PredictiveOrbitalConfig config,
  ) {
    final eventPos = event.eventPosition;
    final distance = 50.0; // Base distance

    // Position camera to show both bodies in the frame
    final viewAngle = math.pi / 6; // 30 degrees off the collision axis
    final cameraOffset = vm.Vector3(
      distance * math.cos(viewAngle),
      distance * 0.5, // Slightly elevated
      distance * math.sin(viewAngle),
    );

    return eventPos + cameraOffset;
  }

  /// Calculate camera position for single body events
  vm.Vector3 _calculateSingleBodyCameraPosition(
    OrbitalEvent event,
    List<Body> bodies,
    PredictiveOrbitalConfig config,
  ) {
    return _calculateOptimalViewingPosition(event.eventPosition, 50.0);
  }
}
