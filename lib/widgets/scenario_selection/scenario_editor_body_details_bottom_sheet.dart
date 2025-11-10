import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/constants/simulation_constants.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/body_type_ranges.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/common/body_type_picker.dart';
import 'package:graviton/widgets/common/color_picker.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/haptics/haptic_slider_option.dart';
import 'package:graviton/widgets/common/section_divider.dart';
import 'package:graviton/widgets/section_title.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Bottom sheet widget for displaying and editing body details
class ScenarioEditorBodyDetailsBottomSheet extends StatefulWidget {
  final Body body;
  final ValueChanged<Body> onBodyChanged;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final ValueChanged<Body>? onSave;
  final bool isAddMode;

  const ScenarioEditorBodyDetailsBottomSheet({
    super.key,
    required this.body,
    required this.onBodyChanged,
    this.onDuplicate,
    this.onDelete,
    this.onSave,
    this.isAddMode = false,
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

  // Color state variable
  late Color _selectedColor;

  // Body type state variable
  late BodyType _selectedBodyType;

  // Track unsaved changes to prevent accidental closing
  bool _hasUnsavedChanges = false;

  // Store the original body to compare against
  late Body _originalBody;

  @override
  void initState() {
    super.initState();

    // Store original body for comparison
    _originalBody = widget.body;

    // Initialize body type and color first (needed for range calculations)
    _selectedBodyType = widget.body.bodyType;
    _selectedColor = widget.body.color;

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

    _massSlider = widget.body.mass.clamp(massRange['min']!, massRange['max']!);
    _radiusSlider = widget.body.radius.clamp(
      radiusRange['min']!,
      radiusRange['max']!,
    );
    _luminositySlider = widget.body.stellarLuminosity.clamp(
      luminosityRange['min']!,
      luminosityRange['max']!,
    );
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
    }
  }

  @override
  void dispose() {
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
                  // Action buttons
                  // Save button (always shown)
                  Semantics(
                    button: true,
                    label: widget.isAddMode
                        ? l10n.saveNewBodyAccessibility
                        : l10n.saveChangesToBodyAccessibility,
                    hint: widget.isAddMode
                        ? l10n.saveNewBodyHint
                        : l10n.saveChangesToBodyHint,
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showSaveConfirmation();
                      },
                      child: Text(
                        l10n.saveButton,
                        style: AppTypography.mediumText.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // 3-dot menu for edit mode actions
                  if (!widget.isAddMode)
                    Semantics(
                      button: true,
                      label: l10n.moreActionsAccessibility,
                      hint: l10n.moreActionsHint,
                      child: PopupMenuButton<String>(
                        onSelected: (String result) {
                          HapticFeedback.lightImpact();
                          // Log analytics for menu selection
                          FirebaseService.instance.logUIEventWithEnums(
                            UIAction.buttonPressed,
                            element: UIElement.bodyEditor,
                            value: 'menu_$result',
                            additionalParams: {
                              'body_name': widget.body.name,
                              'body_type': widget.body.bodyType.name,
                            },
                          );
                          switch (result) {
                            case 'duplicate':
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
                              break;
                            case 'delete':
                              _showDeleteConfirmation();
                              break;
                          }
                        },
                        tooltip: 'More actions',
                        icon: Icon(Icons.more_vert, color: AppColors.uiWhite),
                        color: AppColors.uiBlack.withValues(
                          alpha: AppTypography.opacityHigh,
                        ),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'duplicate',
                            height:
                                56, // Increased height for larger touch target
                            child: Semantics(
                              label: l10n.duplicateBodyTooltip,
                              hint: l10n.duplicateBodyAccessibility,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withValues(
                                                alpha: AppColors
                                                    .alphaMediumVisible,
                                              ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.content_copy_outlined,
                                        color: AppColors.primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppTypography.spacingMedium,
                                    ),
                                    Text(
                                      l10n.duplicateBodyTooltip,
                                      style: AppTypography.mediumText.copyWith(
                                        // Changed from smallText
                                        color: AppColors.uiWhite,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            height:
                                56, // Increased height for larger touch target
                            child: Semantics(
                              label: l10n.deleteBodyTooltip,
                              hint: l10n.deleteBodyAccessibility,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.accretionRed
                                              .withValues(
                                                alpha: AppColors
                                                    .alphaMediumVisible,
                                              ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppColors.accretionRed,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppTypography.spacingMedium,
                                    ),
                                    Text(
                                      l10n.deleteBodyTooltip,
                                      style: AppTypography.mediumText.copyWith(
                                        // Changed from smallText
                                        color: AppColors.uiWhite,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityVeryHigh,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
          side: BorderSide(
            color: AppColors.primaryColor.withValues(
              alpha: AppTypography.opacityMedium,
            ),
            width: 1,
          ),
        ),
        title: Text(
          l10n.unsavedChangesTitle,
          style: AppTypography.titleText.copyWith(color: AppColors.uiWhite),
        ),
        content: Text(
          l10n.unsavedChangesMessage,
          style: AppTypography.mediumText.copyWith(
            color: AppColors.uiWhite.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.uiWhite.withValues(alpha: 0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.discardButton,
              style: AppTypography.mediumText.copyWith(
                color: AppColors.accretionRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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

  void _showSaveConfirmation() {
    HapticFeedback.mediumImpact();

    // Get the current body state with all updates
    final currentBody = _getCurrentBodyState();

    // Log analytics based on mode (add vs edit)
    if (widget.isAddMode) {
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.bodyAdded,
        element: UIElement.bodyEditor,
        additionalParams: {
          'body_name': currentBody.name,
          'body_type': currentBody.bodyType.name,
          'body_mass': currentBody.mass,
        },
      );
    } else {
      FirebaseService.instance.logUIEventWithEnums(
        UIAction.bodyEdited,
        element: UIElement.bodyEditor,
        additionalParams: {
          'body_name': currentBody.name,
          'body_type': currentBody.bodyType.name,
          'body_mass': currentBody.mass,
          'original_name': _originalBody.name,
        },
      );
    }

    // Clear unsaved changes flag since we're saving
    _hasUnsavedChanges = false;

    // Close the bottom sheet and signal save to parent
    if (mounted) {
      Navigator.pop(context);
      widget.onSave?.call(currentBody);
    }
  }

  /// Get the current body state with all field updates applied
  Body _getCurrentBodyState() {
    // Use a default name if the field is empty
    final name = _nameController.text.trim();
    final defaultName = 'Celestial Body';

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
          // Name field
          _buildEditSection(
            l10n.bodyPropertiesName,
            _buildCompactTextField(
              controller: _nameController,
              icon: Icons.label_outline,
              hintText: l10n.bodyPropertiesNameHint,
              onChanged: (value) => _updateBodyProperty(),
            ),
          ),

          _buildDivider(),

          // Body Type Section
          _buildEditSection(
            l10n.bodyTypeEditor,
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

                  _positionXController.text = properties['positionX']!
                      .toString();
                  _positionYController.text = properties['positionY']!
                      .toString();
                  _positionZController.text = properties['positionZ']!
                      .toString();

                  _velocityXController.text = properties['velocityX']!
                      .toString();
                  _velocityYController.text = properties['velocityY']!
                      .toString();
                  _velocityZController.text = properties['velocityZ']!
                      .toString();
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
          ),

          _buildDivider(),

          // Color Section
          _buildEditSection(
            l10n.colorEditor,
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
          ),

          _buildDivider(),

          // Mass Section
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
          SizedBox(height: AppTypography.spacingSmall),
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

          _buildDivider(),

          // Radius Section
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
          SizedBox(height: AppTypography.spacingSmall),
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

          _buildDivider(),

          // Stellar Luminosity Section (only for stars)
          if (_selectedBodyType == BodyType.star) ...[
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
                  // Update the text controller for consistency
                  _luminosityController.text = value.toString();
                });
                _updateBodyProperty();
              },
              formatter: (value) => NumberUtils.formatLuminosity(value),
            ),
            SizedBox(height: AppTypography.spacingSmall),
            Text(
              l10n.lightEnergyOutputDescription,
              style: AppTypography.smallText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                fontStyle: FontStyle.italic,
              ),
            ),

            _buildDivider(),
          ],

          // Position Section
          _buildEditSection(
            l10n.positionMEditor,
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
          ),
          SizedBox(height: AppTypography.spacingSmall),
          Text(
            l10n.spatialCoordinatesDescription,
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),

          _buildDivider(),

          // Velocity Section
          _buildEditSection(
            l10n.velocityMsEditor,
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
          ),
          SizedBox(height: AppTypography.spacingSmall),
          Text(
            l10n.initialMotionVectorsDescription,
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),

          if (widget.body.bodyType == BodyType.star) ...[
            _buildDivider(),

            // Temperature Section (for stars only)
            _buildCompactTextField(
              controller: _temperatureController,
              icon: Icons.wb_sunny_outlined,
              hintText: AppLocalizations.of(context)!.temperatureKEditorhint,
              labelText: AppLocalizations.of(context)!.temperatureEditorlabel,
              onChanged: (value) => _updateBodyProperty(),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppTypography.spacingSmall),
            Text(
              l10n.stellarTemperatureDescription,
              style: AppTypography.smallText.copyWith(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityHigh,
                ),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
        temperature:
            double.tryParse(_temperatureController.text) ??
            widget.body.temperature,
        showGravityWell: widget.body.showGravityWell,
        isPlanet: widget.body.isPlanet,
        habitabilityStatus: widget.body.habitabilityStatus,
      );

      // Track unsaved changes by comparing with original body
      final hasChanges = updatedBody != _originalBody;
      if (hasChanges != _hasUnsavedChanges) {
        setState(() {
          _hasUnsavedChanges = hasChanges;
        });
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

  Widget _buildDivider() {
    return const SectionDivider.plain(
      topSpacing: AppTypography.spacingLarge,
      bottomSpacing: AppTypography.spacingLarge,
    );
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
            'positionX': -15 + random.nextDouble() * 30,
            'positionY': -15 + random.nextDouble() * 30,
            'positionZ': -8 + random.nextDouble() * 16,
            'velocityX': -0.3 + random.nextDouble() * 0.6,
            'velocityY': -0.3 + random.nextDouble() * 0.6,
            'velocityZ': -0.15 + random.nextDouble() * 0.3,
          };
        }

      case BodyType.moon:
        return {
          'mass': 0.3 + random.nextDouble() * 0.7, // 0.3 to 1.0
          'radius': 0.3 + random.nextDouble() * 0.4, // 0.3 to 0.7
          'luminosity': 0.0,
          'positionX': -8 + random.nextDouble() * 16,
          'positionY': -8 + random.nextDouble() * 16,
          'positionZ': -4 + random.nextDouble() * 8,
          'velocityX': -0.4 + random.nextDouble() * 0.8,
          'velocityY': -0.4 + random.nextDouble() * 0.8,
          'velocityZ': -0.2 + random.nextDouble() * 0.4,
        };

      case BodyType.asteroid:
        return {
          'mass': 0.05 + random.nextDouble() * 0.2, // 0.05 to 0.25
          'radius': 0.1 + random.nextDouble() * 0.3, // 0.1 to 0.4
          'luminosity': 0.0,
          'positionX': -20 + random.nextDouble() * 40,
          'positionY': -20 + random.nextDouble() * 40,
          'positionZ': -10 + random.nextDouble() * 20,
          'velocityX': -1.0 + random.nextDouble() * 2.0,
          'velocityY': -1.0 + random.nextDouble() * 2.0,
          'velocityZ': -0.5 + random.nextDouble() * 1.0,
        };
    }
  }

  Widget _buildEditSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: title),
        SizedBox(height: AppTypography.spacingMedium),
        child,
      ],
    );
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
}
