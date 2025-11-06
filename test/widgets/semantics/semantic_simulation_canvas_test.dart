import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_simulation_canvas.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/simulation_status.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../../test_utils.dart';

void main() {
  group('SemanticSimulationCanvas Initialization', () {
    testWidgets('should not crash during initialization', (tester) async {
      final bodies = <Body>[
        Body(
          name: 'Test Body',
          mass: 1e30,
          radius: 696340000,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.yellow,
        ),
      ];

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticSimulationCanvas(
            bodies: bodies,
            status: SimulationStatus.running,
            timeScale: 1.0,
            stepCount: 100,
            cameraDistance: 1000.0,
            autoRotate: false,
            followMode: false,
            child: Container(width: 200, height: 200, color: Colors.blue),
          ),
        ),
      );

      // Should not throw an error during pump
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should handle widget updates correctly', (tester) async {
      final bodies = <Body>[
        Body(
          name: 'Test Body',
          mass: 1e30,
          radius: 696340000,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: Colors.yellow,
        ),
      ];

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticSimulationCanvas(
            bodies: bodies,
            status: SimulationStatus.running,
            timeScale: 1.0,
            stepCount: 100,
            cameraDistance: 1000.0,
            autoRotate: false,
            followMode: false,
            child: Container(width: 200, height: 200, color: Colors.blue),
          ),
        ),
      );

      // Update with new properties
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticSimulationCanvas(
            bodies: bodies,
            status: SimulationStatus.paused,
            timeScale: 2.0,
            stepCount: 200,
            cameraDistance: 2000.0,
            autoRotate: true,
            followMode: true,
            child: Container(width: 200, height: 200, color: Colors.red),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
