# Widgets Organization

This directory is being reorganized to improve widget discoverability and reusability.

## Current Structure (Being Reorganized)

```
widgets/
├── common/                     # ✅ Basic reusable components (KEEP)
│   ├── graviton_popup_menu.dart
│   ├── graviton_snack_bar.dart
│   ├── styled_text_field.dart
│   ├── section_divider.dart
│   ├── color_picker.dart
│   └── ...
├── layouts/                    # 🆕 Layout components (NEW)
│   ├── sliding_panel_bottom_sheet.dart
│   ├── bottom_sheet_header.dart
│   └── bottom_sheet_handle.dart
├── controls/                   # 🆕 Control widgets (NEW)
│   ├── camera_controls.dart
│   ├── physics_controls.dart
│   └── visuals_controls.dart
├── dialogs/                    # 🆕 Dialog widgets (NEW)
│   ├── body_selection_dialog.dart
│   ├── changelog_dialog.dart
│   ├── maintenance_dialog.dart
│   └── version_check_dialog.dart
├── overlays/                   # ✅ Overlay widgets (KEEP)
│   ├── stats_overlay.dart
│   ├── tutorial_overlay.dart
│   ├── body_labels_overlay.dart
│   └── ...
├── haptics/                    # ✅ Haptic wrappers (KEEP)
│   ├── haptic_button.dart
│   ├── haptic_icon_button.dart
│   └── ...
├── account/                    # ✅ Account widgets (KEEP)
│   ├── profile_card.dart
│   ├── avatar_display.dart
│   └── ...
├── auth/                       # ✅ Auth widgets (KEEP)
│   ├── social_auth_button.dart
│   └── avatar_button.dart
├── body_creation/              # ✅ Body creation (KEEP)
│   └── body_creation_mode_toggle.dart
├── scenario_selection/         # ✅ Scenario widgets (KEEP)
│   ├── preset_scenario_tile.dart
│   ├── custom_scenario_tile.dart
│   └── ...
├── simulation/                 # ✅ Simulation widgets (KEEP)
│   └── simulation_viewport_widget.dart
└── semantics/                  # ✅ Accessibility (KEEP)
    ├── semantic_app_wrapper.dart
    ├── semantic_live_region.dart
    └── ...
```

## Migration Status

🚧 **Phase 1**: Directory structure created alongside existing code
- Existing widgets remain in current locations
- New subdirectories (`layouts/`, `controls/`, `dialogs/`) created
- Files will be moved in later phases

## Widget Categories

### Common Widgets (Existing)
Basic building blocks used throughout the app. These are truly generic and reusable.

**Examples**: Buttons, inputs, pickers, dividers, menus

### Layouts (New Category)
Structural components that define page layout and container patterns.

**What belongs here**:
- Bottom sheets and sliding panels
- Sheet headers and handles
- Layout wrappers

### Controls (New Category)
Interactive control panels for manipulating simulation parameters.

**What belongs here**:
- Camera controls
- Physics parameter controls
- Visual settings controls

### Dialogs (New Category)
Dialog components used across features.

**What belongs here**:
- Confirmation dialogs
- Selection dialogs
- Information dialogs
- Maintenance/version dialogs

### Overlays (Existing)
HUD elements and overlays that appear on top of content.

**What belongs here**:
- Stats displays
- Tutorial overlays
- Body labels
- Visual aids

### Feature-Specific Widgets (Existing)
Widgets specific to particular features remain in their feature directories:
- `account/` - Account management widgets
- `auth/` - Authentication widgets
- `scenario_selection/` - Scenario picker widgets
- `simulation/` - Simulation viewport

### Cross-Cutting Concerns (Existing)
- `haptics/` - Haptic feedback wrappers
- `semantics/` - Accessibility wrappers

## Widget Reuse Guidelines

**Before creating a new widget:**
1. ✅ Search `lib/widgets/common/` for existing components
2. ✅ Search `lib/widgets/` subdirectories for similar patterns
3. ✅ Check `lib/shared/widgets/` (future location)
4. ✅ Use `grep_search` or `semantic_search` to find existing implementations

**Widget design principles:**
- Follow AppColors constants (zero tolerance for hardcoded colors)
- Follow AppTypography constants (zero tolerance for magic numbers)
- One widget per file with corresponding test
- Comprehensive documentation with examples
- Composable and reusable design

## Future Structure

In Phase 2+, many of these widgets will move to:
```
lib/shared/widgets/     # For truly generic widgets
lib/features/*/presentation/  # For feature-specific widgets
```

## Related Documentation

- See `shared/README.md` for future widget organization
- See `features/README.md` for feature-specific widgets
- See `.github/copilot-instructions.md` for widget standards (especially AppColors and AppTypography requirements)
