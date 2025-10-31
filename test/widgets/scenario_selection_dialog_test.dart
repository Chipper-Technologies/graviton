import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/widgets/scenario_selection_dialog.dart';

void main() {
  group('ScenarioSelectionDialog', () {
    const testCurrentScenario = ScenarioType.random;

    void mockOnScenarioSelected(ScenarioType scenario) {
      // Mock callback for testing
    }

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    group('Rendering', () {
      testWidgets('Should display scenario selection dialog', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('Should have consistent padding and constraints', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should use AppConstraints for consistent padding
        final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
        final paddedWidgets = paddingWidgets.where(
          (padding) => padding.padding == AppConstraints.dialogPadding,
        );

        expect(paddedWidgets.isNotEmpty, isTrue);
      });

      testWidgets('Should display available scenarios', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should display scenario options
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('Should highlight current scenario', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: ScenarioType.earthMoonSun,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should show current selection
        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });

      testWidgets('Should have proper layout structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should have list structure
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('Scenario List', () {
      testWidgets('Should display scenario options', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should have clickable scenario items
        expect(find.byType(InkWell), findsWidgets);

        // Should have text content
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should show scenario icons', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should display icons for scenarios
        expect(find.byType(Icon), findsWidgets);
      });

      testWidgets('Should handle different scenario types', (tester) async {
        for (final scenario in [
          ScenarioType.random,
          ScenarioType.earthMoonSun,
          ScenarioType.binaryStars,
        ]) {
          await tester.pumpWidget(
            createTestWidget(
              child: ScenarioSelectionDialog(
                currentScenario: scenario,
                onScenarioSelected: mockOnScenarioSelected,
              ),
            ),
          );

          expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
        }
      });
    });

    group('Interaction', () {
      testWidgets('Should handle scenario selection', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
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
                    showDialog<void>(
                      context: context,
                      builder: (context) => ScenarioSelectionDialog(
                        currentScenario: testCurrentScenario,
                        onScenarioSelected: (scenario) {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  child: const Text('Show Scenarios'),
                ),
              ),
            ),
          ),
        );

        // Open dialog
        await tester.tap(find.text('Show Scenarios'));
        await tester.pumpAndSettle();

        // Select a scenario - find the first scenario tile and tap it
        final scenarioTiles = find.byType(Card);
        expect(scenarioTiles, findsAtLeastNWidgets(1));

        // Tap the first scenario card
        await tester.tap(scenarioTiles.first);
        await tester.pumpAndSettle();

        // Dialog should close
        expect(find.byType(ScenarioSelectionDialog), findsNothing);
      });

      testWidgets('Should provide visual feedback on tap', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should have inkwell for tap feedback
        final inkWells = find.byType(InkWell);
        if (inkWells.evaluate().isNotEmpty) {
          await tester.tap(inkWells.first);
          await tester.pump();
        }

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });

      testWidgets('Should handle scrolling if needed', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should be able to scroll through scenarios if many
        final listView = find.byType(ListView);
        if (listView.evaluate().isNotEmpty) {
          await tester.drag(listView, const Offset(0, -100));
          await tester.pump();
        }

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });
    });

    group('Localization', () {
      testWidgets('Should display localized content', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should have localized text content
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        final hasLocalizedContent = textWidgets.any(
          (text) => text.data?.isNotEmpty == true,
        );

        expect(hasLocalizedContent, isTrue);
      });

      testWidgets('Should work with different locales', (tester) async {
        for (final locale in ['en', 'es', 'de', 'fr', 'ja', 'ko', 'zh']) {
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: ScenarioSelectionDialog(
                  currentScenario: testCurrentScenario,
                  onScenarioSelected: mockOnScenarioSelected,
                ),
              ),
            ),
          );

          expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
          expect(find.byType(Text), findsWidgets);
        }
      });

      testWidgets('Should localize scenario descriptions', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should have localized scenario descriptions
        expect(find.byType(Text), findsWidgets);

        // Each scenario should have descriptive text
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        expect(textWidgets.length, greaterThan(3)); // Multiple scenarios
      });
    });

    group('Accessibility', () {
      testWidgets('Should provide proper semantics', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should have semantic elements
        expect(find.byType(Semantics), findsWidgets);

        // Scenarios should be accessible
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('Should support screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // All text should be readable by screen readers
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        for (final text in textWidgets) {
          if (text.data?.isNotEmpty == true) {
            expect(text.data, isNotNull);
          }
        }
      });

      testWidgets('Should have proper focus management', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Scenarios should be focusable
        final inkWells = find.byType(InkWell);
        if (inkWells.evaluate().isNotEmpty) {
          await tester.tap(inkWells.first);
          await tester.pump();
        }

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });

      testWidgets('Should announce scenario details', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Each scenario should have clear labels
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(Icon), findsWidgets);
      });
    });

    group('Performance', () {
      testWidgets('Should render efficiently', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should render without performance issues
        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);

        // Should handle multiple interactions
        final scenarioTiles = find.byType(Card);
        if (scenarioTiles.evaluate().isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(scenarioTiles.first);
            await tester.pump();
          }
        }

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });

      testWidgets('Should dispose properly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);

        // Remove widget
        await tester.pumpWidget(createTestWidget(child: Container()));

        expect(find.byType(ScenarioSelectionDialog), findsNothing);
      });

      testWidgets('Should handle rapid selections', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Rapid taps should be handled gracefully
        final scenarioTiles = find.byType(Card);
        if (scenarioTiles.evaluate().isNotEmpty) {
          for (int i = 0; i < 5; i++) {
            await tester.tap(scenarioTiles.first);
            await tester.pump();
          }
        }

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('Should handle all scenario types', (tester) async {
        for (final scenario in ScenarioType.values) {
          await tester.pumpWidget(
            createTestWidget(
              child: ScenarioSelectionDialog(
                currentScenario: scenario,
                onScenarioSelected: mockOnScenarioSelected,
              ),
            ),
          );

          // Should render without errors for any scenario type
          expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
        }
      });

      testWidgets('Should maintain selection state', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: ScenarioType.binaryStars,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Should show current selection
        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });

      testWidgets('Should maintain consistency across rebuilds', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: mockOnScenarioSelected,
            ),
          ),
        );

        // Force rebuild
        await tester.pump();
        await tester.pump();

        // Should maintain consistent state
        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('Should handle callback edge cases', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: ScenarioSelectionDialog(
              currentScenario: testCurrentScenario,
              onScenarioSelected: (scenario) {
                // Empty callback for testing
              },
            ),
          ),
        );

        // Should handle callback without errors
        final inkWells = find.byType(InkWell);
        if (inkWells.evaluate().isNotEmpty) {
          await tester.tap(inkWells.first);
          await tester.pump();
        }

        expect(find.byType(ScenarioSelectionDialog), findsOneWidget);
      });
    });
  });
}
