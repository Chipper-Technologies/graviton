import 'package:flutter/material.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/enums/body_type.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class BodyPropertiesDialog extends StatefulWidget {
  final Body body;
  final int bodyIndex;
  final Function(Body) onBodyChanged;

  const BodyPropertiesDialog({
    super.key,
    required this.body,
    required this.bodyIndex,
    required this.onBodyChanged,
  });

  @override
  State<BodyPropertiesDialog> createState() => _BodyPropertiesDialogState();
}

class _BodyPropertiesDialogState extends State<BodyPropertiesDialog> {
  late TextEditingController _nameController;
  late double _mass;
  late double _radius;
  late Color _color;
  late BodyType _bodyType;
  late double _stellarLuminosity;
  late vm.Vector3 _velocity;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.body.name);
    _mass = widget.body.mass;
    _radius = widget.body.radius;
    _color = widget.body.color;
    _bodyType = widget.body.bodyType;
    _stellarLuminosity = widget.body.stellarLuminosity;
    _velocity = widget.body.velocity.clone();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateBody() {
    // Update the original body's properties directly
    widget.body.velocity = _velocity;
    widget.body.mass = _mass;
    widget.body.radius = _radius;
    widget.body.color = _color;
    widget.body.name = _nameController.text;
    widget.body.bodyType = _bodyType;
    widget.body.stellarLuminosity = _stellarLuminosity;

    widget.onBodyChanged(widget.body);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTypography.radiusXLarge),
      ),
      child: Container(
        constraints: AppConstraints.dialogMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with close button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.uiOrangeAccent.withValues(alpha: 0.15),
                    AppColors.uiOrangeAccent.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTypography.radiusXLarge),
                  topRight: Radius.circular(AppTypography.radiusXLarge),
                ),
              ),
              padding: EdgeInsets.all(AppTypography.spacingLarge),
              child: Row(
                children: [
                  Icon(Icons.tune, color: AppColors.uiOrangeAccent, size: 28),
                  SizedBox(width: AppTypography.spacingMedium),
                  Text(
                    l10n.bodyPropertiesTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Flexible(
              child: Padding(
                padding: AppConstraints.dialogPadding,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      _buildSectionTitle(l10n.bodyPropertiesName),
                      TextField(
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {});
                          _updateBody();
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: l10n.bodyPropertiesNameHint,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Body Type
                      _buildSectionTitle(l10n.bodyPropertiesType),
                      DropdownButtonFormField<BodyType>(
                        initialValue: _bodyType,
                        onChanged: (BodyType? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _bodyType = newValue;
                            });
                            _updateBody();
                          }
                        },
                        dropdownColor: AppColors.uiBlack,
                        style: TextStyle(color: AppColors.uiWhite),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.uiBlack.withValues(
                            alpha: AppTypography.opacityFaint,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTypography.radiusMedium,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.uiWhite.withValues(
                                alpha: AppTypography.opacityFaint,
                              ),
                            ),
                          ),
                        ),
                        items: BodyType.values.map((BodyType type) {
                          return DropdownMenuItem<BodyType>(
                            value: type,
                            child: Text(
                              type.displayName,
                              style: TextStyle(color: AppColors.uiWhite),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Color
                      _buildSectionTitle(l10n.bodyPropertiesColor),
                      const SizedBox(height: AppTypography.spacingSmall),
                      _buildColorPicker(),

                      const SizedBox(height: 16),

                      // Mass
                      _buildSectionTitle(l10n.bodyPropertiesMass),
                      _buildSlider(
                        value: _mass,
                        min: 0.1,
                        max: 1000.0,
                        divisions: 100,
                        label: _mass.toStringAsFixed(1),
                        icon: Icons.scale,
                        onChanged: (value) {
                          setState(() {
                            _mass = value;
                          });
                          _updateBody();
                        },
                      ),

                      const SizedBox(height: 16),

                      // Radius
                      _buildSectionTitle(l10n.bodyPropertiesRadius),
                      _buildSlider(
                        value: _radius,
                        min: 0.1,
                        max: 100.0,
                        divisions: 100,
                        label: _radius.toStringAsFixed(1),
                        icon: Icons.radio_button_unchecked,
                        onChanged: (value) {
                          setState(() {
                            _radius = value;
                          });
                          _updateBody();
                        },
                      ),

                      const SizedBox(height: 16),

                      // Stellar Luminosity (only for stars)
                      if (_bodyType == BodyType.star) ...[
                        _buildSectionTitle(l10n.bodyPropertiesLuminosity),
                        _buildSlider(
                          value: _stellarLuminosity,
                          min: 0.0,
                          max: 10.0,
                          divisions: 100,
                          label: _stellarLuminosity.toStringAsFixed(2),
                          icon: Icons.brightness_7,
                          onChanged: (value) {
                            setState(() {
                              _stellarLuminosity = value;
                            });
                            _updateBody();
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Velocity
                      _buildSectionTitle(l10n.bodyPropertiesVelocity),
                      _buildVelocityControls(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: AppColors.sectionTitlePurple),
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
    IconData? icon,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon ?? Icons.tune, size: 20),
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              inactiveTrackColor: Theme.of(context).colorScheme.onSurface
                  .withValues(alpha: AppTypography.opacityVeryFaint),
              activeTrackColor: Theme.of(context).colorScheme.primary,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: label,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: AppTypography.spacingSmall,
      runSpacing: AppTypography.spacingSmall,
      children:
          [
            ...AppColors.basicPrimaries,
            AppColors.uiWhite,
            AppColors.basicGrey,
            AppColors.randomPlanetBrown,
          ].map((color) {
            final isSelected = _color == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _color = color;
                });
                _updateBody();
              },
              child: Container(
                width:
                    AppTypography.spacingXXLarge +
                    AppTypography.spacingSmall, // 32
                height:
                    AppTypography.spacingXXLarge +
                    AppTypography.spacingSmall, // 32
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.uiWhite : Colors.transparent,
                    width: AppTypography.borderThick,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        size: AppTypography.iconSizeMedium,
                      )
                    : null,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildVelocityControls(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // X velocity
        Row(
          children: [
            SizedBox(
              width: AppTypography.spacingXLarge,
              child: Text(
                l10n.bodyPropertiesAxisX,
                style: TextStyle(color: AppColors.uiWhite),
              ),
            ),
            Expanded(
              child: _buildSlider(
                value: _velocity.x,
                min: -50.0,
                max: 50.0,
                divisions: 100,
                label: _velocity.x.toStringAsFixed(1),
                icon: Icons.east,
                onChanged: (value) {
                  setState(() {
                    _velocity.x = value;
                  });
                  _updateBody();
                },
              ),
            ),
          ],
        ),
        // Y velocity
        Row(
          children: [
            SizedBox(
              width: AppTypography.spacingXLarge,
              child: Text(
                l10n.bodyPropertiesAxisY,
                style: TextStyle(color: AppColors.uiWhite),
              ),
            ),
            Expanded(
              child: _buildSlider(
                value: _velocity.y,
                min: -50.0,
                max: 50.0,
                divisions: 100,
                label: _velocity.y.toStringAsFixed(1),
                icon: Icons.north,
                onChanged: (value) {
                  setState(() {
                    _velocity.y = value;
                  });
                  _updateBody();
                },
              ),
            ),
          ],
        ),
        // Z velocity
        Row(
          children: [
            SizedBox(
              width: AppTypography.spacingXLarge,
              child: Text(
                l10n.bodyPropertiesAxisZ,
                style: TextStyle(color: AppColors.uiWhite),
              ),
            ),
            Expanded(
              child: _buildSlider(
                value: _velocity.z,
                min: -50.0,
                max: 50.0,
                divisions: 100,
                label: _velocity.z.toStringAsFixed(1),
                icon: Icons.flight_takeoff,
                onChanged: (value) {
                  setState(() {
                    _velocity.z = value;
                  });
                  _updateBody();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
