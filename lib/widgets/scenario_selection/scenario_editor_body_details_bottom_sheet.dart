import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/common/graviton_tabs.dart';
import 'package:graviton/widgets/common/body_type_picker.dart';
import 'package:graviton/widgets/common/color_picker.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';

/// Bottom sheet widget for displaying and editing body details
class ScenarioEditorBodyDetailsBottomSheet extends StatefulWidget {
  final Body body;
  final ValueChanged<Body> onBodyChanged;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const ScenarioEditorBodyDetailsBottomSheet({
    super.key,
    required this.body,
    required this.onBodyChanged,
    required this.onDuplicate,
    required this.onDelete,
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

  @override
  void initState() {
    super.initState();
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

    return Container(
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
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();

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

                    widget.onDuplicate();
                  },
                  icon: const Icon(Icons.content_copy_outlined),
                  color: AppColors.primaryColor,
                  tooltip: l10n.duplicateBodyTooltip,
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showDeleteConfirmation();
                  },
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.accretionRed,
                  tooltip: l10n.deleteBodyTooltip,
                ),
              ],
            ),
          ),

          // Tab Content using GravitonTabbedView
          Expanded(
            child: GravitonTabbedView(
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
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
            AppLocalizations.of(
              context,
            )!.deleteBodyConfirmTitle(widget.body.name),
            style: AppTypography.titleText.copyWith(color: AppColors.uiWhite),
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteBodyConfirmMessage,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.uiWhite.withValues(alpha: 0.7),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
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

                Navigator.of(context).pop();
                widget.onDelete();
              },
              child: Text(
                AppLocalizations.of(context)!.deleteButton,
                style: AppTypography.mediumText.copyWith(
                  color: AppColors.accretionRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
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
                    value: _formatDistance(widget.body.radius),
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
                  if (widget.body.stellarLuminosity > 0)
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
              selectedType: widget.body.bodyType,
              onTypeChanged: (bodyType) {
                final updatedBody = Body(
                  name: widget.body.name,
                  position: widget.body.position,
                  velocity: widget.body.velocity,
                  mass: widget.body.mass,
                  radius: widget.body.radius,
                  color: widget.body.color,
                  bodyType: bodyType,
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

          // Color Section
          _buildEditSection(
            l10n.colorEditor,
            ColorPicker(
              selectedColor: widget.body.color,
              onColorChanged: (color) {
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

          // Mass and Radius Section
          Row(
            children: [
              Expanded(
                child: _buildCompactTextField(
                  controller: _massController,
                  icon: Icons.fitness_center,
                  hintText: AppLocalizations.of(context)!.massKgEditorhint,
                  labelText: AppLocalizations.of(context)!.bodyPropertiesMass,
                  onChanged: (value) => _updateBodyProperty(),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: AppTypography.spacingMedium),
              Expanded(
                child: _buildCompactTextField(
                  controller: _radiusController,
                  icon: Icons.radio_button_unchecked,
                  hintText: AppLocalizations.of(context)!.radiusMEditorhint,
                  labelText: AppLocalizations.of(context)!.bodyPropertiesRadius,
                  onChanged: (value) => _updateBodyProperty(),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTypography.spacingSmall),
          Text(
            l10n.physicalPropertiesDescription,
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),

          _buildDivider(),

          // Stellar Luminosity Section
          _buildCompactTextField(
            controller: _luminosityController,
            icon: Icons.light_mode_outlined,
            hintText: AppLocalizations.of(context)!.luminosityWEditorhint,
            labelText: AppLocalizations.of(context)!.bodyPropertiesLuminosity,
            onChanged: (value) => _updateBodyProperty(),
            keyboardType: TextInputType.number,
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
        mass: double.tryParse(_massController.text) ?? widget.body.mass,
        radius: double.tryParse(_radiusController.text) ?? widget.body.radius,
        color: widget.body.color,
        bodyType: widget.body.bodyType,
        stellarLuminosity:
            double.tryParse(_luminosityController.text) ??
            widget.body.stellarLuminosity,
        temperature:
            double.tryParse(_temperatureController.text) ??
            widget.body.temperature,
        showGravityWell: widget.body.showGravityWell,
        isPlanet: widget.body.isPlanet,
        habitabilityStatus: widget.body.habitabilityStatus,
      );

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTypography.spacingLarge),
      child: Divider(color: AppColors.uiDividerGrey, thickness: 1, height: 1),
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

  Widget _buildEditSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.mediumText.copyWith(
            color: AppColors.uiWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppTypography.spacingSmall),
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
    return NumberUtils.formatMass(mass);
  }

  String _formatDistance(double distance) {
    return NumberUtils.formatDistance(distance);
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
