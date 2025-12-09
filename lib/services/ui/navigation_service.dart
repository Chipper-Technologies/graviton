import 'package:flutter/material.dart';
import 'package:graviton/core/constants/ui_constants.dart';
import 'package:graviton/core/enums/scenario_type.dart';
import 'package:graviton/core/enums/ui_action.dart';
import 'package:graviton/core/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/changelog/changelog.dart';
import 'package:graviton/features/about/presentation/screens/about_screen.dart';
import 'package:graviton/features/account/presentation/screens/account_management_screen.dart';
import 'package:graviton/features/settings/presentation/screens/application_settings_screen.dart';
import 'package:graviton/features/developer_tools/presentation/screens/developer_tools_screen.dart';
import 'package:graviton/features/help/presentation/screens/help_screen.dart';
import 'package:graviton/features/settings/presentation/screens/physics_settings_screen.dart';
import 'package:graviton/features/scenarios/presentation/screens/scenario_selection_screen.dart';
import 'package:graviton/features/simulation/presentation/screens/simulation_info_screen.dart';
import 'package:graviton/services/platform/changelog_service.dart';
import 'package:graviton/features/scenarios/data/custom_scenario_manager.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/services/ui/onboarding_service.dart';
import 'package:graviton/services/platform/version_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/shared/widgets/dialogs/auto_pause_dialog_wrapper.dart';
import 'package:graviton/shared/widgets/dialogs/changelog_dialog.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/overlays/tutorial_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// Service for handling navigation between screens with consistent patterns
///
/// Provides centralized navigation logic with:
/// - Consistent fade transitions
/// - Firebase analytics logging
/// - Error handling for navigation operations
/// - Reusable route builders
class NavigationService {
  /// Private constructor to prevent instantiation
  NavigationService._();

  /// Build a fade transition route for consistent screen transitions
  ///
  /// Parameters:
  /// - [screen]: The widget to navigate to
  /// - [opaque]: Whether the route is opaque (default: false)
  ///
  /// Returns a [PageRouteBuilder] with fade transition
  static PageRouteBuilder<T> buildFadeRoute<T>({
    required Widget screen,
    bool opaque = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: UIConstants.screenTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      opaque: opaque,
    );
  }

