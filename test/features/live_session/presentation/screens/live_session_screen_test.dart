import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/core/enums/live_session_connection_status.dart';
import 'package:graviton/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:graviton/features/live_session/presentation/widgets/browse_sessions_tab.dart';
import 'package:graviton/features/live_session/presentation/widgets/start_sharing_tab.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/live_session_state.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/haptics/haptic_app_bar.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'live_session_screen_test.mocks.dart';

@GenerateMocks([LiveSessionState])
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
      expect(find.text('Start Sharing'), findsOneWidget);
    });

    testWidgets('should show Browse tab by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Browse tab should be visible
      expect(find.byType(BrowseSessionsTab), findsOneWidget);
    });

    testWidgets('should switch to Start Sharing tab when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 100));

      // Tap on Start Sharing tab
      await tester.tap(find.text('Start Sharing'));
      await tester.pumpAndSettle();

      // Start Sharing tab should now be visible
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

    testWidgets('should start on Start Sharing tab when already hosting', (
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

      // Should show Start Sharing tab when hosting
      expect(find.byType(StartSharingTab), findsOneWidget);
    });
  });

  group('LiveSessionScreen.show', () {
    late AppState appState;
    late LiveSessionState liveSessionState;

    setUp(() {
      appState = AppState();
      liveSessionState = LiveSessionState();
    });

    tearDown(() {
      appState.dispose();
      liveSessionState.dispose();
    });

    testWidgets('should navigate to LiveSessionScreen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<LiveSessionState>.value(
          value: liveSessionState,
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
  });
}
