# Internationalization (i18n) Prompt

You are working on Graviton, which supports 7 languages. All user-facing text must be internationalized:

## Supported Languages

- English (en) - Primary
- Spanish (es)
- French (fr) 
- German (de)
- Japanese (ja)
- Chinese Simplified (zh)
- Russian (ru)

## Usage Patterns

```dart
// Correct: Using AppLocalizations
Text(AppLocalizations.of(context)!.simulationPaused)

// Wrong: Hardcoded strings
Text('Simulation Paused') // ❌ Never do this
```

## ARB File Structure

```json
// lib/l10n/app_en.arb
{
  "appTitle": "Graviton",
  "simulationPaused": "Simulation Paused",
  "bodyCount": "Bodies: {count}",
  "@bodyCount": {
    "placeholders": {
      "count": {
        "type": "int",
        "description": "Number of celestial bodies"
      }
    }
  },
  "timeElapsed": "Time: {years} years",
  "@timeElapsed": {
    "placeholders": {
      "years": {
        "type": "double",
        "format": "decimalPattern",
        "description": "Elapsed simulation time in years"
      }
    }
  }
}
```

## Common Patterns

### Simple Text
```dart
AppLocalizations.of(context)!.settings
AppLocalizations.of(context)!.resetSimulation
AppLocalizations.of(context)!.aboutGraviton
```

### Text with Parameters
```dart
AppLocalizations.of(context)!.bodyCount(bodies.length)
AppLocalizations.of(context)!.timeElapsed(simulationTime)
AppLocalizations.of(context)!.temperatureDisplay(temperature)
```

### Context-Sensitive Text
```dart
// Different text for different simulation states
String getStatusText(BuildContext context, SimulationState state) {
  if (state.isRunning) {
    return AppLocalizations.of(context)!.simulationRunning;
  } else if (state.isPaused) {
    return AppLocalizations.of(context)!.simulationPaused;
  } else {
    return AppLocalizations.of(context)!.simulationStopped;
  }
}
```

## Scientific Terms

Use consistent scientific terminology across languages:

```json
{
  "gravitationalForce": "Gravitational Force",
  "orbitalVelocity": "Orbital Velocity",
  "escapeVelocity": "Escape Velocity",
  "lagrangePoint": "Lagrange Point",
  "barycenter": "Barycenter",
  "apoapse": "Apoapse",
  "periapse": "Periapse",
  "eccentricity": "Eccentricity",
  "semiMajorAxis": "Semi-major Axis"
}
```

## Tools & Validation

Use the provided i18n tools:

```bash
# Check for missing translations
python tools/i18n_manager.py --audit

# Generate translation reports
python tools/arb_auditor.py

# Clean duplicate entries
python tools/arb_duplicate_cleaner.py
```

## Testing

```dart
testWidgets('displays localized text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'), // Test Spanish
      home: MyWidget(),
    ),
  );
  
  expect(find.text('Gravitón'), findsOneWidget); // Spanish app title
});
```

## File Locations

- ARB files: `lib/l10n/app_*.arb`
- Generated localizations: `lib/l10n/app_localizations.dart`
- Tools: `tools/i18n_manager.py`, `tools/arb_auditor.py`