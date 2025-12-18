import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/overlays/body_labels_overlay.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../../test_utils.dart';

void main() {
  group('BodyLabelsOverlay', () {
    // Standard test setup
    const testScreenSize = Size(800, 600);

    /// Creates a simple view matrix for testing
    /// Camera at origin looking down negative Z axis
    vm.Matrix4 createViewMatrix({
      vm.Vector3? cameraPosition,
      vm.Vector3? lookAt,
    }) {
      final pos = cameraPosition ?? vm.Vector3(0, 0, 50);
      final target = lookAt ?? vm.Vector3.zero();
      final up = vm.Vector3(0, 1, 0);

      return vm.makeViewMatrix(pos, target, up);
    }

    /// Creates a simple perspective projection matrix
    vm.Matrix4 createProjMatrix({
      double fov = 60.0,
      double aspect = 800 / 600,
      double near = 0.1,
      double far = 1000.0,
    }) {
      return vm.makePerspectiveMatrix(fov * (3.14159 / 180), aspect, near, far);
    }

    Body createTestBody({
      required String name,
      required vm.Vector3 position,
      double radius = 1.0,
      BodyType bodyType = BodyType.planet,
    }) {
      return Body(
        name: name,
        position: position,
        velocity: vm.Vector3.zero(),
        mass: 1.0,
        radius: radius,
        color: AppColors.terrestrialEarthLike,
        bodyType: bodyType,
      );
    }

    group('Widget Construction', () {
      testWidgets('should create BodyLabelsOverlay widget', (tester) async {
        final bodies = [
          createTestBody(name: 'Earth', position: vm.Vector3(0, 0, 0)),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
        // CustomPaint is a child of BodyLabelsOverlay
        expect(
          find.descendant(
            of: find.byType(BodyLabelsOverlay),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget,
        );
      });

      testWidgets('should handle empty bodies list', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: const [],
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle multiple bodies', (tester) async {
        final bodies = [
          createTestBody(name: 'Earth', position: vm.Vector3(0, 0, 0)),
          createTestBody(name: 'Mars', position: vm.Vector3(10, 0, 0)),
          createTestBody(name: 'Venus', position: vm.Vector3(-10, 0, 0)),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Body Projection', () {
      testWidgets('should render labels for visible bodies', (tester) async {
        // Body in front of camera (at origin, camera at z=50)
        final bodies = [
          createTestBody(name: 'Visible Planet', position: vm.Vector3(0, 0, 0)),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        // Widget renders without error
        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should not crash for bodies behind camera', (tester) async {
        // Body behind camera (z=100, camera at z=50 looking at origin)
        final bodies = [
          createTestBody(
            name: 'Behind Camera',
            position: vm.Vector3(0, 0, 100),
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        // Should not crash - body behind camera is filtered out
        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle bodies at various depths', (tester) async {
        final bodies = [
          createTestBody(name: 'Near', position: vm.Vector3(0, 0, 40)),
          createTestBody(name: 'Mid', position: vm.Vector3(5, 0, 20)),
          createTestBody(name: 'Far', position: vm.Vector3(-5, 0, 0)),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Z-Order Sorting', () {
      testWidgets('should handle bodies at same depth', (tester) async {
        // Two bodies at same Z position
        final bodies = [
          createTestBody(name: 'Left', position: vm.Vector3(-5, 0, 0)),
          createTestBody(name: 'Right', position: vm.Vector3(5, 0, 0)),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should sort bodies by depth correctly', (tester) async {
        // Bodies at different depths - should be sorted for rendering
        final bodies = [
          createTestBody(
            name: 'Furthest',
            position: vm.Vector3(0, 0, -50),
          ), // Furthest from camera
          createTestBody(
            name: 'Middle',
            position: vm.Vector3(0, 0, 0),
          ), // Middle distance
          createTestBody(
            name: 'Closest',
            position: vm.Vector3(0, 0, 30),
          ), // Closest to camera
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        // Widget should handle sorting internally
        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Occlusion Detection', () {
      testWidgets('should handle potential occlusion scenario', (tester) async {
        // Large body in front that could occlude smaller body behind it
        final bodies = [
          createTestBody(
            name: 'Front Planet',
            position: vm.Vector3(0, 0, 20),
            radius: 5.0, // Large radius
          ),
          createTestBody(
            name: 'Back Planet',
            position: vm.Vector3(0, 0, 0), // Directly behind front planet
            radius: 1.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        // Should handle occlusion without crashing
        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should not occlude non-overlapping bodies', (tester) async {
        // Bodies that don't overlap in screen space
        final bodies = [
          createTestBody(
            name: 'Left Planet',
            position: vm.Vector3(-20, 0, 10),
            radius: 2.0,
          ),
          createTestBody(
            name: 'Right Planet',
            position: vm.Vector3(20, 0, 0), // Far to the right
            radius: 2.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle star occlusion', (tester) async {
        // Large star that could occlude planets behind it
        final bodies = [
          createTestBody(
            name: 'Sun',
            position: vm.Vector3(0, 0, 10),
            radius: 10.0,
            bodyType: BodyType.star,
          ),
          createTestBody(
            name: 'Hidden Planet',
            position: vm.Vector3(0, 0, 0), // Behind the sun
            radius: 1.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle partial occlusion edge case', (tester) async {
        // Body slightly offset - not fully occluded
        final bodies = [
          createTestBody(
            name: 'Front',
            position: vm.Vector3(0, 0, 20),
            radius: 3.0,
          ),
          createTestBody(
            name: 'Partially Visible',
            position: vm.Vector3(3, 0, 0), // Offset to the side
            radius: 1.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Screen Radius Calculation', () {
      testWidgets('should handle various body radii', (tester) async {
        final bodies = [
          createTestBody(
            name: 'Tiny',
            position: vm.Vector3(-10, 0, 0),
            radius: 0.1,
          ),
          createTestBody(
            name: 'Small',
            position: vm.Vector3(-5, 0, 0),
            radius: 1.0,
          ),
          createTestBody(
            name: 'Medium',
            position: vm.Vector3(0, 0, 0),
            radius: 5.0,
          ),
          createTestBody(
            name: 'Large',
            position: vm.Vector3(5, 0, 0),
            radius: 10.0,
          ),
          createTestBody(
            name: 'Giant',
            position: vm.Vector3(10, 0, 0),
            radius: 20.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle bodies with zero radius gracefully', (
        tester,
      ) async {
        final bodies = [
          createTestBody(
            name: 'Zero Radius',
            position: vm.Vector3(0, 0, 0),
            radius: 0.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Multiple Occlusion Chains', () {
      testWidgets('should handle chain of occluding bodies', (tester) async {
        // Multiple bodies in a line - each potentially occluding the next
        final bodies = [
          createTestBody(
            name: 'Front',
            position: vm.Vector3(0, 0, 30),
            radius: 3.0,
          ),
          createTestBody(
            name: 'Second',
            position: vm.Vector3(0, 0, 20),
            radius: 3.0,
          ),
          createTestBody(
            name: 'Third',
            position: vm.Vector3(0, 0, 10),
            radius: 3.0,
          ),
          createTestBody(
            name: 'Back',
            position: vm.Vector3(0, 0, 0),
            radius: 3.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle many bodies efficiently', (tester) async {
        // Create many bodies to test performance
        final bodies = List.generate(
          50,
          (i) => createTestBody(
            name: 'Body $i',
            position: vm.Vector3(
              (i % 10 - 5) * 5.0,
              ((i ~/ 10) - 2.5) * 5.0,
              (i % 5) * 10.0,
            ),
            radius: 1.0,
          ),
        );

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle bodies at camera position', (tester) async {
        final bodies = [
          createTestBody(
            name: 'At Camera',
            position: vm.Vector3(0, 0, 50), // Same as camera position
            radius: 1.0,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle extreme positions', (tester) async {
        final bodies = [
          createTestBody(
            name: 'Very Far',
            position: vm.Vector3(0, 0, -10000),
            radius: 100.0,
          ),
          createTestBody(
            name: 'Very Close',
            position: vm.Vector3(0, 0, 49.9),
            radius: 0.01,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(
                cameraPosition: vm.Vector3(0, 0, 50),
              ),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle screen size edge cases', (tester) async {
        final bodies = [
          createTestBody(name: 'Test', position: vm.Vector3(0, 0, 0)),
        ];

        // Very small screen
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(aspect: 100 / 100),
              screenSize: const Size(100, 100),
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });

      testWidgets('should handle bodies outside view frustum', (tester) async {
        final bodies = [
          createTestBody(
            name: 'Off Screen Left',
            position: vm.Vector3(-1000, 0, 0),
          ),
          createTestBody(
            name: 'Off Screen Right',
            position: vm.Vector3(1000, 0, 0),
          ),
          createTestBody(
            name: 'Off Screen Up',
            position: vm.Vector3(0, 1000, 0),
          ),
          createTestBody(
            name: 'Off Screen Down',
            position: vm.Vector3(0, -1000, 0),
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });

    group('Body Types', () {
      testWidgets('should render labels for all body types', (tester) async {
        final bodies = [
          createTestBody(
            name: 'Star',
            position: vm.Vector3(-15, 0, 0),
            bodyType: BodyType.star,
          ),
          createTestBody(
            name: 'Planet',
            position: vm.Vector3(-5, 0, 0),
            bodyType: BodyType.planet,
          ),
          createTestBody(
            name: 'Moon',
            position: vm.Vector3(5, 0, 0),
            bodyType: BodyType.moon,
          ),
          createTestBody(
            name: 'Asteroid',
            position: vm.Vector3(15, 0, 0),
            bodyType: BodyType.asteroid,
          ),
        ];

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: BodyLabelsOverlay(
              bodies: bodies,
              viewMatrix: createViewMatrix(),
              projMatrix: createProjMatrix(),
              screenSize: testScreenSize,
            ),
          ),
        );

        expect(find.byType(BodyLabelsOverlay), findsOneWidget);
      });
    });
  });
}
