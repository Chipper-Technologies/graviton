# Accessibility Prompt

You are working on Graviton's accessibility features. Ensure the physics simulation is accessible to all users:

## Core Requirements

1. **Semantic Labels**: All interactive elements must have meaningful semantics
2. **Screen Reader Support**: Provide audio descriptions of visual physics
3. **Keyboard Navigation**: Full app functionality via keyboard/switch control  
4. **High Contrast**: Support for users with visual impairments
5. **Haptic Feedback**: Use vibration for collision events and interactions

## Semantic Patterns

```dart
// Correct: Semantic labels for simulation controls
Semantics(
  label: AppLocalizations.of(context)!.playPauseButton,
  hint: simulationState.isRunning 
    ? AppLocalizations.of(context)!.pauseSimulation
    : AppLocalizations.of(context)!.resumeSimulation,
  child: IconButton(
    icon: Icon(simulationState.isRunning ? Icons.pause : Icons.play_arrow),
    onPressed: () => simulationState.togglePlayPause(),
  ),
)

// Simulation canvas with semantic descriptions
Semantics(
  label: AppLocalizations.of(context)!.simulationCanvas,
  value: _getSimulationDescription(context, simulationState),
  child: CustomPaint(painter: SpacePainter(...)),
)
```

## Physics Descriptions

```dart
String _getSimulationDescription(BuildContext context, SimulationState state) {
  final l10n = AppLocalizations.of(context)!;
  
  if (state.bodies.isEmpty) {
    return l10n.noBodyiesInSimulation;
  }
  
  final bodyCount = state.bodies.length;
  final isStable = state.isSystemStable;
  
  return l10n.simulationDescription(
    bodyCount,
    isStable ? l10n.stable : l10n.chaotic,
  );
}
```

## Keyboard Navigation

```dart
class AccessibleSimulationControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final simulationState = Provider.of<SimulationState>(context, listen: false);
          
          switch (event.logicalKey) {
            case LogicalKeyboardKey.space:
              simulationState.togglePlayPause();
              return KeyEventResult.handled;
            
            case LogicalKeyboardKey.keyR:
              simulationState.resetSimulation();
              return KeyEventResult.handled;
            
            case LogicalKeyboardKey.arrowUp:
              simulationState.increaseSpeed();
              return KeyEventResult.handled;
            
            case LogicalKeyboardKey.arrowDown:
              simulationState.decreaseSpeed();
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: SimulationView(),
    );
  }
}
```

## Haptic Feedback

```dart
// Collision feedback
void onBodyCollision(Body body1, Body body2) {
  // Vibrate based on collision intensity
  final intensity = calculateCollisionIntensity(body1, body2);
  HapticFeedbackService.instance.collisionFeedback(intensity);
  
  // Announce collision to screen reader
  SemanticsService.announce(
    AppLocalizations.of(context)!.bodyCollisionAnnouncement(
      body1.name,
      body2.name,
    ),
    TextDirection.ltr,
  );
}

// Orbital event feedback
void onOrbitalEvent(OrbitalEvent event) {
  switch (event.type) {
    case OrbitalEventType.escape:
      HapticFeedbackService.instance.lightImpact();
      SemanticsService.announce(
        AppLocalizations.of(context)!.bodyEscapedSystem(event.bodyName),
        TextDirection.ltr,
      );
      break;
    
    case OrbitalEventType.capture:
      HapticFeedbackService.instance.mediumImpact();
      break;
  }
}
```

## High Contrast Support

```dart
class AccessibleSpacePainter extends CustomPainter {
  final bool highContrast;
  
  AccessibleSpacePainter({required this.highContrast});
  
  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..color = highContrast 
        ? Colors.white 
        : StellarColorService.getColor(body.temperature);
    
    final trailPaint = Paint()
      ..color = highContrast 
        ? Colors.yellow.withOpacity(0.8)
        : Colors.white.withOpacity(0.6)
      ..strokeWidth = highContrast ? 2.0 : 1.2;
    
    // Render with high contrast if enabled
    _drawBodies(canvas, bodyPaint);
    _drawTrails(canvas, trailPaint);
  }
}
```

## Voice Announcements

```dart
class SimulationAnnouncementService {
  static void announceSystemState(BuildContext context, SimulationState state) {
    final l10n = AppLocalizations.of(context)!;
    
    String announcement = '';
    
    if (state.recentCollisions.isNotEmpty) {
      announcement += l10n.collisionDetected;
    }
    
    if (state.systemBecameUnstable) {
      announcement += l10n.systemBecameUnstable;
    }
    
    if (state.newBodyCaptured) {
      announcement += l10n.newBodyCaptured;
    }
    
    if (announcement.isNotEmpty) {
      SemanticsService.announce(announcement, TextDirection.ltr);
    }
  }
}
```

## Testing Accessibility

```dart
testWidgets('simulation controls are accessible', (tester) async {
  final semantics = tester.binding.pipelineOwner.semanticsOwner!;
  
  await tester.pumpWidget(MyApp());
  
  // Verify semantic labels exist
  expect(
    find.bySemanticsLabel(AppLocalizations.of(context)!.playPauseButton),
    findsOneWidget,
  );
  
  // Test keyboard navigation
  await tester.sendKeyEvent(LogicalKeyboardKey.space);
  await tester.pump();
  
  // Verify state changed
  expect(simulationState.isRunning, isTrue);
});
```

## Services Used

- `AccessibilityService`: Main accessibility coordination
- `HapticFeedbackService`: Vibration patterns for physics events
- `SemanticFocusService`: Screen reader focus management
- `KeyboardNavigationService`: Keyboard shortcuts and navigation

## File Locations

- Services: `lib/services/accessibility_service.dart`
- Haptics: `lib/services/haptic_feedback_service.dart`
- Navigation: `lib/services/keyboard_navigation_service.dart`
- Focus: `lib/services/semantic_focus_service.dart`