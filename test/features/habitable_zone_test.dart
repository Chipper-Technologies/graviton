import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/services/habitable_zone_service.dart';
import 'package:graviton/enums/scenario_type.dart';

void main() {
  group('Habitable Zone Tests', () {
    test('Solar system habitable zone calculations', () {
      // Generate solar system
      final scenarioService = ScenarioService();
      final bodies = scenarioService.generateScenario(ScenarioType.solarSystem);

      // Find the Sun
      final sun = bodies.firstWhere((body) => body.name == 'Sun');
      final earth = bodies.firstWhere((body) => body.name == 'Earth');
      final mars = bodies.firstWhere((body) => body.name == 'Mars');
      // final venus = bodies.firstWhere((body) => body.name == 'Venus'); // Not used in assertions

      // Calculate habitable zone
      final habitableZoneService = HabitableZoneService();
      final zone = habitableZoneService.calculateHabitableZone(sun);

      // Debug output (commented out to avoid lint warnings)
      // print('Sun position: ${sun.position}');
      // print('Earth position: ${earth.position}, distance: ${earth.position.length}');
      // print('Mars position: ${mars.position}, distance: ${mars.position.length}');
      // print('Venus position: ${venus.position}, distance: ${venus.position.length}');
      // print('Habitable zone inner: ${zone['inner']}');
      // print('Habitable zone outer: ${zone['outer']}');

      // Check if Earth and Mars are in habitable zone
      final earthDistance = earth.position.length;
      final marsDistance = mars.position.length;

      // Debug output (commented out to avoid lint warnings)
      // final venusDistance = venus.position.length;
      // print('Venus in zone? ${venusDistance > zone['inner']! && venusDistance < zone['outer']!}');
      // print('Earth in zone? ${earthDistance > zone['inner']! && earthDistance < zone['outer']!}');
      // print('Mars in zone? ${marsDistance > zone['inner']! && marsDistance < zone['outer']!}');

      // Earth should be in habitable zone
      expect(
        earthDistance > zone['inner']!,
        true,
        reason: 'Earth should be inside habitable zone',
      );
      expect(
        earthDistance < zone['outer']!,
        true,
        reason: 'Earth should be inside habitable zone',
      );

      // Mars should be in habitable zone (optimistic boundaries)
      expect(
        marsDistance > zone['inner']!,
        true,
        reason: 'Mars should be inside habitable zone',
      );
      expect(
        marsDistance < zone['outer']!,
        true,
        reason: 'Mars should be inside habitable zone',
      );
    });
  });
}
