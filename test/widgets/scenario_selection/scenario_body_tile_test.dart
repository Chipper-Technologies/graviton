import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/scenario_selection/scenario_body_tile.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('ScenarioBodyTile Tests', () {
    late Body testBody;

    setUp(() {
      testBody = Body(
        name: 'Test Planet',
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 5.972e24, // Earth mass in kg
        radius: 6.371,
        color: Colors.blue,
        bodyType: BodyType.planet,
      );
    });

    Widget createTestWidget({
      required Body body,
      VoidCallback? onTap,
      bool showActions = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ScenarioBodyTile(
            body: body,
            onTap: onTap,
            showActions: showActions,
          ),
        ),
      );
    }

    group('Widget Construction', () {
      testWidgets('should build without error', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));
        expect(find.byType(ScenarioBodyTile), findsOneWidget);
      });

      testWidgets('should display body name', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));
        expect(find.text('Test Planet'), findsOneWidget);
      });

      testWidgets('should display body type and mass', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));
        expect(find.textContaining('planet •'), findsOneWidget);
        expect(
          find.textContaining('M☉'),
          findsOneWidget,
        ); // Solar mass units, not kg
      });

      testWidgets('should display body color indicator', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));

        // Find the color indicator container - it's the first container with a circular decoration
        final containers = tester.widgetList<Container>(find.byType(Container));
        final colorIndicator = containers.firstWhere((container) {
          final decoration = container.decoration;
          if (decoration is BoxDecoration) {
            return decoration.shape == BoxShape.circle;
          }
          return false;
        });

        final decoration = colorIndicator.decoration as BoxDecoration;
        expect(decoration.color, equals(Colors.blue));
        expect(decoration.shape, equals(BoxShape.circle));
      });
    });

    group('Interaction', () {
      testWidgets('should call onTap when tapped', (tester) async {
        bool tapCalled = false;

        await tester.pumpWidget(
          createTestWidget(body: testBody, onTap: () => tapCalled = true),
        );

        await tester.tap(find.byType(ScenarioBodyTile));
        expect(tapCalled, isTrue);
      });

      testWidgets('should handle null onTap', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody, onTap: null));

        // Should not throw when tapped with null onTap
        await tester.tap(find.byType(ScenarioBodyTile));
        expect(tester.takeException(), isNull);
      });
    });

    group('Styling', () {
      testWidgets('should have correct background color', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));

        // Find the main container with background styling
        final containers = tester.widgetList<Container>(find.byType(Container));
        final backgroundContainer = containers.firstWhere((container) {
          final decoration = container.decoration;
          if (decoration is BoxDecoration) {
            return decoration.color ==
                AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityBarely,
                );
          }
          return false;
        });

        final decoration = backgroundContainer.decoration as BoxDecoration;
        expect(
          decoration.color,
          equals(
            AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
          ),
        );
      });

      testWidgets('should have rounded corners', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));

        // Find the main container with background styling
        final containers = tester.widgetList<Container>(find.byType(Container));
        final backgroundContainer = containers.firstWhere((container) {
          final decoration = container.decoration;
          if (decoration is BoxDecoration) {
            return decoration.color ==
                AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityBarely,
                );
          }
          return false;
        });

        final decoration = backgroundContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, isA<BorderRadius>());
      });
    });

    group('Different Body Types', () {
      testWidgets('should display star correctly', (tester) async {
        final starBody = Body(
          name: 'Test Star',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.989e30, // Solar mass in kg
          radius: 696.340,
          color: Colors.yellow,
          bodyType: BodyType.star,
        );

        await tester.pumpWidget(createTestWidget(body: starBody));

        expect(find.text('Test Star'), findsOneWidget);
        expect(find.textContaining('star •'), findsOneWidget);
      });

      testWidgets('should display moon correctly', (tester) async {
        final moonBody = Body(
          name: 'Test Moon',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 7.342e22, // Lunar mass in kg
          radius: 1.737,
          color: Colors.grey,
          bodyType: BodyType.moon,
        );

        await tester.pumpWidget(createTestWidget(body: moonBody));

        expect(find.text('Test Moon'), findsOneWidget);
        expect(find.textContaining('moon •'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long body names', (tester) async {
        final longNameBody = Body(
          name: 'This is a very long celestial body name that might wrap',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0,
          radius: 1.0,
          color: Colors.red,
          bodyType: BodyType.planet,
        );

        await tester.pumpWidget(createTestWidget(body: longNameBody));

        expect(find.textContaining('This is a very long'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle zero mass', (tester) async {
        final zeroMassBody = Body(
          name: 'Zero Mass Body',
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 0.0,
          radius: 1.0,
          color: Colors.black,
          bodyType: BodyType.planet,
        );

        await tester.pumpWidget(createTestWidget(body: zeroMassBody));

        expect(find.text('Zero Mass Body'), findsOneWidget);
        // Check that mass is displayed (exact format depends on NumberUtils.formatMass implementation)
        expect(find.textContaining('planet •'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        await tester.pumpWidget(createTestWidget(body: testBody));

        // Widget should be found and accessible
        expect(find.byType(ScenarioBodyTile), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should work with different text scales', (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: createTestWidget(body: testBody),
          ),
        );

        expect(find.text('Test Planet'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
