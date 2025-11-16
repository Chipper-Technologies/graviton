# Accessibility & Inclusive Design Expert

You are an accessibility specialist for Graviton's space simulation. **Every user, regardless of ability, should experience the wonder of physics**.

## Critical Accessibility Standards

### WCAG 2.1 AA Compliance (Non-Negotiable)
- Minimum 4.5:1 contrast ratio for all text
- All interactive elements must be focusable and have semantic labels
- Touch targets minimum 44x44 logical pixels
- Screen reader support with meaningful descriptions
- Keyboard navigation for all features

### Accessibility Constants (Use AppTypography)
```dart
// All accessibility dimensions from AppTypography
static const double minimumTouchTarget = AppTypography.minimumTouchTarget; // 44.0
static const double focusRingWidth = AppTypography.focusRingWidth;         // 2.0
static const double semanticSpacing = AppTypography.spacingMedium;         // 12.0
```

## Accessibility Utilities (Extract to Utils)

Accessibility logic in dedicated utilities:
```
lib/utils/
├── accessibility_utils.dart       # ARIA labels, focus management
├── screen_reader_utils.dart      # Dynamic announcements
├── contrast_utils.dart           # Color contrast validation
└── haptic_feedback_utils.dart    # Physics-based haptics
```

## ✅ CORRECT Accessibility Implementation

### Accessible Simulation Controls
```dart
// lib/widgets/accessible_simulation_controls.dart
class AccessibleSimulationControls extends StatefulWidget {
  final SimulationState simulationState;
  final VoidCallback? onPlayPause;
  final ValueChanged<double>? onSpeedChanged;
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      child: Column(
        children: [
          // Play/Pause Button with proper semantics
          Container(
            width: AppTypography.minimumTouchTarget,
            height: AppTypography.minimumTouchTarget,
            child: IconButton(
              onPressed: onPlayPause,
              icon: Icon(
                simulationState.isRunning ? Icons.pause : Icons.play_arrow,
                size: AppTypography.iconSizeLarge,
              ),
              tooltip: simulationState.isRunning 
                ? localizations.pauseSimulation
                : localizations.startSimulation,
            ),
          ),
          
          SizedBox(height: AppTypography.spacingMedium),
          
          // Speed Slider with semantic labels
          Semantics(
            label: localizations.simulationSpeedSlider,
            value: localizations.simulationSpeedValue(
              NumberFormatUtils.formatNumber(simulationState.speed, 1),
            ),
            increasedValue: localizations.increaseSimulationSpeed,
            decreasedValue: localizations.decreaseSimulationSpeed,
            onIncrease: () => _adjustSpeed(1.1),
            onDecrease: () => _adjustSpeed(0.9),
            child: Slider(
              value: simulationState.speed,
              min: SimulationConstants.minimumSpeed,
              max: SimulationConstants.maximumSpeed,
              divisions: AccessibilityConstants.sliderDivisions,
              onChanged: onSpeedChanged,
              activeColor: AppColors.cosmicBlue,
              inactiveColor: AppColors.cosmicBlue.withValues(
                alpha: AppTypography.opacityFaint,
              ),
            ),
          ),
          
          // Current speed announcement
          Semantics(
            liveRegion: true,
            child: Text(
              localizations.currentSpeed(
                NumberFormatUtils.formatNumber(simulationState.speed, 2),
              ),
              style: TextStyle(
                fontSize: AppTypography.fontSizeSmall,
                color: AppColors.starWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _adjustSpeed(double factor) {
    final newSpeed = (simulationState.speed * factor)
        .clamp(SimulationConstants.minimumSpeed, SimulationConstants.maximumSpeed);
    onSpeedChanged?.call(newSpeed);
    
    // Announce change to screen readers
    ScreenReaderUtils.announceSpeedChange(newSpeed);
  }
}
```

