import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

/// A welcome message widget that provides quick objectives and guidance
class WelcomeMessageCard extends StatelessWidget {
  final VoidCallback? onTutorial;
  final VoidCallback? onDismiss;

  const WelcomeMessageCard({super.key, this.onTutorial, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.uiBlackOverlay,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.rocket_launch,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.tutorialWelcomeTitle,
                  style: AppTypography.largeText.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Explore gravitational physics through interactive simulations. Try different scenarios, adjust controls, and watch the cosmos unfold!',
            style: AppTypography.mediumText.copyWith(height: 1.4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (onTutorial != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTutorial,
                    icon: const Icon(Icons.school, size: 16),
                    label: const Text('Quick Tutorial'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              if (onTutorial != null && onDismiss != null)
                const SizedBox(width: 8),
              if (onDismiss != null)
                Expanded(
                  child: TextButton(
                    onPressed: onDismiss,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Got it!'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
