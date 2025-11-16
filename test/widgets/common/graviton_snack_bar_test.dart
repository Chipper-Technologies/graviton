import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';

import '../../test_utils.dart';

void main() {
  group('GravitonSnackBar', () {
    group('Severity Theming', () {
      testWidgets('displays info SnackBar with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.info(
                    context: context,
                    message: 'Information message',
                  );
                },
                child: const Text('Show Info'),
              ),
            ),
          ),
        );

        // Tap button to show SnackBar
        await tester.tap(find.text('Show Info'));
        await tester.pumpAndSettle();

        // Verify SnackBar appears
        expect(find.text('Information message'), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);

        // Verify info icon color (blue)
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.info_outline));
        expect(iconWidget.color, AppColors.uiBlue);
      });

      testWidgets('displays success SnackBar with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.success(
                    context: context,
                    message: 'Success message',
                  );
                },
                child: const Text('Show Success'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Success'));
        await tester.pumpAndSettle();

        expect(find.text('Success message'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

        // Verify success icon color (green)
        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.check_circle_outline),
        );
        expect(iconWidget.color, AppColors.uiStatusGreen);
      });

      testWidgets('displays warning SnackBar with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.warning(
                    context: context,
                    message: 'Warning message',
                  );
                },
                child: const Text('Show Warning'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Warning'));
        await tester.pumpAndSettle();

        expect(find.text('Warning message'), findsOneWidget);
        expect(find.byIcon(Icons.warning_outlined), findsOneWidget);

        // Verify warning icon color (orange)
        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.warning_outlined),
        );
        expect(iconWidget.color, AppColors.uiStatusOrange);
      });

      testWidgets('displays error SnackBar with correct styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.error(
                    context: context,
                    message: 'Error message',
                  );
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pumpAndSettle();

        expect(find.text('Error message'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Verify error icon color (red)
        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.error_outline),
        );
        expect(iconWidget.color, AppColors.uiRed);
      });
    });

    group('Action Buttons', () {
      testWidgets('displays action button when provided', (
        WidgetTester tester,
      ) async {
        bool actionPressed = false;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Message with action',
                    actionLabel: 'Retry',
                    onActionPressed: () {
                      actionPressed = true;
                    },
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // Verify action button appears
        expect(find.text('Retry'), findsOneWidget);

        // Tap action button
        await tester.tap(find.text('Retry'));
        await tester.pump();

        // Verify action was called
        expect(actionPressed, true);
      });

      testWidgets('hides action button when not provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Message without action',
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // Verify message appears but no action button
        expect(find.text('Message without action'), findsOneWidget);
        expect(find.byType(SnackBarAction), findsNothing);
      });
    });

    group('Duration and Dismissal', () {
      testWidgets('uses custom duration when provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Custom duration message',
                    duration: const Duration(
                      seconds: 10,
                    ), // Long duration for testing
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pump(); // Initial pump to start animation
        await tester.pump(
          const Duration(milliseconds: 100),
        ); // Let animation start

        // SnackBar should be visible
        expect(find.text('Custom duration message'), findsOneWidget);

        // Verify the SnackBar has the custom duration by checking it's still there after default duration
        await tester.pump(
          const Duration(seconds: 4),
        ); // More than default 3 seconds
        expect(find.text('Custom duration message'), findsOneWidget);
      });

      testWidgets('can be dismissed by swipe', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Dismissible message',
                    duration: const Duration(seconds: 30), // Long duration
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // SnackBar should be visible
        expect(find.text('Dismissible message'), findsOneWidget);

        // Swipe down to dismiss
        await tester.drag(
          find.text('Dismissible message'),
          const Offset(0, 100),
        );
        await tester.pumpAndSettle();

        // SnackBar should be dismissed
        expect(find.text('Dismissible message'), findsNothing);
      });
    });

    group('Convenience Methods', () {
      testWidgets('info convenience method works correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.info(
                    context: context,
                    message: 'Info convenience',
                  );
                },
                child: const Text('Show Info'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Info'));
        await tester.pumpAndSettle();

        expect(find.text('Info convenience'), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });

      testWidgets('success convenience method works correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.success(
                    context: context,
                    message: 'Success convenience',
                  );
                },
                child: const Text('Show Success'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Success'));
        await tester.pumpAndSettle();

        expect(find.text('Success convenience'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      });

      testWidgets('warning convenience method works correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.warning(
                    context: context,
                    message: 'Warning convenience',
                  );
                },
                child: const Text('Show Warning'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Warning'));
        await tester.pumpAndSettle();

        expect(find.text('Warning convenience'), findsOneWidget);
        expect(find.byIcon(Icons.warning_outlined), findsOneWidget);
      });

      testWidgets('error convenience method works correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.error(
                    context: context,
                    message: 'Error convenience',
                  );
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pumpAndSettle();

        expect(find.text('Error convenience'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });

    group('Styling and Layout', () {
      testWidgets('applies proper typography styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Styled message',
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // Find the text widget within the SnackBar
        final textWidget = tester.widget<Text>(find.text('Styled message'));

        // Verify text styling
        expect(textWidget.style?.fontSize, AppTypography.fontSizeMedium);
        expect(textWidget.style?.fontWeight, FontWeight.w500);
        expect(textWidget.style?.color, AppColors.uiWhite);
      });

      testWidgets('applies proper icon sizing', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(context: context, message: 'Icon test');
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // Verify icon size
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.info_outline));
        expect(iconWidget.size, AppTypography.iconSizeMedium);
      });

      testWidgets('uses floating behavior and proper margins', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Layout test',
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // Find the SnackBar widget
        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));

        // Verify floating behavior
        expect(snackBar.behavior, SnackBarBehavior.floating);

        // Verify margins (bottom is 80.0 to avoid blocking controls)
        expect(
          snackBar.margin,
          EdgeInsets.only(
            left: AppTypography.spacingMedium,
            right: AppTypography.spacingMedium,
            bottom: 80.0,
            top: AppTypography.spacingMedium,
          ),
        );

        // Verify elevation
        expect(snackBar.elevation, AppTypography.spacingMedium);
      });
    });

    group('Callback Handling', () {
      testWidgets('calls onVisible callback when SnackBar appears', (
        WidgetTester tester,
      ) async {
        bool visibilityCallbackCalled = false;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.show(
                    context: context,
                    message: 'Visibility test',
                    onVisible: () {
                      visibilityCallbackCalled = true;
                    },
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show SnackBar'));
        await tester.pumpAndSettle();

        // Verify callback was called
        expect(visibilityCallbackCalled, true);
        expect(find.text('Visibility test'), findsOneWidget);
      });
    });

    group('Multiple SnackBars', () {
      testWidgets('shows appropriate icons for different severities', (
        WidgetTester tester,
      ) async {
        // Test info SnackBar
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.info(context: context, message: 'Info test');
                },
                child: const Text('Show Info'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Info'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify info icon
        expect(find.byIcon(Icons.info_outline), findsOneWidget);

        // Clear the SnackBar and wait for animation to complete
        ScaffoldMessenger.of(
          tester.element(find.byType(ElevatedButton)),
        ).clearSnackBars();
        await tester.pump();
        await tester.pumpAndSettle();

        // Test error SnackBar with different widget
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.error(
                    context: context,
                    message: 'Error test',
                  );
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pump();
        await tester.pumpAndSettle();

        // Verify error icon
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });
    });

    group('Convenience Methods', () {
      testWidgets('info method should work correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.info(
                    context: context,
                    message: 'Information message',
                    actionLabel: 'Got it',
                    onActionPressed: () {},
                  );
                },
                child: const Text('Show Info'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Info'));
        await tester.pump();

        expect(find.text('Information message'), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        expect(find.text('Got it'), findsOneWidget);
      });

      testWidgets('success method should work correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.success(
                    context: context,
                    message: 'Success message',
                  );
                },
                child: const Text('Show Success'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Success'));
        await tester.pump();

        expect(find.text('Success message'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      });

      testWidgets('warning method should work correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.warning(
                    context: context,
                    message: 'Warning message',
                    duration: const Duration(seconds: 2),
                  );
                },
                child: const Text('Show Warning'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Warning'));
        await tester.pump();

        expect(find.text('Warning message'), findsOneWidget);
        expect(find.byIcon(Icons.warning_outlined), findsOneWidget);
      });

      testWidgets('error method should work correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GravitonSnackBar.error(
                    context: context,
                    message: 'Error message',
                    actionLabel: 'Retry',
                    onActionPressed: () {},
                  );
                },
                child: const Text('Show Error'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Error'));
        await tester.pump();

        expect(find.text('Error message'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });
  });
}
