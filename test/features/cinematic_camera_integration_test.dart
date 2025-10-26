import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/models/orbital_event.dart';
import 'package:graviton/services/orbital_prediction_engine.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Integration tests for the complete cinematic camera techniques system
void main() {
  group('Cinematic Camera Techniques System Integration', () {
    test('system should support all six camera techniques', () {
      expect(CinematicCameraTechnique.values, hasLength(6));

      // Verify all techniques are present
      final techniqueNames = CinematicCameraTechnique.values
          .map((t) => t.name)
          .toList();
      expect(
        techniqueNames,
        containsAll([
          'manual',
          'predictiveOrbital',
          'dynamicFraming',
          'physicsAware',
          'contextualShots',
          'emotionalPacing',
        ]),
      );
    });

    test('only manual technique should not require AI', () {
      final nonAiTechniques = CinematicCameraTechnique.values
          .where((technique) => !technique.requiresAI)
          .toList();

      expect(nonAiTechniques, hasLength(1));
      expect(nonAiTechniques.first, equals(CinematicCameraTechnique.manual));
    });

    test(
      'all AI techniques should have descriptive names and descriptions',
      () {
        final aiTechniques = CinematicCameraTechnique.values
            .where((technique) => technique.requiresAI)
            .toList();

        for (final technique in aiTechniques) {
          final displayName = technique.displayName;
          final description = technique.description;

          // Should have meaningful content
          expect(displayName, isNotEmpty);
          expect(description, isNotEmpty);
          expect(description.length, greaterThan(displayName.length));

          // Should contain AI-related keywords
          final content = '$displayName $description'.toLowerCase();
          expect(
            content,
            anyOf([
              contains('ai'),
              contains('automatic'),
              contains('intelligent'),
              contains('predict'),
              contains('adjust'),
              contains('select'),
              contains('analyze'),
            ]),
          );
        }
      },
    );

    test(
      'orbital prediction engine should work with all configuration scenarios',
      () {
        final scenarios = ['solarsystem', 'threebody', 'galaxy', 'unknown'];

        for (final scenario in scenarios) {
          final config = PredictiveOrbitalConfig.forScenario(scenario);

          // All configurations should be valid
          expect(config.predictionTimeframe, greaterThan(0));
          expect(config.minDramaticScore, inInclusiveRange(0.0, 1.0));
          expect(config.maxTrackedEvents, greaterThan(0));
          expect(config.movementSpeed, greaterThan(0));
          expect(config.dramaLevel, inInclusiveRange(0.0, 1.0));
        }
      },
    );

    test('orbital events should cover all expected interaction types', () {
      final eventTypes = OrbitalEventType.values;

      expect(eventTypes, hasLength(7));
      expect(
        eventTypes,
        containsAll([
          OrbitalEventType.closeApproach,
          OrbitalEventType.periapsis,
          OrbitalEventType.apoapsis,
          OrbitalEventType.slingshot,
          OrbitalEventType.potentialCollision,
          OrbitalEventType.orbitalDecay,
          OrbitalEventType.resonance,
        ]),
      );
    });

    test('camera movement types should support all animation styles', () {
      final movementTypes = CameraMovementType.values;

      expect(movementTypes, hasLength(4));
      expect(
        movementTypes,
        containsAll([
          CameraMovementType.linear,
          CameraMovementType.easeInOut,
          CameraMovementType.bezier,
          CameraMovementType.banking,
        ]),
      );
    });

    test('technique values should be suitable for analytics and storage', () {
      for (final technique in CinematicCameraTechnique.values) {
        final value = technique.value;

        // Should be URL-safe and database-friendly
        expect(value, matches(RegExp(r'^[a-z_]+$')));
        expect(value, isNot(contains(' ')));
        expect(value, isNot(contains('-')));
        expect(value, isNot(contains('.')));

        // Should be parseable back to enum
        final parsedTechnique = CinematicCameraTechnique.fromValue(value);
        expect(parsedTechnique, equals(technique));
      }
    });

    test('system should gracefully handle edge cases', () {
      // Test parsing unknown values
      final unknownTechnique = CinematicCameraTechnique.fromValue(
        'unknown_technique',
      );
      expect(unknownTechnique, equals(CinematicCameraTechnique.manual));

      // Test empty/null scenarios
      final emptyTechnique = CinematicCameraTechnique.fromValue('');
      expect(emptyTechnique, equals(CinematicCameraTechnique.manual));

      // Test configuration edge cases
      const extremeConfig = PredictiveOrbitalConfig(
        predictionTimeframe: 1.0, // Minimum practical value
        minDramaticScore: 1.0, // Maximum selectivity
        maxTrackedEvents: 1, // Minimum tracking
        movementSpeed: 0.1, // Slowest movement
        dramaLevel: 0.0, // Most educational
      );

      expect(extremeConfig.predictionTimeframe, equals(1.0));
      expect(extremeConfig.minDramaticScore, equals(1.0));
      expect(extremeConfig.maxTrackedEvents, equals(1));
      expect(extremeConfig.movementSpeed, equals(0.1));
      expect(extremeConfig.dramaLevel, equals(0.0));
    });

    test('orbital events should have consistent data structure', () {
      final testEvent = OrbitalEvent(
        timestamp: DateTime.now(),
        type: OrbitalEventType.closeApproach,
        involvedBodies: const [0, 1],
        eventPosition: vm.Vector3(10.0, 20.0, 30.0),
        optimalCameraPosition: vm.Vector3(40.0, 50.0, 60.0),
        dramaticScore: 0.75,
        description: 'Test orbital event',
      );

      // Verify all required fields are accessible
      expect(testEvent.timestamp, isA<DateTime>());
      expect(testEvent.type, isA<OrbitalEventType>());
      expect(testEvent.involvedBodies, isA<List<int>>());
      expect(testEvent.eventPosition, isA<vm.Vector3>());
      expect(testEvent.optimalCameraPosition, isA<vm.Vector3>());
      expect(testEvent.dramaticScore, isA<double>());
      expect(testEvent.description, isA<String>());

      // Verify toString works for debugging
      final eventString = testEvent.toString();
      expect(eventString, contains('OrbitalEvent'));
      expect(eventString, contains('closeApproach'));
      expect(eventString, contains('0.75'));
    });

    test('camera movements should support smooth transitions', () {
      final testMovement = CameraMovement(
        startPosition: vm.Vector3(0.0, 0.0, 0.0),
        endPosition: vm.Vector3(100.0, 100.0, 100.0),
        startTarget: vm.Vector3(50.0, 0.0, 0.0),
        endTarget: vm.Vector3(50.0, 50.0, 0.0),
        duration: 2.5,
        type: CameraMovementType.easeInOut,
      );

      // Verify movement data structure
      expect(testMovement.startPosition, isA<vm.Vector3>());
      expect(testMovement.endPosition, isA<vm.Vector3>());
      expect(testMovement.startTarget, isA<vm.Vector3>());
      expect(testMovement.endTarget, isA<vm.Vector3>());
      expect(testMovement.duration, isA<double>());
      expect(testMovement.type, isA<CameraMovementType>());

      // Verify reasonable duration
      expect(testMovement.duration, greaterThan(0));
    });

    test('complete workflow should integrate all components', () {
      // 1. Select a camera technique
      const selectedTechnique = CinematicCameraTechnique.predictiveOrbital;
      expect(selectedTechnique.requiresAI, isTrue);

      // 2. Get appropriate configuration
      final config = PredictiveOrbitalConfig.forScenario('threebody');
      expect(config.dramaLevel, greaterThan(0.5)); // Should be dramatic

      // 3. Create prediction engine
      final engine = OrbitalPredictionEngine();
      expect(engine, isNotNull);

      // 4. Create test orbital event
      final event = OrbitalEvent(
        timestamp: DateTime.now().add(const Duration(seconds: 3)),
        type: OrbitalEventType.closeApproach,
        involvedBodies: const [0, 1],
        eventPosition: vm.Vector3(25.0, 25.0, 0.0),
        optimalCameraPosition: vm.Vector3(100.0, 75.0, 50.0),
        dramaticScore: 0.9,
        description: 'Dramatic close approach between binary stars',
      );

      // 5. Calculate camera position
      final cameraPosition = engine.calculateOptimalCameraPosition(
        event,
        [],
        config,
      );
      expect(cameraPosition, isA<vm.Vector3>());

      // 6. Create camera movement
      final movement = CameraMovement(
        startPosition: vm.Vector3.zero(),
        endPosition: cameraPosition,
        startTarget: vm.Vector3.zero(),
        endTarget: event.eventPosition,
        duration: config.movementSpeed * 2.0,
        type: config.useBanking
            ? CameraMovementType.banking
            : CameraMovementType.easeInOut,
      );

      expect(movement.duration, greaterThan(0));
      expect(movement.endPosition, equals(cameraPosition));
      expect(movement.endTarget, equals(event.eventPosition));
    });
  });
}
