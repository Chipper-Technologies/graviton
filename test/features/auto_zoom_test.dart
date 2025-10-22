import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/state/camera_state.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';

void main() {
  group('Auto-Zoom Tests', () {
    late CameraState cameraState;
    late ScenarioService scenarioService;

    setUp(() {
      cameraState = CameraState();
      scenarioService = ScenarioService();
    });

    test('Should set different distances for different scenarios', () {
      // Test Binary Stars scenario (auto-calculated distance)
      final binaryBodies = scenarioService.generateScenario(
        ScenarioType.binaryStars,
      );
      cameraState.resetViewForScenario(ScenarioType.binaryStars, binaryBodies);

      // Binary stars doesn't have fixed distance, so check it's reasonable
      expect(
        cameraState.distance,
        greaterThan(20.0),
        reason: 'Binary stars distance should be greater than minimum',
      );

      expect(
        cameraState.distance,
        lessThan(2000.0),
        reason: 'Binary stars distance should be less than maximum',
      );

      // Test Earth-Moon-Sun scenario (auto-calculated distance)
      final earthMoonSunBodies = scenarioService.generateScenario(
        ScenarioType.earthMoonSun,
      );
      cameraState.resetViewForScenario(
        ScenarioType.earthMoonSun,
        earthMoonSunBodies,
      );
      expect(
        cameraState.distance,
        greaterThan(20.0),
        reason: 'Earth-Moon-Sun distance should be greater than minimum',
      );
      expect(
        cameraState.distance,
        lessThan(2000.0),
        reason: 'Earth-Moon-Sun distance should be less than maximum',
      );

      // Test Solar System scenario (fixed distance)
      final solarSystemBodies = scenarioService.generateScenario(
        ScenarioType.solarSystem,
      );
      cameraState.resetViewForScenario(
        ScenarioType.solarSystem,
        solarSystemBodies,
      );
      expect(
        cameraState.distance,
        equals(1200.0),
        reason: 'Solar system should have fixed 1200.0 distance',
      );

      // Test Random scenario (auto-calculated)
      final randomBodies = scenarioService.generateScenario(
        ScenarioType.random,
      );
      cameraState.resetViewForScenario(ScenarioType.random, randomBodies);
      expect(
        cameraState.distance,
        greaterThan(20.0),
        reason: 'Random scenario should auto-calculate distance > 20',
      );
      expect(
        cameraState.distance,
        lessThan(2000.0),
        reason: 'Random scenario should auto-calculate distance < 2000',
      );
    });

    test('Should calculate optimal target based on body positions', () {
      final bodies = scenarioService.generateScenario(ScenarioType.binaryStars);
      cameraState.resetViewForScenario(ScenarioType.binaryStars, bodies);

      // Target should be close to center for binary stars
      expect(
        cameraState.target.length,
        lessThan(5.0),
        reason: 'Binary stars target should be near center',
      );
    });

    test('Should handle empty body list gracefully', () {
      cameraState.resetViewForScenario(ScenarioType.random, []);

      expect(
        cameraState.distance,
        equals(50.0),
        reason: 'Should use fallback distance for empty bodies',
      );
      expect(
        cameraState.target.length,
        equals(0.0),
        reason: 'Should use zero target for empty bodies',
      );
    });

    test('Auto-calculated scenarios should use distance multipliers', () {
      // Test Asteroid Belt scenario (auto-calculated with 1.3x multiplier)
      final asteroidBodies = scenarioService.generateScenario(
        ScenarioType.asteroidBelt,
      );
      cameraState.resetViewForScenario(
        ScenarioType.asteroidBelt,
        asteroidBodies,
      );
      final asteroidDistance = cameraState.distance;

      // Test Galaxy Formation scenario (auto-calculated with 1.5x multiplier)
      final galaxyBodies = scenarioService.generateScenario(
        ScenarioType.galaxyFormation,
      );
      cameraState.resetViewForScenario(
        ScenarioType.galaxyFormation,
        galaxyBodies,
      );
      final galaxyDistance = cameraState.distance;

      // Galaxy should have larger distance due to higher multiplier and larger spread
      expect(
        galaxyDistance,
        greaterThan(asteroidDistance),
        reason: 'Galaxy formation should need more distance than asteroid belt',
      );
    });
  });
}
