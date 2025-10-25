// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => 'Wiedergabe';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resetButton => 'Zurücksetzen';

  @override
  String get speedLabel => 'Geschwindigkeit';

  @override
  String get trailsLabel => 'Spuren';

  @override
  String get warmTrails => '🔥 Warm';

  @override
  String get coolTrails => '❄️ Kalt';

  @override
  String get toggleStatsTooltip => 'Statistiken umschalten';

  @override
  String get toggleLabelsTooltip => 'Körperlabels umschalten';

  @override
  String get showLabelsDescription =>
      'Himmelskörpernamen in der Simulation anzeigen';

  @override
  String get offScreenIndicatorsTitle => 'Bildschirm-Außen-Indikatoren';

  @override
  String get offScreenIndicatorsDescription =>
      'Pfeile zu Objekten außerhalb des sichtbaren Bereichs anzeigen';

  @override
  String get autoRotateTooltip => 'Auto-Rotation';

  @override
  String get centerViewTooltip => 'Ansicht zentrieren';

  @override
  String get focusOnNearestTooltip => 'Nächsten Körper Fokussieren';

  @override
  String get followObjectTooltip => 'Ausgewähltes Objekt Verfolgen';

  @override
  String get stopFollowingTooltip => 'Objektverfolgung Stoppen';

  @override
  String get selectObjectToFollowTooltip => 'Objekt zum Verfolgen Auswählen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get selectScenarioTooltip => 'Szenario Auswählen';

  @override
  String get moreOptionsTooltip => 'Weitere Optionen';

  @override
  String get physicsSettingsTitle => 'Physik-Einstellungen';

  @override
  String get physicsSettingsDescription => 'Simulationsparameter';

  @override
  String get physicsSection => 'Physik';

  @override
  String get gravitationalConstant => 'Gravitationskonstante';

  @override
  String get softeningParameter => 'Weichheitsparameter';

  @override
  String get simulationSpeed => 'Simulationsgeschwindigkeit';

  @override
  String get collisionsSection => 'Kollisionen';

  @override
  String get collisionSensitivity => 'Kollisionsempfindlichkeit';

  @override
  String get trailsSection => 'Spuren';

  @override
  String get trailLength => 'Spurenlänge';

  @override
  String get trailFadeRate => 'Spuren-Ausblendrate';

  @override
  String get hapticsSection => 'Haptik';

  @override
  String get vibrationEnabled => 'Vibration aktiviert';

  @override
  String get hapticFeedbackCollisions => 'Haptisches Feedback bei Kollisionen';

  @override
  String get vibrationThrottle => 'Vibrationsdrosselung';

  @override
  String get scenariosMenuDescription => 'Verschiedene Szenarien erkunden';

  @override
  String get settingsMenuDescription => 'Visuelle & Verhaltensoptionen';

  @override
  String get helpMenuDescription => 'Tutorial & Ziele';

  @override
  String get showTrails => 'Spuren anzeigen';

  @override
  String get showTrailsDescription =>
      'Bewegungsspuren hinter Objekten anzeigen';

  @override
  String get showOrbitalPaths => 'Orbitalbahnen anzeigen';

  @override
  String get showOrbitalPathsDescription =>
      'Vorhergesagte Orbitalbahnen in Szenarien mit stabilen Orbits anzeigen';

  @override
  String get dualOrbitalPaths => 'Doppelte Orbitalbahnen';

  @override
  String get dualOrbitalPathsDescription =>
      'Sowohl ideale kreisförmige als auch tatsächliche elliptische Orbitalbahnen anzeigen';

  @override
  String get trailColorLabel => 'Spurenfarbe';

  @override
  String get closeButton => 'Schließen';

  @override
  String get simulationStats => 'Simulationsstatistiken';

  @override
  String get stepsLabel => 'Schritte';

  @override
  String get timeLabel => 'Zeit';

  @override
  String get earthYearsLabel => 'Erdenjahre';

  @override
  String get speedStatsLabel => 'Geschwindigkeit';

  @override
  String get bodiesLabel => 'Körper';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusRunning => 'Läuft';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get cameraLabel => 'Kamera';

  @override
  String get distanceLabel => 'Entfernung';

  @override
  String get autoRotateLabel => 'Auto-Rotation';

  @override
  String get autoRotateOn => 'Ein';

  @override
  String get autoRotateOff => 'Aus';

  @override
  String get cameraControlsLabel => 'Kamera-Steuerung';

  @override
  String get invertPitchControlsLabel => 'Nickbewegung Umkehren';

  @override
  String get invertPitchControlsDescription => 'Auf/Ab-Ziehrichtung umkehren';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String timeFormatted(String time) {
    return '${time}s';
  }

  @override
  String earthYearsFormatted(String years) {
    return '$years Jahre';
  }

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String bodiesCount(int count) {
    return '$count';
  }

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get scenarioSelectionTitle => 'Szenario auswählen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get bodies => 'körper';

  @override
  String get scenarioRandom => 'Zufälliges System';

  @override
  String get scenarioRandomDescription =>
      'Zufällig generiertes chaotisches Drei-Körper-System mit unvorhersagbarer Dynamik';

  @override
  String get scenarioEarthMoonSun => 'Erde-Mond-Sonne';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Lehrreiche Simulation unseres vertrauten Erde-Mond-Sonne-Systems';

  @override
  String get scenarioBinaryStars => 'Doppelsterne';

  @override
  String get scenarioBinaryStarsDescription =>
      'Zwei massive Sterne, die sich umkreisen mit zirkumbinären Planeten';

  @override
  String get scenarioAsteroidBelt => 'Asteroidengürtel';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Zentraler Stern umgeben von einem Gürtel aus felsigen Asteroiden und Trümmern';

  @override
  String get scenarioGalaxyFormation => 'Galaxienbildung';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Beobachten Sie, wie sich Materie in Spiralstrukturen um ein zentrales schwarzes Loch organisiert';

  @override
  String get scenarioPlanetaryRings => 'Planetenringe';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Ringsystemdynamik um einen massiven Planeten wie Saturn';

  @override
  String get scenarioSolarSystem => 'Sonnensystem';

  @override
  String get scenarioSolarSystemDescription =>
      'Vereinfachte Version unseres Sonnensystems mit inneren und äußeren Planeten';

  @override
  String get habitabilityLabel => 'Bewohnbarkeit';

  @override
  String get habitableZonesLabel => 'Bewohnbare Zonen';

  @override
  String get habitabilityIndicatorsLabel => 'Planetenstatus';

  @override
  String get habitabilityHabitable => 'Bewohnbar';

  @override
  String get habitabilityTooHot => 'Zu Heiß';

  @override
  String get habitabilityTooCold => 'Zu Kalt';

  @override
  String get habitabilityUnknown => 'Unbekannt';

  @override
  String get temperatureFrozen => 'Gefroren';

  @override
  String get temperatureCold => 'Kalt';

  @override
  String get temperatureModerate => 'Gemäßigt';

  @override
  String get temperatureHot => 'Heiß';

  @override
  String get temperatureScorching => 'Glühend';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get toggleHabitableZonesTooltip => 'Bewohnbare Zonen Umschalten';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Planeten-Bewohnbarkeitsstatus Umschalten';

  @override
  String get habitableZonesDescription =>
      'Farbige Zonen um Sterne anzeigen, die bewohnbare Regionen kennzeichnen';

  @override
  String get habitabilityIndicatorsDescription =>
      'Farbkodierte Statusringe um Planeten basierend auf ihrer Bewohnbarkeit anzeigen';

  @override
  String get aboutDialogTitle => 'Über';

  @override
  String get appDescription =>
      'Eine Physiksimulation zur Erforschung der Gravitationsdynamik und Orbitalmechanik. Erleben Sie die Schönheit und Komplexität himmlischer Bewegung durch interaktive 3D-Visualisierung.';

  @override
  String get authorLabel => 'Autor';

  @override
  String get websiteLabel => 'Webseite';

  @override
  String get aboutButtonTooltip => 'Über';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => 'Version';

  @override
  String get loadingVersion => 'Version wird geladen...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => 'Gravitationsfelder';

  @override
  String get gravityWellsDescription =>
      'Gravitationsfeldstärke um Objekte anzeigen';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageDescription => 'App-Sprache ändern';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageChinese => '中文';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get bodyAlpha => 'Alpha';

  @override
  String get bodyBeta => 'Beta';

  @override
  String get bodyGamma => 'Gamma';

  @override
  String get bodyRockyPlanet => 'Felsplanet';

  @override
  String get bodyEarthLike => 'Erdähnlich';

  @override
  String get bodySuperEarth => 'Supererde';

  @override
  String get bodySun => 'Sonne';

  @override
  String get bodyPropertiesTitle => 'Körpereigenschaften';

  @override
  String get bodyPropertiesName => 'Name';

  @override
  String get bodyPropertiesNameHint => 'Körpername eingeben';

  @override
  String get bodyPropertiesType => 'Körpertyp';

  @override
  String get bodyPropertiesColor => 'Farbe';

  @override
  String get bodyPropertiesMass => 'Masse';

  @override
  String get bodyPropertiesRadius => 'Radius';

  @override
  String get bodyPropertiesLuminosity => 'Stellare Leuchtkraft';

  @override
  String get bodyPropertiesVelocity => 'Geschwindigkeit';

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyEarth => 'Erde';

  @override
  String get bodyMoon => 'Mond';

  @override
  String get bodyStarA => 'Stern A';

  @override
  String get bodyStarB => 'Stern B';

  @override
  String get bodyPlanetP => 'Planet P';

  @override
  String get bodyMoonM => 'Mond M';

  @override
  String get bodyCentralStar => 'Zentralstern';

  @override
  String bodyAsteroid(int number) {
    return 'Asteroid $number';
  }

  @override
  String get bodyBlackHole => 'Schwarzes Loch';

  @override
  String bodyStar(int number) {
    return 'Stern $number';
  }

  @override
  String get bodyRingedPlanet => 'Ringplanet';

  @override
  String bodyRing(int number) {
    return 'Ring $number';
  }

  @override
  String get bodyMercury => 'Merkur';

  @override
  String get bodyVenus => 'Venus';

  @override
  String get bodyMars => 'Mars';

  @override
  String get bodyJupiter => 'Jupiter';

  @override
  String get bodySaturn => 'Saturn';

  @override
  String get bodyUranus => 'Uranus';

  @override
  String get bodyNeptune => 'Neptun';

  @override
  String get bodyInnerPlanet => 'Innerer Planet';

  @override
  String get bodyOuterPlanet => 'Äußerer Planet';

  @override
  String get educationalFocusChaoticDynamics => 'chaotische Dynamik';

  @override
  String get educationalFocusRealWorldSystem => 'reales System';

  @override
  String get educationalFocusBinaryOrbits => 'Doppelsternsystem';

  @override
  String get educationalFocusManyBodyDynamics => 'Vielkörperdynamik';

  @override
  String get educationalFocusStructureFormation => 'Strukturbildung';

  @override
  String get educationalFocusPlanetaryMotion => 'Planetenbewegung';

  @override
  String get updateRequiredTitle => 'Update erforderlich';

  @override
  String get updateRequiredMessage =>
      'Eine neuere Version dieser App ist verfügbar. Bitte aktualisieren Sie die App, um sie weiterhin mit den neuesten Funktionen und Verbesserungen nutzen zu können.';

  @override
  String get updateRequiredWarning =>
      'Diese Version wird nicht mehr unterstützt.';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String get updateLater => 'Später aktualisieren';

  @override
  String get versionStatusCurrent => 'Aktuell';

  @override
  String get versionStatusBeta => 'Beta';

  @override
  String get versionStatusOutdated => 'Veraltet';

  @override
  String get maintenanceTitle => 'Wartung';

  @override
  String get newsTitle => 'Neuigkeiten';

  @override
  String get emergencyNotificationTitle => 'Wichtiger Hinweis';

  @override
  String get ok => 'OK';

  @override
  String get screenshotMode => 'Screenshot-Modus';

  @override
  String get screenshotModeSubtitle =>
      'Vorgegebene Szenen für Marketing-Screenshots aktivieren';

  @override
  String get hideUIInScreenshotMode => 'Navigation Ausblenden';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'App-Leiste, untere Navigation und Copyright ausblenden, wenn Screenshot-Modus aktiv ist';

  @override
  String get scenePreset => 'Szenen-Voreinstellung';

  @override
  String get previousPreset => 'Vorherige Voreinstellung';

  @override
  String get nextPreset => 'Nächste Voreinstellung';

  @override
  String get applyScene => 'Szene anwenden';

  @override
  String appliedPreset(String presetName) {
    return 'Voreinstellung angewendet: $presetName';
  }

  @override
  String get deactivate => 'Deaktivieren';

  @override
  String get sceneActive => 'Szene aktiv - Simulation für Screenshot pausiert';

  @override
  String get presetGalaxyFormationOverview => 'Galaxienbildung Übersicht';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Weite Sicht auf Spiralgalaxienbildung mit kosmischem Hintergrund';

  @override
  String get presetGalaxyCoreDetail => 'Galaxienkern Detail';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Nahaufnahme des hellen galaktischen Zentrums mit Akkretionsscheibe';

  @override
  String get presetGalaxyBlackHole => 'Galaktisches Schwarzes Loch';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Nahaufnahme des supermassiven schwarzen Lochs im galaktischen Zentrum';

  @override
  String get presetCompleteSolarSystem => 'Vollständiges Sonnensystem';

  @override
  String get presetCompleteSolarSystemDesc =>
      'Alle Planeten sichtbar mit schönen Umlaufbahnen';

  @override
  String get presetInnerSolarSystem => 'Inneres Sonnensystem';

  @override
  String get presetInnerSolarSystemDesc =>
      'Nahaufnahme von Merkur, Venus, Erde und Mars mit bewohnbarer Zone';

  @override
  String get presetEarthView => 'Erdansicht';

  @override
  String get presetEarthViewDesc =>
      'Nahaufnahme der Erde mit atmosphärischen Details';

  @override
  String get presetSaturnRings => 'Saturns Majestätische Ringe';

  @override
  String get presetSaturnRingsDesc =>
      'Nahaufnahme von Saturn mit detailliertem Ringsystem';

  @override
  String get presetEarthMoonSystem => 'Erde-Mond-System';

  @override
  String get presetEarthMoonSystemDesc =>
      'Erde und Mond mit sichtbarer Orbitalmechanik';

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
  String get presetAsteroidBeltChaos => 'Asteroidengürtel Chaos';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Dichtes Asteroidenfeld mit Gravitationseffekten';

  @override
  String get presetThreeBodyBallet => 'Dreikörper-Ballett';

  @override
  String get presetThreeBodyBalletDesc =>
      'Klassisches Dreikörperproblem in eleganter Bewegung';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioLearnSolar =>
      'Lernen: Planetenbewegung, Orbitalmechanik, vertraute Himmelskörper';

  @override
  String get scenarioBestSolar =>
      'Ideal für: Anfänger, Astronomie-Enthusiasten';

  @override
  String get scenarioLearnEarthMoon =>
      'Lernen: Dreikörperdynamik, Mondmechanik, Gezeitenkräfte';

  @override
  String get scenarioBestEarthMoon =>
      'Ideal für: Verständnis des Erde-Mond-Systems';

  @override
  String get scenarioLearnBinary =>
      'Lernen: Sternentwicklung, Doppelsternsysteme, extreme Gravitation';

  @override
  String get scenarioBestBinary =>
      'Ideal für: Fortgeschrittene Physikerkundung';

  @override
  String get scenarioLearnThreeBody =>
      'Lernen: Chaostheorie, unvorhersagbare Bewegung, instabile Systeme';

  @override
  String get scenarioBestThreeBody =>
      'Ideal für: Mathematische Physik-Enthusiasten';

  @override
  String get scenarioLearnRandom =>
      'Lernen: Unbekannte Konfigurationen entdecken, experimentelle Physik';

  @override
  String get scenarioBestRandom => 'Ideal für: Erkundung und Experimente';

  @override
  String get privacyPolicyLabel => 'Datenschutzrichtlinie';

  @override
  String get tutorialWelcomeTitle => 'Willkommen bei Graviton!';

  @override
  String get tutorialWelcomeDescription =>
      'Willkommen bei Graviton, Ihrem Fenster in die faszinierende Welt der Gravitationsphysik! Diese App ermöglicht es Ihnen zu erkunden, wie Himmelskörper durch Gravitation interagieren und wunderschöne Orbitaltänze durch Raum und Zeit schaffen.';

  @override
  String get tutorialObjectivesTitle => 'Was Können Sie Tun?';

  @override
  String get tutorialObjectivesDescription =>
      '• Realistische Orbitalmechanik beobachten\n• Verschiedene astronomische Szenarien erkunden\n• Mit Gravitationsinteraktionen experimentieren\n• Kollisionen und Verschmelzungen beobachten\n• Über Planetenbewegung lernen\n• Chaotische Dreikörperdynamik entdecken';

  @override
  String get tutorialControlsTitle => 'Simulationssteuerung';

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
  String get tutorialCameraTitle => 'Kamera- & Ansichtssteuerung';

  @override
  String get tutorialCameraDescription =>
      'Ziehen Sie, um Ihre Ansicht zu drehen, kneifen Sie zum Zoomen und verwenden Sie zwei Finger zum Rollen der Kamera. Die untere Leiste hat Fokus-, Zentrier- und automatische Rotationssteuerelemente für ein kinoreifes Erlebnis.';

  @override
  String get tutorialScenariosTitle => 'Wählen Sie Ihr Abenteuer';

  @override
  String get tutorialScenariosDescription =>
      'Öffnen Sie das Menü (⋮) oben rechts, um verschiedene Szenarien zu erkunden: unser Sonnensystem, Erde-Mond-Dynamik, Doppelsterne oder das chaotische Dreikörperproblem. Jedes bietet einzigartige Physik zum Entdecken!';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Öffnen Sie das Menü';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'oben rechts, um verschiedene Szenarien zu erkunden: unser Sonnensystem, Erde-Mond-Dynamik, Doppelsterne oder das chaotische Dreikörperproblem. Jedes bietet einzigartige Physik zum Entdecken!';

  @override
  String get tutorialExploreTitle => 'Bereit zum Erkunden!';

  @override
  String get tutorialExploreDescription =>
      'Sie sind bereit! Beginnen Sie mit dem Sonnensystem, um vertraute Planeten zu sehen, oder tauchen Sie in das Dreikörperproblem für chaotischen Spaß ein. Denken Sie daran: Jedes Zurücksetzen erschafft ein neues Universum zum Erkunden!';

  @override
  String get skipTutorial => 'Überspringen';

  @override
  String get previous => 'Vorherige';

  @override
  String get next => 'Nächste';

  @override
  String get getStarted => 'Loslegen!';

  @override
  String get showTutorialTooltip => 'Tutorial Anzeigen';

  @override
  String get helpAndObjectivesTitle => 'Hilfe & Ziele';

  @override
  String get whatToDoTitle => 'Was in Graviton zu Tun';

  @override
  String get whatToDoDescription =>
      'Graviton ist ein Physik-Spielplatz, wo Sie können:\n\n🪐 Realistische Orbitalmechanik erkunden\n🌟 Sternentwicklung und Kollisionen beobachten\n🎯 Über Gravitationskräfte lernen\n🎮 Mit verschiedenen Szenarien experimentieren\n📚 Himmelsdynamik verstehen\n🔄 Unendliche zufällige Konfigurationen erstellen';

  @override
  String get objectivesTitle => 'Lernziele';

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
  String get quickStartTitle => 'Schnellstart-Anleitung';

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
  String get objectivesDescription =>
      '• Verstehen Sie, wie die Schwerkraft den Kosmos formt\n• Beobachten Sie stabile vs. chaotische Orbitalsysteme\n• Lernen Sie, warum sich Planeten in elliptischen Bahnen bewegen\n• Entdecken Sie, wie Doppelsterne interagieren\n• Sehen Sie, was passiert, wenn Objekte kollidieren\n• Schätzen Sie die Komplexität des Drei-Körper-Problems';

  @override
  String get quickStartDescription =>
      '1. Wählen Sie ein Szenario (Sonnensystem für Anfänger empfohlen)\n2. Drücken Sie Play, um die Simulation zu starten\n3. Ziehen Sie, um die Ansicht zu drehen, kneifen Sie zum Zoomen\n4. Tippen Sie auf den Geschwindigkeitsregler, um die Zeit zu kontrollieren\n5. Versuchen Sie Reset für neue zufällige Konfigurationen\n6. Aktivieren Sie Spuren, um Orbitalbahnen zu sehen';

  @override
  String get showHelpTooltip => 'Hilfe & Ziele';

  @override
  String get tutorialButton => 'Tutorial';

  @override
  String get resetTutorialButton => 'Zurücksetzen';

  @override
  String get tutorialResetMessage =>
      'Tutorial-Status zurückgesetzt! Starten Sie die App neu, um das erste Mal-Erlebnis zu sehen.';

  @override
  String get copyButton => 'Kopieren';

  @override
  String couldNotOpenUrl(String url) {
    return 'Konnte $url nicht öffnen';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Fehler beim Öffnen des Links: $error';
  }

  @override
  String copiedToClipboard(String text) {
    return 'In die Zwischenablage kopiert: $text';
  }
}
