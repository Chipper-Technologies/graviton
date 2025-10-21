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
  String get speedLabel => 'Vitesse';

  @override
  String get trailsLabel => 'Traînées';

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
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get selectScenarioTooltip => 'Sélectionner un Scénario';

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
  String get trailColorLabel => 'Couleur des Traînées';

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
  String get cameraControlsLabel => 'Contrôles de Caméra';

  @override
  String get invertPitchControlsLabel => 'Inverser les Contrôles de Tangage';

  @override
  String get invertPitchControlsDescription =>
      'Inverser la direction de glissement haut/bas';

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
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => 'Version';

  @override
  String get loadingVersion => 'Chargement de la version...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => 'Puits Gravitationnels';

  @override
  String get gravityWellsDescription =>
      'Afficher l\'intensité du champ gravitationnel autour des objets';

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
  String bodyStar(int number) {
    return 'Étoile $number';
  }

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
  String get ok => 'OK';

  @override
  String get screenshotMode => 'Mode Capture d\'Écran';

  @override
  String get screenshotModeSubtitle =>
      'Activer des scènes prédéfinies pour les captures marketing';

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
  String get privacyPolicyLabel => 'Privacy Policy';
}
