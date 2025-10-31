import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graviton/state/app_state.dart';
import 'package:provider/provider.dart';

/// A wrapper widget that automatically pauses the simulation when a dialog is opened
/// and resumes it when the dialog is closed (if it was running before).
class AutoPauseDialogWrapper extends StatefulWidget {
  final Widget child;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;

  const AutoPauseDialogWrapper({
    super.key,
    required this.child,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
  });

  /// Show a dialog with automatic pause/resume behavior
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (context) => AutoPauseDialogWrapper(
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        child: child,
      ),
    );
  }

  @override
  State<AutoPauseDialogWrapper> createState() => _AutoPauseDialogWrapperState();
}

class _AutoPauseDialogWrapperState extends State<AutoPauseDialogWrapper> {
  bool _wasRunningBeforePause = false;
  AppState? _appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Store reference to AppState during didChangeDependencies
    // as recommended by Flutter for use in dispose()
    try {
      _appState = Provider.of<AppState>(context, listen: false);
    } catch (e) {
      _appState = null;
    }
  }

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _appState != null) {
        _pauseSimulationIfRunning();
      }
    });
  }

  @override
  void dispose() {
    // Schedule resume for next frame using stored reference to avoid context issues
    if (_wasRunningBeforePause && _appState != null) {
      scheduleMicrotask(() {
        _appState!.simulation.resumeSimulation();
      });
    }
    super.dispose();
  }

  void _pauseSimulationIfRunning() {
    if (_appState == null) return;

    // Record if simulation was running and not paused before we pause it
    _wasRunningBeforePause =
        _appState!.simulation.isRunning && !_appState!.simulation.isPaused;

    // Pause the simulation if it's currently running
    if (_wasRunningBeforePause) {
      _appState!.simulation.pauseSimulation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
