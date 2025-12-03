import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/dialog_action.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/dialog_title.dart';

import '../../test_utils.dart';

void main() {
  group('BaseConfirmationDialog Tests', () {
    late List<DialogAction> testActions;

    setUp(() {
      testActions = [
        DialogAction(text: 'Cancel', onPressed: () {}),
        DialogAction(
          text: 'Confirm',
          onPressed: () {},
          textColor: AppColors.primaryColor,
        ),
      ];
    });

    testWidgets('should display dialog with basic content', (
      WidgetTester tester,
    ) async {
      const title = 'Test Dialog';
      const message = 'This is a test message';

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: title,
            message: message,
            actions: testActions,
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('should display title icon when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            titleIcon: Icons.warning,
            actions: testActions,
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.byType(DialogTitle), findsOneWidget);
    });

    testWidgets('should not display DialogTitle when no icon provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            actions: testActions,
          ),
        ),
      );

      expect(find.byType(DialogTitle), findsNothing);
      expect(
        find.text('Test Dialog'),
        findsOneWidget,
      ); // Still shows title as Text
    });

    testWidgets('should use custom icon color when provided', (
      WidgetTester tester,
    ) async {
      const customColor = AppColors.uiOrangeAccent;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            titleIcon: Icons.error,
            iconColor: customColor,
            actions: testActions,
          ),
        ),
      );

      final dialogTitle = tester.widget<DialogTitle>(find.byType(DialogTitle));
      expect(dialogTitle.iconColor, customColor);
    });

    testWidgets('should apply custom styling to action buttons', (
      WidgetTester tester,
    ) async {
      final customActions = [
        DialogAction(
          text: 'Custom Action',
          onPressed: () {},
          textColor: AppColors.uiRed,
          backgroundColor: AppColors.stellarGType.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
          fontWeight: FontWeight.bold,
        ),
      ];

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            actions: customActions,
          ),
        ),
      );

      expect(find.text('Custom Action'), findsOneWidget);
    });

    testWidgets('should handle multiple actions correctly', (
      WidgetTester tester,
    ) async {
      final multipleActions = [
        DialogAction(text: 'Action 1', onPressed: () {}),
        DialogAction(text: 'Action 2', onPressed: () {}),
        DialogAction(text: 'Action 3', onPressed: () {}),
      ];

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            actions: multipleActions,
          ),
        ),
      );

      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
      expect(find.text('Action 3'), findsOneWidget);
    });

    testWidgets('should apply custom background color when provided', (
      WidgetTester tester,
    ) async {
      const customBackground = AppColors.stellarOType;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            backgroundColor: customBackground,
            actions: testActions,
          ),
        ),
      );

      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(alertDialog.backgroundColor, customBackground);
    });

    testWidgets('should use constraints when useConstraints is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            actions: testActions,
            useConstraints: true,
          ),
        ),
      );

      // Find ConstrainedBox that wraps our AlertDialog specifically
      final constrainedBoxes = find.byType(ConstrainedBox);
      final alertDialog = find.byType(AlertDialog);

      expect(constrainedBoxes, findsWidgets);
      expect(alertDialog, findsOneWidget);

      // Verify that our dialog is wrapped in a ConstrainedBox by checking
      // if any ConstrainedBox has an AlertDialog as a descendant
      bool foundConstrainedAlertDialog = false;
      for (final element in constrainedBoxes.evaluate()) {
        final widget = element.widget;
        if (widget is ConstrainedBox) {
          // Check if this ConstrainedBox contains our AlertDialog
          final descendants = find.descendant(
            of: find.byWidget(widget),
            matching: find.byType(AlertDialog),
          );
          if (descendants.evaluate().isNotEmpty) {
            foundConstrainedAlertDialog = true;
            break;
          }
        }
      }

      expect(foundConstrainedAlertDialog, true);
    });

    testWidgets('should not use constraints when useConstraints is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Test Dialog',
            message: 'Test message',
            actions: testActions,
            useConstraints: false,
          ),
        ),
      );

      // Should find AlertDialog but verify it's not wrapped in a ConstrainedBox
      expect(find.byType(AlertDialog), findsOneWidget);

      final constrainedBoxes = find.byType(ConstrainedBox);

      // Check that no ConstrainedBox directly contains our AlertDialog
      bool foundConstrainedAlertDialog = false;
      for (final element in constrainedBoxes.evaluate()) {
        final widget = element.widget;
        if (widget is ConstrainedBox) {
          final childWidget = (widget).child;
          if (childWidget is AlertDialog) {
            foundConstrainedAlertDialog = true;
            break;
          }
        }
      }

      expect(foundConstrainedAlertDialog, false);
    });

    group('Static show method tests', () {
      testWidgets('should show dialog with static show method', (
        WidgetTester tester,
      ) async {
        bool? result;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await BaseConfirmationDialog.show<bool>(
                      context: context,
                      title: 'Static Test',
                      message: 'Static show test',
                      actions: [
                        DialogAction(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        DialogAction(
                          text: 'OK',
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        expect(find.text('Static Test'), findsOneWidget);
        expect(find.text('Static show test'), findsOneWidget);

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(result, true);
      });

      testWidgets('should handle barrierDismissible correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await BaseConfirmationDialog.show(
                      context: context,
                      title: 'Non-dismissible',
                      message: 'Cannot dismiss',
                      barrierDismissible: false,
                      actions: [
                        DialogAction(
                          text: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Try to tap outside to dismiss - should not work
        await tester.tapAt(const Offset(50, 50));
        await tester.pump();

        expect(find.text('Non-dismissible'), findsOneWidget);
      });
    });

    group('Convenience showConfirmation method tests', () {
      testWidgets('should show confirmation dialog with default buttons', (
        WidgetTester tester,
      ) async {
        bool? result;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await BaseConfirmationDialog.showConfirmation(
                      context: context,
                      title: 'Confirm Action',
                      message: 'Are you sure?',
                    );
                  },
                  child: const Text('Show Confirmation'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Confirmation'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm Action'), findsOneWidget);
        expect(find.text('Are you sure?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(result, true);
      });

      testWidgets('should show destructive confirmation with custom styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await BaseConfirmationDialog.showConfirmation(
                      context: context,
                      title: 'Delete Item',
                      message: 'This cannot be undone',
                      isDestructive: true,
                      titleIcon: Icons.warning,
                    );
                  },
                  child: const Text('Show Destructive'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Destructive'));
        await tester.pumpAndSettle();

        expect(find.text('Delete Item'), findsOneWidget);
        expect(
          find.text('Delete'),
          findsOneWidget,
        ); // Should use delete button text
        expect(find.byIcon(Icons.warning), findsOneWidget);
      });

      testWidgets('should use custom button text when provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await BaseConfirmationDialog.showConfirmation(
                      context: context,
                      title: 'Custom Buttons',
                      message: 'Test message',
                      confirmText: 'Proceed',
                      cancelText: 'Go Back',
                    );
                  },
                  child: const Text('Show Custom'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Custom'));
        await tester.pumpAndSettle();

        expect(find.text('Proceed'), findsOneWidget);
        expect(find.text('Go Back'), findsOneWidget);
      });

      testWidgets('should return false when cancel is pressed', (
        WidgetTester tester,
      ) async {
        bool? result;

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    result = await BaseConfirmationDialog.showConfirmation(
                      context: context,
                      title: 'Test Cancel',
                      message: 'Test message',
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(result, false);
      });
    });

    testWidgets('should handle very long text content gracefully', (
      WidgetTester tester,
    ) async {
      const longTitle =
          'This is a very long title that might wrap to multiple lines';
      const longMessage =
          'This is a very long message content that should be displayed properly without overflow issues and should maintain good readability even when it spans multiple lines';

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: longTitle,
            message: longMessage,
            actions: testActions,
          ),
        ),
      );

      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('should be accessible to screen readers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Accessibility Test',
            message: 'This dialog should be accessible',
            titleIcon: Icons.info,
            actions: testActions,
          ),
        ),
      );

      expect(find.text('Accessibility Test'), findsOneWidget);
      expect(find.text('This dialog should be accessible'), findsOneWidget);

      // Verify that the dialog is semantically valid
      expect(tester.getSemantics(find.byType(AlertDialog)), isNotNull);
    });

    testWidgets('should handle empty actions list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'No Actions',
            message: 'This dialog has no actions',
            actions: const [],
          ),
        ),
      );

      expect(find.text('No Actions'), findsOneWidget);
      expect(find.text('This dialog has no actions'), findsOneWidget);

      // Should still render without errors
      final alertDialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
      expect(alertDialog.actions, isEmpty);
    });

    testWidgets('should create widget directly without static methods', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BaseConfirmationDialog(
            title: 'Direct Widget',
            message: 'Testing direct widget creation',
            titleIcon: Icons.check,
            actions: [DialogAction(text: 'Direct Action', onPressed: () {})],
          ),
        ),
      );

      expect(find.text('Direct Widget'), findsOneWidget);
      expect(find.text('Testing direct widget creation'), findsOneWidget);
      expect(find.text('Direct Action'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
