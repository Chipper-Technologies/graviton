import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/utils/semantics/semantic_utils.dart';

/// A widget that provides live region announcements for accessibility
/// when values change, with configurable announcement intervals
class SemanticLiveRegion extends StatefulWidget {
  final Widget child;
  final String currentValue;
  final String dataType;
  final Duration announcementInterval;

  const SemanticLiveRegion({
    super.key,
    required this.child,
    required this.currentValue,
    required this.dataType,
    this.announcementInterval = const Duration(seconds: 5),
  });

  @override
  State<SemanticLiveRegion> createState() => _SemanticLiveRegionState();
}

class _SemanticLiveRegionState extends State<SemanticLiveRegion> {
  String? _lastAnnouncedValue;
  DateTime _lastAnnouncementTime = DateTime.now();

  @override
  void didUpdateWidget(SemanticLiveRegion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentValue != oldWidget.currentValue &&
        SemanticUtils.shouldAnnounce(
          _lastAnnouncementTime,
          widget.announcementInterval,
        )) {
      _announceChange();
    }
  }

  void _announceChange() {
    _lastAnnouncedValue = widget.currentValue;
    _lastAnnouncementTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return widget.child;

    final shouldAnnounce =
        _lastAnnouncedValue != widget.currentValue &&
        SemanticUtils.shouldAnnounce(
          _lastAnnouncementTime,
          widget.announcementInterval,
        );

    return Semantics(
      liveRegion: shouldAnnounce,
      label: shouldAnnounce
          ? SemanticUtils.createLiveUpdate(
              l10n,
              widget.dataType,
              widget.currentValue,
            )
          : null,
      child: widget.child,
    );
  }
}
