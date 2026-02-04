import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/live_session/presentation/widgets/browse_sessions_tab.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/camera_snapshot.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/models/firebase/simulation_snapshot.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'browse_sessions_tab_test.mocks.dart';

@GenerateMocks([LiveSessionState])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BrowseSessionsTab', () {
    late AppState appState;
    late LiveSessionState liveSessionState;
    late PremiumState premiumState;

    Widget createTestWidget({
      void Function(LiveSession)? onSessionJoined,
      VoidCallback? onSessionLeft,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<LiveSessionState>.value(
            value: liveSessionState,
          ),
          ChangeNotifierProvider<PremiumState>.value(value: premiumState),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: BrowseSessionsTab(
              appState: appState,
              onSessionJoined: onSessionJoined,
              onSessionLeft: onSessionLeft,
            ),
          ),
        ),
      );
    }

    setUp(() {
      appState = AppState();
      liveSessionState = LiveSessionState();
      premiumState = PremiumState();
    });

    tearDown(() {
      appState.dispose();
      liveSessionState.dispose();
      premiumState.dispose();
    });

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(BrowseSessionsTab), findsOneWidget);
    });

    testWidgets('should show loading or empty state initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Should show either loading indicator or empty state
      expect(
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
            find.byIcon(Icons.wifi_tethering_off).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('should accept callbacks', (WidgetTester tester) async {
      var joinedCalled = false;
      var leftCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          onSessionJoined: (_) => joinedCalled = true,
          onSessionLeft: () => leftCalled = true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(BrowseSessionsTab), findsOneWidget);
      expect(joinedCalled, isFalse);
      expect(leftCalled, isFalse);
    });

    testWidgets('should have StatefulWidget state class', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      final widget = tester.widget<BrowseSessionsTab>(
        find.byType(BrowseSessionsTab),
      );
      expect(widget.createState(), isA<State<BrowseSessionsTab>>());
    });
  });

  group('BrowseSessionsTab with Mocked State', () {
    late AppState appState;
    late MockLiveSessionState mockLiveSession;
    late PremiumState premiumState;

    Widget createMockedTestWidget({
      void Function(LiveSession)? onSessionJoined,
      VoidCallback? onSessionLeft,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<LiveSessionState>.value(
            value: mockLiveSession,
          ),
          ChangeNotifierProvider<PremiumState>.value(value: premiumState),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: BrowseSessionsTab(
              appState: appState,
              onSessionJoined: onSessionJoined,
              onSessionLeft: onSessionLeft,
            ),
          ),
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
      bool isPasswordProtected = false,
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
        isPasswordProtected: isPasswordProtected,
      );
    }

    setUp(() {
      appState = AppState();
      mockLiveSession = MockLiveSessionState();
      premiumState = PremiumState();

      // Default mock behavior
      when(mockLiveSession.isHosting).thenReturn(false);
      when(mockLiveSession.isViewing).thenReturn(false);
      when(mockLiveSession.isInSession).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn([]);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.hostedSessionId).thenReturn(null);
      when(mockLiveSession.latestSnapshot).thenReturn(null);
    });

    tearDown(() {
      appState.dispose();
      premiumState.dispose();
    });

    testWidgets('should show loading state when loading', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isLoadingSessions).thenReturn(true);
      when(mockLiveSession.activeSessions).thenReturn([]);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show empty state when no sessions', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn([]);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.wifi_tethering_off), findsOneWidget);
      expect(find.text('No active sessions'), findsOneWidget);
    });

    testWidgets('should show session list when sessions available', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(
          id: 'session1',
          hostName: 'Host 1',
          scenarioName: 'Solar System',
        ),
        createMockSession(
          id: 'session2',
          hostName: 'Host 2',
          scenarioName: 'Binary Star',
        ),
      ];

      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn(sessions);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Look for localized text 'Hosted by Host 1' - use textContaining for flexibility
      expect(find.textContaining('Host 1'), findsOneWidget);
      expect(find.text('Solar System'), findsOneWidget);
      expect(find.textContaining('Host 2'), findsOneWidget);
      expect(find.text('Binary Star'), findsOneWidget);
    });

    testWidgets('should show lock icon for password protected sessions', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(
          id: 'session1',
          hostName: 'Protected Host',
          scenarioName: 'Protected Scenario',
          isPasswordProtected: true,
        ),
      ];

      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn(sessions);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('should show viewer count for sessions', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(
          id: 'session1',
          hostName: 'Popular Host',
          scenarioName: 'Popular Scenario',
          viewerCount: 5,
        ),
      ];

      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn(sessions);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('5 viewers'), findsOneWidget);
    });

    testWidgets('should show viewing card when viewing a session', (
      WidgetTester tester,
    ) async {
      final session = createMockSession(
        id: 'viewing-session',
        hostName: 'Current Host',
        scenarioName: 'Current Scenario',
      );

      when(mockLiveSession.isViewing).thenReturn(true);
      when(mockLiveSession.currentSession).thenReturn(session);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn([]);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Look for session info in viewing card
      expect(find.textContaining('Current Host'), findsOneWidget);
      expect(find.textContaining('Leave'), findsOneWidget);
    });

    testWidgets(
      'should show camera sync indicator when host has camera sync enabled',
      (WidgetTester tester) async {
        final session = createMockSession(
          id: 'viewing-session',
          hostName: 'Current Host',
          scenarioName: 'Current Scenario',
        );

        // Create a snapshot with camera sync (has camera data)
        final snapshotWithCamera = SimulationSnapshot(
          bodies: [],
          isRunning: true,
          timeScale: 1.0,
          totalTime: 100.0,
          stepCount: 50,
          timestamp: DateTime.now(),
          camera: CameraSnapshot(
            yaw: 0.0,
            pitch: 0.0,
            roll: 0.0,
            distance: 100.0,
            target: vm.Vector3.zero(),
            followMode: false,
            autoRotate: false,
            fieldOfView: 60.0,
          ),
        );

        when(mockLiveSession.isViewing).thenReturn(true);
        when(mockLiveSession.currentSession).thenReturn(session);
        when(mockLiveSession.isLoadingSessions).thenReturn(false);
        when(mockLiveSession.activeSessions).thenReturn([]);
        when(mockLiveSession.latestSnapshot).thenReturn(snapshotWithCamera);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Camera sync indicator should be visible
        expect(find.byIcon(Icons.videocam), findsOneWidget);
        expect(find.text('Camera controlled by host'), findsOneWidget);
      },
    );

    testWidgets(
      'should not show camera sync indicator when host has no camera sync',
      (WidgetTester tester) async {
        final session = createMockSession(
          id: 'viewing-session',
          hostName: 'Current Host',
          scenarioName: 'Current Scenario',
        );

        // Create a snapshot without camera sync (no camera data)
        final snapshotWithoutCamera = SimulationSnapshot(
          bodies: [],
          isRunning: true,
          timeScale: 1.0,
          totalTime: 100.0,
          stepCount: 50,
          timestamp: DateTime.now(),
          camera: null,
        );

        when(mockLiveSession.isViewing).thenReturn(true);
        when(mockLiveSession.currentSession).thenReturn(session);
        when(mockLiveSession.isLoadingSessions).thenReturn(false);
        when(mockLiveSession.activeSessions).thenReturn([]);
        when(mockLiveSession.latestSnapshot).thenReturn(snapshotWithoutCamera);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Camera sync indicator should not be visible
        expect(find.text('Camera controlled by host'), findsNothing);
      },
    );

    testWidgets(
      'should not show camera sync indicator when no snapshot available',
      (WidgetTester tester) async {
        final session = createMockSession(
          id: 'viewing-session',
          hostName: 'Current Host',
          scenarioName: 'Current Scenario',
        );

        when(mockLiveSession.isViewing).thenReturn(true);
        when(mockLiveSession.currentSession).thenReturn(session);
        when(mockLiveSession.isLoadingSessions).thenReturn(false);
        when(mockLiveSession.activeSessions).thenReturn([]);
        when(mockLiveSession.latestSnapshot).thenReturn(null);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Camera sync indicator should not be visible
        expect(find.text('Camera controlled by host'), findsNothing);
      },
    );

    testWidgets('should show description text', (WidgetTester tester) async {
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn([]);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Join a live session'), findsOneWidget);
    });

    testWidgets('should handle join button tap', (WidgetTester tester) async {
      final sessions = [
        createMockSession(
          id: 'session1',
          hostName: 'Test Host',
          scenarioName: 'Test Scenario',
          isPasswordProtected: false,
        ),
      ];

      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn(sessions);
      when(
        mockLiveSession.startViewing(any, password: anyNamed('password')),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the Join button
      await tester.tap(find.text('Join'));
      await tester.pump(const Duration(milliseconds: 100));

      verify(mockLiveSession.startViewing('session1')).called(1);
    });

    testWidgets('should show password dialog for protected sessions', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(
          id: 'protected-session',
          hostName: 'Protected Host',
          scenarioName: 'Protected Scenario',
          isPasswordProtected: true,
        ),
      ];

      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn(sessions);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the Join button
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();

      // Password dialog should be shown
      expect(find.text('Enter Password'), findsOneWidget);
    });

    testWidgets('password dialog should use DialogTitle and HapticTextButton', (
      WidgetTester tester,
    ) async {
      final sessions = [
        createMockSession(
          id: 'protected-session',
          hostName: 'Protected Host',
          scenarioName: 'Protected Scenario',
          isPasswordProtected: true,
        ),
      ];

      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn(sessions);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the Join button
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();

      // Dialog should use standard DialogTitle component
      expect(find.byType(DialogTitle), findsOneWidget);

      // Dialog should use HapticTextButton for actions
      expect(find.byType(HapticTextButton), findsNWidgets(2));
    });
  });
}
