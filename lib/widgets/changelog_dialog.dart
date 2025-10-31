import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/changelog.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextChangelog() {
    if (_currentIndex < widget.changelogs.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _complete();
    }
  }

  void _previousChangelog() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
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
    final theme = Theme.of(context);

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
          child: Container(
            color: AppColors.uiBlack.withValues(alpha: 0.8),
            child: SafeArea(
              child: Center(
                child: GestureDetector(
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
                  child: Material(
                    borderRadius: BorderRadius.circular(
                      AppTypography.radiusXLarge,
                    ),
                    elevation: 8,
                    color: theme.colorScheme.surface,
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                        maxHeight: 700,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppTypography.radiusXLarge,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with version info
                          _buildHeader(context, l10n, changelog),

                          SizedBox(height: AppTypography.spacingLarge),

                          // Step indicators
                          _buildStepIndicators(context),

                          SizedBox(height: AppTypography.spacingLarge),

                          // Changelog content (scrollable)
                          Expanded(
                            child: _buildChangelogContent(
                              context,
                              l10n,
                              changelog,
                            ),
                          ),

                          SizedBox(height: AppTypography.spacingLarge),

                          // Navigation buttons
                          _buildNavigationButtons(context, l10n),
                        ],
                      ),
                    ),
                  ),
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

    return Column(
      children: [
        // Close button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.changelogTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.sectionTitlePurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _skip,
              icon: const Icon(Icons.close),
              tooltip: l10n.closeDialog,
            ),
          ],
        ),

        SizedBox(height: AppTypography.spacingMedium),

        // Version and date
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.celestialGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            border: Border.all(
              color: AppColors.celestialGold.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                changelog.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.celestialGold,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.changelogReleaseDate(
                  dateFormat.format(changelog.releaseDate),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicators(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.changelogs.length, (index) {
        final isActive = index == _currentIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.celestialGold
                : AppColors.uiTextGrey.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
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
            const SizedBox(height: 8),
            ...changelog.addedFeatures.map(
              (entry) => _buildChangelogEntry(context, entry),
            ),
            const SizedBox(height: 16),
          ],

          // Improvements
          if (changelog.improvements.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              l10n.changelogImproved,
              Icons.trending_up,
              AppColors.celestialGold,
            ),
            const SizedBox(height: 8),
            ...changelog.improvements.map(
              (entry) => _buildChangelogEntry(context, entry),
            ),
            const SizedBox(height: 16),
          ],

          // Fixes
          if (changelog.fixes.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              l10n.changelogFixed,
              Icons.bug_report,
              AppColors.uiOrange,
            ),
            const SizedBox(height: 8),
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

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                  const SizedBox(height: 4),
                  Text(
                    entry.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
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
        // Skip button
        TextButton(onPressed: _skip, child: Text(l10n.changelogSkip)),

        // Previous/Next buttons
        Row(
          children: [
            if (_currentIndex > 0)
              TextButton(
                onPressed: _previousChangelog,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.celestialGold,
                ),
                child: Text(l10n.previous),
              ),
            const SizedBox(width: AppTypography.spacingSmall),
            ElevatedButton(
              onPressed: _nextChangelog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.celestialGold,
                foregroundColor: AppColors.uiWhite,
              ),
              child: Text(
                _currentIndex == widget.changelogs.length - 1
                    ? l10n.changelogDone
                    : l10n.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
