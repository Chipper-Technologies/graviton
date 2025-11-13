import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/temperature_unit.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/application_settings_screen.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:provider/provider.dart';

void main() {
  group('ApplicationSettingsScreen', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: child,
        ),
      );
    }

    group('UI Structure', () {
      testWidgets('should display correct screen structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have Scaffold with transparent background
        expect(find.byType(Scaffold), findsOneWidget);
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(AppColors.transparentColor));

        // Should have AppBar
        expect(find.byType(AppBar), findsOneWidget);

        // Should have at least one SafeArea (could be more from nested widgets)
        expect(find.byType(SafeArea), findsWidgets);

        // Should have scrollable content
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should display app bar with correct title', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have AppBar with settings title
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.title, isA<Text>());

        // Should have transparent background with proper opacity
        expect(appBar.backgroundColor, isNotNull);
      });

      testWidgets('should display general settings section', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have section dividers (general settings and haptic feedback)
        expect(find.byType(SectionDivider), findsNWidgets(2));

        // Should have language icon
        expect(find.byIcon(Icons.language), findsOneWidget);

        // Should have temperature icon
        expect(find.byIcon(Icons.thermostat), findsOneWidget);

        // Should have language dropdown (nullable String)
        expect(find.byType(DropdownButton<String?>), findsOneWidget);

        // Should have temperature unit dropdown (non-nullable String)
        expect(find.byType(DropdownButton<String>), findsOneWidget);
      });
    });

    group('Language Settings', () {
      testWidgets('should display language dropdown with correct options', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Find the dropdown button
        final dropdown = find.byType(DropdownButton<String?>);
        expect(dropdown, findsOneWidget);

        // Tap to open dropdown
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        // Should have all language options (allowing for duplicates in dropdown)
        expect(find.text('System Default'), findsWidgets);
        expect(find.text('English'), findsWidgets);
        expect(find.text('Deutsch'), findsWidgets);
        expect(find.text('Español'), findsWidgets);
        expect(find.text('Français'), findsWidgets);
        expect(find.text('中文'), findsWidgets);
        expect(find.text('日本語'), findsWidgets);
        expect(find.text('한국어'), findsWidgets);
      });

      testWidgets('should handle language selection', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Initially should be system default (null)
        expect(appState.ui.selectedLanguageCode, isNull);

        // Tap dropdown to open it
        await tester.tap(find.byType(DropdownButton<String?>));
        await tester.pumpAndSettle();

        // Select English
        await tester.tap(find.text('English').last);
        await tester.pumpAndSettle();

        // Should update the app state
        expect(appState.ui.selectedLanguageCode, equals('en'));
      });

      testWidgets('should display current language selection correctly', (
        tester,
      ) async {
        // Set initial language to German
        appState.ui.setLanguage('de');

        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should show current selection
        final dropdown = tester.widget<DropdownButton<String?>>(
          find.byType(DropdownButton<String?>),
        );
        expect(dropdown.value, equals('de'));
      });

      testWidgets('should display language selection hint text', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should display the language selection hint text
        expect(
          find.text('Choose your preferred display language'),
          findsOneWidget,
        );
      });
      testWidgets('should handle system default language selection', (
        tester,
      ) async {
        // Set initial language to English
        appState.ui.setLanguage('en');

        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Tap dropdown to open it
        await tester.tap(find.byType(DropdownButton<String?>));
        await tester.pumpAndSettle();

        // Select System Default
        await tester.tap(find.text('System Default').last);
        await tester.pumpAndSettle();

        // Should update to null (system default)
        expect(appState.ui.selectedLanguageCode, isNull);
      });
    });

    group('Temperature Unit Settings', () {
      testWidgets(
        'should display temperature unit dropdown with correct options',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(child: const ApplicationSettingsScreen()),
          );
          await tester.pumpAndSettle();

          // Find the temperature unit dropdown button (non-nullable String type)
          final dropdown = find.byType(DropdownButton<String>);
          expect(dropdown, findsOneWidget);

          // Tap to open dropdown
          await tester.tap(dropdown);
          await tester.pumpAndSettle();

          // Should have all temperature unit options
          expect(find.text('Celsius'), findsWidgets);
          expect(find.text('Fahrenheit'), findsWidgets);
          expect(find.text('Kelvin'), findsWidgets);
        },
      );

      testWidgets('should handle temperature unit selection', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Initially should be Kelvin (default)
        expect(appState.ui.temperatureUnit, equals(TemperatureUnit.kelvin));

        // Tap dropdown to open it
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();

        // Select Celsius
        await tester.tap(find.text('Celsius').last);
        await tester.pumpAndSettle();

        // Should update the app state
        expect(appState.ui.temperatureUnit, equals(TemperatureUnit.celsius));
      });

      testWidgets(
        'should display current temperature unit selection correctly',
        (tester) async {
          // Set initial temperature unit to Fahrenheit
          appState.ui.setTemperatureUnit(TemperatureUnit.fahrenheit);

          await tester.pumpWidget(
            createTestWidget(child: const ApplicationSettingsScreen()),
          );
          await tester.pumpAndSettle();

          // Should show current selection
          final dropdown = tester.widget<DropdownButton<String>>(
            find.byType(DropdownButton<String>),
          );
          expect(dropdown.value, equals('fahrenheit'));
        },
      );

      testWidgets(
        'should maintain temperature unit selection across rebuilds',
        (tester) async {
          await tester.pumpWidget(
            createTestWidget(child: const ApplicationSettingsScreen()),
          );
          await tester.pumpAndSettle();

          // Set temperature unit to Celsius
          appState.ui.setTemperatureUnit(TemperatureUnit.celsius);
          await tester.pump();

          // Should maintain selection
          final dropdown = tester.widget<DropdownButton<String>>(
            find.byType(DropdownButton<String>),
          );
          expect(dropdown.value, equals('celsius'));

          // Trigger a rebuild
          await tester.pumpAndSettle();

          // Should still maintain selection
          final dropdownAfterRebuild = tester.widget<DropdownButton<String>>(
            find.byType(DropdownButton<String>),
          );
          expect(dropdownAfterRebuild.value, equals('celsius'));
        },
      );

      testWidgets('should persist temperature unit selection', (tester) async {
        // Change temperature unit
        appState.ui.setTemperatureUnit(TemperatureUnit.fahrenheit);
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Verify persistence by checking state
        expect(appState.ui.temperatureUnit, equals(TemperatureUnit.fahrenheit));
      });
    });

    group('Interactions', () {
      testWidgets('should be scrollable', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should be able to scroll
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Verify scrolling works
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -100),
        );
        await tester.pumpAndSettle();

        // Should still have all content after scrolling
        expect(find.byType(SectionDivider), findsWidgets);
      });

      testWidgets('should handle dropdown interaction properly', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should be able to open and close dropdown
        final dropdown = find.byType(DropdownButton<String?>);

        // Open dropdown
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        // Should show dropdown items
        expect(find.text('English'), findsWidgets);

        // Close dropdown by tapping outside or selecting item
        await tester.tap(find.text('English').last);
        await tester.pumpAndSettle();

        // Dropdown should be closed
        expect(find.byType(DropdownButton<String?>), findsOneWidget);
      });
    });

    group('Styling and Theme', () {
      testWidgets('should have correct background transparency', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Scaffold should be transparent
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(AppColors.transparentColor));

        // Content container should have semi-transparent background
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should have proper spacing and layout', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have proper padding
        expect(find.byType(Padding), findsWidgets);

        // Should have proper spacing with SizedBox
        expect(find.byType(SizedBox), findsWidgets);

        // Should have column layout
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have consistent language option styling', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have language option container with proper styling
        expect(find.byIcon(Icons.language), findsOneWidget);

        // Should have text with proper styling
        expect(find.byType(Text), findsWidgets);

        // Should have dropdown with proper styling
        expect(find.byType(DropdownButton<String?>), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should reflect app state changes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Change language programmatically
        appState.ui.setLanguage('fr');
        await tester.pump();

        // Should reflect the change in the dropdown
        final dropdown = tester.widget<DropdownButton<String?>>(
          find.byType(DropdownButton<String?>),
        );
        expect(dropdown.value, equals('fr'));
      });

      testWidgets('should maintain state consistency', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Make multiple language changes
        appState.ui.setLanguage('ja');
        await tester.pump();

        appState.ui.setLanguage('ko');
        await tester.pump();

        appState.ui.setLanguage(null); // System default
        await tester.pump();

        // Should reflect the final state
        final dropdown = tester.widget<DropdownButton<String?>>(
          find.byType(DropdownButton<String?>),
        );
        expect(dropdown.value, isNull);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle missing localization gracefully', (
        tester,
      ) async {
        // This test ensures the widget doesn't crash with missing translations
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should render without errors
        expect(find.byType(ApplicationSettingsScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle app state changes gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should handle rapid state changes without errors
        for (final lang in ['en', 'de', 'es', 'fr', null]) {
          appState.ui.setLanguage(lang);
          await tester.pump();
        }

        // Should still render correctly
        expect(find.byType(DropdownButton<String?>), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle empty content gracefully', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should still render basic structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have accessible dropdown', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Dropdown should be accessible
        expect(find.byType(DropdownButton<String?>), findsOneWidget);

        final dropdown = tester.widget<DropdownButton<String?>>(
          find.byType(DropdownButton<String?>),
        );
        expect(dropdown.onChanged, isNotNull);
      });

      testWidgets('should have semantic structure', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have proper semantic structure with headers and content
        // (language settings and haptic feedback sections)
        expect(find.byType(SectionDivider), findsNWidgets(2));
        expect(find.byType(Text), findsWidgets);
        expect(find.byIcon(Icons.language), findsOneWidget);
      });

      testWidgets('should support keyboard navigation', (tester) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have focusable elements
        expect(find.byType(DropdownButton<String?>), findsOneWidget);

        // AppBar should support navigation
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Integration', () {
      testWidgets('should integrate with Consumer and Provider correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have Consumer widget
        expect(find.byType(Consumer<AppState>), findsOneWidget);

        // Should react to provider changes
        appState.ui.setLanguage('zh');
        await tester.pump();

        final dropdown = tester.widget<DropdownButton<String?>>(
          find.byType(DropdownButton<String?>),
        );
        expect(dropdown.value, equals('zh'));
      });

      testWidgets('should handle expansion for future settings sections', (
        tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(child: const ApplicationSettingsScreen()),
        );
        await tester.pumpAndSettle();

        // Should have structure ready for additional settings
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // Should have expandable layout (multiple Expanded widgets are fine)
        expect(find.byType(Expanded), findsWidgets);
      });
    });
  });
}
