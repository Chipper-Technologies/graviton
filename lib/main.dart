// Copyright (c) 2025 Chipper Technologies LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/flavor_config.dart';
import 'firebase/firebase_options.dart';
import 'package:graviton/core/constants/platform_channel_constants.dart';
import 'package:graviton/core/enums/app_flavor.dart';
import 'package:graviton/core/enums/firebase_event.dart';
import 'l10n/app_localizations.dart';
import 'package:graviton/features/about/presentation/screens/about_screen.dart';
import 'package:graviton/features/settings/presentation/screens/application_settings_screen.dart';
import 'package:graviton/features/help/presentation/screens/help_screen.dart';
import 'package:graviton/features/home/presentation/screens/home_screen.dart';
import 'services/firebase/app_check_service.dart';
import 'package:graviton/features/auth/data/auth_service.dart';
import 'services/platform/changelog_service.dart';
import 'services/firebase/firebase_service.dart';
import 'package:graviton/shared/widgets/dialogs/changelog_dialog.dart';
import 'services/firebase/remote_config_service.dart';
import 'services/platform/version_service.dart';
import 'state/app_state.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'package:graviton/widgets/common/dev_ribbon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable all debug print statements in release mode
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  // Set up platform channel for macOS menu integration
  _setupPlatformChannels();

  // Detect flavor from dart-define or default to production
  final flavorString = const String.fromEnvironment(
    'environment',
    defaultValue: 'prod',
  );
  final flavor = AppFlavor.values.firstWhere(
    (f) => f.toString().split('.').last == flavorString,
    orElse: () => AppFlavor.prod,
  );

  // Initialize flavor configuration
  FlavorConfig.instance.initialize(flavor: flavor);

  // Initialize Firebase (optional - don't block app startup if it fails)
  try {
    // Check if Firebase is already initialized (e.g., from hot restart)
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (duplicateAppError) {
      // Firebase was already initialized (race condition or hot restart)
    }

    // Initialize remote config service BEFORE App Check
    // App Check depends on Remote Config for the appCheckEnabled flag
    await RemoteConfigService.instance.initialize();

    await AppCheckService.instance.initialize();
    await FirebaseService.instance.initialize();
    await AuthService.instance.initialize();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize version service
  try {
    await VersionService.instance.initialize();
  } catch (e) {
    debugPrint('Version service initialization failed: $e');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize app state with settings
  final appState = AppState();
  await appState.initializeAsync();
  appState.simulation.start();

  runApp(GravitonApp(appState: appState));
}

// Global navigator key to access navigation from platform channels
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void _setupPlatformChannels() {
  // Navigation channel
  const navigationChannel = MethodChannel(PlatformChannelConstants.navigation);
  navigationChannel.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'showAbout':
        // Navigate to About screen
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          );
        }
        break;
      case 'showSettings':
        // Navigate to Application Settings screen
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplicationSettingsScreen(),
            ),
          );
        }
        break;
      case 'showHelp':
        // Navigate to Help screen
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpScreen()),
          );
        }
        break;
      case 'showChangelog':
        // Show changelog dialog
        final context = navigatorKey.currentContext;
        if (context != null) {
          // Fetch changelogs and show dialog
          ChangelogService.instance.fetchChangelogs().then((changelogs) {
            if (context.mounted && changelogs.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => ChangelogDialog(
                  changelogs: changelogs,
                  onComplete: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
          });
        }
        break;
      default:
        throw PlatformException(
          code: 'UNIMPLEMENTED',
          message: 'Method ${call.method} not implemented',
        );
    }
  });

  // Note: Simulation channel is handled by HomeScreen._setupSimulationChannel()
  // since it needs access to the home screen context for UI operations like
  // showing the tutorial overlay and body selection sheet. The handler in
  // HomeScreen will override any handler set here.
}

class GravitonApp extends StatelessWidget {
  final AppState appState;

  const GravitonApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    // Log app start
    FirebaseService.instance.logEventWithEnum(
      FirebaseEvent.appStart,
      parameters: {'flavor': FlavorConfig.instance.flavor.name},
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: appState.auth),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          // Determine the locale to use
          Locale? locale;
          if (appState.ui.selectedLanguageCode != null) {
            locale = Locale(appState.ui.selectedLanguageCode!);
          }
          // If null, Flutter will use system locale

          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: FlavorConfig.instance.appName,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            navigatorObservers: FirebaseService.instance.analytics != null
                ? [
                    FirebaseAnalyticsObserver(
                      analytics: FirebaseService.instance.analytics!,
                    ),
                  ]
                : [],
            theme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primaryColor,
              ),
              // Enhanced focus indicators for accessibility
              focusColor: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacitySemiTransparent,
              ),
              // Enhanced button focus styling
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.focused)) {
                      return AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMedium,
                      );
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityVeryFaint,
                      );
                    }
                    return AppColors.transparentColor;
                  }),
                ),
              ),
              // Enhanced icon button focus styling
              iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.focused)) {
                      return AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityMedium,
                      );
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return AppColors.primaryColor.withValues(
                        alpha: AppTypography.opacityVeryFaint,
                      );
                    }
                    return AppColors.transparentColor;
                  }),
                ),
              ),
              sliderTheme: const SliderThemeData(
                showValueIndicator: ShowValueIndicator.onDrag,
              ),
              segmentedButtonTheme: SegmentedButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.uiWhite;
                    }
                    return AppColors.primaryColor;
                  }),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primaryColor;
                    }
                    return AppColors.transparentColor;
                  }),
                ),
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColors.spaceDeepBlueBlack.withValues(
                  alpha: AppTypography.opacityNearlyOpaque,
                ),
                contentTextStyle: const TextStyle(
                  color: AppColors.uiWhite,
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                ),
                actionTextColor: AppColors.primaryColor,
                actionOverflowThreshold: 0.25,
                disabledActionTextColor: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusLarge,
                  ),
                  side: BorderSide(
                    color: AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacitySemiTransparent,
                    ),
                    width: 1,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                elevation: 12,
                showCloseIcon: false,
                closeIconColor: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
              ),
            ),
            home: const DevRibbon(child: HomeScreen()),
          );
        },
      ),
    );
  }
}
