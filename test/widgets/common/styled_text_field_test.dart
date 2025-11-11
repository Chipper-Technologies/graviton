import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/styled_text_field.dart';

void main() {
  group('StyledTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('displays correctly with required properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify the icon is displayed
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Verify the hint text is displayed
      expect(find.text('Enter name'), findsOneWidget);

      // Verify the container is styled correctly
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(
        decoration.borderRadius,
        BorderRadius.circular(AppTypography.radiusLarge),
      );
    });

    testWidgets('shows label when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              labelText: 'Name',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('handles text input correctly', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // Enter text in the field
      await tester.enterText(find.byType(TextField), 'John Doe');
      expect(controller.text, equals('John Doe'));
      expect(changedValue, equals('John Doe'));
    });

    testWidgets('displays error state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              errorText: 'This field is required',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify error text is displayed
      expect(find.text('This field is required'), findsOneWidget);

      // Verify error styling
      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(icon.color, equals(AppColors.uiRed));
    });

    testWidgets('handles disabled state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              enabled: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify the TextField is disabled
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);

      // Verify disabled styling
      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(
        icon.color,
        equals(
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityDisabled),
        ),
      );
    });

    testWidgets('supports multiline input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Enter description',
              maxLines: 3,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, equals(3));
    });

    testWidgets('supports minLines and maxLines configuration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Enter description',
              minLines: 2,
              maxLines: 4,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.minLines, equals(2));
      expect(textField.maxLines, equals(4));
    });

    testWidgets('minLines defaults to null when not specified', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Enter description',
              maxLines: 3,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.minLines, isNull);
      expect(textField.maxLines, equals(3));
    });

    testWidgets('supports expandable text field configuration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.description,
              hintText: 'Describe what this scenario demonstrates',
              minLines: 2,
              maxLines: 4,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify the text field has the correct expandable configuration
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.minLines,
        equals(2),
        reason: 'Text field should start with 2 lines',
      );
      expect(
        textField.maxLines,
        equals(4),
        reason: 'Text field should expand up to 4 lines',
      );

      // Verify hint text is correct
      expect(
        find.text('Describe what this scenario demonstrates'),
        findsOneWidget,
      );
    });

    testWidgets('supports different keyboard types', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.numbers,
              hintText: 'Enter number',
              keyboardType: TextInputType.number,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.number));
    });

    testWidgets('has proper visual hierarchy with label and error', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              labelText: 'Full Name',
              errorText: 'Name is required',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify all elements are present
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Enter name'), findsOneWidget);
      expect(find.text('Name is required'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('uses correct styling constants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledTextField(
              controller: controller,
              icon: Icons.person,
              hintText: 'Enter name',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Find the icon
      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(icon.size, equals(AppTypography.iconSizeXXLarge));
      expect(icon.color, equals(AppColors.primaryColor));

      // Find the container with border
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.width, equals(AppTypography.borderMedium));
      expect(
        border.top.color,
        equals(
          AppColors.primaryColor.withValues(alpha: AppTypography.opacityHigh),
        ),
      );
    });
  });
}
