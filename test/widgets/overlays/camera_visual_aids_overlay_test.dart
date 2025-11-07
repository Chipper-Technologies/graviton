import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/widgets/overlays/camera_visual_aids_overlay.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('CameraVisualAidsOverlay Widget Tests', () {
    late List<Body> testBodies;
    late vm.Matrix4 testViewMatrix;
    late vm.Matrix4 testProjMatrix;
    late Size testScreenSize;

    setUp(() {
      testBodies = [
        Body(
          name: 'Test Body 1',
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3.zero(),
          mass: 1000,
          radius: 5,
          color: Colors.blue,
        ),
      ];
      testViewMatrix = vm.Matrix4.identity();
      testProjMatrix = vm.Matrix4.identity();
      testScreenSize = const Size(400, 300);
    });

    testWidgets('renders when crosshairs are enabled', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: testBodies,
            viewMatrix: testViewMatrix,
            projMatrix: testProjMatrix,
            screenSize: testScreenSize,
            selectedBodyIndex: null,
            cameraDistance: 100.0,
            showCrosshairs: true,
          ),
        ),
      );

      expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('does not render crosshairs when disabled', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: testBodies,
            viewMatrix: testViewMatrix,
            projMatrix: testProjMatrix,
            screenSize: testScreenSize,
            selectedBodyIndex: null,
            cameraDistance: 100.0,
            showCrosshairs: false,
          ),
        ),
      );

      expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsNothing);
    });

    testWidgets('crosshairs visibility toggles correctly', (tester) async {
      Widget buildWidget(bool showCrosshairs) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: testBodies,
            viewMatrix: testViewMatrix,
            projMatrix: testProjMatrix,
            screenSize: testScreenSize,
            selectedBodyIndex: null,
            cameraDistance: 100.0,
            showCrosshairs: showCrosshairs,
          ),
        );
      }

      // Test crosshairs disabled
      await tester.pumpWidget(buildWidget(false));
      expect(find.byType(CustomPaint), findsNothing);

      // Test crosshairs enabled
      await tester.pumpWidget(buildWidget(true));
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('handles different screen sizes', (tester) async {
      final sizes = [
        const Size(200, 200),
        const Size(400, 300),
        const Size(800, 600),
      ];

      for (final size in sizes) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: CameraVisualAidsOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: size,
              selectedBodyIndex: null,
              cameraDistance: 100.0,
              showCrosshairs: true,
            ),
          ),
        );

        expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
        expect(find.byType(CustomPaint), findsOneWidget);
      }
    });

    testWidgets('handles empty body list', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: [],
            viewMatrix: testViewMatrix,
            projMatrix: testProjMatrix,
            screenSize: testScreenSize,
            selectedBodyIndex: null,
            cameraDistance: 100.0,
            showCrosshairs: true,
          ),
        ),
      );

      expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('handles selected body index', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: testBodies,
            viewMatrix: testViewMatrix,
            projMatrix: testProjMatrix,
            screenSize: testScreenSize,
            selectedBodyIndex: 0,
            cameraDistance: 100.0,
            showCrosshairs: true,
          ),
        ),
      );

      expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('widget structure is consistent', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: [],
            viewMatrix: vm.Matrix4.identity(),
            projMatrix: vm.Matrix4.identity(),
            screenSize: const Size(400, 300),
            selectedBodyIndex: null,
            cameraDistance: 100.0,
            showCrosshairs: true,
          ),
        ),
      );

      // Verify widget hierarchy
      expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });

  group('CrosshairsPainter Tests', () {
    testWidgets('painter draws crosshairs', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CustomPaint(
            size: const Size(200, 200),
            painter: CrosshairsPainter(),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('painter should not repaint by default', (tester) async {
      final painter1 = CrosshairsPainter();
      final painter2 = CrosshairsPainter();

      expect(painter1.shouldRepaint(painter2), isFalse);
    });
  });

  group('Edge Cases', () {
    testWidgets('handles extreme camera distances', (tester) async {
      final distances = [0.1, 1.0, 1000.0, 10000.0];

      for (final distance in distances) {
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: CameraVisualAidsOverlay(
              bodies: [],
              viewMatrix: vm.Matrix4.identity(),
              projMatrix: vm.Matrix4.identity(),
              screenSize: const Size(400, 300),
              selectedBodyIndex: null,
              cameraDistance: distance,
              showCrosshairs: true,
            ),
          ),
        );

        expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
        expect(find.byType(CustomPaint), findsOneWidget);
      }
    });

    testWidgets('handles null selected body index', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CameraVisualAidsOverlay(
            bodies: [
              Body(
                name: 'Test',
                position: vm.Vector3.zero(),
                velocity: vm.Vector3.zero(),
                mass: 1000,
                radius: 5,
                color: Colors.red,
              ),
            ],
            viewMatrix: vm.Matrix4.identity(),
            projMatrix: vm.Matrix4.identity(),
            screenSize: const Size(400, 300),
            selectedBodyIndex: null,
            cameraDistance: 100.0,
            showCrosshairs: true,
          ),
        ),
      );

      expect(find.byType(CameraVisualAidsOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });
}
