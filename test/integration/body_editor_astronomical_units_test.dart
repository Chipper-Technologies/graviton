import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/habitability_status.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_details_bottom_sheet.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/state/app_state.dart';
import 'package:provider/provider.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: ChangeNotifierProvider<AppState>.value(
      value: AppState(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Body Editor Astronomical Units Integration', () {
    testWidgets('displays mass slider with solar mass units', (
      WidgetTester tester,
    ) async {
      // Create a test star body with a known mass
      final testStar = Body(
        name: 'Test Star',
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 20.0, // 20 sim units = 2.0 solar masses
        radius: 1.0,
        color: Colors.yellow,
        bodyType: BodyType.star,
        isPlanet: false,
        temperature: 5778.0,
        stellarLuminosity: 1.0,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testStar,
            isAddMode: false,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the mass slider shows solar mass units
      // The expected formatted value should be "2.00 M☉" for 20 sim units
      final expectedMassText = NumberUtils.formatMassInSolarMasses(20.0);
      expect(expectedMassText, equals('2.00 M☉'));

      // We can't easily test the widget formatter function directly in widget tests,
      // but we can verify the formatters work as expected in isolation
      expect(NumberUtils.formatMassInSolarMasses(10.0), equals('1.00 M☉'));
      expect(NumberUtils.formatMassInSolarMasses(5.0), equals('0.500 M☉'));
      expect(NumberUtils.formatMassInSolarMasses(150.0), equals('15.0 M☉'));
    });

    testWidgets('displays radius slider with solar radius units', (
      WidgetTester tester,
    ) async {
      // Create a test star body with a known radius
      final testStar = Body(
        name: 'Test Star',
        position: vm.Vector3.zero(),
        velocity: vm.Vector3.zero(),
        mass: 10.0,
        radius: 2.5, // 2.5 sim units = 2.5 solar radii
        color: Colors.orange,
        bodyType: BodyType.star,
        isPlanet: false,
        temperature: 4500.0,
        stellarLuminosity: 0.8,
        habitabilityStatus: HabitabilityStatus.unknown,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorBodyDetailsBottomSheet(
            body: testStar,
            isAddMode: false,
            onBodyChanged: (_) {},
            onDuplicate: () {},
            onDelete: () {},
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the radius formatter works correctly
      final expectedRadiusText = NumberUtils.formatRadiusInSolarRadii(2.5);
      expect(expectedRadiusText, equals('2.50 R☉'));

      // Test various radius values
      expect(NumberUtils.formatRadiusInSolarRadii(1.0), equals('1.00 R☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(0.5), equals('0.500 R☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(10.0), equals('10.0 R☉'));
    });

    testWidgets('mass and radius formatters work for different body types', (
      WidgetTester tester,
    ) async {
      // Test different body types to ensure formatters work across all scenarios
      final testCases = [
        {
          'type': BodyType.star,
          'mass': 50.0, // 5.0 M☉
          'radius': 3.0, // 3.0 R☉
          'expectedMass': '5.00 M☉',
          'expectedRadius': '3.00 R☉',
        },
        {
          'type': BodyType.planet,
          'mass': 0.1, // 0.01 M☉
          'radius': 0.09, // 0.09 R☉
          'expectedMass': '0.010 M☉',
          'expectedRadius': '0.090 R☉',
        },
        {
          'type': BodyType.moon,
          'mass': 0.05, // 0.005 M☉
          'radius': 0.02, // 0.02 R☉
          'expectedMass': '0.005 M☉',
          'expectedRadius': '0.020 R☉',
        },
      ];

      for (final testCase in testCases) {
        final bodyType = testCase['type'] as BodyType;
        final mass = testCase['mass'] as double;
        final radius = testCase['radius'] as double;
        final expectedMass = testCase['expectedMass'] as String;
        final expectedRadius = testCase['expectedRadius'] as String;

        // Verify formatters work correctly
        expect(
          NumberUtils.formatMassInSolarMasses(mass),
          equals(expectedMass),
          reason: 'Mass formatting failed for ${bodyType.name}',
        );
        expect(
          NumberUtils.formatRadiusInSolarRadii(radius),
          equals(expectedRadius),
          reason: 'Radius formatting failed for ${bodyType.name}',
        );
      }
    });

    testWidgets('astronomical formatters handle edge cases correctly', (
      WidgetTester tester,
    ) async {
      // Test edge cases
      expect(NumberUtils.formatMassInSolarMasses(0), equals('0 M☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(0), equals('0 R☉'));

      // Test negative values (shouldn't normally happen but good to test)
      expect(NumberUtils.formatMassInSolarMasses(-10.0), equals('-1.00 M☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(-1.0), equals('-1.00 R☉'));

      // Test very small values
      expect(NumberUtils.formatMassInSolarMasses(0.001), equals('0.000 M☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(0.001), equals('0.001 R☉'));

      // Test very large values
      expect(NumberUtils.formatMassInSolarMasses(10000.0), equals('1,000 M☉'));
      expect(
        NumberUtils.formatRadiusInSolarRadii(1000.0),
        equals('1,000.0 R☉'),
      );
    });

    testWidgets('conversion ratios are correct', (WidgetTester tester) async {
      // Verify the documented conversion ratios

      // Mass: 10 sim units = 1 solar mass
      expect(NumberUtils.formatMassInSolarMasses(10.0), equals('1.00 M☉'));
      expect(NumberUtils.formatMassInSolarMasses(30.0), equals('3.00 M☉'));
      expect(NumberUtils.formatMassInSolarMasses(1.0), equals('0.100 M☉'));

      // Radius: 1 sim unit = 1 solar radius (1:1 ratio)
      expect(NumberUtils.formatRadiusInSolarRadii(1.0), equals('1.00 R☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(3.0), equals('3.00 R☉'));
      expect(NumberUtils.formatRadiusInSolarRadii(0.1), equals('0.100 R☉'));
    });

    test('precision levels are appropriate for astronomical values', () {
      // Verify precision levels match astronomical conventions

      // Mass precision tests
      expect(
        NumberUtils.formatMassInSolarMasses(1500.0),
        equals('150 M☉'),
      ); // No decimals for large
      expect(
        NumberUtils.formatMassInSolarMasses(150.0),
        equals('15.0 M☉'),
      ); // 1 decimal for medium-large
      expect(
        NumberUtils.formatMassInSolarMasses(15.0),
        equals('1.50 M☉'),
      ); // 2 decimals for medium
      expect(
        NumberUtils.formatMassInSolarMasses(1.5),
        equals('0.150 M☉'),
      ); // 3 decimals for small

      // Radius precision tests
      expect(
        NumberUtils.formatRadiusInSolarRadii(100.0),
        equals('100.0 R☉'),
      ); // 1 decimal for large
      expect(
        NumberUtils.formatRadiusInSolarRadii(10.0),
        equals('10.0 R☉'),
      ); // 1 decimal for medium-large
      expect(
        NumberUtils.formatRadiusInSolarRadii(1.0),
        equals('1.00 R☉'),
      ); // 2 decimals for medium
      expect(
        NumberUtils.formatRadiusInSolarRadii(0.1),
        equals('0.100 R☉'),
      ); // 3 decimals for small
    });
  });
}
