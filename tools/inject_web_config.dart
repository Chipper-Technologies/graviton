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

  // Determine which index.html to modify
  // If build/web/index.html exists, modify it (post-build)
  // Otherwise modify web/index.html (pre-build)
  final buildIndexHtmlPath = 'build/web/index.html';
  final sourceIndexHtmlPath = 'web/index.html';

  final buildIndexHtmlFile = File(buildIndexHtmlPath);
  final sourceIndexHtmlFile = File(sourceIndexHtmlPath);

  final targetFile = buildIndexHtmlFile.existsSync()
      ? buildIndexHtmlFile
      : sourceIndexHtmlFile;

  if (!targetFile.existsSync()) {
    exit(1);
  }

  var indexHtmlContent = targetFile.readAsStringSync();

  // Replace template variable
  indexHtmlContent = indexHtmlContent.replaceAll(
    r'$GOOGLE_WEB_CLIENT_ID',
    googleWebClientId,
  );

  // Add console silencing script for production builds
  if (environment == 'prod' &&
      !indexHtmlContent.contains('Silence console logs in production')) {
    const consoleSilenceScript = '''
<script>
    // Silence console logs in production
    (function() {
      if (typeof window === 'undefined') return;
      
      // Store original console methods
      const originalError = console.error;
      const originalWarn = console.warn;
      
      // Suppress all standard logging
      console.log = function() {};
      console.debug = function() {};
      console.info = function() {};
      
      // Filter console.warn to suppress browser violations/interventions
      console.warn = function(...args) {
        const message = args.join(' ');
        
        // Filter out performance violations and interventions
        if (message.includes('Violation') ||
            message.includes('Intervention') ||
            message.includes('requestAnimationFrame') ||
            message.includes('navigator.vibrate')) {
          return;
        }
        
        // Pass through other warnings
        originalWarn.apply(console, args);
      };
      
      // Filter console.error to suppress known non-critical messages
      console.error = function(...args) {
        const message = args.join(' ');
        
        // Filter out known Flutter/browser noise
        if (message.includes('Intervention') ||
            message.includes('Violation') ||
            message.includes('requestAnimationFrame') ||
            message.includes('TrustedTypes') ||
            message.includes('service worker') ||
            message.includes('Loading from existing') ||
            message.includes('navigator.vibrate')) {
          return;
        }
        
        // Pass through actual errors
        originalError.apply(console, args);
      };
    })();
  </script>''';

    // Inject before closing </head> tag
    indexHtmlContent = indexHtmlContent.replaceFirst(
      '</head>',
      '$consoleSilenceScript\n</head>',
    );
  }

  // Write back to the target file
  targetFile.writeAsStringSync(indexHtmlContent);
}
