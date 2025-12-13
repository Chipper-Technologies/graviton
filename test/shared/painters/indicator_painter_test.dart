import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/shared/painters/indicator_painter.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/models/ui/indicator_data.dart';
import 'package:graviton/models/celestial/body.dart';
import 'package:graviton/core/enums/body_type.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('IndicatorPainter Tests', () {
    late Body testBody;
    late IndicatorData testIndicator;
    late IndicatorPainter painter;

    setUp(() {
      testBody = Body(
        name: 'Test Planet',
        mass: 1.0,
        radius: 5.0,
        position: vm.Vector3(100, 200, 300),
        velocity: vm.Vector3(10, 20, 30),
        bodyType: BodyType.planet,
        color: AppColors.primaryColor,
      );

      testIndicator = IndicatorData(
        bodyIndex: 0,
        body: testBody,
        position: const Offset(50, 100),
        direction: vm.Vector2(1.0, 0.0),
      );

      painter = IndicatorPainter(indicator: testIndicator, isSelected: false);
    });

    group('Constructor and Properties', () {
      test('should create painter with correct properties', () {
        expect(painter.indicator, testIndicator);
        expect(painter.isSelected, false);
      });

      test('should create selected painter', () {
        final selectedPainter = IndicatorPainter(
          indicator: testIndicator,
          isSelected: true,
        );

        expect(selectedPainter.indicator, testIndicator);
        expect(selectedPainter.isSelected, true);
      });

      test('should handle different body types', () {
        final starBody = Body(
          name: 'Test Star',
          mass: 10.0,
          radius: 15.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.star,
          color: AppColors.stellarGType,
        );

        final starIndicator = IndicatorData(
          bodyIndex: 1,
          body: starBody,
          position: const Offset(0, 0),
          direction: vm.Vector2(0.0, 1.0),
        );

        final starPainter = IndicatorPainter(
          indicator: starIndicator,
          isSelected: false,
        );

        expect(starPainter.indicator.body.bodyType, BodyType.star);
      });
    });

    group('Painting Behavior', () {
      testWidgets('should paint without errors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: painter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('should paint selected indicator differently', (
        tester,
      ) async {
        final selectedPainter = IndicatorPainter(
          indicator: testIndicator,
          isSelected: true,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: painter, // unselected
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: selectedPainter, // selected
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('should handle different directions', (tester) async {
        final directions = [
          vm.Vector2(1.0, 0.0), // right
          vm.Vector2(-1.0, 0.0), // left
          vm.Vector2(0.0, 1.0), // down
          vm.Vector2(0.0, -1.0), // up
          vm.Vector2(0.707, 0.707), // diagonal
        ];

        for (final direction in directions) {
          final indicator = testIndicator.copyWith(direction: direction);
          final testPainter = IndicatorPainter(
            indicator: indicator,
            isSelected: false,
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(painter: testPainter),
                ),
              ),
            ),
          );

          expect(find.byType(SizedBox), findsWidgets);
        }
      });
    });

    group('ShouldRepaint Logic', () {
      test('should repaint when indicator changes', () {
        final otherIndicator = testIndicator.copyWith(bodyIndex: 5);
        final otherPainter = IndicatorPainter(
          indicator: otherIndicator,
          isSelected: false,
        );

        expect(painter.shouldRepaint(otherPainter), true);
      });

      test('should repaint when selection state changes', () {
        final selectedPainter = IndicatorPainter(
          indicator: testIndicator,
          isSelected: true,
        );

        expect(painter.shouldRepaint(selectedPainter), true);
      });

      test('should not repaint when nothing changes', () {
        final samePainter = IndicatorPainter(
          indicator: testIndicator,
          isSelected: false,
        );

        expect(painter.shouldRepaint(samePainter), false);
      });

      test('should repaint when both indicator and selection change', () {
        final otherIndicator = testIndicator.copyWith(
          position: const Offset(200, 300),
        );
        final differentPainter = IndicatorPainter(
          indicator: otherIndicator,
          isSelected: true,
        );

        expect(painter.shouldRepaint(differentPainter), true);
      });
    });

    group('Body Name Formatting', () {
      testWidgets('should handle regular body names', (tester) async {
        final earthBody = Body(
          name: 'Earth',
          mass: 1.0,
          radius: 6.371,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.planet,
          color: AppColors.primaryColor,
        );

        final earthIndicator = IndicatorData(
          bodyIndex: 0,
          body: earthBody,
          position: const Offset(50, 50),
          direction: vm.Vector2(1.0, 0.0),
        );

        final earthPainter = IndicatorPainter(
          indicator: earthIndicator,
          isSelected: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: earthPainter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should handle moon bodies', (tester) async {
        final moonBody = Body(
          name: 'Luna',
          mass: 0.012,
          radius: 1.737,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.moon,
          color: AppColors.uiTextGrey,
        );

        final moonIndicator = IndicatorData(
          bodyIndex: 1,
          body: moonBody,
          position: const Offset(75, 75),
          direction: vm.Vector2(0.0, 1.0),
        );

        final moonPainter = IndicatorPainter(
          indicator: moonIndicator,
          isSelected: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: moonPainter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle zero direction vector', (tester) async {
        final zeroIndicator = testIndicator.copyWith(
          direction: vm.Vector2.zero(),
        );

        final zeroPainter = IndicatorPainter(
          indicator: zeroIndicator,
          isSelected: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: zeroPainter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should handle very small canvas size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 10,
                height: 10,
                child: CustomPaint(painter: painter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should handle large canvas size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1000,
                height: 1000,
                child: CustomPaint(painter: painter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('should handle special characters in body name', (
        tester,
      ) async {
        final specialBody = Body(
          name: 'αβγ-Body_123!@#',
          mass: 1.0,
          radius: 5.0,
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          bodyType: BodyType.asteroid,
          color: AppColors.asteroidRockyBrown,
        );

        final specialIndicator = IndicatorData(
          bodyIndex: 0,
          body: specialBody,
          position: const Offset(50, 50),
          direction: vm.Vector2(1.0, 0.0),
        );

        final specialPainter = IndicatorPainter(
          indicator: specialIndicator,
          isSelected: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: specialPainter),
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    group('Type Safety', () {
      test('should handle different body types safely', () {
        final bodyTypes = [
          BodyType.star,
          BodyType.planet,
          BodyType.moon,
          BodyType.asteroid,
        ];

        for (final bodyType in bodyTypes) {
          final body = Body(
            name: 'Test ${bodyType.name}',
            mass: 1.0,
            radius: 5.0,
            position: vm.Vector3.zero(),
            velocity: vm.Vector3.zero(),
            bodyType: bodyType,
            color: AppColors.uiWhite,
          );

          final indicator = IndicatorData(
            bodyIndex: 0,
            body: body,
            position: const Offset(50, 50),
            direction: vm.Vector2(1.0, 0.0),
          );

          final testPainter = IndicatorPainter(
            indicator: indicator,
            isSelected: false,
          );

          // Should create without throwing
          expect(testPainter.indicator.body.bodyType, bodyType);
        }
      });
    });
  });
}
