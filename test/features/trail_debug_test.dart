import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/simulation.dart' as physics;

void main() {
  group('Trail Visibility Debug', () {
    test('Solar system should generate visible trails', () {
      final simulation = physics.Simulation();
      simulation.resetWithScenario(ScenarioType.solarSystem);

      // Debug output commented out to avoid lint warnings
      // print('=== INITIAL STATE ===');
      // print('Bodies count: ${simulation.bodies.length}');
      // print('Trails count: ${simulation.trails.length}');

      // for (int i = 0; i < simulation.bodies.length; i++) {
      //   final body = simulation.bodies[i];
      //   print('Body $i: ${body.name} at ${body.position}');
      //   print('  Trail points: ${simulation.trails[i].length}');
      // }

      // print('\n=== AFTER 100 STEPS ===');
      // Run simulation and push trails
      for (int step = 0; step < 100; step++) {
        simulation.stepRK4(1.0 / 240.0);
        simulation.pushTrails(1.0 / 240.0);
      }

      // print('Bodies count: ${simulation.bodies.length}');
      // print('Trails count: ${simulation.trails.length}');

      for (int i = 0; i < simulation.bodies.length; i++) {
        // Debug variables commented out to avoid lint warnings
        // final body = simulation.bodies[i];
        // final trailCount = simulation.trails[i].length;
        // final avgAlpha = trailCount > 0
        //     ? simulation.trails[i].map((t) => t.alpha).reduce((a, b) => a + b) / trailCount
        //     : 0.0;

        // Debug output commented out to avoid lint warnings
        // print('Body $i: ${body.name}');
        // print('  Position: ${body.position}');
        // print('  Trail points: $trailCount');
        // print('  Average alpha: ${avgAlpha.toStringAsFixed(3)}');

        // if (trailCount > 0) {
        //   print('  First trail point alpha: ${simulation.trails[i].first.alpha.toStringAsFixed(3)}');
        //   print('  Last trail point alpha: ${simulation.trails[i].last.alpha.toStringAsFixed(3)}');
        // }
      }

      // Verify that trails have been generated
      int totalTrailPoints = 0;
      for (final trail in simulation.trails) {
        totalTrailPoints += trail.length;
      }

      // Debug output commented out to avoid lint warnings
      // print('\n=== SUMMARY ===');
      // print('Total trail points across all bodies: $totalTrailPoints');
      // print('Expected: At least ${simulation.bodies.length * 50} (50 points per body minimum)');

      expect(
        totalTrailPoints,
        greaterThan(simulation.bodies.length * 50),
        reason:
            'Should have accumulated significant trail points after 100 steps',
      );
    });
  });
}
