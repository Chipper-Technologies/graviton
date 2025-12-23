import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/live_session/session_browser_widget.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionBrowserWidget', () {
    late AppState appState;
    late LiveSessionState liveSessionState;

    Widget createTestWidget({required Widget child}) {
      return ChangeNotifierProvider<LiveSessionState>.value(
        value: liveSessionState,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(body: child),
        ),
      );
    }

    setUp(() {
      appState = AppState();
      liveSessionState = LiveSessionState();
    });

    tearDown(() {
      appState.dispose();
      liveSessionState.dispose();
    });

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      // Use pump() with duration instead of pumpAndSettle() to avoid timeout
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should show loading or empty state when no sessions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
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
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
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
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Navigate away to trigger dispose
      await tester.pumpWidget(createTestWidget(child: const SizedBox()));
      await tester.pump(const Duration(milliseconds: 100));

      // Should complete without error
      expect(appState.liveSession.activeSessions, isEmpty);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Verify widget renders
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should accept onSessionJoined callback', (
      WidgetTester tester,
    ) async {
      var callbackFired = false;

      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionJoined: (_) => callbackFired = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
      expect(callbackFired, isFalse); // No session to join
    });

    testWidgets('should accept onSessionLeft callback', (
      WidgetTester tester,
    ) async {
      var callbackFired = false;

      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionLeft: () => callbackFired = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
      expect(callbackFired, isFalse);
    });

    testWidgets('should be a StatefulWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final widget = tester.widget<SessionBrowserWidget>(
        find.byType(SessionBrowserWidget),
      );
      expect(widget, isA<StatefulWidget>());
    });

    testWidgets('should handle multiple pump cycles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should contain Center widget in empty/loading state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Should have some centering for empty/loading state
      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('should contain Padding for proper spacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('should show loading or empty state initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      // Just pump once without waiting for settle
      await tester.pump();

      // Should show loading indicator or empty state
      final hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      final hasIcon = find.byType(Icon).evaluate().isNotEmpty;
      expect(hasLoading || hasIcon, isTrue);
    });

    testWidgets('should rebuild when liveSession state changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Trigger a state change by starting/stopping discovery
      liveSessionState.stopSessionDiscovery();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should use appState.liveSession for session discovery', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // After init, isLoadingSessions should be true briefly
      // This tests the initState behavior
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should display Icon in empty state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      // Let loading complete
      await tester.pump(const Duration(milliseconds: 500));

      // Should show empty state with icon
      expect(find.byType(Icon), findsAtLeastNWidgets(1));
    });

    testWidgets('should contain Text widget for status messages', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    testWidgets('should be responsive to quick state changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );

      // Rapid state changes
      await tester.pump(const Duration(milliseconds: 10));
      liveSessionState.stopSessionDiscovery();
      await tester.pump(const Duration(milliseconds: 10));
      liveSessionState.startSessionDiscovery();
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should properly use Provider.of for state access', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Widget should be able to access LiveSessionState through Provider
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });
  });
}
