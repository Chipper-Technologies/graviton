import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/body_properties_dialog.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

void main() {
  group('BodyPropertiesDialog Tests', () {
    late Body testBody;

    setUp(() {
      testBody = Body(
        position: vm.Vector3.zero(),
        velocity: vm.Vector3(1.0, 2.0, 3.0),
        mass: 100.0,
        radius: 5.0,
        color: AppColors.basicBlue,
        name: 'Test Body',
        bodyType: BodyType.planet,
        stellarLuminosity: 0.0,
      );
    });

    testWidgets('should display dialog with all body properties', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {
                // Body changed callback
              },
            ),
          ),
        ),
      );

      // Verify dialog is displayed
      expect(find.text('Body Properties'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Mass'), findsOneWidget);
      expect(find.text('Radius'), findsOneWidget);
      expect(find.text('Body Type'), findsOneWidget);
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Velocity'), findsOneWidget);

      // Verify body name is displayed
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('should show stellar luminosity for star type', (tester) async {
      testBody.bodyType = BodyType.star;
      testBody.stellarLuminosity = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Pump again to handle the conditional rendering
      await tester.pump();

      // Verify stellar luminosity is shown for stars
      expect(find.text('Stellar Luminosity'), findsOneWidget);
    });

    testWidgets('should hide stellar luminosity for non-star types', (
      tester,
    ) async {
      testBody.bodyType = BodyType.planet;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Verify stellar luminosity is not shown for planets
      expect(find.text('Stellar Luminosity'), findsNothing);
    });

    testWidgets('should close dialog when close button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => BodyPropertiesDialog(
                      body: testBody,
                      bodyIndex: 0,
                      onBodyChanged: (body) {},
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog is open
      expect(find.text('Body Properties'), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('Body Properties'), findsNothing);
    });

    testWidgets('should update name when text field is changed', (
      tester,
    ) async {
      bool bodyChanged = false;
      Body? updatedBody;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {
                bodyChanged = true;
                updatedBody = body;
              },
            ),
          ),
        ),
      );

      // Find and tap the name text field
      final nameField = find.byType(TextField);
      expect(nameField, findsOneWidget);

      // Clear and enter new name
      await tester.enterText(nameField, 'New Test Body');
      await tester.pump();

      // Verify callback was called
      expect(bodyChanged, isTrue);
      expect(updatedBody?.name, equals('New Test Body'));
    });

    testWidgets('should display mass slider with correct value', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Find sliders
      final sliders = find.byType(Slider);
      expect(sliders, findsWidgets);

      // Verify mass value is displayed
      expect(find.text('100.0'), findsOneWidget);
    });

    testWidgets('should display radius slider with correct value', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Verify radius value is displayed
      expect(find.text('5.0'), findsOneWidget);
    });

    testWidgets('should display velocity controls for X, Y, Z', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Verify velocity labels
      expect(find.text('X:'), findsOneWidget);
      expect(find.text('Y:'), findsOneWidget);
      expect(find.text('Z:'), findsOneWidget);

      // Verify velocity values
      expect(find.text('1.0'), findsOneWidget);
      expect(find.text('2.0'), findsOneWidget);
      expect(find.text('3.0'), findsOneWidget);
    });

    testWidgets('should display color picker with selectable colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Find color containers directly without scrolling
      final colorContainers = find.descendant(
        of: find.byType(Wrap),
        matching: find.byType(Container),
      );

      expect(colorContainers, findsWidgets);
    });

    testWidgets('should display body type dropdown with all options', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BodyPropertiesDialog(
              body: testBody,
              bodyIndex: 0,
              onBodyChanged: (body) {},
            ),
          ),
        ),
      );

      // Find dropdown
      final dropdown = find.byType(DropdownButtonFormField<BodyType>);
      expect(dropdown, findsOneWidget);

      // Tap dropdown to open
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Verify body types are available (allowing for duplicates)
      for (final type in BodyType.values) {
        expect(find.text(type.displayName), findsAtLeastNWidgets(1));
      }
    });
  });
}
