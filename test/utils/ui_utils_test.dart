import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/ui_utils.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('UIUtils Tests', () {
    group('isEmoji', () {
      test('should correctly identify emojis', () {
        expect(UIUtils.isEmoji('😀'), isTrue);
        expect(UIUtils.isEmoji('🔥'), isTrue);
        expect(UIUtils.isEmoji('❄️'), isTrue);
        expect(UIUtils.isEmoji('🚀'), isTrue);
        expect(UIUtils.isEmoji('⚫'), isTrue);
        expect(UIUtils.isEmoji('🌟'), isTrue);
      });

      test('should correctly identify non-emojis', () {
        expect(UIUtils.isEmoji('A'), isFalse);
        expect(UIUtils.isEmoji('1'), isFalse);
        expect(UIUtils.isEmoji('@'), isFalse);
        expect(UIUtils.isEmoji(' '), isFalse);
        expect(UIUtils.isEmoji(''), isFalse);
      });
    });

    group('formatBodyName', () {
      test('should return the same body name for now', () {
        const bodyName = 'Earth';
        const bodyType = 'planet';
        final result = UIUtils.formatBodyName(bodyName, bodyType);
        expect(result, equals(bodyName));
      });
    });

    testWidgets('buildBulletList should create proper bullet list', (
      WidgetTester tester,
    ) async {
      final items = ['First item', 'Second item', 'Third item'];

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: UIUtils.buildBulletList(items))),
      );

      // Check that all items are present
      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }

      // Check that bullet points are present
      expect(find.text('•'), findsNWidgets(items.length));

      // Verify widget structure
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNWidgets(items.length));
    });

    testWidgets('buildNumberedList should create proper numbered list', (
      WidgetTester tester,
    ) async {
      final items = ['First item', 'Second item', 'Third item'];

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: UIUtils.buildNumberedList(items))),
      );

      // Check that all items are present
      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }

      // Check that numbers are present
      expect(find.text('1.'), findsOneWidget);
      expect(find.text('2.'), findsOneWidget);
      expect(find.text('3.'), findsOneWidget);

      // Verify widget structure
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNWidgets(items.length));
    });

    testWidgets('buildFormattedContent should handle line breaks', (
      WidgetTester tester,
    ) async {
      const content = 'Line 1\n\nLine 3\nLine 4';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UIUtils.buildFormattedContent(content)),
        ),
      );

      // Check that content lines are present
      expect(find.text('Line 1'), findsOneWidget);
      expect(find.text('Line 3'), findsOneWidget);
      expect(find.text('Line 4'), findsOneWidget);

      // Verify widget structure
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(3)); // 3 non-empty lines
    });

    testWidgets('buildSection should create section with title and content', (
      WidgetTester tester,
    ) async {
      const title = 'Test Section';
      const contentText = 'Test content';
      final content = Text(contentText);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => UIUtils.buildSection(
                context: context,
                title: title,
                content: content,
                icon: Icons.info,
              ),
            ),
          ),
        ),
      );

      // Check that title and content are present
      expect(find.text(title), findsOneWidget);
      expect(find.text(contentText), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);

      // Verify widget structure
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('buildSectionHeader should create header with icon and title', (
      WidgetTester tester,
    ) async {
      const title = 'Test Header';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UIUtils.buildSectionHeader(
              title,
              Icons.settings,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      );

      // Check that title is present
      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Verify widget structure
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('buildSection should work without icon', (
      WidgetTester tester,
    ) async {
      const title = 'Test Section';
      const contentText = 'Test content';
      final content = Text(contentText);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => UIUtils.buildSection(
                context: context,
                title: title,
                content: content,
              ),
            ),
          ),
        ),
      );

      // Check that title and content are present
      expect(find.text(title), findsOneWidget);
      expect(find.text(contentText), findsOneWidget);

      // Icon should not be present
      expect(find.byType(Icon), findsNothing);
    });
  });
}
