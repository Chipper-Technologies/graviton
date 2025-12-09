# Shared Module

This directory contains reusable UI components and rendering code used across multiple features.

## Structure

```
shared/
├── widgets/           # Shared UI components
│   ├── common/       # Basic reusable widgets (buttons, inputs, etc.)
│   ├── layouts/      # Layout components (bottom sheets, panels)
│   ├── controls/     # Control widgets (camera, physics, visuals)
│   ├── dialogs/      # Generic dialog components
│   ├── haptics/      # Haptic feedback wrappers
│   └── semantics/    # Accessibility wrappers
└── painters/          # Custom painters for rendering
```

## Widget Categories

### Common Widgets
Basic building blocks used throughout the app:
- `GravitonPopupMenu`: Custom styled popup menu
- `GravitonSnackBar`: Consistent snack bar styling
- `StyledTextField`: Themed text input
- `SectionDivider`: Visual section separators
- `ColorPicker`: Color selection widget

### Layout Widgets
Structural components:
- `SlidingPanelBottomSheet`: Sliding panel container
- `BottomSheetHeader`: Standardized bottom sheet headers
- `BottomSheetHandle`: Drag handle for sheets

### Control Widgets
Interactive controls:
- `CameraControls`: Camera manipulation controls
- `PhysicsControls`: Physics parameter adjustments
- `VisualsControls`: Visual settings controls

### Dialog Widgets
Reusable dialogs:
- `BaseConfirmationDialog`: Standard confirmation pattern
- `DeleteConfirmationDialog`: Delete action confirmation
- `MaintenanceDialog`: Maintenance mode notification
- `VersionCheckDialog`: Version update prompts

### Haptic Widgets
Haptic feedback wrappers for standard Flutter widgets:
- `HapticButton`, `HapticIconButton`, `HapticInkWell`
- `HapticSwitch`, `HapticSliderOption`
- Consistent haptic feedback patterns

### Semantic Widgets
Accessibility wrappers:
- `SemanticAppWrapper`: App-level semantics
- `SemanticLiveRegion`: Live region announcements
- `SemanticFocusWrappers`: Focus management

## Painters

Custom rendering components:
- `CelestialBodyPainter`: Renders celestial bodies
- `TrailPainter`: Renders orbital trails
- `BackgroundPainter`: Renders starfield background
- `GravityPainter`: Visualizes gravity fields
- `EffectsPainter`: Renders collision effects

## Guidelines

- **Widgets should be generic**: No feature-specific logic
- **Single responsibility**: Each widget does one thing well
- **Composability**: Widgets should compose well together
- **Documentation**: All public APIs must be documented
- **Consistency**: Follow AppColors and AppTypography standards

## Usage Example

```dart
// Import from shared
import 'package:graviton/shared/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/shared/widgets/haptics/haptic_icon_button.dart';

// Use in any feature
GravitonSnackBar.show(
  context,
  message: 'Settings saved',
  severity: SnackBarSeverity.success,
);

HapticIconButton(
  icon: Icons.settings,
  onPressed: () => _openSettings(),
  tooltip: 'Settings',
)
```

## Migration Status

🚧 **Phase 1**: Directory structure created alongside existing code
- Existing widgets remain in `lib/widgets/`
- New structure being prepared for gradual migration
- Both structures will coexist during transition

## Related Documentation

- See `core/README.md` for theme and constants
- See `features/README.md` for feature-specific widgets
- See `.github/copilot-instructions.md` for widget standards
