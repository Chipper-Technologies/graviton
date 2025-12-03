#!/usr/bin/env dart

/// Script to inject configuration values into web/index.html at build time.
///
/// Usage: `dart run tools/inject_web_config.dart <config-file>`
///
/// Example: `dart run tools/inject_web_config.dart config/dev-web.json`
library;

import 'dart:io';
import 'dart:convert';

void main(List<String> args) {
  if (args.isEmpty) {
    exit(1);
  }

  final configPath = args[0];
  final configFile = File(configPath);

  if (!configFile.existsSync()) {
    exit(1);
  }

  // Read config file
  final configJson = jsonDecode(configFile.readAsStringSync());
  final googleWebClientId = configJson['google.webClientId'] as String?;

  if (googleWebClientId == null) {
    exit(1);
  }

  // Read index.html
  final indexHtmlPath = 'web/index.html';
  final indexHtmlFile = File(indexHtmlPath);

  if (!indexHtmlFile.existsSync()) {
    exit(1);
  }

  var indexHtmlContent = indexHtmlFile.readAsStringSync();

  // Replace template variable
  indexHtmlContent = indexHtmlContent.replaceAll(
    r'$GOOGLE_WEB_CLIENT_ID',
    googleWebClientId,
  );

  // Write back to index.html
  indexHtmlFile.writeAsStringSync(indexHtmlContent);
}
