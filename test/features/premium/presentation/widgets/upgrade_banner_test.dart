import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/upgrade_banner.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  group('UpgradeBanner', () {
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
      String title = 'Upgrade to Premium',
      String description = 'Get all features',
      VoidCallback? onUpgrade,
      VoidCallback? onDismiss,
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
            body: UpgradeBanner(
              title: title,
              description: description,
              onUpgrade: onUpgrade,
              onDismiss: onDismiss,
            ),
          ),
        ),
      );
    }

    testWidgets('renders widget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(UpgradeBanner), findsOneWidget);
    });

    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(createTestWidget(title: 'Custom Title'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Title'), findsOneWidget);
    });

    testWidgets('displays description', (tester) async {
      await tester.pumpWidget(
        createTestWidget(description: 'Custom Description'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom Description'), findsOneWidget);
    });

    testWidgets('shows dismiss button when onDismiss is provided', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(onDismiss: () {}));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('does not show dismiss button when onDismiss is null', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onDismiss when dismiss button is tapped', (
      tester,
    ) async {
      var dismissCalled = false;
      await tester.pumpWidget(
        createTestWidget(onDismiss: () => dismissCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(dismissCalled, isTrue);
    });

    testWidgets('has gradient background', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The Container with gradient is inside the UpgradeBanner
      final containers = tester.widgetList<Container>(find.byType(Container));
      final containerWithGradient = containers.where((c) {
        final decoration = c.decoration;
        return decoration is BoxDecoration && decoration.gradient != null;
      });
      expect(containerWithGradient.isNotEmpty, isTrue);
    });

    testWidgets('has star icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
