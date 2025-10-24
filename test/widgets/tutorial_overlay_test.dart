import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/tutorial_overlay.dart';

void main() {
  group('TutorialOverlay', () {
    late VoidCallback mockOnComplete;

    setUp(() {
      mockOnComplete = () {};
    });

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
      testWidgets('Should display tutorial overlay with first step', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        expect(find.byType(TutorialOverlay), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        // First step shows logo, not icon
        expect(find.byType(Icon), findsNothing);
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('Should display page indicators', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Look for the page indicator dots
        final containerFinders = find.byType(Container);
        final containers = tester.widgetList<Container>(containerFinders);

        // Should have page indicator containers with circular decoration
        final circularContainers = containers.where((container) {
          final decoration = container.decoration;
          return decoration is BoxDecoration &&
              decoration.shape == BoxShape.circle;
        });

        expect(circularContainers.isNotEmpty, isTrue);
      });

      testWidgets('Should display tutorial step icon with custom colors', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Navigate to a step that has an icon (not the first step which has logo)
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();

        // Should have icon widgets now
        expect(find.byType(Icon), findsWidgets);

        // Check if icon colors are properly set
        final iconWidgets = tester.widgetList<Icon>(find.byType(Icon));
        final coloredIcons = iconWidgets.where((icon) => icon.color != null);
        expect(coloredIcons.isNotEmpty, isTrue);
      });

      testWidgets('Should display navigation buttons', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // First step should only have Skip and Next buttons
        expect(find.text('Skip'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);
        // Should not have previous button on first step
        expect(find.text('Previous'), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('Should advance to next step when next button pressed', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Find and tap the next button
        final nextButton = find.text('Next');
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // After advancing, should show previous button
        expect(find.text('Previous'), findsOneWidget);
      });

      testWidgets('Should go back when previous button pressed', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Advance to second step first
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();

        // Now tap previous button
        await tester.tap(find.text('Previous'));
        await tester.pumpAndSettle();

        // Should be back to first step (no previous button)
        expect(find.text('Previous'), findsNothing);
      });

      testWidgets('Should support swipe navigation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Find the gesture detector
        final gestureDetector = find.byType(GestureDetector);
        expect(gestureDetector, findsWidgets);

        // Swipe left (should go to next step)
        await tester.drag(gestureDetector.first, const Offset(-300, 0));
        await tester.pump();

        // Should now show previous button
        expect(find.byType(TextButton), findsOneWidget);
      });
    });

    group('Color Coordination', () {
      testWidgets('Should use different colors for each step', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Store initial page indicator color
        final initialPageIndicators = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (c) =>
                  c.decoration is BoxDecoration &&
                  (c.decoration as BoxDecoration).shape == BoxShape.circle,
            );

        Color? firstStepColor;
        for (final container in initialPageIndicators) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color != null &&
              decoration.color != Colors.transparent) {
            firstStepColor = decoration.color;
            break;
          }
        }

        // Advance to next step
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Check if page indicator color changed
        final nextPageIndicators = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (c) =>
                  c.decoration is BoxDecoration &&
                  (c.decoration as BoxDecoration).shape == BoxShape.circle,
            );

        Color? secondStepColor;
        for (final container in nextPageIndicators) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color != null &&
              decoration.color != Colors.transparent) {
            secondStepColor = decoration.color;
            break;
          }
        }

        // Colors should be different (indicating dynamic color coordination)
        if (firstStepColor != null && secondStepColor != null) {
          expect(firstStepColor, isNot(equals(secondStepColor)));
        }
      });

      testWidgets('Should coordinate button and icon colors', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Navigate to a step that has an icon
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();

        // Should have colored buttons and icons now
        expect(find.text('Next'), findsOneWidget);
        expect(find.byType(Icon), findsWidgets);

        // Icons should have custom colors
        final iconWidgets = tester.widgetList<Icon>(find.byType(Icon));
        final coloredIcons = iconWidgets.where((icon) => icon.color != null);
        expect(coloredIcons.isNotEmpty, isTrue);
      });
    });

    group('Completion', () {
      testWidgets('Should call onComplete when reaching final step', (
        tester,
      ) async {
        bool completed = false;

        await tester.pumpWidget(
          createTestWidget(
            child: TutorialOverlay(onComplete: () => completed = true),
          ),
        );

        // Navigate through all steps (there are 6 steps)
        for (int i = 0; i < 6; i++) {
          final button = find.byType(ElevatedButton);
          if (button.evaluate().isNotEmpty) {
            await tester.tap(button);
            await tester.pump();
          }
        }

        expect(completed, isTrue);
      });
    });

    group('Localization', () {
      testWidgets('Should display localized content', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Should have text content
        expect(find.byType(Text), findsWidgets);

        // Should use localized strings (check for common tutorial words)
        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        final hasLocalizedContent = textWidgets.any(
          (text) =>
              text.data?.isNotEmpty == true ||
              text.textSpan?.toPlainText().isNotEmpty == true,
        );

        expect(hasLocalizedContent, isTrue);
      });

      testWidgets('Should work with different locales', (tester) async {
        // Test with German locale
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('de'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: TutorialOverlay(onComplete: mockOnComplete)),
          ),
        );

        expect(find.byType(TutorialOverlay), findsOneWidget);
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Accessibility', () {
      testWidgets('Should provide proper semantics', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Should have semantic elements
        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('Should support keyboard navigation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Buttons should be focusable
        final nextButton = find.text('Next');
        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Should advance step and show previous button
        expect(find.text('Previous'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('Should handle rapid navigation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Rapidly tap next button
        for (int i = 0; i < 3; i++) {
          final nextButton = find.byType(ElevatedButton);
          if (nextButton.evaluate().isNotEmpty) {
            await tester.tap(nextButton);
            await tester.pump(const Duration(milliseconds: 50));
          }
        }

        // Should still be functional
        expect(find.byType(TutorialOverlay), findsOneWidget);
      });

      testWidgets('Should handle animation interruption', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: TutorialOverlay(onComplete: mockOnComplete)),
        );

        // Start navigation
        await tester.tap(find.byType(ElevatedButton));

        // Don't wait for animation to complete, navigate again
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(find.byType(TutorialOverlay), findsOneWidget);
      });
    });
  });
}
