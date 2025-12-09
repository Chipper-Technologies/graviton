import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/core/enums/habitability_status.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/features/scenarios/data/scenario_service.dart';
import '../test_utils.dart';

void main() {
  group('Solar System Habitability Integration Test', () {
    test('Solar system planets have correct habitability classifications', () {
      final scenarioService = ScenarioService();
      final mockL10n = TestUtils.createMockAppLocalizations();
      final bodies = scenarioService.generateScenario(
        ScenarioType.solarSystem,
        l10n: mockL10n,
      );

      // Get all planets
      final planets = bodies
          .where((body) => body.bodyType == BodyType.planet)
          .toList();

      // Should have 8 planets
      expect(planets.length, equals(8));

      // Sort by distance from Sun (approximate)
      planets.sort((a, b) => a.position.length.compareTo(b.position.length));

      // Verify classifications in order: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
      final expectedClassifications = [
        HabitabilityStatus.tooSmall, // Mercury
        HabitabilityStatus.toxicAtmosphere, // Venus
        HabitabilityStatus.habitable, // Earth
        HabitabilityStatus.tooSmall, // Mars
        HabitabilityStatus.gasGiant, // Jupiter
        HabitabilityStatus.gasGiant, // Saturn
        HabitabilityStatus.gasGiant, // Uranus
        HabitabilityStatus.gasGiant, // Neptune
      ];

      for (
        int i = 0;
        i < planets.length && i < expectedClassifications.length;
        i++
      ) {
        expect(
          planets[i].habitabilityStatus,
          equals(expectedClassifications[i]),
          reason:
              'Planet ${planets[i].name} should have classification ${expectedClassifications[i]}',
        );
      }

      // Verify we have exactly 4 gas giants
      final gasGiants = planets
          .where((p) => p.habitabilityStatus == HabitabilityStatus.gasGiant)
          .toList();
      expect(gasGiants.length, equals(4));

      // Verify Earth is habitable
      final habitablePlanets = planets
          .where((p) => p.habitabilityStatus == HabitabilityStatus.habitable)
          .toList();
      expect(habitablePlanets.length, equals(1));
      expect(habitablePlanets.first.name.toLowerCase(), contains('earth'));
    });
  });
}
