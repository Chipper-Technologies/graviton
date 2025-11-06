import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/body_properties_dialog.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BodyPropertiesDialog Tests', () {
    late Body testBody;
    late AppState appState;

    setUp(() {
      testBody = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 100.0,
        radius: 2.0,
        color: AppColors.primaryColor,
        name: 'Test Body',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
      );

      appState = AppState();
      // Add the test body to the simulation so auto-setting logic works
      appState.simulation.bodies.add(testBody);
    });

    Widget createTestWidget({required Widget child}) {
      return ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('should display dialog with body properties', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: BodyPropertiesDialog(
            body: testBody,
            bodyIndex: 0,
            onBodyChanged: (updatedBody) {},
          ),
        ),
      );

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Body Properties'), findsOneWidget);
    });

    testWidgets('should handle gravity wells functionality', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: BodyPropertiesDialog(
            body: testBody,
            bodyIndex: 0,
            onBodyChanged: (body) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Dialog should display and work with gravity wells
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(SwitchListTile), findsWidgets);
    });

    testWidgets('should allow toggling individual gravity well setting', (
      tester,
    ) async {
      // Start with gravity well disabled
      testBody.showGravityWell = false;

      await tester.pumpWidget(
        createTestWidget(
          child: BodyPropertiesDialog(
            body: testBody,
            bodyIndex: 0,
            onBodyChanged: (body) {
              // Body change callback
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the gravity wells switch
      final gravityWellSwitch = find.byType(SwitchListTile);
      expect(gravityWellSwitch, findsAtLeastNWidgets(1));

      // Initially, the switch should be OFF (individual setting)
      SwitchListTile switchWidget = tester.widget(gravityWellSwitch.first);
      expect(switchWidget.value, false);

      // Tap the switch to turn it ON
      await tester.tap(gravityWellSwitch.first);
      await tester.pumpAndSettle();

      // Verify the switch is now ON
      switchWidget = tester.widget(gravityWellSwitch.first);
      expect(switchWidget.value, true);
    });

    testWidgets(
      'should show individual setting when global gravity fields enabled',
      (tester) async {
        // Start with body gravity well OFF
        testBody.showGravityWell = false;

        // Enable global gravity fields - this should auto-set all bodies to showGravityWell = true
        appState.ui.toggleGlobalGravityFields();

        await tester.pumpWidget(
          createTestWidget(
            child: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the gravity wells switch
        final gravityWellSwitch = find.byType(SwitchListTile);
        expect(gravityWellSwitch, findsAtLeastNWidgets(1));

        // With the new logic, when global gravity fields is enabled,
        // AppState automatically sets all bodies to showGravityWell = true
        // so the switch should show ON (true)
        SwitchListTile switchWidget = tester.widget(gravityWellSwitch.first);
        expect(
          switchWidget.value,
          true,
          reason:
              "When global is enabled, bodies are auto-set to showGravityWell = true",
        );

        // Tap the switch to turn individual setting OFF (override global)
        await tester.tap(gravityWellSwitch.first);
        await tester.pumpAndSettle();

        // Verify the switch is now OFF (individual override)
        switchWidget = tester.widget(gravityWellSwitch.first);
        expect(switchWidget.value, false);

        // Tap again to turn individual setting back ON
        await tester.tap(gravityWellSwitch.first);
        await tester.pumpAndSettle();

        // Verify the switch is now ON (individual setting)
        switchWidget = tester.widget(gravityWellSwitch.first);
        expect(switchWidget.value, true);
      },
    );
  });
}
