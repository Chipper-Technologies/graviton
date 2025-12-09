import 'package:flutter/material.dart';
import 'package:graviton/core/enums/integrity_failure_reason.dart';
import 'package:graviton/models/security/play_integrity_exception.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Helper utilities for displaying Play Integrity error messages to users.
///
/// This utility provides methods to extract user-friendly, localized error
/// messages from Play Integrity exceptions, including specific guidance based
/// on the failure reason and support reference IDs for debugging.
///
/// Example usage in a widget:
/// ```dart
/// try {
///   await playIntegrityService.verifyWithEnforcement(...);
/// } on IntegrityVerificationFailedException catch (e) {
///   if (mounted) {
///     IntegrityErrorHelper.showErrorDialog(
///       context: context,
///       exception: e,
///     );
///   }
/// }
/// ```
class IntegrityErrorHelper {
  /// Show an error dialog with user-friendly Play Integrity error messages.
  ///
  /// Displays a comprehensive error dialog with:
  /// - Localized title based on failure reason
  /// - User-friendly error message
  /// - Specific guidance for resolving the issue
  /// - Support reference ID for debugging
  static Future<void> showErrorDialog({
    required BuildContext context,
    required IntegrityVerificationFailedException exception,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getErrorTitle(l10n, exception)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getErrorMessage(l10n, exception)),
                const SizedBox(height: 16),
                Text(
                  getErrorGuidance(l10n, exception),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Support Reference: ${exception.supportReference}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.closeButton),
            ),
          ],
        );
      },
    );
  }

  /// Get localized error title based on failure reason.
  static String getErrorTitle(
    AppLocalizations l10n,
    IntegrityVerificationFailedException exception,
  ) {
    // Use the exception's titleKey which maps to the specific failure reason
    switch (exception.failureReason) {
      case IntegrityFailureReason.deviceIntegrity:
        return l10n.integrityErrorDeviceIntegrityTitle;
      case IntegrityFailureReason.appIntegrity:
        return l10n.integrityErrorAppIntegrityTitle;
      case IntegrityFailureReason.networkError:
        return l10n.integrityErrorNetworkTitle;
      case IntegrityFailureReason.backendVerificationFailed:
        return l10n.integrityErrorBackendVerificationTitle;
      case IntegrityFailureReason.tokenRequestFailed:
        return l10n.integrityErrorTokenRequestTitle;
      case IntegrityFailureReason.unknown:
        return l10n.integrityErrorUnknownTitle;
    }
  }

  /// Get localized error message based on failure reason.
  static String getErrorMessage(
    AppLocalizations l10n,
    IntegrityVerificationFailedException exception,
  ) {
    switch (exception.failureReason) {
      case IntegrityFailureReason.deviceIntegrity:
        return l10n.integrityErrorDeviceIntegrity;
      case IntegrityFailureReason.appIntegrity:
        return l10n.integrityErrorAppIntegrity;
      case IntegrityFailureReason.networkError:
        return l10n.integrityErrorNetwork;
      case IntegrityFailureReason.backendVerificationFailed:
        return l10n.integrityErrorBackendVerification;
      case IntegrityFailureReason.tokenRequestFailed:
        return l10n.integrityErrorTokenRequest;
      case IntegrityFailureReason.unknown:
        return l10n.integrityErrorUnknown;
    }
  }

  /// Get localized guidance for resolving the error.
  ///
  /// Includes the support reference ID in the guidance text.
  static String getErrorGuidance(
    AppLocalizations l10n,
    IntegrityVerificationFailedException exception,
  ) {
    final reference = exception.supportReference;

    switch (exception.failureReason) {
      case IntegrityFailureReason.deviceIntegrity:
        return l10n.integrityGuidanceDeviceIntegrity(reference);
      case IntegrityFailureReason.appIntegrity:
        return l10n.integrityGuidanceAppIntegrity(reference);
      case IntegrityFailureReason.networkError:
        return l10n.integrityGuidanceNetwork(reference);
      case IntegrityFailureReason.backendVerificationFailed:
        return l10n.integrityGuidanceBackendVerification(reference);
      case IntegrityFailureReason.tokenRequestFailed:
        return l10n.integrityGuidanceTokenRequest(reference);
      case IntegrityFailureReason.unknown:
        return l10n.integrityGuidanceUnknown(reference);
    }
  }

  /// Show a snackbar with brief error information.
  ///
  /// Use this for less critical errors or when a dialog would be too intrusive.
  static void showErrorSnackBar({
    required BuildContext context,
    required IntegrityVerificationFailedException exception,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final message = getErrorMessage(l10n, exception);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l10n.closeButton,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Get an appropriate icon for the failure reason.
  ///
  /// Useful for displaying in error UI to provide visual context.
  static IconData getErrorIcon(IntegrityVerificationFailedException exception) {
    switch (exception.failureReason) {
      case IntegrityFailureReason.deviceIntegrity:
        return Icons.phonelink_erase; // Device security issue
      case IntegrityFailureReason.appIntegrity:
        return Icons.warning; // App installation issue
      case IntegrityFailureReason.networkError:
        return Icons.wifi_off; // Network error
      case IntegrityFailureReason.backendVerificationFailed:
        return Icons.cloud_off; // Backend/server issue
      case IntegrityFailureReason.tokenRequestFailed:
        return Icons.vpn_key_off; // Token/authentication issue
      case IntegrityFailureReason.unknown:
        return Icons.error_outline; // Unknown error
    }
  }
}
