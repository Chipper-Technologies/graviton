import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/features/auth/state/auth_state.dart';
import 'package:graviton/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:graviton/features/live_session/presentation/widgets/browse_sessions_tab.dart';
import 'package:graviton/features/live_session/presentation/widgets/start_sharing_tab.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';
import 'package:graviton/widgets/live_session/connection_status_indicator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'live_session_screen_test.mocks.dart';

@GenerateMocks([LiveSessionState, AuthState])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LiveSessionScreen', () {
    late AppState appState;
    late LiveSessionState liveSessionState;

    Widget createTestWidget({
      VoidCallback? onHostingChanged,
      VoidCallback? onViewingChanged,
    }) {
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
          home: LiveSessionScreen(
            appState: appState,
            onHostingChanged: onHostingChanged,
            onViewingChanged: onViewingChanged,
          ),
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
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LiveSessionScreen), findsOneWidget);
    });

    testWidgets('should show HapticAppBar with title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HapticAppBar), findsOneWidget);
      expect(find.text('Live Sessions'), findsOneWidget);
    });

    testWidgets('should show GravitonTabbedView with two tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(GravitonTabbedView), findsOneWidget);
      expect(find.text('Browse'), findsOneWidget);
      expect(find.text('Sharing'), findsOneWidget);
    });

    testWidgets('should show Browse tab by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Browse tab should be visible
      expect(find.byType(BrowseSessionsTab), findsOneWidget);
    });

    testWidgets('should switch to Sharing tab when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Tap on Sharing tab
      await tester.tap(find.text('Sharing'));
      await tester.pumpAndSettle();

      // Sharing tab should now be visible
      expect(find.byType(StartSharingTab), findsOneWidget);
    });

    testWidgets('should accept optional callbacks', (
      WidgetTester tester,
    ) async {
      var hostingChanged = false;
      var viewingChanged = false;

      await tester.pumpWidget(
        createTestWidget(
          onHostingChanged: () => hostingChanged = true,
          onViewingChanged: () => viewingChanged = true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LiveSessionScreen), findsOneWidget);
      expect(hostingChanged, isFalse);
      expect(viewingChanged, isFalse);
    });

    testWidgets('should have StatefulWidget state class', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      final widget = tester.widget<LiveSessionScreen>(
        find.byType(LiveSessionScreen),
      );
      expect(widget.createState(), isA<State<LiveSessionScreen>>());
    });
  });

  group('LiveSessionScreen with Mocked State', () {
    late AppState appState;
    late MockLiveSessionState mockLiveSession;

    Widget createMockedTestWidget({
      VoidCallback? onHostingChanged,
      VoidCallback? onViewingChanged,
    }) {
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
          home: LiveSessionScreen(
            appState: appState,
            onHostingChanged: onHostingChanged,
            onViewingChanged: onViewingChanged,
          ),
        ),
      );
    }

    setUp(() {
      appState = AppState();
      mockLiveSession = MockLiveSessionState();

      // Default mock behavior
      when(mockLiveSession.isHosting).thenReturn(false);
      when(mockLiveSession.isViewing).thenReturn(false);
      when(mockLiveSession.isInSession).thenReturn(false);
      when(mockLiveSession.activeSessions).thenReturn([]);
      when(mockLiveSession.isLoadingSessions).thenReturn(false);
      when(mockLiveSession.currentSession).thenReturn(null);
      when(mockLiveSession.hostedSession).thenReturn(null);
      when(mockLiveSession.hostedSessionId).thenReturn(null);
      when(mockLiveSession.stopHosting()).thenAnswer((_) async => true);
      when(mockLiveSession.stopViewing()).thenAnswer((_) async => true);
      when(mockLiveSession.syncCameraWithViewers).thenReturn(false);
      when(mockLiveSession.latestSnapshot).thenReturn(null);
    });

    tearDown(() {
      appState.dispose();
    });

    testWidgets('should not show connection indicator when not in session', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isInSession).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Connection indicator should not be in app bar
      expect(find.byIcon(Icons.wifi), findsNothing);
    });

    testWidgets('should show connection indicator when in session', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isInSession).thenReturn(true);
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(2);
      when(
        mockLiveSession.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Connection status indicator should be visible
      expect(find.byType(LiveSessionScreen), findsOneWidget);
    });

    testWidgets('should start on Browse tab when not hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(false);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(BrowseSessionsTab), findsOneWidget);
    });

    testWidgets('should start on Sharing tab when already hosting', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.isInSession).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);
      when(
        mockLiveSession.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Should show Sharing tab when hosting
      expect(find.byType(StartSharingTab), findsOneWidget);
    });

    testWidgets(
      'should show session settings when connection indicator tapped',
      (WidgetTester tester) async {
        when(mockLiveSession.isInSession).thenReturn(true);
        when(mockLiveSession.isHosting).thenReturn(true);
        when(mockLiveSession.viewerCount).thenReturn(3);
        when(
          mockLiveSession.connectionStatus,
        ).thenReturn(LiveSessionConnectionStatus.connected);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Find and tap the connection indicator in the app bar
        final indicator = find.ancestor(
          of: find.byType(ConnectionStatusIndicator),
          matching: find.byType(HapticInkWell),
        );
        await tester.tap(indicator);
        await tester.pumpAndSettle();

        // Session settings dialog should appear
        expect(find.text('Session Settings'), findsOneWidget);
        // Viewer count appears in both the tab and the dialog
        expect(find.text('3 viewers'), findsAtLeastNWidgets(1));
      },
    );

    testWidgets('should show host info in session settings when viewing', (
      WidgetTester tester,
    ) async {
      final mockSession = LiveSession(
        id: 'test-session',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Test Scenario',
        isRunning: true,
        timeScale: 1.0,
        viewerCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockLiveSession.isInSession).thenReturn(true);
      when(mockLiveSession.isHosting).thenReturn(false);
      when(mockLiveSession.isViewing).thenReturn(true);
      when(mockLiveSession.currentSession).thenReturn(mockSession);
      when(
        mockLiveSession.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the connection indicator in the app bar
      final indicator = find.ancestor(
        of: find.byType(ConnectionStatusIndicator),
        matching: find.byType(HapticInkWell),
      );
      await tester.tap(indicator);
      await tester.pumpAndSettle();

      // Session settings dialog should show host info
      expect(find.text('Session Settings'), findsOneWidget);
      // Host info appears in both the tab and the dialog
      expect(find.text('Hosted by Test Host'), findsAtLeastNWidgets(1));
    });

    testWidgets('should stop hosting when stop button pressed in settings', (
      WidgetTester tester,
    ) async {
      var hostingChanged = false;

      when(mockLiveSession.isInSession).thenReturn(true);
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);
      when(
        mockLiveSession.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(
        createMockedTestWidget(onHostingChanged: () => hostingChanged = true),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Open session settings via connection indicator in app bar
      final indicator = find.ancestor(
        of: find.byType(ConnectionStatusIndicator),
        matching: find.byType(HapticInkWell),
      );
      await tester.tap(indicator);
      await tester.pumpAndSettle();

      // Tap stop sharing button in the dialog
      await tester.tap(find.text('Stop Sharing').last);
      await tester.pumpAndSettle();

      // Verify stopHosting was called and callback invoked
      verify(mockLiveSession.stopHosting()).called(1);
      expect(hostingChanged, isTrue);
    });

    testWidgets('should leave session when leave button pressed in settings', (
      WidgetTester tester,
    ) async {
      var viewingChanged = false;

      final mockSession = LiveSession(
        id: 'test-session',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Test Scenario',
        isRunning: true,
        timeScale: 1.0,
        viewerCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockLiveSession.isInSession).thenReturn(true);
      when(mockLiveSession.isHosting).thenReturn(false);
      when(mockLiveSession.isViewing).thenReturn(true);
      when(mockLiveSession.currentSession).thenReturn(mockSession);
      when(
        mockLiveSession.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(
        createMockedTestWidget(onViewingChanged: () => viewingChanged = true),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Open session settings via connection indicator in app bar
      final indicator = find.ancestor(
        of: find.byType(ConnectionStatusIndicator),
        matching: find.byType(HapticInkWell),
      );
      await tester.tap(indicator);
      await tester.pumpAndSettle();

      // Tap leave button in the dialog
      await tester.tap(find.text('Leave Session').last);
      await tester.pumpAndSettle();

      // Verify stopViewing was called and callback invoked
      verify(mockLiveSession.stopViewing()).called(1);
      expect(viewingChanged, isTrue);
    });

    testWidgets('should close settings dialog when close button pressed', (
      WidgetTester tester,
    ) async {
      when(mockLiveSession.isInSession).thenReturn(true);
      when(mockLiveSession.isHosting).thenReturn(true);
      when(mockLiveSession.viewerCount).thenReturn(0);
      when(
        mockLiveSession.connectionStatus,
      ).thenReturn(LiveSessionConnectionStatus.connected);

      await tester.pumpWidget(createMockedTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Open session settings via connection indicator in app bar
      final indicator = find.ancestor(
        of: find.byType(ConnectionStatusIndicator),
        matching: find.byType(HapticInkWell),
      );
      await tester.tap(indicator);
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Session Settings'), findsOneWidget);

      // Tap close button in the dialog
      await tester.tap(find.text('Close').last);
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Session Settings'), findsNothing);
    });

    testWidgets(
      'session settings dialog should use DialogTitle and HapticTextButton',
      (WidgetTester tester) async {
        when(mockLiveSession.isInSession).thenReturn(true);
        when(mockLiveSession.isHosting).thenReturn(true);
        when(mockLiveSession.viewerCount).thenReturn(0);
        when(
          mockLiveSession.connectionStatus,
        ).thenReturn(LiveSessionConnectionStatus.connected);

        await tester.pumpWidget(createMockedTestWidget());
        await tester.pump(const Duration(milliseconds: 100));

        // Open session settings via connection indicator in app bar
        final indicator = find.ancestor(
          of: find.byType(ConnectionStatusIndicator),
          matching: find.byType(HapticInkWell),
        );
        await tester.tap(indicator);
        await tester.pumpAndSettle();

        // Dialog should use standard DialogTitle component
        expect(find.byType(DialogTitle), findsOneWidget);

        // Dialog should use HapticTextButton for actions
        expect(find.byType(HapticTextButton), findsNWidgets(2));
      },
    );
  });

  group('LiveSessionScreen.show', () {
    late AppState appState;
    late LiveSessionState liveSessionState;
    late MockAuthState mockAuthState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      appState = AppState();
      liveSessionState = LiveSessionState();
      mockAuthState = MockAuthState();

      // Set up authenticated user
      when(mockAuthState.isAuthenticated).thenReturn(true);
    });

    tearDown(() {
      appState.dispose();
      liveSessionState.dispose();
    });

    testWidgets('should navigate to LiveSessionScreen when authenticated', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LiveSessionState>.value(
              value: liveSessionState,
            ),
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    LiveSessionScreen.show(context, appState: appState),
                child: const Text('Open Live Session'),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Tap the button to navigate
      await tester.tap(find.text('Open Live Session'));
      await tester.pumpAndSettle();

      // Should show the LiveSessionScreen
      expect(find.byType(LiveSessionScreen), findsOneWidget);
    });

    testWidgets('should show auth dialog when not authenticated', (
      WidgetTester tester,
    ) async {
      when(mockAuthState.isAuthenticated).thenReturn(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LiveSessionState>.value(
              value: liveSessionState,
            ),
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    LiveSessionScreen.show(context, appState: appState),
                child: const Text('Open Live Session'),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Tap the button to navigate
      await tester.tap(find.text('Open Live Session'));
      await tester.pumpAndSettle();

      // Should show the auth required dialog
      expect(find.text('Account Required'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should close auth dialog when Cancel pressed', (
      WidgetTester tester,
    ) async {
      when(mockAuthState.isAuthenticated).thenReturn(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<LiveSessionState>.value(
              value: liveSessionState,
            ),
            ChangeNotifierProvider<AuthState>.value(value: mockAuthState),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    LiveSessionScreen.show(context, appState: appState),
                child: const Text('Open Live Session'),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Open auth dialog
      await tester.tap(find.text('Open Live Session'));
      await tester.pumpAndSettle();

      expect(find.text('Account Required'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed, still on home screen
      expect(find.text('Account Required'), findsNothing);
      expect(find.text('Open Live Session'), findsOneWidget);
    });
  });
}
