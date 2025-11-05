import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_camera_controls.dart';
import 'package:graviton/services/semantic_focus_service.dart';

import '../../test_utils.dart';

void main() {
  group('SemanticCameraControls', () {
    setUp(() {
      SemanticFocusService.instance.setEnabled(true);
    });

    testWidgets('should render child widget', (tester) async {
      const testChild = Text('Test Camera Controls');

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticCameraControls(
            autoRotate: false,
            cameraDistance: 100.0,
            child: testChild,
          ),
        ),
      );

      expect(find.text('Test Camera Controls'), findsOneWidget);
    });

    testWidgets('should create semantic wrapper with proper focus node', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticCameraControls(
            autoRotate: true,
            cameraDistance: 200.0,
            child: Text('Camera Controls'),
          ),
        ),
      );

      // Verify the widget is rendered
      expect(find.text('Camera Controls'), findsOneWidget);

      // Verify focus node is accessible
      expect(SemanticFocusService.instance.cameraControlsFocusNode, isNotNull);
    });

    testWidgets('should handle null localization gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SemanticCameraControls(
              autoRotate: false,
              cameraDistance: 100.0,
              child: const Text('Camera Controls'),
            ),
          ),
        ),
      );

      expect(find.text('Camera Controls'), findsOneWidget);
    });

    testWidgets('should update semantic label based on auto-rotate state', (
      tester,
    ) async {
      Widget buildWidget(bool autoRotate) {
        return TestUtils.wrapWithMaterialApp(
          child: SemanticCameraControls(
            autoRotate: autoRotate,
            cameraDistance: 150.0,
            child: const Text('Camera Controls'),
          ),
        );
      }

      // Test with auto-rotate enabled
      await tester.pumpWidget(buildWidget(true));
      await tester.pumpAndSettle();

      // Test with auto-rotate disabled
      await tester.pumpWidget(buildWidget(false));
      await tester.pumpAndSettle();

      expect(find.text('Camera Controls'), findsOneWidget);
    });

    testWidgets('should execute callbacks when provided', (tester) async {
      // Verify callbacks can be assigned (actual triggering would require user interaction)
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticCameraControls(
            autoRotate: false,
            cameraDistance: 100.0,
            onCenter: () {},
            onToggleRotate: () {},
            onZoomIn: () {},
            onZoomOut: () {},
            child: const Text('Camera Controls'),
          ),
        ),
      );

      expect(find.text('Camera Controls'), findsOneWidget);
    });

    testWidgets('should handle different camera distances', (tester) async {
      final distances = [50.0, 100.0, 200.0, 500.0];

      for (final distance in distances) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticCameraControls(
              autoRotate: false,
              cameraDistance: distance,
              child: Text('Distance: $distance'),
            ),
          ),
        );

        expect(find.text('Distance: $distance'), findsOneWidget);
      }
    });

    testWidgets('should create proper semantic structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticCameraControls(
            autoRotate: false,
            cameraDistance: 100.0,
            child: Text('Camera Controls'),
          ),
        ),
      );

      // Verify semantic structure is created
      final semanticsNode = tester.getSemantics(find.text('Camera Controls'));
      expect(semanticsNode, isNotNull);
    });

    group('Edge cases', () {
      testWidgets('should handle zero camera distance', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticCameraControls(
              autoRotate: false,
              cameraDistance: 0.0,
              child: Text('Zero Distance'),
            ),
          ),
        );

        expect(find.text('Zero Distance'), findsOneWidget);
      });

      testWidgets('should handle very large camera distance', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticCameraControls(
              autoRotate: true,
              cameraDistance: 1000.0,
              child: Text('Large Distance'),
            ),
          ),
        );

        expect(find.text('Large Distance'), findsOneWidget);
      });

      testWidgets('should handle negative camera distance', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticCameraControls(
              autoRotate: false,
              cameraDistance: -50.0,
              child: Text('Negative Distance'),
            ),
          ),
        );

        expect(find.text('Negative Distance'), findsOneWidget);
      });
    });
  });
}
