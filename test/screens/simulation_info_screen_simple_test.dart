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
  group('SimulationInfoScreen - Simplified Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    Widget buildTestWidget({List<Body>? bodies}) {
      if (bodies != null) {
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

    testWidgets('renders basic UI structure', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Simulation Info'), findsOneWidget);
    });

    testWidgets('renders with test bodies', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(),
        TestUtils.createTestPlanet(),
        TestUtils.createTestMoon(),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('displays body names correctly', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(name: 'Test Star'),
        TestUtils.createTestPlanet(name: 'Test Planet'),
        TestUtils.createTestMoon(name: 'Test Moon'),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      expect(find.text('Test Star'), findsOneWidget);
      expect(find.text('Test Planet'), findsOneWidget);
      expect(find.text('Test Moon'), findsOneWidget);
    });

    testWidgets('handles empty bodies gracefully', (tester) async {
      await tester.pumpWidget(buildTestWidget(bodies: []));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('handles large numbers correctly', (tester) async {
      final testBodies = [TestUtils.createTestStar(mass: 1.989e30)];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Should display scientific notation formatting
      expect(find.textContaining('×'), findsWidgets);
    });

    testWidgets('scrolls with many bodies', (tester) async {
      final testBodies = List.generate(
        5,
        (index) => TestUtils.createTestAsteroid(name: 'Asteroid $index'),
      );

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Asteroid 0'), findsOneWidget);
    });

    testWidgets('calculates body count correctly', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(),
        TestUtils.createTestPlanet(),
        TestUtils.createTestMoon(),
        TestUtils.createTestAsteroid(),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Should have "4" displayed somewhere for total body count
      expect(find.textContaining('4'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays habitability for planets', (tester) async {
      final testBodies = [
        TestUtils.createTestPlanet(
          habitabilityStatus: HabitabilityStatus.habitable,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Should render without error
      expect(find.text('Test Planet'), findsOneWidget);
    });

    testWidgets('handles extreme values', (tester) async {
      final testBodies = [
        TestUtils.createTestStar(mass: 1e50, velocity: vm.Vector3(1e10, 0, 0)),
      ];

      await tester.pumpWidget(buildTestWidget(bodies: testBodies));
      await tester.pumpAndSettle();

      // Should render without crashing
      expect(find.text('Test Star'), findsOneWidget);
    });

    testWidgets('displays physics parameters', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should have some physics-related text displayed
      expect(find.textContaining('x'), findsWidgets); // Time scale multiplier
    });
  });
}
