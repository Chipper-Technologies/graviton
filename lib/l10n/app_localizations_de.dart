// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appDescription =>
      'Eine Physiksimulation zur Erforschung der Gravitationsdynamik und Orbitalmechanik. Erleben Sie die Schönheit und Komplexität himmlischer Bewegung durch interaktive 3D-Visualisierung.';

  @override
  String get appFlavorDevelopment => 'Entwicklung';

  @override
  String get appFlavorProduction => 'Produktion';

  @override
  String get appInformationCredits => 'App-Informationen und Credits';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => 'Zurück';

  @override
  String get bottomNavVisualsLabel => 'Grafik';

  @override
  String get collisionHapticFeedbackDescription =>
      'Haptisches Feedback aktivieren, wenn Himmelskörper während der Simulation kollidieren';

  @override
  String get exitFullscreenHint =>
      'Tippen Sie irgendwo, um den Vollbildmodus zu verlassen';

  @override
  String get fullscreenMode => 'Vollbildmodus';

  @override
  String get fullscreenModeDescription =>
      'Alle UI-Elemente für eine immersive Betrachtung ausblenden';

  @override
  String get hapticFeedbackCollisions => 'Haptisches Feedback bei Kollisionen';

  @override
  String get hapticFeedbackDescription =>
      'Haptisches Feedback für UI-Interaktionen und Kollisionen aktivieren';

  @override
  String get uiHapticFeedbackDescription =>
      'Haptisches Feedback für UI-Interaktionen wie Tasten, Schalter und Navigation aktivieren';

  @override
  String get displayOptionsTitle => 'Anzeigeoptionen';

  @override
  String get pauseButton => 'Pause';

  @override
  String get playButton => 'Wiedergabe';

  @override
  String get presetAsteroidBeltChaos => 'Asteroidengürtel Chaos';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Dichtes Asteroidenfeld mit Gravitationseffekten';

  @override
  String get presetBinaryStarDrama => 'Doppelstern Drama';

  @override
  String get presetBinaryStarDramaDesc =>
      'Frontansicht zweier massereicher Sterne im Gravitationstanz';

  @override
  String get presetBinaryStarPlanetMoon => 'Doppelstern Planet & Mond';

  @override
  String get presetBinaryStarPlanetMoonDesc =>
      'Planet und Mond in chaotischem Doppelsternsystem';

  @override
  String get presetCompleteSolarSystem => 'Vollständiges Sonnensystem';

  @override
  String get presetCompleteSolarSystemDesc =>
      'Alle Planeten sichtbar mit schönen Umlaufbahnen';

  @override
  String get presetEarthMoonSystem => 'Erde-Mond-System';

  @override
  String get presetEarthMoonSystemDesc =>
      'Erde und Mond mit sichtbarer Orbitalmechanik';

  @override
  String get presetEarthView => 'Erdansicht';

  @override
  String get presetEarthViewDesc =>
      'Nahaufnahme der Erde mit atmosphärischen Details';

  @override
  String get presetGalaxyBlackHole => 'Galaktisches Schwarzes Loch';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Nahaufnahme des supermassiven schwarzen Lochs im galaktischen Zentrum';

  @override
  String get presetGalaxyCoreDetail => 'Galaxienkern Detail';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Nahaufnahme des hellen galaktischen Zentrums mit Akkretionsscheibe';

  @override
  String get presetGalaxyFormationOverview => 'Galaxienbildung Übersicht';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Weite Sicht auf Spiralgalaxienbildung mit kosmischem Hintergrund';

  @override
  String get presetInnerSolarSystem => 'Inneres Sonnensystem';

  @override
  String get presetInnerSolarSystemDesc =>
      'Nahaufnahme von Merkur, Venus, Erde und Mars mit bewohnbarer Zone';

  @override
  String get presetSaturnRings => 'Saturns Majestätische Ringe';

  @override
  String get presetSaturnRingsDesc =>
      'Nahaufnahme von Saturn mit detailliertem Ringsystem';

  @override
  String get presetThreeBodyBallet => 'Dreikörper-Ballett';

  @override
  String get presetThreeBodyBalletDesc =>
      'Klassisches Dreikörperproblem in eleganter Bewegung';

  @override
  String get resetButton => 'Zurücksetzen';

  @override
  String get resetChangelogButton => 'Changelog-Status zurücksetzen';

  @override
  String get resetChangelogDescription => 'Changelog-Lesestatus zurücksetzen';

  @override
  String get resetSettingsDescription =>
      'Alle Einstellungen auf Standardwerte zurücksetzen';

  @override
  String get resetTutorialDescription => 'Tutorial-Fortschritt zurücksetzen';

  @override
  String get simulationCanvasFocused =>
      'Simulationsleinwand fokussiert - Hauptbereich der Physiksimulation';

  @override
  String get simulationCanvasHint =>
      'Verwenden Sie Tastenkürzel zur Simulationssteuerung. Leertaste zum Pausieren, R zum Zurücksetzen, C zum Zentrieren der Kamera';

  @override
  String get simulationCanvasLabel => 'Gravitationsphysik-Simulation';

  @override
  String get simulationControlsFocused => 'Simulationssteuerung fokussiert';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return 'Gravitationssimulation mit $bodyCount Himmelskörpern. Status: $status. Geschwindigkeit: $speed. Schritte: $steps';
  }

  @override
  String get simulationSpeed => 'Simulationsgeschwindigkeit';

  @override
  String get simulationSpeedHint =>
      'Simulationsgeschwindigkeit von 0,1x bis 16x normaler Geschwindigkeit anpassen. Verwenden Sie Pfeiltasten für kleine Schritte.';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return 'Gravitationssimulation mit $bodyCount Himmelskörpern. Status: $status. Geschwindigkeit: $speed. Schritte abgeschlossen: $stepCount. Tippen Sie, um mit der Simulation zu interagieren oder verwenden Sie Tastenkürzel.';
  }

  @override
  String get simulationStats => 'Simulationsstatistiken';

  @override
  String get simulationStepsLabel => 'Simulationsschritte';

  @override
  String get speedDouble => 'Doppelt';

  @override
  String get speedFast => 'Schnell';

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String get speedHalf => 'Halbe Geschwindigkeit';

  @override
  String get speedLabel => 'Geschwindigkeit';

  @override
  String get speedMaximum => 'Maximum';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedQuarter => 'Viertel Geschwindigkeit';

  @override
  String get speedVeryFast => 'Sehr Schnell';

  @override
  String get stopFollowTitle => 'Folgen Stoppen';

  @override
  String get stopFollowingTooltip => 'Objektverfolgung Stoppen';

  @override
  String get stopRotateTitle => 'Rotation Stoppen';

  @override
  String get testPresetForUnitTesting => 'Test-Voreinstellung für Unit-Tests';

  @override
  String get trailsLabel => 'Spuren';

  @override
  String get cameraControlsFocused => 'Kamerasteuerung fokussiert';

  @override
  String get cameraControlsLabel => 'Kamera-Steuerung';

  @override
  String get cameraDynamicFraming => 'Dynamische Bildkomposition';

  @override
  String get cameraDynamicFramingDescription =>
      'Passt die Bildkomposition automatisch basierend auf Szeneninhalten an';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return 'Kamera folgt $bodyName in Entfernung $distance. Auto-Rotation: $rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return 'Kamera im freien Modus in Entfernung $distance. Auto-Rotation: $rotation';
  }

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get cameraManual => 'Manuelle Steuerung';

  @override
  String get cameraManualDescription =>
      'Traditionelle manuelle Kamerasteuerung mit Folgemodus';

  @override
  String get cameraPredictiveOrbital => 'Vorhersagende Orbital';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'KI sagt Orbitalpfade für dramatische Kamerabewegungen voraus';

  @override
  String get cameraSettingsTitle => 'Kameraeinstellungen';

  @override
  String get cameraSpeedHint =>
      'KI-Kamerabewegungsgeschwindigkeit von langsam bis schnell anpassen. Pfeiltasten für kleine Schritte verwenden.';

  @override
  String get cameraSpeedLabel => 'Kamera-Geschwindigkeit';

  @override
  String get cameraTooltip => 'Kameraeinstellungen und KI-Modi';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => 'Entfernung';

  @override
  String get previewEditortitle => 'Vorschau-Editor';

  @override
  String get setupEditorTitle => 'Einrichtung';

  @override
  String get rotateLabel => 'Rotieren';

  @override
  String get viewPhysicsSettings => 'Physik-Einstellungen anzeigen';

  @override
  String get zoomInAction => 'Hineinzoomen';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String get zoomOutAction => 'Herauszoomen';

  @override
  String get colorEditor => 'Farb-Editor';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return 'Farboption $color';
  }

  @override
  String get colorSelector => 'Farbauswahl';

  @override
  String colorOptionTooltip(String colorName) {
    return '$colorName Farbe für Himmelskörper wählen';
  }

  @override
  String get visualsTooltip => 'Visuelle Anzeigeoptionen';

  @override
  String get collisionHapticFeedback => 'Kollisions-Haptisches Feedback';

  @override
  String get collisionSensitivity => 'Kollisionsempfindlichkeit';

  @override
  String get gravityColorSchemeClassic => 'Klassisch';

  @override
  String get gravityColorSchemeEmerald => 'Smaragd';

  @override
  String get gravityColorSchemeMonochrome => 'Monochrom';

  @override
  String get gravityColorSchemeNeon => 'Neon';

  @override
  String get gravityColorSchemeSpectral => 'Spektral';

  @override
  String get gravityEditor => 'Schwerkraft-Editor';

  @override
  String get gravityFieldColorSchemeDescription =>
      'Farbschema für die Gravitationsfeldvisualisierung wählen';

  @override
  String get gravityFieldColorSchemeLabel => 'Gravitationsfeld-Farben';

  @override
  String get gravityFieldIndicatorsDescription =>
      'Visuelle Indikatoren der Gravitationsfeldstärke anzeigen';

  @override
  String get gravityFieldIndicatorsLabel => 'Feldstärke-Indikatoren';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => 'Feldstärke';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription =>
      'Gravitationsfeldvisualisierung anzeigen';

  @override
  String get gravityFieldsTitle => 'Gravitationsfelder';

  @override
  String get gravityWellsDescription =>
      'Gravitationsfeldstärke um Objekte anzeigen';

  @override
  String get gravityWellsLabel => 'Gravitationsfelder';

  @override
  String get massKgEditorhint => 'Masse in Kilogramm eingeben';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      'Physik-Konfiguration wird hier implementiert-Editor';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return 'Physik-Feld außerhalb des gültigen Bereichs';
  }

  @override
  String get physicsSection => 'Physik';

  @override
  String get physicsSettingsDescription => 'Simulationsparameter';

  @override
  String get physicsSettingsTitle => 'Physik-Einstellungen';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return 'Physik: $time Zeiteinheiten, $earthYears Erdenjahre, $steps Simulationsschritte abgeschlossen';
  }

  @override
  String get physicsTooltip => 'Physikvisualisierung und -einstellungen';

  @override
  String get physicsVisualizationTitle => 'Physikvisualisierung';

  @override
  String get temperatureCold => 'Kalt';

  @override
  String get temperatureEditorlabel => 'Temperatur-Editor';

  @override
  String get temperatureFrozen => 'Gefroren';

  @override
  String get temperatureHot => 'Heiß';

  @override
  String get temperatureKEditorhint => 'Temperatur in Kelvin eingeben';

  @override
  String get temperatureCelsiusEditorhint => 'Temperatur (°C)';

  @override
  String get temperatureFahrenheitEditorhint => 'Temperatur (°F)';

  @override
  String get temperatureModerate => 'Gemäßigt';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureScorching => 'Glühend';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitCelsiusName => 'Celsius';

  @override
  String get temperatureUnitFahrenheitName => 'Fahrenheit';

  @override
  String get temperatureUnitKelvinName => 'Kelvin';

  @override
  String get velocityMsEditor => 'Geschwindigkeit m/s Editor';

  @override
  String get addBodyButton => 'Körper hinzufügen';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      'Himmelskörper hinzufügen, um Ihr benutzerdefiniertes Szenario zu erstellen-Editor';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      'Asteroidengürtel und andere Partikelsysteme werden hier konfiguriert-Editor';

  @override
  String get beginnerEditor => 'Anfänger-Editor';

  @override
  String get noBodiesAdded => 'Noch keine Körper hinzugefügt';

  @override
  String get addBodiesInSetupTab => 'Körper im Setup-Tab hinzufügen';

  @override
  String get untitledScenario => 'Unbenanntes Szenario';

  @override
  String get noDescriptionProvided => 'Keine Beschreibung angegeben';

  @override
  String get collisionSoftening => 'Kollisions-Glättung';

  @override
  String get collisionRadius => 'Kollisionsradius';

  @override
  String get bodyTypeEditor => 'Körpertyp-Editor';

  @override
  String get createACopyOfThisCelestialBodyEditorHint =>
      'Eine Kopie dieses Himmelskörpers erstellen-Editor-Hinweis';

  @override
  String get createCustomScenarioButton =>
      'Benutzerdefiniertes Szenario erstellen';

  @override
  String get createCustomScenarioDescription =>
      'Benutzerdefinierte Szenario-Beschreibung';

  @override
  String get createScenarioButton => 'Szenario erstellen';

  @override
  String get createScenarioTitle => 'Szenario erstellen';

  @override
  String get editScenarioButton => 'Szenario bearbeiten';

  @override
  String get editScenarioHint => 'Dieses Szenario bearbeiten';

  @override
  String get editBodyButton => 'Körper bearbeiten';

  @override
  String get editBodyHint => 'Diesen Himmelskörper bearbeiten';

  @override
  String get deleteScenarioButton => 'Szenario löschen';

  @override
  String get deleteScenarioHint => 'Dieses Szenario löschen';

  @override
  String get customGravitationalSimulationEditor =>
      'Benutzerdefinierte Gravitationssimulation-Editor';

  @override
  String get deleteBodyConfirmMessage => 'Körper wirklich löschen?';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return 'Körper löschen bestätigen';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return '$bodyName löschen';
  }

  @override
  String get deleteBodyTooltip => 'Körper löschen';

  @override
  String get deleteButton => 'Löschen';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return 'Szenario wirklich löschen?';
  }

  @override
  String get deleteScenarioTitle => 'Szenario löschen';

  @override
  String deleteScenarioSuccessMessage(String scenarioName) {
    return 'Szenario erfolgreich gelöscht: $scenarioName';
  }

  @override
  String deleteScenarioFailedMessage(String error) {
    return 'Fehler beim Löschen des Szenarios: $error';
  }

  @override
  String get editEditorLabel => 'Bearbeiten-Editor';

  @override
  String get editScenarioTitle => 'Szenario bearbeiten';

  @override
  String get gravitationalForcesEditor => 'Gravitationskräfte-Editor';

  @override
  String get newScenarioEditor => 'Neues Szenario-Editor';

  @override
  String get noBodiesYetEditor => 'Noch keine Körper-Editor';

  @override
  String get positionMEditor => 'Position m Editor';

  @override
  String get positionMotionEditor => 'Positions-/Bewegungseditor';

  @override
  String get propertiesEditor => 'Eigenschaften-Editor';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      'Diesen Himmelskörper aus dem Szenario entfernen-Editor-Hinweis';

  @override
  String get softeningEditor => 'Glättungs-Editor';

  @override
  String get stellarPropertiesEditor => 'Sterne-Eigenschaften-Editor';

  @override
  String get trailPointsEditor => 'Spur-Punkte-Editor';

  @override
  String get customColor => 'Benutzerdefinierte Farbe';

  @override
  String get customLabel => 'Benutzerdefiniert';

  @override
  String get customScenarioDescription =>
      'Benutzerdefinierte Szenario-Beschreibung';

  @override
  String get viewScenarioButton => 'Szenario anzeigen';

  @override
  String get viewScenarioHint =>
      'Szenario-Details im schreibgeschützten Modus anzeigen';

  @override
  String get exportScenarioButton => 'Szenario exportieren';

  @override
  String get exportScenarioHint => 'Szenario als Datei zum Teilen exportieren';

  @override
  String exportScenarioFailedMessage(String error) {
    return 'Szenario-Export fehlgeschlagen';
  }

  @override
  String get exportScenarioNotImplementedMessage =>
      'Szenario-Export noch nicht implementiert';

  @override
  String get saveButton => 'Speichern';

  @override
  String get saveBodyTooltip => 'Körper Speichern';

  @override
  String get saveNewBodyAccessibility => 'Neuen Körper speichern';

  @override
  String get saveNewBodyHint =>
      'Erstellt den Körper mit den aktuellen Einstellungen';

  @override
  String get saveChangesToBodyAccessibility => 'Änderungen am Körper speichern';

  @override
  String get saveChangesToBodyHint =>
      'Speichert alle Änderungen an diesem Körper';

  @override
  String get moreActionsAccessibility => 'Weitere Aktionen';

  @override
  String get moreActionsHint => 'Menü mit Duplikat- und Löschoptionen öffnen';

  @override
  String get duplicateBodyAccessibility => 'Erstellt eine Kopie dieses Körpers';

  @override
  String get deleteBodyAccessibility => 'Entfernt diesen Körper dauerhaft';

  @override
  String get settingsButtonFocused => 'Einstellungen-Schaltfläche fokussiert';

  @override
  String get settingsMenuDescription => 'Visuelle & Verhaltensoptionen';

  @override
  String get settingsTooltip => 'Anwendungseinstellungen';

  @override
  String get toggleAutoRotateAction => 'Auto-Rotation umschalten';

  @override
  String get toggleGravityFieldsTooltip => 'Gravitationsfelder umschalten';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Planeten-Bewohnbarkeitsstatus Umschalten';

  @override
  String get toggleHabitableZonesTooltip => 'Bewohnbare Zonen Umschalten';

  @override
  String get toggleLabelsTooltip => 'Körperlabels umschalten';

  @override
  String get toggleStatsTooltip => 'Statistiken umschalten';

  @override
  String get statsLabel => 'Statistiken';

  @override
  String get helpMenuDescription => 'Tutorial & Ziele';

  @override
  String get tutorialButton => 'Tutorial';

  @override
  String get tutorialCameraDescription =>
      'Ziehen Sie, um Ihre Ansicht zu drehen, kneifen Sie zum Zoomen, verwenden Sie zwei Finger zum Rollen der Kamera und verwenden Sie drei Finger zum Verschieben. Die untere Leiste hat Fokus-, Zentrier- und automatische Rotationssteuerelemente für ein kinoreifes Erlebnis.';

  @override
  String get tutorialCameraTitle => 'Kamera- & Ansichtssteuerung';

  @override
  String get tutorialControlsDescription =>
      'Tippen Sie überall hin, um die schwebenden Play/Pause-Steuerelemente für die Simulation aufzurufen. Die Geschwindigkeitssteuerung befindet sich oben rechts. Tippen Sie auf das Menü (⋮) für Szenarien, Einstellungen und Physik-Anpassungen.';

  @override
  String get tutorialControlsDescriptionPart1 =>
      'Tippen Sie überall hin, um die schwebenden Play/Pause-Steuerelemente für die Simulation aufzurufen. Die Geschwindigkeitssteuerung befindet sich oben rechts. Tippen Sie auf das Menü';

  @override
  String get tutorialControlsDescriptionPart2 =>
      'für Szenarien, Einstellungen und Physik-Anpassungen.';

  @override
  String get tutorialControlsTitle => 'Simulationssteuerung';

  @override
  String get tutorialDescription => 'Interaktive geführte Tour durch die App';

  @override
  String get tutorialExploreDescription =>
      'Sie sind bereit! Beginnen Sie mit dem Sonnensystem, um vertraute Planeten zu sehen, oder tauchen Sie in das Dreikörperproblem für chaotischen Spaß ein. Denken Sie daran: Jedes Zurücksetzen erschafft ein neues Universum zum Erkunden!';

  @override
  String get tutorialExploreTitle => 'Bereit zum Erkunden!';

  @override
  String get tutorialNavigationHint =>
      'Wischen Sie nach links/rechts oder verwenden Sie Schaltflächen zur Navigation';

  @override
  String get tutorialObjectivesDescription =>
      '• Realistische Orbitalmechanik beobachten\n• Verschiedene astronomische Szenarien erkunden\n• Mit Gravitationsinteraktionen experimentieren\n• Kollisionen und Verschmelzungen beobachten\n• Über Planetenbewegung lernen\n• Chaotische Dreikörperdynamik entdecken';

  @override
  String get tutorialObjectivesTitle => 'Was Können Sie Tun?';

  @override
  String get tutorialResetMessage =>
      'Tutorial-Status zurückgesetzt! Starten Sie die App neu, um das erste Mal-Erlebnis zu sehen.';

  @override
  String get tutorialResetSuccess => 'Tutorial-Fortschritt wurde zurückgesetzt';

  @override
  String get tutorialScenariosDescription =>
      'Öffnen Sie das Menü (⋮) oben rechts, um verschiedene Szenarien zu erkunden: unser Sonnensystem, Erde-Mond-Dynamik, Doppelsterne oder das chaotische Dreikörperproblem. Jedes bietet einzigartige Physik zum Entdecken!';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Öffnen Sie das Menü';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'oben rechts, um verschiedene Szenarien zu erkunden: unser Sonnensystem, Erde-Mond-Dynamik, Doppelsterne oder das chaotische Dreikörperproblem. Jedes bietet einzigartige Physik zum Entdecken!';

  @override
  String get tutorialScenariosTitle => 'Wählen Sie Ihr Abenteuer';

  @override
  String get tutorialWelcomeDescription =>
      'Willkommen bei Graviton, Ihrem Fenster in die faszinierende Welt der Gravitationsphysik! Diese App ermöglicht es Ihnen zu erkunden, wie Himmelskörper durch Gravitation interagieren und wunderschöne Orbitaltänze durch Raum und Zeit schaffen.';

  @override
  String get tutorialWelcomeTitle => 'Willkommen bei Graviton!';

  @override
  String get welcomeCardDescription =>
      'Erkunden Sie Gravitationsphysik durch interaktive Simulationen. Probieren Sie verschiedene Szenarien aus, passen Sie Steuerelemente an und beobachten Sie, wie sich der Kosmos entfaltet!';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get descriptionEditorLabel => 'Beschreibungs-Editor';

  @override
  String get next => 'Nächste';

  @override
  String get ok => 'OK';

  @override
  String get previous => 'Vorherige';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType geändert zu $value';
  }

  @override
  String timeFormatted(String time) {
    return '${time}s';
  }

  @override
  String get timeLabel => 'Zeit';

  @override
  String get timeScaleStatLabel => 'Zeitskala';

  @override
  String get updateLater => 'Später aktualisieren';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String get updateRequiredMessage =>
      'Eine neuere Version dieser App ist verfügbar. Bitte aktualisieren Sie die App, um sie weiterhin mit den neuesten Funktionen und Verbesserungen nutzen zu können.';

  @override
  String get updateRequiredTitle => 'Update erforderlich';

  @override
  String get updateRequiredWarning =>
      'Diese Version wird nicht mehr unterstützt.';

  @override
  String errorLoadingChangelogs(String error) {
    return 'Fehler beim Laden der Changelogs: $error';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Fehler beim Öffnen des Links: $error';
  }

  @override
  String get notificationTypeDebug => 'Debug';

  @override
  String get notificationTypeInfo => 'Information';

  @override
  String get warningTitle => 'Warnung';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return 'Barrierefreiheit-Ankündigung übersprungen - keine Bindung';
  }

  @override
  String get accessibilityCameraFocus =>
      'Kamera auf nächsten Himmelskörper fokussiert';

  @override
  String get accessibilityCameraFollow =>
      'Kamera folgt nun dem ausgewählten Himmelskörper';

  @override
  String get accessibilityCameraReset =>
      'Kameraansicht auf Standardposition zurückgesetzt';

  @override
  String get accessibilityCameraUnfollow =>
      'Kamera hört auf, dem Himmelskörper zu folgen';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return 'Kollisionsempfindlichkeit geändert zu $newValue';
  }

  @override
  String accessibilityError(String errorMessage) {
    return 'Fehler: $errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return 'Gravitationsstärke geändert zu $newValue';
  }

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return 'Kollision erkannt: $body1 fusioniert mit $body2';
  }

  @override
  String get accessibilityMergeEventContext =>
      'Die kombinierte Masse erzeugt einen neuen Himmelskörper';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return 'Szenario geändert zu $scenarioName';
  }

  @override
  String get accessibilityScenarioChangeContext =>
      'Neue Himmelskörper und Physikparameter geladen';

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName deaktiviert';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName aktiviert';
  }

  @override
  String get accessibilitySimulationPaused => 'Simulation pausiert';

  @override
  String get accessibilitySimulationPausedContext =>
      'Alle Himmelskörper haben aufgehört sich zu bewegen';

  @override
  String get accessibilitySimulationReset => 'Simulation zurückgesetzt';

  @override
  String get accessibilitySimulationResetContext =>
      'Neues Szenario mit frischen Himmelskörpern geladen';

  @override
  String get accessibilitySimulationResumed => 'Simulation fortgesetzt';

  @override
  String get accessibilitySimulationResumedContext =>
      'Himmelskörper bewegen sich wieder';

  @override
  String get accessibilitySimulationStarted => 'Simulation gestartet';

  @override
  String get accessibilitySimulationStartedContext =>
      'Himmelskörper sind nun in Bewegung';

  @override
  String get accessibilitySimulationStopped => 'Simulation gestoppt';

  @override
  String get accessibilitySimulationStoppedContext =>
      'Alle Himmelskörper wurden zurückgesetzt';

  @override
  String accessibilitySpeedChange(String newValue) {
    return 'Simulationsgeschwindigkeit geändert zu $newValue';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return 'Tutorial-Schritt $currentStep von $totalSteps: $stepName';
  }

  @override
  String get changelogAdded => 'Neue Funktionen';

  @override
  String get changelogButton => 'Changelog anzeigen';

  @override
  String get changelogCategoryAdded => 'Hinzugefügt';

  @override
  String get changelogCategoryFixed => 'Behoben';

  @override
  String get changelogCategoryImproved => 'Verbessert';

  @override
  String get changelogDescription => 'App-Updates und Änderungen anzeigen';

  @override
  String get changelogDone => 'Fertig';

  @override
  String get changelogFixed => 'Fehlerbehebungen';

  @override
  String get changelogHometitle => 'Änderungsprotokoll-Startseite';

  @override
  String get changelogImproved => 'Verbesserungen';

  @override
  String changelogLoadError(String error) {
    return 'Fehler beim Laden des Changelogs: $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return 'Kein Changelog gefunden. Fügen Sie zuerst Changelog-Daten zu Firestore hinzu.\nAktuelle Version: $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return 'Veröffentlicht am $date';
  }

  @override
  String get changelogResetMessage => 'Changelog-Status wurde zurückgesetzt';

  @override
  String get changelogResetSuccess => 'Changelog-Status wurde zurückgesetzt';

  @override
  String get changelogTitle => 'Was ist neu';

  @override
  String get debugStatisticsTitle => 'Debug und Statistiken';

  @override
  String errorLoadingChangelogEHome(String error) {
    return 'Fehler beim Laden des Änderungsprotokolls';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return 'Kein Änderungsprotokoll für diese Version verfügbar';
  }

  @override
  String get testPreset => 'Test-Voreinstellung';

  @override
  String get testScenarioButton => 'Test-Szenario-Schaltfläche';

  @override
  String get testScenarioHint =>
      'Das aktuelle Szenario in der Simulation testen';

  @override
  String get testScenarioNotImplementedMessage =>
      'Test-Szenario noch nicht implementiert';

  @override
  String get scenarioEditorMenuHint =>
      'Menü mit Test- und Exportoptionen öffnen';

  @override
  String get aboutButtonTooltip => 'Über';

  @override
  String get aboutMenuDescription => 'App-Informationen & Credits';

  @override
  String get accessAppPreferences => 'App-Einstellungen öffnen';

  @override
  String get accessScenarioOptions => 'Szenario-Optionen öffnen';

  @override
  String get adjustSimulationSpeed => 'Simulationsgeschwindigkeit anpassen';

  @override
  String get aiCameraModesTitle => 'KI-Kamera-Modi';

  @override
  String get allRightsReserved => 'Alle Rechte vorbehalten';

  @override
  String get announcementTitle => 'Ankündigung';

  @override
  String appliedPreset(String presetName) {
    return 'Voreinstellung angewendet: $presetName';
  }

  @override
  String get applyScene => 'Szene anwenden';

  @override
  String get atLeastOneBodyIsRequired =>
      'Mindestens ein Körper ist erforderlich';

  @override
  String get authorLabel => 'Autor';

  @override
  String get autoRotateActive => 'aktiv';

  @override
  String get autoRotateInactive => 'inaktiv';

  @override
  String get autoRotateLabel => 'Auto-Rotation';

  @override
  String get autoRotateOff => 'Aus';

  @override
  String get autoRotateOn => 'Ein';

  @override
  String get autoRotateTooltip => 'Auto-Rotation';

  @override
  String get rotateSpeed => 'Rotationsgeschwindigkeit';

  @override
  String get blackColor => 'Schwarz';

  @override
  String get bodies => 'körper';

  @override
  String get bodiesHeaderDescription => 'Himmelskörper-Header-Beschreibung';

  @override
  String bodiesHeaderPlural(int count) {
    return 'Himmelskörper';
  }

  @override
  String scenariosHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Szenarien',
      one: '1 Szenario',
      zero: 'Keine Szenarien',
    );
    return '$_temp0';
  }

  @override
  String experimentsHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Experimente',
      one: '1 Experiment',
      zero: 'Keine Experimente',
    );
    return '$_temp0';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return 'Körper in der Simulation: $descriptions';
  }

  @override
  String get bodiesLabel => 'Körper';

  @override
  String get bodyAlpha => 'Alpha';

  @override
  String bodyAsteroid(int number) {
    return 'Asteroid $number';
  }

  @override
  String get bodyBeta => 'Beta';

  @override
  String get bodyBlackHole => 'Schwarzes Loch';

  @override
  String get bodyCenterOfMass => 'Massenzentrum';

  @override
  String get bodyCentralStar => 'Zentralstern';

  @override
  String bodyColorInvalid(String prefix) {
    return 'Körperfarbe ungültig';
  }

  @override
  String get bodyEarth => 'Erde';

  @override
  String get bodyEarthLike => 'Erdähnlich';

  @override
  String get bodyGamma => 'Gamma';

  @override
  String bodyIndex(int index) {
    return 'Körper-Index';
  }

  @override
  String get bodyInnerPlanet => 'Innerer Planet';

  @override
  String get bodyJupiter => 'Jupiter';

  @override
  String get bodyMars => 'Mars';

  @override
  String bodyMassInvalid(String prefix) {
    return 'Körpermasse ungültig';
  }

  @override
  String get bodyMercury => 'Merkur';

  @override
  String get bodyMoon => 'Mond';

  @override
  String get bodyMoonM => 'Mond M';

  @override
  String get bodySpacecraft => 'Raumfahrzeug';

  @override
  String get bodyIo => 'Io';

  @override
  String get bodyEuropa => 'Europa';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return 'Kopie von $bodyName';
  }

  @override
  String bodyNameRequired(String prefix) {
    return 'Körpername erforderlich';
  }

  @override
  String get bodyNeptune => 'Neptun';

  @override
  String bodyNumberTemplate(String number) {
    return 'Körper $number';
  }

  @override
  String get bodyOuterPlanet => 'Äußerer Planet';

  @override
  String get bodyPlanetP => 'Planet P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return 'Körperpositions-Komponente ungültig';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return 'Körperposition ungültig';
  }

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyPropertiesLuminosity => 'Stellare Leuchtkraft';

  @override
  String get bodyPropertiesMass => 'Masse';

  @override
  String get bodyPropertiesName => 'Name';

  @override
  String get bodyPropertiesNameHint => 'Körpername eingeben';

  @override
  String get bodyPropertiesRadius => 'Radius';

  @override
  String get bodyPropertiesMassHint =>
      'Gravitationseinfluss und Bahnmechanik anpassen';

  @override
  String get bodyPropertiesRadiusHint => 'Größe und Kollisionsgrenze steuern';

  @override
  String get bodyPropertiesTitle => 'Körpereigenschaften';

  @override
  String get bodyPropertiesVelocity => 'Geschwindigkeit';

  @override
  String bodyRadiusInvalid(String prefix) {
    return 'Körperradius ungültig';
  }

  @override
  String bodyRing(int number) {
    return 'Ring $number';
  }

  @override
  String get bodyRingedPlanet => 'Ringplanet';

  @override
  String get bodyRockyPlanet => 'Felsplanet';

  @override
  String get bodySaturn => 'Saturn';

  @override
  String bodySelectedTemplate(String bodyNumber) {
    return '$bodyNumber ausgewählt';
  }

  @override
  String get bodyStarA => 'Stern A';

  @override
  String get bodyStarB => 'Stern B';

  @override
  String bodyStarNumber(int number) {
    return 'Stern $number';
  }

  @override
  String get bodySun => 'Sonne';

  @override
  String get bodySuperEarth => 'Supererde';

  @override
  String get bodyTypeAsteroid => 'Asteroid';

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Asteroiden',
      one: '1 Asteroid',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeInvalid(String prefix, String bodyType) {
    return 'Körpertyp ungültig';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Monde',
      one: '1 Mond',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypePlanet => 'Planet';

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Planeten',
      one: '1 Planet',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeSelector => 'Körpertyp-Auswahl';

  @override
  String get bodyTypeStar => 'Stern';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sterne',
      one: '1 Stern',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeNeutronStar => 'Neutronenstern';

  @override
  String get bodyTypeBlackHole => 'Schwarzes Loch';

  @override
  String get bodyTypeMoon => 'Mond';

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return 'Körpertyp: $type';
  }

  @override
  String get bodyTypeTooltipStar =>
      'Massive Himmelskörper, die durch Kernfusion Licht und Wärme erzeugen. Sterne sind die primären Energiequellen in Sternsystemen.';

  @override
  String get bodyTypeTooltipPlanet =>
      'Große Himmelskörper, die Sterne umkreisen und ihre Umlaufbahn freigeräumt haben. Planeten können gesteinsartig oder gasförmig sein und Monde haben.';

  @override
  String get bodyTypeTooltipMoon =>
      'Natürliche Satelliten, die Planeten umkreisen. Monde können Gezeiten beeinflussen und Planetensystemen Stabilität verleihen.';

  @override
  String get bodyTypeTooltipAsteroid =>
      'Kleine Gesteinsbrocken, die die Sonne umkreisen. Asteroiden sind Überreste aus der frühen Entstehung des Sonnensystems.';

  @override
  String get bodyTypeTooltipBlackHole =>
      'Bereiche der Raumzeit mit so intensiven Gravitationsfeldern, dass nichts, nicht einmal Licht, ihnen entkommen kann.';

  @override
  String get bodyTypeTooltipNeutronStar =>
      'Extrem dichte Sternenreste, die entstehen, wenn massive Sterne kollabieren. Sie haben unglaublich starke Gravitations- und Magnetfelder.';

  @override
  String get bodyUranus => 'Uranus';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return 'Körpergeschwindigkeits-Komponente ungültig';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return 'Körpergeschwindigkeit ungültig';
  }

  @override
  String get bodyVenus => 'Venus';

  @override
  String get bottomSheetFocused => 'Unteres Blatt fokussiert';

  @override
  String get bottomSheetLabel => 'Unteres Blatt';

  @override
  String get browseAvailableSimulations =>
      'Verfügbare Simulationen durchsuchen';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return 'Himmelskörper $name';
  }

  @override
  String get centerLabel => 'Zentrieren';

  @override
  String get centerViewTooltip => 'Ansicht zentrieren';

  @override
  String get cinematicCameraTechniqueDescription =>
      'Wählen Sie, wie die KI die Kamera beim Verfolgen von Objekten steuert';

  @override
  String get cinematicCameraTechniqueLabel => 'KI-Kamera-Technik';

  @override
  String get cinematicTechniqueDynamicFramingDesc =>
      'Echtzeit-dramatische Zielerfassung für chaotische Szenarien';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      'KI-Touren und Umlaufbahnvorhersagen für Bildungsszenarien';

  @override
  String get closeButton => 'Schließen';

  @override
  String get collapsedState => 'eingeklappt';

  @override
  String get collisionsSection => 'Kollisionen';

  @override
  String get colorsLabel => 'Farben';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ Kalt';

  @override
  String copiedToClipboard(String text) {
    return 'In die Zwischenablage kopiert: $text';
  }

  @override
  String get copyButton => 'Kopieren';

  @override
  String get copyrightLabel => 'Urheberrecht';

  @override
  String couldNotOpenUrl(String url) {
    return 'Konnte $url nicht öffnen';
  }

  @override
  String get crosshairsDescription => 'Bildschirmmitte-Anzeige einblenden';

  @override
  String get crosshairsTitle => 'Fadenkreuz';

  @override
  String get currentScenario => 'Aktuelles Szenario';

  @override
  String get currentStatisticsTitle => 'Aktuelle Statistiken';

  @override
  String get currentlySelected => 'Aktuell ausgewählt';

  @override
  String get cyanColor => 'Cyan';

  @override
  String get deactivate => 'Deaktivieren';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      'Beschreiben Sie, was dieses Szenario demonstriert-Editor-Hinweis';

  @override
  String get detailsEditorLabel => 'Details-Editor';

  @override
  String get developerToolsMenuDescription => 'Debug-Tools für die Entwicklung';

  @override
  String get developerToolsTitle => 'Entwicklertools';

  @override
  String get difficultyEditorLabel => 'Schwierigkeits-Editor';

  @override
  String get discardButton => 'Verwerfen';

  @override
  String get dragToRotateCameraView => 'Ziehen, um Kameraansicht zu drehen';

  @override
  String get dualOrbitalPaths => 'Doppelte Orbitalbahnen';

  @override
  String get dualOrbitalPathsDescription =>
      'Sowohl ideale kreisförmige als auch tatsächliche elliptische Orbitalbahnen anzeigen';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return '$bodyName duplizieren';
  }

  @override
  String get duplicateBodyTooltip => 'Körper duplizieren';

  @override
  String get dynamicFramingDescription => 'KI rahmt alle Objekte dynamisch ein';

  @override
  String get earthBlueColor => 'Erdblau';

  @override
  String earthYearsFormatted(String years) {
    return '$years Jahre';
  }

  @override
  String get earthYearsLabel => 'Erdenjahre';

  @override
  String get educationalFocusBinaryOrbits => 'Doppelsternsystem';

  @override
  String get educationalFocusChaoticDynamics => 'chaotische Dynamik';

  @override
  String get educationalFocusManyBodyDynamics => 'Vielkörperdynamik';

  @override
  String get educationalFocusPlanetaryMotion => 'Planetenbewegung';

  @override
  String get educationalFocusRealWorldSystem => 'reales System';

  @override
  String get educationalFocusStructureFormation => 'Strukturbildung';

  @override
  String get educationalObjectivesEditortitle => 'Bildungsziele-Editor-Titel';

  @override
  String get educationalObjectivesFutureMessage =>
      'Bildungsziele können hier in zukünftigen Versionen konfiguriert werden';

  @override
  String get educationalObjectivesListMessage =>
      'Dies umfasst:\n• Lernziele\n• Erfolgskriterien\n• Geführte Herausforderungen\n• Bewertungsraster';

  @override
  String get emergencyNotificationTitle => 'Wichtiger Hinweis';

  @override
  String get enterScenarioNameEditorHint =>
      'Szenario-Name eingeben-Editor-Hinweis';

  @override
  String get equipotentialSurfacesDescription =>
      'Flächen gleicher gravitativer Potentialenergie anzeigen';

  @override
  String get equipotentialSurfacesLabel => 'Äquipotentialflächen';

  @override
  String get exit => 'Beenden';

  @override
  String get exitAppMessage =>
      'Sind Sie sicher, dass Sie Graviton beenden möchten?';

  @override
  String get exitAppTitle => 'App Beenden';

  @override
  String get expandedState => 'erweitert';

  @override
  String failedToSwitchScenarioError(String error) {
    return 'Fehler beim Wechseln des Szenarios';
  }

  @override
  String get fieldOfViewLabel => 'Sichtfeld';

  @override
  String get focusOnNearestTooltip => 'Nächsten Körper Fokussieren';

  @override
  String get followLabel => 'Verfolgen';

  @override
  String get followObjectTooltip => 'Ausgewähltes Objekt Verfolgen';

  @override
  String get getStarted => 'Loslegen!';

  @override
  String get globalGravityFieldsDescription =>
      'Gravitationsfeldvisualisierung für alle massereichen Objekte aktivieren';

  @override
  String get globalGravityFieldsLabel => 'Globale Gravitationsfelder';

  @override
  String get gotItButton => 'Verstanden!';

  @override
  String get gravitationalConstant => 'Gravitationskonstante';

  @override
  String get greenColor => 'Grün';

  @override
  String get habitabilityHabitable => 'Bewohnbar';

  @override
  String get habitabilityIndicatorsDescription =>
      'Farbkodierte Statusringe um Planeten basierend auf ihrer Bewohnbarkeit anzeigen';

  @override
  String get habitabilityIndicatorsLabel => 'Planetenstatus';

  @override
  String get habitabilityLabel => 'Bewohnbarkeit';

  @override
  String get habitabilityTooCold => 'Zu Kalt';

  @override
  String get habitabilityTooHot => 'Zu Heiß';

  @override
  String get habitabilityUnknown => 'Unbekannt';

  @override
  String get habitabilityGasGiant => 'Gasriese';

  @override
  String get habitabilityTooSmall => 'Zu Klein';

  @override
  String get habitabilityNoAtmosphere => 'Keine Atmosphäre';

  @override
  String get habitabilityToxicAtmosphere => 'Giftige Atmosphäre';

  @override
  String get habitabilityHighRadiation => 'Hohe Strahlung';

  @override
  String get habitabilityTidallyLocked => 'Gebundene Rotation';

  @override
  String get habitabilityExtremeGravity => 'Extreme Schwerkraft';

  @override
  String get habitableZonesDescription =>
      'Farbige Zonen um Sterne anzeigen, die bewohnbare Regionen kennzeichnen';

  @override
  String get habitableZonesLabel => 'Bewohnbare Zonen';

  @override
  String get hapticsSection => 'Haptik';

  @override
  String get hideUIInScreenshotMode => 'Navigation Ausblenden';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'App-Leiste, untere Navigation und Copyright ausblenden, wenn Screenshot-Modus aktiv ist';

  @override
  String get initialMotionVectorsDescription =>
      'Beschreibung der anfänglichen Bewegungsvektoren';

  @override
  String invalidJsonFormat(String error) {
    return 'Ungültiges JSON-Format';
  }

  @override
  String get invertPitchControlsDescription => 'Auf/Ab-Ziehrichtung umkehren';

  @override
  String get invertPitchControlsLabel => 'Nickbewegung Umkehren';

  @override
  String get jupiterTanColor => 'Jupiter-Beige';

  @override
  String get keyboardShortcutsHint =>
      'Verwenden Sie Leertaste zum Pausieren/Fortsetzen, R zum Zurücksetzen, C zum Zentrieren der Kamera, A zum Umschalten der Auto-Rotation';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => 'App-Sprache ändern';

  @override
  String get languageSelectionHint =>
      'Wählen Sie Ihre bevorzugte Anzeigesprache';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageLabel => 'Allgemein';

  @override
  String get temperatureUnitsLabel => 'Temperatureinheiten';

  @override
  String get temperatureUnitsDescription =>
      'Bevorzugte Einheiten für die Anzeige von Temperaturen in der App';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get lightEnergyOutputDescription =>
      'Beschreibung der Licht-Energieabgabe';

  @override
  String get loadingVersion => 'Version wird geladen...';

  @override
  String get luminosityEditorLabel => 'Leuchtkraft-Editor-Label';

  @override
  String get luminosityWEditorhint =>
      'Leuchtkraft in Watt eingeben-Editor-Hinweis';

  @override
  String get maintenanceTitle => 'Wartung';

  @override
  String get manualControlDescription =>
      'Vollständige manuelle Kamerasteuerung';

  @override
  String get manualControlsTitle => 'Manuelle Steuerung';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String get marsRedColor => 'Mars-Rot';

  @override
  String get maxTrailPointsInvalid => 'Maximale Spurpunkte ungültig';

  @override
  String get maximum50BodiesAllowed => 'Maximal 50 Körper erlaubt';

  @override
  String get mercuryGrayColor => 'Merkur-Grau';

  @override
  String get missingRequiredFieldBodies =>
      'Erforderliches Feld \'Körper\' fehlt';

  @override
  String get missingRequiredFieldConfiguration =>
      'Erforderliches Feld \'Konfiguration\' fehlt';

  @override
  String get missingRequiredFieldMetadata =>
      'Erforderliches Feld \'Metadaten\' fehlt';

  @override
  String get missingRequiredFieldParticleSystems =>
      'Erforderliches Feld \'Partikelsysteme\' fehlt';

  @override
  String get missingRequiredFieldPhysics =>
      'Erforderliches Feld \'Physik\' fehlt';

  @override
  String get missingRequiredFieldVersion =>
      'Erforderliches Feld \'Version\' fehlt';

  @override
  String get moreOptionsTooltip => 'Weitere Optionen';

  @override
  String get navigationAidsTitle => 'Navigationshilfen';

  @override
  String get neptuneBlueColor => 'Neptun-Blau';

  @override
  String get newsTitle => 'Neuigkeiten';

  @override
  String get nextPreset => 'Nächste Voreinstellung';

  @override
  String get nextSceneTooltip => 'Nächste Szene-Tooltip';

  @override
  String get noActionsAvailable => 'Keine Aktionen verfügbar';

  @override
  String get noBodiesInSimulation =>
      'Keine Himmelskörper derzeit in der Simulation';

  @override
  String get noChangelogsAvailable => 'Keine Changelogs verfügbar';

  @override
  String get objectives1 => 'Verstehen, wie Gravitation den Kosmos formt';

  @override
  String get objectives2 => 'Stabile vs. chaotische Orbitalsysteme beobachten';

  @override
  String get objectives3 =>
      'Lernen, warum Planeten sich in elliptischen Bahnen bewegen';

  @override
  String get objectives4 => 'Entdecken, wie Doppelsterne interagieren';

  @override
  String get objectives5 => 'Sehen, was passiert, wenn Objekte kollidieren';

  @override
  String get objectives6 => 'Die Komplexität des Dreikörperproblems schätzen';

  @override
  String get objectivesDescription =>
      '• Verstehen Sie, wie die Schwerkraft den Kosmos formt\n• Beobachten Sie stabile vs. chaotische Orbitalsysteme\n• Lernen Sie, warum sich Planeten in elliptischen Bahnen bewegen\n• Entdecken Sie, wie Doppelsterne interagieren\n• Sehen Sie, was passiert, wenn Objekte kollidieren\n• Schätzen Sie die Komplexität des Drei-Körper-Problems';

  @override
  String get objectivesTitle => 'Lernziele';

  @override
  String get offScreenIndicatorsDescription =>
      'Pfeile zu Objekten außerhalb des sichtbaren Bereichs anzeigen';

  @override
  String get offScreenIndicatorsTitle => 'Bildschirm-Außen-Indikatoren';

  @override
  String get orangeColor => 'Orange';

  @override
  String get particleSystemsEditortitle => 'Partikelsysteme-Editor-Titel';

  @override
  String get pathVisualizationTitle => 'Bahnvisualisierung';

  @override
  String get physicalPropertiesDescription =>
      'Beschreibung der physikalischen Eigenschaften';

  @override
  String get pinchToZoomInOut => 'Kneifen zum Hinein-/Herauszoomen';

  @override
  String get pitchLabel => 'Neigen';

  @override
  String get positionEditorLabel => 'Positions-Editor-Label';

  @override
  String get predictiveOrbitalDescription =>
      'KI sagt optimale Orbitalansichten voraus';

  @override
  String get previousPreset => 'Vorherige Voreinstellung';

  @override
  String get previousSceneTooltip => 'Vorherige Szene-Tooltip';

  @override
  String get privacyPolicyLabel => 'Datenschutzrichtlinie';

  @override
  String get promotionTitle => 'Angebot';

  @override
  String get quickStart1 =>
      'Wählen Sie ein Szenario (Sonnensystem für Anfänger empfohlen)';

  @override
  String get quickStart2 =>
      'Drücken Sie Abspielen, um die Simulation zu starten';

  @override
  String get quickStart3 =>
      'Ziehen Sie, um Ihre Ansicht zu drehen, kneifen Sie zum Zoomen';

  @override
  String get quickStart4 =>
      'Tippen Sie auf den Geschwindigkeitsregler, um die Zeit zu steuern';

  @override
  String get quickStart5 =>
      'Versuchen Sie Zurücksetzen für neue zufällige Konfigurationen';

  @override
  String get quickStart6 => 'Aktivieren Sie Spuren, um Orbitalbahnen zu sehen';

  @override
  String get quickStartDescription =>
      '1. Wählen Sie ein Szenario (Sonnensystem für Anfänger empfohlen)\n2. Drücken Sie Play, um die Simulation zu starten\n3. Ziehen Sie, um die Ansicht zu drehen, kneifen Sie zum Zoomen\n4. Tippen Sie auf den Geschwindigkeitsregler, um die Zeit zu kontrollieren\n5. Versuchen Sie Reset für neue zufällige Konfigurationen\n6. Aktivieren Sie Spuren, um Orbitalbahnen zu sehen';

  @override
  String get quickStartTitle => 'Schnellstart-Anleitung';

  @override
  String get quickTutorialButton => 'Schnelles Tutorial';

  @override
  String get radiusMEditorhint => 'Radius in Metern eingeben-Editor-Hinweis';

  @override
  String get realisticColors => 'Realistische Farben';

  @override
  String get realisticColorsDescription =>
      'Wissenschaftlich genaue Farben basierend auf Temperatur und Sternklassifikation verwenden';

  @override
  String get redColor => 'Rot';

  @override
  String get rollLabel => 'Rollen';

  @override
  String get saturnCreamColor => 'Saturn-Creme';

  @override
  String get scenarioAsteroidBelt => 'Asteroidengürtel';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Zentraler Stern umgeben von einem Gürtel aus felsigen Asteroiden und Trümmern';

  @override
  String get scenarioBestBinary =>
      'Ideal für: Fortgeschrittene Physikerkundung';

  @override
  String get scenarioBestEarthMoon =>
      'Ideal für: Verständnis des Erde-Mond-Systems';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom => 'Ideal für: Erkundung und Experimente';

  @override
  String get scenarioBestSolar =>
      'Ideal für: Anfänger, Astronomie-Enthusiasten';

  @override
  String get scenarioBestThreeBody =>
      'Ideal für: Mathematische Physik-Enthusiasten';

  @override
  String get scenarioBinaryStars => 'Doppelsterne';

  @override
  String get scenarioBinaryStarsDescription =>
      'Zwei massive Sterne, die sich umkreisen mit zirkumbinären Planeten';

  @override
  String get scenarioCustom => 'Szenario Benutzerdefiniert';

  @override
  String get scenarioCustomDescription =>
      'Benutzerdefinierte Szenario-Beschreibung';

  @override
  String get scenarioEarthMoonSun => 'Erde-Mond-Sonne';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Lehrreiche Simulation unseres vertrauten Erde-Mond-Sonne-Systems';

  @override
  String get scenarioGalaxyFormation => 'Galaxienbildung';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Beobachten Sie, wie sich Materie in Spiralstrukturen um ein zentrales schwarzes Loch organisiert';

  @override
  String get scenarioInformationEditortitle =>
      'Szenario-Informationen-Editor-Titel';

  @override
  String get scenarioLearnBinary =>
      'Lernen: Sternentwicklung, Doppelsternsysteme, extreme Gravitation';

  @override
  String get scenarioLearnEarthMoon =>
      'Lernen: Dreikörperdynamik, Mondmechanik, Gezeitenkräfte';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom =>
      'Lernen: Unbekannte Konfigurationen entdecken, experimentelle Physik';

  @override
  String get scenarioLearnSolar =>
      'Lernen: Planetenbewegung, Orbitalmechanik, vertraute Himmelskörper';

  @override
  String get scenarioLearnThreeBody =>
      'Lernen: Chaostheorie, unvorhersagbare Bewegung, instabile Systeme';

  @override
  String get scenarioNameRequired => 'Szenario-Name erforderlich';

  @override
  String get scenarioNameTooLong => 'Szenario-Name zu lang';

  @override
  String get scenarioPlanetaryRings => 'Planetenringe';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Ringsystemdynamik um einen massiven Planeten wie Saturn';

  @override
  String get scenarioRandom => 'Zufälliges System';

  @override
  String get scenarioRandomDescription =>
      'Zufällig generiertes chaotisches Drei-Körper-System mit unvorhersagbarer Dynamik';

  @override
  String scenarioSaveFailedMessage(String error) {
    return 'Szenario-Speichern fehlgeschlagen';
  }

  @override
  String get scenarioSavedSuccessMessage => 'Szenario erfolgreich gespeichert';

  @override
  String get scenarioSelectorFocused => 'Szenario-Auswahl fokussiert';

  @override
  String get scenarioSolarSystem => 'Sonnensystem';

  @override
  String get scenarioSolarSystemDescription =>
      'Vereinfachte Version unseres Sonnensystems mit inneren und äußeren Planeten';

  @override
  String get scenarioSpecial => 'Spezielles Szenario';

  @override
  String get scenarioSpecialDescription =>
      'Spezielles Szenario für Screenshot-Modus';

  @override
  String get scenariosAvailable => 'Szenarien verfügbar';

  @override
  String get scenariosMenuDescription => 'Verschiedene Szenarien erkunden';

  @override
  String get sceneActive => 'Szene aktiv - Simulation für Screenshot pausiert';

  @override
  String get scenePreset => 'Szenen-Voreinstellung';

  @override
  String get scheduledMaintenanceInProgress => 'Planmäßige Wartung läuft';

  @override
  String screenshotCountdown(int seconds) {
    return 'Screenshot in ${seconds}s';
  }

  @override
  String get screenshotMode => 'Screenshot-Modus';

  @override
  String get screenshotModeSubtitle =>
      'Vorgegebene Szenen für Marketing-Screenshots aktivieren';

  @override
  String get selectAColorForTheCelestialBody =>
      'Farbe für den Himmelskörper auswählen';

  @override
  String get selectNearestTitle => 'Nächstes Auswählen';

  @override
  String get selectObjectToFollowTooltip => 'Objekt zum Verfolgen Auswählen';

  @override
  String get selectScenarioTooltip => 'Szenario Auswählen';

  @override
  String get selectTheTypeOfCelestialBody => 'Typ des Himmelskörpers auswählen';

  @override
  String get selectedStatLabel => 'Ausgewählt';

  @override
  String get showHelpTooltip => 'Hilfe & Ziele';

  @override
  String get showLabelsDescription =>
      'Himmelskörpernamen in der Simulation anzeigen';

  @override
  String get showLabelsTitle => 'Beschriftungen Anzeigen';

  @override
  String get showOrbitalPaths => 'Orbitalbahnen anzeigen';

  @override
  String get showOrbitalPathsDescription =>
      'Vorhergesagte Orbitalbahnen in Szenarien mit stabilen Orbits anzeigen';

  @override
  String get showStatisticsDescription =>
      'Leistungs- und Physikstatistiken anzeigen';

  @override
  String get showStatisticsTitle => 'Statistiken Anzeigen';

  @override
  String get showTrails => 'Spuren anzeigen';

  @override
  String get showTrailsDescription =>
      'Bewegungsspuren hinter Objekten anzeigen';

  @override
  String get showTutorialTooltip => 'Tutorial Anzeigen';

  @override
  String get skipTutorial => 'Überspringen';

  @override
  String get softeningParameter => 'Weichheitsparameter';

  @override
  String get spatialCoordinatesDescription =>
      'Beschreibung der räumlichen Koordinaten';

  @override
  String get statusError => 'Fehler';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get statusRunning => 'Läuft';

  @override
  String get statusStopped => 'Gestoppt';

  @override
  String get stellarColorBlue => 'Blau';

  @override
  String get stellarColorBlueWhite => 'Bläulich-weiß';

  @override
  String get stellarColorOrange => 'Orange';

  @override
  String get stellarColorRed => 'Rot';

  @override
  String get stellarColorWhite => 'Weiß';

  @override
  String get stellarColorYellow => 'Gelb';

  @override
  String get stellarColorYellowWhite => 'Gelblich-weiß';

  @override
  String get stellarTemperatureDescription =>
      'Beschreibung der Sterntemperatur';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => 'Schritte';

  @override
  String get successTitle => 'Erfolg';

  @override
  String get swipeUpToExpand => 'Nach oben wischen zum Erweitern';

  @override
  String get tapPlayPauseButton => 'Wiedergabe-/Pause-Schaltfläche antippen';

  @override
  String get tapResetButton => 'Zurücksetzen-Schaltfläche antippen';

  @override
  String get tapToCenterCamera => 'Antippen, um Kamera zu zentrieren';

  @override
  String get tapToChangeScenario => 'Antippen, um Szenario zu ändern';

  @override
  String get tapToInteractWithSimulation =>
      'Antippen, um mit Simulation zu interagieren';

  @override
  String get tapToOpenSettings => 'Antippen, um Einstellungen zu öffnen';

  @override
  String get tapToSelect => 'Antippen zum Auswählen';

  @override
  String get tapToToggleAutoRotation =>
      'Antippen, um automatische Rotation umzuschalten';

  @override
  String get tapToToggleFullscreen => 'Tippen, um Vollbild ein-/auszuschalten';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return 'Antippen, um Details anzuzeigen und zu bearbeiten-Körper-Körpertyp-Name-mit-Nummer-Utils-Format-Masse-Körpermasse-Editor-Hinweis';
  }

  @override
  String get trackingModeEssential => 'Nur Wesentliches';

  @override
  String get trackingModeEssentialDescription =>
      'Nur kritische Abstürze und Fehler';

  @override
  String get trackingModeFull => 'Vollständige Verfolgung';

  @override
  String get trackingModeFullDescription =>
      'Alle Analysen, Abstürze und Interaktionen';

  @override
  String get trackingModeLimited => 'Begrenzte Verfolgung';

  @override
  String get trackingModeLimitedDescription => 'Nur Benutzerinteraktionen';

  @override
  String get trackingModeNone => 'Keine Verfolgung';

  @override
  String get trackingModeNoneDescription => 'Keine Datensammlung';

  @override
  String get trailColorLabel => 'Spurfarbe';

  @override
  String get trailFadeRate => 'Spuren-Ausblendrate';

  @override
  String get trailLength => 'Spurenlänge';

  @override
  String get typeEditorLabel => 'Typ-Editor-Label';

  @override
  String get uiHapticFeedback => 'UI-Haptisches Feedback';

  @override
  String get unsavedChangesMessage => 'Ungespeicherte Änderungen-Nachricht';

  @override
  String get unsavedChangesTitle => 'Ungespeicherte Änderungen';

  @override
  String get uranusCyanColor => 'Uranus-Cyan';

  @override
  String get useKeyboardShortcutsForControls =>
      'Tastenkürzel für Steuerung verwenden';

  @override
  String get useZoomControls => 'Zoom-Steuerung verwenden';

  @override
  String get venusYellowColor => 'Venus-Gelb';

  @override
  String get versionLabel => 'Version';

  @override
  String get versionStatusCurrent => 'Aktuell';

  @override
  String get versionStatusOutdated => 'Veraltet';

  @override
  String get vibrationEnabled => 'Vibration aktiviert';

  @override
  String get vibrationThrottle => 'Vibrationsdrosselung';

  @override
  String get warmTrails => '🔥 Warm';

  @override
  String get websiteLabel => 'Webseite';

  @override
  String get whatToDoDescription =>
      'Graviton ist ein Physik-Spielplatz, wo Sie können:\n\n🪐 Realistische Orbitalmechanik erkunden\n🌟 Sternentwicklung und Kollisionen beobachten\n🎯 Über Gravitationskräfte lernen\n🎮 Mit verschiedenen Szenarien experimentieren\n📚 Himmelsdynamik verstehen\n🔄 Unendliche zufällige Konfigurationen erstellen';

  @override
  String get whatToDoTitle => 'Was in Graviton zu Tun';

  @override
  String get whiteColor => 'Weiß';

  @override
  String get xCoordinateEditorhint => 'X-Koordinate eingeben-Editor-Hinweis';

  @override
  String get xCoordinateLabel => 'X-Koordinaten-Label';

  @override
  String get xVelocityEditorhint => 'X-Geschwindigkeit eingeben-Editor-Hinweis';

  @override
  String get yCoordinateEditorhint => 'Y-Koordinate eingeben-Editor-Hinweis';

  @override
  String get yCoordinateLabel => 'Y-Koordinaten-Label';

  @override
  String get yVelocityEditorhint => 'Y-Geschwindigkeit eingeben-Editor-Hinweis';

  @override
  String get yawLabel => 'Gieren';

  @override
  String get yellowColor => 'Gelb';

  @override
  String get zCoordinateEditorhint => 'Z-Koordinate eingeben-Editor-Hinweis';

  @override
  String get zCoordinateLabel => 'Z-Koordinaten-Label';

  @override
  String get zVelocityEditorhint => 'Z-Geschwindigkeit eingeben-Editor-Hinweis';

  @override
  String orbitalEventCloseApproach(String distance) {
    return 'Naher Vorbeiflug: $distance Einheiten';
  }

  @override
  String get accessibilityBodiesCombined =>
      'Die kombinierte Masse erzeugt einen neuen Himmelskörper';

  @override
  String get accessibilityBodiesInMotion => 'Himmelskörper bewegen sich jetzt';

  @override
  String get accessibilityBodiesStopped =>
      'Alle Himmelskörper haben aufgehört sich zu bewegen';

  @override
  String get accessibilityBodiesResumed => 'Himmelskörper bewegen sich wieder';

  @override
  String get accessibilityBodiesReset =>
      'Alle Himmelskörper wurden zurückgesetzt';

  @override
  String get accessibilityNewScenarioLoaded =>
      'Neues Szenario mit frischen Himmelskörpern geladen';

  @override
  String get accessibilityNewParametersLoaded =>
      'Neue Himmelskörper und Physikparameter geladen';

  @override
  String get scenarioTabPresets => 'Vorlagen';

  @override
  String get scenarioTabCustom => 'Benutzerdefiniert';

  @override
  String get savedScenariosTitle => 'Gespeicherte Szenarien';

  @override
  String get experimentsTitle => 'Experimente';

  @override
  String get experimentsSubtitle => 'Interessante Physikkonzepte erkunden';

  @override
  String customScenarioBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Himmelskörper',
      one: '1 Himmelskörper',
    );
    return '$_temp0';
  }

  @override
  String get customScenarioCreatedToday => 'Heute erstellt';

  @override
  String get customScenarioCreatedYesterday => 'Gestern erstellt';

  @override
  String customScenarioCreatedDaysAgo(int count, Object days) {
    return 'Vor $days Tagen erstellt';
  }

  @override
  String customScenarioCreatedWeeksAgo(int count, Object weeks) {
    return 'Vor $weeks Wochen erstellt';
  }

  @override
  String customScenarioCreatedMonthsAgo(int count, Object months) {
    return 'Vor $months Monaten erstellt';
  }

  @override
  String get customScenarioCreatedUnknown => 'Erstellungsdatum unbekannt';

  @override
  String get orbitalPlacementEditor => 'Orbitalplatzierung';

  @override
  String get placeInOrbitButton => 'In Umlaufbahn platzieren';

  @override
  String get centralBodySelector => 'Zentralkörper';

  @override
  String get orbitRadiusEditor => 'Bahnradius';

  @override
  String get orbitPhaseEditor => 'Bahnphase';

  @override
  String get orbitInclinationEditor => 'Neigung';

  @override
  String get circularOrbitOption => 'Kreisbahn';

  @override
  String get ellipticalOrbitOption => 'Elliptische Bahn';

  @override
  String orbitalPeriodDisplay(String period) {
    return 'Periode: $period';
  }

  @override
  String get noAvailableCentralBodies =>
      'Keine anderen Körper für Orbitalplatzierung verfügbar';

  @override
  String get orbitalPlacementDescription =>
      'Diesen Körper so konfigurieren, dass er mit realistischer Physik um einen anderen Himmelskörper kreist';

  @override
  String get orbitalPlacementActiveDescription =>
      'Orbitalplatzierung ist aktiv. Position und Geschwindigkeit werden automatisch basierend auf den Bahnparametern unten berechnet.';

  @override
  String get showGravitationalFieldVisualization =>
      'Gravitationsfeld-Visualisierung für diesen Körper anzeigen';

  @override
  String get cancelOrbitalPlacement => 'Orbitalplatzierung abbrechen';

  @override
  String get makeStable => 'Stabilisieren';

  @override
  String get orbitalWarningMassiveBody =>
      '⚠️ Warnung: Der umkreisende Körper ist sehr massereich im Verhältnis zum Zentralkörper. Dies kann instabile Bahnen verursachen oder die Körper können umeinander kreisen.';

  @override
  String get orbitalTipSignificantMass =>
      '💡 Tipp: Das ist ein bedeutendes Massenverhältnis. Erwägen Sie, die Orbitaldistanz für Stabilität zu erhöhen.';

  @override
  String get orbitalWarningCloseOrbit =>
      '⚠️ Warnung: Sehr nahe Umlaufbahn. Kollisions- oder Gezeitenstörungsrisiko.';

  @override
  String get orbitalTipDistantOrbit =>
      '💡 Tipp: Entfernte Umlaufbahn. Gravitationseinfluss anderer Körper kann diese Bahn stören.';

  @override
  String get orbitalGoodConfiguration =>
      '✅ Gute Bahnkonfiguration für ein stabiles System.';

  @override
  String get orbitalError => 'Fehler';

  @override
  String get orbitalConfigurationWarning =>
      'Diese Bahnkonfiguration kann zu Kollisionen oder Auswürfen führen. Erwägen Sie die Verwendung des \"Stabilisieren\" Buttons.';

  @override
  String get defaultBodyName => 'Himmelskörper';

  @override
  String get orbitalPeriodLabel => 'Umlaufperiode';

  @override
  String get orbitIsStable => 'Umlaufbahn ist Stabil';

  @override
  String get orbitMayBeUnstable => 'Umlaufbahn Könnte Instabil Sein';

  @override
  String bodyTypeGeneric(String bodyType) {
    return '$bodyType Körper';
  }

  @override
  String orbitalRadiusIncreasedFeedback(String amount) {
    return 'um $amount Einheiten erhöht';
  }

  @override
  String orbitalRadiusDecreasedFeedback(String amount) {
    return 'um $amount Einheiten verringert';
  }

  @override
  String get orbitalRadiusFineTunedFeedback => 'fein abgestimmt';

  @override
  String orbitStabilizedMessage(String changeDescription, String finalRadius) {
    return 'Umlaufbahn stabilisiert! Radius $changeDescription auf $finalRadius Einheiten. Phase und Neigung für Stabilität zurückgesetzt.';
  }

  @override
  String get experimentBinaryPulsarName => 'Doppelpulsar';

  @override
  String get experimentBinaryPulsarDescription =>
      'Zwei Neutronensterne spiralen durch Gravitationswellen nach innen';

  @override
  String get experimentBinaryPulsarDuration => '100 Jahre';

  @override
  String get binaryPulsarPulsarA => 'Pulsar A';

  @override
  String get binaryPulsarNeutronStarB => 'Neutronenstern B';

  @override
  String get binaryPulsarScenarioDescription =>
      'Dieses Szenario demonstriert: extreme Gravitationsfelder, relativistische Effekte, Gravitationswellenemission und orbitalen Zerfall. Die Neutronensterne werden im Laufe der Zeit langsam nach innen spiralen und schließlich in einer katastrophalen Kollision verschmelzen, die Gravitationswellen erzeugt.';

  @override
  String get binaryPulsarAuthor => 'Graviton Physik-Experimente';

  @override
  String get binaryPulsarEducationalFocus =>
      'Relativität und Gravitationswellen';

  @override
  String get experimentTrojanAsteroidsName => 'Trojanische Asteroiden';

  @override
  String get experimentTrojanAsteroidsDescription =>
      'Stabile Punkte in Jupiters Umlaufbahn, wo sich Asteroiden ansammeln';

  @override
  String get experimentTrojanAsteroidsDuration => '50 Jahre';

  @override
  String get trojanAsteroidsSun => 'Sonne';

  @override
  String get trojanAsteroidsJupiter => 'Jupiter';

  @override
  String trojanAsteroidsL4Name(int number) {
    return 'L4 Trojan $number';
  }

  @override
  String trojanAsteroidsL5Name(int number) {
    return 'L5 Trojan $number';
  }

  @override
  String get trojanAsteroidsScenarioDescription =>
      'Dieses Szenario demonstriert: Lagrange-Punkte, stabile Orbitalmechanik, Dreikörperdynamik und gravitationales Gleichgewicht. Die trojanischen Asteroiden verbleiben in stabilen Positionen 60° vor und hinter Jupiter, gefangen im gravitationalen Gleichgewicht.';

  @override
  String get trojanAsteroidsEducationalFocus =>
      'Lagrange-Punkte und orbitale Stabilität';

  @override
  String get experimentDoubleStarEclipseName => 'Doppelstern-Finsternis';

  @override
  String get experimentDoubleStarEclipseDescription =>
      'Doppelsternsystem, in dem ein Stern regelmäßig den anderen verdeckt';

  @override
  String get experimentDoubleStarEclipseDuration => '30 Tage';

  @override
  String get experimentRoguePlanetName => 'Vagabundierender Planet';

  @override
  String get experimentRoguePlanetDescription =>
      'Ein aus seinem System ausgestoßener Planet trifft auf ein neues Sonnensystem';

  @override
  String get experimentRoguePlanetDuration => '500 Jahre';

  @override
  String get experimentGravitationalSlingshotName => 'Gravitationsschleuder';

  @override
  String get experimentGravitationalSlingshotDescription =>
      'Ein Raumfahrzeug nutzt Jupiters Mond Io, um Geschwindigkeit zu gewinnen und Europa zu erreichen';

  @override
  String get experimentGravitationalSlingshotDuration => '2 Jahre';

  @override
  String get experimentDifficultyAdvanced => 'fortgeschritten';

  @override
  String get experimentDifficultyIntermediate => 'mittelstufe';

  @override
  String get experimentDifficultyBeginner => 'Anfänger';

  @override
  String experimentComingSoon(String scenarioName) {
    return 'Experimentelles Szenario \"$scenarioName\" - Bald verfügbar!';
  }

  @override
  String get unknownValue => 'Unbekannt';

  @override
  String get bodyPrimaryStar => 'Hauptstern';

  @override
  String get bodySecondaryStar => 'Nebenstern';

  @override
  String get bodyInnerRockyPlanet => 'Innerer Gesteinsplanet';

  @override
  String get bodyHabitablePlanet => 'Bewohnbarer Planet';

  @override
  String get bodyGasGiant => 'Gasriese';

  @override
  String get bodyIceGiant => 'Eisriese';

  @override
  String get bodyRoguePlanet => 'Vagabundierender Planet';

  @override
  String get authorGravitonPhysicsTeam => 'Graviton-Physikteam';

  @override
  String get doubleStarEclipseScenarioDescription =>
      'Beobachten Sie, wie zwei Sterne in einem engen Doppelsternsystem umeinander kreisen. Sehen Sie zu, wie der kleinere Sekundärstern regelmäßig vor dem größeren Hauptstern vorbeizieht und periodische Finsternisse verursacht. Dies demonstriert stellare Photometrie, binäre Orbitalmechanik und wie Astronomen mit ähnlichen Transitmethoden Exoplaneten entdecken.';

  @override
  String get doubleStarEclipseEducationalFocus =>
      'Doppelsterne, Finsternisse, stellare Photometrie';

  @override
  String get roguePlanetScenarioDescription =>
      'Ein stabiles Sonnensystem mit gut verteilten Planetenbahnen begegnet einem massiven vagabundierenden Planeten, der sich aus dem interstellaren Raum nähert. Beobachten Sie, wie die Schwerkraft des Eindringlings das empfindliche Orbitalgleichgewicht stört und möglicherweise Planeten ausstößt oder chaotische Gravitationswechselwirkungen erzeugt. Dieses Szenario demonstriert die Dynamik von Planetensystemen, Gravitationsschleudereffekte und wie vagabundierende Planeten ganze Sonnensysteme umgestalten können.';

  @override
  String get roguePlanetEducationalFocus =>
      'Vagabundierende Planeten, Gravitationsbegegnungen, orbitale Störung';

  @override
  String get simulationInfoTitle => 'Simulations-Info';

  @override
  String get scenarioInfoTitle => 'Szenario-Info';

  @override
  String get scenarioNameLabel => 'Szenario-Name';

  @override
  String get bodyStatisticsTitle => 'Körper-Statistiken';

  @override
  String get totalBodiesLabel => 'Gesamtkörper';

  @override
  String get starsLabel => 'Sterne';

  @override
  String get planetsLabel => 'Planeten';

  @override
  String get asteroidsLabel => 'Asteroiden';

  @override
  String get blackHolesLabel => 'Schwarze Löcher';

  @override
  String get totalMassLabel => 'Gesamtmasse';

  @override
  String get habitableWorldsLabel => 'Bewohnbare Welten';

  @override
  String get physicsInfoTitle => 'Physik-Info';

  @override
  String get timeScaleLabel => 'Zeitskala';

  @override
  String get gravitationalConstantLabel => 'Gravitationskonstante';

  @override
  String get softeningParameterLabel => 'Glättungsparameter';

  @override
  String get collisionRadiusLabel => 'Kollisionsradius';

  @override
  String get scenarioThreeBodyClassic => 'Klassisches Drei-Körper-Problem';

  @override
  String get scenarioThreeBodyClassicDescription =>
      'Das klassische Drei-Körper-Problem mit chaotischer Dynamik';

  @override
  String get scenarioCollisionDemo => 'Kollisions-Demo';

  @override
  String get scenarioCollisionDemoDescription =>
      'Demonstration von Kollisionen zwischen Himmelskörpern';

  @override
  String get scenarioDeepSpace => 'Tiefraum';

  @override
  String get scenarioDeepSpaceDescription => 'Zufällige Objekte im tiefen Raum';

  @override
  String get systemEnergyLabel => 'Systemenergie';

  @override
  String get kineticEnergyLabel => 'Kinetische Energie';

  @override
  String get potentialEnergyLabel => 'Potentielle Energie';

  @override
  String get angularMomentumLabel => 'Drehimpuls';

  @override
  String get centerOfMassLabel => 'Massenschwerpunkt';

  @override
  String get velocityRangeLabel => 'Geschwindigkeitsbereich';

  @override
  String get averageVelocityLabel => 'Durchschnittsgeschwindigkeit';

  @override
  String get temperatureRangeLabel => 'Temperaturbereich';

  @override
  String get systemMomentumLabel => 'Systemimpuls';

  @override
  String get energyDynamicsTitle => 'Energie & Dynamik';

  @override
  String get orbitalMechanicsTitle => 'Orbitalmechanik';

  @override
  String get celestialBodiesTitle => 'Himmelskörper';

  @override
  String get bodyNameLabel => 'Körpername';

  @override
  String get bodyMassLabel => 'Körpermasse';

  @override
  String get bodyRadiusLabel => 'Körperradius';

  @override
  String get bodyVelocityLabel => 'Körpergeschwindigkeit';

  @override
  String get bodyTemperatureLabel => 'Körpertemperatur';

  @override
  String get bodyLuminosityLabel => 'Körperleuchtkraft';

  @override
  String get bodyPositionLabel => 'Körperposition';

  @override
  String get bodyTypeLabel => 'Körpertyp';

  @override
  String get bodyHabitabilityLabel => 'Körperbewohnbarkeit';

  @override
  String get bodyKineticEnergyLabel => 'Körper Kinetische Energie';

  @override
  String get bodyEscapeVelocityLabel => 'Fluchtgeschwindigkeit';

  @override
  String get bodyDistanceFromCenterLabel => 'Abstand zum Zentrum';

  @override
  String get bodyOrbitalPeriodLabel => 'Umlaufperiode';

  @override
  String get notApplicableValue => 'n. z.';

  @override
  String get habitableStatus => 'Bewohnbar';

  @override
  String get unknownHabitabilityStatus => 'Unbekannt';

  @override
  String get tooHotStatus => 'Zu heiß';

  @override
  String get tooColdStatus => 'Zu kalt';

  @override
  String get noAtmosphereStatus => 'Keine Atmosphäre';

  @override
  String get selectBody => 'Körper auswählen';

  @override
  String get noBodiesAvailable => 'Keine Körper verfügbar';

  @override
  String get share => 'Teilen';

  @override
  String get shareSimulation => 'Simulation teilen';

  @override
  String get shareImage => 'Bild teilen';

  @override
  String get shareImageDescription => 'Aktuelle Ansicht aufnehmen und teilen';

  @override
  String get shareState => 'Zustand teilen';

  @override
  String get shareStateDescription =>
      'Simulationsdaten als importierbare Datei exportieren';

  @override
  String get shareSuccess => 'Erfolgreich geteilt';

  @override
  String get shareFailed => 'Teilen fehlgeschlagen';

  @override
  String get shareImageError =>
      'Bild kann nicht erfasst werden. Bitte versuchen Sie es erneut.';

  @override
  String get shareSubject => 'Graviton-Simulation';

  @override
  String get shareSnapshotSubject => 'Graviton-Simulationsschnappschuss';

  @override
  String get shareText => 'Sehen Sie sich diese Gravitationssimulation an!';

  @override
  String get importScenario => 'Szenario importieren';

  @override
  String get importScenarioDescription => 'Szenario aus einer JSON-Datei laden';

  @override
  String get importSuccess => 'Szenario erfolgreich importiert';

  @override
  String get importFailed => 'Importieren des Szenarios fehlgeschlagen';

  @override
  String get importInvalidFile =>
      'Ungültiges Dateiformat. Bitte wählen Sie eine gültige JSON-Datei aus.';

  @override
  String get importFileNotFound =>
      'Datei nicht gefunden. Bitte versuchen Sie es erneut.';

  @override
  String get importCancelled => 'Import abgebrochen';

  @override
  String get accountManagementTitle => 'Konto';

  @override
  String get accountButtonTooltip => 'Konto & Profil';

  @override
  String get signInPromptTitle => 'In Ihr Konto anmelden';

  @override
  String get signInPromptMessage =>
      'Erstellen Sie ein Konto oder melden Sie sich an, um Ihre Daten und Einstellungen über Geräte hinweg zu synchronisieren.';

  @override
  String get signInButton => 'Anmelden';

  @override
  String get signOutButton => 'Abmelden';

  @override
  String get resetSessionButton => 'Sitzung zurücksetzen';

  @override
  String get signOutSuccess => 'Erfolgreich abgemeldet';

  @override
  String get operationTimeout =>
      'Die Operation ist abgelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get operationFailed =>
      'Die Operation ist fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get couldNotOpenLink =>
      'Link konnte nicht geöffnet werden. Bitte versuchen Sie es erneut.';

  @override
  String get pleaseWaitBeforeRetrying =>
      'Bitte warten Sie einen Moment, bevor Sie es erneut versuchen.';

  @override
  String rateLimitWithCooldown(int seconds) {
    return 'Bitte warten Sie $seconds Sekunden, bevor Sie es erneut versuchen.';
  }

  @override
  String get networkError =>
      'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get continueAsGuestButton => 'Als Gast fortfahren';

  @override
  String get signInAnonymousSuccess => 'Als Gast angemeldet';

  @override
  String get anonymousUserLabel => 'Gastbenutzer';

  @override
  String get guestAccountLabel => 'Gastkonto';

  @override
  String get authenticatedLabel => 'Konto';

  @override
  String get changeAvatarTooltip => 'Avatar ändern';

  @override
  String get editDisplayNameTooltip => 'Name bearbeiten';

  @override
  String get accountActionsSection => 'Kontoaktionen';

  @override
  String get upgradeAccountTitle => 'Auf Vollkonto upgraden';

  @override
  String get upgradeAccountDescription =>
      'Speichern Sie Ihre Daten und greifen Sie von jedem Gerät darauf zu';

  @override
  String get accountManagementSection => 'Account Management';

  @override
  String get dangerZoneSection => 'Kontoverwaltung';

  @override
  String get deleteAccountButton => 'Konto löschen';

  @override
  String get avatarChangedSuccess => 'Avatar erfolgreich aktualisiert';

  @override
  String get avatarChangedError => 'Fehler beim Aktualisieren des Avatars';

  @override
  String get accountMenuDescription => 'Verwalten Sie Ihr Konto und Profil';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get createAccountButton => 'Konto erstellen';

  @override
  String get pleaseEnterEmail => 'Bitte geben Sie Ihre E-Mail-Adresse ein';

  @override
  String get pleaseEnterValidEmail =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get pleaseEnterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get passwordMinLength =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto? Anmelden';

  @override
  String get needAccount => 'Benötigen Sie ein Konto? Erstellen Sie eines';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get continueWithApple => 'Mit Apple fortfahren';

  @override
  String get selectAvatarTitle => 'Avatar auswählen';

  @override
  String get editAccountInformationTitle => 'Anzeigename bearbeiten';

  @override
  String get displayNameLabel => 'Anzeigename';

  @override
  String get pleaseEnterDisplayName => 'Bitte geben Sie einen Anzeigenamen ein';

  @override
  String get displayNameMinLength =>
      'Der Name muss mindestens 2 Zeichen lang sein';

  @override
  String get deleteAccountTitle => 'Konto löschen';

  @override
  String get deleteAccountWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountMessage =>
      'Das Löschen Ihres Kontos entfernt dauerhaft alle damit verbundenen Daten.';

  @override
  String get deleteAccountItem1 => 'Ihr Profil und Avatar';

  @override
  String get deleteAccountItem2 => 'Alle gespeicherten Einstellungen';

  @override
  String get deleteAccountItem3 =>
      'Benutzerdefinierte Szenarien und Einstellungen';

  @override
  String get deleteAccountItem4 => 'Kontoanmeldung';

  @override
  String get deleteAccountPasswordPrompt =>
      'Bitte geben Sie Ihr Passwort zur Bestätigung ein:';

  @override
  String get orDivider => 'OR';

  @override
  String get displayNameHint => 'Enter your name (optional)';

  @override
  String get emailHint => 'Your email address';

  @override
  String get passwordHint => 'Your password';

  @override
  String get alreadyHaveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get needAccountCreateOne => 'Don\'t have an account? Create one';

  @override
  String get useGoogleProfilePhoto => 'Use Google Profile Photo';

  @override
  String get customAvatars => 'Custom Avatars';

  @override
  String get saveAvatar => 'Save Avatar';

  @override
  String get displayNameFieldLabel => 'Display Name';

  @override
  String get displayNameFieldHint => 'Enter your display name';

  @override
  String get saveAccountInformation => 'Save Account Information';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get defaultUserName => 'User';

  @override
  String get googleSignInError =>
      'Google sign-in was canceled or failed. Please try again.';

  @override
  String get displayNameUpdated => 'Display name updated';

  @override
  String get displayNameUpdateFailed => 'Failed to update display name';

  @override
  String get sessionResetSuccess => 'Session reset successfully';

  @override
  String get accountDeletedSuccess => 'Account deleted successfully';

  @override
  String get errorUserNotFound => 'No account found with this email address.';

  @override
  String get errorWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get errorInvalidEmail => 'Invalid email address format.';

  @override
  String get errorUserDisabled => 'This account has been disabled.';

  @override
  String get errorEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get errorWeakPassword =>
      'Password is too weak. Please use a stronger password.';

  @override
  String get errorOperationNotAllowed => 'This sign-in method is not enabled.';

  @override
  String get errorRequiresRecentLogin =>
      'Please sign in again to perform this action.';

  @override
  String get errorNetworkFailed =>
      'Network error. Please check your connection.';

  @override
  String errorUnknown(String message) {
    return 'An error occurred: $message';
  }

  @override
  String get exceptionGoogleSignInNotInitialized =>
      'Google Sign-In nicht initialisiert';

  @override
  String get exceptionGoogleSignInTimeout =>
      'Google-Anmeldung hat Zeitüberschreitung';

  @override
  String get exceptionAppleSignInPlatform =>
      'Apple Sign-In ist nur auf Apple-Plattformen verfügbar';

  @override
  String get exceptionNoAnonymousUser =>
      'Kein anonymer Benutzer zum Verknüpfen';

  @override
  String get exceptionNoUserSignedIn => 'Kein Benutzer angemeldet';

  @override
  String get firebaseErrorUserNotFound =>
      'Kein Konto mit dieser E-Mail-Adresse gefunden.';

  @override
  String get firebaseErrorWrongPassword =>
      'Falsches Passwort. Bitte versuchen Sie es erneut.';

  @override
  String get firebaseErrorInvalidEmail => 'Ungültiges E-Mail-Adressformat.';

  @override
  String get firebaseErrorUserDisabled => 'Dieses Konto wurde deaktiviert.';

  @override
  String get firebaseErrorEmailInUse =>
      'Mit dieser E-Mail-Adresse existiert bereits ein Konto.';

  @override
  String get firebaseErrorWeakPassword =>
      'Passwort ist zu schwach. Bitte verwenden Sie ein stärkeres Passwort.';

  @override
  String get firebaseErrorOperationNotAllowed =>
      'Diese Anmeldemethode ist nicht aktiviert.';

  @override
  String get firebaseErrorRequiresRecentLogin =>
      'Bitte melden Sie sich erneut an, um diese Aktion durchzuführen.';

  @override
  String get firebaseErrorNetworkFailed =>
      'Netzwerkfehler. Bitte überprüfen Sie Ihre Verbindung.';

  @override
  String firebaseErrorDefault(String message) {
    return 'Ein Fehler ist aufgetreten: $message';
  }

  @override
  String get emailVerificationSent =>
      'Bestätigungs-E-Mail gesendet! Bitte überprüfen Sie Ihren Posteingang.';

  @override
  String get emailVerificationResent =>
      'Bestätigungs-E-Mail erfolgreich erneut gesendet.';

  @override
  String get emailNotVerified => 'E-Mail nicht bestätigt';

  @override
  String get emailVerified => 'E-Mail bestätigt';

  @override
  String get verifyEmailAddress => 'E-Mail-Adresse bestätigen';

  @override
  String get verifyEmailMessage =>
      'Bitte bestätigen Sie Ihre E-Mail-Adresse, um auf alle Funktionen zuzugreifen. Überprüfen Sie Ihren Posteingang auf den Bestätigungslink.';

  @override
  String get sendVerificationEmail => 'Bestätigungs-E-Mail senden';

  @override
  String get resendVerificationEmail => 'Bestätigungs-E-Mail erneut senden';

  @override
  String get checkVerificationStatus => 'Bestätigungsstatus prüfen';

  @override
  String get emailVerificationPending => 'E-Mail-Bestätigung ausstehend';

  @override
  String verificationEmailCooldown(int seconds) {
    return 'Bitte warten Sie $seconds Sekunden, bevor Sie eine weitere Bestätigungs-E-Mail anfordern.';
  }

  @override
  String get termsAndPrivacy => 'Geschäftsbedingungen & Datenschutz';

  @override
  String get acceptTermsAndPrivacy =>
      'Ich akzeptiere die Nutzungsbedingungen und Datenschutzerklärung';

  @override
  String get mustAcceptTerms =>
      'Sie müssen die Nutzungsbedingungen und Datenschutzerklärung akzeptieren, um fortzufahren.';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get viewTermsOfService => 'Nutzungsbedingungen anzeigen';

  @override
  String get viewPrivacyPolicy => 'Datenschutzerklärung anzeigen';

  @override
  String termsLastUpdated(String date) {
    return 'Zuletzt aktualisiert: $date';
  }

  @override
  String privacyLastUpdated(String date) {
    return 'Zuletzt aktualisiert: $date';
  }

  @override
  String get ageRequirement =>
      'Sie müssen mindestens 13 Jahre alt sein, um ein Konto zu erstellen.';

  @override
  String get confirmAge =>
      'Ich bestätige, dass ich mindestens 13 Jahre alt bin';

  @override
  String get exceptionEmailVerificationFailed =>
      'exceptionEmailVerificationFailed';

  @override
  String get exceptionEmailVerificationCooldown =>
      'exceptionEmailVerificationCooldown';

  @override
  String get exceptionTermsNotAccepted => 'exceptionTermsNotAccepted';
}
