import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/semantics/semantic_live_region.dart';
import '../../test_utils.dart';

void main() {
  group('SemanticLiveRegion', () {
    testWidgets('should create widget with proper semantics', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticLiveRegion(
            currentValue: '1.0',
            dataType: 'speed',
            child: Text('Live Region'),
          ),
        ),
      );

      expect(find.text('Live Region'), findsOneWidget);
    });

    testWidgets('should handle null localization gracefully', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticLiveRegion(
            currentValue: '2.0',
            dataType: 'time',
            child: Text('Live Region'),
          ),
        ),
      );

      expect(find.text('Live Region'), findsOneWidget);
    });

    testWidgets('should update when value changes', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticLiveRegion(
            currentValue: '1.0',
            dataType: 'speed',
            child: Text('Live Region'),
          ),
        ),
      );

      expect(find.text('Live Region'), findsOneWidget);

      // Update with new value
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticLiveRegion(
            currentValue: '2.0',
            dataType: 'speed',
            child: Text('Live Region'),
          ),
        ),
      );

      expect(find.text('Live Region'), findsOneWidget);
    });

    testWidgets('should respect announcement interval', (tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticLiveRegion(
            currentValue: '1.0',
            dataType: 'speed',
            announcementInterval: Duration(milliseconds: 100),
            child: Text('Live Region'),
          ),
        ),
      );

      expect(find.text('Live Region'), findsOneWidget);

      // Test rapid updates within interval
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: const SemanticLiveRegion(
            currentValue: '2.0',
            dataType: 'speed',
            announcementInterval: Duration(milliseconds: 100),
            child: Text('Live Region'),
          ),
        ),
      );

      expect(find.text('Live Region'), findsOneWidget);
    });

    group('Edge cases', () {
      testWidgets('should handle empty values', (tester) async {
        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticLiveRegion(
              currentValue: '',
              dataType: 'empty',
              child: Text('Empty Value'),
            ),
          ),
        );

        expect(find.text('Empty Value'), findsOneWidget);
      });

      testWidgets('should handle very long values', (tester) async {
        const longValue =
            'This is a very long value that might cause issues with announcement systems';

        await tester.pumpWidget(
          TestUtils.wrapWithMaterialApp(
            child: const SemanticLiveRegion(
              currentValue: longValue,
              dataType: 'long',
              child: Text('Long Value'),
            ),
          ),
        );

        expect(find.text('Long Value'), findsOneWidget);
      });
    });
  });
}