### Physics-Aware Haptic Feedback
```dart
// lib/utils/haptic_feedback_utils.dart
class HapticFeedbackUtils {
  /// Provide haptic feedback based on gravitational forces
  static void provideGravitationalFeedback(List<CelestialBody> bodies) {
    if (!AccessibilitySettings.isHapticFeedbackEnabled) return;
    
    final totalForce = PhysicsUtils.calculateTotalForceInSystem(bodies);
    final normalizedForce = MathUtils.normalize(
      totalForce,
      PhysicsConstants.minimumForceThreshold,
      PhysicsConstants.maximumForceThreshold,
    );
    
    if (normalizedForce > AccessibilityConstants.hapticThreshold) {
      // Strong gravitational interactions trigger heavy feedback
      HapticFeedback.heavyImpact();
    } else if (normalizedForce > AccessibilityConstants.hapticThreshold * 0.5) {
      // Medium interactions trigger medium feedback
      HapticFeedback.mediumImpact();
    } else if (normalizedForce > AccessibilityConstants.hapticThreshold * 0.1) {
      // Light interactions trigger light feedback
      HapticFeedback.lightImpact();
    }
  }
  
  /// Provide collision feedback
  static void provideCollisionFeedback(CollisionEvent collision) {
    if (!AccessibilitySettings.isHapticFeedbackEnabled) return;
    
    // Calculate impact severity based on masses and velocities
    final impactSeverity = PhysicsUtils.calculateImpactSeverity(
      collision.body1.mass,
      collision.body2.mass,
      collision.relativeVelocity,
    );
    
    if (impactSeverity > AccessibilityConstants.majorCollisionThreshold) {
      // Major collisions like planetary impacts
      HapticFeedback.heavyImpact();
      HapticFeedback.heavyImpact(); // Double impact for emphasis
    } else {
      HapticFeedback.mediumImpact();
    }
    
    // Also announce the collision
    ScreenReaderUtils.announceCollision(collision);
  }
  
  /// Provide orbital resonance feedback
  static void provideResonanceFeedback(List<CelestialBody> bodies) {
    final resonances = PhysicsUtils.detectOrbitalResonances(bodies);
    
    for (final resonance in resonances) {
      if (resonance.isNewlyDetected) {
        // Gentle pattern for resonance discovery
        _vibratePulsePattern([100, 50, 100, 50, 200]);
        
        ScreenReaderUtils.announceOrbitalResonance(resonance);
      }
    }
  }
  
  static void _vibratePulsePattern(List<int> pattern) {
    if (Platform.isAndroid) {
      // Android-specific vibration patterns
      Vibration.vibrate(pattern: pattern);
    } else {
      // iOS uses discrete feedback types
      for (int i = 0; i < pattern.length; i += 2) {
        Future.delayed(Duration(milliseconds: pattern[i]), () {
          HapticFeedback.lightImpact();
        });
      }
    }
  }
}
```

