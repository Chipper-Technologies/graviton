#!/usr/bin/env dart

/// Script to restore template variables in web/index.html.
///
/// This should be run before committing to avoid hardcoding credentials.
///
/// Usage: `dart run tools/restore_web_template.dart`
library;

import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  final indexHtmlPath = 'web/index.html';
  final indexHtmlFile = File(indexHtmlPath);

  if (!indexHtmlFile.existsSync()) {
    debugPrint('Error: web/index.html not found');
    exit(1);
  }

  var indexHtmlContent = indexHtmlFile.readAsStringSync();

  // Replace any hardcoded Google client ID with template variable
  final googleClientIdPattern = RegExp(
    r'<meta name="google-signin-client_id" content="([^"]+)"',
  );

  if (googleClientIdPattern.hasMatch(indexHtmlContent)) {
    indexHtmlContent = indexHtmlContent.replaceAll(
      googleClientIdPattern,
      r'<meta name="google-signin-client_id" content="$GOOGLE_WEB_CLIENT_ID"',
    );

    indexHtmlFile.writeAsStringSync(indexHtmlContent);
    debugPrint('✓ Restored template variable in web/index.html');
  } else {
    debugPrint('✓ web/index.html already has template variable');
  }
}
