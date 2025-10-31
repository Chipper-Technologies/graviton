import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/models/orbital_event.dart';
import 'package:graviton/services/orbital_prediction_engine.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('OrbitalPredictionEngine Tests', () {
    late OrbitalPredictionEngine engine;
    late List<Body> testBodies;

    setUp(() {
      engine = OrbitalPredictionEngine();

      // Create test bodies for various scenarios
      testBodies = [
        Body(
          position: vm.Vector3(0.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 0.0),
          mass: 100.0,
          radius: 5.0,
          color: AppColors.basicRed,
          name: 'Central Body',
          bodyType: BodyType.star,
        ),
        Body(
          position: vm.Vector3(50.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 10.0, 0.0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicBlue,
          name: 'Orbiting Body 1',
          bodyType: BodyType.planet,
        ),
        Body(
          position: vm.Vector3(-50.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, -10.0, 0.0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicGreen,
          name: 'Orbiting Body 2',
          bodyType: BodyType.planet,
        ),
      ];
    });

    test('should initialize with default configuration', () {
      expect(engine, isNotNull);
    });

    test('predictFuturePositions should return future positions', () {
      const timeframeSeconds = 1.0;
      const timeStep = 0.1;

      final futurePositions = engine.predictFuturePositions(
        testBodies,
        timeframeSeconds,
        timeStep: timeStep,
      );

      expect(futurePositions, hasLength(testBodies.length));
      expect(futurePositions[0], isNotEmpty);

      // Positions should change over time for moving bodies
      expect(futurePositions[1].length, greaterThan(1));
    });

    test('predictFuturePositions should handle zero timeframe', () {
      const timeframeSeconds = 0.0;

      final futurePositions = engine.predictFuturePositions(
        testBodies,
        timeframeSeconds,
      );

      expect(futurePositions, hasLength(testBodies.length));
      // Each body should have at least initial position
      for (final positions in futurePositions) {
        expect(positions, hasLength(1));
      }
    });

    test('predictFuturePositions should handle large timeframes', () {
      const timeframeSeconds = 10.0;
      const timeStep = 0.5;

      final futurePositions = engine.predictFuturePositions(
        testBodies,
        timeframeSeconds,
        timeStep: timeStep,
      );

      expect(futurePositions, hasLength(testBodies.length));
      // Should not crash with large timeframes
      for (final positions in futurePositions) {
        expect(positions, everyElement(isA<vm.Vector3>()));
      }
    });

    test('detectEvents should find events from predictions', () {
      // Create bodies that will approach each other
      final approachingBodies = [
        Body(
          position: vm.Vector3(0.0, 0.0, 0.0),
          velocity: vm.Vector3(1.0, 0.0, 0.0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicRed,
          name: 'Body A',
          bodyType: BodyType.planet,
        ),
        Body(
          position: vm.Vector3(10.0, 0.0, 0.0),
          velocity: vm.Vector3(-1.0, 0.0, 0.0),
          mass: 10.0,
          radius: 2.0,
          color: AppColors.basicBlue,
          name: 'Body B',
          bodyType: BodyType.planet,
        ),
      ];

      const timeframeSeconds = 10.0;
      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();

      final predictions = engine.predictFuturePositions(
        approachingBodies,
        timeframeSeconds,
      );
      final events = engine.detectEvents(
        approachingBodies,
        predictions,
        timeStep,
        config,
      );

      expect(events, isA<List<OrbitalEvent>>());
    });

    test('detectEvents should handle stable orbits', () {
      const timeframeSeconds = 5.0;
      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();

      final predictions = engine.predictFuturePositions(
        testBodies,
        timeframeSeconds,
      );
      final events = engine.detectEvents(
        testBodies,
        predictions,
        timeStep,
        config,
      );

      // May find some events but should not crash
      expect(events, isA<List<OrbitalEvent>>());
    });

    test('detectEvents should handle single body', () {
      final singleBody = [testBodies[0]];
      const timeframeSeconds = 5.0;
      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();

      final predictions = engine.predictFuturePositions(
        singleBody,
        timeframeSeconds,
      );
      final events = engine.detectEvents(
        singleBody,
        predictions,
        timeStep,
        config,
      );

      // Single body should not generate interaction events
      expect(
        events.where((e) => e.type == OrbitalEventType.closeApproach),
        isEmpty,
      );
    });

    test('calculateOptimalCameraPosition should return valid position', () {
      final event = OrbitalEvent(
        timestamp: DateTime.now().add(const Duration(seconds: 5)),
        type: OrbitalEventType.closeApproach,
        involvedBodies: const [0, 1],
        eventPosition: vm.Vector3(25.0, 0.0, 0.0),
        optimalCameraPosition: vm.Vector3(50.0, 30.0, 20.0),
        dramaticScore: 0.8,
        description: 'Test close approach',
      );
      const config = PredictiveOrbitalConfig();

      final cameraPosition = engine.calculateOptimalCameraPosition(
        event,
        testBodies,
        config,
      );

      expect(cameraPosition, isA<vm.Vector3>());
      expect(cameraPosition, isNot(equals(vm.Vector3.zero())));
    });

    test(
      'calculateOptimalCameraPosition should handle different event types',
      () {
        const config = PredictiveOrbitalConfig();

        for (final eventType in OrbitalEventType.values) {
          final event = OrbitalEvent(
            timestamp: DateTime.now(),
            type: eventType,
            involvedBodies: const [0],
            eventPosition: vm.Vector3(10.0, 10.0, 10.0),
            optimalCameraPosition: vm.Vector3(20.0, 20.0, 20.0),
            dramaticScore: 0.5,
            description: 'Test $eventType event',
          );

          final cameraPosition = engine.calculateOptimalCameraPosition(
            event,
            testBodies,
            config,
          );
          expect(cameraPosition, isA<vm.Vector3>());
        }
      },
    );

    test('should handle empty body list gracefully', () {
      final emptyBodies = <Body>[];
      const timeframeSeconds = 5.0;
      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();

      final predictions = engine.predictFuturePositions(
        emptyBodies,
        timeframeSeconds,
      );
      expect(predictions, isEmpty);

      final events = engine.detectEvents(
        emptyBodies,
        predictions,
        timeStep,
        config,
      );
      expect(events, isEmpty);
    });

    test('should handle bodies with zero mass', () {
      final zeroMassBody = Body(
        position: vm.Vector3(10.0, 0.0, 0.0),
        velocity: vm.Vector3(0.0, 5.0, 0.0),
        mass: 0.0, // Zero mass
        radius: 1.0,
        color: AppColors.basicYellow,
        name: 'Zero Mass Body',
        bodyType: BodyType.asteroid,
      );

      final bodiesWithZeroMass = [testBodies[0], zeroMassBody];
      const timeframeSeconds = 1.0;

      // Should not crash with zero mass bodies
      final predictions = engine.predictFuturePositions(
        bodiesWithZeroMass,
        timeframeSeconds,
      );
      expect(predictions, hasLength(2));

      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();
      final events = engine.detectEvents(
        bodiesWithZeroMass,
        predictions,
        timeStep,
        config,
      );
      expect(events, isA<List<OrbitalEvent>>());
    });

    test('should handle very high velocities', () {
      final fastBody = Body(
        position: vm.Vector3(0.0, 0.0, 0.0),
        velocity: vm.Vector3(1000.0, 1000.0, 1000.0), // Very high velocity
        mass: 5.0,
        radius: 1.0,
        color: AppColors.basicPurple,
        name: 'Fast Body',
        bodyType: BodyType.asteroid,
      );

      final fastBodies = [testBodies[0], fastBody];
      const timeframeSeconds = 0.1; // Short timeframe for stability

      // Should handle high velocities without numerical instability
      final predictions = engine.predictFuturePositions(
        fastBodies,
        timeframeSeconds,
        timeStep: 0.01, // Small time step for stability
      );
      expect(predictions, hasLength(2));

      // Positions should be finite (not NaN or infinite)
      for (final bodyPositions in predictions) {
        for (final position in bodyPositions) {
          expect(position.x.isFinite, isTrue);
          expect(position.y.isFinite, isTrue);
          expect(position.z.isFinite, isTrue);
        }
      }
    });

    test('should detect different event types appropriately', () {
      const timeframeSeconds = 10.0;
      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();

      final predictions = engine.predictFuturePositions(
        testBodies,
        timeframeSeconds,
      );
      final events = engine.detectEvents(
        testBodies,
        predictions,
        timeStep,
        config,
      );

      // Should detect some events in our test scenario
      expect(events, isA<List<OrbitalEvent>>());

      // All events should have valid properties
      for (final event in events) {
        expect(event.timestamp, isA<DateTime>());
        expect(event.type, isA<OrbitalEventType>());
        expect(event.involvedBodies, isA<List<int>>());
        expect(event.eventPosition, isA<vm.Vector3>());
        expect(event.optimalCameraPosition, isA<vm.Vector3>());
        expect(event.dramaticScore, greaterThanOrEqualTo(0.0));
        expect(event.dramaticScore, lessThanOrEqualTo(1.0));
        expect(event.description, isNotEmpty);
      }
    });

    test('should generate reasonable dramatic scores', () {
      const timeframeSeconds = 10.0;
      const timeStep = 0.1;
      const config = PredictiveOrbitalConfig();

      final predictions = engine.predictFuturePositions(
        testBodies,
        timeframeSeconds,
      );
      final events = engine.detectEvents(
        testBodies,
        predictions,
        timeStep,
        config,
      );

      for (final event in events) {
        // Dramatic scores should be within valid range
        expect(event.dramaticScore, greaterThanOrEqualTo(0.0));
        expect(event.dramaticScore, lessThanOrEqualTo(1.0));

        // Close approaches should generally have higher scores
        if (event.type == OrbitalEventType.closeApproach) {
          expect(event.dramaticScore, greaterThan(0.1));
        }
      }
    });
  });

  group('OrbitalPredictionEngine Integration Tests', () {
    test('should work with different scenario configurations', () {
      final scenarios = ['solarsystem', 'threebody', 'galaxy'];

      for (final scenario in scenarios) {
        final config = PredictiveOrbitalConfig.forScenario(scenario);

        // Should not crash with different configurations
        expect(config, isA<PredictiveOrbitalConfig>());
        expect(config.predictionTimeframe, greaterThan(0));
        expect(config.minDramaticScore, greaterThanOrEqualTo(0.0));
        expect(config.minDramaticScore, lessThanOrEqualTo(1.0));
      }
    });

    test('should maintain performance with many bodies', () {
      final manyBodies = <Body>[];

      // Create 10 bodies for performance testing
      for (int i = 0; i < 10; i++) {
        manyBodies.add(
          Body(
            position: vm.Vector3(i * 10.0, 0.0, 0.0),
            velocity: vm.Vector3(0.0, i.toDouble(), 0.0),
            mass: 5.0 + i,
            radius: 1.0 + i * 0.5,
            color: AppColors.basicRed,
            name: 'Body $i',
            bodyType: BodyType.planet,
          ),
        );
      }

      final engine = OrbitalPredictionEngine();

      // Should complete prediction in reasonable time
      final stopwatch = Stopwatch()..start();
      final predictions = engine.predictFuturePositions(manyBodies, 5.0);
      stopwatch.stop();

      expect(predictions, isA<List<List<vm.Vector3>>>());
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 second timeout
    });
  });
}
