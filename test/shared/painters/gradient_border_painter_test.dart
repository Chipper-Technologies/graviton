import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/painters/gradient_border_painter.dart';

void main() {
  group('GradientBorderPainter', () {
    late GradientBorderPainter painter;

    setUp(() {
      painter = GradientBorderPainter();
    });

    test('should create instance', () {
      expect(painter, isNotNull);
      expect(painter, isA<CustomPainter>());
    });

    test('should not repaint by default', () {
      final oldPainter = GradientBorderPainter();
      expect(painter.shouldRepaint(oldPainter), isFalse);
    });

    testWidgets('should paint without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(painter: painter, size: const Size(200, 50)),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should render with different sizes', (tester) async {
      for (final size in [
        const Size(100, 50),
        const Size(200, 60),
        const Size(300, 70),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(painter: painter, size: size),
            ),
          ),
        );

        expect(find.byType(CustomPaint), findsWidgets);
      }
    });
  });
}
