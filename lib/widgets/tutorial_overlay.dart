import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';

/// Tutorial overlay widget (stub implementation)
class TutorialOverlay extends StatelessWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                Text(l10n.tutorialOverlayTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(l10n.tutorialOverlayDescription, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: onComplete, child: Text(l10n.continueButton)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
