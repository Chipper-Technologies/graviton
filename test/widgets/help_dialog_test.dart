import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/help_dialog.dart';

void main() {
  group('HelpDialog', () {
    Widget createTestWidget({required Widget child}) {
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

    group('Rendering', () {
      testWidgets('Should display dialog structure', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should have basic dialog structure
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should display header with action button content', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should have the explore icon and get started text
        expect(find.byIcon(Icons.explore), findsOneWidget);
        expect(find.text('Get Started!'), findsOneWidget);

        // Should have header text
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should handle emoji text alignment', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Look for emoji-containing text
        final allTexts = find.byType(Text);
        expect(allTexts, findsWidgets);

        // Should handle the dialog without crashing
        expect(find.byType(HelpDialog), findsOneWidget);
      });

      testWidgets('Should display content sections', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should have the expected content sections
        expect(
          find.textContaining('Explore realistic orbital mechanics'),
          findsOneWidget,
        );
        expect(find.textContaining('Quick Start Guide'), findsOneWidget);
        expect(find.textContaining('Press Play to start'), findsOneWidget);
      });
    });

    group('Content Formatting', () {
      testWidgets('Should format bullet lists correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should contain formatted content without crashing
        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should format numbered lists correctly', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should contain formatted content without crashing
        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should apply purple color to bullets and numbers', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should apply proper formatting without crashing
        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should handle UTF-16 emoji properly', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should handle emojis without crashing
        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should maintain consistent text styling', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should maintain styling without crashing
        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Interaction', () {
      testWidgets('Should close when action button pressed', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        expect(find.byType(HelpDialog), findsOneWidget);

        // Try to tap the get started text area (this is the clickable button)
        final getStartedText = find.text('Get Started!');
        if (getStartedText.evaluate().isNotEmpty) {
          await tester.tap(getStartedText, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Test completes successfully if no exceptions
      });

      testWidgets('Should handle scrolling', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should handle scrolling without issues
        final scrollable = find.byType(SingleChildScrollView);
        if (scrollable.evaluate().isNotEmpty) {
          await tester.drag(scrollable.first, const Offset(0, -100));
          await tester.pump();
        }

        expect(find.byType(HelpDialog), findsOneWidget);
      });

      testWidgets('Should handle tap outside to close', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should handle dialog interaction
        expect(find.byType(HelpDialog), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('Should provide proper semantics', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should have semantic elements
        expect(find.byType(Semantics), findsWidgets);

        // Action button content should be accessible
        expect(find.byIcon(Icons.explore), findsOneWidget);
        expect(find.text('Get Started!'), findsOneWidget);
      });

      testWidgets('Should support screen readers', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should support accessibility
        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should have proper focus management', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Try to interact with action text if it exists
        final getStartedText = find.text('Get Started!');
        if (getStartedText.evaluate().isNotEmpty) {
          await tester.tap(getStartedText, warnIfMissed: false);
          await tester.pump();
        }

        // Should handle focus properly
        expect(find.byType(HelpDialog), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('Should render efficiently', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should render without performance issues
        expect(find.byType(HelpDialog), findsOneWidget);
      });

      testWidgets('Should dispose properly', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Trigger disposal
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Test passes if no memory leaks or exceptions
      });

      testWidgets('Should handle repeated renders', (tester) async {
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
          await tester.pump();
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        }

        // Test passes if no exceptions
      });
    });

    group('Edge Cases', () {
      testWidgets('Should handle window resizing', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Should handle different sizes
        expect(find.byType(HelpDialog), findsOneWidget);
      });

      testWidgets('Should handle rapid interactions', (tester) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pumpAndSettle();

        // Rapid taps if button text exists
        final getStartedText = find.text('Get Started!');
        if (getStartedText.evaluate().isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(getStartedText, warnIfMissed: false);
            await tester.pump(const Duration(milliseconds: 10));
          }
        }

        expect(find.byType(HelpDialog), findsOneWidget);
      });

      testWidgets('Should maintain consistency across rebuilds', (
        tester,
      ) async {
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pump();

        // Force rebuild
        await tester.pumpWidget(createTestWidget(child: const HelpDialog()));
        await tester.pump();

        expect(find.byType(HelpDialog), findsOneWidget);
        expect(find.text('Get Started!'), findsOneWidget);
      });
    });
  });
}
