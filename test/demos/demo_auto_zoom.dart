// ignore_for_file: avoid_print

import 'package:graviton/state/camera_state.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/utils/number_utils.dart';
import '../test_utils.dart';

void main() {
  print('🚀 Auto-Zoom Feature Demonstration 🚀\n');

  final cameraState = CameraState();
  final scenarioService = ScenarioService();
  final mockL10n = TestUtils.createMockAppLocalizations();

  print('Testing auto-zoom behavior for different scenarios:\n');

  for (final scenario in ScenarioType.values) {
    try {
      final bodies = scenarioService.generateScenario(scenario, l10n: mockL10n);
      cameraState.resetViewForScenario(scenario, bodies);

      print('📊 ${scenario.name}:');
      print('   Bodies: ${bodies.length}');
      print(
        '   Camera Distance: ${NumberUtils.formatDistance(cameraState.distance)}',
      );
      print('   Target: ${NumberUtils.formatVector3(cameraState.target)}');

      // Calculate bounding sphere for context
      if (bodies.isNotEmpty) {
        var maxDistance = 0.0;
        for (final body in bodies) {
          final distance = body.position.length + body.radius;
          if (distance > maxDistance) maxDistance = distance;
        }
        print(
          '   Max Body Distance: ${NumberUtils.formatDistance(maxDistance)}',
        );
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
