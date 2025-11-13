import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_button.dart';

import '../../test_utils.dart';

void main() {
  group('HapticButton', () {
    group('Basic Functionality', () {
      testWidgets('displays text correctly', (WidgetTester tester) async {
        const buttonText = 'Test Button';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: () {}, text: buttonText),
          ),
        );

        expect(find.text(buttonText), findsOneWidget);
      });

      testWidgets('handles onPressed callback', (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () => wasPressed = true,
              text: 'Test Button',
            ),
          ),
        );

        await tester.tap(find.byType(HapticButton));
        expect(wasPressed, isTrue);
      });

      testWidgets('is disabled when onPressed is null', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: null, text: 'Disabled Button'),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);
      });

      testWidgets('displays icon when provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Icon Button',
              icon: Icons.star,
            ),
          ),
        );

        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Icon Button'), findsOneWidget);
      });

      testWidgets('displays tooltip when provided', (
        WidgetTester tester,
      ) async {
        const tooltipText = 'Button tooltip';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Button',
              tooltip: tooltipText,
            ),
          ),
        );

        // Long press to show tooltip
        await tester.longPress(find.byType(HapticButton));
        await tester.pumpAndSettle();

        expect(find.text(tooltipText), findsOneWidget);
      });
    });

    group('Factory Constructors', () {
      testWidgets('primary constructor uses correct colors', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton.primary(
              onPressed: () {},
              text: 'Primary Button',
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(
          button.style?.backgroundColor?.resolve({}),
          AppColors.primaryColor,
        );
      });

      testWidgets('destructive constructor uses correct colors', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton.destructive(
              onPressed: () {},
              text: 'Delete Button',
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(
          button.style?.backgroundColor?.resolve({}),
          AppColors.celestialRed,
        );
      });

      testWidgets('secondary constructor uses correct colors', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton.secondary(
              onPressed: () {},
              text: 'Secondary Button',
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final expectedColor = AppColors.uiWhite.withValues(
          alpha: AppTypography.opacityBarely,
        );
        expect(button.style?.backgroundColor?.resolve({}), expectedColor);
      });

      testWidgets('primary constructor with icon displays correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton.primary(
              onPressed: () {},
              text: 'Primary Icon',
              icon: Icons.add,
            ),
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Primary Icon'), findsOneWidget);
      });

      testWidgets('destructive constructor with icon displays correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton.destructive(
              onPressed: () {},
              text: 'Delete Item',
              icon: Icons.delete,
            ),
          ),
        );

        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.text('Delete Item'), findsOneWidget);
      });
    });

    group('Styling and Layout', () {
      testWidgets('uses full width when specified', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SizedBox(
              width: 300,
              child: HapticButton(
                onPressed: () {},
                text: 'Full Width Button',
                isFullWidth: true,
              ),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(ElevatedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, double.infinity);
      });

      testWidgets('uses custom padding when provided', (
        WidgetTester tester,
      ) async {
        const customPadding = EdgeInsets.all(32.0);

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Custom Padding',
              padding: customPadding,
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.style?.padding?.resolve({}), customPadding);
      });

      testWidgets('uses custom colors when provided', (
        WidgetTester tester,
      ) async {
        const customBg = Colors.purple;
        const customFg = Colors.yellow;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Custom Colors',
              backgroundColor: customBg,
              foregroundColor: customFg,
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.style?.backgroundColor?.resolve({}), customBg);
        expect(button.style?.foregroundColor?.resolve({}), customFg);
      });

      testWidgets('applies proper border radius', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: () {}, text: 'Rounded Button'),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final shape = button.style?.shape?.resolve({});
        // HapticButton uses default ElevatedButton shape (no custom border radius)
        expect(shape, isNull);
      });

      testWidgets('applies proper elevation and shadow', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: () {}, text: 'Elevated Button'),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(
          button.style?.elevation?.resolve({}),
          AppTypography.spacingXSmall,
        );
      });
    });

    group('Text Styling', () {
      testWidgets('applies correct text style for text-only button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: () {}, text: 'Text Button'),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('Text Button'));
        expect(textWidget.style?.fontSize, AppTypography.fontSizeMedium);
        expect(textWidget.style?.fontWeight, FontWeight.w600);
        expect(textWidget.textAlign, TextAlign.center);
      });

      testWidgets('applies correct text style for icon button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Icon Text',
              icon: Icons.star,
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('Icon Text'));
        expect(textWidget.style?.fontSize, AppTypography.fontSizeMedium);
        expect(textWidget.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('icon has correct size', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Icon Button',
              icon: Icons.star,
            ),
          ),
        );

        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.star));
        expect(iconWidget.size, AppTypography.iconSizeMedium);
      });
    });

    group('Accessibility', () {
      testWidgets('is accessible by default', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: () {}, text: 'Accessible Button'),
          ),
        );

        // Button should be found by semantics
        expect(find.bySemanticsLabel('Accessible Button'), findsOneWidget);
      });

      testWidgets('supports tooltip accessibility', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(
              onPressed: () {},
              text: 'Button',
              tooltip: 'This is a helpful tooltip',
            ),
          ),
        );

        // Should have tooltip widget
        expect(find.byType(Tooltip), findsOneWidget);
      });
    });

    group('Integration', () {
      testWidgets('works in a full width layout', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Column(
              children: [
                HapticButton.primary(
                  onPressed: () {},
                  text: 'First Button',
                  isFullWidth: true,
                ),
                SizedBox(height: AppTypography.spacingMedium),
                HapticButton.destructive(
                  onPressed: () {},
                  text: 'Second Button',
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        );

        expect(find.text('First Button'), findsOneWidget);
        expect(find.text('Second Button'), findsOneWidget);

        // Both buttons should be rendered
        expect(find.byType(HapticButton), findsNWidgets(2));
      });

      testWidgets('works with complex layouts', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppTypography.spacingLarge),
                child: Column(
                  children: [
                    Text('Choose an action:'),
                    SizedBox(height: AppTypography.spacingMedium),
                    Row(
                      children: [
                        Expanded(
                          child: HapticButton.primary(
                            onPressed: () {},
                            text: 'Confirm',
                            icon: Icons.check,
                          ),
                        ),
                        SizedBox(width: AppTypography.spacingMedium),
                        Expanded(
                          child: HapticButton.secondary(
                            onPressed: () {},
                            text: 'Cancel',
                            icon: Icons.close,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Choose an action:'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty text', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: HapticButton(onPressed: () {}, text: ''),
          ),
        );

        expect(find.byType(HapticButton), findsOneWidget);
      });

      testWidgets('handles very long text', (WidgetTester tester) async {
        const longText =
            'This is a very long button text that might cause layout issues';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SizedBox(
              width: 200,
              child: HapticButton(onPressed: () {}, text: longText),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);
        // Should not overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles multiple button instances', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Column(
              children: List.generate(
                5,
                (index) =>
                    HapticButton(onPressed: () {}, text: 'Button $index'),
              ),
            ),
          ),
        );

        expect(find.byType(HapticButton), findsNWidgets(5));
        for (int i = 0; i < 5; i++) {
          expect(find.text('Button $i'), findsOneWidget);
        }
      });
    });
  });
}
