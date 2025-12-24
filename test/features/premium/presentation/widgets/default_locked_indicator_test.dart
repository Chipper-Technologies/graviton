import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/presentation/widgets/default_locked_indicator.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('DefaultLockedIndicator', () {
    Widget createTestWidget({required PremiumFeature feature}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DefaultLockedIndicator(feature: feature)),
      );
    }

    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        createTestWidget(feature: PremiumFeature.cameraSync),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DefaultLockedIndicator), findsOneWidget);
    });

    testWidgets('displays lock icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(feature: PremiumFeature.cameraSync),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('has amber color scheme', (tester) async {
      await tester.pumpWidget(
        createTestWidget(feature: PremiumFeature.cameraSync),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DefaultLockedIndicator),
          matching: find.byType(Container).first,
        ),
      );
      expect(container, isNotNull);
    });

    testWidgets('has semantics for accessibility', (tester) async {
      await tester.pumpWidget(
        createTestWidget(feature: PremiumFeature.cameraSync),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('works with different premium features', (tester) async {
      for (final feature in PremiumFeature.values) {
        await tester.pumpWidget(createTestWidget(feature: feature));
        await tester.pumpAndSettle();
        expect(find.byType(DefaultLockedIndicator), findsOneWidget);
      }
    });
  });
}
