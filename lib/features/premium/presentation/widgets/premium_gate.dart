import 'package:flutter/material.dart';
import 'package:graviton/features/premium/domain/premium_feature.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:graviton/features/premium/presentation/widgets/default_locked_indicator.dart';
import 'package:provider/provider.dart';

/// Widget that conditionally renders content based on premium access
///
/// Shows [child] if user has access to the specified feature.
/// Shows [lockedChild] or default locked indicator if user doesn't have access.
///
/// Example:
/// ```dart
/// PremiumGate(
///   feature: PremiumFeature.cameraSync,
///   child: CameraSyncToggle(),
///   lockedChild: UpgradePrompt(),
/// )
/// ```
class PremiumGate extends StatelessWidget {
  /// The premium feature to check
  final PremiumFeature feature;

  /// Widget to show when user has access
  final Widget child;

  /// Widget to show when user doesn't have access
  final Widget? lockedChild;

  /// Whether to hide the widget entirely when locked (instead of showing lockedChild)
  final bool hideWhenLocked;

  /// Callback when locked content is tapped
  final VoidCallback? onLockedTap;

  const PremiumGate({
    required this.feature,
    required this.child,
    this.lockedChild,
    this.hideWhenLocked = false,
    this.onLockedTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumState>(
      builder: (context, premiumState, _) {
        if (premiumState.canUseFeature(feature)) {
          return child;
        }

        if (hideWhenLocked) {
          return const SizedBox.shrink();
        }

        if (lockedChild != null) {
          return GestureDetector(onTap: onLockedTap, child: lockedChild!);
        }

        // Default locked indicator
        return GestureDetector(
          onTap: onLockedTap,
          child: DefaultLockedIndicator(feature: feature),
        );
      },
    );
  }
}
