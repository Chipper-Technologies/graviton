import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';

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
        icon: Icons.smart_button,
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
        highlightArea: const Rect.fromLTWH(-50, 0, 100, 100),
        action: TutorialAction.highlightScenarioButton,
      ),
      TutorialStep(
        title: l10n.tutorialExploreTitle,
        description: l10n.tutorialExploreDescription,
        icon: Icons.explore,
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
      case 2: // smart_button - Controls
        return AppColors.accretionGold;
      case 3: // videocam - Camera
        return AppColors.celestialBlue;
      case 4: // science - Scenarios
        return AppColors.spaceVibrantPurple;
      case 5: // explore - Explore
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
            color: Colors.black.withValues(alpha: 0.8),
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
                    child: GestureDetector(
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
                      child: Material(
                        borderRadius: BorderRadius.circular(16),
                        elevation: 8,
                        color: theme.colorScheme.surface,
                        child: Container(
                          margin: const EdgeInsets.all(32),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Step indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_steps.length, (index) {
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
                                                .withValues(alpha: 0.3),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 8),

                              // Swipe hint
                              Text(
                                'Swipe left/right or use buttons to navigate',
                                style: AppTypography.smallText.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),

                              // Icon or Logo
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                child: step.isLogoStep
                                    ? Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/images/app-logo.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        step.icon,
                                        size: 48,
                                        color: _getIconColor(_currentStep),
                                      ),
                              ),
                              const SizedBox(height: 24),

                              // Title
                              Text(
                                step.title,
                                style: AppTypography.titleText.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),

                              // Description - left aligned
                              SizedBox(
                                width: double.infinity,
                                child: _buildDescriptionText(
                                  step.description,
                                  theme,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Navigation buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Skip button
                                  TextButton(
                                    onPressed: _skipTutorial,
                                    child: Text(l10n.skipTutorial),
                                  ),

                                  // Previous/Next buttons
                                  Row(
                                    children: [
                                      if (_currentStep > 0)
                                        TextButton(
                                          onPressed: _previousStep,
                                          style: TextButton.styleFrom(
                                            foregroundColor: _getIconColor(
                                              _currentStep,
                                            ),
                                          ),
                                          child: Text(l10n.previous),
                                        ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: _nextStep,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _getIconColor(
                                            _currentStep,
                                          ),
                                          foregroundColor: Colors.white,
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build description text with proper list formatting
  Widget _buildDescriptionText(String description, ThemeData theme) {
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

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Rect? highlightArea;
  final TutorialAction? action;
  final bool isLogoStep;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    this.highlightArea,
    this.action,
    this.isLogoStep = false,
  });
}

enum TutorialAction {
  highlightAppBar,
  highlightBottomControls,
  highlightScenarioButton,
}

class HighlightPainter extends CustomPainter {
  final Rect highlightArea;

  HighlightPainter(this.highlightArea);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(highlightArea, const Radius.circular(8)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
