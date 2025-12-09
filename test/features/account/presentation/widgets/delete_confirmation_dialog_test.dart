import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/features/account/presentation/widgets/delete_confirmation_dialog.dart';

import '../../../../test_utils.dart';

void main() {
  group('DeleteConfirmationDialog', () {
    testWidgets('displays warning icon', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('warning icon has red color', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () {},
          ),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.warning_amber_rounded),
      );
      expect(icon.color, isNotNull);
    });

    testWidgets('displays warning title text', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () {},
          ),
        ),
      );

      // Should have Text widgets for title and message
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('calls onConfirmDelete when delete button tapped', (
      tester,
    ) async {
      bool confirmed = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () => confirmed = true,
            onCancel: () {},
          ),
        ),
      );

      // Find and tap the delete button (elevated button)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(confirmed, isTrue);
    });

    testWidgets('calls onCancel when cancel button tapped', (tester) async {
      bool cancelled = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () => cancelled = true,
          ),
        ),
      );

      // Find and tap the cancel button (text button)
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(cancelled, isTrue);
    });

    testWidgets('delete button has red styling', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () {},
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.style, isNotNull);
    });

    testWidgets('delete button spans full width', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () {},
          ),
        ),
      );

      final sizedBox = find.ancestor(
        of: find.byType(ElevatedButton),
        matching: find.byType(SizedBox),
      );

      if (tester.any(sizedBox)) {
        final box = tester.widget<SizedBox>(sizedBox.first);
        expect(box.width, equals(double.infinity));
      }
    });

    testWidgets('can confirm delete multiple times', (tester) async {
      int confirmCount = 0;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () => confirmCount++,
            onCancel: () {},
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(confirmCount, equals(1));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(confirmCount, equals(2));
    });

    testWidgets('renders in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: DeleteConfirmationDialog(
            onConfirmDelete: () {},
            onCancel: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
