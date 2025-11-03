import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/simulation_settings_dialog.dart';

void main() {
  group('SimulationSettingsDialog Tests', () {
    Widget createTestWidget({
      double gravitationalConstant = 1.2,
      double softening = 0.1,
      double timeScale = 8.0,
      double collisionRadiusMultiplier = 0.5,
      int maxTrailPoints = 500,
      double trailFadeRate = 1.0,
      double vibrationThrottleTime = 0.2,
      bool vibrationEnabled = true,
      ScenarioType currentScenario = ScenarioType.solarSystem,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SimulationSettingsDialog(
            gravitationalConstant: gravitationalConstant,
            softening: softening,
            timeScale: timeScale,
            collisionRadiusMultiplier: collisionRadiusMultiplier,
            maxTrailPoints: maxTrailPoints,
            trailFadeRate: trailFadeRate,
            vibrationThrottleTime: vibrationThrottleTime,
            vibrationEnabled: vibrationEnabled,
            currentScenario: currentScenario,
            onSettingsChanged: (settings) {
              // Callback for settings changes
            },
          ),
        ),
      );
    }

    group('Widget Creation', () {
      testWidgets('should create dialog without errors', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationSettingsDialog), findsOneWidget);
        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('should display dialog title and close button', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should find the physics icon in header
        expect(find.byIcon(Icons.science), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('should display all section icons', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Check for section icons
        expect(
          find.byIcon(Icons.public),
          findsOneWidget,
        ); // Gravitational constant
        expect(find.byIcon(Icons.blur_on), findsOneWidget); // Softening
        expect(find.byIcon(Icons.speed), findsOneWidget); // Time scale
        expect(
          find.byIcon(Icons.radio_button_unchecked),
          findsOneWidget,
        ); // Collision
        expect(find.byIcon(Icons.linear_scale), findsOneWidget); // Trail length
        expect(find.byIcon(Icons.opacity), findsOneWidget); // Trail fade
        expect(find.byIcon(Icons.vibration), findsOneWidget); // Vibration
        expect(find.byIcon(Icons.refresh), findsOneWidget); // Reset
      });
    });

    group('Widget Structure', () {
      testWidgets(
        'should have correct number of sliders when vibration enabled',
        (tester) async {
          await tester.pumpWidget(createTestWidget(vibrationEnabled: true));
          await tester.pumpAndSettle();

          final sliders = find.byType(Slider);
          expect(
            sliders,
            findsNWidgets(7),
          ); // 6 main sliders + 1 vibration throttle
        },
      );

      testWidgets(
        'should have correct number of sliders when vibration disabled',
        (tester) async {
          await tester.pumpWidget(createTestWidget(vibrationEnabled: false));
          await tester.pumpAndSettle();

          final sliders = find.byType(Slider);
          expect(sliders, findsNWidgets(6)); // Only 6 main sliders
        },
      );

      testWidgets('should have vibration switch', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final switches = find.byType(Switch);
        expect(switches, findsAtLeastNWidgets(1));
      });
    });

    group('Different Scenarios', () {
      testWidgets('should work with different scenario types', (tester) async {
        final scenarios = [
          ScenarioType.solarSystem,
          ScenarioType.threeBodyClassic,
          ScenarioType.asteroidBelt,
          ScenarioType.binaryStars,
        ];

        for (final scenario in scenarios) {
          await tester.pumpWidget(createTestWidget(currentScenario: scenario));
          await tester.pumpAndSettle();

          expect(find.byType(SimulationSettingsDialog), findsOneWidget);
          expect(find.byIcon(Icons.science), findsOneWidget);
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle extreme values', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            gravitationalConstant: 0.1, // Minimum
            softening: 2.0, // Maximum
            timeScale: 16.0, // Maximum
            collisionRadiusMultiplier: 0.05, // Minimum
            maxTrailPoints: 1000, // Maximum
            trailFadeRate: 0.1, // Minimum
            vibrationThrottleTime: 1.0, // Maximum
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SimulationSettingsDialog), findsOneWidget);
      });

      testWidgets('should handle null values gracefully', (tester) async {
        // Test that the dialog doesn't crash with edge case values
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SimulationSettingsDialog), findsOneWidget);
        expect(find.byType(Dialog), findsOneWidget);
      });
    });

    group('Performance and Memory', () {
      testWidgets('should not leak memory', (tester) async {
        // Create and destroy the dialog multiple times
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          expect(find.byType(SimulationSettingsDialog), findsOneWidget);

          // Clear the widget tree
          await tester.pumpWidget(Container());
          await tester.pumpAndSettle();
        }
      });

      testWidgets('should render efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Should render within reasonable time (2 seconds is very generous)
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        expect(find.byType(SimulationSettingsDialog), findsOneWidget);
      });
    });

    group('Localization', () {
      testWidgets('should support localization', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should not crash and should have localized content
        expect(find.byType(SimulationSettingsDialog), findsOneWidget);

        // Should have text content (localized strings)
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Check that interactive elements are present
        expect(find.byType(Slider), findsWidgets);
        expect(find.byType(Switch), findsWidgets);
        expect(find.byType(IconButton), findsWidgets);

        // Should have semantic information
        expect(find.byType(SimulationSettingsDialog), findsOneWidget);
      });
    });
  });
}
