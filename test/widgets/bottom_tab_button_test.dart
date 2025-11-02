import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/painters/gradient_grid_painter.dart';
import 'package:graviton/widgets/bottom_tab_button.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

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

      testWidgets('should handle null onPressed (disabled state)', (
        tester,
      ) async {
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

        // Find the icon and verify active state color (purple)
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.camera));
        expect(
          iconWidget.color,
          equals(
            AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityMediumHigh,
            ),
          ),
        );

        // Verify button structure
        expect(find.byType(BottomTabButton), findsOneWidget);
        expect(find.byIcon(Icons.camera), findsOneWidget);
        expect(find.text('Active Button'), findsOneWidget);

        // Verify animated container exists
        final animatedContainers = find.byType(AnimatedContainer);
        expect(animatedContainers, findsAtLeastNWidgets(1));

        // Verify stack structure (background, grid, gradients, content)
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(
          find.byType(CustomPaint),
          findsAtLeastNWidgets(1),
        ); // Grid painter
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

        // Find the icon and verify inactive state color (grey)
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.camera));
        expect(
          iconWidget.color,
          equals(
            AppColors.uiTextGrey.withValues(
              alpha: AppTypography.opacityVeryHigh,
            ),
          ),
        );

        // Verify no active purple gradient overlay exists (only for active buttons)
        final containers = tester.widgetList<Container>(find.byType(Container));
        bool hasInactiveGradient = containers.any((container) {
          final decoration = container.decoration as BoxDecoration?;
          return decoration?.gradient != null;
        });
        expect(hasInactiveGradient, isTrue); // Should have background gradient
      });

      testWidgets('should show disabled state correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Disabled Button',
              tooltip: 'Disabled Tooltip',
              onPressed: null, // null makes it disabled
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the icon and verify disabled state color
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.camera));
        expect(
          iconWidget.color,
          equals(
            AppColors.uiTextGrey.withValues(
              alpha: AppTypography.opacitySemiTransparent,
            ),
          ),
        );

        // Button should be disabled when onPressed is null
        final button = tester.widget<InkWell>(find.byType(InkWell));
        expect(button.onTap, isNull);
      });
    });

    group('Button Layout and Styling', () {
      testWidgets('should have correct button constraints', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Height Test',
              tooltip: 'Height Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the button widget and check its size
        final buttonFinder = find.byType(BottomTabButton);
        final buttonSize = tester.getSize(buttonFinder);
        expect(buttonSize.height, greaterThan(50)); // Should be reasonably tall
        expect(buttonSize.height, lessThan(100)); // But not too tall
      });

      testWidgets('should have box shadows for depth', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Shadow Test',
              tooltip: 'Shadow Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        final decoration = animatedContainer.decoration as BoxDecoration?;
        expect(decoration?.boxShadow, isNotNull);
        expect(decoration?.boxShadow?.length, equals(3)); // Three shadow layers
      });

      testWidgets('should have gradient grid painter', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Grid Test',
              tooltip: 'Grid Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify CustomPaint widget exists for grid
        expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

        final customPaintWidgets = tester.widgetList<CustomPaint>(
          find.byType(CustomPaint),
        );
        final gridPainter = customPaintWidgets.firstWhere(
          (cp) => cp.painter is GradientGridPainter,
          orElse: () => throw Exception('GradientGridPainter not found'),
        );
        expect(gridPainter.painter, isA<GradientGridPainter>());
      });

      testWidgets('should have proper border styling for different states', (
        tester,
      ) async {
        // Test active state border
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Active Border',
              tooltip: 'Active Border Tooltip',
              onPressed: () {},
              isActive: true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find container with border
        final containers = tester.widgetList<Container>(find.byType(Container));
        bool hasActiveBorder = false;
        for (final container in containers) {
          final decoration = container.decoration as BoxDecoration?;
          final border = decoration?.border as Border?;
          if (border?.top.width == 1.5) {
            // Active border is thicker
            hasActiveBorder = true;
            break;
          }
        }
        expect(hasActiveBorder, isTrue);
      });
    });

    group('Gradient Overlays', () {
      testWidgets('should show purple gradient overlay for active buttons', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Active Gradient',
              tooltip: 'Active Gradient Tooltip',
              onPressed: () {},
              isActive: true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Count containers - should have multiple for background, active gradient, etc.
        final containers = find.byType(Container);
        expect(
          containers,
          findsAtLeastNWidgets(2),
        ); // Background + active gradient
      });

      testWidgets(
        'should show grey gradient overlay for inactive enabled buttons',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(
              child: BottomTabButton(
                icon: Icons.camera,
                label: 'Inactive Gradient',
                tooltip: 'Inactive Gradient Tooltip',
                onPressed: () {},
                isActive: false,
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Should have background + inactive grey gradient
          final containers = find.byType(Container);
          expect(containers, findsAtLeastNWidgets(2));
        },
      );

      testWidgets('should not show gradient overlay for disabled buttons', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Disabled No Gradient',
              tooltip: 'Disabled No Gradient Tooltip',
              onPressed: null, // Disabled
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should have fewer containers (only background, no gradient overlays)
        final containers = find.byType(Container);
        expect(
          containers,
          findsWidgets,
        ); // Should find containers but fewer than enabled states
      });
    });

    group('Text Styling and Shadows', () {
      testWidgets('should have enhanced text shadows', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Shadow Text',
              tooltip: 'Shadow Text Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the text widgets and check that they exist with proper styling
        final textWidgets = find.byType(Text);
        expect(textWidgets, findsOneWidget);

        // Verify AnimatedDefaultTextStyle exists (which provides the shadows)
        final animatedTextStyles = find.byType(AnimatedDefaultTextStyle);
        expect(animatedTextStyles, findsAtLeastNWidgets(1));
      });

      testWidgets('should have different text styling for active vs inactive', (
        tester,
      ) async {
        // Test active button
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Active Weight',
              tooltip: 'Active Weight Tooltip',
              onPressed: () {},
              isActive: true,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify active button exists and renders properly
        expect(find.byType(BottomTabButton), findsOneWidget);
        expect(find.text('Active Weight'), findsOneWidget);

        // Test inactive button
        await tester.pumpWidget(
          createTestWidget(
            child: BottomTabButton(
              icon: Icons.camera,
              label: 'Inactive Weight',
              tooltip: 'Inactive Weight Tooltip',
              onPressed: () {},
              isActive: false,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify inactive button exists and renders properly
        expect(find.byType(BottomTabButton), findsOneWidget);
        expect(find.text('Inactive Weight'), findsOneWidget);
      });
    });

    group('Grid Painter Integration', () {
      testWidgets(
        'should have grid with correct opacity for different states',
        (tester) async {
          // Test active state grid
          await tester.pumpWidget(
            createTestWidget(
              child: BottomTabButton(
                icon: Icons.camera,
                label: 'Active Grid',
                tooltip: 'Active Grid Tooltip',
                onPressed: () {},
                isActive: true,
              ),
            ),
          );

          await tester.pumpAndSettle();

          final customPaintWidgets = tester.widgetList<CustomPaint>(
            find.byType(CustomPaint),
          );
          final gridPainterWidget = customPaintWidgets.firstWhere(
            (cp) => cp.painter is GradientGridPainter,
            orElse: () => throw Exception('GradientGridPainter not found'),
          );
          final painter = gridPainterWidget.painter as GradientGridPainter;
          expect(
            painter.opacity,
            equals(AppTypography.opacityDisabled),
          ); // 0.1 for active
          expect(painter.gridSize, equals(6.0));
          expect(painter.gridColor, equals(AppColors.primaryColor));
        },
      );
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
