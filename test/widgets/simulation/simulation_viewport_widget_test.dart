import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/services/ui/screenshot_mode_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/utils/star_generator.dart';
import 'package:graviton/widgets/simulation/simulation_viewport_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('SimulationViewportWidget', () {
    late AppState appState;
    late List<StarData> stars;
    late GlobalKey simulationViewportKey;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      appState = AppState();
      appState.simulation.resetWithScenario(ScenarioType.solarSystem);
      stars = StarGenerator.generateStars(100);
      simulationViewportKey = GlobalKey();
    });

    tearDown(() {
      appState.dispose();
    });

    Widget createTestWidget({bool shouldHideUI = false}) {
      final screenshotModeService = ScreenshotModeService();
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SimulationViewportWidget(
            appState: appState,
            stars: stars,
            simulationViewportKey: simulationViewportKey,
            shouldHideUI: shouldHideUI,
            screenshotModeService: screenshotModeService,
            showFloatingControlsTemporarily: () {},
            onTap: (context, state, size, l10n, offset) {},
            onFullscreenToggle: (state) {},
            onThreeFingerPan: (offset, state) {},
            onBodyMovement: (state, size, offset) {},
            onBodySelected: (state, index, bodies) {},
            onBodyPropertiesRequested: (context, state) {},
            findBodyAtTapLocation: (state, size, offset) => null,
            findBodyAtHoverLocation: (state, size, offset) => null,
          ),
        ),
      );
    }

    testWidgets('should render without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SimulationViewportWidget), findsOneWidget);
    });

    testWidgets('should render simulation canvas', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // CustomPaint should be rendered for the simulation
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('should render RepaintBoundary for screenshot support', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('should hide UI elements when shouldHideUI is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(shouldHideUI: true));
      await tester.pumpAndSettle();

      // The widget should still render
      expect(find.byType(SimulationViewportWidget), findsOneWidget);
    });

    testWidgets('should handle empty stars list', (WidgetTester tester) async {
      stars = [];
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SimulationViewportWidget), findsOneWidget);
    });

    testWidgets('should render with different app states', (
      WidgetTester tester,
    ) async {
      // Test with different scenarios
      final scenarios = [
        ScenarioType.threeBodyClassic,
        ScenarioType.binaryStars,
        ScenarioType.deepSpace,
      ];

      for (final scenario in scenarios) {
        appState.simulation.resetWithScenario(scenario);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
      }
    });

    testWidgets('should maintain simulationViewportKey reference', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(simulationViewportKey.currentContext, isNotNull);
    });

    testWidgets('should integrate with ScreenshotModeService', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Widget should render without errors with screenshot mode service
      expect(find.byType(SimulationViewportWidget), findsOneWidget);
    });

    group('Widget Structure', () {
      testWidgets('should have proper widget hierarchy', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Check for key widgets in the hierarchy
        expect(find.byType(RepaintBoundary), findsWidgets);
        expect(find.byType(CustomPaint), findsWidgets);
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('should handle viewport with no bodies', (
        WidgetTester tester,
      ) async {
        appState.simulation.bodies.clear();
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
        expect(appState.simulation.bodies, isEmpty);
      });

      testWidgets('should handle viewport with multiple bodies', (
        WidgetTester tester,
      ) async {
        // Add test bodies
        final body1 = Body(
          name: 'Test Body 1',
          mass: 1.0,
          radius: 1.0,
          position: vm.Vector3(0, 0, 0),
          velocity: vm.Vector3(0, 0, 0),
          color: AppColors.stellarMType,
        );
        final body2 = Body(
          name: 'Test Body 2',
          mass: 2.0,
          radius: 1.5,
          position: vm.Vector3(10, 0, 0),
          velocity: vm.Vector3(0, 1, 0),
          color: AppColors.stellarOType,
        );

        appState.simulation.bodies
          ..clear()
          ..addAll([body1, body2]);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
        expect(appState.simulation.bodies.length, equals(2));
      });
    });

    group('State Management', () {
      testWidgets('should respond to app state changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Change scenario
        appState.simulation.resetWithScenario(ScenarioType.binaryStars);
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
      });

      testWidgets('should handle simulation pause and resume', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Pause simulation
        appState.simulation.pause();
        await tester.pumpAndSettle();

        expect(appState.simulation.isPaused, isTrue);

        // Resume simulation
        appState.simulation.resumeSimulation();
        await tester.pumpAndSettle();

        expect(appState.simulation.isPaused, isFalse);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null callbacks gracefully', (
        WidgetTester tester,
      ) async {
        final screenshotModeService = ScreenshotModeService();
        final widget = MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SimulationViewportWidget(
              appState: appState,
              stars: stars,
              simulationViewportKey: simulationViewportKey,
              shouldHideUI: false,
              screenshotModeService: screenshotModeService,
              showFloatingControlsTemporarily: () {},
              onTap: (context, state, size, l10n, offset) {},
              onFullscreenToggle: (state) {},
              onThreeFingerPan: (offset, state) {},
              onBodyMovement: (state, size, offset) {},
              onBodySelected: (state, index, bodies) {},
              onBodyPropertiesRequested: (context, state) {},
              findBodyAtTapLocation: (state, size, offset) => null,
              findBodyAtHoverLocation: (state, size, offset) => null,
              onShowSimulationControls: null, // Test null optional callback
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
      });

      testWidgets('should handle rapid state changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Rapidly change scenarios
        for (var i = 0; i < 5; i++) {
          appState.simulation.resetWithScenario(ScenarioType.solarSystem);
          await tester.pump();
          appState.simulation.resetWithScenario(ScenarioType.threeBodyClassic);
          await tester.pump();
        }

        await tester.pumpAndSettle();
        expect(find.byType(SimulationViewportWidget), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should handle large number of stars', (
        WidgetTester tester,
      ) async {
        stars = StarGenerator.generateStars(5000);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
        expect(stars.length, equals(5000));
      });

      testWidgets('should handle many bodies', (WidgetTester tester) async {
        // Add many test bodies
        appState.simulation.bodies.clear();
        for (var i = 0; i < 50; i++) {
          appState.simulation.bodies.add(
            Body(
              name: 'Body $i',
              mass: 1.0,
              radius: 1.0,
              position: vm.Vector3(i.toDouble(), 0, 0),
              velocity: vm.Vector3(0, 0, 0),
              color:
                  AppColors.basicPrimaries[i % AppColors.basicPrimaries.length],
            ),
          );
        }

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
        expect(appState.simulation.bodies.length, equals(50));
      });
    });

    group('Callbacks', () {
      testWidgets('should accept all required callbacks', (
        WidgetTester tester,
      ) async {
        var tapCalled = false;
        var fullscreenCalled = false;
        final screenshotModeService = ScreenshotModeService();

        final widget = MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SimulationViewportWidget(
              appState: appState,
              stars: stars,
              simulationViewportKey: simulationViewportKey,
              shouldHideUI: false,
              screenshotModeService: screenshotModeService,
              showFloatingControlsTemporarily: () {},
              onTap: (context, state, size, l10n, offset) {
                tapCalled = true;
              },
              onFullscreenToggle: (state) {
                fullscreenCalled = true;
              },
              onThreeFingerPan: (offset, state) {},
              onBodyMovement: (state, size, offset) {},
              onBodySelected: (state, index, bodies) {},
              onBodyPropertiesRequested: (context, state) {},
              findBodyAtTapLocation: (state, size, offset) => null,
              findBodyAtHoverLocation: (state, size, offset) => null,
            ),
          ),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.byType(SimulationViewportWidget), findsOneWidget);
        // Callbacks are passed but not invoked during initial render
        expect(tapCalled, isFalse);
        expect(fullscreenCalled, isFalse);
      });
    });
  });
}
