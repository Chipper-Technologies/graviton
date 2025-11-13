import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/temperature_unit.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/services/orbital_mechanics_service.dart';
import 'package:graviton/state/app_state.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/common/body_type_picker.dart';
import 'package:graviton/widgets/common/color_picker.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/common/base_confirmation_dialog.dart';
import 'package:graviton/widgets/common/graviton_popup_menu.dart';
import 'package:graviton/widgets/common/graviton_snack_bar.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/haptics/haptic_slider_option.dart';
import 'package:graviton/widgets/haptics/haptic_ink_well.dart';
import 'package:graviton/widgets/haptics/haptic_switch.dart';
import 'package:graviton/widgets/haptics/haptic_button.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Bottom sheet widget for displaying and editing body details
class ScenarioEditorBodyDetailsBottomSheet extends StatefulWidget {
  final Body body;
  final ValueChanged<Body> onBodyChanged;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final ValueChanged<Body>? onSave;
  final bool isAddMode;
  final List<Body> availableCentralBodies; // For orbital placement

  const ScenarioEditorBodyDetailsBottomSheet({
    super.key,
    required this.body,
    required this.onBodyChanged,
    this.onDuplicate,
    this.onDelete,
    this.onSave,
    this.isAddMode = false,
    this.availableCentralBodies = const [],
  });

  @override
  State<ScenarioEditorBodyDetailsBottomSheet> createState() =>
      _ScenarioEditorBodyDetailsBottomSheetState();
}

