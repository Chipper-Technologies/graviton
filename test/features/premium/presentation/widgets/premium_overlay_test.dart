import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/premium_overlay.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  group('PremiumOverlay', () {
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

    Widget createTestWidget({
      required Widget child,
      PremiumFeature feature = PremiumFeature.cameraSync,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider.value(
          value: premiumState,
          child: Scaffold(
            body: PremiumOverlay(feature: feature, onTap: onTap, child: child),
          ),
        ),
      );
    }

    testWidgets('renders widget', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const Text('Content')));
      await tester.pumpAndSettle();

      expect(find.byType(PremiumOverlay), findsOneWidget);
    });

    testWidgets('shows overlay structure when locked', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const Text('Locked Content')),
      );
      await tester.pumpAndSettle();

      // Free tier users should see the overlay
      // The widget uses a Stack when locked
      expect(find.byType(Stack), findsWidgets);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('child has reduced opacity when locked', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const Text('Locked Content')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Opacity), findsWidgets);
    });

    testWidgets('child is not interactive when locked', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const Text('Locked Content')),
      );
      await tester.pumpAndSettle();

      // Find the IgnorePointer with ignoring=true
      final ignorePointers = tester
          .widgetList<IgnorePointer>(find.byType(IgnorePointer))
          .where((w) => w.ignoring);
      expect(ignorePointers.isNotEmpty, isTrue);
    });

    testWidgets('calls onTap when overlay is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestWidget(
          child: Container(width: 100, height: 100, color: Colors.blue),
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      // Find the star icon (part of the overlay) and tap near it
      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('has accessibility semantics', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const Text('Locked Content')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('works with different premium features', (tester) async {
      for (final feature in PremiumFeature.values) {
        await tester.pumpWidget(
          createTestWidget(child: const Text('Content'), feature: feature),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PremiumOverlay), findsOneWidget);
      }
    });
  });
}
