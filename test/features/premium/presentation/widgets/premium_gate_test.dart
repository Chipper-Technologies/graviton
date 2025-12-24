import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/premium_gate.dart';
import 'package:graviton/features/premium/presentation/widgets/default_locked_indicator.dart';
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
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('PremiumGate', () {
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

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            child: const Text('Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PremiumGate), findsOneWidget);
    });

    testWidgets('shows locked indicator when feature requires premium', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            child: const Text('Locked Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show the DefaultLockedIndicator instead of child content
      expect(find.text('Locked Content'), findsNothing);
      expect(find.byType(DefaultLockedIndicator), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows custom lockedChild when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            lockedChild: const Text('Custom Locked'),
            child: const Text('Locked Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Locked'), findsOneWidget);
      expect(find.text('Locked Content'), findsNothing);
    });

    testWidgets('hides widget when hideWhenLocked is true', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            hideWhenLocked: true,
            child: const Text('Hidden Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hidden Content'), findsNothing);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('calls onLockedTap when locked indicator is tapped', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            onLockedTap: () => tapped = true,
            child: const Text('Locked Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.lock_outline));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('calls onLockedTap when custom lockedChild is tapped', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          premiumState: premiumState,
          child: PremiumGate(
            feature: PremiumFeature.cameraSync,
            onLockedTap: () => tapped = true,
            lockedChild: const Text('Custom Locked'),
            child: const Text('Locked Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Custom Locked'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('works with all premium features', (tester) async {
      for (final feature in PremiumFeature.values) {
        await tester.pumpWidget(
          createTestableWidget(
            premiumState: premiumState,
            child: PremiumGate(feature: feature, child: const Text('Content')),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PremiumGate), findsOneWidget);
      }
    });
  });
}
