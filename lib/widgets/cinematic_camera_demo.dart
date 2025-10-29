import 'package:flutter/material.dart';
import 'package:graviton/enums/cinematic_camera_technique.dart';
import 'package:graviton/l10n/app_localizations.dart';
import 'package:graviton/state/ui_state.dart';

/// Demo widget showing the cinematic camera technique selection
class CinematicCameraTechniqueDemo extends StatefulWidget {
  const CinematicCameraTechniqueDemo({super.key});

  @override
  State<CinematicCameraTechniqueDemo> createState() => _CinematicCameraTechniqueDemoState();
}

class _CinematicCameraTechniqueDemoState extends State<CinematicCameraTechniqueDemo> {
  final UIState _uiState = UIState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cinematicCameraTechniqueLabel)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select an AI Camera Technique:', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),

            // Current selection display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Selection:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    _uiState.cinematicCameraTechnique.displayName,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_uiState.cinematicCameraTechnique.description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Technique selection buttons
            Text('Available Techniques:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: CinematicCameraTechnique.values.length,
                itemBuilder: (context, index) {
                  final technique = CinematicCameraTechnique.values[index];
                  final isSelected = _uiState.cinematicCameraTechnique == technique;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
                    child: ListTile(
                      leading: Icon(_getIconForTechnique(technique), color: isSelected ? Colors.blue : null),
                      title: Text(
                        technique.displayName,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : null,
                        ),
                      ),
                      subtitle: Text(technique.description),
                      trailing: technique.requiresAI
                          ? const Icon(Icons.psychology, color: Colors.orange)
                          : const Icon(Icons.person),
                      onTap: () {
                        setState(() {
                          _uiState.setCinematicCameraTechnique(technique);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTechnique(CinematicCameraTechnique technique) {
    switch (technique) {
      case CinematicCameraTechnique.manual:
        return Icons.pan_tool;
      case CinematicCameraTechnique.predictiveOrbital:
        return Icons.track_changes;
      case CinematicCameraTechnique.dynamicFraming:
        return Icons.aspect_ratio;
    }
  }
}
