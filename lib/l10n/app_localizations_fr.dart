// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => 'Lecture';

  @override
  String get pauseButton => 'Pause';

  @override
  String get resetButton => 'Réinitialiser';

  @override
  String get resetSettingsDescription =>
      'Réinitialiser tous les paramètres aux valeurs par défaut';

  @override
  String get speedLabel => 'Vitesse';

  @override
  String get trailsLabel => 'Traînées';

  @override
  String get statsLabel => 'Statistiques';

  @override
  String get bottomNavCameraLabel => 'Caméra';

  @override
  String get bottomNavVisualsLabel => 'Visuels';

  @override
  String get bottomNavPhysicsLabel => 'Physique';

  @override
  String get cameraTooltip => 'Paramètres de caméra et modes IA';

  @override
  String get visualsTooltip => 'Options d\'affichage visuel';

  @override
  String get physicsTooltip => 'Visualisation et paramètres de physique';

  @override
  String get aiCameraModesTitle => 'Modes Caméra IA';

  @override
  String get manualControlTitle => 'Contrôle Manuel';

  @override
  String get manualControlDescription => 'Contrôle manuel complet de la caméra';

  @override
  String get predictiveOrbitalTitle => 'Orbital Prédictif';

  @override
  String get predictiveOrbitalDescription =>
      'L\'IA prédit les vues orbitales optimales';

  @override
  String get dynamicFramingTitle => 'Cadrage Dynamique';

  @override
  String get dynamicFramingDescription =>
      'L\'IA cadre dynamiquement tous les objets';

  @override
  String get manualControlsTitle => 'Contrôles Manuels';

  @override
  String get cameraSpeedLabel => 'Vitesse de la Caméra';

  @override
  String get cameraSpeedHint =>
      'Ajuster la vitesse de mouvement de la caméra IA de lente à rapide. Utiliser les touches fléchées pour des changements par petits incréments.';

  @override
  String get selectNearestTitle => 'Sélectionner le Plus Proche';

  @override
  String get stopFollowTitle => 'Arrêter de Suivre';

  @override
  String get followTitle => 'Suivre';

  @override
  String get centerViewTitle => 'Centrer la Vue';

  @override
  String get stopRotateTitle => 'Arrêter la Rotation';

  @override
  String get autoRotateTitle => 'Rotation Automatique';

  @override
  String get displayOptionsTitle => 'Options d\'Affichage';

  @override
  String get showTrailsTitle => 'Afficher les Traînées';

  @override
  String get showLabelsTitle => 'Afficher les Étiquettes';

  @override
  String get realisticColorsTitle => 'Couleurs Réalistes';

  @override
  String get physicsVisualizationTitle => 'Visualisation de la Physique';

  @override
  String get gravityFieldsTitle => 'Champs Gravitationnels';

  @override
  String get gravityFieldsDescription =>
      'Afficher la visualisation du champ gravitationnel';

  @override
  String get debugStatisticsTitle => 'Débogage et Statistiques';

  @override
  String get showStatisticsTitle => 'Afficher les Statistiques';

  @override
  String get showStatisticsDescription =>
      'Afficher les statistiques de performance et de physique';

  @override
  String get currentStatisticsTitle => 'Statistiques Actuelles';

  @override
  String get bodiesStatLabel => 'Corps';

  @override
  String get timeScaleStatLabel => 'Échelle de Temps';

  @override
  String get selectedStatLabel => 'Sélectionné';

  @override
  String get followLabel => 'Suivre';

  @override
  String get centerLabel => 'Centrer';

  @override
  String get rotateLabel => 'Rotation';

  @override
  String get warmTrails => '🔥 Chaud';

  @override
  String get coolTrails => '❄️ Froid';

  @override
  String get toggleStatsTooltip => 'Basculer Statistiques';

  @override
  String get toggleLabelsTooltip => 'Basculer Étiquettes des Corps';

  @override
  String get showLabelsDescription =>
      'Afficher les noms des corps célestes dans la simulation';

  @override
  String get offScreenIndicatorsTitle => 'Indicateurs Hors Écran';

  @override
  String get offScreenIndicatorsDescription =>
      'Afficher des flèches pointant vers les objets en dehors de la zone visible';

  @override
  String get autoRotateTooltip => 'Rotation Automatique';

  @override
  String get centerViewTooltip => 'Centrer la Vue';

  @override
  String get focusOnNearestTooltip =>
      'Se Concentrer sur le Corps le Plus Proche';

  @override
  String get followObjectTooltip => 'Suivre l\'Objet Sélectionné';

  @override
  String get stopFollowingTooltip => 'Arrêter de Suivre l\'Objet';

  @override
  String get selectObjectToFollowTooltip => 'Sélectionner un Objet à Suivre';

  @override
  String get settingsTitle => 'Paramètres de l\'Application';

  @override
  String get settingsTooltip => 'Paramètres de l\'Application';

  @override
  String get selectScenarioTooltip => 'Sélectionner un Scénario';

  @override
  String get moreOptionsTooltip => 'Plus d\'options';

  @override
  String get physicsSettingsTitle => 'Paramètres de Physique';

  @override
  String get physicsSettingsDescription => 'Paramètres de simulation';

  @override
  String get physicsSection => 'Physique';

  @override
  String get gravitationalConstant => 'Constante gravitationnelle';

  @override
  String get softeningParameter => 'Paramètre d\'adoucissement';

  @override
  String get simulationSpeed => 'Vitesse de simulation';

  @override
  String get simulationSpeedHint =>
      'Ajustez la vitesse de simulation de 0,1x à 16x vitesse normale. Utilisez les touches fléchées pour de petits incréments.';

  @override
  String get collisionsSection => 'Collisions';

  @override
  String get collisionSensitivity => 'Sensibilité aux collisions';

  @override
  String get trailsSection => 'Traces';

  @override
  String get trailLength => 'Longueur des traces';

  @override
  String get trailFadeRate => 'Taux de fondu des traces';

  @override
  String get hapticsSection => 'Haptique';

  @override
  String get uiHapticFeedback => 'Retour Haptique UI';

  @override
  String get uiHapticFeedbackDescription =>
      'Activer le retour haptique pour les interactions UI comme les boutons, les commutateurs et la navigation';

  @override
  String get collisionHapticFeedback => 'Retour Haptique de Collision';

  @override
  String get collisionHapticFeedbackDescription =>
      'Activer le retour haptique lorsque les corps célestes entrent en collision pendant la simulation';

  @override
  String get vibrationEnabled => 'Vibration activée';

  @override
  String get hapticFeedbackCollisions => 'Retour haptique sur les collisions';

  @override
  String get hapticFeedbackDescription =>
      'Activer le retour haptique pour les interactions UI et les collisions';

  @override
  String get vibrationThrottle => 'Limitation de vibration';

  @override
  String get scenariosMenuDescription => 'Explorer différents scénarios';

  @override
  String get settingsMenuDescription => 'Options visuelles et de comportement';

  @override
  String get helpMenuDescription => 'Tutoriel et objectifs';

  @override
  String get aboutMenuDescription => 'Informations de l\'app et crédits';

  @override
  String get showTrails => 'Afficher les Traînées';

  @override
  String get showTrailsDescription =>
      'Afficher les traînées de mouvement derrière les objets';

  @override
  String get showOrbitalPaths => 'Afficher les Trajectoires Orbitales';

  @override
  String get showOrbitalPathsDescription =>
      'Afficher les trajectoires orbitales prédites dans les scénarios avec des orbites stables';

  @override
  String get dualOrbitalPaths => 'Trajectoires Orbitales Doubles';

  @override
  String get dualOrbitalPathsDescription =>
      'Afficher à la fois les trajectoires orbitales circulaires idéales et elliptiques réelles';

  @override
  String get trailColorLabel => 'Couleur de Traînée';

  @override
  String get colorsLabel => 'Couleurs';

  @override
  String get realisticColors => 'Couleurs Réalistes';

  @override
  String get realisticColorsDescription =>
      'Utiliser des couleurs scientifiquement précises basées sur la température et la classification stellaire';

  @override
  String get closeButton => 'Fermer';

  @override
  String get simulationStats => 'Statistiques de Simulation';

  @override
  String get stepsLabel => 'Étapes';

  @override
  String get timeLabel => 'Temps';

  @override
  String get earthYearsLabel => 'Années Terrestres';

  @override
  String get speedStatsLabel => 'Vitesse';

  @override
  String get bodiesLabel => 'Corps';

  @override
  String get statusLabel => 'État';

  @override
  String get statusRunning => 'En cours';

  @override
  String get statusPaused => 'En pause';

  @override
  String get statusStopped => 'Arrêté';

  @override
  String get statusError => 'Erreur';

  @override
  String get cameraLabel => 'Caméra';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get autoRotateLabel => 'Rotation automatique';

  @override
  String get autoRotateOn => 'Activé';

  @override
  String get autoRotateOff => 'Désactivé';

  @override
  String get yawLabel => 'Lacet';

  @override
  String get pitchLabel => 'Tangage';

  @override
  String get rollLabel => 'Roulis';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String get cameraControlsLabel => 'Contrôles de Caméra';

  @override
  String get invertPitchControlsLabel => 'Inverser les Contrôles de Tangage';

  @override
  String get invertPitchControlsDescription =>
      'Inverser la direction de glissement haut/bas';

  @override
  String get cinematicCameraTechniqueLabel => 'Technique de Caméra IA';

  @override
  String get cinematicCameraTechniqueDescription =>
      'Choisissez comment l\'IA contrôle la caméra lors du suivi d\'objets';

  @override
  String get cinematicTechniqueManual => 'Contrôle Manuel';

  @override
  String get cinematicTechniqueManualDesc =>
      'Contrôles de caméra manuels traditionnels avec mode de suivi';

  @override
  String get cinematicTechniquePredictiveOrbital => 'Orbital Prédictif';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      'Tours IA et prédictions orbitales pour scénarios éducatifs';

  @override
  String get cinematicTechniqueDynamicFraming => 'Cadrage Dynamique';

  @override
  String get cinematicTechniqueDynamicFramingDesc =>
      'Ciblage dramatique en temps réel pour scénarios chaotiques';

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
    return '$years ans';
  }

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String get speedQuarter => 'Vitesse Quart';

  @override
  String get speedHalf => 'Demi-Vitesse';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedDouble => 'Double';

  @override
  String get speedFast => 'Rapide';

  @override
  String get speedVeryFast => 'Très Rapide';

  @override
  String get speedMaximum => 'Maximum';

  @override
  String bodiesCount(int count) {
    return '$count';
  }

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get scenarioSelectionTitle => 'Sélectionner un Scénario';

  @override
  String get cancel => 'Annuler';

  @override
  String get bodies => 'corps';

  @override
  String get scenarioRandom => 'Système Aléatoire';

  @override
  String get scenarioRandomDescription =>
      'Système chaotique à trois corps généré aléatoirement avec une dynamique imprévisible';

  @override
  String get scenarioEarthMoonSun => 'Terre-Lune-Soleil';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Simulation éducative de notre système familier Terre-Lune-Soleil';

  @override
  String get scenarioBinaryStars => 'Étoiles Binaires';

  @override
  String get scenarioBinaryStarsDescription =>
      'Deux étoiles massives en orbite l\'une autour de l\'autre avec des planètes circumbinaires';

  @override
  String get scenarioAsteroidBelt => 'Ceinture d\'Astéroïdes';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Étoile centrale entourée d\'une ceinture d\'astéroïdes rocheux et de débris';

  @override
  String get scenarioGalaxyFormation => 'Formation de Galaxie';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Observez la matière s\'organiser en structures spirales autour d\'un trou noir central';

  @override
  String get scenarioPlanetaryRings => 'Anneaux Planétaires';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Dynamique du système d\'anneaux autour d\'une planète massive comme Saturne';

  @override
  String get scenarioSolarSystem => 'Système Solaire';

  @override
  String get scenarioSolarSystemDescription =>
      'Version simplifiée de notre système solaire avec des planètes intérieures et extérieures';

  @override
  String get scenarioSpecial => 'Scénario Spécial';

  @override
  String get scenarioSpecialDescription =>
      'Scénario spécial pour le mode capture d\'écran';

  @override
  String get habitabilityLabel => 'Habitabilité';

  @override
  String get habitableZonesLabel => 'Zones Habitables';

  @override
  String get habitabilityIndicatorsLabel => 'État de la Planète';

  @override
  String get habitabilityHabitable => 'Habitable';

  @override
  String get habitabilityTooHot => 'Trop Chaud';

  @override
  String get habitabilityTooCold => 'Trop Froid';

  @override
  String get habitabilityUnknown => 'Inconnu';

  @override
  String get temperatureFrozen => 'Gelé';

  @override
  String get temperatureCold => 'Froid';

  @override
  String get temperatureModerate => 'Modéré';

  @override
  String get temperatureHot => 'Chaud';

  @override
  String get temperatureScorching => 'Brûlant';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get toggleHabitableZonesTooltip => 'Basculer les Zones Habitables';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Basculer l\'État d\'Habitabilité de la Planète';

  @override
  String get habitableZonesDescription =>
      'Afficher des zones colorées autour des étoiles indiquant les régions habitables';

  @override
  String get habitabilityIndicatorsDescription =>
      'Afficher des anneaux d\'état codés par couleur autour des planètes basés sur leur habitabilité';

  @override
  String get aboutDialogTitle => 'À Propos';

  @override
  String get appDescription =>
      'Une simulation physique explorant la dynamique gravitationnelle et la mécanique orbitale. Découvrez la beauté et la complexité du mouvement céleste grâce à la visualisation 3D interactive.';

  @override
  String get authorLabel => 'Auteur';

  @override
  String get websiteLabel => 'Site Web';

  @override
  String get aboutButtonTooltip => 'À Propos';

  @override
  String get backButtonTooltip => 'Retour';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => 'Version';

  @override
  String get loadingVersion => 'Chargement de la version...';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get gravityWellsLabel => 'Puits Gravitationnels';

  @override
  String get gravityWellsDescription =>
      'Afficher l\'intensité du champ gravitationnel autour des objets';

  @override
  String get globalGravityFieldsLabel => 'Champs Gravitationnels Globaux';

  @override
  String get globalGravityFieldsDescription =>
      'Activer la visualisation des champs gravitationnels pour tous les objets massifs';

  @override
  String get gravityFieldColorSchemeLabel =>
      'Couleurs des Champs Gravitationnels';

  @override
  String get gravityFieldColorSchemeDescription =>
      'Choisir le schéma de couleurs pour la visualisation des champs gravitationnels';

  @override
  String get gravityColorSchemeClassic => 'Classique';

  @override
  String get gravityColorSchemeSpectral => 'Spectral';

  @override
  String get gravityColorSchemeMonochrome => 'Monochrome';

  @override
  String get gravityColorSchemeNeon => 'Néon';

  @override
  String get gravityColorSchemeEmerald => 'Émeraude';

  @override
  String get gravityFieldStrengthLabel => 'Intensité du Champ';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get equipotentialSurfacesLabel => 'Surfaces Équipotentielles';

  @override
  String get equipotentialSurfacesDescription =>
      'Afficher les surfaces d\'égale énergie potentielle gravitationnelle';

  @override
  String get gravityFieldIndicatorsLabel => 'Indicateurs d\'Intensité du Champ';

  @override
  String get gravityFieldIndicatorsDescription =>
      'Afficher des indicateurs visuels de l\'intensité du champ gravitationnel';

  @override
  String get toggleGravityFieldsTooltip =>
      'Basculer les Champs Gravitationnels';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageDescription => 'Changer la langue de l\'application';

  @override
  String get languageSystem => 'Par Défaut du Système';

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
  String get bodyBeta => 'Bêta';

  @override
  String get bodyGamma => 'Gamma';

  @override
  String get bodyRockyPlanet => 'Planète Rocheuse';

  @override
  String get bodyEarthLike => 'Similaire à la Terre';

  @override
  String get bodySuperEarth => 'Super-Terre';

  @override
  String get bodySun => 'Soleil';

  @override
  String get bodyPropertiesTitle => 'Propriétés du Corps';

  @override
  String get bodyPropertiesName => 'Nom';

  @override
  String get bodyPropertiesNameHint => 'Entrer le nom du corps';

  @override
  String get bodyPropertiesType => 'Type de Corps';

  @override
  String get bodyPropertiesColor => 'Couleur';

  @override
  String get bodyPropertiesMass => 'Masse';

  @override
  String get bodyPropertiesRadius => 'Rayon';

  @override
  String get bodyPropertiesLuminosity => 'Luminosité Stellaire';

  @override
  String get bodyPropertiesVelocity => 'Vitesse';

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyEarth => 'Terre';

  @override
  String get bodyMoon => 'Lune';

  @override
  String get bodyStarA => 'Étoile A';

  @override
  String get bodyStarB => 'Étoile B';

  @override
  String get bodyPlanetP => 'Planète P';

  @override
  String get bodyMoonM => 'Lune M';

  @override
  String get bodyCentralStar => 'Étoile Centrale';

  @override
  String bodyAsteroid(int number) {
    return 'Astéroïde $number';
  }

  @override
  String get bodyBlackHole => 'Trou Noir';

  @override
  String get bodyRingedPlanet => 'Planète à Anneaux';

  @override
  String bodyRing(int number) {
    return 'Anneau $number';
  }

  @override
  String get bodyMercury => 'Mercure';

  @override
  String get bodyVenus => 'Vénus';

  @override
  String get bodyMars => 'Mars';

  @override
  String get bodyJupiter => 'Jupiter';

  @override
  String get bodySaturn => 'Saturne';

  @override
  String get bodyUranus => 'Uranus';

  @override
  String get bodyNeptune => 'Neptune';

  @override
  String get bodyInnerPlanet => 'Planète Intérieure';

  @override
  String get bodyOuterPlanet => 'Planète Extérieure';

  @override
  String get bodyCenterOfMass => 'Centre de Masse';

  @override
  String bodyStarNumber(int number) {
    return 'Étoile $number';
  }

  @override
  String get educationalFocusChaoticDynamics => 'dynamique chaotique';

  @override
  String get educationalFocusRealWorldSystem => 'système du monde réel';

  @override
  String get educationalFocusBinaryOrbits => 'orbites binaires';

  @override
  String get educationalFocusManyBodyDynamics => 'dynamique à plusieurs corps';

  @override
  String get educationalFocusStructureFormation => 'formation de structure';

  @override
  String get educationalFocusPlanetaryMotion => 'mouvement planétaire';

  @override
  String get updateRequiredTitle => 'Mise à jour requise';

  @override
  String get updateRequiredMessage =>
      'Une version plus récente de cette application est disponible. Veuillez mettre à jour pour continuer à utiliser l\'application avec les dernières fonctionnalités et améliorations.';

  @override
  String get updateRequiredWarning =>
      'Cette version n\'est plus prise en charge.';

  @override
  String get updateNow => 'Mettre à jour maintenant';

  @override
  String get updateLater => 'Plus tard';

  @override
  String get versionStatusCurrent => 'Actuel';

  @override
  String get versionStatusBeta => 'Bêta';

  @override
  String get versionStatusOutdated => 'Obsolète';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get newsTitle => 'Actualités';

  @override
  String get emergencyNotificationTitle => 'Avis Important';

  @override
  String get warningTitle => 'Avertissement';

  @override
  String get successTitle => 'Succès';

  @override
  String get announcementTitle => 'Annonce';

  @override
  String get promotionTitle => 'Promotion';

  @override
  String get ok => 'OK';

  @override
  String get screenshotMode => 'Mode Capture d\'Écran';

  @override
  String get screenshotModeSubtitle =>
      'Activer des scènes prédéfinies pour les captures marketing';

  @override
  String get hideUIInScreenshotMode => 'Masquer la Navigation';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'Masquer la barre d\'app, la navigation du bas et le copyright quand le mode capture est actif';

  @override
  String screenshotCountdown(int seconds) {
    return 'Capture dans ${seconds}s';
  }

  @override
  String get scenePreset => 'Scène Prédéfinie';

  @override
  String get previousPreset => 'Scène précédente';

  @override
  String get nextPreset => 'Scène suivante';

  @override
  String get applyScene => 'Appliquer la Scène';

  @override
  String appliedPreset(String presetName) {
    return 'Scène appliquée : $presetName';
  }

  @override
  String get deactivate => 'Désactiver';

  @override
  String get sceneActive => 'Scène active - simulation pausée pour capture';

  @override
  String get presetGalaxyFormationOverview =>
      'Vue d\'Ensemble de Formation Galactique';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Vue large de la formation de galaxie spirale avec arrière-plan cosmique';

  @override
  String get presetGalaxyCoreDetail => 'Détail du Noyau Galactique';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Gros plan du centre galactique brillant avec disque d\'accrétion';

  @override
  String get presetGalaxyBlackHole => 'Trou Noir Galactique';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Vue rapprochée du trou noir supermassif au centre galactique';

  @override
  String get presetCompleteSolarSystem => 'Système Solaire Complet';

  @override
  String get presetCompleteSolarSystemDesc =>
      'Toutes les planètes visibles avec de belles orbites';

  @override
  String get presetInnerSolarSystem => 'Système Solaire Intérieur';

  @override
  String get presetInnerSolarSystemDesc =>
      'Gros plan de Mercure, Vénus, Terre et Mars avec indicateur de zone habitable';

  @override
  String get presetEarthView => 'Vue de la Terre';

  @override
  String get presetEarthViewDesc =>
      'Perspective rapprochée de la Terre avec détail atmosphérique';

  @override
  String get presetSaturnRings => 'Anneaux Majestueux de Saturne';

  @override
  String get presetSaturnRingsDesc =>
      'Gros plan de Saturne avec système d\'anneaux détaillé';

  @override
  String get presetEarthMoonSystem => 'Système Terre-Lune';

  @override
  String get presetEarthMoonSystemDesc =>
      'Terre et Lune avec mécanique orbitale visible';

  @override
  String get presetBinaryStarDrama => 'Drame d\'Étoile Binaire';

  @override
  String get presetBinaryStarDramaDesc =>
      'Vue de face de deux étoiles massives en danse gravitationnelle';

  @override
  String get presetBinaryStarPlanetMoon => 'Planète et Lune d\'Étoile Binaire';

  @override
  String get presetBinaryStarPlanetMoonDesc =>
      'Planète et lune en orbite dans un système binaire chaotique';

  @override
  String get presetAsteroidBeltChaos => 'Chaos de la Ceinture d\'Astéroïdes';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Champ dense d\'astéroïdes avec effets gravitationnels';

  @override
  String get presetThreeBodyBallet => 'Ballet à Trois Corps';

  @override
  String get presetThreeBodyBalletDesc =>
      'Problème classique à trois corps en mouvement élégant';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioLearnSolar =>
      'Apprendre : Mouvement planétaire, mécanique orbitale, corps célestes familiers';

  @override
  String get scenarioBestSolar =>
      'Idéal pour : Débutants, passionnés d\'astronomie';

  @override
  String get scenarioLearnEarthMoon =>
      'Apprendre : Dynamiques à trois corps, mécanique lunaire, forces de marée';

  @override
  String get scenarioBestEarthMoon =>
      'Idéal pour : Comprendre le système Terre-Lune';

  @override
  String get scenarioLearnBinary =>
      'Apprendre : Évolution stellaire, systèmes binaires, gravité extrême';

  @override
  String get scenarioBestBinary =>
      'Idéal pour : Exploration avancée de physique';

  @override
  String get scenarioLearnThreeBody =>
      'Apprendre : Théorie du chaos, mouvement imprévisible, systèmes instables';

  @override
  String get scenarioBestThreeBody =>
      'Idéal pour : Passionnés de physique mathématique';

  @override
  String get scenarioLearnRandom =>
      'Apprendre : Découvrir des configurations inconnues, physique expérimentale';

  @override
  String get scenarioBestRandom =>
      'Idéal pour : Exploration et expérimentation';

  @override
  String get privacyPolicyLabel => 'Politique de Confidentialité';

  @override
  String get tutorialWelcomeTitle => 'Bienvenue dans Graviton !';

  @override
  String get tutorialWelcomeDescription =>
      'Bienvenue dans Graviton, votre fenêtre sur le monde fascinant de la physique gravitationnelle ! Cette application vous permet d\'explorer comment les corps célestes interagissent par la gravité, créant de belles danses orbitales à travers l\'espace et le temps.';

  @override
  String get welcomeCardDescription =>
      'Explorez la physique gravitationnelle à travers des simulations interactives. Essayez différents scénarios, ajustez les contrôles et regardez le cosmos se déployer !';

  @override
  String get quickTutorialButton => 'Tutoriel Rapide';

  @override
  String get gotItButton => 'Compris !';

  @override
  String get tutorialNavigationHint =>
      'Glissez gauche/droite ou utilisez les boutons pour naviguer';

  @override
  String get tutorialObjectivesTitle => 'Que pouvez-vous faire ?';

  @override
  String get tutorialObjectivesDescription =>
      '• Observer une mécanique orbitale réaliste\n• Explorer différents scénarios astronomiques\n• Expérimenter avec les interactions gravitationnelles\n• Regarder les collisions et fusions\n• Apprendre le mouvement planétaire\n• Découvrir les dynamiques chaotiques à trois corps';

  @override
  String get tutorialControlsTitle => 'Contrôles de Simulation';

  @override
  String get tutorialControlsDescription =>
      'Touchez n\'importe où pour afficher les contrôles flottants de Lecture/Pause pour la simulation. Le contrôle de vitesse est dans le coin supérieur droit. Touchez le menu (⋮) pour les scénarios, paramètres et ajustements physiques.';

  @override
  String get tutorialControlsDescriptionPart1 =>
      'Touchez n\'importe où pour afficher les contrôles flottants de Lecture/Pause pour la simulation. Le contrôle de vitesse est dans le coin supérieur droit. Touchez le menu';

  @override
  String get tutorialControlsDescriptionPart2 =>
      'pour les scénarios, paramètres et ajustements physiques.';

  @override
  String get tutorialCameraTitle => 'Contrôles de Caméra et Vue';

  @override
  String get tutorialCameraDescription =>
      'Glissez pour faire pivoter la vue, pincez pour zoomer, et utilisez deux doigts pour faire rouler la caméra. La barre inférieure a des contrôles de focus, centrage et rotation automatique pour une expérience cinématographique.';

  @override
  String get tutorialScenariosTitle => 'Explorer les Scénarios';

  @override
  String get tutorialScenariosDescription =>
      'Accédez au menu (⋮) dans le coin supérieur droit pour explorer différents scénarios : notre Système Solaire, dynamiques Terre-Lune, Étoiles Binaires, ou le chaotique Problème à Trois Corps. Chacun offre une physique unique à découvrir !';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Accédez au menu';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'dans le coin supérieur droit pour explorer différents scénarios : notre Système Solaire, dynamiques Terre-Lune, Étoiles Binaires, ou le chaotique Problème à Trois Corps. Chacun offre une physique unique à découvrir !';

  @override
  String get tutorialExploreTitle => 'Commencez à Explorer !';

  @override
  String get tutorialExploreDescription =>
      'Vous êtes maintenant prêt à explorer le cosmos ! Expérimentez avec différents scénarios, ajustez les paramètres, et observez comment la gravité façonne la danse des corps célestes. Profitez de votre voyage à travers l\'univers !';

  @override
  String get skipTutorial => 'Passer le Tutoriel';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get showTutorialTooltip => 'Afficher le Tutoriel';

  @override
  String get helpAndObjectivesTitle => 'Aide et Objectifs';

  @override
  String get whatToDoTitle => 'Que faire ?';

  @override
  String get whatToDoDescription =>
      'Explorez les contrôles, expérimentez avec différents scénarios, et observez comment la gravité affecte le mouvement des objets célestes.';

  @override
  String get objectivesTitle => 'Objectifs';

  @override
  String get objectives1 => 'Comprendre comment la gravité façonne le cosmos';

  @override
  String get objectives2 =>
      'Observer les systèmes orbitaux stables vs. chaotiques';

  @override
  String get objectives3 =>
      'Apprendre pourquoi les planètes bougent en orbites elliptiques';

  @override
  String get objectives4 =>
      'Découvrir comment les étoiles binaires interagissent';

  @override
  String get objectives5 =>
      'Voir ce qui se passe quand les objets entrent en collision';

  @override
  String get objectives6 => 'Apprécier la complexité du problème à trois corps';

  @override
  String get quickStartTitle => 'Démarrage Rapide';

  @override
  String get quickStart1 =>
      'Choisissez un scénario (Système Solaire recommandé pour les débutants)';

  @override
  String get quickStart2 => 'Appuyez sur Play pour démarrer la simulation';

  @override
  String get quickStart3 =>
      'Faites glisser pour faire pivoter votre vue, pincez pour zoomer';

  @override
  String get quickStart4 =>
      'Touchez le curseur de Vitesse pour contrôler le temps';

  @override
  String get quickStart5 =>
      'Essayez Reset pour de nouvelles configurations aléatoires';

  @override
  String get quickStart6 =>
      'Activez les Traces pour voir les trajectoires orbitales';

  @override
  String get objectivesDescription =>
      '• Comprendre comment la gravité façonne le cosmos\n• Observer les systèmes orbitaux stables vs. chaotiques\n• Apprendre pourquoi les planètes bougent en orbites elliptiques\n• Découvrir comment les étoiles binaires interagissent\n• Voir ce qui se passe quand les objets entrent en collision\n• Apprécier la complexité du problème à trois corps';

  @override
  String get quickStartDescription =>
      '1. Choisissez un scénario (Système Solaire recommandé pour les débutants)\n2. Appuyez sur Play pour démarrer la simulation\n3. Faites glisser pour faire pivoter votre vue, pincez pour zoomer\n4. Touchez le curseur de Vitesse pour contrôler le temps\n5. Essayez Reset pour de nouvelles configurations aléatoires\n6. Activez les Traces pour voir les trajectoires orbitales';

  @override
  String get showHelpTooltip => 'Afficher l\'Aide';

  @override
  String get tutorialButton => 'Tutoriel';

  @override
  String get resetTutorialButton => 'Réinitialiser';

  @override
  String get tutorialResetMessage =>
      'État du tutoriel réinitialisé ! Redémarrez l\'application pour voir l\'expérience de première utilisation.';

  @override
  String get copyButton => 'Copier';

  @override
  String couldNotOpenUrl(String url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Erreur lors de l\'ouverture du lien : $error';
  }

  @override
  String copiedToClipboard(String text) {
    return 'Copié dans le presse-papiers : $text';
  }

  @override
  String get changelogTitle => 'Nouveautés';

  @override
  String get closeDialog => 'Fermer';

  @override
  String changelogReleaseDate(String date) {
    return 'Publié le $date';
  }

  @override
  String get changelogAdded => 'Nouvelles fonctionnalités';

  @override
  String get changelogImproved => 'Améliorations';

  @override
  String get changelogFixed => 'Corrections de bugs';

  @override
  String get changelogSkip => 'Ignorer';

  @override
  String get changelogDone => 'Terminé';

  @override
  String get changelogButton => 'Afficher le journal des modifications';

  @override
  String get resetChangelogButton => 'Réinitialiser l\'état du journal';

  @override
  String get changelogResetMessage =>
      'L\'état du journal des modifications a été réinitialisé';

  @override
  String get changelogDebugTitle => 'Journal des modifications';

  @override
  String changelogNotFoundError(String version) {
    return 'Aucun journal de modifications trouvé. Ajoutez d\'abord les données du journal à Firestore.\nVersion actuelle : $version';
  }

  @override
  String changelogLoadError(String error) {
    return 'Échec du chargement du journal des modifications : $error';
  }

  @override
  String get noChangelogsAvailable =>
      'Aucun journal de modifications disponible';

  @override
  String errorLoadingChangelogs(String error) {
    return 'Erreur lors du chargement des journaux de modifications : $error';
  }

  @override
  String get stellarColorBlue => 'Bleu';

  @override
  String get stellarColorBlueWhite => 'Bleu-blanc';

  @override
  String get stellarColorWhite => 'Blanc';

  @override
  String get stellarColorYellowWhite => 'Blanc-jaune';

  @override
  String get stellarColorYellow => 'Jaune';

  @override
  String get stellarColorOrange => 'Orange';

  @override
  String get stellarColorRed => 'Rouge';

  @override
  String get pathVisualizationTitle => 'Visualisation des Trajectoires';

  @override
  String get navigationAidsTitle => 'Aides à la Navigation';

  @override
  String get gravityFieldClassicLabel => 'Classique';

  @override
  String get gravityFieldSpectralLabel => 'Spectral';

  @override
  String get gravityFieldMonochromeLabel => 'Monochrome';

  @override
  String get gravityFieldNeonLabel => 'Néon';

  @override
  String get gravityFieldEmeraldLabel => 'Émeraude';

  @override
  String get appInformationCredits => 'Informations sur l\'app et crédits';

  @override
  String get developerToolsTitle => 'Outils de Développement';

  @override
  String get developerToolsMenuDescription =>
      'Outils de débogage pour le développement';

  @override
  String get tutorialDescription => 'Visite guidée interactive de l\'app';

  @override
  String get resetTutorialDescription => 'Réinitialiser le progrès du tutoriel';

  @override
  String get changelogDescription =>
      'Voir les mises à jour et changements de l\'app';

  @override
  String get resetChangelogDescription =>
      'Réinitialiser le statut de lecture du changelog';

  @override
  String get tutorialResetSuccess =>
      'Le progrès du tutoriel a été réinitialisé';

  @override
  String get changelogResetSuccess =>
      'Le statut du changelog a été réinitialisé';

  @override
  String get copyrightLabel => 'Droits d\'Auteur';

  @override
  String get allRightsReserved => 'Tous droits réservés';

  @override
  String get bodyTypeStar => 'Étoile';

  @override
  String get bodyTypePlanet => 'Planète';

  @override
  String get bodyTypeMoon => 'Lune';

  @override
  String get bodyTypeAsteroid => 'Astéroïde';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Étoiles',
      one: '1 Étoile',
    );
    return '$_temp0';
  }

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Planètes',
      one: '1 Planète',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lunes',
      one: '1 Lune',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Astéroïdes',
      one: '1 Astéroïde',
    );
    return '$_temp0';
  }

  @override
  String get appFlavorDevelopment => 'Développement';

  @override
  String get appFlavorProduction => 'Production';

  @override
  String get notificationTypeError => 'Erreur';

  @override
  String get notificationTypeWarning => 'Avertissement';

  @override
  String get notificationTypeInfo => 'Information';

  @override
  String get notificationTypeSuccess => 'Succès';

  @override
  String get notificationTypeDebug => 'Débogage';

  @override
  String get trackingModeFull => 'Suivi Complet';

  @override
  String get trackingModeEssential => 'Essentiel Seulement';

  @override
  String get trackingModeNone => 'Aucun Suivi';

  @override
  String get trackingModeLimited => 'Suivi Limité';

  @override
  String get trackingModeFullDescription =>
      'Toutes les analyses, crashs et interactions';

  @override
  String get trackingModeEssentialDescription =>
      'Crashs critiques et erreurs seulement';

  @override
  String get trackingModeNoneDescription => 'Aucune collecte de données';

  @override
  String get trackingModeLimitedDescription =>
      'Interactions utilisateur seulement';

  @override
  String get changelogCategoryAdded => 'Ajouté';

  @override
  String get changelogCategoryImproved => 'Amélioré';

  @override
  String get changelogCategoryFixed => 'Corrigé';

  @override
  String get cameraManual => 'Contrôle Manuel';

  @override
  String get cameraPredictiveOrbital => 'Orbital Prédictif';

  @override
  String get cameraDynamicFraming => 'Cadrage Dynamique';

  @override
  String get cameraManualDescription =>
      'Contrôles manuels traditionnels de caméra avec mode suivi';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'L\'IA prédit les trajectoires orbitales pour des mouvements dramatiques de caméra';

  @override
  String get cameraDynamicFramingDescription =>
      'Ajuste automatiquement le cadrage basé sur le contenu de la scène';

  @override
  String get fullscreenMode => 'Mode Plein Écran';

  @override
  String get fullscreenModeDescription =>
      'Masquer tous les éléments de l\'interface pour une visualisation immersive';

  @override
  String get tapToToggleFullscreen => 'Appuyez pour basculer en plein écran';

  @override
  String get exitFullscreenHint =>
      'Appuyez n\'importe où pour quitter le mode plein écran';

  @override
  String get simulationCanvasLabel => 'Simulation de Physique Gravitationnelle';

  @override
  String get simulationCanvasHint =>
      'Utilisez les raccourcis clavier pour contrôler la simulation. Espace pour pause, R pour redémarrer, C pour centrer la caméra';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return 'Simulation gravitationnelle avec $bodyCount corps célestes. État : $status. Vitesse : $speed. Étapes : $steps';
  }

  @override
  String get noBodiesInSimulation =>
      'Aucun corps céleste dans la simulation actuellement';

  @override
  String bodiesInSimulation(String descriptions) {
    return 'Corps dans la simulation : $descriptions';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return 'Caméra en mode libre à distance $distance. Rotation automatique : $rotation';
  }

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return 'Caméra suivant $bodyName à distance $distance. Rotation automatique : $rotation';
  }

  @override
  String get autoRotateActive => 'active';

  @override
  String get autoRotateInactive => 'inactive';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType changé à $value';
  }

  @override
  String get keyboardShortcutsHint =>
      'Utilisez Espace pour pause/reprendre, R pour redémarrer, C pour centrer la caméra, A pour basculer la rotation automatique';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return 'Physique : $time unités de temps, $earthYears années terrestres, $steps étapes de simulation terminées';
  }

  @override
  String get toggleAutoRotateAction => 'Basculer rotation automatique';

  @override
  String get zoomInAction => 'Zoomer';

  @override
  String get zoomOutAction => 'Dézoomer';

  @override
  String get expandedState => 'élargi';

  @override
  String get collapsedState => 'réduit';

  @override
  String get currentScenario => 'Scénario actuel';

  @override
  String get scenariosAvailable => 'scénarios disponibles';

  @override
  String get bottomSheetLabel => 'Feuille inférieure';

  @override
  String get gravitationalSimulationLabel =>
      'Simulation de Physique Gravitationnelle';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return 'Simulation gravitationnelle avec $bodyCount corps célestes. État : $status. Vitesse : $speed. Étapes terminées : $stepCount. Appuyez pour interagir avec la simulation ou utilisez les raccourcis clavier.';
  }

  @override
  String get accessibilitySimulationStarted => 'Simulation démarrée';

  @override
  String get accessibilitySimulationStartedContext =>
      'Les corps célestes sont maintenant en mouvement';

  @override
  String get accessibilitySimulationPaused => 'Simulation en pause';

  @override
  String get accessibilitySimulationPausedContext =>
      'Tous les corps célestes ont cessé de bouger';

  @override
  String get accessibilitySimulationResumed => 'Simulation reprise';

  @override
  String get accessibilitySimulationResumedContext =>
      'Les corps célestes bougent à nouveau';

  @override
  String get accessibilitySimulationStopped => 'Simulation arrêtée';

  @override
  String get accessibilitySimulationStoppedContext =>
      'Tous les corps célestes ont été réinitialisés';

  @override
  String get accessibilitySimulationReset => 'Simulation réinitialisée';

  @override
  String get accessibilitySimulationResetContext =>
      'Nouveau scénario chargé avec de nouveaux corps célestes';

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return 'Collision détectée : $body1 a fusionné avec $body2';
  }

  @override
  String get accessibilityMergeEventContext =>
      'La masse combinée crée un nouveau corps céleste';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return 'Scénario changé pour $scenarioName';
  }

  @override
  String get accessibilityScenarioChangeContext =>
      'Nouveaux corps célestes et paramètres physiques chargés';

  @override
  String accessibilitySpeedChange(String newValue) {
    return 'Vitesse de simulation changée à $newValue';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return 'Force de gravité changée à $newValue';
  }

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return 'Sensibilité de collision changée à $newValue';
  }

  @override
  String get accessibilityCameraReset =>
      'Vue caméra réinitialisée à la position par défaut';

  @override
  String get accessibilityCameraFocus =>
      'Caméra focalisée sur le corps céleste le plus proche';

  @override
  String get accessibilityCameraFollow =>
      'La caméra suit maintenant le corps céleste sélectionné';

  @override
  String get accessibilityCameraUnfollow =>
      'La caméra a cessé de suivre le corps céleste';

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return 'Étape du tutoriel $currentStep sur $totalSteps : $stepName';
  }

  @override
  String accessibilityError(String errorMessage) {
    return 'Erreur : $errorMessage';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName activé';
  }

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName désactivé';
  }
}
