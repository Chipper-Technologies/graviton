/// Scenarios Feature Exports
///
/// This barrel file provides convenient access to all scenario-related functionality.
library;

// Data Layer - Services
export 'data/custom_scenario_manager.dart';
export 'data/custom_scenario_storage.dart';
export 'data/scenario_serialization_service.dart';
export 'data/scenario_service.dart';
export 'data/simulation_share_service.dart';

// Domain Layer - Models
export 'domain/custom_scenario.dart';
export 'domain/custom_scenario_summary.dart';
export 'domain/experimental_scenario_config.dart';
export 'domain/objectives_config.dart';
export 'domain/particle_systems_config.dart';
export 'domain/preset_scenario.dart';
export 'domain/scenario_camera_parameters.dart';
export 'domain/scenario_config.dart';
export 'domain/scenario_configuration.dart';
export 'domain/scenario_json_schema.dart';
export 'domain/scenario_metadata.dart';
export 'domain/scenario_physics_settings.dart';
export 'domain/scenario_validation_result.dart';
export 'domain/scenario_validation_rules.dart';
export 'domain/success_criteria.dart';

// Presentation Layer - Screens
export 'presentation/screens/scenario_editor_screen.dart';
export 'presentation/screens/scenario_selection_screen.dart';

// Presentation Layer - Widgets
export 'presentation/widgets/create_scenario_tile.dart';
export 'presentation/widgets/custom_scenario_tile.dart';
export 'presentation/widgets/custom_scenarios_tab.dart';
export 'presentation/widgets/experimental_scenario_tile.dart';
export 'presentation/widgets/import_scenario_tile.dart';
export 'presentation/widgets/preset_scenario_tile.dart';
export 'presentation/widgets/preset_scenarios_tab.dart';
export 'presentation/widgets/scenario_body_tile.dart';
export 'presentation/widgets/scenario_editor_body_details_bottom_sheet.dart';
export 'presentation/widgets/scenario_editor_body_list.dart';
export 'presentation/widgets/scenario_editor_metadata_panel.dart';
export 'presentation/widgets/scenario_editor_physics_panel.dart';