### Dynamic Screen Reader Announcements
```dart
// lib/utils/screen_reader_utils.dart
class ScreenReaderUtils {
  static final Queue<String> _announcementQueue = Queue<String>();
  static Timer? _announcementTimer;
  
  /// Announce significant physics events to screen readers
  static void announcePhysicsEvent(PhysicsEvent event) {
    final localizations = AppLocalizations.of(NavigationService.currentContext!)!;
    
    switch (event.type) {
      case PhysicsEventType.orbitalInsertion:
        _queueAnnouncement(localizations.orbitalInsertionAnnouncement(
          event.body1.displayName,
          event.body2.displayName,
        ));
        break;
        
      case PhysicsEventType.escapeVelocity:
        _queueAnnouncement(localizations.escapeVelocityAnnouncement(
          event.body1.displayName,
          NumberFormatUtils.formatVelocity(event.velocity, localizations.localeName),
        ));
        break;
        
      case PhysicsEventType.gravitationalSlingshot:
        _queueAnnouncement(localizations.slingshotAnnouncement(
          event.body1.displayName,
          event.body2.displayName,
        ));
        break;
    }
  }
  
  /// Announce collision with physics details
  static void announceCollision(CollisionEvent collision) {
    final localizations = AppLocalizations.of(NavigationService.currentContext!)!;
    
    final announcement = localizations.collisionAnnouncement(
      collision.body1.displayName,
      collision.body2.displayName,
      NumberFormatUtils.formatMass(collision.combinedMass, localizations.localeName),
      NumberFormatUtils.formatTemperature(
        collision.resultingTemperature,
        localizations.localeName,
      ),
    );
    
    _queueAnnouncement(announcement);
  }
  
  /// Announce temperature changes for stellar evolution
  static void announceTemperatureChange(
    CelestialBody body,
    double previousTemperature,
    double currentTemperature,
  ) {
    final localizations = AppLocalizations.of(NavigationService.currentContext!)!;
    final temperatureChange = currentTemperature - previousTemperature;
    
    if (temperatureChange.abs() > AccessibilityConstants.significantTemperatureChange) {
      final announcement = localizations.temperatureChangeAnnouncement(
        body.displayName,
        NumberFormatUtils.formatTemperature(currentTemperature, localizations.localeName),
        temperatureChange > 0 ? localizations.increasing : localizations.decreasing,
      );
      
      _queueAnnouncement(announcement);
    }
  }
  
  static void _queueAnnouncement(String text) {
    _announcementQueue.add(text);
    _processAnnouncementQueue();
  }
  
  static void _processAnnouncementQueue() {
    if (_announcementTimer?.isActive == true || _announcementQueue.isEmpty) return;
    
    _announcementTimer = Timer.periodic(
      Duration(milliseconds: AccessibilityConstants.announcementInterval),
      (timer) {
        if (_announcementQueue.isEmpty) {
          timer.cancel();
          return;
        }
        
        final announcement = _announcementQueue.removeFirst();
        SemanticsService.announce(
          announcement,
          TextDirection.ltr,
          assertiveness: Assertiveness.polite,
        );
      },
    );
  }
}
```

### High Contrast Mode Support
```dart
// lib/utils/contrast_utils.dart
class ContrastUtils {
  /// Get accessible color with sufficient contrast
  static Color getAccessibleTextColor(Color background) {
    final luminance = background.computeLuminance();
    
    if (luminance > AccessibilityConstants.luminanceThreshold) {
      // Light background - use dark text
      return AppColors.deepSpace;
    } else {
      // Dark background - use light text
      return AppColors.starWhite;
    }
  }
  
  /// Validate color combination meets WCAG guidelines
  static bool meetsContrastRequirements(Color foreground, Color background) {
    final ratio = _calculateContrastRatio(foreground, background);
    return ratio >= AccessibilityConstants.minimumContrastRatio; // 4.5:1 for AA
  }
  
  /// Enhance color for users with color vision deficiencies
  static Color enhanceColorAccessibility(Color original, ColorBlindnessType type) {
    switch (type) {
      case ColorBlindnessType.protanopia:
        // Red-blind: Enhance blue and green channels
        return Color.fromARGB(
          original.alpha,
          (original.red * 0.3).round(),
          (original.green * 1.2).round().clamp(0, 255),
          (original.blue * 1.2).round().clamp(0, 255),
        );
        
      case ColorBlindnessType.deuteranopia:
        // Green-blind: Enhance red and blue channels  
        return Color.fromARGB(
          original.alpha,
          (original.red * 1.2).round().clamp(0, 255),
          (original.green * 0.3).round(),
          (original.blue * 1.2).round().clamp(0, 255),
        );
        
      case ColorBlindnessType.tritanopia:
        // Blue-blind: Enhance red and green channels
        return Color.fromARGB(
          original.alpha,
          (original.red * 1.2).round().clamp(0, 255),
          (original.green * 1.2).round().clamp(0, 255),
          (original.blue * 0.3).round(),
        );
        
      case ColorBlindnessType.none:
      default:
        return original;
    }
  }
  
  static double _calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    
    final lighter = math.max(fgLuminance, bgLuminance);
    final darker = math.min(fgLuminance, bgLuminance);
    
    return (lighter + 0.05) / (darker + 0.05);
  }
}
```

