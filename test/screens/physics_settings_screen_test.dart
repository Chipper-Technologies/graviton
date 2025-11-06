import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/physics_settings_screen.dart';
import 'package:graviton/widgets/common/action_option.dart';
import 'package:graviton/widgets/common/haptic_slider_option.dart';
import 'package:graviton/widgets/common/toggle_option.dart';
import 'package:graviton/widgets/section_title.dart';

void main() {
  group('PhysicsSettingsScreen Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('de'),
          Locale('ja'),
          Locale('zh'),
        ],
        home: child,
      );
    }

    Map<String, dynamic>? capturedSettings;
    void onSettingsChanged(Map<String, dynamic> settings) {
      capturedSettings = settings;
    }

    Widget buildPhysicsSettingsScreen({
      double gravitationalConstant = 6.67,
      double softening = 0.1,
      double timeScale = 8.0,
      double collisionRadiusMultiplier = 0.5,
      int maxTrailPoints = 500,
      double trailFadeRate = 1.0,
      double vibrationThrottleTime = 0.5,
      bool vibrationEnabled = true,
      ScenarioType currentScenario = ScenarioType.solarSystem,
    }) {
      return createTestWidget(
        PhysicsSettingsScreen(
          gravitationalConstant: gravitationalConstant,
          softening: softening,
          timeScale: timeScale,
          collisionRadiusMultiplier: collisionRadiusMultiplier,
          maxTrailPoints: maxTrailPoints,
          trailFadeRate: trailFadeRate,
          vibrationThrottleTime: vibrationThrottleTime,
          vibrationEnabled: vibrationEnabled,
          currentScenario: currentScenario,
          onSettingsChanged: onSettingsChanged,
        ),
      );
    }

    setUp(() {
      capturedSettings = null;
    });

    testWidgets('should display screen with transparent background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Find the Scaffold
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.transparent));
    });

    testWidgets('should display AppBar with title and close button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);

      // Verify title
      expect(find.text('Physics Settings'), findsOneWidget);
    });

    testWidgets('should display all section titles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify section titles
      expect(find.text('Physics'), findsOneWidget);
      expect(find.text('Collisions'), findsOneWidget);
      expect(find.text('Trails'), findsOneWidget);
      expect(find.text('Haptics'), findsOneWidget);
    });

    testWidgets('should display physics section sliders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify physics sliders are present
      expect(find.text('Gravitational Constant'), findsOneWidget);
      expect(find.text('Softening Parameter'), findsOneWidget);
      expect(find.text('Simulation Speed'), findsOneWidget);

      // Verify corresponding icons
      expect(find.byIcon(Icons.public), findsOneWidget);
      expect(find.byIcon(Icons.blur_on), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
    });

    testWidgets('should display collision section sliders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify collision slider
      expect(find.text('Collision Sensitivity'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    });

    testWidgets('should display trails section sliders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify trail sliders
      expect(find.text('Trail Length'), findsOneWidget);
      expect(find.text('Trail Fade Rate'), findsOneWidget);

      // Verify corresponding icons
      expect(find.byIcon(Icons.linear_scale), findsOneWidget);
      expect(find.byIcon(Icons.blur_linear), findsOneWidget);
    });

    testWidgets('should display haptics section with vibration toggle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify vibration toggle
      expect(find.text('Vibration Enabled'), findsOneWidget);
      expect(find.text('Haptic feedback on collisions'), findsOneWidget);
      expect(find.byIcon(Icons.vibration), findsOneWidget);
      expect(find.byType(ToggleOption), findsAtLeastNWidgets(1));
    });

    testWidgets(
      'should show vibration throttle slider when vibration is enabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildPhysicsSettingsScreen(vibrationEnabled: true),
        );
        await tester.pumpAndSettle();

        // Verify vibration throttle slider is visible
        expect(find.text('Vibration Throttle'), findsOneWidget);
        expect(find.byIcon(Icons.timer), findsOneWidget);
      },
    );

    testWidgets(
      'should hide vibration throttle slider when vibration is disabled',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildPhysicsSettingsScreen(vibrationEnabled: false),
        );
        await tester.pumpAndSettle();

        // Verify vibration throttle slider is not visible
        expect(find.text('Vibration Throttle'), findsNothing);
        expect(find.byIcon(Icons.timer), findsNothing);
      },
    );

    testWidgets('should display reset button', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify reset button
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Reset all settings to default values'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byType(ActionOption), findsOneWidget);
    });

    testWidgets('should call onSettingsChanged when slider values change', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Find the first slider (gravitational constant)
      final sliders = find.byType(Slider);
      expect(sliders, findsAtLeastNWidgets(1));

      // Interact with the slider
      await tester.drag(sliders.first, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Verify settings callback was called
      expect(capturedSettings, isNotNull);
      expect(capturedSettings!['gravitationalConstant'], isA<double>());
    });

    testWidgets('should toggle vibration when switch is tapped', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(
        buildPhysicsSettingsScreen(vibrationEnabled: false),
      );
      await tester.pumpAndSettle();

      // Scroll to the haptics section to make the switch visible
      await tester.scrollUntilVisible(
        find.text('Haptics'),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Find and tap the vibration toggle
      final toggleSwitch = find.byType(Switch);
      expect(toggleSwitch, findsOneWidget);

      await tester.tap(toggleSwitch);
      await tester.pumpAndSettle();

      // Verify settings callback was called with vibration enabled
      expect(capturedSettings, isNotNull);
      expect(capturedSettings!['vibrationEnabled'], isTrue);

      // Verify vibration throttle slider now appears
      expect(find.text('Vibration Throttle'), findsOneWidget);
    });

    testWidgets('should handle reset button tap', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Clear any previous captured settings
      capturedSettings = null;

      // Scroll to the reset button to make it visible
      await tester.scrollUntilVisible(
        find.text('Reset'),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Find and tap the reset button
      final resetButton = find.text('Reset');
      expect(resetButton, findsOneWidget);

      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Verify settings callback was called with reset values
      expect(capturedSettings, isNotNull);
      expect(capturedSettings!.keys, contains('gravitationalConstant'));
      expect(capturedSettings!.keys, contains('softening'));
      expect(capturedSettings!.keys, contains('timeScale'));
    });

    testWidgets('should close screen when close button is tapped', (
      WidgetTester tester,
    ) async {
      // TODO: Fix navigation context issue
      // This test needs proper navigation setup to work correctly
    }, skip: true);

    testWidgets('should display correct initial values', (
      WidgetTester tester,
    ) async {
      const testGravity = 5.55;
      const testSoftening = 0.123;
      const testTimeScale = 12.5;

      await tester.pumpWidget(
        buildPhysicsSettingsScreen(
          gravitationalConstant: testGravity,
          softening: testSoftening,
          timeScale: testTimeScale,
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial values are displayed
      expect(find.text('5.55'), findsOneWidget); // Gravity
      expect(find.text('0.123'), findsOneWidget); // Softening
      expect(find.text('12.5x'), findsOneWidget); // Time scale
    });

    testWidgets('should be scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify SingleChildScrollView exists
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Test scrolling
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      // Should still find the content
      expect(find.byType(PhysicsSettingsScreen), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Verify overall structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));

      // Verify section components
      expect(
        find.byType(SectionTitle),
        findsNWidgets(4),
      ); // Physics, Collision, Trails, Haptics
      expect(
        find.byType(HapticSliderOption),
        findsAtLeastNWidgets(5),
      ); // Multiple sliders
      expect(find.byType(ToggleOption), findsOneWidget); // Vibration toggle
      expect(find.byType(ActionOption), findsOneWidget); // Reset button
    });

    testWidgets('should handle different scenario types', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        buildPhysicsSettingsScreen(currentScenario: ScenarioType.binaryStars),
      );
      await tester.pumpAndSettle();

      // Should still display all sections
      expect(find.text('Physics Settings'), findsOneWidget);
      expect(find.text('Physics'), findsOneWidget);
      expect(find.text('Collisions'), findsOneWidget);
      expect(find.text('Trails'), findsOneWidget);
      expect(find.text('Haptics'), findsOneWidget);
    });

    testWidgets('should preserve state during interactions', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(buildPhysicsSettingsScreen());
      await tester.pumpAndSettle();

      // Scroll to the haptics section to make the switch visible
      await tester.scrollUntilVisible(
        find.text('Haptics'),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Toggle vibration off
      final toggleSwitch = find.byType(Switch);
      await tester.tap(toggleSwitch);
      await tester.pumpAndSettle();

      // Scroll and verify vibration throttle is hidden (vibration is now disabled)
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vibration Throttle'), findsNothing);
    });
  });
}
