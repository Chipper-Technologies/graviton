import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/utils/semantics/semantic_utils.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/enums/simulation_status.dart';
import 'package:graviton/models/body.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:flutter/material.dart';
import '../../test_utils.dart';

void main() {
  group('SemanticUtils', () {
    late AppLocalizations l10n;

    // Helper to get localization
    Future<AppLocalizations> getL10n(WidgetTester tester) async {
      await tester.pumpWidget(
        TestUtils.wrapWithMaterialApp(child: Container()),
      );
      return AppLocalizations.of(tester.element(find.byType(Container)))!;
    }

    group('createLiveUpdate', () {
      testWidgets('should format live update announcements', (tester) async {
        l10n = await getL10n(tester);

        final announcement = SemanticUtils.createLiveUpdate(
          l10n,
          'Speed',
          '2.0x',
        );
        expect(announcement, contains('Speed'));
        expect(announcement, contains('2.0x'));
      });

      testWidgets('should handle empty strings', (tester) async {
        l10n = await getL10n(tester);

        final announcement = SemanticUtils.createLiveUpdate(l10n, '', '');
        expect(announcement, isA<String>());
      });
    });

    group('createKeyboardHints', () {
      testWidgets('should provide keyboard shortcuts help', (tester) async {
        l10n = await getL10n(tester);

        final hints = SemanticUtils.createKeyboardHints(l10n);

        expect(hints, isNotEmpty);
        expect(hints, contains('Space'));
        expect(hints, contains('R'));
        expect(hints, contains('C'));
        expect(hints, contains('A'));
      });
    });

    group('createSimulationDescription', () {
      testWidgets('should create comprehensive simulation description', (
        tester,
      ) async {
        l10n = await getL10n(tester);

        final bodies = <Body>[
          Body(
            name: 'Sun',
            mass: 1e30,
            radius: 696340000,
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3(0, 0, 0),
            color: Colors.yellow,
          ),
          Body(
            name: 'Earth',
            mass: 5.97e24,
            radius: 6371000,
            position: vm.Vector3(149597870700, 0, 0),
            velocity: vm.Vector3(0, 29780, 0),
            color: Colors.blue,
          ),
        ];

        final description = SemanticUtils.createSimulationDescription(
          l10n,
          bodies,
          SimulationStatus.running,
          2.0,
          1000,
        );

        expect(description, contains('2'));
        expect(description, contains('1000'));
      });
    });

    group('createBodiesDescription', () {
      testWidgets('should describe empty simulation', (tester) async {
        l10n = await getL10n(tester);

        final description = SemanticUtils.createBodiesDescription(l10n, []);
        expect(description, contains('No celestial bodies'));
      });

      testWidgets('should describe bodies in simulation', (tester) async {
        l10n = await getL10n(tester);

        final bodies = <Body>[
          Body(
            name: 'Sun',
            mass: 1e30,
            radius: 696340000,
            position: vm.Vector3(0, 0, 0),
            velocity: vm.Vector3(0, 0, 0),
            color: Colors.yellow,
          ),
        ];

        final description = SemanticUtils.createBodiesDescription(l10n, bodies);
        expect(description, contains('Bodies in simulation'));
      });
    });

    group('createCameraDescription', () {
      testWidgets('should describe free camera mode', (tester) async {
        l10n = await getL10n(tester);

        final description = SemanticUtils.createCameraDescription(
          l10n,
          1000.0,
          true,
          false,
          null,
        );

        expect(description, contains('free mode'));
        expect(description, contains('1000.0'));
      });

      testWidgets('should describe follow camera mode', (tester) async {
        l10n = await getL10n(tester);

        final description = SemanticUtils.createCameraDescription(
          l10n,
          500.0,
          false,
          true,
          'Earth',
        );

        expect(description, contains('following'));
        expect(description, contains('Earth'));
        expect(description, contains('500.0'));
      });
    });

    group('createPhysicsStatsLabel', () {
      testWidgets('should create physics statistics description', (
        tester,
      ) async {
        l10n = await getL10n(tester);

        final stats = SemanticUtils.createPhysicsStatsLabel(
          l10n,
          100.5,
          2.5,
          5000,
        );

        expect(stats, contains('100.5'));
        expect(stats, contains('2.50'));
        expect(stats, contains('5000'));
      });
    });

    group('shouldAnnounce', () {
      test('should respect announcement intervals', () {
        final now = DateTime.now();
        final fiveSecondsAgo = now.subtract(const Duration(seconds: 5));
        final twoSecondsAgo = now.subtract(const Duration(seconds: 2));

        expect(
          SemanticUtils.shouldAnnounce(
            fiveSecondsAgo,
            const Duration(seconds: 3),
          ),
          isTrue,
        );

        expect(
          SemanticUtils.shouldAnnounce(
            twoSecondsAgo,
            const Duration(seconds: 3),
          ),
          isFalse,
        );
      });
    });
  });
}
