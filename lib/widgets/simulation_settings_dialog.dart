import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:graviton/theme/app_constraints.dart';

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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: AppConstraints.dialogMedium,
        padding: AppConstraints.dialogPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Simulation Settings',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Settings content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Physics section
                    _buildSectionHeader('Physics', Icons.science),
                    const SizedBox(height: 16),

                    _buildSlider(
                      label: 'Gravitational Constant',
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
                      label: 'Softening Parameter',
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
                      label: 'Simulation Speed',
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

                    const SizedBox(height: 24),

                    // Collision section
                    _buildSectionHeader('Collisions', Icons.adjust),
                    const SizedBox(height: 16),

                    _buildSlider(
                      label: 'Collision Sensitivity',
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

                    const SizedBox(height: 24),

                    // Trails section
                    _buildSectionHeader('Trails', Icons.timeline),
                    const SizedBox(height: 16),

                    _buildSlider(
                      label: 'Trail Length',
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
                      label: 'Trail Fade Rate',
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

                    const SizedBox(height: 24),

                    // Haptics section
                    _buildSectionHeader('Haptics', Icons.vibration),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: Text(
                        'Vibration Enabled',
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        'Haptic feedback on collisions',
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
                        label: 'Vibration Throttle',
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

            const SizedBox(height: 24),

            // Reset and Close buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _resetToDefaults,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check),
                  label: const Text('Done'),
                ),
              ],
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
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
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
            Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
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
          inactiveColor: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 8),
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
