import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/enums/custom_message_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/maintenance_dialog.dart';

void main() {
  group('MaintenanceDialog Widget Tests', () {
    // Helper to create test app with localization
    Widget createTestApp({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    group('Maintenance Mode Dialog', () {
      testWidgets('should display maintenance title and message', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.maintenance(
              title: 'Test Maintenance',
              message: 'Test maintenance message',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify title and message
        expect(find.text('Test Maintenance'), findsOneWidget);
        expect(find.text('Test maintenance message'), findsOneWidget);

        // Should have maintenance-related content
        expect(find.byIcon(Icons.build), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('should handle button tap in maintenance mode', (
        tester,
      ) async {
        bool dialogClosed = false;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => MaintenanceDialog.maintenance(
                title: 'Test Maintenance',
                message: 'Test maintenance message',
                onClose: () => dialogClosed = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the close button
        final button = find.byType(TextButton);
        expect(button, findsOneWidget);

        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(dialogClosed, isTrue);
      });

      testWidgets(
        'should show default localized text when no title/message provided',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(child: const MaintenanceDialog.maintenance()),
          );
          await tester.pumpAndSettle();

          // Should use localized strings
          expect(find.textContaining('maintenance'), findsAtLeastNWidgets(1));
          expect(find.byIcon(Icons.build), findsOneWidget);
        },
      );
    });

    group('Notification Mode Dialog', () {
      testWidgets('should display notification title and message', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.notification(
              title: 'Test Notification',
              message: 'Test notification message',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify title and message
        expect(find.text('Test Notification'), findsOneWidget);
        expect(find.text('Test notification message'), findsOneWidget);

        // Should have notification-related content
        expect(find.byIcon(Icons.info), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('should handle button tap in notification mode', (
        tester,
      ) async {
        bool dialogClosed = false;

        await tester.pumpWidget(
          createTestApp(
            child: Builder(
              builder: (context) => MaintenanceDialog.notification(
                title: 'Test Notification',
                message: 'Test notification message',
                onClose: () => dialogClosed = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find and tap the close button
        final button = find.byType(TextButton);
        expect(button, findsOneWidget);

        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(dialogClosed, isTrue);
      });

      testWidgets(
        'should show default localized text when no title/message provided',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(child: const MaintenanceDialog.notification()),
          );
          await tester.pumpAndSettle();

          // Should use localized strings
          expect(find.textContaining('News'), findsAtLeastNWidgets(1));
          expect(find.byIcon(Icons.info), findsOneWidget);
        },
      );
    });

    group('Localization Tests', () {
      testWidgets('should support different locales', (tester) async {
        // Test with Spanish locale
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
            home: const Scaffold(body: MaintenanceDialog.maintenance()),
          ),
        );
        await tester.pumpAndSettle();

        // Should display content in Spanish
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byIcon(Icons.build), findsOneWidget);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets(
        'should have proper widget hierarchy for maintenance dialog',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(
              child: const MaintenanceDialog.maintenance(
                title: 'Test Title',
                message: 'Test Message',
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Check widget hierarchy - be more specific
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.byType(Icon), findsOneWidget);
          expect(
            find.byType(Text),
            findsAtLeastNWidgets(2),
          ); // Title and content
          expect(find.byType(TextButton), findsOneWidget);
        },
      );

      testWidgets(
        'should have proper widget hierarchy for notification dialog',
        (tester) async {
          await tester.pumpWidget(
            createTestApp(
              child: const MaintenanceDialog.notification(
                title: 'Test Title',
                message: 'Test Message',
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Check widget hierarchy - be more specific
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.byType(Icon), findsOneWidget);
          expect(
            find.byType(Text),
            findsAtLeastNWidgets(2),
          ); // Title and content
          expect(find.byType(TextButton), findsOneWidget);
        },
      );
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantics for maintenance dialog', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.maintenance(
              title: 'Maintenance Title',
              message: 'Maintenance Message',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Check for semantic properties
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Maintenance Title'), findsOneWidget);
        expect(find.text('Maintenance Message'), findsOneWidget);
      });

      testWidgets('should have proper semantics for notification dialog', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.notification(
              title: 'Notification Title',
              message: 'Notification Message',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Check for semantic properties
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Notification Title'), findsOneWidget);
        expect(find.text('Notification Message'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null onClose callback', (tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.maintenance(
              title: 'Test Title',
              message: 'Test Message',
              onClose: null,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should still render without errors
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('should handle empty title and message', (tester) async {
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.maintenance(title: '', message: ''),
          ),
        );
        await tester.pumpAndSettle();

        // Should still render dialog structure
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byIcon(Icons.build), findsOneWidget);
      });

      testWidgets('should handle very long text content', (tester) async {
        const longText =
            'This is a very long message that should be handled properly by the dialog widget even when it contains a lot of text content that might cause layout issues in some scenarios.';

        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.notification(
              title: longText,
              message: longText,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should handle long text without overflow
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(
          find.textContaining('This is a very long message'),
          findsAtLeastNWidgets(2),
        );
      });
    });

    group('CustomMessageType Enum Support', () {
      test(
        'should have proper localization keys for all notification types',
        () {
          // Test that each CustomMessageType has proper localization keys
          for (final type in CustomMessageType.values) {
            expect(
              type.localizationKey,
              isNotEmpty,
              reason: 'Missing localization key for $type',
            );
            expect(
              type.configValue,
              isNotEmpty,
              reason: 'Missing config value for $type',
            );
          }
        },
      );

      test('should have consistent localization key patterns', () {
        // Test that localization keys follow expected patterns
        expect(CustomMessageType.info.localizationKey, equals('newsTitle'));
        expect(
          CustomMessageType.warning.localizationKey,
          equals('warningTitle'),
        );
        expect(
          CustomMessageType.success.localizationKey,
          equals('successTitle'),
        );
        expect(
          CustomMessageType.announcement.localizationKey,
          equals('announcementTitle'),
        );
        expect(
          CustomMessageType.promotion.localizationKey,
          equals('promotionTitle'),
        );
        expect(
          CustomMessageType.update.localizationKey,
          equals('updateRequiredTitle'),
        );
      });

      test('should parse notification types correctly from config values', () {
        // Test round-trip conversion from enum to config value and back
        for (final type in CustomMessageType.values) {
          final configValue = type.configValue;
          final parsed = CustomMessageTypeExtension.fromString(configValue);
          expect(
            parsed,
            equals(type),
            reason: 'Round trip failed for $type: $configValue -> $parsed',
          );
        }
      });

      testWidgets('should display notification dialog with proper structure', (
        tester,
      ) async {
        // Test basic notification dialog rendering
        await tester.pumpWidget(
          createTestApp(
            child: const MaintenanceDialog.notification(
              title: 'Test Notification',
              message: 'Test notification message',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the dialog appears with correct content
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Test Notification'), findsOneWidget);
        expect(find.text('Test notification message'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
      });
    });
  });
}
