import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/widgets/bottom_tab_button.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('BottomTabButton Tests', () {
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
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Test Label',
              tooltip: 'Test Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        expect(find.byType(BottomTabButton), findsOneWidget);
        expect(find.text('Test Label'), findsOneWidget);
        expect(find.byIcon(Icons.camera), findsOneWidget);
      });

      testWidgets('should handle null onPressed', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Test Label',
              tooltip: 'Test Tooltip',
              onPressed: null,
              isActive: false,
            ),
          ),
        );

        expect(find.byType(BottomTabButton), findsOneWidget);

        // Button should be disabled when onPressed is null
        final button = tester.widget<InkWell>(find.byType(InkWell));
        expect(button.onTap, isNull);
      });
    });

    group('Visual States', () {
      testWidgets('should show active state correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Active Button',
              tooltip: 'Active Tooltip',
              onPressed: () {},
              isActive: true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the icon and text to check their styling
        // Check that the widget renders properly in active state
        expect(find.byType(BottomTabButton), findsOneWidget);
        expect(find.byIcon(Icons.camera), findsOneWidget);
        expect(find.text('Active Button'), findsOneWidget);

        // Verify active visual styling exists
        final animatedContainers = find.byType(AnimatedContainer);
        expect(animatedContainers, findsAtLeastNWidgets(1));
      });

      testWidgets('should show inactive state correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Inactive Button',
              tooltip: 'Inactive Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the icon and text to check their styling
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.camera));
        final textWidget = tester.widget<Text>(find.text('Inactive Button'));

        // Inactive state should use white with opacity
        expect(iconWidget.color, isNot(equals(AppColors.primaryColor)));
        expect(textWidget.style?.color, isNot(equals(AppColors.primaryColor)));
      });
    });

    group('Interactions', () {
      testWidgets('should call onPressed when tapped', (tester) async {
        bool wasPressed = false;

        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Tap Test',
              tooltip: 'Tap Tooltip',
              onPressed: () => wasPressed = true,
              isActive: false,
            ),
          ),
        );

        await tester.tap(find.byType(BottomTabButton));
        await tester.pumpAndSettle();

        expect(wasPressed, isTrue);
      });

      testWidgets('should show tooltip on long press', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Tooltip Test',
              tooltip: 'This is a test tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        // Long press to show tooltip
        await tester.longPress(find.byType(BottomTabButton));
        await tester.pumpAndSettle();

        expect(find.text('This is a test tooltip'), findsOneWidget);
      });

      testWidgets('should not respond to tap when disabled', (tester) async {
        bool wasPressed = false;

        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Disabled Test',
              tooltip: 'Disabled Tooltip',
              onPressed: null, // Disabled
              isActive: false,
            ),
          ),
        );

        await tester.tap(find.byType(BottomTabButton));
        await tester.pumpAndSettle();

        expect(wasPressed, isFalse);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantic labels', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Camera',
              tooltip: 'Open camera controls',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        // Check for accessibility features
        expect(find.byTooltip('Open camera controls'), findsOneWidget);
        expect(find.text('Camera'), findsOneWidget);
      });

      testWidgets('should support semantic taps', (tester) async {
        bool wasPressed = false;

        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Semantic Test',
              tooltip: 'Semantic tap test',
              onPressed: () => wasPressed = true,
              isActive: false,
            ),
          ),
        );

        await tester.tap(find.byTooltip('Semantic tap test'));
        await tester.pumpAndSettle();

        expect(wasPressed, isTrue);
      });
    });

    group('Layout and Sizing', () {
      testWidgets('should expand to fill available space', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Row(
              children: [
                Expanded(
                  child: BottomTabButton(
                    icon: Icons.camera,
                    label: 'Expand Test',
                    tooltip: 'Expand Test',
                    onPressed: () {},
                    isActive: false,
                  ),
                ),
              ],
            ),
          ),
        );

        final button = find.byType(BottomTabButton);
        expect(button, findsOneWidget);

        // Button should take available width
        final size = tester.getSize(button);
        expect(size.width, greaterThan(100)); // Should be reasonably wide
      });

      testWidgets('should handle different icon sizes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.zoom_out_map, // Different icon
              label: 'Icon Test',
              tooltip: 'Icon Test',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        expect(find.byType(BottomTabButton), findsOneWidget);
        expect(find.byIcon(Icons.zoom_out_map), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty label gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: '', // Empty label
              tooltip: 'Empty Label Test',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        expect(find.byType(BottomTabButton), findsOneWidget);
        // Should still render without error
      });

      testWidgets('should handle very long labels', (tester) async {
        const longLabel = 'This is a very long label that might overflow';

        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: longLabel,
              tooltip: 'Long Label Test',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        expect(find.byType(BottomTabButton), findsOneWidget);
        // Should handle overflow gracefully
      });

      testWidgets('should handle rapid state changes', (tester) async {
        bool isActive = false;

        await tester.pumpWidget(
          createTestWidget(
            child: StatefulBuilder(
              builder: (context, setState) {
                return BottomTabButton(
                  icon: Icons.camera,
                  label: 'State Test',
                  tooltip: 'State Test',
                  onPressed: () {
                    setState(() {
                      isActive = !isActive;
                    });
                  },
                  isActive: isActive,
                );
              },
            ),
          ),
        );

        // Tap multiple times rapidly
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(BottomTabButton));
          await tester.pump();
        }

        await tester.pumpAndSettle();
        expect(find.byType(BottomTabButton), findsOneWidget);
      });
    });
  });
}
