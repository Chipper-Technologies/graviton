import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/premium/presentation/widgets/session_expired_dialog.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/l10n/app_localizations_en.dart';

import 'package:graviton/theme/app_typography.dart';

void main() {
  final l10n = AppLocalizationsEn();

  Widget createTestWidget({VoidCallback? onUpgrade, VoidCallback? onDismiss}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: SessionExpiredDialog(onUpgrade: onUpgrade, onDismiss: onDismiss),
      ),
    );
  }

  group('SessionExpiredDialog Widget', () {
    testWidgets('should render with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(l10n.premiumSessionExpired), findsOneWidget);
    });

    testWidgets('should display session expired message', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(l10n.premiumSessionExpiredMessage), findsOneWidget);
    });

    testWidgets('should display premium upgrade hint', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(l10n.premiumUnlimitedSessionsHint), findsOneWidget);
    });

    testWidgets('should show timer_off icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.timer_off), findsOneWidget);
    });

    testWidgets('should show star icon in benefits section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should have upgrade button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(l10n.premiumUpgrade), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should have dismiss button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text(l10n.closeButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should call onUpgrade when upgrade button tapped', (
      tester,
    ) async {
      var upgradeCalled = false;
      await tester.pumpWidget(
        createTestWidget(onUpgrade: () => upgradeCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.premiumUpgrade));
      await tester.pumpAndSettle();

      expect(upgradeCalled, isTrue);
    });

    testWidgets('should call onDismiss when close button tapped', (
      tester,
    ) async {
      var dismissCalled = false;
      await tester.pumpWidget(
        createTestWidget(onDismiss: () => dismissCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.closeButton));
      await tester.pumpAndSettle();

      expect(dismissCalled, isTrue);
    });

    testWidgets('should have AlertDialog as root widget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('should use correct theme colors', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the dialog
      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.backgroundColor, equals(const Color(0xFF1A1A2E)));
    });

    testWidgets('should have rounded corners', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(dialog.shape, isA<RoundedRectangleBorder>());
      final shape = dialog.shape as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        equals(BorderRadius.circular(AppTypography.radiusLarge)),
      );
    });
  });

  group('SessionExpiredDialog.show()', () {
    testWidgets('should show dialog and return true when upgrade tapped', (
      tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await SessionExpiredDialog.show(context);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(SessionExpiredDialog), findsOneWidget);

      // Tap upgrade
      await tester.tap(find.text(l10n.premiumUpgrade));
      await tester.pumpAndSettle();

      // Verify result
      expect(result, isTrue);
    });

    testWidgets('should show dialog and return false when dismissed', (
      tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await SessionExpiredDialog.show(context);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(SessionExpiredDialog), findsOneWidget);

      // Tap close
      await tester.tap(find.text(l10n.closeButton));
      await tester.pumpAndSettle();

      // Verify result
      expect(result, isFalse);
    });

    testWidgets('should not dismiss when tapping outside', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => SessionExpiredDialog.show(context),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Try to tap outside (barrier is not dismissible)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.byType(SessionExpiredDialog), findsOneWidget);
    });
  });

  group('SessionExpiredDialog Accessibility', () {
    testWidgets('should have semantic labels for buttons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Buttons should be findable by text for accessibility
      expect(find.text(l10n.premiumUpgrade), findsOneWidget);
      expect(find.text(l10n.closeButton), findsOneWidget);
    });
  });
}
