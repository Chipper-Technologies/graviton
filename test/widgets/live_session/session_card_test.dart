import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/firebase/live_session.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/live_session/session_card.dart';

void main() {
  group('SessionCard', () {
    late LiveSession mockSession;

    setUp(() {
      mockSession = LiveSession(
        id: 'session-123',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Test Scenario',
        isRunning: true,
        timeScale: 1.0,
        viewerCount: 5,
        isPasswordProtected: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    Widget buildTestWidget({
      required LiveSession session,
      VoidCallback? onJoin,
      bool isOwnSession = false,
      bool showPasswordIndicator = true,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SessionCard(
            session: session,
            onJoin: onJoin ?? () {},
            isOwnSession: isOwnSession,
            showPasswordIndicator: showPasswordIndicator,
          ),
        ),
      );
    }

    testWidgets('displays session scenario name', (tester) async {
      await tester.pumpWidget(buildTestWidget(session: mockSession));
      await tester.pumpAndSettle();

      expect(find.text('Test Scenario'), findsOneWidget);
    });

    testWidgets('displays host name', (tester) async {
      await tester.pumpWidget(buildTestWidget(session: mockSession));
      await tester.pumpAndSettle();

      expect(find.textContaining('Test Host'), findsOneWidget);
    });

    testWidgets('displays play icon when session is running', (tester) async {
      await tester.pumpWidget(buildTestWidget(session: mockSession));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('displays pause icon when session is not running', (
      tester,
    ) async {
      final pausedSession = LiveSession(
        id: 'session-123',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Test Scenario',
        isRunning: false,
        timeScale: 1.0,
        viewerCount: 5,
        isPasswordProtected: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(buildTestWidget(session: pausedSession));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('shows join button when not own session', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(session: mockSession, isOwnSession: false),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      // Join button should be present
      expect(
        find.descendant(
          of: find.byType(SessionCard),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color ==
                    AppColors.primaryColor,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows your session label when is own session', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(session: mockSession, isOwnSession: true),
      );
      await tester.pumpAndSettle();

      // Should not have the primary color join button
      expect(
        find.descendant(
          of: find.byType(SessionCard),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color ==
                    AppColors.primaryColor,
          ),
        ),
        findsNothing,
      );
    });

    testWidgets('shows lock icon for password protected sessions', (
      tester,
    ) async {
      final protectedSession = LiveSession(
        id: 'session-123',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Test Scenario',
        isRunning: true,
        timeScale: 1.0,
        viewerCount: 5,
        isPasswordProtected: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(buildTestWidget(session: protectedSession));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('hides lock icon when showPasswordIndicator is false', (
      tester,
    ) async {
      final protectedSession = LiveSession(
        id: 'session-123',
        hostId: 'host-123',
        hostName: 'Test Host',
        scenarioName: 'Test Scenario',
        isRunning: true,
        timeScale: 1.0,
        viewerCount: 5,
        isPasswordProtected: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestWidget(
          session: protectedSession,
          showPasswordIndicator: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock), findsNothing);
    });

    testWidgets('calls onJoin when join button is tapped', (tester) async {
      var joinCalled = false;

      await tester.pumpWidget(
        buildTestWidget(session: mockSession, onJoin: () => joinCalled = true),
      );
      await tester.pumpAndSettle();

      // Find and tap the join button area
      final joinButton = find.descendant(
        of: find.byType(SessionCard),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color ==
                  AppColors.primaryColor,
        ),
      );

      await tester.tap(joinButton);
      await tester.pumpAndSettle();

      expect(joinCalled, isTrue);
    });

    testWidgets('displays visibility icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(session: mockSession));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
