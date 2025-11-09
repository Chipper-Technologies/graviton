import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graviton/enums/ui_action.dart';
import 'package:graviton/enums/ui_element.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/body.dart';
import 'package:graviton/services/firebase_service.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/utils/number_utils.dart';
import 'package:graviton/widgets/common/delete_confirmation_dialog.dart';
import 'package:graviton/widgets/scenario_selection/scenario_editor_body_details_bottom_sheet.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.bodies.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return _buildBodyListPanel(l10n);
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.public_off,
            size: AppTypography.iconSizeXXXXLarge * 1.33,
            color: AppColors.uiWhite.withValues(
              alpha: AppTypography.opacityFaint,
            ),
          ), // ~64
          SizedBox(height: AppTypography.spacingLarge),
          Text(
            l10n.noBodiesYetEditor,
            style: AppTypography.titleText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityHigh,
              ),
            ),
          ),
          SizedBox(height: AppTypography.spacingMedium),
          Text(
            l10n.addCelestialBodiesToCreateYourCustomScenarioEditor,
            style: AppTypography.mediumText.copyWith(
              color: AppColors.uiWhite.withValues(
                alpha: AppTypography.opacityMedium,
              ),
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
          // Combined header with body count
          Container(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(
                alpha: AppTypography.opacityMidFade,
              ),
              borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
              border: Border.all(
                color: AppColors.primaryColor,
                width: AppTypography.borderThin,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.public,
                  color: AppColors.primaryColor,
                  size: AppTypography.iconSizeXXLarge,
                ),
                SizedBox(width: AppTypography.spacingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.bodiesHeaderPlural(widget.bodies.length),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: AppTypography.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppTypography.spacingXSmall),
                      Text(
                        l10n.bodiesHeaderDescription,
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
              ],
            ),
          ),

          SizedBox(height: AppTypography.spacingMedium),

          // Body list
          Expanded(
            child: ListView.builder(
              itemCount: widget.bodies.length,
              itemBuilder: (context, index) => _buildBodyTile(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyTile(int index) {
    final body = widget.bodies[index];

    return Container(
      margin: EdgeInsets.only(bottom: AppTypography.spacingSmall),
      child: Semantics(
        label:
            AppLocalizations.of(
              context,
            )?.celestialBodyNameTemplate(body.name, body.name) ??
            '${body.name} celestial body',
        hint:
            AppLocalizations.of(
              context,
            )?.tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
              body.bodyType.name,
              NumberUtils.formatMass(body.mass),
            ) ??
            'Tap to view and edit details. ${body.bodyType.name} with ${NumberUtils.formatMass(body.mass)}.',
        button: true,
        child: Material(
          color: AppColors.transparentColor,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _openBodyDetails(index);
            },
            borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
            child: Container(
              padding: EdgeInsets.all(AppTypography.spacingLarge),
              decoration: BoxDecoration(
                color: AppColors.uiWhite.withValues(
                  alpha: AppTypography.opacityBarely,
                ),
                borderRadius: BorderRadius.circular(AppTypography.radiusLarge),
                border: Border.all(
                  color: AppColors.uiWhite.withValues(
                    alpha: AppTypography.opacityDisabled,
                  ),
                  width: AppTypography.borderThin,
                ),
              ),
              child: Row(
                children: [
                  // Body color indicator icon
                  Container(
                    width: AppTypography.iconSizeLarge,
                    height: AppTypography.iconSizeLarge,
                    decoration: BoxDecoration(
                      color: body.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.uiWhite.withValues(
                          alpha: AppTypography.opacityFaint,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.public,
                      size: AppTypography.iconSizeSmall,
                      color: AppColors.uiWhite,
                    ),
                  ),

                  SizedBox(width: AppTypography.spacingLarge),

                  // Body info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          body.name,
                          style: TextStyle(
                            color: AppColors.uiWhite,
                            fontSize: AppTypography.fontSizeLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppTypography.spacingXSmall),
                        Text(
                          '${body.bodyType.name} • ${NumberUtils.formatMass(body.mass)}',
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

                  // Action buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Duplicate button
                      Semantics(
                        label:
                            AppLocalizations.of(
                              context,
                            )?.duplicateBodyNameTemplate(body.name) ??
                            'Duplicate ${body.name}',
                        hint:
                            AppLocalizations.of(
                              context,
                            )?.createACopyOfThisCelestialBodyEditorHint ??
                            'Create a copy of this celestial body',
                        button: true,
                        child: Material(
                          color: AppColors.transparentColor,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _duplicateBody(index);
                            },
                            borderRadius: BorderRadius.circular(
                              AppTypography.radiusXXLarge,
                            ),
                            child: Container(
                              width: AppTypography.spacingXXXLarge,
                              height: AppTypography.spacingXXXLarge,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacityDisabled,
                                ),
                                border: Border.all(
                                  color: AppColors.uiWhite.withValues(
                                    alpha: AppTypography.opacityFaint,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.content_copy,
                                size: AppTypography.iconSizeMedium,
                                color: AppColors.uiWhite.withValues(
                                  alpha: AppTypography.opacityVeryHigh,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: AppTypography.spacingSmall),

                      // Delete button (only if more than one body)
                      if (widget.bodies.length > 1)
                        Semantics(
                          label:
                              AppLocalizations.of(
                                context,
                              )?.deleteBodyNameTemplate(body.name) ??
                              'Delete ${body.name}',
                          hint:
                              AppLocalizations.of(
                                context,
                              )?.removeThisCelestialBodyFromTheScenarioEditorHint ??
                              'Remove this celestial body from the scenario',
                          button: true,
                          child: Material(
                            color: AppColors.transparentColor,
                            child: InkWell(
                              onTap: () async {
                                HapticFeedback.lightImpact();
                                await _deleteBody(index);
                              },
                              borderRadius: BorderRadius.circular(
                                AppTypography.radiusXXLarge,
                              ),
                              child: Container(
                                width: AppTypography.spacingXXXLarge,
                                height: AppTypography.spacingXXXLarge,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.uiRed.withValues(
                                    alpha: AppTypography.opacityDisabled,
                                  ),
                                  border: Border.all(
                                    color: AppColors.uiRed.withValues(
                                      alpha: AppTypography.opacityFaint,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: AppTypography.iconSizeMedium,
                                  color: AppColors.uiRed.withValues(
                                    alpha: AppTypography.opacityNearlyOpaque,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openBodyDetails(int index) {
    // Provide haptic feedback when opening details
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ScenarioEditorBodyDetailsBottomSheet(
            body: widget
                .bodies[index], // Always use the current body from the list
            onBodyChanged: (updatedBody) {
              _updateBody(index, updatedBody);
              setSheetState(() {}); // Force the bottom sheet to rebuild
            },
            onDuplicate: () {
              Navigator.pop(context);
              _duplicateBody(index);
            },
            onDelete: () {
              // Direct deletion - confirmation already shown in bottom sheet
              _performBodyDeletion(index, widget.bodies[index]);
            },
          ),
        ),
      ),
    );
  }

  void _updateBody(int index, Body updatedBody) {
    final updatedBodies = List<Body>.from(widget.bodies);
    updatedBodies[index] = updatedBody;
    widget.onBodiesChanged(updatedBodies);
  }

  void _duplicateBody(int index) {
    final l10n = AppLocalizations.of(context)!;
    final originalBody = widget.bodies[index];
    final duplicatedBody = Body(
      name: l10n.bodyNameCopyTemplate(originalBody.name),
      position:
          originalBody.position + vm.Vector3(10.0, 0, 0), // Offset position
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

  Future<void> _deleteBody(int index) async {
    final bodyToDelete = widget.bodies[index];
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await DeleteConfirmationDialog.show(
      context: context,
      title: l10n.deleteBodyConfirmTitle(bodyToDelete.name),
      message: l10n.deleteBodyConfirmMessage,
    );

    if (confirmed == true) {
      _performBodyDeletion(index, bodyToDelete);
    }
  }

  void _performBodyDeletion(int index, Body bodyToDelete) {
    // Log analytics for body removal
    FirebaseService.instance.logUIEventWithEnums(
      UIAction.bodyRemoved,
      element: UIElement.scenarioEditorBodies,
      additionalParams: {
        'body_name': bodyToDelete.name,
        'body_type': bodyToDelete.bodyType.name,
        'remaining_body_count': widget.bodies.length - 1,
      },
    );

    final updatedBodies = List<Body>.from(widget.bodies)..removeAt(index);
    widget.onBodiesChanged(updatedBodies);
  }
}
