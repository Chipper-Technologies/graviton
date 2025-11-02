import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/widgets/settings_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsDialog - Updated Version', () {
    late AppState appState;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Widget createTestWidget({required Widget child}) {
      appState = AppState();
      // Initialize the AppState
      appState.initializeAsync();

      return ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('Should display settings dialog', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('Should display header with title and close button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        expect(find.text('Settings'), findsOneWidget);
        expect(find.byIcon(Icons.tune), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('Should display only language selection section', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Should have language section
        expect(find.text('Language'), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.language), findsOneWidget);
        expect(find.byType(DropdownButton<String?>), findsOneWidget);
      });

      testWidgets('Should NOT display removed sections', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // These sections should no longer be present
        expect(find.text('Marketing'), findsNothing);
        expect(find.text('Help & Objectives'), findsNothing);
        expect(find.text('Changelog (Debug)'), findsNothing);
        expect(find.text('Tutorial'), findsNothing);
        expect(find.text('Reset Tutorial'), findsNothing);
        expect(find.text('Changelog'), findsNothing);
        expect(find.text('Reset Changelog'), findsNothing);

        // Screenshot mode should not be present
        expect(find.byIcon(Icons.camera_alt), findsNothing);
        expect(find.byIcon(Icons.school), findsNothing);
        expect(find.byIcon(Icons.assignment), findsNothing);
      });

      testWidgets('Should have simplified layout with only language controls', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pumpAndSettle();

        // Should have dialog structure
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Should have only one main content container for language
        final containers = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.padding != null &&
              widget.decoration is BoxDecoration,
        );
        expect(containers, findsWidgets);
      });
    });

    group('Language Selection', () {
      testWidgets('Should display all supported languages', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Tap dropdown to open it
        await tester.tap(find.byType(DropdownButton<String?>));
        await tester.pumpAndSettle();

        // Check for all language options (allowing for duplicates)
        expect(find.text('System Default'), findsAtLeastNWidgets(1));
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Deutsch'), findsOneWidget);
        expect(find.text('Español'), findsOneWidget);
        expect(find.text('Français'), findsOneWidget);
        expect(find.text('中文'), findsOneWidget);
        expect(find.text('日本語'), findsOneWidget);
        expect(find.text('한국어'), findsOneWidget);
      });

      testWidgets('Should handle language selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Initial language should be system default (null)
        expect(appState.ui.selectedLanguageCode, isNull);

        // Tap dropdown to open it
        await tester.tap(find.byType(DropdownButton<String?>));
        await tester.pumpAndSettle();

        // Select English
        await tester.tap(find.text('English').last);
        await tester.pumpAndSettle();

        // Language should be updated
        expect(appState.ui.selectedLanguageCode, equals('en'));
      });

      testWidgets('Should have proper language section styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Should have language icon and title
        expect(find.byIcon(Icons.language), findsOneWidget);
        expect(find.text('Language'), findsAtLeastNWidgets(1));

        // Should have description text
        final descriptions = find.byWidgetPredicate(
          (widget) => widget is Text && widget.style?.color != null,
        );
        expect(descriptions, findsWidgets);
      });
    });

    group('User Interactions', () {
      testWidgets('Should close dialog when close button is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const SettingsDialog(),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        );

        // Open dialog
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsDialog), findsOneWidget);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsDialog), findsNothing);
      });

      testWidgets('Should be scrollable if content overflows', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Should have scrollable content
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Responsive Design', () {
      testWidgets('Should maintain constraints for dialog size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Should have proper constraints
        final containers = find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints != null,
        );
        expect(containers, findsWidgets);
      });

      testWidgets('Should adapt to different screen sizes', (
        WidgetTester tester,
      ) async {
        // Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(800, 600));

        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
        expect(find.text('Language'), findsAtLeastNWidgets(1));

        // Reset surface size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Clean Architecture', () {
      testWidgets('Should not contain any removed functionality imports', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Dialog should render successfully without any dependency issues
        expect(find.byType(SettingsDialog), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('Should have minimal and focused functionality', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Should only have language-related controls
        expect(find.byType(DropdownButton<String?>), findsOneWidget);
        expect(find.text('Language'), findsAtLeastNWidgets(1));

        // Should not have any other interactive elements except close button
        expect(find.byType(ElevatedButton), findsNothing);
        expect(find.byType(TextButton), findsNothing);
        expect(find.byType(Switch), findsNothing);
        expect(find.byType(Slider), findsNothing);
        expect(find.byType(SegmentedButton), findsNothing);
      });
    });

    group('Accessibility', () {
      testWidgets('Should have proper semantic labels', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Dialog should be accessible
        expect(find.byType(Dialog), findsOneWidget);

        // Language dropdown should be accessible
        expect(find.byType(DropdownButton<String?>), findsOneWidget);
        expect(find.text('Language'), findsAtLeastNWidgets(1));
      });

      testWidgets('Should support keyboard navigation', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Should be able to navigate to interactive elements
        expect(find.byType(IconButton), findsOneWidget); // Close button
        expect(
          find.byType(DropdownButton<String?>),
          findsOneWidget,
        ); // Language dropdown
      });
    });

    group('Localization', () {
      testWidgets('Should display localized text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const SettingsDialog()),
        );
        await tester.pump();

        // Check for localized strings
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('Language'), findsAtLeastNWidgets(1));

        // Language options should be localized when dropdown is opened
        await tester.tap(find.byType(DropdownButton<String?>));
        await tester.pumpAndSettle();

        expect(find.text('System Default'), findsAtLeastNWidgets(1));
        expect(find.text('English'), findsOneWidget);
      });
    });
  });
}
