import 'package:flutter/material.dart';
import 'package:graviton/enums/scenario_type.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/models/physics_settings.dart';
import 'package:graviton/theme/app_colors.dart';
import 'package:graviton/theme/app_typography.dart';
import 'package:graviton/widgets/common/action_option.dart';
import 'package:graviton/widgets/common/slider_option.dart';
import 'package:graviton/widgets/common/toggle_option.dart';
import 'package:graviton/widgets/section_title.dart';

/// Full-screen physics settings page with transparent background
class PhysicsSettingsScreen extends StatefulWidget {
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

  const PhysicsSettingsScreen({
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
  State<PhysicsSettingsScreen> createState() => _PhysicsSettingsScreenState();
}

class _PhysicsSettingsScreenState extends State<PhysicsSettingsScreen> {
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.physicsSettingsTitle),
        backgroundColor: AppColors.uiBlack.withValues(
          alpha: AppTypography.opacityNearlyOpaque,
        ),
        foregroundColor: AppColors.uiWhite,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.uiBlack.withValues(
              alpha: AppTypography.opacityNearlyOpaque,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppTypography.spacingLarge),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Physics section
                        SectionTitle(title: l10n.physicsSection),
                        SizedBox(height: AppTypography.spacingMedium),

                        SliderOption.detailed(
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

                        SliderOption.detailed(
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

                        SliderOption.detailed(
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

                        const SizedBox(height: 32),

                        // Collision section
                        SectionTitle(title: l10n.collisionsSection),
                        const SizedBox(height: 16),

                        SliderOption.detailed(
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

                        const SizedBox(height: 32),

                        // Trails section
                        SectionTitle(title: l10n.trailsSection),
                        const SizedBox(height: 16),

                        SliderOption.detailed(
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

                        SliderOption.detailed(
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

                        const SizedBox(height: 32),

                        // Haptics section
                        SectionTitle(title: l10n.hapticsSection),
                        const SizedBox(height: 16),

                        ToggleOption(
                          title: l10n.vibrationEnabled,
                          description: l10n.hapticFeedbackCollisions,
                          icon: Icons.vibration,
                          isEnabled: _vibrationEnabled,
                          onChanged: (value) {
                            setState(() => _vibrationEnabled = value);
                            _updateSettings();
                          },
                        ),

                        if (_vibrationEnabled) ...[
                          const SizedBox(height: 16),
                          SliderOption.detailed(
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

                        const SizedBox(height: 24),

                        // Reset button
                        ActionOption(
                          title: l10n.resetButton,
                          description: l10n.resetSettingsDescription,
                          icon: Icons.refresh,
                          onPressed: _resetToDefaults,
                        ),

                        SizedBox(height: AppTypography.spacingXXLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
