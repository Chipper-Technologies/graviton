import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/account/edit_name_form.dart';

import '../../test_utils.dart';

void main() {
  group('EditNameForm', () {
    late TextEditingController nameController;

    setUp(() {
      nameController = TextEditingController();
    });

    tearDown(() {
      nameController.dispose();
    });

    testWidgets('displays name text field', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () {},
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays person icon', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () {},
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () {},
            onChanged: (value) => changedValue = value,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.pump();

      expect(changedValue, equals('New Name'));
    });

    testWidgets('calls onSave when save button tapped', (tester) async {
      bool saved = false;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () => saved = true,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(saved, isTrue);
    });

    testWidgets('updates controller text', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () {},
            onChanged: (_) {},
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test Name');
      await tester.pump();

      expect(nameController.text, equals('Test Name'));
    });

    testWidgets('save button spans full width', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () {},
            onChanged: (_) {},
          ),
        ),
      );

      // Button uses crossAxisAlignment.stretch in Column (find the EditNameForm's Column)
      final columns = find.byType(Column);
      expect(columns, findsWidgets);

      // The first Column should be EditNameForm's with crossAxisAlignment.stretch
      final columnWidget = tester.widget<Column>(columns.first);
      expect(
        columnWidget.crossAxisAlignment,
        equals(CrossAxisAlignment.stretch),
      );
    });

    testWidgets('renders in small screen size', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: EditNameForm(
            nameController: nameController,
            onSave: () {},
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
