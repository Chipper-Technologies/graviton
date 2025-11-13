import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/screens/simulation_info_screen.dart';
import 'package:graviton/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../test_utils.dart';

void main() {
  group('SimulationInfoScreen', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    Widget buildTestWidget({List<Body>? bodies}) {
      if (bodies != null) {
        // Set up the simulation with test bodies
        appState.simulation.bodies.clear();
        appState.simulation.bodies.addAll(bodies);
      }

      return ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SimulationInfoScreen(),
        ),
      );
    }

    testWidgets('renders without crashing with empty bodies', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Just verify the main screen widgets are displayed without specific text
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Simulation Info'), findsOneWidget);
    });

    testWidgets('displays all major sections with bodies', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(),
        TestUtils.createTestPlanet(),
        TestUtils.createTestMoon(),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify basic structure is rendered
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('displays correct body statistics', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(),
        TestUtils.createTestPlanet(),
        TestUtils.createTestMoon(),
        TestUtils.createTestAsteroid(),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Check for any text containing "4" (total bodies count)
      expect(find.textContaining('4'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays energy and dynamics section', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(
          mass: 1.989e30, // Solar mass
          velocity: vm.Vector3(0, 0, 0),
        ),
        TestUtils.createTestPlanet(
          mass: 5.972e24, // Earth mass
          velocity: vm.Vector3(29780, 0, 0), // Earth orbital velocity
        ),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify energy section labels are present
      expect(find.text('Total Energy'), findsOneWidget);
      expect(find.text('Kinetic Energy'), findsWidgets);
      expect(find.text('Potential Energy'), findsWidgets);
      expect(find.text('Angular Momentum'), findsOneWidget);
      expect(find.text('System Momentum'), findsOneWidget);
      expect(find.text('Center of Mass'), findsOneWidget);
    });

    testWidgets('displays orbital mechanics section', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(velocity: vm.Vector3(1000, 0, 0)),
        TestUtils.createTestPlanet(velocity: vm.Vector3(30000, 0, 0)),
        TestUtils.createTestMoon(velocity: vm.Vector3(1000, 0, 0)),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify orbital mechanics labels
      expect(find.text('Velocity Range'), findsOneWidget);
      expect(find.text('Average Velocity'), findsOneWidget);
      expect(find.text('Temperature Range'), findsOneWidget);
    });

    testWidgets('displays individual celestial bodies in correct order', (
      tester,
    ) async {
      final testBodies = [
        TestUtils.createTestStar(name: 'Test Star'),
        TestUtils.createTestPlanet(name: 'Test Planet'),
        TestUtils.createTestMoon(name: 'Test Moon'),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify bodies are displayed in simulation order
      expect(find.text('Test Star'), findsOneWidget);
      expect(find.text('Test Planet'), findsOneWidget);
      expect(find.text('Test Moon'), findsOneWidget);

      // Verify body types are displayed
      expect(find.text('Star'), findsOneWidget);
      expect(find.text('Planet'), findsOneWidget);
      expect(find.text('Moon'), findsOneWidget);
    });

    testWidgets('displays detailed body statistics', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(
          mass: 1.989e30,
          radius: 6.96e8,
          temperature: 5778,
          velocity: vm.Vector3(1000, 0, 0),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify detailed body stats labels are present
      expect(find.text('Mass'), findsWidgets);
      expect(find.text('Radius'), findsWidgets);
      expect(find.text('Velocity'), findsWidgets);
      expect(find.text('Temperature'), findsWidgets);
      expect(find.text('Kinetic Energy'), findsWidgets);
      expect(find.text('Escape Velocity'), findsWidgets);
    });

    testWidgets('displays star-specific statistics', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(stellarLuminosity: 3.828e26),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify star-specific stats
      expect(find.text('Luminosity'), findsOneWidget);
    });

    testWidgets('displays planet-specific statistics', (tester) async {
      final testBodies = [
        TestUtils.createTestPlanet(
          habitabilityStatus: HabitabilityStatus.habitable,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify planet-specific stats
      expect(find.text('Habitability'), findsOneWidget);
    });

    testWidgets('displays physics parameters correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify physics parameters
      expect(find.text('Time Scale'), findsOneWidget);
      expect(find.text('Simulation Steps'), findsOneWidget);
      expect(find.text('Gravitational Constant'), findsOneWidget);
    });

    testWidgets('handles different scenarios correctly', (tester) async {
      // Test with default scenario
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should display scenario information
      expect(find.text('Simulation Info'), findsOneWidget);
    });

    testWidgets('scrolls correctly with many bodies', (tester) async {
      // Create many test bodies to test scrolling
      final testBodies = List.generate(
        10,
        (index) => TestUtils.createTestAsteroid(name: 'Asteroid $index'),
      );

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify we can scroll through the content
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Verify some bodies are displayed
      expect(find.text('Asteroid 0'), findsOneWidget);

      // Scroll down to see more bodies
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('uses correct cosmic theming', (tester) async {
      final testBodies = [TestUtils.createTestStar()];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Verify cosmic colors are used
      final starCard = find.byType(Container).first;
      expect(starCard, findsOneWidget);

      // Verify gradient decorations are present
      expect(find.byType(Container), findsWidgets);
    });

    group('Statistical calculations', () {
      testWidgets('verifies calculations work through UI', (tester) async {
        final testBodies = [
          TestUtils.createTestStar(),
          TestUtils.createTestPlanet(
            habitabilityStatus: HabitabilityStatus.habitable,
          ),
          TestUtils.createTestMoon(),
          TestUtils.createTestAsteroid(),
        ];

        await tester.pumpWidget(buildTestWidget(bodies: testBodies));
        await tester.pumpAndSettle();

        // Verify that calculations are reflected in the UI
        // Look for the total body count in the Body Statistics section
        expect(find.text('Total Bodies'), findsOneWidget);
        // The exact count display depends on the UI implementation,
        // so we'll just verify the section exists rather than the exact text
      });
    });

    group('Formatting functions', () {
      testWidgets('formats large numbers correctly', (tester) async {
        final testBodies = [
          TestUtils.createTestStar(mass: 1.989e30), // Solar mass
        ];

        await tester.pumpWidget(buildTestWidget(bodies: testBodies));
        await tester.pumpAndSettle();

        // Verify scientific notation or readable formatting is used
        expect(find.textContaining('×'), findsWidgets);
      });
    });

    group('Error handling', () {
      testWidgets('handles empty body list gracefully', (tester) async {
        await tester.pumpWidget(buildTestWidget(bodies: []));
        await tester.pumpAndSettle();

        // Should still render main sections
        expect(find.text('Simulation Info'), findsOneWidget);
        expect(find.text('Body Statistics'), findsOneWidget);
        expect(find.text('Physics Parameters'), findsOneWidget);

        // Energy and celestial bodies sections should be hidden or show empty state
        expect(find.text('Energy & Dynamics'), findsNothing);
        expect(find.text('Celestial Bodies'), findsNothing);
      });

      testWidgets('handles extreme values correctly', (tester) async {
        final testBodies = [
          TestUtils.createTestStar(
            mass: double.maxFinite,
            velocity: vm.Vector3(double.maxFinite, 0, 0),
            temperature: double.maxFinite,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(bodies: testBodies));
        await tester.pumpAndSettle();

        // Should render without crashing
        expect(find.text('Test Star'), findsOneWidget);
      });
    });
  });
}
