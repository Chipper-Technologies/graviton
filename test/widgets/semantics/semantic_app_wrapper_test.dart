import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_app_wrapper.dart';
import 'package:graviton/services/semantic_focus_service.dart';

import '../../test_utils.dart';

void main() {
  group('SemanticAppWrapper', () {
    setUp(() {
      SemanticFocusService.instance.setEnabled(true);
    });

    testWidgets('should render child widget', (tester) async {
      const testChild = Text('Test App Content');

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticAppWrapper(child: testChild),
        ),
      );

      expect(find.text('Test App Content'), findsOneWidget);
    });

    testWidgets('should create focus scope and keyboard shortcuts', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticAppWrapper(child: Text('App Content')),
        ),
      );

      expect(find.text('App Content'), findsOneWidget);
      expect(find.byType(FocusScope), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle complex child hierarchies', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: SemanticAppWrapper(
            child: Column(
              children: const [Text('Header'), Text('Content'), Text('Footer')],
            ),
          ),
        ),
      );

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('should work with different child widgets', (tester) async {
      final childWidgets = [
        const Text('Simple Text'),
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text('Container Child'),
        ),
        const Center(child: Text('Centered Child')),
      ];

      for (int i = 0; i < childWidgets.length; i++) {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticAppWrapper(child: childWidgets[i]),
          ),
        );

        if (i == 0) {
          expect(find.text('Simple Text'), findsOneWidget);
        } else if (i == 1) {
          expect(find.text('Container Child'), findsOneWidget);
        } else {
          expect(find.text('Centered Child'), findsOneWidget);
        }
      }
    });

    testWidgets('should maintain focus structure', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticAppWrapper(child: Text('Focus Test')),
        ),
      );

      // Verify FocusScope is created
      expect(find.byType(FocusScope), findsAtLeastNWidgets(1));
      expect(find.text('Focus Test'), findsOneWidget);
    });

    group('Edge cases', () {
      testWidgets('should handle empty container as child', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticAppWrapper(child: Container()),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should handle sized box as child', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticAppWrapper(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Text('Sized Content'),
              ),
            ),
          ),
        );

        expect(find.text('Sized Content'), findsOneWidget);
      });

      testWidgets('should handle nested semantics', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticAppWrapper(
              child: Semantics(
                label: 'Nested Semantics',
                child: const Text('Nested Content'),
              ),
            ),
          ),
        );

        expect(find.text('Nested Content'), findsOneWidget);
      });

      testWidgets('should handle scrollable content', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: SemanticAppWrapper(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(20, (index) => Text('Item $index')),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Item 19'), findsOneWidget);
      });
    });
  });
}
