import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';

import '../../test_utils.dart';

void main() {
  group('DeleteConfirmationDialog Tests', () {
    testWidgets('should display dialog with required content', (
      WidgetTester tester,
    ) async {
      const title = 'Delete Test Item';
      const message = 'Are you sure you want to delete this item?';

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: title,
                    message: message,
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );

      // Tap the button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should display title icon when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Test Item',
                    message: 'Test message',
                    titleIcon: Icons.warning_amber_rounded,
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

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('should not display title icon when not provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Test Item',
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

      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
    });

    testWidgets('should return false when cancel is tapped', (
      WidgetTester tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Test Item',
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

    testWidgets('should return true when delete is tapped', (
      WidgetTester tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Test Item',
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

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('should use custom warning color when provided', (
      WidgetTester tester,
    ) async {
      const customColor = AppColors.uiOrangeAccent;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Test Item',
                    message: 'Test message',
                    titleIcon: Icons.warning,
                    warningColor: customColor,
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

      // Find the warning icon and verify it has the custom color
      final iconFinder = find.byIcon(Icons.warning);
      expect(iconFinder, findsOneWidget);

      final Icon iconWidget = tester.widget(iconFinder);
      expect(
        iconWidget.color,
        customColor.withValues(alpha: AppTypography.opacityVeryFaint),
      );
    });

    testWidgets('should use default warning color when not provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Test Item',
                    message: 'Test message',
                    titleIcon: Icons.warning,
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

      final iconFinder = find.byIcon(Icons.warning);
      expect(iconFinder, findsOneWidget);

      final Icon iconWidget = tester.widget(iconFinder);
      expect(
        iconWidget.color,
        AppColors.celestialRed.withValues(
          alpha: AppTypography.opacityVeryFaint,
        ),
      );
    });

    testWidgets('should be accessible to screen readers', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: 'Delete Important Item',
                    message: 'This action cannot be undone',
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

      // Verify that the dialog is properly accessible
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Important Item'), findsOneWidget);
      expect(find.text('This action cannot be undone'), findsOneWidget);
    });

    testWidgets('should handle long text content properly', (
      WidgetTester tester,
    ) async {
      const longTitle = 'Delete This Very Long Item Name That Might Wrap';
      const longMessage =
          'This is a very long confirmation message that explains in detail what will happen when the user confirms the deletion. It should wrap properly and remain readable.';

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await DeleteConfirmationDialog.show(
                    context: context,
                    title: longTitle,
                    message: longMessage,
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

      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('should create widget directly without static show method', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const DeleteConfirmationDialog(
            title: 'Direct Test',
            message: 'Testing direct widget creation',
            titleIcon: Icons.delete,
          ),
        ),
      );

      expect(find.text('Direct Test'), findsOneWidget);
      expect(find.text('Testing direct widget creation'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });
}
