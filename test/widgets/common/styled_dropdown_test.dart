import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/styled_dropdown.dart';

enum TestEnum { first, second, third }

void main() {
  group('StyledDropdown', () {
    testWidgets('displays correctly with required properties', (tester) async {
      String selectedValue = 'option1';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<String>(
              value: selectedValue,
              icon: Icons.category,
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
                DropdownMenuItem(value: 'option3', child: Text('Option 3')),
              ],
              onChanged: (String? value) {
                selectedValue = value ?? selectedValue;
              },
            ),
          ),
        ),
      );

      // Verify the icon is displayed
      expect(find.byIcon(Icons.category), findsOneWidget);

      // Verify the dropdown arrow is displayed
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);

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
            body: StyledDropdown<String>(
              value: 'option1',
              icon: Icons.category,
              labelText: 'Category',
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('handles selection correctly', (tester) async {
      String selectedValue = 'option1';
      String? changedValue;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: StyledDropdown<String>(
                  value: selectedValue,
                  icon: Icons.category,
                  items: const [
                    DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                    DropdownMenuItem(value: 'option2', child: Text('Option 2')),
                    DropdownMenuItem(value: 'option3', child: Text('Option 3')),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value ?? selectedValue;
                      changedValue = value;
                    });
                  },
                ),
              ),
            );
          },
        ),
      );

      // Tap the dropdown to open it
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Tap on 'Option 2'
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(changedValue, equals('option2'));
    });

    testWidgets('displays error state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<String>(
              value: 'option1',
              icon: Icons.category,
              errorText: 'Please select a valid option',
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify error text is displayed
      expect(find.text('Please select a valid option'), findsOneWidget);

      // Verify error styling
      final icon = tester.widget<Icon>(find.byIcon(Icons.category));
      expect(icon.color, equals(AppColors.uiRed));
    });

    testWidgets('handles disabled state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<String>(
              value: 'option1',
              icon: Icons.category,
              enabled: false,
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify the DropdownButtonFormField is disabled
      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.onChanged, isNull);

      // Verify disabled styling
      final icon = tester.widget<Icon>(find.byIcon(Icons.category));
      expect(
        icon.color,
        equals(
          AppColors.uiWhite.withValues(alpha: AppTypography.opacityDisabled),
        ),
      );
    });

    testWidgets('shows hint text when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<String>(
              value: 'option1',
              icon: Icons.category,
              hintText: 'Select an option',
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // The hint text should be set in the InputDecoration
      final dropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdown.decoration.hintText, equals('Select an option'));
    });

    testWidgets('has proper visual hierarchy with label and error', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<String>(
              value: 'option1',
              icon: Icons.category,
              labelText: 'Category',
              errorText: 'Selection is required',
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Verify all elements are present
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Selection is required'), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('uses correct styling constants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<String>(
              value: 'option1',
              icon: Icons.category,
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Find the category icon
      final categoryIcon = tester.widget<Icon>(find.byIcon(Icons.category));
      expect(categoryIcon.size, equals(AppTypography.iconSizeXXLarge));
      expect(categoryIcon.color, equals(AppColors.primaryColor));

      // Find the dropdown arrow icon
      final arrowIcon = tester.widget<Icon>(find.byIcon(Icons.arrow_drop_down));
      expect(arrowIcon.color, equals(AppColors.primaryColor));

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

    testWidgets('supports generic types correctly', (tester) async {
      TestEnum selectedValue = TestEnum.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledDropdown<TestEnum>(
              value: selectedValue,
              icon: Icons.category,
              items: const [
                DropdownMenuItem(value: TestEnum.first, child: Text('First')),
                DropdownMenuItem(value: TestEnum.second, child: Text('Second')),
                DropdownMenuItem(value: TestEnum.third, child: Text('Third')),
              ],
              onChanged: (TestEnum? value) {
                selectedValue = value ?? selectedValue;
              },
            ),
          ),
        ),
      );

      // Verify the dropdown works with enum types
      expect(find.byType(DropdownButtonFormField<TestEnum>), findsOneWidget);
      expect(find.byIcon(Icons.category), findsOneWidget);
    });
  });
}
