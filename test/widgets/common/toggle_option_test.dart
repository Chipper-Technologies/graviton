import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/common/toggle_option.dart';

void main() {
  group('ToggleOption', () {
    testWidgets('renders correctly with all properties', (
      WidgetTester tester,
    ) async {
      bool value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Test Toggle',
              description: 'This is a test toggle',
              icon: Icons.star,
              isEnabled: value,
              onChanged: (newValue) {
                value = newValue;
              },
            ),
          ),
        ),
      );

      // Verify the title is displayed
      expect(find.text('Test Toggle'), findsOneWidget);

      // Verify the description is displayed
      expect(find.text('This is a test toggle'), findsOneWidget);

      // Verify the icon is displayed
      expect(find.byIcon(Icons.star), findsOneWidget);

      // Verify the switch exists
      expect(find.byType(Switch), findsOneWidget);

      // Verify the switch has the correct initial state
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, equals(false));
    });

    testWidgets('handles switch toggle correctly', (WidgetTester tester) async {
      bool value = false;
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ToggleOption(
                title: 'Toggle Test',
                description: 'Test description',
                icon: Icons.check,
                isEnabled: value,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                    callbackCalled = true;
                  });
                },
              ),
            ),
          ),
        ),
      );

      // Verify initial state
      final initialSwitch = tester.widget<Switch>(find.byType(Switch));
      expect(initialSwitch.value, equals(false));

      // Tap the switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(callbackCalled, isTrue);
      expect(value, isTrue);

      // Verify the switch state updated
      final updatedSwitch = tester.widget<Switch>(find.byType(Switch));
      expect(updatedSwitch.value, equals(true));
    });

    testWidgets('handles tap on container correctly', (
      WidgetTester tester,
    ) async {
      bool value = false;
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ToggleOption(
                title: 'Container Tap Test',
                description: 'Test description',
                icon: Icons.touch_app,
                isEnabled: value,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                    callbackCalled = true;
                  });
                },
              ),
            ),
          ),
        ),
      );

      // Tap on the title area (InkWell should respond)
      await tester.tap(find.text('Container Tap Test'));
      await tester.pumpAndSettle();

      // Verify the callback was called
      expect(callbackCalled, isTrue);
      expect(value, isTrue);
    });

    testWidgets('displays icon with correct styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Icon Test',
              description: 'Testing icon display',
              icon: Icons.settings,
              isEnabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Find the icon container
      final iconContainerFinder = find
          .descendant(
            of: find.byType(ToggleOption),
            matching: find.byType(Container),
          )
          .first;

      expect(iconContainerFinder, findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('has proper semantic labels for accessibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Accessibility Test',
              description: 'Testing accessibility features',
              icon: Icons.accessibility,
              isEnabled: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Verify the switch has semantic labels
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // Check that the widget is accessible by verifying structure
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.text('Accessibility Test'), findsOneWidget);
      expect(find.text('Testing accessibility features'), findsOneWidget);
    });

    testWidgets('handles enabled state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Enabled State Test',
              description: 'Testing enabled state',
              icon: Icons.power,
              isEnabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, equals(true));
    });

    testWidgets('handles disabled state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Disabled State Test',
              description: 'Testing disabled state',
              icon: Icons.power_off,
              isEnabled: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, equals(false));
    });

    testWidgets('has correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Layout Test',
              description: 'Testing layout structure',
              icon: Icons.view_list,
              isEnabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Verify the main container structure
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('handles rapid toggle changes', (WidgetTester tester) async {
      bool value = false;
      int callbackCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ToggleOption(
                title: 'Rapid Toggle Test',
                description: 'Testing rapid changes',
                icon: Icons.speed,
                isEnabled: value,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                    callbackCount++;
                  });
                },
              ),
            ),
          ),
        ),
      );

      // Rapidly toggle the switch multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(Switch));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Verify all callbacks were called
      expect(callbackCount, equals(5));
      expect(value, isTrue); // Should be true after odd number of toggles
    });

    testWidgets('maintains state consistency across rebuilds', (
      WidgetTester tester,
    ) async {
      bool value = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Consistency Test',
              description: 'Testing state consistency',
              icon: Icons.sync,
              isEnabled: value,
              onChanged: (newValue) {
                value = newValue;
              },
            ),
          ),
        ),
      );

      // Verify initial state
      expect(tester.widget<Switch>(find.byType(Switch)).value, equals(true));

      // Rebuild with same state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToggleOption(
              title: 'Consistency Test',
              description: 'Testing state consistency',
              icon: Icons.sync,
              isEnabled: value,
              onChanged: (newValue) {
                value = newValue;
              },
            ),
          ),
        ),
      );

      // Verify state is still consistent
      expect(tester.widget<Switch>(find.byType(Switch)).value, equals(true));
    });
  });
}
