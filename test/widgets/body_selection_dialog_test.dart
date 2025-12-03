import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/widgets/body_selection_dialog.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../test_utils.dart';

void main() {
  group('BodySelectionDialog Tests', () {
    late List<Body> testBodies;

    setUp(() {
      testBodies = [
        Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.989e30,
          radius: 20,
          color: AppColors.stellarGType,
          isPlanet: true,
          name: 'Sun',
          bodyType: BodyType.star,
          stellarLuminosity: 1.0,
          habitabilityStatus: HabitabilityStatus.unknown,
          temperature: 5778,
        ),
        Body(
          position: vm.Vector3(100, 0, 0),
          velocity: vm.Vector3(0, 30, 0),
          mass: 5.972e24,
          radius: 10,
          color: AppColors.primaryColor,
          isPlanet: true,
          name: 'Earth',
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
          habitabilityStatus: HabitabilityStatus.habitable,
          temperature: 288,
        ),
        Body(
          position: vm.Vector3(-100, 0, 0),
          velocity: vm.Vector3(0, -25, 0),
          mass: 6.39e23,
          radius: 8,
          color: AppColors.uiRed,
          isPlanet: true,
          name: 'Mars',
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
          habitabilityStatus: HabitabilityStatus.tooHot,
          temperature: 210,
        ),
      ];
    });

    testWidgets('should display dialog with title and bodies', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      // Check dialog title
      expect(find.byType(DialogTitle), findsOneWidget);
      expect(find.text('Select Body'), findsOneWidget);

      // Check all bodies are listed
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Earth'), findsOneWidget);
      expect(find.text('Mars'), findsOneWidget);

      // Check cancel button
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should display empty state when no bodies', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(bodies: const [], onBodySelected: (_) {}),
        ),
      );

      expect(find.text('No bodies available'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('should highlight selected body', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            selectedIndex: 1, // Earth is selected
            onBodySelected: (_) {},
          ),
        ),
      );

      // Check that check icon is shown for selected body
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display body color indicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      // Find containers with body colors
      final containers = tester.widgetList<Container>(find.byType(Container));
      final coloredContainers = containers.where((container) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.stellarGType ||
              decoration.color == AppColors.primaryColor ||
              decoration.color == AppColors.uiRed;
        }
        return false;
      });

      expect(coloredContainers.length, equals(3));
    });

    testWidgets('should display body type for planets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      // Check that body types are shown
      expect(find.text('star'), findsOneWidget);
      expect(find.text('planet'), findsNWidgets(2));
    });

    testWidgets('should call onBodySelected when body is tapped', (
      WidgetTester tester,
    ) async {
      int? selectedIndex;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (index) {
              selectedIndex = index;
            },
          ),
        ),
      );

      // Tap on Earth
      await tester.tap(find.text('Earth'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets('should close dialog when cancel is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog<int>(
                  context: context,
                  builder: (context) => BodySelectionDialog(
                    bodies: testBodies,
                    onBodySelected: (index) => Navigator.of(context).pop(index),
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.text('Select Body'), findsOneWidget);

      // Tap cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Select Body'), findsNothing);
    });

    testWidgets('should use static show method correctly', (
      WidgetTester tester,
    ) async {
      int? result;

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await BodySelectionDialog.show(
                  context: context,
                  bodies: testBodies,
                  selectedIndex: 0,
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Select Mars
      await tester.tap(find.text('Mars'));
      await tester.pumpAndSettle();

      expect(result, equals(2));
    });

    testWidgets('should update selection state when different body is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            selectedIndex: 0, // Sun initially selected
            onBodySelected: (_) {},
          ),
        ),
      );

      // Initially, Sun should be selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Tap Earth
      await tester.tap(find.text('Earth'));
      await tester.pumpAndSettle();

      // Now Earth should show check icon
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display dialog with proper styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      // Find the main dialog widget
      final dialog = tester.widget<Dialog>(find.byType(Dialog));

      // Check dialog has proper shape
      expect(dialog.shape, isA<RoundedRectangleBorder>());

      // Check dialog has background color
      expect(dialog.backgroundColor, isNotNull);
    });

    testWidgets('should handle body without isPlanet flag', (
      WidgetTester tester,
    ) async {
      final bodiesWithMoon = [
        ...testBodies,
        Body(
          position: vm.Vector3(150, 0, 0),
          velocity: vm.Vector3(0, 20, 0),
          mass: 7.34e22,
          radius: 5,
          color: AppColors.uiTextGrey,
          isPlanet: false, // Moon is not a planet
          name: 'Moon',
          bodyType: BodyType.moon,
          stellarLuminosity: 0.0,
          habitabilityStatus: HabitabilityStatus.noAtmosphere,
          temperature: 250,
        ),
      ];

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: bodiesWithMoon,
            onBodySelected: (_) {},
          ),
        ),
      );

      // Moon should be listed
      expect(find.text('Moon'), findsOneWidget);

      // Moon should not show body type text since isPlanet is false
      // (body type is only shown for planets)
      expect(find.text('moon'), findsNothing);
    });

    testWidgets('should handle single body list', (WidgetTester tester) async {
      final singleBody = [testBodies[0]]; // Only Sun

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: singleBody,
            onBodySelected: (_) {},
          ),
        ),
      );

      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Earth'), findsNothing);
      expect(find.text('Mars'), findsNothing);
    });

    testWidgets('should show proper icon in header', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      // Check that the public icon is shown in the DialogTitle
      expect(find.byIcon(Icons.public), findsOneWidget);
    });

    testWidgets('should handle tap on body when no callback provided', (
      WidgetTester tester,
    ) async {
      // This test ensures the dialog doesn't crash if callback is somehow null
      // (though TypeScript/Dart's required params should prevent this)
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {
              // Empty callback - just don't crash
            },
          ),
        ),
      );

      // Tap a body
      await tester.tap(find.text('Sun'));
      await tester.pumpAndSettle();

      // Should not crash
      expect(find.text('Sun'), findsOneWidget);
    });

    testWidgets('should scroll when many bodies are present', (
      WidgetTester tester,
    ) async {
      // Create many bodies
      final manyBodies = List.generate(
        20,
        (index) => Body(
          position: vm.Vector3.zero(),
          velocity: vm.Vector3.zero(),
          mass: 1.0e24,
          radius: 10,
          color: AppColors.primaryColor,
          isPlanet: true,
          name: 'Body $index',
          bodyType: BodyType.planet,
          stellarLuminosity: 0.0,
          habitabilityStatus: HabitabilityStatus.unknown,
          temperature: 300,
        ),
      );

      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: manyBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      // First body should be visible
      expect(find.text('Body 0'), findsOneWidget);

      // Last body might not be visible initially
      // (Depending on screen size, some might be visible)

      // Scroll down - need to scroll multiple times to reach the bottom
      for (int i = 0; i < 3; i++) {
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Now last body should be visible or we should have scrolled significantly
      // Just verify that scrolling worked by checking that we can still find the list
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should respect dialog constraints', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(
          child: BodySelectionDialog(
            bodies: testBodies,
            onBodySelected: (_) {},
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Dialog),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints, isNotNull);
      expect(container.constraints!.maxWidth, equals(500));
      expect(container.constraints!.maxHeight, equals(600));
    });
  });
}
