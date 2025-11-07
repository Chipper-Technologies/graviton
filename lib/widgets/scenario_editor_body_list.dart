import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/haptic_gesture_detector.dart';
import 'package:graviton/widgets/section_title.dart';

/// Widget for managing the list of celestial bodies in the scenario editor
class ScenarioEditorBodyList extends StatefulWidget {
  final List<Body> bodies;
  final ValueChanged<List<Body>> onBodiesChanged;
  final VoidCallback onAddBody;

  const ScenarioEditorBodyList({
    super.key,
    required this.bodies,
    required this.onBodiesChanged,
    required this.onAddBody,
  });

  @override
  State<ScenarioEditorBodyList> createState() => _ScenarioEditorBodyListState();
}

class _ScenarioEditorBodyListState extends State<ScenarioEditorBodyList> {
  int? _selectedBodyIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.bodies.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return Row(
      children: [
        // Body list panel
        Expanded(
          flex: 1,
          child: _buildBodyListPanel(l10n),
        ),
        
        // Body details panel (if body selected)
        if (_selectedBodyIndex != null && _selectedBodyIndex! < widget.bodies.length)
          Expanded(
            flex: 2,
            child: _buildBodyDetailsPanel(l10n),
          ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.public_off,
            size: 64,
            color: AppColors.uiWhite.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppTypography.spacingLarge),
          Text(
            'No bodies yet',
            style: AppTypography.titleText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Text(
            'Add celestial bodies to create your custom scenario',
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyListPanel(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Bodies'),
          SizedBox(height: AppTypography.spacingMedium),
          
          // Body count indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTypography.spacingMedium,
              vertical: AppTypography.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTypography.radiusSmall),
            ),
            child: Text(
              '${widget.bodies.length} bodies',
              style: AppTypography.smallText.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          
          SizedBox(height: AppTypography.spacingMedium),
          
          // Body list
          Expanded(
            child: ListView.builder(
              itemCount: widget.bodies.length,
              itemBuilder: (context, index) => _buildBodyListTile(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyListTile(int index) {
    final body = widget.bodies[index];
    final isSelected = _selectedBodyIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: HapticGestureDetector(
        onTap: () => _selectBody(index),
        child: Container(
          padding: EdgeInsets.all(AppTypography.spacingMedium),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor.withValues(alpha: 0.2)
                : AppColors.uiBlack.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppTypography.radiusMedium),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.uiWhite.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Body color indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: body.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.uiWhite.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              
              SizedBox(width: AppTypography.spacingMedium),
              
              // Body info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      body.name,
                      style: AppTypography.mediumText.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: AppTypography.spacingSmall),
                    Text(
                      '${body.bodyType.name} • ${body.mass.toStringAsFixed(1)} M',
                      style: AppTypography.smallText.copyWith(
                        color: AppColors.uiWhite.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Duplicate button
                  HapticGestureDetector(
                    onTap: () => _duplicateBody(index),
                    child: Container(
                      padding: EdgeInsets.all(AppTypography.spacingSmall),
                      child: Icon(
                        Icons.content_copy,
                        size: AppTypography.iconSizeSmall,
                        color: AppColors.uiWhite.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  
                  // Delete button (only if more than one body)
                  if (widget.bodies.length > 1)
                    HapticGestureDetector(
                      onTap: () => _deleteBody(index),
                      child: Container(
                        padding: EdgeInsets.all(AppTypography.spacingSmall),
                        child: Icon(
                          Icons.delete_outline,
                          size: AppTypography.iconSizeSmall,
                          color: AppColors.uiRed.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyDetailsPanel(AppLocalizations l10n) {
    final body = widget.bodies[_selectedBodyIndex!];
    
    return Container(
      padding: EdgeInsets.all(AppTypography.spacingMedium),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Details',
            style: AppTypography.titleText,
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Text(
            'Selected: ${body.name}',
            style: AppTypography.mediumText,
          ),
          // TODO: Implement full body details editor
          Text(
            'Body editing will be implemented here',
            style: AppTypography.smallText.copyWith(
              color: AppColors.uiWhite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _selectBody(int index) {
    setState(() {
      _selectedBodyIndex = index;
    });
  }

  void _duplicateBody(int index) {
    final originalBody = widget.bodies[index];
    final duplicatedBody = Body(
      name: '${originalBody.name} Copy',
      position: originalBody.position + vm.Vector3(10.0, 0, 0), // Offset position
      velocity: originalBody.velocity.clone(),
      mass: originalBody.mass,
      radius: originalBody.radius,
      color: originalBody.color,
      bodyType: originalBody.bodyType,
      stellarLuminosity: originalBody.stellarLuminosity,
      temperature: originalBody.temperature,
      showGravityWell: originalBody.showGravityWell,
      isPlanet: originalBody.isPlanet,
      habitabilityStatus: originalBody.habitabilityStatus,
    );

    final updatedBodies = List<Body>.from(widget.bodies)..add(duplicatedBody);
    widget.onBodiesChanged(updatedBodies);
  }

  void _deleteBody(int index) {
    final updatedBodies = List<Body>.from(widget.bodies)..removeAt(index);
    
    // Adjust selected index if needed
    if (_selectedBodyIndex == index) {
      _selectedBodyIndex = null;
    } else if (_selectedBodyIndex != null && _selectedBodyIndex! > index) {
      _selectedBodyIndex = _selectedBodyIndex! - 1;
    }
    
    setState(() {});
    widget.onBodiesChanged(updatedBodies);
  }
}