  /// Navigate to the scenario selection screen
  ///
  /// Handles scenario selection and custom scenario loading with proper
  /// error handling and camera adjustments.
  ///
  /// Parameters:
  /// - [context]: Build context for navigation
  /// - [appState]: Application state for scenario management
  /// - [onCinematicCameraReset]: Callback to reset cinematic camera controller
  static void showScenarioSelectionScreen(
    BuildContext context,
    AppState appState,
    VoidCallback onCinematicCameraReset,
  ) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.scenarioSelection,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScenarioSelectionScreen(
              currentScenario: appState.simulation.simulation.currentScenario,
              onScenarioSelected: (scenario) {
                final l10n = AppLocalizations.of(context)!;
                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.scenarioSelected,
                  element: UIElement.scenarioDialog,
                  value: scenario.name,
                );

                // Close the screen first to avoid navigator conflicts
                Navigator.of(context).pop();

                // Then perform the scenario switch with proper error handling
                try {
                  appState.simulation.resetWithScenario(scenario, l10n: l10n);
                  // Reset cinematic camera controller for new scenario
                  onCinematicCameraReset();

                  // Use a timer instead of post-frame callback for more reliable execution
                  Future.delayed(UIConstants.postNavigationDelay, () {
                    try {
                      // Auto-zoom camera to fit the new scenario
                      if (appState.simulation.bodies.isNotEmpty) {
                        appState.camera.resetViewForScenario(
                          scenario,
                          appState.simulation.bodies,
                        );
                      }
                    } catch (e) {
                      // Silently handle any camera reset errors
                      debugPrint('Camera reset error: $e');
                    }
                  });
                } catch (e) {
                  // Handle any simulation reset errors
                  debugPrint('Scenario switch error: $e');
                  appState.setError(
                    l10n.failedToSwitchScenarioError(e.toString()),
                  );
                }
              },
              onCustomScenarioSelected: (scenarioName) {
                final l10n = AppLocalizations.of(context)!;
                FirebaseService.instance.logUIEventWithEnums(
                  UIAction.scenarioSelected,
                  element: UIElement.scenarioDialog,
                  value: 'custom:$scenarioName',
                );

                // Close the screen first to avoid navigator conflicts
                Navigator.of(context).pop();

                // Load custom scenario
                _loadCustomScenario(
                  context,
                  scenarioName,
                  l10n,
                  appState,
                  onCinematicCameraReset,
                );
              },
            ),
        opaque: false,
        transitionDuration: UIConstants.screenTransitionDuration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Load a custom scenario with proper error handling
  ///
  /// Parameters:
  /// - [context]: Build context for showing messages
  /// - [scenarioName]: Name of the custom scenario to load
  /// - [l10n]: Localization strings
  /// - [appState]: Application state for scenario management
  /// - [onCinematicCameraReset]: Callback to reset cinematic camera controller
  static Future<void> _loadCustomScenario(
    BuildContext context,
    String scenarioName,
    AppLocalizations l10n,
    AppState appState,
    VoidCallback onCinematicCameraReset,
  ) async {
    try {
      // Load the custom scenario using the custom scenario manager
      final customManager = CustomScenarioManager.instance;
      await customManager.loadCustomScenario(scenarioName);

      // Switch to custom scenario type to trigger the custom scenario loading
      appState.simulation.resetWithScenario(ScenarioType.custom, l10n: l10n);

      // Reset cinematic camera controller for new scenario
      onCinematicCameraReset();

      // Use a timer instead of post-frame callback for more reliable execution
      Future.delayed(UIConstants.postNavigationDelay, () {
        try {
          // Auto-zoom camera to fit the new scenario
          if (appState.simulation.bodies.isNotEmpty) {
            appState.camera.resetViewForScenario(
              ScenarioType.custom,
              appState.simulation.bodies,
            );
          }
        } catch (e) {
          // Silently handle any camera reset errors
          debugPrint('Camera reset error: $e');
        }
      });

      // Show success message
      if (context.mounted) {
        GravitonSnackBar.success(
          context: context,
          message: l10n.accessibilityNewScenarioLoaded,
        );
      }
    } catch (e) {
      // Handle custom scenario loading errors
      debugPrint('Custom scenario loading error: $e');
      appState.setError(l10n.failedToSwitchScenarioError(e.toString()));
    }
  }

  /// Navigate to the application settings screen
  static void showApplicationSettingsScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.settings,
    );

    Navigator.of(
      context,
    ).push(buildFadeRoute(screen: const ApplicationSettingsScreen()));
  }

  /// Navigate to the help screen
  static void showHelpScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.help,
    );

    Navigator.of(context).push(buildFadeRoute(screen: const HelpScreen()));
  }

  /// Navigate to the simulation info screen
  static void showSimulationInfoScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.settings,
    );

    Navigator.of(
      context,
    ).push(buildFadeRoute(screen: const SimulationInfoScreen()));
  }

  /// Navigate to the about screen
  static void showAboutScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.about,
    );

    Navigator.of(context).push(buildFadeRoute(screen: const AboutScreen()));
  }

  /// Navigate to the account management screen
  static void showAccountManagementScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.accountManagement,
    );

    Navigator.of(context).push(
      buildFadeRoute(screen: const AccountManagementScreen(), opaque: true),
    );
  }

  /// Navigate to the developer tools screen
  static void showDeveloperToolsScreen(BuildContext context) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.developerTools,
    );

    Navigator.of(
      context,
    ).push(buildFadeRoute(screen: const DeveloperToolsScreen()));
  }

  /// Navigate to the physics settings screen
  ///
  /// Parameters:
  /// - [context]: Build context for navigation
  /// - [appState]: Application state containing physics settings
  static void showPhysicsSettingsScreen(
    BuildContext context,
    AppState appState,
  ) {
    final sim = appState.simulation.simulation;

    FirebaseService.instance.logUIEventWithEnums(
      UIAction.screenOpened,
      element: UIElement.physicsSettings,
    );

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: PhysicsSettingsScreen(
              gravitationalConstant: sim.gravitationalConstant,
              softening: sim.softening,
              timeScale: appState.simulation.timeScale,
              collisionRadiusMultiplier: sim.collisionRadiusMultiplier,
              maxTrailPoints: sim.maxTrail,
              trailFadeRate: sim.fadeRate,
              vibrationThrottleTime: sim.vibrationThrottleTime,
              vibrationEnabled: sim.vibrationEnabled,
              currentScenario: sim.currentScenario,
              onSettingsChanged: (settings) {
                // Settings are handled by the PhysicsSettingsScreen
              },
            ),
          );
        },
      ),
    );
  }

  /// Show the tutorial overlay
  ///
  /// Parameters:
  /// - [context]: Build context for showing the dialog
  /// - [onTutorialCompleted]: Callback when tutorial is completed
  static void showTutorial(
    BuildContext context,
    VoidCallback onTutorialCompleted,
  ) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.tutorialStarted,
      element: UIElement.tutorial,
    );

    AutoPauseDialogWrapper.show<void>(
      context: context,
      barrierDismissible: false,
      child: TutorialOverlay(
        onComplete: () async {
          await OnboardingService.markTutorialCompleted();
          if (context.mounted) {
            Navigator.of(context).pop();
            onTutorialCompleted();
          }

          FirebaseService.instance.logUIEventWithEnums(
            UIAction.tutorialCompleted,
            element: UIElement.tutorial,
          );
        },
      ),
    );
  }

  /// Check if first-time user needs tutorial
  ///
  /// Parameters:
  /// - [context]: Build context for showing tutorial
  /// - [onTutorialCompleted]: Callback when tutorial is completed
  /// - [versionDialogWasShown]: Whether version dialog was already shown
  static Future<void> checkFirstTimeUser(
    BuildContext context,
    VoidCallback onTutorialCompleted, {
    bool versionDialogWasShown = false,
  }) async {
    final hasSeenTutorial = await OnboardingService.hasSeenTutorial();
    if (!hasSeenTutorial && context.mounted) {
      // Show tutorial after a short delay to let the app initialize
      Future.delayed(UIConstants.initializationDelay, () {
        if (context.mounted) {
          showTutorial(context, onTutorialCompleted);
        }
      });
    } else {
      // For existing users, check for new changelogs only if no version dialog was shown
      // This prevents dialog conflicts - if user needs to update, focus on that first
      if (!versionDialogWasShown) {
        Future.delayed(UIConstants.changelogCheckDelay, () {
          if (context.mounted) {
            checkForNewChangelogs(context);
          }
        });
      }
      // If version dialog was shown, skip changelog entirely to avoid overwhelming the user
    }
  }

  /// Check for new changelogs and show if available
  ///
  /// Parameters:
  /// - [context]: Build context for showing changelog dialog
  static Future<void> checkForNewChangelogs(BuildContext context) async {
    try {
      if (!context.mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);

      // Ensure version service is initialized
      await VersionService.instance.initialize();

      // Get current app version
      final currentVersion = VersionService.instance.appVersion;
      if (currentVersion.isEmpty) {
        return;
      }

      // Check if user should see changelog for this version
      if (!appState.ui.shouldShowChangelogFor(currentVersion)) {
        return; // Already seen changelog for this version
      }

      // Initialize and fetch changelogs using the shared method with fallback logic
      await ChangelogService.instance.initialize();

      final changelogsToShow = await ChangelogService.instance
          .fetchChangelogsWithFallback(currentVersion: currentVersion);

      if (changelogsToShow.isNotEmpty && context.mounted) {
        // Show changelog dialog with available changelogs
        showChangelogDialog(context, changelogsToShow);
      }
    } catch (e) {
      // Silently fail - app should continue normally
      debugPrint('Error checking for new changelogs: $e');
    }
  }

  /// Show the changelog dialog
  ///
  /// Parameters:
  /// - [context]: Build context for showing the dialog
  /// - [changelogs]: List of changelog versions to display
  static void showChangelogDialog(
    BuildContext context,
    List<ChangelogVersion> changelogs,
  ) {
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.changelogShown,
      element: UIElement.changelog,
    );

    AutoPauseDialogWrapper.show<void>(
      context: context,
      barrierDismissible: false,
      child: ChangelogDialog(
        changelogs: changelogs,
        onComplete: () async {
          if (context.mounted) {
            Navigator.of(context).pop();

            // Mark the latest changelog version as seen
            final appState = Provider.of<AppState>(context, listen: false);
            final currentVersion = VersionService.instance.appVersion;
            appState.ui.setLastSeenChangelogVersion(currentVersion);
          }

          FirebaseService.instance.logUIEventWithEnums(
            UIAction.changelogCompleted,
            element: UIElement.changelog,
          );
        },
      ),
    );
  }

  /// Show the current version changelog manually
  ///
  /// Parameters:
  /// - [context]: Build context for showing the dialog
  static Future<void> showCurrentVersionChangelog(BuildContext context) async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Initialize changelog service
      await ChangelogService.instance.initialize();

      // Get changelogs for current version
      final changelogsToShow = await ChangelogService.instance
          .fetchChangelogsWithFallback(currentVersion: currentVersion);

      if (changelogsToShow.isNotEmpty && context.mounted) {
        // Show changelog dialog with available changelogs
        showChangelogDialog(context, changelogsToShow);
      } else {
        // Show a simple message if no changelog available
        if (context.mounted) {
          GravitonSnackBar.info(
            context: context,
            message: 'No changelog available for this version',
          );
        }
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        GravitonSnackBar.error(
          context: context,
          message: AppLocalizations.of(
            context,
          )!.errorLoadingChangelogEHome(e.toString()),
        );
      }
    }
  }
}
