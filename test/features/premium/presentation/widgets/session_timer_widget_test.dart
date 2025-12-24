import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/session_timer_widget.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Creates a test wrapper widget with localization and provider support
Widget createTestableWidget({
  required Widget child,
  required PremiumState premiumState,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: ChangeNotifierProvider<PremiumState>.value(
      value: premiumState,
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  group('SessionTimerWidget', () {
    late PremiumState premiumState;

    setUp(() {
      premiumState = PremiumState();
    });

    tearDown(() {
      try {
        premiumState.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: const SessionTimerWidget(),
        ),
      );
      await tester.pumpAndSettle();

      // Widget should render without errors
      // Timer visibility depends on premium status and session state
      expect(find.byType(SessionTimerWidget), findsOneWidget);
    });

    testWidgets('shows formatted time display', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: const SessionTimerWidget(),
        ),
      );
      await tester.pumpAndSettle();

      // Should display time in MM:SS format
      expect(find.textContaining(RegExp(r'\d{2}:\d{2}')), findsOneWidget);
    });

    testWidgets('compact mode renders without errors', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: const SessionTimerWidget(compact: true),
        ),
      );
      await tester.pumpAndSettle();

      // Compact mode should render without errors
      expect(find.byType(SessionTimerWidget), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: SessionTimerWidget(onTap: () => tapped = true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SessionTimerWidget));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('compact mode calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: SessionTimerWidget(compact: true, onTap: () => tapped = true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SessionTimerWidget));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('has proper accessibility semantics', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: const SessionTimerWidget(),
        ),
      );
      await tester.pumpAndSettle();

      // Find Semantics widget
      final semantics = tester.getSemantics(find.byType(SessionTimerWidget));
      expect(semantics.label, isNotEmpty);
    });

    testWidgets('compact mode has proper accessibility semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: const SessionTimerWidget(compact: true),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(find.byType(SessionTimerWidget));
      expect(semantics.label, isNotEmpty);
    });
  });
}
