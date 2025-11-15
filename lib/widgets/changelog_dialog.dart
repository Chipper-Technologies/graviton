import 'package:flutter/material.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:graviton/widgets/common/dialog_title.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_icon_button.dart';
import 'package:intl/intl.dart';

/// Dialog that displays changelogs with swipe navigation
class ChangelogDialog extends StatefulWidget {
  final List<ChangelogVersion> changelogs;
  final VoidCallback onComplete;

  const ChangelogDialog({
    super.key,
    required this.changelogs,
    required this.onComplete,
  });

  @override
  State<ChangelogDialog> createState() => _ChangelogDialogState();
}

class _ChangelogDialogState extends State<ChangelogDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Track changelog dialog opening
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.changelogShown,
      element: UIElement.changelogViewer,
      value: 'changelog_opened',
      additionalParams: {
        'changelog_count': widget.changelogs.length.toString(),
        'latest_version': widget.changelogs.isNotEmpty
            ? widget.changelogs.first.version
            : 'unknown',
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextChangelog() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--; // Go to newer version (lower index)
      });
    } else {
      _complete();
    }
  }

  void _previousChangelog() {
    if (_currentIndex < widget.changelogs.length - 1) {
      setState(() {
        _currentIndex++; // Go to older version (higher index)
      });
    }
  }

  void _complete() {
    _animationController.reverse().then((_) {
      widget.onComplete();
    });
  }

  void _skip() {
    _complete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.changelogs.isEmpty) {
      // Auto-close if no changelogs
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete();
      });
      return const SizedBox.shrink();
    }

    final changelog = widget.changelogs[_currentIndex];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
            ),
            child: HapticGestureDetector(
              onPanEnd: (details) {
                // Detect swipe direction
                if (details.velocity.pixelsPerSecond.dx > 300) {
                  // Swipe right - go to previous changelog
                  _previousChangelog();
                } else if (details.velocity.pixelsPerSecond.dx < -300) {
                  // Swipe left - go to next changelog
                  _nextChangelog();
                }
              },
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 700,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with colored background
                    _buildHeader(context, l10n, changelog),

                    // Changelog content (scrollable)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: AppTypography.spacingLarge,
                          right: AppTypography.spacingLarge,
                          bottom: AppTypography.spacingLarge,
                        ),
                        child: _buildChangelogContent(context, l10n, changelog),
                      ),
                    ),

                    // Navigation buttons
                    Padding(
                      padding: EdgeInsets.all(AppTypography.spacingLarge),
                      child: _buildNavigationButtons(context, l10n),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    ChangelogVersion changelog,
  ) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityMidFade,
            ),
            AppColors.spaceVibrantPurple.withValues(
              alpha: AppTypography.opacityBarely,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTypography.radiusXLarge),
          topRight: Radius.circular(AppTypography.radiusXLarge),
        ),
      ),
      padding: EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        children: [
          // Title row with close button
          DialogTitle(
            title: l10n.changelogTitle,
            icon: Icons.assignment,
            iconColor: AppColors.primaryColor,
            iconSize: AppTypography.iconSizeXXXLarge,
            trailing: HapticIconButton(
              onPressed: _skip,
              icon: const Icon(Icons.close),
              tooltip: l10n.closeButton,
            ),
          ),

          SizedBox(height: AppTypography.spacingMedium),

          // Version and date info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacitySubtle,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
              border: Border.all(
                color: AppColors.primaryColor.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
              ),
            ),
            child: Column(
              children: [
                Text(
                  changelog.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTypography.spacingXSmall),
                Text(
                  '${l10n.versionLabel} ${changelog.version} • ${dateFormat.format(changelog.releaseDate)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityVeryHigh,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangelogContent(
    BuildContext context,
    AppLocalizations l10n,
    ChangelogVersion changelog,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Added features
          if (changelog.addedFeatures.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              l10n.changelogAdded,
              Icons.add_circle,
              AppColors.uiGreen,
            ),
            const SizedBox(height: AppTypography.spacingSmall),
            ...changelog.addedFeatures.map(
              (entry) => _buildChangelogEntry(context, entry),
            ),
            const SizedBox(height: AppTypography.spacingLarge),
          ],

          // Improvements
          if (changelog.improvements.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              l10n.changelogImproved,
              Icons.trending_up,
              AppColors.spaceVibrantPurple,
            ),
            const SizedBox(height: AppTypography.spacingSmall),
            ...changelog.improvements.map(
              (entry) => _buildChangelogEntry(context, entry),
            ),
            const SizedBox(height: AppTypography.spacingLarge),
          ],

          // Fixes
          if (changelog.fixes.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              l10n.changelogFixed,
              Icons.bug_report,
              AppColors.uiOrange,
            ),
            const SizedBox(height: AppTypography.spacingSmall),
            ...changelog.fixes.map(
              (entry) => _buildChangelogEntry(context, entry),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: AppTypography.iconSizeXLarge, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangelogEntry(BuildContext context, ChangelogEntry entry) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppTypography.opacityMediumHigh,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.description != null) ...[
                  const SizedBox(height: AppTypography.spacingXSmall),
                  Text(
                    entry.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: AppTypography.opacityVeryHigh,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous/Next chevron buttons on the left
        Row(
          children: [
            // Previous button (chevron left)
            HapticIconButton(
              onPressed: _currentIndex < widget.changelogs.length - 1
                  ? _previousChangelog
                  : null,
              style: IconButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                disabledForegroundColor: AppColors.uiTextGrey.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
              ),
              icon: const Icon(Icons.chevron_left),
              tooltip: _currentIndex < widget.changelogs.length - 1
                  ? '${l10n.previous} (${widget.changelogs[_currentIndex + 1].version})'
                  : null,
            ),
            // Next button (chevron right)
            HapticIconButton(
              onPressed: _currentIndex > 0 ? _nextChangelog : null,
              style: IconButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                disabledForegroundColor: AppColors.uiTextGrey.withValues(
                  alpha: AppTypography.opacityFaint,
                ),
              ),
              icon: Icon(Icons.chevron_right),
              tooltip: _currentIndex > 0
                  ? '${l10n.next} (${widget.changelogs[_currentIndex - 1].version})'
                  : null,
            ),
          ],
        ),

        // Done button on the right
        HapticElevatedButton(
          onPressed: _complete,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.uiWhite,
          ),
          child: Text(l10n.changelogDone),
        ),
      ],
    );
  }
}
