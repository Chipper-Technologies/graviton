// Copyright (c) 2025 Chipper Technologies, LLC. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/flavor_config.dart';
import 'enums/app_flavor.dart';
import 'enums/firebase_event.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';
import 'services/remote_config_service.dart';
import 'services/version_service.dart';
import 'state/app_state.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'widgets/dev_ribbon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    await Firebase.initializeApp();
    await FirebaseService.instance.initialize();
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue without Firebase functionality');
  }

  // Initialize remote config service
  try {
    await RemoteConfigService.instance.initialize();
    debugPrint('Remote config service initialized successfully');
  } catch (e) {
    debugPrint('Remote config service initialization failed: $e');
  }

  // Initialize version service
  try {
    await VersionService.instance.initialize();
    debugPrint('Version service initialized successfully');
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

    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          // Determine the locale to use
          Locale? locale;
          if (appState.ui.selectedLanguageCode != null) {
            locale = Locale(appState.ui.selectedLanguageCode!);
          }
          // If null, Flutter will use system locale

          return MaterialApp(
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
