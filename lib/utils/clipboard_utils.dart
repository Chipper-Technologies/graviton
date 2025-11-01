import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Utility functions for clipboard operations and user feedback
class ClipboardUtils {
  ClipboardUtils._(); // Private constructor to prevent instantiation

  /// Copy text to clipboard and show a snackbar with confirmation
  static void copyToClipboard(
    BuildContext context,
    String text, {
    AppLocalizations? l10n,
    Duration duration = const Duration(seconds: 2),
  }) {
    Clipboard.setData(ClipboardData(text: text));

    final localizations = l10n ?? AppLocalizations.of(context);
    if (localizations != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.copiedToClipboard(text)),
          duration: duration,
        ),
      );
    }
  }

  /// Copy text to clipboard without showing any user feedback
  static Future<void> copyToClipboardSilent(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Get text from clipboard
  static Future<String?> getFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text;
  }

  /// Check if clipboard contains text
  static Future<bool> hasText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text?.isNotEmpty ?? false;
    } catch (e) {
      return false;
    }
  }
}
