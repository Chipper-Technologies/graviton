import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';

void main() {
  group('Scenario Service Tests', () {
    late ScenarioService service;

    setUp(() {
      service = ScenarioService();
    });

    test('Should generate all scenario types without errors', () {
      for (final scenario in ScenarioType.values) {
        expect(() => service.generateScenario(scenario), returnsNormally);
      }
    });

    test('Each scenario should generate appropriate number of bodies', () {
      // Random scenario (3 stars + 1 planet)
      final randomBodies = service.generateScenario(ScenarioType.random);
      expect(randomBodies.length, equals(4));

      // Earth-Moon-Sun (3 bodies)
      final earthMoonSun = service.generateScenario(ScenarioType.earthMoonSun);
      expect(earthMoonSun.length, equals(3));
      expect(earthMoonSun.any((b) => b.name == 'Sun'), isTrue);
      expect(earthMoonSun.any((b) => b.name == 'Earth'), isTrue);
      expect(earthMoonSun.any((b) => b.name == 'Moon'), isTrue);

      // Binary stars (2 stars + 2 planets)
      final binaryStars = service.generateScenario(ScenarioType.binaryStars);
      expect(binaryStars.length, equals(4));
      expect(binaryStars.any((b) => b.name == 'Star A'), isTrue);
      expect(binaryStars.any((b) => b.name == 'Star B'), isTrue);

      // Asteroid belt (1 star + 2 planets, asteroids are handled by particle system)
      final asteroidBelt = service.generateScenario(ScenarioType.asteroidBelt);
      expect(asteroidBelt.length, equals(3));
      expect(asteroidBelt.any((b) => b.name == 'Central Star'), isTrue);

      // Galaxy formation (1 black hole + 30 stars)
      final galaxy = service.generateScenario(ScenarioType.galaxyFormation);
      expect(galaxy.length, equals(31));
      expect(galaxy.any((b) => b.name == 'Supermassive Black Hole'), isTrue);

      // Solar system (1 sun + 8 planets)
      final solarSystem = service.generateScenario(ScenarioType.solarSystem);
      expect(solarSystem.length, equals(9));
      expect(solarSystem.any((b) => b.name == 'Sun'), isTrue);
      expect(solarSystem.any((b) => b.name == 'Earth'), isTrue);
      expect(solarSystem.any((b) => b.name == 'Uranus'), isTrue);
      expect(solarSystem.any((b) => b.name == 'Neptune'), isTrue);
    });

    test('All bodies should have valid properties', () {
      for (final scenario in ScenarioType.values) {
        final bodies = service.generateScenario(scenario);
        for (final body in bodies) {
          expect(body.mass, greaterThan(0));
          expect(body.radius, greaterThan(0));
          expect(body.name, isNotEmpty);
          expect(body.position, isNotNull);
          expect(body.velocity, isNotNull);
          expect(body.color, isNotNull);
        }
      }
    });

    test('Scenario types should have proper configurations', () {
      for (final scenario in ScenarioType.values) {
        expect(scenario.nameKey, isNotEmpty);
        expect(scenario.descriptionKey, isNotEmpty);
      }
    });
  });
}
