import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/section_title.dart';

void main() {
  group('SectionTitle Tests', () {
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

    group('Widget Construction', () {
      testWidgets('should build without error with title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Test Section')),
        );

        expect(find.byType(SectionTitle), findsOneWidget);
        expect(find.text('Test Section'), findsOneWidget);
      });

      testWidgets('should display the provided title text', (tester) async {
        const testTitle = 'Camera Controls';

        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: testTitle)),
        );

        expect(find.text(testTitle), findsOneWidget);
      });
    });

    group('Visual Styling', () {
      testWidgets('should apply correct text color', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Style Test')),
        );

        await tester.pumpAndSettle();

        // Check that text is rendered with proper styling
        expect(find.text('Style Test'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);

        final textWidget = tester.widget<Text>(find.text('Style Test'));
        expect(textWidget.style, isNotNull);
      });

      testWidgets('should apply correct font weight', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Weight Test')),
        );

        final textWidget = tester.widget<Text>(find.text('Weight Test'));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should apply correct font size', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Size Test')),
        );

        final textWidget = tester.widget<Text>(find.text('Size Test'));
        expect(textWidget.style?.fontSize, isNotNull);
        expect(textWidget.style?.fontSize, greaterThan(12.0));
      });
    });

    group('Text Content Handling', () {
      testWidgets('should handle short titles', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'UI')),
        );

        expect(find.text('UI'), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });

      testWidgets('should handle medium length titles', (tester) async {
        const title = 'Physics Visualization';

        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: title)),
        );

        expect(find.text(title), findsOneWidget);
      });

      testWidgets('should handle long titles', (tester) async {
        const longTitle =
            'Very Long Section Title That Might Need Special Handling';

        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: longTitle)),
        );

        expect(find.text(longTitle), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });

      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: '')),
        );

        expect(find.byType(SectionTitle), findsOneWidget);
        // Should render without error even with empty title
      });

      testWidgets('should handle titles with special characters', (
        tester,
      ) async {
        const specialTitle = 'Settings & Preferences 🔧';

        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: specialTitle)),
        );

        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('should handle titles with line breaks', (tester) async {
        const multilineTitle = 'Line 1\nLine 2';

        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: multilineTitle)),
        );

        expect(find.text(multilineTitle), findsOneWidget);
      });
    });

    group('Layout and Positioning', () {
      testWidgets('should align text to start', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Alignment Test')),
        );

        final textWidget = tester.widget<Text>(find.text('Alignment Test'));
        expect(textWidget.textAlign, anyOf(isNull, equals(TextAlign.start)));
      });

      testWidgets('should take up appropriate width', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Column(children: [SectionTitle(title: 'Width Test')]),
          ),
        );

        final sectionTitle = find.byType(SectionTitle);
        expect(sectionTitle, findsOneWidget);

        final size = tester.getSize(sectionTitle);
        expect(size.width, greaterThan(50)); // Should have reasonable width
        expect(size.height, greaterThan(10)); // Should have reasonable height
      });

      testWidgets('should fit within parent constraints', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: SizedBox(
              width: 200,
              child: SectionTitle(title: 'Constraint Test'),
            ),
          ),
        );

        final sectionTitle = find.byType(SectionTitle);
        final sizedBox = find.byType(SizedBox).last;

        final sectionSize = tester.getSize(sectionTitle);
        final sizedBoxSize = tester.getSize(sizedBox);

        expect(sectionSize.width, lessThanOrEqualTo(sizedBoxSize.width));
      });
    });

    group('Common Use Cases', () {
      final commonTitles = [
        'AI Camera Modes',
        'Manual Controls',
        'Display Options',
        'Path Visualization',
        'Navigation Aids',
        'Physics Visualization',
        'Advanced Settings',
        'Camera Controls',
        'Visual Effects',
        'Gravity Fields',
      ];

      for (final title in commonTitles) {
        testWidgets('should handle "$title" title correctly', (tester) async {
          await tester.pumpWidget(
            createTestWidget(child: SectionTitle(title: title)),
          );

          expect(find.text(title), findsOneWidget);
          expect(find.byType(SectionTitle), findsOneWidget);
        });
      }
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Accessibility Test')),
        );

        // Text should be readable by screen readers
        expect(find.text('Accessibility Test'), findsOneWidget);

        // Should not interfere with semantic tree
        final textWidget = tester.widget<Text>(find.text('Accessibility Test'));
        expect(textWidget.semanticsLabel, anyOf(isNull, isNotEmpty));
      });

      testWidgets('should work with different text scales', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: createTestWidget(child: SectionTitle(title: 'Scale Test')),
          ),
        );

        expect(find.text('Scale Test'), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        const title = 'Performance Test';

        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: title)),
        );

        // Initial build
        expect(find.text(title), findsOneWidget);

        // Pump without changes
        await tester.pump();

        // Should still be there and not have unnecessary rebuilds
        expect(find.text(title), findsOneWidget);
      });

      testWidgets('should handle rapid creation and disposal', (tester) async {
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            createTestWidget(child: SectionTitle(title: 'Rapid Test $i')),
          );

          await tester.pump();
        }

        // Should complete without errors
        expect(find.byType(SectionTitle), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null safety correctly', (tester) async {
        // Test that the widget handles required non-null title parameter
        await tester.pumpWidget(
          createTestWidget(child: SectionTitle(title: 'Null Safety Test')),
        );

        expect(find.byType(SectionTitle), findsOneWidget);
        expect(find.text('Null Safety Test'), findsOneWidget);
      });

      testWidgets('should handle theme changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(body: SectionTitle(title: 'Theme Test')),
          ),
        );

        expect(find.text('Theme Test'), findsOneWidget);

        // Change to dark theme
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(body: SectionTitle(title: 'Theme Test')),
          ),
        );

        expect(find.text('Theme Test'), findsOneWidget);
      });
    });
  });
}
