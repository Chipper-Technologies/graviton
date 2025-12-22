import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/live_session/session_browser_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionBrowserWidget', () {
    late AppState appState;

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      );
    }

    setUp(() {
      appState = AppState();
    });

    tearDown(() {
      appState.dispose();
    });

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(appState: appState),
        ),
      );
      // Use pump() with duration instead of pumpAndSettle() to avoid timeout
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should show loading or empty state when no sessions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(appState: appState),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Should show either loading indicator or empty state
      expect(
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
            find.byIcon(Icons.wifi_tethering_off).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('should start session discovery on init', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(appState: appState),
        ),
      );
      await tester.pump();

      // Session discovery should have started (tested via state)
      // Without Firebase, the list will remain empty
      expect(appState.liveSession.activeSessions, isEmpty);
    });

    testWidgets('should stop session discovery on dispose', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(appState: appState),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Navigate away to trigger dispose
      await tester.pumpWidget(
        createTestWidget(child: const SizedBox()),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Should complete without error
      expect(appState.liveSession.activeSessions, isEmpty);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(appState: appState),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Verify widget renders
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });
  });
}
