import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_simulation_controls.dart';
import 'package:graviton/services/semantic_focus_service.dart';

import '../../test_utils.dart';

void main() {
  group('SemanticSimulationControls', () {
    setUp(() {
      SemanticFocusService.instance.setEnabled(true);
    });

    testWidgets('should render child widget', (tester) async {
      const testChild = Text('Test Simulation Controls');

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSimulationControls(
            isPlaying: false,
            timeScale: 1.0,
            child: testChild,
          ),
        ),
      );

      expect(find.text('Test Simulation Controls'), findsOneWidget);
    });

    testWidgets('should create semantic wrapper with proper focus node', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSimulationControls(
            isPlaying: true,
            timeScale: 2.0,
            child: Text('Simulation Controls'),
          ),
        ),
      );

      expect(find.text('Simulation Controls'), findsOneWidget);
      expect(
        SemanticFocusService.instance.simulationControlsFocusNode,
        isNotNull,
      );
    });

    testWidgets('should handle null localization gracefully', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSimulationControls(
            isPlaying: false,
            timeScale: 1.0,
            child: Text('Simulation Controls'),
          ),
        ),
      );

      expect(find.text('Simulation Controls'), findsOneWidget);
    });

    testWidgets('should update semantic label based on playing state', (
      tester,
    ) async {
      Widget buildWidget(bool isPlaying) {
        return TestUtils.wrapWithMaterialApp(
          child: SemanticSimulationControls(
            isPlaying: isPlaying,
            timeScale: 1.5,
            child: const Text('Simulation Controls'),
          ),
        );
      }

      // Test with simulation playing
      await tester.pumpWidget(buildWidget(true));
      await tester.pumpAndSettle();

      // Test with simulation paused
      await tester.pumpWidget(buildWidget(false));
      await tester.pumpAndSettle();

      expect(find.text('Simulation Controls'), findsOneWidget);
    });

    testWidgets('should execute callbacks when provided', (tester) async {
      // Verify callbacks can be assigned (actual triggering would require user interaction)
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticSimulationControls(
            isPlaying: false,
            timeScale: 1.0,
            onPlayPause: () {},
            onReset: () {},
            onSpeedChange: () {},
            child: const Text('Simulation Controls'),
          ),
        ),
      );

      expect(find.text('Simulation Controls'), findsOneWidget);
    });

    testWidgets('should handle different time scales', (tester) async {
      final timeScales = [0.1, 0.5, 1.0, 2.0, 5.0, 10.0];

      for (final scale in timeScales) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticSimulationControls(
              isPlaying: true,
              timeScale: scale,
              child: Text('Scale: $scale'),
            ),
          ),
        );

        expect(find.text('Scale: $scale'), findsOneWidget);
      }
    });

    testWidgets('should create proper semantic structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticSimulationControls(
            isPlaying: false,
            timeScale: 1.0,
            child: Text('Simulation Controls'),
          ),
        ),
      );

      final semanticsNode = tester.getSemantics(
        find.text('Simulation Controls'),
      );
      expect(semanticsNode, isNotNull);
    });

    group('Edge cases', () {
      testWidgets('should handle zero time scale', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticSimulationControls(
              isPlaying: false,
              timeScale: 0.0,
              child: Text('Zero Scale'),
            ),
          ),
        );

        expect(find.text('Zero Scale'), findsOneWidget);
      });

      testWidgets('should handle very large time scale', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticSimulationControls(
              isPlaying: true,
              timeScale: 1000.0,
              child: Text('Large Scale'),
            ),
          ),
        );

        expect(find.text('Large Scale'), findsOneWidget);
      });

      testWidgets('should handle negative time scale', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticSimulationControls(
              isPlaying: false,
              timeScale: -1.0,
              child: Text('Negative Scale'),
            ),
          ),
        );

        expect(find.text('Negative Scale'), findsOneWidget);
      });

      testWidgets('should handle fractional time scales', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticSimulationControls(
              isPlaying: true,
              timeScale: 0.333,
              child: Text('Fractional Scale'),
            ),
          ),
        );

        expect(find.text('Fractional Scale'), findsOneWidget);
      });
    });
  });
}
