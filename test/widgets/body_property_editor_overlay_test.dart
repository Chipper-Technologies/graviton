import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/body_property_editor_overlay.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BodyPropertyEditorOverlay Tests', () {
    late List<Body> testBodies;
    late vm.Matrix4 testViewMatrix;
    late vm.Matrix4 testProjMatrix;
    late Size testScreenSize;

    setUp(() {
      testBodies = [
        Body(
          name: 'Test Planet',
          mass: 5.972e24,
          radius: 6.371e6,
          position: vm.Vector3(0, 0, -10), // Position in front of camera
          velocity: vm.Vector3(0, 0, 0),
          color: const Color(0xFF4CAF50),
          bodyType: BodyType.planet,
          stellarLuminosity: 0,
        ),
        Body(
          name: 'Test Star',
          mass: 1.989e30,
          radius: 6.96e8,
          position: vm.Vector3(10, 5, -15), // Another position
          velocity: vm.Vector3(0, 0, 0),
          color: const Color(0xFFFFEB3B),
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
        ),
      ];

      // Create a proper view matrix (looking down negative Z)
      testViewMatrix = vm.Matrix4.identity();

      // Create a proper projection matrix (perspective)
      testProjMatrix = vm.makePerspectiveMatrix(
        vm.radians(45.0), // 45 degree field of view
        800.0 / 600.0, // aspect ratio
        1.0, // near plane
        1000.0, // far plane
      );

      testScreenSize = const Size(800, 600);
    });

    testWidgets('should not render when no body is selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: null, // No selection
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      // Should render empty space (SizedBox.expand())
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsNothing);
    });

    testWidgets('should not render when selected index is out of bounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 5, // Out of bounds
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      // Should render empty space (SizedBox.expand())
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsNothing);
    });

    testWidgets('should render property icon when valid body is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 0, // Valid selection
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      // Should render the property icon
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('should call onPropertyIconTapped when icon is tapped', (
      tester,
    ) async {
      bool iconTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 0,
              onPropertyIconTapped: () {
                iconTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the property icon
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pump();

      // Verify callback was called
      expect(iconTapped, isTrue);
    });

    testWidgets('should render with correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 0,
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      // Find the icon container
      final containerFinder = find.byType(Container).first;
      expect(containerFinder, findsOneWidget);

      // Get the container widget
      final container = tester.widget<Container>(containerFinder);

      // Verify container properties
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.shape, equals(BoxShape.circle));
      expect(decoration.border, isA<Border>());
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
    });

    testWidgets('should render icon with correct properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 0,
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      // Find the icon
      final iconFinder = find.byIcon(Icons.tune);
      expect(iconFinder, findsOneWidget);

      // Get the icon widget
      final icon = tester.widget<Icon>(iconFinder);

      // Verify icon properties
      expect(icon.icon, equals(Icons.tune));
      expect(icon.color, equals(AppColors.uiWhite));
    });

    testWidgets('should handle empty bodies list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: [], // Empty list
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 0,
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      // Should render empty space since bodies list is empty (SizedBox.expand())
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsNothing);
    });

    testWidgets('should render for different selected body indices', (
      tester,
    ) async {
      // Test with first body
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 0,
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.tune), findsOneWidget);

      // Test with second body
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertyEditorOverlay(
              bodies: testBodies,
              viewMatrix: testViewMatrix,
              projMatrix: testProjMatrix,
              screenSize: testScreenSize,
              selectedBodyIndex: 1,
              onPropertyIconTapped: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.tune), findsOneWidget);
    });
  });
}
