// Premium feature exports
//
// This barrel file exports all premium-related classes for convenient imports.

// Core
export 'package:graviton/core/enums/premium_tier.dart';
export 'package:graviton/core/constants/premium_constants.dart';

// Domain models
export 'package:graviton/features/premium/domain/premium_feature.dart';
export 'package:graviton/features/premium/domain/premium_limits.dart';
export 'package:graviton/features/premium/domain/premium_pricing.dart';
export 'package:graviton/features/premium/domain/targeted_discount.dart';
export 'package:graviton/features/premium/domain/usage_data.dart';

// Data services
export 'package:graviton/features/premium/data/premium_service.dart';
export 'package:graviton/features/premium/data/usage_tracking_service.dart';

// Presentation
export 'package:graviton/features/premium/presentation/premium_state.dart';
export 'package:graviton/features/premium/presentation/paywall_screen.dart';

// Widgets
export 'package:graviton/features/premium/presentation/widgets/default_locked_indicator.dart';
export 'package:graviton/features/premium/presentation/widgets/premium_gate.dart';
export 'package:graviton/features/premium/presentation/widgets/premium_overlay.dart';
export 'package:graviton/features/premium/presentation/widgets/session_timer_widget.dart';
export 'package:graviton/features/premium/presentation/widgets/upgrade_banner.dart';
