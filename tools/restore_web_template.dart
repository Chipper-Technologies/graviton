#!/usr/bin/env dart

/// Script to restore template variables in web/index.html.
///
/// This should be run before committing to avoid hardcoding credentials.
///
/// Usage: `dart run tools/restore_web_template.dart`
library;

import 'dart:io';

void main() {
  final indexHtmlPath = 'web/index.html';
  final indexHtmlFile = File(indexHtmlPath);

  if (!indexHtmlFile.existsSync()) {
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
  }
}
