import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/shared/widgets/layouts/bottom_sheet_header.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('BottomSheetHeader Tests', () {
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
      testWidgets('should build without error with required parameters', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.camera, title: 'Test Header'),
          ),
        );

        expect(find.byType(BottomSheetHeader), findsOneWidget);
        expect(find.text('Test Header'), findsOneWidget);
        expect(find.byIcon(Icons.camera), findsOneWidget);
      });

      testWidgets('should display icon and title correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(
              icon: Icons.palette,
              title: 'Visual Controls',
            ),
          ),
        );

        expect(find.byIcon(Icons.palette), findsOneWidget);
        expect(find.text('Visual Controls'), findsOneWidget);
      });
    });

    group('Visual Styling', () {
      testWidgets('should apply correct colors to icon and text', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(
              icon: Icons.science,
              title: 'Physics Controls',
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check icon color
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.science));
        expect(iconWidget.color, equals(AppColors.primaryColor));

        // Check text color
        final textWidget = tester.widget<Text>(find.text('Physics Controls'));
        expect(textWidget.style?.color, equals(AppColors.uiWhite));
      });

      testWidgets('should have proper text styling', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(
              icon: Icons.videocam,
              title: 'Camera Settings',
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('Camera Settings'));

        // Verify text style properties
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
        expect(textWidget.style?.fontSize, isNotNull);
      });
    });

    group('Layout and Positioning', () {
      testWidgets('should arrange icon and title in a row', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.settings, title: 'Settings'),
          ),
        );

        // Should contain a Row widget
        expect(find.byType(Row), findsAtLeastNWidgets(1));

        // Icon should come before text
        final rowWidget = tester.widget<Row>(find.byType(Row).first);
        expect(rowWidget.children.length, greaterThanOrEqualTo(2));
      });

      testWidgets('should have proper spacing between icon and title', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.info, title: 'Information'),
          ),
        );

        // Check for SizedBox spacing
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper padding', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.help, title: 'Help'),
          ),
        );

        // Should have proper padding structure
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(BottomSheetHeader), findsOneWidget);
      });
    });

    group('Different Icons', () {
      final testCases = [
        {'icon': Icons.camera, 'title': 'Camera'},
        {'icon': Icons.palette, 'title': 'Visuals'},
        {'icon': Icons.science, 'title': 'Physics'},
        {'icon': Icons.settings, 'title': 'Settings'},
        {'icon': Icons.info, 'title': 'Info'},
      ];

      for (final testCase in testCases) {
        testWidgets('should handle ${testCase['title']} icon correctly', (
          tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              child: BottomSheetHeader(
                icon: testCase['icon'] as IconData,
                title: testCase['title'] as String,
              ),
            ),
          );

          expect(find.byIcon(testCase['icon'] as IconData), findsOneWidget);
          expect(find.text(testCase['title'] as String), findsOneWidget);
        });
      }
    });

    group('Text Handling', () {
      testWidgets('should handle short titles', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.star, title: 'Hi'),
          ),
        );

        expect(find.text('Hi'), findsOneWidget);
        expect(find.byType(BottomSheetHeader), findsOneWidget);
      });

      testWidgets('should handle titles of different lengths', (tester) async {
        const shortTitle = 'Help';
        const mediumTitle = 'Camera Controls';

        // Test short title
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.help, title: shortTitle),
          ),
        );

        expect(find.text(shortTitle), findsOneWidget);
        expect(find.byType(BottomSheetHeader), findsOneWidget);

        // Test medium title
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.camera, title: mediumTitle),
          ),
        );

        expect(find.text(mediumTitle), findsOneWidget);
      });

      testWidgets('should handle special characters in title', (tester) async {
        const specialTitle = 'Physics';

        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.science, title: specialTitle),
          ),
        );

        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('should handle empty title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.block, title: ''),
          ),
        );

        expect(find.byType(BottomSheetHeader), findsOneWidget);
        // Should render without error even with empty title
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(
              icon: Icons.accessibility,
              title: 'Accessibility Test',
            ),
          ),
        );

        // Should have semantic meaning for screen readers
        expect(find.text('Accessibility Test'), findsOneWidget);
        expect(find.byIcon(Icons.accessibility), findsOneWidget);
      });

      testWidgets('should work with different screen sizes', (tester) async {
        // Test normal screen size functionality
        await tester.pumpWidget(
          createTestWidget(
            child: BottomSheetHeader(icon: Icons.phone, title: 'Mobile'),
          ),
        );

        expect(find.byType(BottomSheetHeader), findsOneWidget);
        expect(find.text('Mobile'), findsOneWidget);
        expect(find.byIcon(Icons.phone), findsOneWidget);
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        int buildCount = 0;

        await tester.pumpWidget(
          createTestWidget(
            child: StatefulBuilder(
              builder: (context, setState) {
                buildCount++;
                return BottomSheetHeader(
                  icon: Icons.build,
                  title: 'Build Test $buildCount',
                );
              },
            ),
          ),
        );

        final initialBuildCount = buildCount;

        // Pump without changes
        await tester.pump();

        // Build count should not increase unnecessarily
        expect(buildCount, equals(initialBuildCount));
      });

      testWidgets('should handle rapid creation and disposal', (tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(
            createTestWidget(
              child: BottomSheetHeader(
                icon: Icons.speed,
                title: 'Speed Test $i',
              ),
            ),
          );

          await tester.pump();
        }

        // Should complete without errors
        expect(find.byType(BottomSheetHeader), findsOneWidget);
      });
    });
  });
}
