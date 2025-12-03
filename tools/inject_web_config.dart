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
  final environment = configJson['environment'] as String? ?? 'dev';

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

  // Add console silencing script for production builds
  final consoleSilenceScript = environment == 'prod'
      ? '''
<script>
    // Silence console logs in production
    if (typeof window !== 'undefined') {
      // Store original console methods for critical errors
      const originalError = console.error;
      
      // Override console methods to suppress logs
      console.log = function() {};
      console.debug = function() {};
      console.info = function() {};
      console.warn = function() {};
      
      // Keep critical errors but suppress common Flutter/Firebase noise
      console.error = function(...args) {
        const message = args.join(' ');
        // Filter out known non-critical messages
        if (message.includes('Intervention') ||
            message.includes('Violation') ||
            message.includes('requestAnimationFrame') ||
            message.includes('TrustedTypes') ||
            message.includes('service worker') ||
            message.includes('Loading from existing')) {
          return;
        }
        // Pass through actual errors
        originalError.apply(console, args);
      };
    }
  </script>'''
      : '';

  indexHtmlContent = indexHtmlContent.replaceAll(
    '<!-- CONSOLE_SILENCE_SCRIPT -->',
    consoleSilenceScript,
  );

  // Write back to index.html
  indexHtmlFile.writeAsStringSync(indexHtmlContent);
}
