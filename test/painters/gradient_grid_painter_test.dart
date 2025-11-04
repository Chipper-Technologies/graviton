import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/painters/gradient_grid_painter.dart';
import 'package:graviton/theme/app_colors.dart';

void main() {
  group('GradientGridPainter', () {
    test('should create painter with default parameters', () {
      const painter = GradientGridPainter();

      expect(painter.gridSize, equals(20.0));
      expect(painter.gridColor, equals(AppColors.uiWhite));
      expect(painter.opacity, equals(0.1));
    });

    test('should create painter with custom parameters', () {
      const painter = GradientGridPainter(
        gridSize: 16.0,
        gridColor: AppColors.primaryColor,
        opacity: 0.15,
      );

      expect(painter.gridSize, equals(16.0));
      expect(painter.gridColor, equals(AppColors.primaryColor));
      expect(painter.opacity, equals(0.15));
    });

    testWidgets('should render without errors in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: const GradientGridPainter(),
              size: const Size(200, 100),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should render with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: const GradientGridPainter(
                gridSize: 10.0,
                gridColor: AppColors.galaxyRoyalBlue,
                opacity: 0.5,
              ),
              size: const Size(300, 150),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    test('should handle shouldRepaint correctly with same parameters', () {
      const painter1 = GradientGridPainter(
        gridSize: 16.0,
        gridColor: AppColors.primaryColor,
        opacity: 0.15,
      );
      const painter2 = GradientGridPainter(
        gridSize: 16.0,
        gridColor: AppColors.primaryColor,
        opacity: 0.15,
      );

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('should handle shouldRepaint correctly with different gridSize', () {
      const painter1 = GradientGridPainter(gridSize: 16.0);
      const painter2 = GradientGridPainter(gridSize: 20.0);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('should handle shouldRepaint correctly with different gridColor', () {
      const painter1 = GradientGridPainter(gridColor: AppColors.primaryColor);
      const painter2 = GradientGridPainter(gridColor: AppColors.uiWhite);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('should handle shouldRepaint correctly with different opacity', () {
      const painter1 = GradientGridPainter(opacity: 0.1);
      const painter2 = GradientGridPainter(opacity: 0.2);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test(
      'should handle shouldRepaint correctly with different painter type',
      () {
        const painter1 = GradientGridPainter();
        const painter2 = _MockPainter();

        expect(painter1.shouldRepaint(painter2), isTrue);
      },
    );

    test('should support various grid sizes', () {
      const smallGrid = GradientGridPainter(gridSize: 8.0);
      const mediumGrid = GradientGridPainter(gridSize: 16.0);
      const largeGrid = GradientGridPainter(gridSize: 32.0);

      expect(smallGrid.gridSize, equals(8.0));
      expect(mediumGrid.gridSize, equals(16.0));
      expect(largeGrid.gridSize, equals(32.0));
    });

    test('should support various opacity levels', () {
      const lowOpacity = GradientGridPainter(opacity: 0.05);
      const mediumOpacity = GradientGridPainter(opacity: 0.15);
      const highOpacity = GradientGridPainter(opacity: 0.25);

      expect(lowOpacity.opacity, equals(0.05));
      expect(mediumOpacity.opacity, equals(0.15));
      expect(highOpacity.opacity, equals(0.25));
    });

    test('should support different colors', () {
      const whiteGrid = GradientGridPainter(gridColor: AppColors.uiWhite);
      const primaryGrid = GradientGridPainter(
        gridColor: AppColors.primaryColor,
      );
      const redGrid = GradientGridPainter(gridColor: Colors.red);

      expect(whiteGrid.gridColor, equals(AppColors.uiWhite));
      expect(primaryGrid.gridColor, equals(AppColors.primaryColor));
      expect(redGrid.gridColor, equals(Colors.red));
    });

    testWidgets('should work with different widget sizes', (tester) async {
      // Test with square size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: const GradientGridPainter(),
              size: const Size(100, 100),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

      // Test with rectangular size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              painter: const GradientGridPainter(),
              size: const Size(300, 80),
            ),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should integrate well with ClipRRect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CustomPaint(
                painter: const GradientGridPainter(),
                size: const Size(200, 100),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });
  });
}

/// Mock painter for testing shouldRepaint with different painter types
class _MockPainter extends CustomPainter {
  const _MockPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Mock implementation
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
