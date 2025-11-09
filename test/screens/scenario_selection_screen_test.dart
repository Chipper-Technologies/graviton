import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/screens/scenario_selection_screen.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/scenario_selection/preset_scenarios_tab.dart';
import 'package:graviton/widgets/common/haptic_floating_action_button.dart';

void main() {
  group('ScenarioSelectionScreen', () {
    Widget buildTestWidget({
      ScenarioType? currentScenario,
      Function(ScenarioType)? onScenarioSelected,
      Function(String)? onCustomScenarioSelected,
    }) {
      return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScenarioSelectionScreen(
          currentScenario: currentScenario ?? ScenarioType.solarSystem,
          onScenarioSelected: onScenarioSelected ?? (scenario) {},
          onCustomScenarioSelected: onCustomScenarioSelected ?? (scenarioId) {},
        ),
      );
    }

    group('Basic Structure', () {
      testWidgets('creates and displays without errors', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Should have the main screen components
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(GravitonTabbedView), findsOneWidget);
      });

      testWidgets('displays app bar with correct title', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Select Scenario'), findsOneWidget);
      });

      testWidgets('displays tab navigation', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Should have both tab icons
        expect(find.byIcon(Icons.explore), findsOneWidget);
        expect(find.byIcon(Icons.palette), findsOneWidget);
      });
    });

    group('Preset Scenarios Tab', () {
      testWidgets('shows preset scenarios tab by default', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Preset tab should be active by default
        expect(find.byType(PresetScenariosTab), findsOneWidget);
      });

      testWidgets('passes correct parameters to preset tab', (tester) async {
        final testScenario = ScenarioType.binaryStars;

        await tester.pumpWidget(buildTestWidget(currentScenario: testScenario));
        await tester.pumpAndSettle();

        final presetTab = tester.widget<PresetScenariosTab>(
          find.byType(PresetScenariosTab),
        );
        expect(presetTab.currentScenario, testScenario);
        expect(presetTab.onScenarioSelected, isNotNull);
      });

      testWidgets('preset tab callback works correctly', (tester) async {
        ScenarioType? callbackResult;

        await tester.pumpWidget(
          buildTestWidget(
            onScenarioSelected: (scenario) {
              callbackResult = scenario;
            },
          ),
        );
        await tester.pumpAndSettle();

        final presetTab = tester.widget<PresetScenariosTab>(
          find.byType(PresetScenariosTab),
        );
        presetTab.onScenarioSelected(ScenarioType.random);

        expect(callbackResult, ScenarioType.random);
      });
    });

    group('Custom Tab Navigation', () {
      testWidgets('does not show FAB on preset tab', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(HapticFloatingActionButton), findsNothing);
      });

      testWidgets('shows FAB when switching to custom tab', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Tap custom tab
        await tester.tap(find.byIcon(Icons.palette));
        await tester.pump();

        // FAB should appear
        expect(find.byType(HapticFloatingActionButton), findsOneWidget);
      });

      testWidgets('hides FAB when switching back to preset tab', (
        tester,
      ) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Switch to custom tab
        await tester.tap(find.byIcon(Icons.palette));
        await tester.pump();

        // Verify FAB is there
        expect(find.byType(HapticFloatingActionButton), findsOneWidget);

        // Switch back to presets
        await tester.tap(find.byIcon(Icons.explore));
        await tester.pump();

        // FAB should be gone
        expect(find.byType(HapticFloatingActionButton), findsNothing);
      });

      testWidgets('FAB is positioned correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Switch to custom tab
        await tester.tap(find.byIcon(Icons.palette));
        await tester.pump();

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.floatingActionButton, isNotNull);
        expect(
          scaffold.floatingActionButtonLocation,
          FloatingActionButtonLocation.endFloat,
        );
      });
    });

    group('Navigation', () {
      testWidgets('back button works correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScenarioSelectionScreen(
                          currentScenario: ScenarioType.solarSystem,
                          onScenarioSelected: (scenario) {},
                        ),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        // Open the scenario selection screen
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.text('Select Scenario'), findsOneWidget);

        // Go back - try different back button approaches
        var backButton = find.byType(BackButton);
        if (backButton.evaluate().isEmpty) {
          backButton = find.byIcon(Icons.arrow_back);
        }
        if (backButton.evaluate().isEmpty) {
          backButton = find.byTooltip('Back');
        }

        expect(backButton, findsOneWidget);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        expect(find.text('Open'), findsOneWidget);
      });
    });

    group('Constructor Parameters', () {
      testWidgets('requires currentScenario parameter', (tester) async {
        expect(
          () => ScenarioSelectionScreen(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (scenario) {},
          ),
          returnsNormally,
        );
      });

      testWidgets('requires onScenarioSelected parameter', (tester) async {
        expect(
          () => ScenarioSelectionScreen(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (scenario) {},
          ),
          returnsNormally,
        );
      });

      testWidgets('onCustomScenarioSelected is optional', (tester) async {
        expect(
          () => ScenarioSelectionScreen(
            currentScenario: ScenarioType.solarSystem,
            onScenarioSelected: (scenario) {},
            onCustomScenarioSelected: null,
          ),
          returnsNormally,
        );
      });
    });

    group('Error Handling', () {
      testWidgets('handles different scenario types', (tester) async {
        for (final scenario in [
          ScenarioType.solarSystem,
          ScenarioType.binaryStars,
          ScenarioType.random,
        ]) {
          await tester.pumpWidget(buildTestWidget(currentScenario: scenario));
          await tester.pumpAndSettle();

          expect(find.byType(ScenarioSelectionScreen), findsOneWidget);

          // Clean up for next iteration
          await tester.pumpWidget(Container());
        }
      });

      testWidgets('handles null callback gracefully', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(onCustomScenarioSelected: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ScenarioSelectionScreen), findsOneWidget);
      });
    });

    group('Tab State Management', () {
      testWidgets('maintains tab state correctly', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Initial state - preset tab active, no FAB
        expect(find.byType(PresetScenariosTab), findsOneWidget);
        expect(find.byType(HapticFloatingActionButton), findsNothing);

        // Switch to custom tab
        await tester.tap(find.byIcon(Icons.palette));
        await tester.pump();

        // Custom tab active, FAB visible
        expect(find.byType(HapticFloatingActionButton), findsOneWidget);

        // Switch back to preset tab
        await tester.tap(find.byIcon(Icons.explore));
        await tester.pump();

        // Back to original state
        expect(find.byType(PresetScenariosTab), findsOneWidget);
        expect(find.byType(HapticFloatingActionButton), findsNothing);
      });
    });
  });
}
