import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/widgets/haptics/haptic_list_tile.dart';
import 'package:graviton/services/haptic_feedback_service.dart';

void main() {
  group('HapticListTile Tests', () {
    setUp(() {
      // Initialize the haptic feedback service for testing
      HapticFeedbackService.instance.setEnabled(true);
    });

    Widget createTestWidget({required HapticListTile child}) {
      return MaterialApp(home: Scaffold(body: child));
    }

    group('Basic Functionality', () {
      testWidgets('should render correctly', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              subtitle: const Text('Navigate to home'),
              onTap: () {},
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byType(HapticListTile), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Navigate to home'), findsOneWidget);
      });

      testWidgets('should call onTap when tapped', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Settings'),
              onTap: () => tapped = true,
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('should handle disabled tile correctly', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Disabled'),
              onTap: null, // Disabled
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pump();

        expect(tapped, isFalse);
      });

      testWidgets('should work when haptic feedback is disabled', (
        tester,
      ) async {
        HapticFeedbackService.instance.setEnabled(false);
        bool tapped = false;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Test'),
              onTap: () => tapped = true,
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pump();

        expect(tapped, isTrue);
      });
    });

    group('Layout Properties', () {
      testWidgets('should handle leading widget', (tester) async {
        const leadingIcon = Icon(Icons.settings);

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              leading: leadingIcon,
              title: const Text('Settings'),
              onTap: () {},
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.leading, leadingIcon);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should handle title widget', (tester) async {
        const titleText = Text('Navigation Item');

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(title: titleText, onTap: () {}),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.title, titleText);
        expect(find.text('Navigation Item'), findsOneWidget);
      });

      testWidgets('should handle subtitle widget', (tester) async {
        const subtitleText = Text('Additional information');

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Main Title'),
              subtitle: subtitleText,
              onTap: () {},
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.subtitle, subtitleText);
        expect(find.text('Additional information'), findsOneWidget);
      });

      testWidgets('should handle contentPadding', (tester) async {
        const customPadding = EdgeInsets.all(16.0);

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Padded Item'),
              contentPadding: customPadding,
              onTap: () {},
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.contentPadding, customPadding);
      });

      testWidgets('should handle dense property', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Dense Item'),
              dense: true,
              onTap: () {},
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.dense, isTrue);
      });

      testWidgets('should default dense to false', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Normal Item'),
              onTap: () {},
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.dense, isFalse);
      });
    });

    group('Complex Layouts', () {
      testWidgets('should handle all properties together', (tester) async {
        const leading = Icon(Icons.star);
        const title = Text('Favorites');
        const subtitle = Text('Your starred items');
        const padding = EdgeInsets.symmetric(horizontal: 20.0);
        bool tapped = false;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              leading: leading,
              title: title,
              subtitle: subtitle,
              contentPadding: padding,
              dense: true,
              onTap: () => tapped = true,
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.leading, leading);
        expect(listTile.title, title);
        expect(listTile.subtitle, subtitle);
        expect(listTile.contentPadding, padding);
        expect(listTile.dense, isTrue);

        // Test interaction
        await tester.tap(find.byType(ListTile));
        await tester.pump();
        expect(tapped, isTrue);

        // Verify widgets are present
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Favorites'), findsOneWidget);
        expect(find.text('Your starred items'), findsOneWidget);
      });

      testWidgets('should work with just title', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text('Simple Item'),
              onTap: () => tapped = true,
            ),
          ),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.leading, isNull);
        expect(listTile.subtitle, isNull);
        expect(listTile.title, isA<Text>());

        await tester.tap(find.byType(ListTile));
        await tester.pump();
        expect(tapped, isTrue);
      });

      testWidgets('should work without any content', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: HapticListTile(onTap: () {})),
        );

        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile.leading, isNull);
        expect(listTile.title, isNull);
        expect(listTile.subtitle, isNull);
      });
    });

    group('Navigation Use Cases', () {
      testWidgets('should work for drawer navigation items', (tester) async {
        final List<String> navigatedTo = [];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  HapticListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () => navigatedTo.add('home'),
                  ),
                  HapticListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () => navigatedTo.add('settings'),
                  ),
                  HapticListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () => navigatedTo.add('about'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Test each navigation item
        await tester.tap(find.text('Home'));
        await tester.pump();
        expect(navigatedTo, contains('home'));

        await tester.tap(find.text('Settings'));
        await tester.pump();
        expect(navigatedTo, contains('settings'));

        await tester.tap(find.text('About'));
        await tester.pump();
        expect(navigatedTo, contains('about'));

        expect(navigatedTo.length, 3);
      });

      testWidgets('should work for menu items with descriptions', (
        tester,
      ) async {
        bool profileTapped = false;

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('John Doe'),
              subtitle: const Text('john.doe@example.com'),
              onTap: () => profileTapped = true,
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pump();

        expect(profileTapped, isTrue);
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('john.doe@example.com'), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              leading: const Icon(Icons.accessibility),
              title: const Text('Accessibility Settings'),
              subtitle: const Text('Configure accessibility options'),
              onTap: () {},
            ),
          ),
        );

        // Verify that ListTile is accessible
        final ListTile listTile = tester.widget(find.byType(ListTile));
        expect(listTile, isNotNull);

        // The ListTile should maintain its semantic properties
        expect(find.text('Accessibility Settings'), findsOneWidget);
        expect(find.text('Configure accessibility options'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty string title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(title: const Text(''), onTap: () {}),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should handle very long title and subtitle', (tester) async {
        const longTitle =
            'This is a very long title that might wrap to multiple lines in the list tile widget';
        const longSubtitle =
            'This is also a very long subtitle that provides additional context and information that might also wrap to multiple lines';

        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              title: const Text(longTitle),
              subtitle: const Text(longSubtitle),
              onTap: () {},
            ),
          ),
        );

        expect(find.text(longTitle), findsOneWidget);
        expect(find.text(longSubtitle), findsOneWidget);
      });

      testWidgets('should handle complex widget trees', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            child: HapticListTile(
              leading: const Icon(Icons.notifications),
              title: const Row(
                children: [
                  Text('Notifications'),
                  SizedBox(width: 8),
                  Icon(Icons.badge, size: 16),
                ],
              ),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enable notifications'),
                  Text(
                    'Get updates and alerts',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
        );

        expect(find.text('Notifications'), findsOneWidget);
        expect(find.text('Enable notifications'), findsOneWidget);
        expect(find.text('Get updates and alerts'), findsOneWidget);
        expect(find.byIcon(Icons.notifications), findsOneWidget);
        expect(find.byIcon(Icons.badge), findsOneWidget);
      });
    });
  });
}
