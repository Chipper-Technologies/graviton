import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/features/scenarios/presentation/widgets/custom_scenarios_tab.dart';
import 'package:graviton/core/enums/scenario_type.dart';

import '../test_utils.dart';

void main() {
  group('CustomScenariosTab i18n Tests', () {
    testWidgets('should display localized deletion success message', (
      WidgetTester tester,
    ) async {
      // Test that the new localized success message key exists
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;

              // Verify the method exists and returns proper formatted string
              final message = l10n.deleteScenarioSuccessMessage(
                'Test Scenario',
              );
              expect(message, contains('Test Scenario'));
              expect(message, isNot(contains('{scenarioName}')));

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should display localized deletion failure message', (
      WidgetTester tester,
    ) async {
      // Test that the new localized failure message key exists
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;

              // Verify the method exists and returns proper formatted string
              final message = l10n.deleteScenarioFailedMessage(
                'Connection failed',
              );
              expect(message, contains('Connection failed'));
              expect(message, isNot(contains('{error}')));

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should create widget without throwing i18n errors', (
      WidgetTester tester,
    ) async {
      // Verify CustomScenariosTab can be created with all localization keys
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: CustomScenariosTab(
            onScenarioSelected: (ScenarioType type) {},
            onCustomScenarioSelected: (String name) {},
          ),
        ),
      );

      // Should not throw any localization errors
      expect(find.byType(CustomScenariosTab), findsOneWidget);
    });

    testWidgets('should verify all required localization keys exist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;

              // Verify all scenario-related keys exist and are accessible
              expect(l10n.deleteScenarioTitle, isNotEmpty);
              expect(l10n.deleteScenarioConfirmMessage('Test'), isNotEmpty);
              expect(l10n.deleteScenarioSuccessMessage('Test'), isNotEmpty);
              expect(l10n.deleteScenarioFailedMessage('Error'), isNotEmpty);
              expect(l10n.cancel, isNotEmpty);
              expect(l10n.deleteButton, isNotEmpty);

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
