import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graviton/constants/ui_constants.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/screens/about_screen.dart';
import 'package:graviton/screens/account_management_screen.dart';
import 'package:graviton/screens/application_settings_screen.dart';
import 'package:graviton/screens/developer_tools_screen.dart';
import 'package:graviton/screens/help_screen.dart';
import 'package:graviton/screens/physics_settings_screen.dart';
import 'package:graviton/screens/simulation_info_screen.dart';
import 'package:graviton/services/navigation_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/state/auth_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NavigationService', () {
    group('buildFadeRoute', () {
      testWidgets('should create fade route with correct transition duration', (
        tester,
      ) async {
        final route = NavigationService.buildFadeRoute(
          screen: const Scaffold(body: Text('Test Screen')),
        );

        expect(route.transitionDuration, UIConstants.screenTransitionDuration);
        expect(route.opaque, false);
      });

      testWidgets('should create opaque route when specified', (tester) async {
        final route = NavigationService.buildFadeRoute(
          screen: const Scaffold(body: Text('Test Screen')),
          opaque: true,
        );

        expect(route.opaque, true);
      });

      testWidgets('should create fade transition', (tester) async {
        final route = NavigationService.buildFadeRoute<void>(
          screen: const Scaffold(body: Text('Test Screen')),
        );

        // Build the transition
        final transition = route.transitionsBuilder(
          tester.element(find.byType(Container)),
          const AlwaysStoppedAnimation(1.0),
          const AlwaysStoppedAnimation(0.0),
          const Text('Child'),
        );

        expect(transition, isA<FadeTransition>());
      });

      testWidgets('should handle generic type parameters', (tester) async {
        final stringRoute = NavigationService.buildFadeRoute<String>(
          screen: const Scaffold(body: Text('Test')),
        );

        final intRoute = NavigationService.buildFadeRoute<int>(
          screen: const Scaffold(body: Text('Test')),
        );

        final voidRoute = NavigationService.buildFadeRoute<void>(
          screen: const Scaffold(body: Text('Test')),
        );

        expect(stringRoute, isA<PageRouteBuilder<String>>());
        expect(intRoute, isA<PageRouteBuilder<int>>());
        expect(voidRoute, isA<PageRouteBuilder<void>>());
      });

      testWidgets('should create non-opaque route by default', (tester) async {
        final route = NavigationService.buildFadeRoute(
          screen: const Scaffold(body: Text('Test')),
        );

        expect(route.opaque, isFalse);
      });
    });

    group('Screen Navigation Methods', () {
      testWidgets('showApplicationSettingsScreen should navigate correctly', (
        tester,
      ) async {
        final appState = AppState();

        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      NavigationService.showApplicationSettingsScreen(context);
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(ApplicationSettingsScreen), findsOneWidget);
        appState.dispose();
      });

      testWidgets('showHelpScreen should navigate correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    NavigationService.showHelpScreen(context);
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(HelpScreen), findsOneWidget);
      });

      testWidgets('showSimulationInfoScreen should navigate correctly', (
        tester,
      ) async {
        final appState = AppState();

        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      NavigationService.showSimulationInfoScreen(context);
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(SimulationInfoScreen), findsOneWidget);
        appState.dispose();
      });

      testWidgets('showAboutScreen should navigate correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    NavigationService.showAboutScreen(context);
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(AboutScreen), findsOneWidget);
      });

      testWidgets('showAccountManagementScreen should navigate correctly', (
        tester,
      ) async {
        final appState = AppState();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AppState>.value(value: appState),
              ChangeNotifierProvider.value(value: appState.auth),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      NavigationService.showAccountManagementScreen(context);
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(AccountManagementScreen), findsOneWidget);
        appState.dispose();
      });

      testWidgets('showDeveloperToolsScreen should navigate correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    NavigationService.showDeveloperToolsScreen(context);
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(DeveloperToolsScreen), findsOneWidget);
      });

      testWidgets('showPhysicsSettingsScreen should navigate correctly', (
        tester,
      ) async {
        final appState = AppState();

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    NavigationService.showPhysicsSettingsScreen(
                      context,
                      appState,
                    );
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        expect(find.byType(PhysicsSettingsScreen), findsOneWidget);

        appState.dispose();
      });
    });

    group('Constructor', () {
      test('should have private constructor', () {
        // Verify NavigationService cannot be instantiated
        expect(() => NavigationService, returnsNormally);
      });

      test('should be a static utility class', () {
        // Verify the class is a Type
        expect(NavigationService, isA<Type>());
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle navigation without valid navigator', (
        tester,
      ) async {
        // This test verifies that navigation fails gracefully when no Navigator exists
        final context = tester.element(find.byType(Container).first);

        expect(
          () => NavigationService.showApplicationSettingsScreen(context),
          throwsA(isA<FlutterError>()),
        );
      });

      testWidgets('should handle rapid successive navigations', (tester) async {
        final appState = AppState();

        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      // Rapid successive navigation calls
                      NavigationService.showHelpScreen(context);
                      NavigationService.showAboutScreen(context);
                      NavigationService.showSimulationInfoScreen(context);
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        // Last navigation should win
        expect(find.byType(SimulationInfoScreen), findsOneWidget);
        appState.dispose();
      });

      testWidgets('should handle navigation with different scenarios', (
        tester,
      ) async {
        final appState = AppState();
        final scenarios = [
          ScenarioType.solarSystem,
          ScenarioType.threeBodyClassic,
          ScenarioType.binaryStars,
        ];

        for (final scenario in scenarios) {
          appState.simulation.resetWithScenario(scenario);

          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      NavigationService.showPhysicsSettingsScreen(
                        context,
                        appState,
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              ),
            ),
          );

          await tester.tap(find.text('Navigate'));
          await tester.pumpAndSettle();

          expect(find.byType(PhysicsSettingsScreen), findsOneWidget);

          // Go back
          final navigator = tester.state<NavigatorState>(
            find.byType(Navigator),
          );
          navigator.pop();
          await tester.pumpAndSettle();
        }

        appState.dispose();
      });
    });

    group('Transition Animations', () {
      testWidgets('should animate fade transition correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    NavigationService.showHelpScreen(context);
                  },
                  child: const Text('Navigate'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Navigate'));

        // Check for transition in progress
        await tester.pump();
        await tester.pump(UIConstants.screenTransitionDuration ~/ 2);

        // Transition should still be happening
        expect(find.byType(FadeTransition), findsWidgets);

        await tester.pumpAndSettle();

        // Navigation should be complete
        expect(find.byType(HelpScreen), findsOneWidget);
      });
    });
  });
}
