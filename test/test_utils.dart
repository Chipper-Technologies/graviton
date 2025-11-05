import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Test utilities for widget testing
class TestUtils {
  /// Wraps a widget with MaterialApp and localization support for testing
  static Widget wrapWithMaterialApp({required Widget child, ThemeData? theme}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  /// Wraps a widget with MaterialApp in a Scaffold for drawer testing
  static Widget wrapWithScaffold({
    required Widget child,
    Widget? endDrawer,
    ThemeData? theme,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: Scaffold(body: child, endDrawer: endDrawer),
    );
  }
}