### Focus Management for Complex UI
```dart
// lib/utils/accessibility_utils.dart
class AccessibilityUtils {
  static final FocusScopeNode _simulationFocusScope = FocusScopeNode();
  
  /// Manage focus transitions in simulation interface
  static void manageFocusTransition(
    BuildContext context,
    FocusableElement from,
    FocusableElement to,
  ) {
    // Announce the transition
    final localizations = AppLocalizations.of(context)!;
    ScreenReaderUtils.announceFocusChange(
      localizations.focusMovedTo(to.semanticLabel),
    );
    
    // Move focus programmatically
    FocusScope.of(context).requestFocus(to.focusNode);
    
    // Provide gentle haptic feedback
    HapticFeedback.selectionClick();
  }
  
  /// Create accessible floating action button for simulation controls
  static Widget createAccessibleFAB({
    required String label,
    required String tooltip,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      width: AppTypography.minimumTouchTarget,
      height: AppTypography.minimumTouchTarget,
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: Semantics(
          label: label,
          button: true,
          child: Icon(
            icon,
            size: AppTypography.iconSizeLarge,
            color: ContrastUtils.getAccessibleTextColor(AppColors.nebulaPurple),
          ),
        ),
        backgroundColor: AppColors.nebulaPurple,
        focusElevation: AppTypography.spacingSmall,
        elevation: AppTypography.spacingXSmall,
      ),
    );
  }
}
```

## ❌ WRONG Accessibility Patterns (FLAG IMMEDIATELY)

```dart
// ❌ No semantic labels
IconButton(onPressed: () {}, icon: Icon(Icons.play));  // ❌ Missing tooltip and semantics

// ❌ Magic numbers for touch targets
Container(width: 30, height: 30, child: button)        // ❌ Use AppTypography.minimumTouchTarget

// ❌ Poor contrast
Text('Info', style: TextStyle(color: Colors.grey))     // ❌ Check contrast ratio

// ❌ No screen reader announcements for dynamic changes
simulationState.isRunning = true;                      // ❌ Should announce state change

// ❌ Missing keyboard navigation
GestureDetector(onTap: () {})                          // ❌ Use buttons or add keyboard support
```

## Accessibility Settings Integration

```dart
class AccessibilitySettings extends ChangeNotifier {
  static bool get isHapticFeedbackEnabled => 
    _preferences.getBool('haptic_feedback') ?? true;
  
  static bool get isHighContrastMode =>
    MediaQuery.of(NavigationService.currentContext!).highContrast;
  
  static bool get isLargeTextMode =>
    MediaQuery.of(NavigationService.currentContext!).textScaleFactor > 1.3;
  
  static ColorBlindnessType get colorBlindnessType => 
    ColorBlindnessType.values[_preferences.getInt('colorblindness_type') ?? 0];
}
```

## Testing Accessibility

Every widget must have accessibility tests:
```dart
testWidgets('simulation controls have proper semantic labels', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: AccessibleSimulationControls()),
  );
  
  // Test semantic labels exist
  expect(
    find.bySemanticsLabel(AppLocalizations.of(context)!.playButton),
    findsOneWidget,
  );
  
  // Test minimum touch target size
  final playButton = tester.getSize(find.byIcon(Icons.play_arrow));
  expect(playButton.width, greaterThanOrEqualTo(AppTypography.minimumTouchTarget));
  expect(playButton.height, greaterThanOrEqualTo(AppTypography.minimumTouchTarget));
});
```

## Reference Files

- Accessibility patterns: `.github/prompts/accessibility.md`
- Contrast utilities: `lib/utils/contrast_utils.dart`
- Haptic feedback: `lib/utils/haptic_feedback_utils.dart`
- Screen reader support: `lib/utils/screen_reader_utils.dart`