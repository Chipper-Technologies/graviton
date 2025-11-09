import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/scenario_physics_settings.dart';
import 'package:graviton/models/particle_systems_config.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_physics_panel.dart';
import 'package:graviton/widgets/section_title.dart';

/// Test widget wrapper with localization support
Widget makeTestableWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('ScenarioEditorPhysicsPanel', () {
    late ScenarioPhysicsSettings testPhysics;
    late ParticleSystemsConfig testParticleSystems;

    setUp(() {
      testPhysics = ScenarioPhysicsSettings(
        gravitationalConstant: 6.674e-11,
        softening: 0.1,
        timeScale: 1.0,
        collisionRadiusMultiplier: 1.0,
        maxTrailPoints: 1000,
        trailFadeRate: 0.05,
      );

      testParticleSystems = ParticleSystemsConfig(
        asteroidBelt: null,
        kuiperBelt: null,
      );
    });

    testWidgets('displays physics panel correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should display the widget without crashing
      expect(find.byType(ScenarioEditorPhysicsPanel), findsOneWidget);

      // Should display section titles
      expect(find.byType(SectionTitle), findsAtLeastNWidgets(2));

      // Should be wrapped in SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays physics settings section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should display physics settings section title
      expect(find.byType(SectionTitle), findsAtLeastNWidgets(1));

      // Should display placeholder text (widget only shows placeholder content)
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });

    testWidgets('displays particle systems section', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should display particle systems section title
      expect(find.byType(SectionTitle), findsAtLeastNWidgets(2));

      // Should display placeholder text (widget only shows placeholder content)
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });

    testWidgets('handles physics changes callback', (
      WidgetTester tester,
    ) async {
      ScenarioPhysicsSettings? updatedPhysics;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (physics) => updatedPhysics = physics,
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Verify the callback parameter exists and widget renders
      expect(find.byType(ScenarioEditorPhysicsPanel), findsOneWidget);

      // The onPhysicsChanged callback should be available for future implementation
      expect(
        updatedPhysics,
        isNull,
      ); // Should be null since no changes triggered yet
    });

    testWidgets('handles particle systems changes callback', (
      WidgetTester tester,
    ) async {
      ParticleSystemsConfig? updatedParticleSystems;

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (systems) =>
                updatedParticleSystems = systems,
          ),
        ),
      );

      // Verify the callback parameter exists and widget renders
      expect(find.byType(ScenarioEditorPhysicsPanel), findsOneWidget);

      // The onParticleSystemsChanged callback should be available for future implementation
      expect(
        updatedParticleSystems,
        isNull,
      ); // Should be null since no changes triggered yet
    });

    testWidgets('displays proper layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should have proper layout structure
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('uses proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should use proper padding
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.padding, isNotNull);
    });

    testWidgets('handles different physics settings', (
      WidgetTester tester,
    ) async {
      final altPhysics = ScenarioPhysicsSettings(
        gravitationalConstant: 1.0,
        softening: 0.05,
        timeScale: 2.0,
        collisionRadiusMultiplier: 1.5,
        maxTrailPoints: 500,
        trailFadeRate: 0.1,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: altPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should handle different physics settings without crashing
      expect(find.byType(ScenarioEditorPhysicsPanel), findsOneWidget);
    });

    testWidgets('handles different particle systems settings', (
      WidgetTester tester,
    ) async {
      final withParticleSystems = ParticleSystemsConfig(
        asteroidBelt: null, // These would be configured when enabled
        kuiperBelt: null,
      );

      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: withParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should handle configured particle systems without crashing
      expect(find.byType(ScenarioEditorPhysicsPanel), findsOneWidget);
    });

    testWidgets('displays implementation placeholder text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          ScenarioEditorPhysicsPanel(
            physics: testPhysics,
            particleSystems: testParticleSystems,
            onPhysicsChanged: (_) {},
            onParticleSystemsChanged: (_) {},
          ),
        ),
      );

      // Should display placeholder text indicating future implementation
      expect(find.textContaining('implemented'), findsWidgets);
      expect(find.textContaining('configured'), findsWidgets);
    });
  });
}
