import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/floating_simulation_controls.dart';
import 'package:provider/provider.dart';

void main() {
  group('FloatingSimulationControls', () {
    late AppState testAppState;

    setUp(() async {
      testAppState = AppState();
      await testAppState.initializeAsync();
    });

    tearDown(() {
      testAppState.dispose();
    });

    Widget createTestWidget({required Widget child}) {
      return ChangeNotifierProvider<AppState>.value(
        value: testAppState,
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

    testWidgets('Should create widget without crashing', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const FloatingSimulationControls()),
      );
      await tester.pump();

      // Basic check that widget is created
      expect(find.byType(FloatingSimulationControls), findsOneWidget);

      // Clean up properly to avoid timer issues
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
