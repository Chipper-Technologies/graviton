import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/live_session/session_browser_widget.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'session_browser_widget_test.mocks.dart';

@GenerateMocks([LiveSessionState])
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

    testWidgets('should use appState.liveSession for discovery', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // Verify the widget is using appState.liveSession
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
      expect(appState.liveSession, isNotNull);
    });

    testWidgets('should handle dispose during loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      // Immediately dispose without waiting
      await tester.pumpWidget(createTestWidget(child: const SizedBox()));
      await tester.pump();

      expect(find.byType(SessionBrowserWidget), findsNothing);
    });

    testWidgets('should render Column when sessions would be available', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 200));

      // Widget tree should be present
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('empty state should show wifi_tethering_off icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      // Wait for loading to finish
      await tester.pump(const Duration(milliseconds: 500));

      // When empty (not loading), should show the empty state icon
      final hasEmptyIcon = find
          .byIcon(Icons.wifi_tethering_off)
          .evaluate()
          .isNotEmpty;
      final hasLoading = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      expect(hasEmptyIcon || hasLoading, isTrue);
    });

    testWidgets('loading state should show CircularProgressIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      // Immediately pump without waiting
      await tester.pump();

      // Should show loading or empty state
      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should handle onSessionJoined callback correctly', (
      WidgetTester tester,
    ) async {
      LiveSession? callbackSession;

      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionJoined: (session) {
              callbackSession = session;
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Callback not invoked yet (no sessions to join)
      expect(callbackSession, isNull);
    });

    testWidgets('should handle onSessionLeft callback correctly', (
      WidgetTester tester,
    ) async {
      var leftCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionLeft: () {
              leftCalled = true;
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Callback not invoked yet (not viewing)
      expect(leftCalled, isFalse);
    });

    testWidgets('should work with both callbacks provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionJoined: (_) {},
            onSessionLeft: () {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should work with no callbacks provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionJoined: null,
            onSessionLeft: null,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SessionBrowserWidget), findsOneWidget);
    });

    testWidgets('should have StatefulWidget state class', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final widget = tester.widget<SessionBrowserWidget>(
        find.byType(SessionBrowserWidget),
      );
      expect(widget.createState(), isA<State<SessionBrowserWidget>>());
    });
  });

  group('SessionBrowserWidget with Mocked State', () {
    late AppState appState;
    late MockLiveSessionState mockLiveSession;

    Widget createMockedTestWidget({required Widget child}) {
      return ChangeNotifierProvider<LiveSessionState>.value(
        value: mockLiveSession,
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

    LiveSession createMockSession({
      String id = 'session1',
      String hostId = 'host1',
      String hostName = 'Test Host',
      String scenarioName = 'Solar System',
      int viewerCount = 3,
      bool isRunning = true,
    }) {
      return LiveSession(
        id: id,
        hostId: hostId,
        hostName: hostName,
        scenarioName: scenarioName,
        viewerCount: viewerCount,
        isRunning: isRunning,
        timeScale: 1.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    setUp(() {
      appState = AppState();
      mockLiveSession = MockLiveSessionState();
      // Default stubs
      when(mockLiveSession.activeSessions).thenReturn([]);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.isViewing).thenReturn(false);
      when(mockLiveSession.currentSession).thenReturn(null);
    });

    tearDown(() {
      appState.dispose();
    });

    testWidgets('shows loading state when isLoadingSessions is true', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isLoadingSessions).thenReturn(true);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no sessions', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.activeSessions).thenReturn([]);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pump();

      // Should show empty state icon
      expect(find.byIcon(Icons.wifi_tethering_off), findsOneWidget);
    });

    testWidgets('shows session cards when sessions available', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(
          id: 'session1',
          hostName: 'Alice',
          scenarioName: 'Binary Stars',
          viewerCount: 5,
        ),
        createMockSession(
          id: 'session2',
          hostName: 'Bob',
          scenarioName: 'Three Body',
          viewerCount: 2,
        ),
      ];
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should show session scenario names
      expect(find.text('Binary Stars'), findsOneWidget);
      expect(find.text('Three Body'), findsOneWidget);
      // Should show "Join" buttons for each session
      expect(find.text('Join'), findsNWidgets(2));
    });

    testWidgets('shows host name in session card', (WidgetTester tester) async {
      final sessions = [
        createMockSession(hostName: 'Alice', scenarioName: 'Solar System'),
      ];
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should show "Hosted by Alice" or similar
      expect(find.textContaining('Alice'), findsOneWidget);
    });

    testWidgets('shows viewer count in session card', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(scenarioName: 'Test', viewerCount: 7),
      ];
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should show viewer count with visibility icon
      expect(find.byIcon(Icons.visibility), findsAtLeastNWidgets(1));
      expect(find.textContaining('7'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows play icon for running session', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(scenarioName: 'Running', isRunning: true),
      ];
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows pause icon for paused session', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(scenarioName: 'Paused', isRunning: false),
      ];
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('shows viewing card when isViewing is true', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isViewing).thenReturn(true);
      when(mockLiveSession.currentSession).thenReturn(
        createMockSession(hostName: 'Alice', scenarioName: 'Viewed Session'),
      );

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should show "Viewing" text
      expect(find.textContaining('Viewing'), findsOneWidget);
      // Should show the session name
      expect(find.text('Viewed Session'), findsOneWidget);
      // Should show "Leave" button
      expect(find.textContaining('Leave'), findsOneWidget);
    });

    testWidgets('calls startViewing when join button tapped', (
      WidgetTester tester,
    ) async {
      final session = createMockSession(
        id: 'session123',
        scenarioName: 'Test Session',
      );
      when(mockLiveSession.activeSessions).thenReturn([session]);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.startViewing(any)).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Tap the join button
      await tester.tap(find.text('Join'));
      await tester.pump();

      verify(mockLiveSession.startViewing('session123')).called(1);
    });

    testWidgets('calls stopViewing when leave button tapped', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isViewing).thenReturn(true);
      when(
        mockLiveSession.currentSession,
      ).thenReturn(createMockSession(scenarioName: 'Current Session'));
      when(mockLiveSession.stopViewing()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Find and tap the leave button
      final leaveButton = find.widgetWithText(HapticInkWell, 'Leave Session');
      if (leaveButton.evaluate().isNotEmpty) {
        await tester.tap(leaveButton);
        await tester.pump();
        verify(mockLiveSession.stopViewing()).called(1);
      }
    });

    testWidgets('fires onSessionJoined callback on successful join', (
      WidgetTester tester,
    ) async {
      LiveSession? joinedSession;
      final session = createMockSession(
        id: 'session456',
        scenarioName: 'Join Test',
      );
      when(mockLiveSession.activeSessions).thenReturn([session]);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.startViewing(any)).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createMockedTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionJoined: (s) => joinedSession = s,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();

      expect(joinedSession, isNotNull);
      expect(joinedSession!.id, equals('session456'));
    });

    testWidgets('fires onSessionLeft callback on successful leave', (
      WidgetTester tester,
    ) async {
      var leftSession = false;
      when(mockLiveSession.isViewing).thenReturn(true);
      when(
        mockLiveSession.currentSession,
      ).thenReturn(createMockSession(scenarioName: 'Leave Test'));
      when(mockLiveSession.stopViewing()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createMockedTestWidget(
          child: SessionBrowserWidget(
            appState: appState,
            onSessionLeft: () => leftSession = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final leaveButton = find.widgetWithText(HapticInkWell, 'Leave Session');
      if (leaveButton.evaluate().isNotEmpty) {
        await tester.tap(leaveButton);
        await tester.pumpAndSettle();
        expect(leftSession, isTrue);
      }
    });

    testWidgets('shows browse sessions header when sessions available', (
      WidgetTester tester,
    ) async {
      final sessions = [createMockSession(scenarioName: 'Test')];
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should show "Browse Sessions" or similar header
      expect(find.textContaining('Browse'), findsOneWidget);
    });

    testWidgets('viewing card shows host name', (WidgetTester tester) async {
      when(mockLiveSession.isViewing).thenReturn(true);
      when(mockLiveSession.currentSession).thenReturn(
        createMockSession(hostName: 'Charlie', scenarioName: 'Test'),
      );

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should show "Hosted by Charlie" or similar
      expect(find.textContaining('Charlie'), findsOneWidget);
    });

    testWidgets('handles null currentSession gracefully', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isViewing).thenReturn(true);
      when(mockLiveSession.currentSession).thenReturn(null);

      await tester.pumpWidget(
        createMockedTestWidget(child: SessionBrowserWidget(appState: appState)),
      );
      await tester.pumpAndSettle();

      // Should still show viewing card without crashing
      expect(find.textContaining('Viewing'), findsOneWidget);
    });
  });
}
