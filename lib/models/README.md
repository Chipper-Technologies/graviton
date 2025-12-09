# Models Organization

This directory is being reorganized into logical subdirectories to improve maintainability.

## New Structure

```
models/
├── celestial/         # Celestial body models
│   ├── body.dart
│   ├── body_data.dart
│   ├── orbital_parameters.dart
│   ├── orbital_placement.dart
│   └── orbital_event.dart
├── particles/         # Particle system models
│   ├── asteroid_particle.dart
│   ├── collision_particle.dart
│   ├── ring_particle.dart
│   └── particle_system_data.dart
├── effects/           # Visual effects models
│   ├── shockwave.dart
│   ├── plasma_jet.dart
│   ├── merge_flash.dart
│   ├── debris_cloud.dart
│   └── sunspot_data.dart
├── scenarios/         # Scenario configuration models
│   ├── preset_scenario.dart
│   ├── custom_scenario.dart
│   ├── custom_scenario_summary.dart
│   ├── scenario_config.dart
│   ├── scenario_configuration.dart
│   ├── scenario_metadata.dart
│   ├── scenario_physics_settings.dart
│   ├── scenario_camera_parameters.dart
│   ├── scenario_validation_result.dart
│   ├── scenario_validation_rules.dart
│   ├── scenario_json_schema.dart
│   └── experimental_scenario_config.dart
├── camera/            # Camera-related models
│   ├── camera_position.dart
│   ├── camera_movement.dart
│   └── screenshot_*.dart models
├── ui/                # UI-specific models
│   ├── dialog_action.dart
│   ├── graviton_menu_item_config.dart
│   ├── snack_bar_theme.dart
│   ├── indicator_data.dart
│   └── tutorial_step.dart
├── user/              # User-related models
│   └── user_profile.dart
├── physics/           # Physics configuration models
│   ├── physics_settings.dart
│   ├── predictive_orbital_config.dart
│   ├── objectives_config.dart
│   ├── particle_systems_config.dart
│   └── success_criteria.dart
├── changelog/         # Changelog models
│   ├── changelog.dart
│   ├── changelog_entry.dart
│   └── changelog_version.dart
└── security/          # Security and integrity models
    ├── integrity_config.dart
    ├── platform_version_config.dart
    ├── play_integrity_exception.dart
    └── play_integrity_verification_result.dart
```

## Migration Status

🚧 **Phase 1**: Directory structure created alongside existing code
- Existing models remain in `lib/models/` root
- New subdirectories created for future organization
- Both flat and hierarchical structures coexist

## Purpose of Each Category

### Celestial
Models representing astronomical bodies and their properties, including orbital mechanics and physical characteristics.

### Particles
Models for particle systems used in visual effects like asteroid belts, rings, and collision debris.

### Effects
Visual effect models for transient phenomena like explosions, jets, shockwaves, and stellar activity.

### Scenarios
All models related to scenario configuration, validation, and persistence. This includes both preset and custom scenarios.

### Camera
Models managing camera positioning, movement, and screenshot functionality.

### UI
User interface models that don't belong to specific features, including menus, dialogs, and tutorial content.

### User
User account and profile information.

### Physics
Physics simulation configuration and settings separate from the celestial body models.

### Changelog
Application changelog and version history models.

### Security
Security, integrity verification, and platform-specific security models.

## Guidelines for Future Files

- Place new models in appropriate subdirectories
- Create barrel export files (`celestial.dart`) for cleaner imports
- Maintain one model per file
- Include comprehensive tests for each model

## Related Documentation

- See `features/README.md` for feature-specific models
- See `.github/copilot-instructions.md` for model standards
