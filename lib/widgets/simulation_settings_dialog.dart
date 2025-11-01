import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_constraints.dart';
import 'package:graviton/theme/app_typography.dart';

class SimulationSettingsDialog extends StatefulWidget {
  final double gravitationalConstant;
  final double softening;
  final double timeScale;
  final double collisionRadiusMultiplier;
  final int maxTrailPoints;
  final double trailFadeRate;
  final double vibrationThrottleTime;
  final bool vibrationEnabled;
  final ScenarioType currentScenario;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const SimulationSettingsDialog({
    super.key,
    required this.gravitationalConstant,
    required this.softening,
    required this.timeScale,
    required this.collisionRadiusMultiplier,
    required this.maxTrailPoints,
    required this.trailFadeRate,
    required this.vibrationThrottleTime,
    required this.vibrationEnabled,
    required this.currentScenario,
    required this.onSettingsChanged,
  });

  @override
  State<SimulationSettingsDialog> createState() =>
      _SimulationSettingsDialogState();
}

class _SimulationSettingsDialogState extends State<SimulationSettingsDialog> {
  late double _gravitationalConstant;
  late double _softening;
  late double _timeScale;
  late double _collisionRadiusMultiplier;
  late double _maxTrailPoints;
  late double _trailFadeRate;
  late double _vibrationThrottleTime;
  late bool _vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _gravitationalConstant = widget.gravitationalConstant;
    _softening = widget.softening;
    _timeScale = widget.timeScale;
    _collisionRadiusMultiplier = widget.collisionRadiusMultiplier;
    _maxTrailPoints = widget.maxTrailPoints.toDouble();
    _trailFadeRate = widget.trailFadeRate;
    _vibrationThrottleTime = widget.vibrationThrottleTime;
    _vibrationEnabled = widget.vibrationEnabled;
  }

  void _updateSettings() {
    widget.onSettingsChanged({
      'gravitationalConstant': _gravitationalConstant,
      'softening': _softening,
      'timeScale': _timeScale,
      'collisionRadiusMultiplier': _collisionRadiusMultiplier,
      'maxTrailPoints': _maxTrailPoints.round(),
      'trailFadeRate': _trailFadeRate,
      'vibrationThrottleTime': _vibrationThrottleTime,
      'vibrationEnabled': _vibrationEnabled,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            // Header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityMidFade,
                    ),
                    AppColors.primaryColor.withValues(
                      alpha: AppTypography.opacityBarely,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTypography.radiusXLarge),
                  topRight: Radius.circular(AppTypography.radiusXLarge),
                ),
              ),
              padding: const EdgeInsets.all(AppTypography.spacingLarge),
              child: Row(
                children: [
                  Icon(
                    Icons.science,
                    color: AppColors.primaryColor,
                    size: AppTypography.fontSizeHeader,
                  ),
                  const SizedBox(width: AppTypography.spacingMedium),
                  Text(
                    l10n.physicsSettingsTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content section
            Flexible(
              child: Padding(
                padding: AppConstraints.dialogPadding,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Physics section
                      _buildSectionHeader(l10n.physicsSection, Icons.science),
                      const SizedBox(height: AppTypography.spacingLarge),

                      _buildSlider(
                        label: l10n.gravitationalConstant,
                        value: _gravitationalConstant,
                        min: 0.1,
                        max: 10.0,
                        divisions: 99,
                        icon: Icons.public,
                        onChanged: (value) {
                          setState(() => _gravitationalConstant = value);
                          _updateSettings();
                        },
                        formatter: (value) => value.toStringAsFixed(2),
                      ),

                      _buildSlider(
                        label: l10n.softeningParameter,
                        value: _softening,
                        min: 0.01,
                        max: 2.0,
                        divisions: 199,
                        icon: Icons.blur_on,
                        onChanged: (value) {
                          setState(() => _softening = value);
                          _updateSettings();
                        },
                        formatter: (value) => value.toStringAsFixed(3),
                      ),

                      _buildSlider(
                        label: l10n.simulationSpeed,
                        value: _timeScale,
                        min: 0.1,
                        max: 16.0,
                        divisions: 159,
                        icon: Icons.speed,
                        onChanged: (value) {
                          setState(() => _timeScale = value);
                          _updateSettings();
                        },
                        formatter: (value) => '${value.toStringAsFixed(1)}x',
                      ),

                      const SizedBox(height: AppTypography.spacingXXLarge),

                      // Collision section
                      _buildSectionHeader(l10n.collisionsSection, Icons.adjust),
                      const SizedBox(height: AppTypography.spacingLarge),

                      _buildSlider(
                        label: l10n.collisionSensitivity,
                        value: _collisionRadiusMultiplier,
                        min: 0.05,
                        max: 1.0,
                        divisions: 95,
                        icon: Icons.radio_button_unchecked,
                        onChanged: (value) {
                          setState(() => _collisionRadiusMultiplier = value);
                          _updateSettings();
                        },
                        formatter: (value) =>
                            '${(value * 100).toStringAsFixed(0)}%',
                      ),

                      const SizedBox(height: AppTypography.spacingXXLarge),

                      // Trails section
                      _buildSectionHeader(l10n.trailsSection, Icons.timeline),
                      const SizedBox(height: AppTypography.spacingLarge),

                      _buildSlider(
                        label: l10n.trailLength,
                        value: _maxTrailPoints,
                        min: 50,
                        max: 1000,
                        divisions: 95,
                        icon: Icons.linear_scale,
                        onChanged: (value) {
                          setState(() => _maxTrailPoints = value);
                          _updateSettings();
                        },
                        formatter: (value) => value.toStringAsFixed(0),
                      ),

                      _buildSlider(
                        label: l10n.trailFadeRate,
                        value: _trailFadeRate,
                        min: 0.1,
                        max: 2.0,
                        divisions: 19,
                        icon: Icons.opacity,
                        onChanged: (value) {
                          setState(() => _trailFadeRate = value);
                          _updateSettings();
                        },
                        formatter: (value) => value.toStringAsFixed(1),
                      ),

                      const SizedBox(height: AppTypography.spacingXXLarge),

                      // Haptics section
                      _buildSectionHeader(l10n.hapticsSection, Icons.vibration),
                      const SizedBox(height: AppTypography.spacingLarge),

                      SwitchListTile(
                        title: Text(
                          l10n.vibrationEnabled,
                          style: theme.textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          l10n.hapticFeedbackCollisions,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        value: _vibrationEnabled,
                        onChanged: (value) {
                          setState(() => _vibrationEnabled = value);
                          _updateSettings();
                        },
                        activeThumbColor: theme.colorScheme.primary,
                        contentPadding: EdgeInsets.zero,
                      ),

                      if (_vibrationEnabled) ...[
                        const SizedBox(height: 8),
                        _buildSlider(
                          label: l10n.vibrationThrottle,
                          value: _vibrationThrottleTime,
                          min: 0.05,
                          max: 1.0,
                          divisions: 95,
                          icon: Icons.timer,
                          onChanged: (value) {
                            setState(() => _vibrationThrottleTime = value);
                            _updateSettings();
                          },
                          formatter: (value) =>
                              '${(value * 1000).toStringAsFixed(0)}ms',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppTypography.spacingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _resetToDefaults,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.resetButton),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: AppTypography.iconSizeXLarge,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppTypography.spacingSmall),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required IconData icon,
    required ValueChanged<double> onChanged,
    required String Function(double) formatter,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: AppTypography.iconSizeMedium,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppTypography.spacingSmall),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              formatter(value),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.outline.withValues(
            alpha: AppTypography.opacityVeryFaint,
          ),
        ),
        const SizedBox(height: AppTypography.spacingSmall),
      ],
    );
  }

  void _resetToDefaults() {
    final scenarioDefaults = PhysicsSettings.forScenario(
      widget.currentScenario,
    );
    setState(() {
      _gravitationalConstant = scenarioDefaults.gravitationalConstant;
      _softening = scenarioDefaults.softening;
      _timeScale = 8.0; // Default from simulation state
      _collisionRadiusMultiplier = scenarioDefaults.collisionRadiusMultiplier;
      _maxTrailPoints = scenarioDefaults.maxTrailPoints.toDouble();
      _trailFadeRate = scenarioDefaults.trailFadeRate;
      _vibrationThrottleTime = scenarioDefaults.vibrationThrottleTime;
      _vibrationEnabled = scenarioDefaults.vibrationEnabled;
    });
    _updateSettings();
  }
}
