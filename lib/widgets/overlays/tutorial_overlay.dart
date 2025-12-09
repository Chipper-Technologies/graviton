import 'package:flutter/material.dart';
import 'package:graviton/config/flavor_config.dart';
import 'package:graviton/core/constants/rendering_constants.dart';
import 'package:graviton/core/enums/tutorial_action.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/ui/tutorial_step.dart';
import 'package:graviton/shared/painters/highlight_painter.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/haptics/haptic_elevated_button.dart';
import 'package:graviton/widgets/haptics/haptic_gesture_detector.dart';
import 'package:graviton/widgets/haptics/haptic_text_button.dart';

/// Tutorial overlay that guides new users through the app
class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({super.key, required this.onComplete});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentStep = 0;

  final List<TutorialStep> _steps = [];

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTutorialSteps();
  }

  void _initializeTutorialSteps() {
    final l10n = AppLocalizations.of(context)!;

    _steps.clear();
    _steps.addAll([
      TutorialStep(
        title: l10n.tutorialWelcomeTitle,
        description: l10n.tutorialWelcomeDescription,
        icon: Icons.rocket_launch,
        isLogoStep: true, // Special flag for the welcome step
        highlightArea: null,
        action: null,
      ),
      TutorialStep(
        title: l10n.tutorialObjectivesTitle,
        description: l10n.tutorialObjectivesDescription,
        icon: Icons.school,
        highlightArea: null,
        action: null,
      ),
      TutorialStep(
        title: l10n.tutorialControlsTitle,
        description: l10n.tutorialControlsDescription,
        icon: Icons.play_circle_filled,
        highlightArea: const Rect.fromLTWH(0, 0, double.infinity, 100),
        action: TutorialAction.highlightAppBar,
      ),
      TutorialStep(
        title: l10n.tutorialCameraTitle,
        description: l10n.tutorialCameraDescription,
        icon: Icons.videocam,
        highlightArea: const Rect.fromLTWH(0, -100, double.infinity, 100),
        action: TutorialAction.highlightBottomControls,
      ),
      TutorialStep(
        title: l10n.tutorialScenariosTitle,
        description: l10n.tutorialScenariosDescription,
        icon: Icons.science,
        highlightArea: const Rect.fromLTWH(-80, 0, 160, 100),
        action: TutorialAction.highlightAppBar,
      ),
      TutorialStep(
        title: l10n.tutorialExploreTitle,
        description: l10n.tutorialExploreDescription,
        icon: Icons.touch_app,
        highlightArea: null,
        action: null,
      ),
    ]);
  }

  /// Returns a different color for each tutorial icon
  Color _getIconColor(int stepIndex) {
    switch (stepIndex) {
      case 0: // rocket_launch - Launch/Welcome
        return AppColors.gravitonOrangeRed;
      case 1: // school - Objectives/Learning
        return AppColors.celestialTeal;
      case 2: // play_circle_filled - Simulation Controls
        return AppColors.accretionGold;
      case 3: // videocam - Camera & View Controls
        return AppColors.celestialBlue;
      case 4: // science - Scenarios
        return AppColors.spaceVibrantPurple;
      case 5: // touch_app - Body Properties & Physics
        return AppColors.celestialAmber;
      default:
        return AppColors.primaryColor; // Fallback
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeTutorial();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _completeTutorial() {
    _animationController.reverse().then((_) {
      widget.onComplete();
    });
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final step = _steps[_currentStep];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityVeryHigh,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Highlight area (if specified)
                  if (step.highlightArea != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: HighlightPainter(step.highlightArea!),
                      ),
                    ),

                  // Tutorial content
                  Center(
                    child: HapticGestureDetector(
                      onPanEnd: (details) {
                        // Detect swipe direction
                        if (details.velocity.pixelsPerSecond.dx > 300) {
                          // Swipe right - go to previous step
                          _previousStep();
                        } else if (details.velocity.pixelsPerSecond.dx < -300) {
                          // Swipe left - go to next step
                          _nextStep();
                        }
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: RenderingConstants.tutorialOverlayMaxWidth,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                            AppTypography.radiusXLarge,
                          ),
                          elevation: 8,
                          color: theme.colorScheme.surface,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppTypography.radiusXLarge,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Step indicator
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(_steps.length, (
                                      index,
                                    ) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: index == _currentStep
                                              ? _getIconColor(_currentStep)
                                              : theme.colorScheme.onSurface
                                                    .withValues(
                                                      alpha: AppTypography
                                                          .opacityFaint,
                                                    ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(
                                    height: AppTypography.spacingSmall,
                                  ),

                                  // Swipe hint
                                  Text(
                                    l10n.tutorialNavigationHint,
                                    style: AppTypography.smallText.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(
                                            alpha:
                                                AppTypography.opacityMediumHigh,
                                          ),
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: AppTypography.spacingLarge,
                                  ),

                                  // Icon or Logo
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.primary
                                          .withValues(
                                            alpha: AppTypography.opacitySubtle,
                                          ),
                                    ),
                                    child: step.isLogoStep
                                        ? Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  AppConfig.appLogoPath,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            step.icon,
                                            size:
                                                AppTypography.iconSizeXXXXLarge,
                                            color: _getIconColor(_currentStep),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: AppTypography.spacingXXLarge,
                                  ),

                                  // Title
                                  Text(
                                    step.title,
                                    style: AppTypography.titleText.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: AppTypography.spacingLarge,
                                  ),

                                  // Description - left aligned
                                  SizedBox(
                                    width: double.infinity,
                                    child: _buildDescriptionText(
                                      step.description,
                                      theme,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppTypography.spacingXXXLarge,
                                  ),

                                  // Navigation buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Skip button
                                      HapticTextButton(
                                        onPressed: _skipTutorial,
                                        child: Text(l10n.skipTutorial),
                                      ),

                                      // Previous/Next buttons
                                      Row(
                                        children: [
                                          if (_currentStep > 0)
                                            HapticTextButton(
                                              onPressed: _previousStep,
                                              style: TextButton.styleFrom(
                                                foregroundColor: _getIconColor(
                                                  _currentStep,
                                                ),
                                              ),
                                              child: Text(l10n.previous),
                                            ),
                                          const SizedBox(
                                            width: AppTypography.spacingSmall,
                                          ),
                                          HapticElevatedButton(
                                            onPressed: _nextStep,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _getIconColor(
                                                _currentStep,
                                              ),
                                              foregroundColor:
                                                  AppColors.uiWhite,
                                            ),
                                            child: Text(
                                              _currentStep == _steps.length - 1
                                                  ? l10n.getStarted
                                                  : l10n.next,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ), // End Column
                            ), // End SingleChildScrollView
                          ),
                        ), // End Material
                      ), // End ConstrainedBox
                    ), // End HapticGestureDetector
                  ), // End Center
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build description text with proper list formatting and menu icon support
  Widget _buildDescriptionText(String description, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    // Check if this description needs to be split for menu icon display
    bool needsSplitForMenuIcon = false;
    String? part1;
    String? part2;

    // Controls step (step 2)
    if (description == l10n.tutorialControlsDescription) {
      needsSplitForMenuIcon = true;
      part1 = l10n.tutorialControlsDescriptionPart1;
      part2 = l10n.tutorialControlsDescriptionPart2;
    }
    // Scenarios step (step 4)
    else if (description == l10n.tutorialScenariosDescription) {
      needsSplitForMenuIcon = true;
      part1 = l10n.tutorialScenariosDescriptionPart1;
      part2 = l10n.tutorialScenariosDescriptionPart2;
    }

    // If we need to split for menu icon, create special layout
    if (needsSplitForMenuIcon && part1 != null && part2 != null) {
      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: AppTypography.largeText.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurface,
            decoration: TextDecoration.none,
          ),
          children: [
            TextSpan(text: part1),
            TextSpan(text: ' '), // Space before icon
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(
                    alpha: AppTypography.opacityDisabled,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppTypography.radiusSmall,
                  ),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(
                      alpha: AppTypography.opacityFaint,
                    ),
                    width: AppTypography.borderThin,
                  ),
                ),
                child: Icon(
                  Icons.more_vert,
                  size: AppTypography.iconSizeMedium,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            TextSpan(text: ' '), // Space after icon
            TextSpan(text: part2),
          ],
        ),
      );
    }

    // Check if this is a list (contains bullets or numbers)
    final bool isBulletList = description.contains('•');
    final bool isNumberedList = description.contains(RegExp(r'\d\.'));
    final bool isList = isBulletList || isNumberedList;

    if (!isList) {
      // Regular text - left aligned for consistency
      return Text(
        description,
        style: AppTypography.largeText.copyWith(
          height: 1.5,
          color: theme.colorScheme.onSurface,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.left,
      );
    }

    // Split into lines and create properly formatted list
    final lines = description.split('\n');
    final List<Widget> listItems = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      listItems.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i < lines.length - 1 ? 6.0 : 0, // More space between items
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Extract the bullet/number and text
              if (isBulletList && line.startsWith('•'))
                ..._buildBulletItem(line, theme)
              else if (isNumberedList && line.contains(RegExp(r'^\d\.')))
                ..._buildNumberedItem(line, theme)
              else
                ..._buildFallbackItem(line, theme),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listItems,
    );
  }

  /// Build bullet list item
  List<Widget> _buildBulletItem(String line, ThemeData theme) {
    return [
      Text(
        '• ',
        style: AppTypography.largeText.copyWith(
          height: 1.5,
          color: theme.colorScheme.primary,
        ),
      ),
      Expanded(
        child: Text(
          line.substring(2), // Remove the bullet
          style: AppTypography.largeText.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurface,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    ];
  }

  /// Build numbered list item
  List<Widget> _buildNumberedItem(String line, ThemeData theme) {
    final match = RegExp(r'^(\d\.\s*)(.*)').firstMatch(line);
    if (match != null) {
      return [
        Text(
          match.group(1)!, // The number part
          style: AppTypography.largeText.copyWith(
            height: 1.5,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        Expanded(
          child: Text(
            match.group(2)!, // The text part
            style: AppTypography.largeText.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ];
    } else {
      return _buildFallbackItem(line, theme);
    }
  }

  /// Build fallback item for malformed list items
  List<Widget> _buildFallbackItem(String line, ThemeData theme) {
    return [
      Expanded(
        child: Text(
          line,
          style: AppTypography.largeText.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurface,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    ];
  }
}
