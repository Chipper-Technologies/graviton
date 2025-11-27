#!/usr/bin/env dart

/// Script to inject configuration values into web/index.html at build time
/// Usage: dart run tools/inject_web_config.dart <config-file>
/// Example: dart run tools/inject_web_config.dart config/dev-web.json

import 'dart:io';
import 'dart:convert';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run tools/inject_web_config.dart <config-file>');
    print('Example: dart run tools/inject_web_config.dart config/dev-web.json');
    exit(1);
  }

  final configPath = args[0];
  final configFile = File(configPath);

  if (!configFile.existsSync()) {
    print('Error: Config file not found: $configPath');
    exit(1);
  }

  // Read config file
  final configJson = jsonDecode(configFile.readAsStringSync());
  final googleWebClientId = configJson['google.webClientId'] as String?;

  if (googleWebClientId == null) {
    print('Error: google.webClientId not found in config file');
    exit(1);
  }

  // Read index.html
  final indexHtmlPath = 'web/index.html';
  final indexHtmlFile = File(indexHtmlPath);

  if (!indexHtmlFile.existsSync()) {
    print('Error: web/index.html not found');
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

  print('✓ Injected Google Web Client ID into web/index.html');
  print('  Client ID: $googleWebClientId');
}
