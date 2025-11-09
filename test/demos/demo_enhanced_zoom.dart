// ignore_for_file: avoid_print

import 'package:graviton/state/camera_state.dart';
import 'package:graviton/services/scenario_service.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/utils/number_utils.dart';

void main() {
  print('🎯 Enhanced Zoom Feature Demonstration 🎯\n');

  final cameraState = CameraState();
  final scenarioService = ScenarioService();

  print(
    'Testing the enhanced zoom behavior that solves the "bodies far apart" problem:\n',
  );

  // Test with Solar System scenario
  print('📊 Solar System Scenario:');
  final solarBodies = scenarioService.generateScenario(
    ScenarioType.solarSystem,
  );
  cameraState.resetViewForScenario(ScenarioType.solarSystem, solarBodies);

  print(
    '   Initial camera distance: ${NumberUtils.formatDistance(cameraState.distance)}',
  );
  print('   Initial target: ${NumberUtils.formatVector3(cameraState.target)}');
  print(
    '   Bodies spread across: ${NumberUtils.formatDistance(_calculateSystemSpread(solarBodies))} units\n',
  );

  // Demonstrate body selection and enhanced zoom
  print('🎯 Selecting Neptune (outermost planet):');
  final neptuneIndex = _findOutermostBody(solarBodies);
  cameraState.selectBody(neptuneIndex);
  cameraState.focusOnBody(neptuneIndex, solarBodies);

  print('   Selected body index: $neptuneIndex');
  print(
    '   New target position: ${NumberUtils.formatVector3(cameraState.target)}',
  );

  // Simulate enhanced zoom behavior
  print('\n🔍 Enhanced Zoom Demonstration:');
  print(
    '   Original distance: ${NumberUtils.formatDistance(cameraState.distance)}',
  );

  // Zoom in using enhanced method
  cameraState.zoomTowardBody(-0.2, solarBodies); // 20% zoom in
  print(
    '   After enhanced zoom in: ${NumberUtils.formatDistance(cameraState.distance)}',
  );
  print(
    '   Target adjusted to: ${NumberUtils.formatVector3(cameraState.target)}',
  );

  print('\n💡 How this solves the "far apart bodies" problem:');
  print('   1. 🎯 Tap to cycle through and select bodies');
  print('   2. 🔍 Zoom gestures now focus toward the selected body');
  print('   3. 📍 Use "Focus on Nearest Body" button to find closest object');
  print(
    '   4. 👁️ Camera target smoothly adjusts toward selected body when zooming',
  );
  print('   5. 🎮 Follow mode keeps the camera locked on moving objects');

  print('\n🚀 User Experience Improvements:');
  print('   ✅ No more zooming into empty space');
  print('   ✅ Easy to focus on distant planets like Neptune');
  print('   ✅ Smooth, predictable zoom behavior');
  print('   ✅ Enhanced body selection with visual feedback');
  print('   ✅ One-tap "focus on nearest" for scattered systems');
}

double _calculateSystemSpread(List<dynamic> bodies) {
  if (bodies.isEmpty) return 0.0;

  double minDistance = double.infinity;
  double maxDistance = 0.0;

  for (final body in bodies) {
    final distance = body.position.length;
    minDistance = distance < minDistance ? distance : minDistance;
    maxDistance = distance > maxDistance ? distance : maxDistance;
  }

  return maxDistance - minDistance;
}

int _findOutermostBody(List<dynamic> bodies) {
  if (bodies.isEmpty) return 0;

  int outermostIndex = 0;
  double maxDistance = 0.0;

  for (int i = 0; i < bodies.length; i++) {
    final distance = bodies[i].position.length;
    if (distance > maxDistance) {
      maxDistance = distance;
      outermostIndex = i;
    }
  }

  return outermostIndex;
}
