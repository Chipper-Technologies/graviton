import 'package:flutter/material.dart';
import 'package:graviton/services/ui/semantic_focus_service.dart';

/// Main semantic wrapper that provides focus navigation shortcuts for the entire app
class SemanticAppWrapper extends StatelessWidget {
  final Widget child;

  const SemanticAppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SemanticFocusService.instance.createFocusScope(
      autofocus: true,
      child: SemanticFocusService.instance.createFocusKeyboardShortcuts(
        child: child,
      ),
    );
  }
}
