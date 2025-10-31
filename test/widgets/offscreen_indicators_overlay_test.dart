import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/offscreen_indicators_overlay.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('OffScreenIndicatorsOverlay Tests', () {
    late List<Body> testBodies;
    late vm.Matrix4 viewMatrix;
    late vm.Matrix4 projMatrix;

    setUp(() {
      testBodies = [
        Body(
          name: 'Test Star',
          position: vm.Vector3(0.0, 0.0, 0.0),
          velocity: vm.Vector3(0.0, 0.0, 0.0),
          mass: SimulationConstants.sunMassReference,
          radius: 1.0,
          bodyType: BodyType.star,
          color: Colors.yellow,
        ),
        Body(
          name: 'Test Planet',
          position: vm.Vector3(100.0, 0.0, 0.0), // Far off-screen
          velocity: vm.Vector3(0.0, 0.0, 0.0),
          mass: SimulationConstants.earthLikePlanetMassMin,
          radius: 0.5,
          bodyType: BodyType.planet,
          color: Colors.blue,
        ),
      ];

      viewMatrix = vm.Matrix4.identity();
      projMatrix = vm.Matrix4.identity();
    });

    testWidgets('displays offscreen indicators overlay widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OffScreenIndicatorsOverlay(
              bodies: testBodies,
              viewMatrix: viewMatrix,
              projMatrix: projMatrix,
              screenSize: const Size(800, 600),
              onIndicatorTapped: (int bodyIndex) {
                // Callback for testing
              },
            ),
          ),
        ),
      );

      // Verify that the overlay is rendered
      expect(find.byType(OffScreenIndicatorsOverlay), findsOneWidget);

      // Verify that the overlay contains Stack widgets (including from MaterialApp structure)
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('handles tap callback when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: OffScreenIndicatorsOverlay(
                bodies: testBodies,
                viewMatrix: viewMatrix,
                projMatrix: projMatrix,
                screenSize: const Size(800, 600),
                onIndicatorTapped: (int bodyIndex) {
                  // Callback for testing
                },
              ),
            ),
          ),
        ),
      );

      // Look for GestureDetector widgets which should be present for interactive indicators
      final gestureDetectors = find.byType(GestureDetector);

      // The presence of GestureDetector widgets indicates tap functionality is available
      // Actual visibility and positioning depends on 3D calculations
      expect(gestureDetectors, findsWidgets);
    });

    testWidgets('renders without error when no bodies provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OffScreenIndicatorsOverlay(
              bodies: const [],
              viewMatrix: viewMatrix,
              projMatrix: projMatrix,
              screenSize: const Size(800, 600),
              onIndicatorTapped: (int bodyIndex) {},
            ),
          ),
        ),
      );

      // Should render without error even with empty bodies list
      expect(find.byType(OffScreenIndicatorsOverlay), findsOneWidget);
    });

    testWidgets('handles null callback gracefully', (
      WidgetTester tester,
    ) async {
      // Test that the widget can handle null callback without crashing
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OffScreenIndicatorsOverlay(
              bodies: testBodies,
              viewMatrix: viewMatrix,
              projMatrix: projMatrix,
              screenSize: const Size(800, 600),
              onIndicatorTapped: null,
            ),
          ),
        ),
      );

      expect(find.byType(OffScreenIndicatorsOverlay), findsOneWidget);
    });

    testWidgets('contains CustomPaint for indicator visualization', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OffScreenIndicatorsOverlay(
              bodies: testBodies,
              viewMatrix: viewMatrix,
              projMatrix: projMatrix,
              screenSize: const Size(800, 600),
              onIndicatorTapped: null,
            ),
          ),
        ),
      );

      // Should contain CustomPaint widgets for visual indicators (multiple may exist)
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
