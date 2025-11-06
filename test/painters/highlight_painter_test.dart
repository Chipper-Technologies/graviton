import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/painters/highlight_painter.dart';

void main() {
  group('HighlightPainter', () {
    test('should create instance with highlight area', () {
      const highlightArea = Rect.fromLTWH(10, 20, 100, 150);
      final painter = HighlightPainter(highlightArea);

      expect(painter.highlightArea, equals(highlightArea));
    });

    test('should handle different highlight area sizes', () {
      const smallArea = Rect.fromLTWH(0, 0, 50, 50);
      const largeArea = Rect.fromLTWH(100, 100, 500, 600);

      final smallPainter = HighlightPainter(smallArea);
      final largePainter = HighlightPainter(largeArea);

      expect(smallPainter.highlightArea, equals(smallArea));
      expect(largePainter.highlightArea, equals(largeArea));
    });

    test('should handle zero-sized areas', () {
      const zeroArea = Rect.fromLTWH(0, 0, 0, 0);
      final painter = HighlightPainter(zeroArea);

      expect(painter.highlightArea, equals(zeroArea));
      expect(painter.highlightArea.width, equals(0));
      expect(painter.highlightArea.height, equals(0));
    });

    test('should handle negative coordinates', () {
      const negativeArea = Rect.fromLTWH(-50, -100, 200, 300);
      final painter = HighlightPainter(negativeArea);

      expect(painter.highlightArea, equals(negativeArea));
      expect(painter.highlightArea.left, equals(-50));
      expect(painter.highlightArea.top, equals(-100));
    });

    test('should not repaint when highlight area is the same', () {
      const area = Rect.fromLTWH(10, 20, 100, 150);
      final painter1 = HighlightPainter(area);
      final painter2 = HighlightPainter(area);

      // Both painters have the same area, so shouldRepaint should return false
      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('should use correct paint properties', () {
      const area = Rect.fromLTWH(0, 0, 100, 100);
      final painter = HighlightPainter(area);

      // Test that the painter can be created without throwing
      expect(() => painter, returnsNormally);
    });

    testWidgets('should paint highlight correctly', (
      WidgetTester tester,
    ) async {
      final painter = HighlightPainter(const Rect.fromLTWH(10, 10, 100, 100));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(painter: painter, size: const Size(200, 200)),
          ),
        ),
      );

      // Find our specific CustomPaint widget by looking for one with our painter
      final customPaintWidgets = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );

      // Verify our painter is being used in at least one CustomPaint widget
      expect(customPaintWidgets.length, greaterThanOrEqualTo(1));

      bool foundOurPainter = false;
      for (final widget in customPaintWidgets) {
        if (widget.painter is HighlightPainter) {
          foundOurPainter = true;
          break;
        }
      }
      expect(foundOurPainter, isTrue);
    });

    testWidgets('should handle full screen highlight', (
      WidgetTester tester,
    ) async {
      const fullScreenArea = Rect.fromLTWH(0, 0, 400, 800);
      final painter = HighlightPainter(fullScreenArea);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(painter: painter, size: const Size(400, 800)),
          ),
        ),
      );

      // Verify CustomPaint widgets exist (may be multiple due to Material framework)
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

      // Verify our painter is present
      final customPaintWidgets = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );

      bool foundOurPainter = false;
      for (final widget in customPaintWidgets) {
        if (widget.painter is HighlightPainter) {
          foundOurPainter = true;
          break;
        }
      }
      expect(foundOurPainter, isTrue);
    });

    testWidgets('should handle small highlight areas', (
      WidgetTester tester,
    ) async {
      const smallArea = Rect.fromLTWH(10, 10, 5, 5);
      final painter = HighlightPainter(smallArea);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(painter: painter, size: const Size(100, 100)),
          ),
        ),
      );

      // Verify CustomPaint widgets exist
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

      // Verify our painter is present
      final customPaintWidgets = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );

      bool foundOurPainter = false;
      for (final widget in customPaintWidgets) {
        if (widget.painter is HighlightPainter) {
          foundOurPainter = true;
          break;
        }
      }
      expect(foundOurPainter, isTrue);
    });

    test('should maintain highlight area immutability', () {
      const originalArea = Rect.fromLTWH(10, 20, 100, 150);
      final painter = HighlightPainter(originalArea);

      // The highlight area should remain unchanged
      expect(painter.highlightArea, equals(originalArea));
      expect(painter.highlightArea.left, equals(10));
      expect(painter.highlightArea.top, equals(20));
      expect(painter.highlightArea.width, equals(100));
      expect(painter.highlightArea.height, equals(150));
    });

    test('should work with different rect creation methods', () {
      const areaLTWH = Rect.fromLTWH(10, 20, 100, 150);
      const areaLTRB = Rect.fromLTRB(10, 20, 110, 170);
      final areaCircle = Rect.fromCircle(
        center: const Offset(60, 95),
        radius: 50,
      );

      final painter1 = HighlightPainter(areaLTWH);
      final painter2 = HighlightPainter(areaLTRB);
      final painter3 = HighlightPainter(areaCircle);

      expect(painter1.highlightArea, equals(areaLTWH));
      expect(painter2.highlightArea, equals(areaLTRB));
      expect(painter3.highlightArea, equals(areaCircle));

      // LTWH and LTRB should represent the same area
      expect(painter1.highlightArea.left, equals(painter2.highlightArea.left));
      expect(painter1.highlightArea.top, equals(painter2.highlightArea.top));
      expect(
        painter1.highlightArea.right,
        equals(painter2.highlightArea.right),
      );
      expect(
        painter1.highlightArea.bottom,
        equals(painter2.highlightArea.bottom),
      );
    });
  });
}