class _ScenarioEditorBodyDetailsBottomSheetState
    extends State<ScenarioEditorBodyDetailsBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _massController;
  late TextEditingController _radiusController;
  late TextEditingController _positionXController;
  late TextEditingController _positionYController;
  late TextEditingController _positionZController;
  late TextEditingController _velocityXController;
  late TextEditingController _velocityYController;
  late TextEditingController _velocityZController;
  late TextEditingController _temperatureController;
  late TextEditingController _luminosityController;

  // Slider state variables
  late double _massSlider;
  late double _radiusSlider;
  late double _luminositySlider;
  late double _temperatureSlider;

  // Color state variable
  late Color _selectedColor;

  // Body type state variable
  late BodyType _selectedBodyType;

  // Gravity well state variable
  late bool _showGravityWell;

  // Track unsaved changes to prevent accidental closing
  bool _hasUnsavedChanges = false;

  // Auto-save mechanism for body changes
  Timer? _autoSaveTimer;
  static const Duration _autoSaveDelay = Duration(milliseconds: 500);

  // Store the original body to compare against
  late Body _originalBody;

  // Orbital placement state variables
  Body? _selectedCentralBody;
  bool _showOrbitalPlacement = false;
  double _orbitRadius = 20.0;
  double _orbitPhase = 0.0; // 0 to 2π
  double _orbitInclination = 0.0; // 0 to π/2
  bool _isOrbitalPlacementUIActive = false;

  @override
  void initState() {
    super.initState();

    // Store original body for comparison
    _originalBody = widget.body;

    // Initialize body type and color first (needed for range calculations)
    _selectedBodyType = widget.body.bodyType;
    _selectedColor = widget.body.color;
    _showGravityWell = widget.body.showGravityWell;

    _nameController = TextEditingController(text: widget.body.name);
    _massController = TextEditingController(text: widget.body.mass.toString());
    _radiusController = TextEditingController(
      text: widget.body.radius.toString(),
    );
    _positionXController = TextEditingController(
      text: widget.body.position.x.toString(),
    );
    _positionYController = TextEditingController(
      text: widget.body.position.y.toString(),
    );
    _positionZController = TextEditingController(
      text: widget.body.position.z.toString(),
    );
    _velocityXController = TextEditingController(
      text: widget.body.velocity.x.toString(),
    );
    _velocityYController = TextEditingController(
      text: widget.body.velocity.y.toString(),
    );
    _velocityZController = TextEditingController(
      text: widget.body.velocity.z.toString(),
    );
    _temperatureController = TextEditingController(
      text: widget.body.temperature.round().toString(),
    );
    _luminosityController = TextEditingController(
      text: widget.body.stellarLuminosity.toString(),
    );

    // Initialize slider values (clamped to dynamic ranges based on body type)
    final massRange = BodyTypeRanges.getMassRange(_selectedBodyType);
    final radiusRange = BodyTypeRanges.getRadiusRange(_selectedBodyType);
    final luminosityRange = BodyTypeRanges.getLuminosityRange(
      _selectedBodyType,
    );
    final temperatureRange = BodyTypeRanges.getTemperatureRange(
      _selectedBodyType,
    );

    _massSlider = widget.body.mass.clamp(massRange['min']!, massRange['max']!);
    _radiusSlider = widget.body.radius.clamp(
      radiusRange['min']!,
      radiusRange['max']!,
    );
    _luminositySlider = widget.body.stellarLuminosity.clamp(
      luminosityRange['min']!,
      luminosityRange['max']!,
    );
    _temperatureSlider = widget.body.temperature.clamp(
      temperatureRange['min']!,
      temperatureRange['max']!,
    );

    // Initialize orbital placement state from body
    _showOrbitalPlacement = widget.body.isOrbitalPlacementActive;
    _isOrbitalPlacementUIActive = widget.body.isOrbitalPlacementActive;

    // Initialize orbital parameters from body with proper clamping to slider ranges
    _orbitRadius = widget.body.orbitRadius.clamp(5.0, 500.0);
    _orbitPhase = widget.body.orbitPhase.clamp(0.0, 2 * math.pi);
    _orbitInclination = widget.body.orbitInclination.clamp(0.0, math.pi / 2);
  }

  @override
  void didUpdateWidget(ScenarioEditorBodyDetailsBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers if the body has changed
    if (oldWidget.body != widget.body) {
      _nameController.text = widget.body.name;
      _massController.text = widget.body.mass.toString();
      _radiusController.text = widget.body.radius.toString();
      _positionXController.text = widget.body.position.x.toString();
      _positionYController.text = widget.body.position.y.toString();
      _positionZController.text = widget.body.position.z.toString();
      _velocityXController.text = widget.body.velocity.x.toString();
      _velocityYController.text = widget.body.velocity.y.toString();
      _velocityZController.text = widget.body.velocity.z.toString();
      _temperatureController.text = widget.body.temperature.round().toString();
      _luminosityController.text = widget.body.stellarLuminosity.toString();

      // Update slider values with dynamic ranges
      final massRange = BodyTypeRanges.getMassRange(_selectedBodyType);
      final radiusRange = BodyTypeRanges.getRadiusRange(_selectedBodyType);
      final luminosityRange = BodyTypeRanges.getLuminosityRange(
        _selectedBodyType,
      );

      _massSlider = widget.body.mass.clamp(
        massRange['min']!,
        massRange['max']!,
      );
      _radiusSlider = widget.body.radius.clamp(
        radiusRange['min']!,
        radiusRange['max']!,
      );
      _luminositySlider = widget.body.stellarLuminosity.clamp(
        luminosityRange['min']!,
        luminosityRange['max']!,
      );

      // Update color
      _selectedColor = widget.body.color;

      // Update body type
      _selectedBodyType = widget.body.bodyType;

      // Update orbital placement state
      _showOrbitalPlacement = widget.body.isOrbitalPlacementActive;
      _isOrbitalPlacementUIActive = widget.body.isOrbitalPlacementActive;

      // Update orbital parameters with proper clamping to slider ranges
      _orbitRadius = widget.body.orbitRadius.clamp(5.0, 500.0);
      _orbitPhase = widget.body.orbitPhase.clamp(0.0, 2 * math.pi);
      _orbitInclination = widget.body.orbitInclination.clamp(0.0, math.pi / 2);
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _nameController.dispose();
    _massController.dispose();
    _radiusController.dispose();
    _positionXController.dispose();
    _positionYController.dispose();
    _positionZController.dispose();
    _velocityXController.dispose();
    _velocityYController.dispose();
    _velocityZController.dispose();
    _temperatureController.dispose();
    _luminosityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // If we get here, there are unsaved changes and the pop was prevented
        final shouldPop = await _showUnsavedChangesDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.uiBlack.withValues(
            alpha: AppTypography.opacityVeryHigh,
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTypography.radiusXLarge),
          ),
          border: Border(
            top: BorderSide(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.uiBlack.withValues(
                alpha: AppTypography.opacityMedium,
              ),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 8),
              width: 80,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.uiBlack.withValues(
                      alpha: AppTypography.opacityMedium,
                    ),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),

            // Header with title and actions
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.body.name,
                      style: AppTypography.titleText.copyWith(
                        color: AppColors.uiWhite,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 3-dot menu for edit mode actions (only show if there are actions available)
                  if (!widget.isAddMode &&
                      (widget.onDuplicate != null || widget.onDelete != null))
                    GravitonPopupMenu(
                      accessibilityLabel: l10n.moreActionsAccessibility,
                      accessibilityHint: l10n.moreActionsHint,
                      analyticsElement: UIElement.bodyEditor,
                      additionalAnalyticsParams: {
                        'body_name': widget.body.name,
                        'body_type': widget.body.bodyType.name,
                      },
                      menuItems: [
                        // Only show duplicate option if callback is provided
                        if (widget.onDuplicate != null)
                          GravitonMenuItemConfig(
                            value: 'duplicate',
                            labelKey: 'duplicateBodyTooltip',
                            hintKey: 'duplicateBodyAccessibility',
                            icon: Icons.content_copy_outlined,
                            onTap: () {
                              // Log analytics for body duplication
                              FirebaseService.instance.logUIEventWithEnums(
                                UIAction.bodyAdded,
                                element: UIElement.bodyEditor,
                                value: 'duplicate',
                                additionalParams: {
                                  'original_body_name': widget.body.name,
                                  'body_type': widget.body.bodyType.name,
                                },
                              );
                              widget.onDuplicate?.call();
                            },
                          ),
                        // Only show delete option if callback is provided
                        if (widget.onDelete != null)
                          GravitonMenuItemConfig(
                            value: 'delete',
                            labelKey: 'deleteBodyTooltip',
                            hintKey: 'deleteBodyAccessibility',
                            icon: Icons.delete_outline,
                            iconColor: AppColors.accretionRed,
                            borderColor: AppColors.accretionRed.withValues(
                              alpha: AppColors.alphaMediumVisible,
                            ),
                            onTap: () => _showDeleteConfirmation(),
                          ),
                      ],
                    ),
                ],
              ),
            ),

            // Tab Content using GravitonTabbedView
            Expanded(
              child: GravitonTabbedView(
                initialIndex: widget.isAddMode
                    ? 1
                    : 0, // Default to Edit tab when adding
                tabs: [
                  GravitonTab(
                    icon: Icons.info_outline,
                    label: l10n.detailsEditorLabel,
                  ),
                  GravitonTab(
                    icon: Icons.edit_outlined,
                    label: l10n.editEditorLabel,
                  ),
                ],
                children: [_buildDetailsTab(l10n), _buildEditTab(l10n)],
              ),
            ),
          ],
        ), // End Column
      ), // End Container (PopScope child)
    ); // End PopScope
  }

  /// Shows confirmation dialog for unsaved changes
  Future<bool> _showUnsavedChangesDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final result = await BaseConfirmationDialog.show<bool>(
      context: context,
      title: l10n.unsavedChangesTitle,
      message: l10n.unsavedChangesMessage,
      borderColor: AppColors.primaryColor.withValues(
        alpha: AppTypography.opacityFaint,
      ),
      actions: [
        DialogAction(
          text: l10n.cancel,
          onPressed: () => Navigator.of(context).pop(false),
          textColor: AppColors.uiWhite.withValues(
            alpha: AppTypography.opacityHigh,
          ),
        ),
        DialogAction(
          text: l10n.discardButton,
          onPressed: () => Navigator.of(context).pop(true),
          textColor: AppColors.accretionRed,
          fontWeight: FontWeight.w600,
          isDestructive: true,
        ),
      ],
    );

    return result ?? false;
  }

  Future<void> _showDeleteConfirmation() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await DeleteConfirmationDialog.show(
      context: context,
      title: l10n.deleteBodyConfirmTitle(widget.body.name),
      message: l10n.deleteBodyConfirmMessage,
    );

    if (confirmed == true) {
      HapticFeedback.mediumImpact();

      // Log analytics for body deletion
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.bodyRemoved,
        element: UIElement.bodyEditor,
        additionalParams: {
          'body_name': widget.body.name,
          'body_type': widget.body.bodyType.name,
          'body_mass': widget.body.mass,
        },
      );

      // Close the bottom sheet and signal deletion to parent
      if (mounted) {
        Navigator.pop(context);
        widget.onDelete?.call();
      }
    }
  }

  /// Triggers auto-save with a debounce delay
  void _triggerAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, () {
      if (mounted && _hasUnsavedChanges) {
        _autoSaveBody();
      }
    });
  }

  /// Auto-save the body without user interaction
  void _autoSaveBody() {
    try {
      // Get the current body state with all updates
      final currentBody = _getCurrentBodyState(context);

      // Clear unsaved changes flag since we're saving
      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
        });

        // Signal save to parent
        widget.onSave?.call(currentBody);
      }
    } catch (e) {
      // Don't show errors for auto-save, just log them
      debugPrint('Auto-save failed: $e');
    }
  }

  /// Get the current body state with all field updates applied
  Body _getCurrentBodyState(BuildContext context) {
    // Use a default name if the field is empty
    final name = _nameController.text.trim();
    final defaultName = AppLocalizations.of(context)!.defaultBodyName;

    return Body(
      name: name.isEmpty ? defaultName : name,
      position: vm.Vector3(
        double.tryParse(_positionXController.text) ?? widget.body.position.x,
        double.tryParse(_positionYController.text) ?? widget.body.position.y,
        double.tryParse(_positionZController.text) ?? widget.body.position.z,
      ),
      velocity: vm.Vector3(
        double.tryParse(_velocityXController.text) ?? widget.body.velocity.x,
        double.tryParse(_velocityYController.text) ?? widget.body.velocity.y,
        double.tryParse(_velocityZController.text) ?? widget.body.velocity.z,
      ),
      mass: _massSlider, // Use slider value instead of text controller
      radius: _radiusSlider, // Use slider value instead of text controller
      color: _selectedColor, // Use local color state
      bodyType: _selectedBodyType, // Use local body type state
      stellarLuminosity:
          _luminositySlider, // Use slider value instead of text controller
      temperature:
          double.tryParse(_temperatureController.text) ??
          widget.body.temperature,
      showGravityWell: widget.body.showGravityWell,
      isPlanet: widget.body.isPlanet,
      habitabilityStatus: widget.body.habitabilityStatus,
      isOrbitalPlacementActive:
          _showOrbitalPlacement, // Save orbital placement state
      orbitRadius: _orbitRadius, // Save orbital parameters
      orbitPhase: _orbitPhase,
      orbitInclination: _orbitInclination,
    );
  }

  Widget _buildDetailsTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppTypography.spacingMedium,
        AppTypography.spacingMedium,
        AppTypography.spacingMedium,
        AppTypography.spacingMedium + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Properties
          _buildDetailSection(l10n.propertiesEditor, [
            Row(
              children: [
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.category_outlined,
                    label: l10n.typeEditorLabel,
                    value: widget.body.bodyType.name.toUpperCase(),
                    color: _getBodyTypeColor(widget.body.bodyType),
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.fitness_center,
                    label: l10n.bodyPropertiesMass,
                    value: _formatMass(widget.body.mass),
                    color: AppColors.uiCyan,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTypography.spacingSmall),
            Row(
              children: [
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.radio_button_unchecked,
                    label: l10n.bodyPropertiesRadius,
                    value: _formatRadius(widget.body.radius),
                    color: AppColors.uiGreen,
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(child: SizedBox()), // Empty space for symmetry
              ],
            ),
          ]),

          SizedBox(height: AppTypography.spacingLarge),

          // Position & Motion
          _buildDetailSection(l10n.positionMotionEditor, [
            Row(
              children: [
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.place_outlined,
                    label: l10n.positionEditorLabel,
                    value: _formatVector(widget.body.position),
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: _buildDetailCard(
                    icon: Icons.speed,
                    label: l10n.bodyPropertiesVelocity,
                    value: _formatVector(widget.body.velocity),
                    color: AppColors.uiOrange,
                  ),
                ),
              ],
            ),
          ]),

          if (widget.body.temperature > 0) ...[
            SizedBox(height: AppTypography.spacingLarge),

            // Stellar Properties (if applicable)
            _buildDetailSection(l10n.stellarPropertiesEditor, [
              Row(
                children: [
                  Expanded(
                    child: _buildDetailCard(
                      icon: Icons.wb_sunny_outlined,
                      label: l10n.temperatureEditorlabel,
                      value: _formatTemperature(widget.body.temperature),
                      color: AppColors.accretionRed,
                    ),
                  ),
                  SizedBox(width: AppTypography.spacingSmall),
                  if (widget.body.bodyType == BodyType.star)
                    Expanded(
                      child: _buildDetailCard(
                        icon: Icons.light_mode_outlined,
                        label: l10n.luminosityEditorLabel,
                        value: _formatLuminosity(widget.body.stellarLuminosity),
                        color: AppColors.uiYellow,
                      ),
                    )
                  else
                    Expanded(child: SizedBox()), // Empty space if no luminosity
                ],
              ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildEditTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppTypography.spacingMedium,
        AppTypography.spacingMedium,
        AppTypography.spacingMedium,
        AppTypography.spacingMedium + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field (no section - this is basic info)
          _buildCompactTextField(
            controller: _nameController,
            icon: Icons.label_outline,
            hintText: l10n.bodyPropertiesNameHint,
            onChanged: (value) => _updateBodyProperty(),
          ),

          // Body Type Section
          SectionDivider.labeled(
            l10n.bodyTypeEditor,
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingMedium,
          ),
          BodyTypePicker(
            selectedType: _selectedBodyType,
            onTypeChanged: (bodyType) {
              // Generate realistic properties for the new body type
              final properties = _generateRealisticProperties(bodyType);

              setState(() {
                _selectedBodyType = bodyType;

                // Update local state with realistic values
                _massSlider = properties['mass']!;
                _massController.text = properties['mass']!.toString();

                _radiusSlider = properties['radius']!;
                _radiusController.text = properties['radius']!.toString();

                _luminositySlider = properties['luminosity']!;
                _luminosityController.text = properties['luminosity']!
                    .toString();

                _temperatureSlider = properties['temperature']!;
                _temperatureController.text = properties['temperature']!
                    .toString();

                _positionXController.text = properties['positionX']!.toString();
                _positionYController.text = properties['positionY']!.toString();
                _positionZController.text = properties['positionZ']!.toString();

                _velocityXController.text = properties['velocityX']!.toString();
                _velocityYController.text = properties['velocityY']!.toString();
                _velocityZController.text = properties['velocityZ']!.toString();
              });

              final updatedBody = Body(
                name: widget.body.name,
                position: vm.Vector3(
                  properties['positionX']!,
                  properties['positionY']!,
                  properties['positionZ']!,
                ),
                velocity: vm.Vector3(
                  properties['velocityX']!,
                  properties['velocityY']!,
                  properties['velocityZ']!,
                ),
                mass: properties['mass']!,
                radius: properties['radius']!,
                color: widget.body.color,
                bodyType: bodyType,
                stellarLuminosity: properties['luminosity']!,
                temperature: widget.body.temperature,
                showGravityWell: widget.body.showGravityWell,
                isPlanet:
                    bodyType == BodyType.planet || bodyType == BodyType.moon,
                habitabilityStatus: widget.body.habitabilityStatus,
              );
              widget.onBodyChanged(updatedBody);
            },
          ),

          // Color Section
          SectionDivider.labeled(
            l10n.colorEditor,
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingMedium,
          ),
          ColorPicker(
            selectedColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
              final updatedBody = Body(
                name: widget.body.name,
                position: widget.body.position,
                velocity: widget.body.velocity,
                mass: widget.body.mass,
                radius: widget.body.radius,
                color: color,
                bodyType: widget.body.bodyType,
                stellarLuminosity: widget.body.stellarLuminosity,
                temperature: widget.body.temperature,
                showGravityWell: widget.body.showGravityWell,
                isPlanet: widget.body.isPlanet,
                habitabilityStatus: widget.body.habitabilityStatus,
              );
              widget.onBodyChanged(updatedBody);
            },
          ),

          SectionDivider.plain(
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingXSmall,
          ),

          // Gravity Well Section
          SizedBox(height: AppTypography.spacingMedium),
          _buildToggleOption(
            l10n.gravityWellsDescription,
            AppLocalizations.of(context)!.showGravitationalFieldVisualization,
            Icons.grain,
            _showGravityWell,
            () {
              setState(() {
                _showGravityWell = !_showGravityWell;
              });
              _updateBodyProperty();
            },
          ),

          SectionDivider.plain(topSpacing: AppTypography.spacingSmall),

          // Mass Section - no labeled divider, just spacing
          SizedBox(height: AppTypography.spacingLarge),
          HapticSliderOption.detailed(
            label: AppLocalizations.of(context)!.bodyPropertiesMass,
            value: _massSlider,
            min: BodyTypeRanges.getMassRange(_selectedBodyType)['min']!,
            max: BodyTypeRanges.getMassRange(_selectedBodyType)['max']!,
            divisions: 100,
            icon: Icons.fitness_center,
            onChanged: (value) {
              setState(() {
                _massSlider = value;
                _massController.text = value.toString();
              });
              _updateBodyProperty();
            },
            formatter: (value) => NumberUtils.formatMassInSolarMasses(value),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
            ),
            child: Text(
              AppLocalizations.of(context)!.bodyPropertiesMassHint,
              style: AppTypography.smallText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          SectionDivider.plain(
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingXSmall,
          ),

          // Radius Section
          SizedBox(height: AppTypography.spacingMedium),
          HapticSliderOption.detailed(
            label: AppLocalizations.of(context)!.bodyPropertiesRadius,
            value: _radiusSlider,
            min: BodyTypeRanges.getRadiusRange(_selectedBodyType)['min']!,
            max: BodyTypeRanges.getRadiusRange(_selectedBodyType)['max']!,
            divisions: 100,
            icon: Icons.radio_button_unchecked,
            onChanged: (value) {
              setState(() {
                _radiusSlider = value;
                _radiusController.text = value.toString();
              });
              _updateBodyProperty();
            },
            formatter: (value) => NumberUtils.formatRadiusInSolarRadii(value),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
            ),
            child: Text(
              AppLocalizations.of(context)!.bodyPropertiesRadiusHint,
              style: AppTypography.smallText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          SectionDivider.plain(
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingXSmall,
          ),

          // Stellar Luminosity Section (only for stars)
          if (_selectedBodyType == BodyType.star) ...[
            SizedBox(height: AppTypography.spacingMedium),
            HapticSliderOption.detailed(
              label: AppLocalizations.of(context)!.bodyPropertiesLuminosity,
              value: _luminositySlider,
              min: BodyTypeRanges.getLuminosityRange(_selectedBodyType)['min']!,
              max: BodyTypeRanges.getLuminosityRange(_selectedBodyType)['max']!,
              divisions: 100,
              icon: Icons.light_mode_outlined,
              onChanged: (value) {
                setState(() {
                  _luminositySlider = value;
                  _luminosityController.text = value.toString();
                });
                _updateBodyProperty();
              },
              formatter: (value) => NumberUtils.formatLuminosity(value),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
              ),
              child: Text(
                l10n.lightEnergyOutputDescription,
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],

          SectionDivider.plain(
            topSpacing: AppTypography.spacingLarge,
            bottomSpacing: AppTypography.spacingXSmall,
          ),

          // Temperature Section
          SizedBox(height: AppTypography.spacingMedium),
          Consumer<AppState>(
            builder: (context, appState, child) {
              final kelvinRange = BodyTypeRanges.getTemperatureRange(
                _selectedBodyType,
              );
              final convertedRange = NumberUtils.convertTemperatureRange(
                kelvinRange,
                appState.ui.temperatureUnit,
              );
              final convertedValue = NumberUtils.convertTemperatureFromKelvin(
                _temperatureSlider,
                appState.ui.temperatureUnit,
              );

              return HapticSliderOption.detailed(
                label: AppLocalizations.of(context)!.temperatureEditorlabel,
                value: convertedValue,
                min: convertedRange['min']!,
                max: convertedRange['max']!,
                divisions: 200,
                icon: Icons.thermostat_outlined,
                onChanged: (value) {
                  final kelvinValue = NumberUtils.convertTemperatureToKelvin(
                    value,
                    appState.ui.temperatureUnit,
                  );
                  setState(() {
                    _temperatureSlider = kelvinValue;
                    _temperatureController.text = kelvinValue.toString();
                  });
                  _updateBodyProperty();
                },
                formatter: (value) {
                  return NumberUtils.formatTemperatureWithUnit(
                    NumberUtils.convertTemperatureToKelvin(
                      value,
                      appState.ui.temperatureUnit,
                    ),
                    appState.ui.temperatureUnit,
                  );
                },
              );
            },
          ),
          Consumer<AppState>(
            builder: (context, appState, child) {
              String hintText;
              if (_selectedBodyType == BodyType.star) {
                hintText = l10n.stellarTemperatureDescription;
              } else {
                switch (appState.ui.temperatureUnit) {
                  case TemperatureUnit.celsius:
                    hintText = l10n.temperatureCelsiusEditorhint;
                    break;
                  case TemperatureUnit.fahrenheit:
                    hintText = l10n.temperatureFahrenheitEditorhint;
                    break;
                  case TemperatureUnit.kelvin:
                    hintText = l10n.temperatureKEditorhint;
                    break;
                }
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTypography.spacingMedium,
                ),
                child: Text(
                  hintText,
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityHigh,
                    ),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            },
          ),

          // Orbital Placement Section (only show if there are available central bodies)
          if (widget.availableCentralBodies.isNotEmpty) ...[
            SectionDivider.labeled(
              l10n.orbitalPlacementEditor,
              topSpacing: AppTypography.spacingLarge,
              bottomSpacing: AppTypography.spacingMedium,
            ),
            _buildOrbitalPlacementSection(l10n),
          ],

          // Position and Velocity Sections (only show when not using orbital placement)
          if (!_isOrbitalPlacementUIActive) ...[
            // Position Section
            SectionDivider.labeled(
              l10n.positionMEditor,
              topSpacing: AppTypography.spacingLarge,
              bottomSpacing: AppTypography.spacingMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildCompactCoordinateField(
                    controller: _positionXController,
                    coordinate: l10n.xCoordinateLabel,
                    hintText: AppLocalizations.of(
                      context,
                    )!.xCoordinateEditorhint,
                    onChanged: (value) => _updateBodyProperty(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: _buildCompactCoordinateField(
                    controller: _positionYController,
                    coordinate: l10n.yCoordinateLabel,
                    hintText: AppLocalizations.of(
                      context,
                    )!.yCoordinateEditorhint,
                    onChanged: (value) => _updateBodyProperty(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: _buildCompactCoordinateField(
                    controller: _positionZController,
                    coordinate: l10n.zCoordinateLabel,
                    hintText: AppLocalizations.of(
                      context,
                    )!.zCoordinateEditorhint,
                    onChanged: (value) => _updateBodyProperty(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTypography.spacingMedium),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
              ),
              child: Text(
                l10n.spatialCoordinatesDescription,
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            // Velocity Section
            SectionDivider.labeled(
              l10n.velocityMsEditor,
              topSpacing: AppTypography.spacingLarge,
              bottomSpacing: AppTypography.spacingMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildCompactCoordinateField(
                    controller: _velocityXController,
                    coordinate: l10n.xCoordinateLabel,
                    hintText: AppLocalizations.of(context)!.xVelocityEditorhint,
                    onChanged: (value) => _updateBodyProperty(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: _buildCompactCoordinateField(
                    controller: _velocityYController,
                    coordinate: l10n.yCoordinateLabel,
                    hintText: AppLocalizations.of(context)!.yVelocityEditorhint,
                    onChanged: (value) => _updateBodyProperty(),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: AppTypography.spacingSmall),
                Expanded(
                  child: _buildCompactCoordinateField(
                    controller: _velocityZController,
                    coordinate: l10n.zCoordinateLabel,
                    hintText: AppLocalizations.of(context)!.zVelocityEditorhint,
                    onChanged: (value) => _updateBodyProperty(),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTypography.spacingMedium),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTypography.spacingMedium,
              ),
              child: Text(
                l10n.initialMotionVectorsDescription,
                style: AppTypography.smallText.copyWith(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],

          // Final spacing
          SizedBox(height: AppTypography.spacingLarge),
        ],
      ),
    );
  }

  void _updateBodyProperty() {
    try {
      final updatedBody = Body(
        name: _nameController.text,
        position: vm.Vector3(
          double.tryParse(_positionXController.text) ?? widget.body.position.x,
          double.tryParse(_positionYController.text) ?? widget.body.position.y,
          double.tryParse(_positionZController.text) ?? widget.body.position.z,
        ),
        velocity: vm.Vector3(
          double.tryParse(_velocityXController.text) ?? widget.body.velocity.x,
          double.tryParse(_velocityYController.text) ?? widget.body.velocity.y,
          double.tryParse(_velocityZController.text) ?? widget.body.velocity.z,
        ),
        mass: _massSlider, // Use slider value
        radius: _radiusSlider, // Use slider value
        color: _selectedColor, // Use local color state
        bodyType: _selectedBodyType, // Use local body type state
        stellarLuminosity: _luminositySlider, // Use slider value
        temperature: _temperatureSlider, // Use slider value
        showGravityWell: _showGravityWell, // Use local gravity well state
        isPlanet: widget.body.isPlanet,
        habitabilityStatus: widget.body.habitabilityStatus,
        isOrbitalPlacementActive:
            _showOrbitalPlacement, // Include orbital placement state
        orbitRadius: _orbitRadius, // Include orbital parameters
        orbitPhase: _orbitPhase,
        orbitInclination: _orbitInclination,
      );

      // Track unsaved changes by comparing with original body
      final hasChanges = updatedBody != _originalBody;
      if (hasChanges != _hasUnsavedChanges) {
        setState(() {
          _hasUnsavedChanges = hasChanges;
        });

        // Trigger auto-save if there are changes
        if (hasChanges) {
          _triggerAutoSave();
        }
      }

      // Log analytics for body editing (but only if there's an actual change)
      if (updatedBody != widget.body) {
        FirebaseService.instance.logUIEventWithEnums(
          UIAction.bodyEdited,
          element: UIElement.bodyEditor,
          additionalParams: {
            'body_name': widget.body.name,
            'property_changed': _getChangedProperty(updatedBody),
          },
        );
      }

      widget.onBodyChanged(updatedBody);
    } catch (e) {
      // Invalid input, ignore the update
      debugPrint('Invalid body property input: $e');
    }
  }

  String _getChangedProperty(Body updatedBody) {
    if (updatedBody.name != widget.body.name) return 'name';
    if (updatedBody.mass != widget.body.mass) return 'mass';
    if (updatedBody.radius != widget.body.radius) return 'radius';
    if (updatedBody.position != widget.body.position) return 'position';
    if (updatedBody.velocity != widget.body.velocity) return 'velocity';
    if (updatedBody.temperature != widget.body.temperature) {
      return 'temperature';
    }
    if (updatedBody.stellarLuminosity != widget.body.stellarLuminosity) {
      return 'luminosity';
    }
    return 'unknown';
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    String? labelText,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText,
            style: TextStyle(
              color: AppColors.uiWhite,
              fontSize: AppTypography.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppTypography.spacingSmall),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityBarely,
            ),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            border: Border.all(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              width: AppTypography.borderMedium,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppTypography.spacingMedium,
                  right: AppTypography.spacingSmall,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: AppTypography.iconSizeLarge,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    color: AppColors.uiWhite,
                    fontSize: AppTypography.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityHigh,
                      ),
                      fontSize: AppTypography.fontSizeLarge,
                      fontWeight: FontWeight.normal,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppTypography.spacingLarge,
                      horizontal: AppTypography.spacingMedium,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppTypography.spacingMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactCoordinateField({
    required TextEditingController controller,
    required String coordinate,
    required String hintText,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.uiWhite.withValues(alpha: AppTypography.opacityBarely),
        borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
        border: Border.all(
          color: AppColors.primaryColor.withValues(
            alpha: AppTypography.opacityHigh,
          ),
          width: AppTypography.borderMedium,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppTypography.spacingMedium,
              right: AppTypography.spacingSmall,
            ),
            child: Text(
              coordinate,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: AppTypography.fontSizeXLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: keyboardType,
              style: TextStyle(
                color: AppColors.uiWhite,
                fontSize: AppTypography.fontSizeLarge,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityHigh,
                  ),
                  fontSize: AppTypography.fontSizeLarge,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppTypography.spacingLarge,
                  horizontal: AppTypography.spacingMedium,
                ),
              ),
            ),
          ),
          SizedBox(width: AppTypography.spacingMedium),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleText.copyWith(
            color: AppColors.uiWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: AppTypography.spacingMedium),
        ...children,
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppTypography.spacingSmall),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            ),
            child: Icon(icon, color: color, size: AppTypography.iconSizeMedium),
          ),
          SizedBox(width: AppTypography.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.smallText.copyWith(
                    color: AppColors.uiWhite.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.mediumText.copyWith(
                    color: AppColors.uiWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Generates realistic body properties based on body type
  Map<String, double> _generateRealisticProperties(BodyType bodyType) {
    final random = math.Random();

    switch (bodyType) {
      case BodyType.star:
        // Use BodyTypeRanges for consistency with sliders, but bias toward typical star masses
        final massRange = BodyTypeRanges.getMassRange(BodyType.star);
        final radiusRange = BodyTypeRanges.getRadiusRange(BodyType.star);
        final luminosityRange = BodyTypeRanges.getLuminosityRange(
          BodyType.star,
        );
        final temperatureRange = BodyTypeRanges.getTemperatureRange(
          BodyType.star,
        );

        // Bias toward medium-sized stars (main sequence stars are most common)
        // Use a higher exponent to favor smaller values
        final massRandom = random.nextDouble();
        final massBias = math
            .pow(massRandom, 2.5)
            .toDouble(); // Higher exponent favors smaller values

        final radiusRandom = random.nextDouble();
        final radiusBias = math
            .pow(radiusRandom, 0.8)
            .toDouble(); // Slight bias toward smaller radii

        final luminosityRandom = random.nextDouble();
        final luminosityBias = math
            .pow(luminosityRandom, 1.2)
            .toDouble(); // Slight bias toward lower luminosity

        final temperatureRandom = random.nextDouble();
        final temperatureBias = math
            .pow(temperatureRandom, 1.5)
            .toDouble(); // Bias toward lower temperature stars

        return {
          'mass':
              massRange['min']! +
              massBias * (massRange['max']! - massRange['min']!),
          'radius':
              radiusRange['min']! +
              radiusBias * (radiusRange['max']! - radiusRange['min']!),
          'luminosity':
              luminosityRange['min']! +
              luminosityBias *
                  (luminosityRange['max']! - luminosityRange['min']!),
          'temperature':
              temperatureRange['min']! +
              temperatureBias *
                  (temperatureRange['max']! - temperatureRange['min']!),
          'positionX':
              -10 +
              random.nextDouble() * 20, // Random position between -10 and 10
          'positionY': -10 + random.nextDouble() * 20,
          'positionZ': -5 + random.nextDouble() * 10,
          'velocityX':
              -0.5 +
              random.nextDouble() * 1.0, // Random velocity between -0.5 and 0.5
          'velocityY': -0.5 + random.nextDouble() * 1.0,
          'velocityZ': -0.2 + random.nextDouble() * 0.4,
        };

      case BodyType.planet:
        // Choose random planet category
        final planetType = random.nextDouble();
        final tempRange = BodyTypeRanges.getTemperatureRange(BodyType.planet);

        if (planetType < SimulationConstants.smallPlanetProbability) {
          // Small rocky planet
          return {
            'mass':
                SimulationConstants.smallPlanetMassMin +
                random.nextDouble() *
                    (SimulationConstants.smallPlanetMassMax -
                        SimulationConstants.smallPlanetMassMin),
            'radius':
                SimulationConstants.smallPlanetRadiusMin +
                random.nextDouble() *
                    (SimulationConstants.smallPlanetRadiusMax -
                        SimulationConstants.smallPlanetRadiusMin),
            'luminosity': 0.0, // Planets don't emit light
            'temperature':
                tempRange['min']! +
                random.nextDouble() * (tempRange['max']! - tempRange['min']!),
            'positionX': -15 + random.nextDouble() * 30,
            'positionY': -15 + random.nextDouble() * 30,
            'positionZ': -8 + random.nextDouble() * 16,
            'velocityX': -0.3 + random.nextDouble() * 0.6,
            'velocityY': -0.3 + random.nextDouble() * 0.6,
            'velocityZ': -0.15 + random.nextDouble() * 0.3,
          };
        } else if (planetType <
            SimulationConstants.earthLikePlanetProbability) {
          // Earth-like planet
          return {
            'mass':
                SimulationConstants.earthLikePlanetMassMin +
                random.nextDouble() *
                    (SimulationConstants.earthLikePlanetMassMax -
                        SimulationConstants.earthLikePlanetMassMin),
            'radius':
                SimulationConstants.earthLikePlanetRadiusMin +
                random.nextDouble() *
                    (SimulationConstants.earthLikePlanetRadiusMax -
                        SimulationConstants.earthLikePlanetRadiusMin),
            'luminosity': 0.0,
            'temperature':
                tempRange['min']! +
                random.nextDouble() * (tempRange['max']! - tempRange['min']!),
            'positionX': -15 + random.nextDouble() * 30,
            'positionY': -15 + random.nextDouble() * 30,
            'positionZ': -8 + random.nextDouble() * 16,
            'velocityX': -0.3 + random.nextDouble() * 0.6,
            'velocityY': -0.3 + random.nextDouble() * 0.6,
            'velocityZ': -0.15 + random.nextDouble() * 0.3,
          };
        } else {
          // Super-Earth
          return {
            'mass':
                SimulationConstants.superEarthMassMin +
                random.nextDouble() *
                    (SimulationConstants.superEarthMassMax -
                        SimulationConstants.superEarthMassMin),
            'radius':
                SimulationConstants.superEarthRadiusMin +
                random.nextDouble() *
                    (SimulationConstants.superEarthRadiusMax -
                        SimulationConstants.superEarthRadiusMin),
            'luminosity': 0.0,
            'temperature':
                tempRange['min']! +
                random.nextDouble() * (tempRange['max']! - tempRange['min']!),
            'positionX': -15 + random.nextDouble() * 30,
            'positionY': -15 + random.nextDouble() * 30,
            'positionZ': -8 + random.nextDouble() * 16,
            'velocityX': -0.3 + random.nextDouble() * 0.6,
            'velocityY': -0.3 + random.nextDouble() * 0.6,
            'velocityZ': -0.15 + random.nextDouble() * 0.3,
          };
        }

      case BodyType.moon:
        final moonTempRange = BodyTypeRanges.getTemperatureRange(BodyType.moon);
        return {
          'mass': 0.3 + random.nextDouble() * 0.7, // 0.3 to 1.0
          'radius': 0.3 + random.nextDouble() * 0.4, // 0.3 to 0.7
          'luminosity': 0.0,
          'temperature':
              moonTempRange['min']! +
              random.nextDouble() *
                  (moonTempRange['max']! - moonTempRange['min']!),
          'positionX': -8 + random.nextDouble() * 16,
          'positionY': -8 + random.nextDouble() * 16,
          'positionZ': -4 + random.nextDouble() * 8,
          'velocityX': -0.4 + random.nextDouble() * 0.8,
          'velocityY': -0.4 + random.nextDouble() * 0.8,
          'velocityZ': -0.2 + random.nextDouble() * 0.4,
        };

      case BodyType.asteroid:
        final asteroidTempRange = BodyTypeRanges.getTemperatureRange(
          BodyType.asteroid,
        );
        return {
          'mass': 0.05 + random.nextDouble() * 0.2, // 0.05 to 0.25
          'radius': 0.1 + random.nextDouble() * 0.3, // 0.1 to 0.4
          'luminosity': 0.0,
          'temperature':
              asteroidTempRange['min']! +
              random.nextDouble() *
                  (asteroidTempRange['max']! - asteroidTempRange['min']!),
          'positionX': -20 + random.nextDouble() * 40,
          'positionY': -20 + random.nextDouble() * 40,
          'positionZ': -10 + random.nextDouble() * 20,
          'velocityX': -1.0 + random.nextDouble() * 2.0,
          'velocityY': -1.0 + random.nextDouble() * 2.0,
          'velocityZ': -0.5 + random.nextDouble() * 1.0,
        };

      case BodyType.blackHole:
        final blackHoleRanges = {
          'mass': BodyTypeRanges.getMassRange(BodyType.blackHole),
          'radius': BodyTypeRanges.getRadiusRange(BodyType.blackHole),
          'temperature': BodyTypeRanges.getTemperatureRange(BodyType.blackHole),
        };
        return {
          'mass':
              blackHoleRanges['mass']!['min']! +
              random.nextDouble() *
                  (blackHoleRanges['mass']!['max']! -
                      blackHoleRanges['mass']!['min']!),
          'radius':
              blackHoleRanges['radius']!['min']! +
              random.nextDouble() *
                  (blackHoleRanges['radius']!['max']! -
                      blackHoleRanges['radius']!['min']!),
          'luminosity': 0.0, // Black holes don't emit light
          'temperature':
              blackHoleRanges['temperature']!['min']! +
              random.nextDouble() *
                  (blackHoleRanges['temperature']!['max']! -
                      blackHoleRanges['temperature']!['min']!),
          'positionX': -15 + random.nextDouble() * 30,
          'positionY': -15 + random.nextDouble() * 30,
          'positionZ': -5 + random.nextDouble() * 10,
          'velocityX': -0.5 + random.nextDouble() * 1.0,
          'velocityY': -0.5 + random.nextDouble() * 1.0,
          'velocityZ': -0.2 + random.nextDouble() * 0.4,
        };

      case BodyType.neutronStar:
        final neutronStarRanges = {
          'mass': BodyTypeRanges.getMassRange(BodyType.neutronStar),
          'radius': BodyTypeRanges.getRadiusRange(BodyType.neutronStar),
          'luminosity': BodyTypeRanges.getLuminosityRange(BodyType.neutronStar),
          'temperature': BodyTypeRanges.getTemperatureRange(
            BodyType.neutronStar,
          ),
        };
        return {
          'mass':
              neutronStarRanges['mass']!['min']! +
              random.nextDouble() *
                  (neutronStarRanges['mass']!['max']! -
                      neutronStarRanges['mass']!['min']!),
          'radius':
              neutronStarRanges['radius']!['min']! +
              random.nextDouble() *
                  (neutronStarRanges['radius']!['max']! -
                      neutronStarRanges['radius']!['min']!),
          'luminosity':
              neutronStarRanges['luminosity']!['min']! +
              random.nextDouble() *
                  (neutronStarRanges['luminosity']!['max']! -
                      neutronStarRanges['luminosity']!['min']!),
          'temperature':
              neutronStarRanges['temperature']!['min']! +
              random.nextDouble() *
                  (neutronStarRanges['temperature']!['max']! -
                      neutronStarRanges['temperature']!['min']!),
          'positionX': -10 + random.nextDouble() * 20,
          'positionY': -10 + random.nextDouble() * 20,
          'positionZ': -5 + random.nextDouble() * 10,
          'velocityX': -1.0 + random.nextDouble() * 2.0,
          'velocityY': -1.0 + random.nextDouble() * 2.0,
          'velocityZ': -0.5 + random.nextDouble() * 1.0,
        };
    }
  }

  Color _getBodyTypeColor(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.star:
        return AppColors.uiYellow;
      case BodyType.planet:
        return AppColors.uiCyan;
      case BodyType.moon:
        return AppColors.testMediumGray;
      case BodyType.asteroid:
        return AppColors.uiOrange;
      case BodyType.blackHole:
        return AppColors.spacePureBlack;
      case BodyType.neutronStar:
        return AppColors.pulsarCyan;
    }
  }

  String _formatMass(double mass) {
    return NumberUtils.formatMassInSolarMasses(mass);
  }

  String _formatRadius(double radius) {
    return NumberUtils.formatRadiusInSolarRadii(radius);
  }

  String _formatTemperature(double temperature) {
    return NumberUtils.formatTemperature(temperature);
  }

  String _formatLuminosity(double luminosity) {
    return NumberUtils.formatLuminosity(luminosity);
  }

  String _formatVector(vm.Vector3 vector) {
    return NumberUtils.formatVector3(vector);
  }

  /// Build orbital placement section UI
  Widget _buildOrbitalPlacementSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTypography.spacingMedium,
          ),
          child: Text(
            _isOrbitalPlacementUIActive
                ? l10n.orbitalPlacementActiveDescription
                : l10n.orbitalPlacementDescription,
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: AppTypography.spacingMedium),

        // Place in Orbit Toggle Button
        _showOrbitalPlacement
            ? HapticButton.destructive(
                onPressed: _cancelOrbitalPlacement,
                text: AppLocalizations.of(context)!.cancelOrbitalPlacement,
                icon: Icons.close,
                isFullWidth: true,
              )
            : HapticButton.primary(
                onPressed: _enableOrbitalPlacement,
                text: l10n.placeInOrbitButton,
                icon: Icons.track_changes,
                isFullWidth: true,
              ),

        // Orbital Parameters (only show when placement mode is active)
        if (_showOrbitalPlacement) ...[
          SizedBox(height: AppTypography.spacingLarge),

          // Orbital placement container with fixed constraints
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Central Body Selector
                _buildCentralBodySelector(l10n),
                SizedBox(height: AppTypography.spacingMedium),

                // Orbit Radius Slider
                HapticSliderOption.detailed(
                  label: l10n.orbitRadiusEditor,
                  value: _orbitRadius,
                  min: 5.0,
                  max: 500.0,
                  divisions: 99, // 100 steps for better granularity
                  icon: Icons.radio_button_unchecked,
                  onChanged: (value) {
                    setState(() {
                      _orbitRadius = value;
                    });
                    _applyOrbitalPlacement();
                  },
                  formatter: (value) => NumberUtils.formatDecimal(value, 1),
                ),

                // Orbit Phase Slider (starting position)
                HapticSliderOption.detailed(
                  label: l10n.orbitPhaseEditor,
                  value: _orbitPhase,
                  min: 0.0,
                  max: 2 * math.pi,
                  divisions: 360,
                  icon: Icons.restart_alt,
                  onChanged: (value) {
                    setState(() {
                      _orbitPhase = value;
                    });
                    _applyOrbitalPlacement();
                  },
                  formatter: (value) =>
                      '${NumberUtils.formatDecimal(value * 180 / math.pi, 0)}°',
                ),

                // Orbit Inclination Slider
                HapticSliderOption.detailed(
                  label: l10n.orbitInclinationEditor,
                  value: _orbitInclination,
                  min: 0.0,
                  max: math.pi / 2,
                  divisions: 90,
                  icon: Icons.rotate_90_degrees_ccw,
                  onChanged: (value) {
                    setState(() {
                      _orbitInclination = value;
                    });
                    _applyOrbitalPlacement();
                  },
                  formatter: (value) =>
                      '${NumberUtils.formatDecimal(value * 180 / math.pi, 0)}°',
                ),

                // Orbital Period Display (read-only info)
                if (_selectedCentralBody != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppTypography.spacingLarge),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withValues(alpha: 0.1),
                          AppColors.primaryColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusLarge,
                      ),
                      border: Border.all(
                        color: AppColors.primaryColor.withValues(alpha: 0.4),
                        width: AppTypography.borderMedium,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: AppColors.primaryColor,
                          size: AppTypography.iconSizeMedium,
                        ),
                        SizedBox(width: AppTypography.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.orbitalPeriodLabel,
                                style: AppTypography.mediumText.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppTypography.spacingSmall),
                              Text(
                                _calculateOrbitalPeriodText(context),
                                style: AppTypography.largeText.copyWith(
                                  color: AppColors.uiWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Stability Indicator and Make Stable Button
                if (_selectedCentralBody != null) ...[
                  SizedBox(height: AppTypography.spacingMedium),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppTypography.spacingLarge),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isCurrentOrbitStable()
                            ? [
                                AppColors.primaryColor.withValues(alpha: 0.1),
                                AppColors.primaryColor.withValues(alpha: 0.05),
                              ]
                            : [
                                AppColors.celestialOrange.withValues(
                                  alpha: 0.2,
                                ),
                                AppColors.celestialOrange.withValues(
                                  alpha: 0.1,
                                ),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusLarge,
                      ),
                      border: Border.all(
                        color: _isCurrentOrbitStable()
                            ? AppColors.primaryColor.withValues(alpha: 0.4)
                            : AppColors.celestialOrange.withValues(alpha: 0.6),
                        width: AppTypography.borderMedium,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isCurrentOrbitStable()
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: _isCurrentOrbitStable()
                                  ? AppColors.primaryColor
                                  : AppColors.celestialOrange,
                              size: AppTypography.iconSizeMedium,
                            ),
                            SizedBox(width: AppTypography.spacingMedium),
                            Expanded(
                              child: Text(
                                _isCurrentOrbitStable()
                                    ? AppLocalizations.of(
                                        context,
                                      )!.orbitIsStable
                                    : AppLocalizations.of(
                                        context,
                                      )!.orbitMayBeUnstable,
                                style: AppTypography.mediumText.copyWith(
                                  color: _isCurrentOrbitStable()
                                      ? AppColors.primaryColor
                                      : AppColors.celestialOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!_isCurrentOrbitStable()) ...[
                          SizedBox(height: AppTypography.spacingSmall),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.orbitalConfigurationWarning,
                            style: AppTypography.smallText.copyWith(
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityHigh,
                              ),
                            ),
                          ),
                          SizedBox(height: AppTypography.spacingMedium),
                          HapticButton.primary(
                            onPressed: _makeOrbitStable,
                            text: AppLocalizations.of(context)!.makeStable,
                            icon: Icons.auto_fix_high,
                            isFullWidth: true,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Orbital Guidance Message
                  SizedBox(height: AppTypography.spacingMedium),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppTypography.spacingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundBlack.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(
                        AppTypography.radiusMedium,
                      ),
                      border: Border.all(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      _getOrbitalGuidanceMessage(context),
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityMediumHigh,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Build central body selector dropdown
  Widget _buildCentralBodySelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionDivider.labeled(l10n.centralBodySelector),
        SizedBox(height: AppTypography.spacingMedium),
        Container(
          width: double.infinity,
          height: 56.0,
          padding: EdgeInsets.symmetric(
            horizontal: AppTypography.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityBarely,
            ),
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            border: Border.all(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              width: AppTypography.borderMedium,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Body>(
              value:
                  _selectedCentralBody ?? widget.availableCentralBodies.first,
              isExpanded: true,
              dropdownColor: AppColors.uiBlack,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
              items: widget.availableCentralBodies.map((body) {
                return DropdownMenuItem<Body>(
                  value: body,
                  child: Row(
                    children: [
                      Icon(
                        Icons.center_focus_strong,
                        color: AppColors.primaryColor,
                        size: AppTypography.iconSizeMedium,
                      ),
                      SizedBox(width: AppTypography.spacingSmall),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: body.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppTypography.spacingSmall),
                      Expanded(
                        child: Text(
                          body.name.isEmpty
                              ? AppLocalizations.of(
                                  context,
                                )!.bodyTypeGeneric(body.bodyType.name)
                              : body.name,
                          style: AppTypography.mediumText.copyWith(
                            color: AppColors.uiWhite,
                          ),
                        ),
                      ),
                      Text(
                        NumberUtils.formatMassInSolarMasses(body.mass),
                        style: AppTypography.smallText.copyWith(
                          color: AppColors.uiWhite.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Body? newBody) {
                // Add haptic feedback for central body selection
                HapticFeedback.lightImpact();

                setState(() {
                  _selectedCentralBody = newBody;
                  if (newBody != null) {
                    // Auto-calculate safe orbit radius
                    _orbitRadius =
                        OrbitalMechanicsService.calculateSafeOrbitRadius(
                          newBody,
                          widget.body,
                        );
                  }
                });
                _applyOrbitalPlacement();
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Enable orbital placement mode
  void _enableOrbitalPlacement() {
    setState(() {
      _showOrbitalPlacement = true;
      _isOrbitalPlacementUIActive = true;
      // Auto-select the most massive body as default central body
      if (widget.availableCentralBodies.isNotEmpty) {
        _selectedCentralBody = OrbitalMechanicsService.findCentralBody(
          widget.availableCentralBodies,
        );
        if (_selectedCentralBody != null) {
          _orbitRadius = OrbitalMechanicsService.calculateSafeOrbitRadius(
            _selectedCentralBody!,
            widget.body,
          );
          // Automatically apply orbital placement to set correct velocity
          Future.delayed(const Duration(milliseconds: 100), () {
            _applyOrbitalPlacement();
          });
        }
      }
    });
    // Notify parent of state change
    _updateBodyProperty();
  }

  /// Cancel orbital placement mode
  void _cancelOrbitalPlacement() {
    setState(() {
      _showOrbitalPlacement = false;
      _isOrbitalPlacementUIActive = false;
      _selectedCentralBody = null;
    });
    // Notify parent of state change
    _updateBodyProperty();
  }

  /// Apply orbital placement calculations to the body
  void _applyOrbitalPlacement() {
    if (_selectedCentralBody == null) return;

    try {
      final placement = OrbitalMechanicsService.calculateCircularOrbit(
        centralBody: _selectedCentralBody!,
        orbitRadius: _orbitRadius,
        orbitPhase: _orbitPhase,
        inclination: _orbitInclination,
      );

      // Update position and velocity controllers
      _positionXController.text = placement.position.x.toString();
      _positionYController.text = placement.position.y.toString();
      _positionZController.text = placement.position.z.toString();
      _velocityXController.text = placement.velocity.x.toString();
      _velocityYController.text = placement.velocity.y.toString();
      _velocityZController.text = placement.velocity.z.toString();

      // Update the body immediately
      _updateBodyProperty();
    } catch (e) {
      debugPrint('Error applying orbital placement: $e');
    }
  }

  /// Check if current orbital configuration is stable
  bool _isCurrentOrbitStable() {
    if (_selectedCentralBody == null) return false;

    return OrbitalMechanicsService.isOrbitStable(
      _selectedCentralBody!,
      widget.body,
      _orbitRadius,
    );
  }

  /// Calculate stable orbital parameters and apply them
  void _makeOrbitStable() {
    if (_selectedCentralBody == null) return;

    // Store old radius for comparison
    final oldRadius = _orbitRadius;

    setState(() {
      // Calculate safe orbital radius
      final safeRadius = OrbitalMechanicsService.calculateSafeOrbitRadius(
        _selectedCentralBody!,
        widget.body,
      );

      // Update orbital radius to safe value
      _orbitRadius = safeRadius;

      // Normalize phase to a standard position (0 radians = positive X-axis)
      _orbitPhase = 0.0;

      // Set inclination to 0 for a stable equatorial orbit
      _orbitInclination = 0.0;

      // Apply the orbital placement with stable parameters
      _applyOrbitalPlacement();
    });

    // Calculate the change in radius for user feedback
    final radiusChange = _orbitRadius - oldRadius;
    final changeDescription = radiusChange > 0.1
        ? AppLocalizations.of(
            context,
          )!.orbitalRadiusIncreasedFeedback(radiusChange.toStringAsFixed(1))
        : radiusChange < -0.1
        ? AppLocalizations.of(
            context,
          )!.orbitalRadiusDecreasedFeedback((-radiusChange).toStringAsFixed(1))
        : AppLocalizations.of(context)!.orbitalRadiusFineTunedFeedback;

    // Haptic feedback for the action
    HapticFeedback.mediumImpact();

    // Show detailed feedback to user
    GravitonSnackBar.success(
      context: context,
      message: AppLocalizations.of(context)!.orbitStabilizedMessage(
        changeDescription,
        _orbitRadius.toStringAsFixed(1),
      ),
      duration: const Duration(seconds: 4),
    );
  }

  /// Get orbital guidance message based on mass hierarchy
  String _getOrbitalGuidanceMessage(BuildContext context) {
    if (_selectedCentralBody == null) return '';

    final centralMass = _selectedCentralBody!.mass;
    final orbitingMass = widget.body.mass;

    if (orbitingMass > centralMass * 0.5) {
      return AppLocalizations.of(context)!.orbitalWarningMassiveBody;
    } else if (orbitingMass > centralMass * 0.1) {
      return AppLocalizations.of(context)!.orbitalTipSignificantMass;
    } else if (_orbitRadius < 10.0) {
      return AppLocalizations.of(context)!.orbitalWarningCloseOrbit;
    } else if (_orbitRadius > 50.0) {
      return AppLocalizations.of(context)!.orbitalTipDistantOrbit;
    } else {
      return AppLocalizations.of(context)!.orbitalGoodConfiguration;
    }
  }

  /// Calculate orbital period text for display
  String _calculateOrbitalPeriodText(BuildContext context) {
    if (_selectedCentralBody == null) {
      return AppLocalizations.of(context)!.unknownValue;
    }

    try {
      final placement = OrbitalMechanicsService.calculateCircularOrbit(
        centralBody: _selectedCentralBody!,
        orbitRadius: _orbitRadius,
        orbitPhase: 0.0,
      );

      return NumberUtils.formatDecimal(placement.orbitalPeriod, 1);
    } catch (e) {
      return AppLocalizations.of(context)!.orbitalError;
    }
  }

  /// Build a toggle option with consistent styling matching camera controls
  Widget _buildToggleOption(
    String title,
    String description,
    IconData icon,
    bool isEnabled,
    VoidCallback onToggle,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: Material(
        color: AppColors.transparentColor,
        child: HapticInkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
          child: Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    )
                  : AppColors.uiWhite.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: isEnabled
                  ? Border.all(
                      color: AppColors.primaryColor,
                      width: AppTypography.borderThin,
                    )
                  : Border.all(
                      color: AppColors.uiWhite.withValues(
                        alpha: AppTypography.opacityDisabled,
                      ),
                      width: AppTypography.borderThin,
                    ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isEnabled
                      ? AppColors.primaryColor
                      : AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                  size: AppTypography.iconSizeXXLarge,
                ),
                SizedBox(width: AppTypography.spacingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isEnabled
                              ? AppColors.primaryColor
                              : AppColors.uiWhite,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.uiWhite.withValues(
                            alpha: AppTypography.opacityHigh,
                          ),
                          fontSize: AppTypography.fontSizeMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                HapticSwitch(
                  value: isEnabled,
                  onChanged: (_) => onToggle(),
                  activeColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor.withValues(
                    alpha: AppTypography.opacityFaint,
                  ),
                  inactiveThumbColor: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityMedium,
                  ),
                  inactiveTrackColor: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
