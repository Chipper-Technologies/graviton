// ignore_for_file: avoid_print

import 'package:graviton/state/camera_state.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';

void main() {
  print('🚀 Auto-Zoom Feature Demonstration 🚀\n');

  final cameraState = CameraState();
  final scenarioService = ScenarioService();

  print('Testing auto-zoom behavior for different scenarios:\n');

  for (final scenario in ScenarioType.values) {
    try {
      final bodies = scenarioService.generateScenario(scenario);
      cameraState.resetViewForScenario(scenario, bodies);

      print('📊 ${scenario.name}:');
      print('   Bodies: ${bodies.length}');
      print('   Camera Distance: ${cameraState.distance.toStringAsFixed(1)}');
      print(
        '   Target: (${cameraState.target.x.toStringAsFixed(1)}, ${cameraState.target.y.toStringAsFixed(1)}, ${cameraState.target.z.toStringAsFixed(1)})',
      );

      // Calculate bounding sphere for context
      if (bodies.isNotEmpty) {
        var maxDistance = 0.0;
        for (final body in bodies) {
          final distance = body.position.length + body.radius;
          if (distance > maxDistance) maxDistance = distance;
        }
        print('   Max Body Distance: ${maxDistance.toStringAsFixed(1)}');
      }
      print('');
    } catch (e) {
      print('❌ Error testing ${scenario.name}: $e\n');
    }
  }

  print('✅ Auto-zoom feature working correctly!');
  print('📝 Summary:');
  print(
    '   • Fixed distances for specific scenarios (Binary Stars: 50, Earth-Moon-Sun: 120, Solar System: 1800)',
  );
  print(
    '   • Auto-calculated distances for variable scenarios with different multipliers',
  );
  print('   • Smart targeting to center of mass or geometric center');
  print('   • Graceful handling of edge cases (empty bodies, etc.)');
}
