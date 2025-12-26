import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/enums/firebase_event.dart';
import 'package:graviton/core/enums/stripe_price_tier.dart';
import 'package:graviton/features/premium/data/stripe_web_service.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/services/firebase/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/features/premium/presentation/premium_state.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Paywall screen for purchasing premium subscriptions
///
/// Displays available subscription options with pricing and benefits.
/// Handles purchase flow and restore purchases functionality.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  /// Show the paywall as a bottom sheet
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (context) => const PaywallScreen(),
    );
  }

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int _selectedIndex = 1; // Default to annual

  @override
  void initState() {
    super.initState();
    // Log paywall opened
    FirebaseService.instance.logEventWithEnum(
      FirebaseEvent.paywallOpened,
      parameters: {'source': 'bottom_sheet'},
    );
  }

  @override
  void dispose() {
    // Log paywall closed
    FirebaseService.instance.logEventWithEnum(FirebaseEvent.paywallClosed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PremiumState>(
      builder: (context, premiumState, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppTypography.radiusLarge),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: AppTypography.spacingLarge,
                    right: AppTypography.spacingLarge,
                    top: AppTypography.spacingLarge,
                    bottom:
                        AppTypography.spacingLarge +
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      _buildBenefitsList(context),
                      const SizedBox(height: AppTypography.spacingXLarge),
                      _buildSubscriptionOptions(context, premiumState),
                      const SizedBox(height: AppTypography.spacingLarge),
                      _buildPurchaseButton(context, premiumState),
                      const SizedBox(height: AppTypography.spacingMedium),
                      _buildRestoreButton(context, premiumState),
                      const SizedBox(height: AppTypography.spacingXSmall),
                      _buildLegalText(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppTypography.spacingLarge),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppTypography.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.uiWhite.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTypography.spacingSmall),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.premiumPrimary,
                      AppColors.premiumSecondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.uiWhite,
                  size: AppTypography.iconSizeLarge,
                ),
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.premiumTitle,
                      style: const TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.premiumSubtitle,
                      style: const TextStyle(
                        color: AppColors.uiTextGrey,
                        fontSize: AppTypography.fontSizeMedium,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: AppColors.uiWhite.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final benefits = [
      _Benefit(
        icon: Icons.all_inclusive,
        title: l10n.premiumBenefitUnlimitedDuration,
        description: l10n.premiumBenefitUnlimitedDurationDesc,
      ),
      _Benefit(
        icon: Icons.groups,
        title: l10n.premiumBenefitViewers(25),
        description: l10n.premiumBenefitViewersDesc,
      ),
      _Benefit(
        icon: Icons.videocam,
        title: l10n.premiumBenefitCameraSync,
        description: l10n.premiumBenefitCameraSyncDesc,
      ),
      _Benefit(
        icon: Icons.lock,
        title: l10n.premiumBenefitPassword,
        description: l10n.premiumBenefitPasswordDesc,
      ),
      _Benefit(
        icon: Icons.repeat,
        title: l10n.premiumBenefitUnlimitedSessions,
        description: l10n.premiumBenefitUnlimitedSessionsDesc,
      ),
    ];

    return Column(
      children: benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTypography.spacingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTypography.spacingSmall),
                decoration: BoxDecoration(
                  color: AppColors.premiumPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusSmall,
                  ),
                ),
                child: Icon(
                  benefit.icon,
                  color: AppColors.premiumAccent,
                  size: AppTypography.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit.title,
                      style: const TextStyle(
                        color: AppColors.uiWhite,
                        fontSize: AppTypography.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      benefit.description,
                      style: TextStyle(
                        color: AppColors.uiWhite.withValues(alpha: 0.6),
                        fontSize: AppTypography.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.uiWhite,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.uiGreen,
                  size: AppTypography.iconSizeLarge,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionOptions(
    BuildContext context,
    PremiumState premiumState,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final pricing = premiumState.pricing;
    final hasDiscount = pricing.hasDiscount;

    return Column(
      children: [
        // Monthly
        _SubscriptionOption(
          index: 0,
          isSelected: _selectedIndex == 0,
          title: l10n.premiumPlanMonthly,
          price: hasDiscount
              ? '\$${pricing.discountedMonthlyPrice.toStringAsFixed(2)}'
              : '\$${pricing.monthlyPriceUsd.toStringAsFixed(2)}',
          period: l10n.premiumPeriodMonth,
          originalPrice: hasDiscount
              ? '\$${pricing.monthlyPriceUsd.toStringAsFixed(2)}'
              : null,
          badge: null,
          onTap: () => setState(() => _selectedIndex = 0),
        ),
        const SizedBox(height: AppTypography.spacingMedium),
        // Yearly
        _SubscriptionOption(
          index: 1,
          isSelected: _selectedIndex == 1,
          title: l10n.premiumPlanYearly,
          price: hasDiscount
              ? '\$${pricing.discountedYearlyPrice.toStringAsFixed(2)}'
              : '\$${pricing.yearlyPriceUsd.toStringAsFixed(2)}',
          period: l10n.premiumPeriodYear,
          originalPrice: hasDiscount
              ? '\$${pricing.yearlyPriceUsd.toStringAsFixed(2)}'
              : null,
          badge: l10n.premiumSavePercent(
            pricing.yearlySavingsPercentage.toStringAsFixed(0),
          ),
          onTap: () => setState(() => _selectedIndex = 1),
        ),
        const SizedBox(height: AppTypography.spacingMedium),
        // Lifetime
        _SubscriptionOption(
          index: 2,
          isSelected: _selectedIndex == 2,
          title: l10n.premiumPlanLifetime,
          price: hasDiscount
              ? '\$${pricing.discountedLifetimePrice.toStringAsFixed(2)}'
              : '\$${pricing.lifetimePriceUsd.toStringAsFixed(2)}',
          period: l10n.premiumPeriodOneTime,
          originalPrice: hasDiscount
              ? '\$${pricing.lifetimePriceUsd.toStringAsFixed(2)}'
              : null,
          badge: l10n.premiumBestValue,
          badgeColor: AppColors.premiumGold,
          onTap: () => setState(() => _selectedIndex = 2),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton(BuildContext context, PremiumState premiumState) {
    final l10n = AppLocalizations.of(context)!;

    // On web, use Stripe
    if (kIsWeb) {
      return _buildStripePurchaseButton(context, premiumState, l10n);
    }

    // On mobile, use RevenueCat
    final Package? package = switch (_selectedIndex) {
      0 => premiumState.monthlyPackage,
      1 => premiumState.annualPackage,
      2 => premiumState.lifetimePackage,
      _ => null,
    };

    final isLoading = premiumState.isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || package == null
            ? null
            : () async {
                final navigator = Navigator.of(context);
                final success = await premiumState.purchasePackage(package);
                if (!mounted) return;
                if (success) {
                  navigator.pop(true);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.premiumPrimary,
          foregroundColor: AppColors.uiWhite,
          padding: const EdgeInsets.symmetric(
            vertical: AppTypography.spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.uiWhite),
                ),
              )
            : Text(
                _selectedIndex == 2
                    ? l10n.premiumBuyNow
                    : l10n.premiumStartFreeTrial,
                style: const TextStyle(
                  fontSize: AppTypography.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildStripePurchaseButton(
    BuildContext context,
    PremiumState premiumState,
    AppLocalizations l10n,
  ) {
    final isLoading = premiumState.isLoading;
    final user = FirebaseAuth.instance.currentUser;
    final stripeTier = switch (_selectedIndex) {
      0 => StripePriceTier.monthly,
      1 => StripePriceTier.yearly,
      2 => StripePriceTier.lifetime,
      _ => StripePriceTier.yearly,
    };

    final isConfigured = StripeWebService.isConfigured;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || user == null || !isConfigured
            ? null
            : () async {
                final messenger = ScaffoldMessenger.of(context);
                final redirectingMessage = l10n.premiumRedirectingToPayment;
                final success = await StripeWebService.launchCheckout(
                  tier: stripeTier,
                  userId: user.uid,
                  email: user.email,
                );
                if (!mounted) return;
                if (success) {
                  // Show message that user will be redirected
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(redirectingMessage),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.premiumPrimary,
          foregroundColor: AppColors.uiWhite,
          padding: const EdgeInsets.symmetric(
            vertical: AppTypography.spacingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.uiWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: AppTypography.iconSizeMedium,
                  ),
                  const SizedBox(width: AppTypography.spacingSmall),
                  Text(
                    _selectedIndex == 2
                        ? l10n.premiumBuyNow
                        : l10n.premiumStartFreeTrial,
                    style: const TextStyle(
                      fontSize: AppTypography.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRestoreButton(BuildContext context, PremiumState premiumState) {
    final l10n = AppLocalizations.of(context)!;

    // On web, restore works by refreshing from Stripe
    if (kIsWeb) {
      return _buildStripeRestoreButton(context, premiumState, l10n);
    }

    return TextButton(
      onPressed: premiumState.isLoading
          ? null
          : () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final success = await premiumState.restorePurchases();
              if (!mounted) return;
              if (success) {
                navigator.pop(true);
              } else {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.premiumNoPurchasesToRestore),
                    backgroundColor: AppColors.uiRed,
                  ),
                );
              }
            },
      child: Text(
        l10n.premiumRestorePurchases,
        style: TextStyle(
          color: AppColors.uiWhite.withValues(alpha: 0.7),
          fontSize: AppTypography.fontSizeMedium,
        ),
      ),
    );
  }

  Widget _buildStripeRestoreButton(
    BuildContext context,
    PremiumState premiumState,
    AppLocalizations l10n,
  ) {
    return TextButton(
      onPressed: premiumState.isLoading
          ? null
          : () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              // Try to verify purchase from Stripe
              final success = await StripeWebService.verifyPurchase();
              if (!mounted) return;

              if (success) {
                // Refresh premium state
                await premiumState.refreshPremiumStatus();
                if (!mounted) return;
                navigator.pop(true);
              } else {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.premiumNoPurchasesToRestore),
                    backgroundColor: AppColors.uiRed,
                  ),
                );
              }
            },
      child: Text(
        l10n.premiumRestorePurchases,
        style: TextStyle(
          color: AppColors.uiWhite.withValues(alpha: 0.7),
          fontSize: AppTypography.fontSizeMedium,
        ),
      ),
    );
  }

  Widget _buildLegalText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.premiumLegalText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.uiWhite.withValues(alpha: 0.4),
            fontSize: AppTypography.fontSizeXSmall,
          ),
        ),
        const SizedBox(height: AppTypography.spacingSmall),
        GestureDetector(
          onTap: _openSubscriptionManagement,
          child: Text(
            l10n.premiumManageSubscriptions,
            style: TextStyle(
              color: AppColors.premiumAccent,
              fontSize: AppTypography.fontSizeSmall,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.premiumAccent,
            ),
          ),
        ),
      ],
    );
  }

  /// Opens the platform-specific subscription management page
  Future<void> _openSubscriptionManagement() async {
    late final Uri uri;

    if (kIsWeb) {
      // On web, open Stripe billing portal
      final billingPortalUrl = AppConfig.stripeBillingPortalUrl;
      if (billingPortalUrl.isEmpty) return;
      uri = Uri.parse(billingPortalUrl);
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      // On iOS/macOS, open App Store subscriptions
      uri = Uri.parse('https://apps.apple.com/account/subscriptions');
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // On Android, open Play Store subscriptions
      uri = Uri.parse('https://play.google.com/store/account/subscriptions');
    } else {
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Benefit {
  final IconData icon;
  final String title;
  final String description;

  _Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _SubscriptionOption extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String title;
  final String price;
  final String period;
  final String? originalPrice;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _SubscriptionOption({
    required this.index,
    required this.isSelected,
    required this.title,
    required this.price,
    required this.period,
    this.originalPrice,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Build semantic label for accessibility
    final semanticLabel = StringBuffer()
      ..write(title)
      ..write(', ')
      ..write(price)
      ..write(period);
    if (badge != null) {
      semanticLabel.write(', $badge');
    }
    if (originalPrice != null) {
      semanticLabel.write(', was $originalPrice');
    }
    if (isSelected) {
      semanticLabel.write(', selected');
    }

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticLabel.toString(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppTypography.spacingMedium),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.premiumPrimary.withValues(alpha: 0.15)
                : AppColors.spaceGradientDark.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? AppColors.premiumPrimary
                  : AppColors.uiWhite.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.premiumPrimary
                        : AppColors.uiWhite.withValues(alpha: 0.2),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.uiWhite,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.uiWhite
                                  : AppColors.uiWhite.withValues(alpha: 0.8),
                              fontSize: AppTypography.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: AppTypography.spacingSmall),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTypography.spacingSmall,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor ?? AppColors.uiGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge!,
                                style: const TextStyle(
                                  color: AppColors.uiWhite,
                                  fontSize: AppTypography.fontSizeXSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (originalPrice != null)
                        Text(
                          originalPrice!,
                          style: TextStyle(
                            color: AppColors.uiWhite.withValues(alpha: 0.4),
                            fontSize: AppTypography.fontSizeSmall,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              ExcludeSemantics(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.premiumAccent
                              : AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: period,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(alpha: 0.6),
                          fontSize: AppTypography.fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
