// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appDescription =>
      'Une simulation physique explorant la dynamique gravitationnelle et la mécanique orbitale. Découvrez la beauté et la complexité du mouvement céleste grâce à la visualisation 3D interactive.';

  @override
  String get appFlavorDevelopment => 'Développement';

  @override
  String get appFlavorProduction => 'Production';

  @override
  String get appInformationCredits => 'Informations sur l\'app et crédits';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => 'Retour';

  @override
  String get bottomNavVisualsLabel => 'Visuels';

  @override
  String get collisionHapticFeedbackDescription =>
      'Activer le retour haptique lorsque les corps célestes entrent en collision pendant la simulation';

  @override
  String get exitFullscreenHint =>
      'Appuyez n\'importe où pour quitter le mode plein écran';

  @override
  String get fullscreenMode => 'Mode Plein Écran';

  @override
  String get fullscreenModeDescription =>
      'Masquer tous les éléments de l\'interface pour une visualisation immersive';

  @override
  String get hapticFeedbackCollisions => 'Retour haptique sur les collisions';

  @override
  String get hapticFeedbackDescription =>
      'Activer le retour haptique pour les interactions UI et les collisions';

  @override
  String get uiHapticFeedbackDescription =>
      'Activer le retour haptique pour les interactions UI comme les boutons, les commutateurs et la navigation';

  @override
  String get displayOptionsTitle => 'Options d\'Affichage';

  @override
  String get pauseButton => 'Pause';

  @override
  String get playButton => 'Lecture';

  @override
  String get presetAsteroidBeltChaos => 'Chaos de la Ceinture d\'Astéroïdes';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Champ dense d\'astéroïdes avec effets gravitationnels';

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
  String get presetCompleteSolarSystem => 'Système Solaire Complet';

  @override
  String get presetCompleteSolarSystemDesc =>
      'Toutes les planètes visibles avec de belles orbites';

  @override
  String get presetEarthMoonSystem => 'Système Terre-Lune';

  @override
  String get presetEarthMoonSystemDesc =>
      'Terre et Lune avec mécanique orbitale visible';

  @override
  String get presetEarthView => 'Vue de la Terre';

  @override
  String get presetEarthViewDesc =>
      'Perspective rapprochée de la Terre avec détail atmosphérique';

  @override
  String get presetGalaxyBlackHole => 'Trou Noir Galactique';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Vue rapprochée du trou noir supermassif au centre galactique';

  @override
  String get presetGalaxyCoreDetail => 'Détail du Noyau Galactique';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Gros plan du centre galactique brillant avec disque d\'accrétion';

  @override
  String get presetGalaxyFormationOverview =>
      'Vue d\'Ensemble de Formation Galactique';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Vue large de la formation de galaxie spirale avec arrière-plan cosmique';

  @override
  String get presetInnerSolarSystem => 'Système Solaire Intérieur';

  @override
  String get presetInnerSolarSystemDesc =>
      'Gros plan de Mercure, Vénus, Terre et Mars avec indicateur de zone habitable';

  @override
  String get presetSaturnRings => 'Anneaux Majestueux de Saturne';

  @override
  String get presetSaturnRingsDesc =>
      'Gros plan de Saturne avec système d\'anneaux détaillé';

  @override
  String get presetThreeBodyBallet => 'Ballet à Trois Corps';

  @override
  String get presetThreeBodyBalletDesc =>
      'Problème classique à trois corps en mouvement élégant';

  @override
  String get resetButton => 'Réinitialiser';

  @override
  String get resetChangelogButton => 'Réinitialiser l\'état du journal';

  @override
  String get resetChangelogDescription =>
      'Réinitialiser le statut de lecture du changelog';

  @override
  String get resetSettingsDescription =>
      'Réinitialiser tous les paramètres aux valeurs par défaut';

  @override
  String get resetTutorialDescription => 'Réinitialiser le progrès du tutoriel';

  @override
  String get simulationCanvasFocused =>
      'Canevas de simulation focalisé - zone principale de simulation physique';

  @override
  String get simulationCanvasHint =>
      'Utilisez les raccourcis clavier pour contrôler la simulation. Espace pour pause, R pour redémarrer, C pour centrer la caméra';

  @override
  String get simulationCanvasLabel => 'Simulation de Physique Gravitationnelle';

  @override
  String get simulationControlsFocused => 'Contrôles de simulation focalisés';

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
  String get simulationSpeed => 'Vitesse de simulation';

  @override
  String get simulationSpeedHint =>
      'Ajustez la vitesse de simulation de 0,1x à 16x vitesse normale. Utilisez les touches fléchées pour de petits incréments.';

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
  String get simulationStats => 'Statistiques de Simulation';

  @override
  String get simulationStepsLabel => 'Étapes de simulation';

  @override
  String get speedDouble => 'Double';

  @override
  String get speedFast => 'Rapide';

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String get speedHalf => 'Demi-Vitesse';

  @override
  String get speedLabel => 'Vitesse';

  @override
  String get speedMaximum => 'Maximum';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedQuarter => 'Vitesse Quart';

  @override
  String get speedVeryFast => 'Très Rapide';

  @override
  String get stopFollowTitle => 'Arrêter de Suivre';

  @override
  String get stopFollowingTooltip => 'Arrêter de Suivre l\'Objet';

  @override
  String get stopRotateTitle => 'Arrêter la Rotation';

  @override
  String get testPresetForUnitTesting =>
      'Préréglage de test pour les tests unitaires';

  @override
  String get trailsLabel => 'Traînées';

  @override
  String get cameraControlsFocused => 'Contrôles de caméra focalisés';

  @override
  String get cameraControlsLabel => 'Contrôles de Caméra';

  @override
  String get cameraDynamicFraming => 'Cadrage Dynamique';

  @override
  String get cameraDynamicFramingDescription =>
      'Ajuste automatiquement le cadrage basé sur le contenu de la scène';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return 'Caméra suivant $bodyName à distance $distance. Rotation automatique : $rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return 'Caméra en mode libre à distance $distance. Rotation automatique : $rotation';
  }

  @override
  String get cameraLabel => 'Caméra';

  @override
  String get cameraManual => 'Contrôle Manuel';

  @override
  String get cameraManualDescription =>
      'Contrôles manuels traditionnels de caméra avec mode suivi';

  @override
  String get cameraPredictiveOrbital => 'Orbital Prédictif';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'L\'IA prédit les trajectoires orbitales pour des mouvements dramatiques de caméra';

  @override
  String get cameraSettingsTitle => 'Paramètres de la Caméra';

  @override
  String get cameraSpeedHint =>
      'Ajuster la vitesse de mouvement de la caméra IA de lente à rapide. Utiliser les touches fléchées pour des changements par petits incréments.';

  @override
  String get cameraSpeedLabel => 'Vitesse de la Caméra';

  @override
  String get cameraTooltip => 'Paramètres de caméra et modes IA';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => 'Distance';

  @override
  String get previewEditortitle => 'Titre de l\'éditeur d\'aperçu';

  @override
  String get setupEditorTitle => 'Configuration';

  @override
  String get rotateLabel => 'Rotation';

  @override
  String get viewPhysicsSettings => 'Voir les paramètres de physique';

  @override
  String get zoomInAction => 'Zoomer';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String get zoomOutAction => 'Dézoomer';

  @override
  String get colorEditor => 'Éditeur de couleur';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return 'Option de couleur $color';
  }

  @override
  String get colorSelector => 'Sélecteur de couleur';

  @override
  String colorOptionTooltip(String colorName) {
    return 'Sélectionner la couleur $colorName pour le corps céleste';
  }

  @override
  String get visualsTooltip => 'Options d\'affichage visuel';

  @override
  String get collisionHapticFeedback => 'Retour Haptique de Collision';

  @override
  String get collisionSensitivity => 'Sensibilité aux collisions';

  @override
  String get gravityColorSchemeClassic => 'Classique';

  @override
  String get gravityColorSchemeEmerald => 'Émeraude';

  @override
  String get gravityColorSchemeMonochrome => 'Monochrome';

  @override
  String get gravityColorSchemeNeon => 'Néon';

  @override
  String get gravityColorSchemeSpectral => 'Spectral';

  @override
  String get gravityEditor => 'Éditeur de gravité';

  @override
  String get gravityFieldColorSchemeDescription =>
      'Choisir le schéma de couleurs pour la visualisation des champs gravitationnels';

  @override
  String get gravityFieldColorSchemeLabel =>
      'Couleurs des Champs Gravitationnels';

  @override
  String get gravityFieldIndicatorsDescription =>
      'Afficher des indicateurs visuels de l\'intensité du champ gravitationnel';

  @override
  String get gravityFieldIndicatorsLabel => 'Indicateurs d\'Intensité du Champ';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => 'Intensité du Champ';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription =>
      'Afficher la visualisation du champ gravitationnel';

  @override
  String get gravityFieldsTitle => 'Champs Gravitationnels';

  @override
  String get relativisticEffectsTitle => 'Effets Relativistes';

  @override
  String get relativisticEffectsDescription =>
      'Appliquer des corrections post-newtoniennes pour les objets à grande vitesse';

  @override
  String get relativisticGlowTitle => 'Lueur Relativiste';

  @override
  String get relativisticGlowDescription =>
      'Visualiser la dilatation du temps avec une lueur basée sur la vélocité';

  @override
  String get tidalForcesTitle => 'Forces de Marée';

  @override
  String get tidalForcesDescription =>
      'Calculer la déformation de marée et les effets de chauffage';

  @override
  String get tidalVisualizationTitle => 'Visualisation des Marées';

  @override
  String get tidalVisualizationDescription =>
      'Afficher le stress de marée et les axes de déformation';

  @override
  String get gravityWellsDescription =>
      'Afficher l\'intensité du champ gravitationnel autour des objets';

  @override
  String get gravityWellsLabel => 'Puits Gravitationnels';

  @override
  String get massKgEditorhint => 'Entrer la masse en kilogrammes';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      'La configuration physique sera implémentée ici-Éditeur';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return 'Champ physique hors de portée';
  }

  @override
  String get physicsSection => 'Physique';

  @override
  String get physicsSettingsDescription => 'Paramètres de simulation';

  @override
  String get physicsSettingsTitle => 'Paramètres de Physique';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return 'Physique : $time unités de temps, $earthYears années terrestres, $steps étapes de simulation terminées';
  }

  @override
  String get physicsTooltip => 'Visualisation et paramètres de physique';

  @override
  String get physicsVisualizationTitle => 'Visualisation de la Physique';

  @override
  String get temperatureCold => 'Froid';

  @override
  String get temperatureEditorlabel => 'Étiquette de l\'éditeur de température';

  @override
  String get temperatureFrozen => 'Gelé';

  @override
  String get temperatureHot => 'Chaud';

  @override
  String get temperatureKEditorhint => 'Entrer la température en Kelvin';

  @override
  String get temperatureCelsiusEditorhint => 'Température (°C)';

  @override
  String get temperatureFahrenheitEditorhint => 'Température (°F)';

  @override
  String get temperatureModerate => 'Modéré';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureScorching => 'Brûlant';

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
  String get velocityMsEditor => 'Éditeur de vitesse m/s';

  @override
  String get addBodyButton => 'Bouton Ajouter un corps';

  @override
  String get tapToEnableAddBodyMode =>
      'Appuyez pour activer le mode d\'ajout de corps - cliquez sur la toile pour placer de nouveaux corps';

  @override
  String get tapToDisableAddBodyMode =>
      'Appuyez pour désactiver le mode d\'ajout de corps et revenir à l\'interaction normale';

  @override
  String get addBodyModeActive => 'Mode Ajout de Corps Actif';

  @override
  String get addBodyModeInactive => 'Mode Ajout de Corps Inactif';

  @override
  String get tapToPlaceBody =>
      'Appuyez n\'importe où sur la toile pour placer un nouveau corps';

  @override
  String get lockInteraction => 'Verrouiller l\'interaction';

  @override
  String get tapToLockInteraction =>
      'Appuyez pour verrouiller - empêche le déplacement accidentel des corps';

  @override
  String get tapToUnlockInteraction =>
      'Appuyez pour déverrouiller - permet de déplacer les corps en les faisant glisser';

  @override
  String get interactionLocked => 'Interaction verrouillée';

  @override
  String get interactionUnlocked => 'Interaction déverrouillée';

  @override
  String get bodyPlacedSuccessfully => 'Corps placé avec succès';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      'Ajouter des corps célestes pour créer votre scénario personnalisé-Éditeur';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      'La ceinture d\'astéroïdes et autres systèmes de particules seront configurés ici-Éditeur';

  @override
  String get beginnerEditor => 'Éditeur débutant';

  @override
  String get noBodiesAdded => 'Aucun corps ajouté pour le moment';

  @override
  String get addBodiesInSetupTab =>
      'Ajouter des corps dans l\'onglet Configuration';

  @override
  String get untitledScenario => 'Scénario sans titre';

  @override
  String get noDescriptionProvided => 'Aucune description fournie';

  @override
  String get collisionSoftening => 'Adoucissement de collision';

  @override
  String get collisionRadius => 'Rayon de collision';

  @override
  String get bodyTypeEditor => 'Éditeur de type de corps';

  @override
  String get createACopyOfThisCelestialBodyEditorHint =>
      'Créer une copie de ce corps céleste-Conseil de l\'éditeur';

  @override
  String get createCustomScenarioButton =>
      'Bouton Créer un scénario personnalisé';

  @override
  String get createCustomScenarioDescription =>
      'Description du scénario personnalisé';

  @override
  String get createScenarioButton => 'Bouton Créer un scénario';

  @override
  String get createScenarioTitle => 'Titre Créer un scénario';

  @override
  String get editScenarioButton => 'Modifier le scénario';

  @override
  String get editScenarioHint => 'Modifier ce scénario';

  @override
  String get editBodyButton => 'Modifier le corps';

  @override
  String get editBodyHint => 'Modifier ce corps céleste';

  @override
  String get deleteScenarioButton => 'Supprimer le scénario';

  @override
  String get deleteScenarioHint => 'Supprimer ce scénario';

  @override
  String get customGravitationalSimulationEditor =>
      'Éditeur de simulation gravitationnelle personnalisée';

  @override
  String get deleteBodyConfirmMessage =>
      'Message de confirmation de suppression du corps';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return 'Titre de confirmation de suppression du corps';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return 'Supprimer $bodyName';
  }

  @override
  String get deleteBodyTooltip => 'Info-bulle Supprimer le corps';

  @override
  String get deleteButton => 'Bouton Supprimer';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return 'Message de confirmation de suppression du scénario';
  }

  @override
  String get deleteScenarioTitle => 'Titre Supprimer le scénario';

  @override
  String deleteScenarioSuccessMessage(String scenarioName) {
    return 'Scénario supprimé avec succès : $scenarioName';
  }

  @override
  String deleteScenarioFailedMessage(String error) {
    return 'Échec de la suppression du scénario : $error';
  }

  @override
  String get editEditorLabel => 'Étiquette de l\'éditeur Modifier';

  @override
  String get editScenarioTitle => 'Titre Modifier le scénario';

  @override
  String get gravitationalForcesEditor =>
      'Éditeur des forces gravitationnelles';

  @override
  String get newScenarioEditor => 'Éditeur de nouveau scénario';

  @override
  String get noBodiesYetEditor => 'Aucun corps encore-Éditeur';

  @override
  String get positionMEditor => 'Éditeur de position m';

  @override
  String get positionMotionEditor => 'Éditeur de position/mouvement';

  @override
  String get propertiesEditor => 'Éditeur de propriétés';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      'Retirer ce corps céleste du scénario-Conseil de l\'éditeur';

  @override
  String get softeningEditor => 'Éditeur d\'adoucissement';

  @override
  String get stellarPropertiesEditor => 'Éditeur de propriétés stellaires';

  @override
  String get trailPointsEditor => 'Éditeur de points de traînée';

  @override
  String get customColor => 'Couleur personnalisée';

  @override
  String get customLabel => 'Étiquette personnalisée';

  @override
  String get customScenarioDescription =>
      'Description du scénario personnalisé';

  @override
  String get viewScenarioButton => 'Voir le scénario';

  @override
  String get viewScenarioHint =>
      'Voir les détails du scénario en mode lecture seule';

  @override
  String get exportScenarioButton => 'Exporter le scénario';

  @override
  String get exportScenarioHint =>
      'Exporter le scénario vers un fichier pour le partager';

  @override
  String exportScenarioFailedMessage(String error) {
    return 'Échec de l\'exportation du scénario';
  }

  @override
  String get exportScenarioNotImplementedMessage =>
      'Exportation du scénario non implémentée';

  @override
  String get saveButton => 'Sauvegarder';

  @override
  String get saveBodyTooltip => 'Sauvegarder le Corps';

  @override
  String get saveNewBodyAccessibility => 'Sauvegarder nouveau corps';

  @override
  String get saveNewBodyHint => 'Crée le corps avec les paramètres actuels';

  @override
  String get saveChangesToBodyAccessibility =>
      'Sauvegarder les modifications du corps';

  @override
  String get saveChangesToBodyHint =>
      'Sauvegarde toutes les modifications apportées à ce corps';

  @override
  String get moreActionsAccessibility => 'Plus d\'actions';

  @override
  String get moreActionsHint =>
      'Ouvrir le menu avec les options dupliquer et supprimer';

  @override
  String get duplicateBodyAccessibility => 'Crée une copie de ce corps';

  @override
  String get deleteBodyAccessibility => 'Supprime définitivement ce corps';

  @override
  String get settingsButtonFocused => 'Bouton Paramètres focalisé';

  @override
  String get settingsMenuDescription => 'Options visuelles et de comportement';

  @override
  String get settingsTooltip => 'Paramètres de l\'Application';

  @override
  String get toggleAutoRotateAction => 'Basculer rotation automatique';

  @override
  String get toggleGravityFieldsTooltip =>
      'Basculer les Champs Gravitationnels';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Basculer l\'État d\'Habitabilité de la Planète';

  @override
  String get toggleHabitableZonesTooltip => 'Basculer les Zones Habitables';

  @override
  String get toggleLabelsTooltip => 'Basculer Étiquettes des Corps';

  @override
  String get toggleStatsTooltip => 'Basculer Statistiques';

  @override
  String get statsLabel => 'Statistiques';

  @override
  String get helpMenuDescription => 'Tutoriel et objectifs';

  @override
  String get tutorialButton => 'Tutoriel';

  @override
  String get tutorialCameraDescription =>
      'Glissez pour faire pivoter la vue, pincez pour zoomer, utilisez deux doigts pour faire rouler la caméra et utilisez trois doigts pour déplacer. La barre inférieure a des contrôles de focus, centrage et rotation automatique pour une expérience cinématographique.';

  @override
  String get tutorialCameraTitle => 'Contrôles de Caméra et Vue';

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
  String get tutorialControlsTitle => 'Contrôles de Simulation';

  @override
  String get tutorialDescription => 'Visite guidée interactive de l\'app';

  @override
  String get tutorialExploreDescription =>
      'Vous êtes maintenant prêt à explorer le cosmos ! Expérimentez avec différents scénarios, ajustez les paramètres, et observez comment la gravité façonne la danse des corps célestes. Profitez de votre voyage à travers l\'univers !';

  @override
  String get tutorialExploreTitle => 'Commencez à Explorer !';

  @override
  String get tutorialNavigationHint =>
      'Glissez gauche/droite ou utilisez les boutons pour naviguer';

  @override
  String get tutorialObjectivesDescription =>
      '• Observer une mécanique orbitale réaliste\n• Explorer différents scénarios astronomiques\n• Expérimenter avec les interactions gravitationnelles\n• Regarder les collisions et fusions\n• Apprendre le mouvement planétaire\n• Découvrir les dynamiques chaotiques à trois corps';

  @override
  String get tutorialObjectivesTitle => 'Que pouvez-vous faire ?';

  @override
  String get tutorialResetMessage =>
      'État du tutoriel réinitialisé ! Redémarrez l\'application pour voir l\'expérience de première utilisation.';

  @override
  String get tutorialResetSuccess =>
      'Le progrès du tutoriel a été réinitialisé';

  @override
  String get tutorialScenariosDescription =>
      'Accédez au menu (⋮) dans le coin supérieur droit pour explorer différents scénarios : notre Système Solaire, dynamiques Terre-Lune, Étoiles Binaires, ou le chaotique Problème à Trois Corps. Chacun offre une physique unique à découvrir !';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Accédez au menu';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'dans le coin supérieur droit pour explorer différents scénarios : notre Système Solaire, dynamiques Terre-Lune, Étoiles Binaires, ou le chaotique Problème à Trois Corps. Chacun offre une physique unique à découvrir !';

  @override
  String get tutorialScenariosTitle => 'Explorer les Scénarios';

  @override
  String get tutorialWelcomeDescription =>
      'Bienvenue dans Graviton, votre fenêtre sur le monde fascinant de la physique gravitationnelle ! Cette application vous permet d\'explorer comment les corps célestes interagissent par la gravité, créant de belles danses orbitales à travers l\'espace et le temps.';

  @override
  String get tutorialWelcomeTitle => 'Bienvenue dans Graviton !';

  @override
  String get welcomeCardDescription =>
      'Explorez la physique gravitationnelle à travers des simulations interactives. Essayez différents scénarios, ajustez les contrôles et regardez le cosmos se déployer !';

  @override
  String get cancel => 'Annuler';

  @override
  String get descriptionEditorLabel => 'Étiquette de l\'éditeur de description';

  @override
  String get next => 'Suivant';

  @override
  String get ok => 'OK';

  @override
  String get previous => 'Précédent';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType changé à $value';
  }

  @override
  String timeFormatted(String time) {
    return '${time}s';
  }

  @override
  String get timeLabel => 'Temps';

  @override
  String get timeScaleStatLabel => 'Échelle de Temps';

  @override
  String get updateLater => 'Plus tard';

  @override
  String get updateNow => 'Mettre à jour maintenant';

  @override
  String get updateRequiredMessage =>
      'Une version plus récente de cette application est disponible. Veuillez mettre à jour pour continuer à utiliser l\'application avec les dernières fonctionnalités et améliorations.';

  @override
  String get updateRequiredTitle => 'Mise à jour requise';

  @override
  String get updateRequiredWarning =>
      'Cette version n\'est plus prise en charge.';

  @override
  String errorLoadingChangelogs(String error) {
    return 'Erreur lors du chargement des journaux de modifications : $error';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Erreur lors de l\'ouverture du lien : $error';
  }

  @override
  String get notificationTypeDebug => 'Débogage';

  @override
  String get notificationTypeInfo => 'Information';

  @override
  String get warningTitle => 'Avertissement';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return 'Annonce d\'accessibilité ignorée - aucune liaison';
  }

  @override
  String get accessibilityCameraFocus =>
      'Caméra focalisée sur le corps céleste le plus proche';

  @override
  String get accessibilityCameraFollow =>
      'La caméra suit maintenant le corps céleste sélectionné';

  @override
  String get accessibilityCameraReset =>
      'Vue caméra réinitialisée à la position par défaut';

  @override
  String get accessibilityCameraUnfollow =>
      'La caméra a cessé de suivre le corps céleste';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return 'Sensibilité de collision changée à $newValue';
  }

  @override
  String accessibilityError(String errorMessage) {
    return 'Erreur : $errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return 'Force de gravité changée à $newValue';
  }

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
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName désactivé';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName activé';
  }

  @override
  String get accessibilitySimulationPaused => 'Simulation en pause';

  @override
  String get accessibilitySimulationPausedContext =>
      'Tous les corps célestes ont cessé de bouger';

  @override
  String get accessibilitySimulationReset => 'Simulation réinitialisée';

  @override
  String get accessibilitySimulationResetContext =>
      'Nouveau scénario chargé avec de nouveaux corps célestes';

  @override
  String get accessibilitySimulationResumed => 'Simulation reprise';

  @override
  String get accessibilitySimulationResumedContext =>
      'Les corps célestes bougent à nouveau';

  @override
  String get accessibilitySimulationStarted => 'Simulation démarrée';

  @override
  String get accessibilitySimulationStartedContext =>
      'Les corps célestes sont maintenant en mouvement';

  @override
  String get accessibilitySimulationStopped => 'Simulation arrêtée';

  @override
  String get accessibilitySimulationStoppedContext =>
      'Tous les corps célestes ont été réinitialisés';

  @override
  String accessibilitySpeedChange(String newValue) {
    return 'Vitesse de simulation changée à $newValue';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return 'Étape du tutoriel $currentStep sur $totalSteps : $stepName';
  }

  @override
  String get changelogAdded => 'Nouvelles fonctionnalités';

  @override
  String get changelogButton => 'Afficher le journal des modifications';

  @override
  String get changelogCategoryAdded => 'Ajouté';

  @override
  String get changelogCategoryFixed => 'Corrigé';

  @override
  String get changelogCategoryImproved => 'Amélioré';

  @override
  String get changelogDescription =>
      'Voir les mises à jour et changements de l\'app';

  @override
  String get changelogDone => 'Terminé';

  @override
  String get changelogFixed => 'Corrections de bugs';

  @override
  String get changelogHometitle =>
      'Titre de la page d\'accueil du journal des modifications';

  @override
  String get changelogImproved => 'Améliorations';

  @override
  String changelogLoadError(String error) {
    return 'Échec du chargement du journal des modifications : $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return 'Aucun journal de modifications trouvé. Ajoutez d\'abord les données du journal à Firestore.\nVersion actuelle : $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return 'Publié le $date';
  }

  @override
  String get changelogResetMessage =>
      'L\'état du journal des modifications a été réinitialisé';

  @override
  String get changelogResetSuccess =>
      'Le statut du changelog a été réinitialisé';

  @override
  String get changelogTitle => 'Nouveautés';

  @override
  String get debugStatisticsTitle => 'Débogage et Statistiques';

  @override
  String errorLoadingChangelogEHome(String error) {
    return 'Erreur de chargement du journal des modifications';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return 'Aucun journal des modifications disponible pour cette version';
  }

  @override
  String get testPreset => 'Préréglage de test';

  @override
  String get testScenarioButton => 'Bouton Scénario de test';

  @override
  String get testScenarioHint => 'Tester le scénario actuel en simulation';

  @override
  String get testScenarioNotImplementedMessage =>
      'Scénario de test non implémenté';

  @override
  String get scenarioEditorMenuHint =>
      'Ouvrir le menu avec les options de test et d\'exportation';

  @override
  String get aboutButtonTooltip => 'À Propos';

  @override
  String get aboutMenuDescription => 'Informations de l\'app et crédits';

  @override
  String get accessAppPreferences =>
      'Accéder aux préférences de l\'application';

  @override
  String get accessScenarioOptions => 'Accéder aux options de scénario';

  @override
  String get adjustSimulationSpeed => 'Ajuster la vitesse de simulation';

  @override
  String get aiCameraModesTitle => 'Modes Caméra IA';

  @override
  String get allRightsReserved => 'Tous droits réservés';

  @override
  String get announcementTitle => 'Annonce';

  @override
  String appliedPreset(String presetName) {
    return 'Scène appliquée : $presetName';
  }

  @override
  String get applyScene => 'Appliquer la Scène';

  @override
  String get atLeastOneBodyIsRequired => 'Au moins un corps est requis';

  @override
  String get authorLabel => 'Auteur';

  @override
  String get autoRotateActive => 'active';

  @override
  String get autoRotateInactive => 'inactive';

  @override
  String get autoRotateLabel => 'Rotation automatique';

  @override
  String get autoRotateOff => 'Désactivé';

  @override
  String get autoRotateOn => 'Activé';

  @override
  String get autoRotateTooltip => 'Rotation Automatique';

  @override
  String get rotateSpeed => 'Vitesse de Rotation';

  @override
  String get blackColor => 'Noir';

  @override
  String get bodies => 'corps';

  @override
  String get bodiesHeaderDescription => 'Description de l\'en-tête des corps';

  @override
  String bodiesHeaderPlural(int count) {
    return 'Corps';
  }

  @override
  String scenariosHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Scénarios',
      one: '1 Scénario',
      zero: 'Aucun Scénario',
    );
    return '$_temp0';
  }

  @override
  String experimentsHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Expériences',
      one: '1 Expérience',
      zero: 'Aucune Expérience',
    );
    return '$_temp0';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return 'Corps dans la simulation : $descriptions';
  }

  @override
  String get bodiesLabel => 'Corps';

  @override
  String get bodyAlpha => 'Alpha';

  @override
  String bodyAsteroid(int number) {
    return 'Astéroïde $number';
  }

  @override
  String get bodyBeta => 'Bêta';

  @override
  String get bodyBlackHole => 'Trou Noir';

  @override
  String get bodyCenterOfMass => 'Centre de Masse';

  @override
  String get bodyCentralStar => 'Étoile Centrale';

  @override
  String bodyColorInvalid(String prefix) {
    return 'Couleur du corps invalide';
  }

  @override
  String get bodyEarth => 'Terre';

  @override
  String get bodyEarthLike => 'Similaire à la Terre';

  @override
  String get bodyGamma => 'Gamma';

  @override
  String bodyIndex(int index) {
    return 'Index du corps';
  }

  @override
  String get bodyNewDefault => 'Nouveau Corps';

  @override
  String get bodyPlacementTooClose =>
      'Trop proche d\'un corps existant - veuillez toucher ailleurs';

  @override
  String get bodyInnerPlanet => 'Planète Intérieure';

  @override
  String get bodyJupiter => 'Jupiter';

  @override
  String get bodyMars => 'Mars';

  @override
  String bodyMassInvalid(String prefix) {
    return 'Masse du corps invalide';
  }

  @override
  String get bodyMercury => 'Mercure';

  @override
  String get bodyMoon => 'Lune';

  @override
  String get bodyMoonM => 'Lune M';

  @override
  String get bodySpacecraft => 'Vaisseau spatial';

  @override
  String get bodyIo => 'Io';

  @override
  String get bodyEuropa => 'Europe';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return 'Copie de $bodyName';
  }

  @override
  String bodyNameRequired(String prefix) {
    return 'Nom du corps requis';
  }

  @override
  String get bodyNeptune => 'Neptune';

  @override
  String bodyNumberTemplate(String number) {
    return 'Corps $number';
  }

  @override
  String get bodyOuterPlanet => 'Planète Extérieure';

  @override
  String get bodyPlanetP => 'Planète P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return 'Composant de position du corps invalide';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return 'Position du corps invalide';
  }

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyPropertiesLuminosity => 'Luminosité Stellaire';

  @override
  String get bodyPropertiesMass => 'Masse';

  @override
  String get bodyPropertiesName => 'Nom';

  @override
  String get bodyPropertiesNameHint => 'Entrer le nom du corps';

  @override
  String get bodyPropertiesRadius => 'Rayon';

  @override
  String get bodyPropertiesMassHint =>
      'Ajuster l\'influence gravitationnelle et la dynamique orbitale';

  @override
  String get bodyPropertiesRadiusHint =>
      'Contrôler la taille et les limites de collision';

  @override
  String get bodyPropertiesTitle => 'Propriétés du Corps';

  @override
  String get bodyPropertiesVelocity => 'Vitesse';

  @override
  String bodyRadiusInvalid(String prefix) {
    return 'Rayon du corps invalide';
  }

  @override
  String bodyRing(int number) {
    return 'Anneau $number';
  }

  @override
  String get bodyRingedPlanet => 'Planète à Anneaux';

  @override
  String get bodyRockyPlanet => 'Planète Rocheuse';

  @override
  String get bodySaturn => 'Saturne';

  @override
  String bodySelectedTemplate(String bodyNumber) {
    return '$bodyNumber sélectionné';
  }

  @override
  String get bodyStarA => 'Étoile A';

  @override
  String get bodyStarB => 'Étoile B';

  @override
  String bodyStarNumber(int number) {
    return 'Étoile $number';
  }

  @override
  String get bodySun => 'Soleil';

  @override
  String get bodySuperEarth => 'Super-Terre';

  @override
  String get bodyTypeAsteroid => 'Astéroïde';

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
  String bodyTypeInvalid(String prefix, String bodyType) {
    return 'Type de corps invalide';
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
  String get bodyTypePlanet => 'Planète';

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
  String get bodyTypeSelector => 'Sélecteur de type de corps';

  @override
  String get bodyTypeStar => 'Étoile';

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
  String get bodyTypeNeutronStar => 'Étoile à Neutrons';

  @override
  String get bodyTypeBlackHole => 'Trou Noir';

  @override
  String get bodyTypeMoon => 'Lune';

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return 'Type de corps: $type';
  }

  @override
  String get bodyTypeTooltipStar =>
      'Corps célestes massifs qui génèrent de la lumière et de la chaleur par fusion nucléaire. Les étoiles sont les principales sources d\'énergie dans les systèmes stellaires.';

  @override
  String get bodyTypeTooltipPlanet =>
      'Grands corps célestes qui orbitent autour d\'étoiles et ont dégagé leur orbite. Les planètes peuvent être rocheuses ou gazeuses et peuvent abriter des lunes.';

  @override
  String get bodyTypeTooltipMoon =>
      'Satellites naturels qui orbitent autour des planètes. Les lunes peuvent influencer les marées et apporter de la stabilité aux systèmes planétaires.';

  @override
  String get bodyTypeTooltipAsteroid =>
      'Petits corps rocheux qui orbitent autour du soleil. Les astéroïdes sont des vestiges de la formation précoce du système solaire.';

  @override
  String get bodyTypeTooltipBlackHole =>
      'Régions de l\'espace-temps avec des champs gravitationnels si intenses que rien, pas même la lumière, ne peut s\'en échapper.';

  @override
  String get bodyTypeTooltipNeutronStar =>
      'Vestiges stellaires extrêmement denses formés lorsque des étoiles massives s\'effondrent. Elles ont des champs gravitationnels et magnétiques incroyablement forts.';

  @override
  String get bodyUranus => 'Uranus';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return 'Composant de vitesse du corps invalide';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return 'Vitesse du corps invalide';
  }

  @override
  String get bodyVenus => 'Vénus';

  @override
  String get bottomSheetFocused => 'Feuille inférieure focalisée';

  @override
  String get bottomSheetLabel => 'Feuille inférieure';

  @override
  String get browseAvailableSimulations =>
      'Parcourir les simulations disponibles';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return 'Corps céleste $name';
  }

  @override
  String get centerLabel => 'Centrer';

  @override
  String get centerViewTooltip => 'Centrer la Vue';

  @override
  String get cinematicCameraTechniqueDescription =>
      'Choisissez comment l\'IA contrôle la caméra lors du suivi d\'objets';

  @override
  String get cinematicCameraTechniqueLabel => 'Technique de Caméra IA';

  @override
  String get cinematicTechniqueDynamicFramingDesc =>
      'Ciblage dramatique en temps réel pour scénarios chaotiques';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      'Tours IA et prédictions orbitales pour scénarios éducatifs';

  @override
  String get closeButton => 'Fermer';

  @override
  String get collapsedState => 'réduit';

  @override
  String get collisionsSection => 'Collisions';

  @override
  String get colorsLabel => 'Couleurs';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ Froid';

  @override
  String copiedToClipboard(String text) {
    return 'Copié dans le presse-papiers : $text';
  }

  @override
  String get copyButton => 'Copier';

  @override
  String get copyrightLabel => 'Droits d\'Auteur';

  @override
  String couldNotOpenUrl(String url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String get crosshairsDescription =>
      'Afficher l\'indicateur de centre d\'écran';

  @override
  String get crosshairsTitle => 'Réticule';

  @override
  String get currentScenario => 'Scénario actuel';

  @override
  String get currentStatisticsTitle => 'Statistiques Actuelles';

  @override
  String get currentlySelected => 'Actuellement sélectionné';

  @override
  String get cyanColor => 'Cyan';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      'Décrire ce que démontre ce scénario-Conseil de l\'éditeur';

  @override
  String get detailsEditorLabel => 'Étiquette de l\'éditeur de détails';

  @override
  String get developerToolsMenuDescription =>
      'Outils de débogage pour le développement';

  @override
  String get developerToolsTitle => 'Outils de Développement';

  @override
  String get difficultyEditorLabel => 'Étiquette de l\'éditeur de difficulté';

  @override
  String get discardButton => 'Bouton Annuler';

  @override
  String get dragToRotateCameraView =>
      'Glisser pour faire pivoter la vue de la caméra';

  @override
  String get dualOrbitalPaths => 'Trajectoires Orbitales Doubles';

  @override
  String get dualOrbitalPathsDescription =>
      'Afficher à la fois les trajectoires orbitales circulaires idéales et elliptiques réelles';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return 'Dupliquer $bodyName';
  }

  @override
  String get duplicateBodyTooltip => 'Info-bulle Dupliquer le corps';

  @override
  String get dynamicFramingDescription =>
      'L\'IA cadre dynamiquement tous les objets';

  @override
  String get earthBlueColor => 'Bleu terrestre';

  @override
  String earthYearsFormatted(String years) {
    return '$years ans';
  }

  @override
  String get earthYearsLabel => 'Années Terrestres';

  @override
  String get educationalFocusBinaryOrbits => 'orbites binaires';

  @override
  String get educationalFocusChaoticDynamics => 'dynamique chaotique';

  @override
  String get educationalFocusManyBodyDynamics => 'dynamique à plusieurs corps';

  @override
  String get educationalFocusPlanetaryMotion => 'mouvement planétaire';

  @override
  String get educationalFocusRealWorldSystem => 'système du monde réel';

  @override
  String get educationalFocusStructureFormation => 'formation de structure';

  @override
  String get educationalObjectivesEditortitle =>
      'Titre de l\'éditeur d\'objectifs éducatifs';

  @override
  String get educationalObjectivesFutureMessage =>
      'Les objectifs éducatifs peuvent être configurés ici dans les futures versions';

  @override
  String get educationalObjectivesListMessage =>
      'Cela comprendra:\n• Objectifs d\'apprentissage\n• Critères de succès\n• Défis guidés\n• Grilles d\'évaluation';

  @override
  String get emergencyNotificationTitle => 'Avis Important';

  @override
  String get enterScenarioNameEditorHint =>
      'Entrer le nom du scénario-Conseil de l\'éditeur';

  @override
  String get equipotentialSurfacesDescription =>
      'Afficher les surfaces d\'égale énergie potentielle gravitationnelle';

  @override
  String get equipotentialSurfacesLabel => 'Surfaces Équipotentielles';

  @override
  String get exit => 'Quitter';

  @override
  String get exitAppMessage => 'Êtes-vous sûr de vouloir quitter Graviton ?';

  @override
  String get exitAppTitle => 'Quitter l\'App';

  @override
  String get expandedState => 'élargi';

  @override
  String failedToSwitchScenarioError(String error) {
    return 'Échec du changement de scénario';
  }

  @override
  String get fieldOfViewLabel => 'Champ de Vision';

  @override
  String get focusOnNearestTooltip =>
      'Se Concentrer sur le Corps le Plus Proche';

  @override
  String get followLabel => 'Suivre';

  @override
  String get followObjectTooltip => 'Suivre l\'Objet Sélectionné';

  @override
  String get getStarted => 'Commencer';

  @override
  String get globalGravityFieldsDescription =>
      'Activer la visualisation des champs gravitationnels pour tous les objets massifs';

  @override
  String get globalGravityFieldsLabel => 'Champs Gravitationnels Globaux';

  @override
  String get gotItButton => 'Compris !';

  @override
  String get gravitationalConstant => 'Constante gravitationnelle';

  @override
  String get greenColor => 'Vert';

  @override
  String get habitabilityHabitable => 'Habitable';

  @override
  String get habitabilityIndicatorsDescription =>
      'Afficher des anneaux d\'état codés par couleur autour des planètes basés sur leur habitabilité';

  @override
  String get habitabilityIndicatorsLabel => 'État de la Planète';

  @override
  String get stellarCoronasTitle => 'Couronnes Stellaires';

  @override
  String get stellarCoronasDescription =>
      'Afficher les atmosphères de plasma brillant autour des étoiles';

  @override
  String get atmosphericEffectsTitle => 'Effets Atmosphériques';

  @override
  String get atmosphericEffectsDescription =>
      'Afficher les halos atmosphériques et la diffusion sur les planètes';

  @override
  String get hemisphereLightingTitle => 'Éclairage Hémisphérique';

  @override
  String get hemisphereLightingDescription =>
      'Simuler un éclairage 3D réaliste sur les corps sphériques';

  @override
  String get castShadowsTitle => 'Ombres Portées';

  @override
  String get castShadowsDescription =>
      'Afficher les ombres lorsque les corps occultent les sources lumineuses';

  @override
  String get specularHighlightsTitle => 'Reflets Spéculaires';

  @override
  String get specularHighlightsDescription =>
      'Afficher les reflets sur les surfaces glacées et aquatiques';

  @override
  String get lightingEffectsLabel => 'Éclairage et Ombres';

  @override
  String get habitabilityLabel => 'Habitabilité';

  @override
  String get habitabilityTooCold => 'Trop Froid';

  @override
  String get habitabilityTooHot => 'Trop Chaud';

  @override
  String get habitabilityUnknown => 'Inconnu';

  @override
  String get habitabilityGasGiant => 'Géante Gazeuse';

  @override
  String get habitabilityTooSmall => 'Trop Petit';

  @override
  String get habitabilityNoAtmosphere => 'Sans Atmosphère';

  @override
  String get habitabilityToxicAtmosphere => 'Atmosphère Toxique';

  @override
  String get habitabilityHighRadiation => 'Radiation Élevée';

  @override
  String get habitabilityTidallyLocked => 'Rotation Synchrone';

  @override
  String get habitabilityExtremeGravity => 'Gravité Extrême';

  @override
  String get habitableZonesDescription =>
      'Afficher des zones colorées autour des étoiles indiquant les régions habitables';

  @override
  String get habitableZonesLabel => 'Zones Habitables';

  @override
  String get hapticsSection => 'Haptique';

  @override
  String get hideUIInScreenshotMode => 'Masquer la Navigation';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'Masquer la barre d\'app, la navigation du bas et le copyright quand le mode capture est actif';

  @override
  String get initialMotionVectorsDescription =>
      'Description des vecteurs de mouvement initial';

  @override
  String invalidJsonFormat(String error) {
    return 'Format JSON invalide';
  }

  @override
  String get invertPitchControlsDescription =>
      'Inverser la direction de glissement haut/bas';

  @override
  String get invertPitchControlsLabel => 'Inverser les Contrôles de Tangage';

  @override
  String get jupiterTanColor => 'Couleur tan de Jupiter';

  @override
  String get keyboardShortcutsHint =>
      'Utilisez Espace pour pause/reprendre, R pour redémarrer, C pour centrer la caméra, A pour basculer la rotation automatique';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => 'Changer la langue de l\'application';

  @override
  String get languageSelectionHint =>
      'Choisissez votre langue d\'affichage préférée';

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
  String get languageLabel => 'Général';

  @override
  String get temperatureUnitsLabel => 'Unités de Température';

  @override
  String get temperatureUnitsDescription =>
      'Unités préférées pour afficher les températures dans l\'application';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => 'Par Défaut du Système';

  @override
  String get lightEnergyOutputDescription =>
      'Description de la sortie d\'énergie lumineuse';

  @override
  String get loadingVersion => 'Chargement de la version...';

  @override
  String get luminosityEditorLabel => 'Étiquette de l\'éditeur de luminosité';

  @override
  String get luminosityWEditorhint =>
      'Entrer la luminosité en watts-Conseil de l\'éditeur';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get manualControlDescription => 'Contrôle manuel complet de la caméra';

  @override
  String get manualControlsTitle => 'Contrôles Manuels';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String get marsRedColor => 'Rouge martien';

  @override
  String get maxTrailPointsInvalid => 'Points de traînée maximum invalides';

  @override
  String get maximum50BodiesAllowed => 'Maximum 50 corps autorisés';

  @override
  String get mercuryGrayColor => 'Gris mercurien';

  @override
  String get missingRequiredFieldBodies => 'Champ requis \'Corps\' manquant';

  @override
  String get missingRequiredFieldConfiguration =>
      'Champ requis \'Configuration\' manquant';

  @override
  String get missingRequiredFieldMetadata =>
      'Champ requis \'Métadonnées\' manquant';

  @override
  String get missingRequiredFieldParticleSystems =>
      'Champ requis \'Systèmes de particules\' manquant';

  @override
  String get missingRequiredFieldPhysics =>
      'Champ requis \'Physique\' manquant';

  @override
  String get missingRequiredFieldVersion => 'Champ requis \'Version\' manquant';

  @override
  String get moreOptionsTooltip => 'Plus d\'options';

  @override
  String get navigationAidsTitle => 'Aides à la Navigation';

  @override
  String get neptuneBlueColor => 'Bleu neptunien';

  @override
  String get newsTitle => 'Actualités';

  @override
  String get nextPreset => 'Scène suivante';

  @override
  String get nextSceneTooltip => 'Info-bulle Scène suivante';

  @override
  String get noActionsAvailable => 'Aucune action disponible';

  @override
  String get noBodiesInSimulation =>
      'Aucun corps céleste dans la simulation actuellement';

  @override
  String get noChangelogsAvailable =>
      'Aucun journal de modifications disponible';

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
  String get objectivesDescription =>
      '• Comprendre comment la gravité façonne le cosmos\n• Observer les systèmes orbitaux stables vs. chaotiques\n• Apprendre pourquoi les planètes bougent en orbites elliptiques\n• Découvrir comment les étoiles binaires interagissent\n• Voir ce qui se passe quand les objets entrent en collision\n• Apprécier la complexité du problème à trois corps';

  @override
  String get objectivesTitle => 'Objectifs';

  @override
  String get offScreenIndicatorsDescription =>
      'Afficher des flèches pointant vers les objets en dehors de la zone visible';

  @override
  String get offScreenIndicatorsTitle => 'Indicateurs Hors Écran';

  @override
  String get orangeColor => 'Orange';

  @override
  String get particleSystemsEditortitle =>
      'Titre de l\'éditeur de systèmes de particules';

  @override
  String get pathVisualizationTitle => 'Visualisation des Trajectoires';

  @override
  String get physicalPropertiesDescription =>
      'Description des propriétés physiques';

  @override
  String get pinchToZoomInOut => 'Pincer pour zoomer/dézoomer';

  @override
  String get pitchLabel => 'Tangage';

  @override
  String get positionEditorLabel => 'Étiquette de l\'éditeur de position';

  @override
  String get predictiveOrbitalDescription =>
      'L\'IA prédit les vues orbitales optimales';

  @override
  String get previousPreset => 'Scène précédente';

  @override
  String get previousSceneTooltip => 'Info-bulle Scène précédente';

  @override
  String get privacyPolicyLabel => 'Politique de Confidentialité';

  @override
  String get promotionTitle => 'Promotion';

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
  String get quickStartDescription =>
      '1. Choisissez un scénario (Système Solaire recommandé pour les débutants)\n2. Appuyez sur Play pour démarrer la simulation\n3. Faites glisser pour faire pivoter votre vue, pincez pour zoomer\n4. Touchez le curseur de Vitesse pour contrôler le temps\n5. Essayez Reset pour de nouvelles configurations aléatoires\n6. Activez les Traces pour voir les trajectoires orbitales';

  @override
  String get quickStartTitle => 'Démarrage Rapide';

  @override
  String get quickTutorialButton => 'Tutoriel Rapide';

  @override
  String get radiusMEditorhint =>
      'Entrer le rayon en mètres-Conseil de l\'éditeur';

  @override
  String get realisticColors => 'Couleurs Réalistes';

  @override
  String get realisticColorsDescription =>
      'Utiliser des couleurs scientifiquement précises basées sur la température et la classification stellaire';

  @override
  String get redColor => 'Rouge';

  @override
  String get rollLabel => 'Roulis';

  @override
  String get saturnCreamColor => 'Couleur crème de Saturne';

  @override
  String get scenarioAsteroidBelt => 'Ceinture d\'Astéroïdes';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Étoile centrale entourée d\'une ceinture d\'astéroïdes rocheux et de débris';

  @override
  String get scenarioBestBinary =>
      'Idéal pour : Exploration avancée de physique';

  @override
  String get scenarioBestEarthMoon =>
      'Idéal pour : Comprendre le système Terre-Lune';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom =>
      'Idéal pour : Exploration et expérimentation';

  @override
  String get scenarioBestSolar =>
      'Idéal pour : Débutants, passionnés d\'astronomie';

  @override
  String get scenarioBestThreeBody =>
      'Idéal pour : Passionnés de physique mathématique';

  @override
  String get scenarioBinaryStars => 'Étoiles Binaires';

  @override
  String get scenarioBinaryStarsDescription =>
      'Deux étoiles massives en orbite l\'une autour de l\'autre avec des planètes circumbinaires';

  @override
  String get scenarioCustom => 'Scénario personnalisé';

  @override
  String get scenarioCustomDescription =>
      'Description du scénario personnalisé';

  @override
  String get scenarioEarthMoonSun => 'Terre-Lune-Soleil';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Simulation éducative de notre système familier Terre-Lune-Soleil';

  @override
  String get scenarioGalaxyFormation => 'Formation de Galaxie';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Observez la matière s\'organiser en structures spirales autour d\'un trou noir central';

  @override
  String get scenarioInformationEditortitle =>
      'Titre de l\'éditeur d\'informations de scénario';

  @override
  String get scenarioLearnBinary =>
      'Apprendre : Évolution stellaire, systèmes binaires, gravité extrême';

  @override
  String get scenarioLearnEarthMoon =>
      'Apprendre : Dynamiques à trois corps, mécanique lunaire, forces de marée';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom =>
      'Apprendre : Découvrir des configurations inconnues, physique expérimentale';

  @override
  String get scenarioLearnSolar =>
      'Apprendre : Mouvement planétaire, mécanique orbitale, corps célestes familiers';

  @override
  String get scenarioLearnThreeBody =>
      'Apprendre : Théorie du chaos, mouvement imprévisible, systèmes instables';

  @override
  String get scenarioNameRequired => 'Nom de scénario requis';

  @override
  String get scenarioNameTooLong => 'Nom du scénario trop long';

  @override
  String get scenarioPlanetaryRings => 'Anneaux Planétaires';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Dynamique du système d\'anneaux autour d\'une planète massive comme Saturne';

  @override
  String get scenarioRandom => 'Système Aléatoire';

  @override
  String get scenarioRandomDescription =>
      'Système chaotique à trois corps généré aléatoirement avec une dynamique imprévisible';

  @override
  String scenarioSaveFailedMessage(String error) {
    return 'Échec de la sauvegarde du scénario';
  }

  @override
  String get scenarioSavedSuccessMessage => 'Scénario sauvegardé avec succès';

  @override
  String get scenarioSelectorFocused => 'Sélecteur de scénario focalisé';

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
  String get scenariosAvailable => 'scénarios disponibles';

  @override
  String get scenariosMenuDescription => 'Explorer différents scénarios';

  @override
  String get sceneActive => 'Scène active - simulation pausée pour capture';

  @override
  String get scenePreset => 'Scène Prédéfinie';

  @override
  String get scheduledMaintenanceInProgress =>
      'Maintenance programmée en cours';

  @override
  String screenshotCountdown(int seconds) {
    return 'Capture dans ${seconds}s';
  }

  @override
  String get screenshotMode => 'Mode Capture d\'Écran';

  @override
  String get screenshotModeSubtitle =>
      'Activer des scènes prédéfinies pour les captures marketing';

  @override
  String get selectAColorForTheCelestialBody =>
      'Sélectionner une couleur pour le corps céleste';

  @override
  String get selectNearestTitle => 'Sélectionner le Plus Proche';

  @override
  String get selectObjectToFollowTooltip => 'Sélectionner un Objet à Suivre';

  @override
  String get selectScenarioTooltip => 'Sélectionner un Scénario';

  @override
  String get selectTheTypeOfCelestialBody =>
      'Sélectionner le type de corps céleste';

  @override
  String get selectedStatLabel => 'Sélectionné';

  @override
  String get showHelpTooltip => 'Afficher l\'Aide';

  @override
  String get showLabelsDescription =>
      'Afficher les noms des corps célestes dans la simulation';

  @override
  String get showLabelsTitle => 'Afficher les Étiquettes';

  @override
  String get showOrbitalPaths => 'Afficher les Trajectoires Orbitales';

  @override
  String get showOrbitalPathsDescription =>
      'Afficher les trajectoires orbitales prédites dans les scénarios avec des orbites stables';

  @override
  String get showStatisticsDescription =>
      'Afficher les statistiques de performance et de physique';

  @override
  String get showStatisticsTitle => 'Afficher les Statistiques';

  @override
  String get showTrails => 'Afficher les Traînées';

  @override
  String get showTrailsDescription =>
      'Afficher les traînées de mouvement derrière les objets';

  @override
  String get showTutorialTooltip => 'Afficher le Tutoriel';

  @override
  String get skipTutorial => 'Passer le Tutoriel';

  @override
  String get softeningParameter => 'Paramètre d\'adoucissement';

  @override
  String get spatialCoordinatesDescription =>
      'Description des coordonnées spatiales';

  @override
  String get statusError => 'Erreur';

  @override
  String get statusLabel => 'État';

  @override
  String get statusPaused => 'En pause';

  @override
  String get statusRunning => 'En cours';

  @override
  String get statusStopped => 'Arrêté';

  @override
  String get stellarColorBlue => 'Bleu';

  @override
  String get stellarColorBlueWhite => 'Bleu-blanc';

  @override
  String get stellarColorOrange => 'Orange';

  @override
  String get stellarColorRed => 'Rouge';

  @override
  String get stellarColorWhite => 'Blanc';

  @override
  String get stellarColorYellow => 'Jaune';

  @override
  String get stellarColorYellowWhite => 'Blanc-jaune';

  @override
  String get stellarTemperatureDescription =>
      'Description de la température stellaire';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => 'Étapes';

  @override
  String get successTitle => 'Succès';

  @override
  String get swipeUpToExpand => 'Glisser vers le haut pour développer';

  @override
  String get tapPlayPauseButton => 'Appuyer sur le bouton Lecture/Pause';

  @override
  String get tapResetButton => 'Appuyer sur le bouton Réinitialiser';

  @override
  String get tapToCenterCamera => 'Appuyer pour centrer la caméra';

  @override
  String get tapToChangeScenario => 'Appuyer pour changer de scénario';

  @override
  String get tapToInteractWithSimulation =>
      'Appuyer pour interagir avec la simulation';

  @override
  String get tapToOpenSettings => 'Appuyer pour ouvrir les paramètres';

  @override
  String get tapToSelect => 'Appuyer pour sélectionner';

  @override
  String get tapToToggleAutoRotation =>
      'Appuyer pour activer/désactiver la rotation automatique';

  @override
  String get tapToToggleFullscreen => 'Appuyez pour basculer en plein écran';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return 'Appuyer pour voir et modifier les détails-Corps-Type de corps-Nom avec numéro-Utils-Format-Masse-Masse du corps-Conseil de l\'éditeur';
  }

  @override
  String get trackingModeEssential => 'Essentiel Seulement';

  @override
  String get trackingModeEssentialDescription =>
      'Crashs critiques et erreurs seulement';

  @override
  String get trackingModeFull => 'Suivi Complet';

  @override
  String get trackingModeFullDescription =>
      'Toutes les analyses, crashs et interactions';

  @override
  String get trackingModeLimited => 'Suivi Limité';

  @override
  String get trackingModeLimitedDescription =>
      'Interactions utilisateur seulement';

  @override
  String get trackingModeNone => 'Aucun Suivi';

  @override
  String get trackingModeNoneDescription => 'Aucune collecte de données';

  @override
  String get trailColorLabel => 'Couleur de Traînée';

  @override
  String get trailFadeRate => 'Taux de fondu des traces';

  @override
  String get trailLength => 'Longueur des traces';

  @override
  String get typeEditorLabel => 'Étiquette de l\'éditeur de type';

  @override
  String get uiHapticFeedback => 'Retour Haptique UI';

  @override
  String get unsavedChangesMessage =>
      'Message de modifications non sauvegardées';

  @override
  String get unsavedChangesTitle => 'Modifications non sauvegardées';

  @override
  String get uranusCyanColor => 'Couleur cyan d\'Uranus';

  @override
  String get useKeyboardShortcutsForControls =>
      'Utiliser les raccourcis clavier pour les contrôles';

  @override
  String get useZoomControls => 'Utiliser les contrôles de zoom';

  @override
  String get venusYellowColor => 'Couleur jaune de Vénus';

  @override
  String get versionLabel => 'Version';

  @override
  String get versionStatusCurrent => 'Actuel';

  @override
  String get versionStatusOutdated => 'Obsolète';

  @override
  String get vibrationEnabled => 'Vibration activée';

  @override
  String get vibrationThrottle => 'Limitation de vibration';

  @override
  String get warmTrails => '🔥 Chaud';

  @override
  String get websiteLabel => 'Site Web';

  @override
  String get whatToDoDescription =>
      'Explorez les contrôles, expérimentez avec différents scénarios, et observez comment la gravité affecte le mouvement des objets célestes.';

  @override
  String get whatToDoTitle => 'Que faire ?';

  @override
  String get whiteColor => 'Blanc';

  @override
  String get xCoordinateEditorhint =>
      'Entrer la coordonnée X-Conseil de l\'éditeur';

  @override
  String get xCoordinateLabel => 'Étiquette de coordonnée X';

  @override
  String get xVelocityEditorhint => 'Entrer la vitesse X-Conseil de l\'éditeur';

  @override
  String get yCoordinateEditorhint =>
      'Entrer la coordonnée Y-Conseil de l\'éditeur';

  @override
  String get yCoordinateLabel => 'Étiquette de coordonnée Y';

  @override
  String get yVelocityEditorhint => 'Entrer la vitesse Y-Conseil de l\'éditeur';

  @override
  String get yawLabel => 'Lacet';

  @override
  String get yellowColor => 'Jaune';

  @override
  String get zCoordinateEditorhint =>
      'Entrer la coordonnée Z-Conseil de l\'éditeur';

  @override
  String get zCoordinateLabel => 'Étiquette de coordonnée Z';

  @override
  String get zVelocityEditorhint => 'Entrer la vitesse Z-Conseil de l\'éditeur';

  @override
  String orbitalEventCloseApproach(String distance) {
    return 'Approche rapprochée : $distance unités';
  }

  @override
  String get accessibilityBodiesCombined =>
      'La masse combinée crée un nouveau corps céleste';

  @override
  String get accessibilityBodiesInMotion =>
      'Les corps célestes sont maintenant en mouvement';

  @override
  String get accessibilityBodiesStopped =>
      'Tous les corps célestes ont cessé de bouger';

  @override
  String get accessibilityBodiesResumed =>
      'Les corps célestes bougent à nouveau';

  @override
  String get accessibilityBodiesReset =>
      'Tous les corps célestes ont été réinitialisés';

  @override
  String get accessibilityNewScenarioLoaded =>
      'Nouveau scénario chargé avec de nouveaux corps célestes';

  @override
  String get accessibilityNewParametersLoaded =>
      'Nouveaux corps célestes et paramètres physiques chargés';

  @override
  String get scenarioTabPresets => 'Préréglages';

  @override
  String get scenarioTabCustom => 'Personnalisé';

  @override
  String get savedScenariosTitle => 'Scénarios Sauvegardés';

  @override
  String get experimentsTitle => 'Expériences';

  @override
  String get experimentsSubtitle =>
      'Explorer des concepts physiques intéressants';

  @override
  String customScenarioBodyCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count corps célestes',
      one: '1 corps céleste',
    );
    return '$_temp0';
  }

  @override
  String get customScenarioCreatedToday => 'Créé aujourd\'hui';

  @override
  String get customScenarioCreatedYesterday => 'Créé hier';

  @override
  String customScenarioCreatedDaysAgo(int count, Object days) {
    return 'Créé il y a $days jours';
  }

  @override
  String customScenarioCreatedWeeksAgo(int count, Object weeks) {
    return 'Créé il y a $weeks semaines';
  }

  @override
  String customScenarioCreatedMonthsAgo(int count, Object months) {
    return 'Créé il y a $months mois';
  }

  @override
  String get customScenarioCreatedUnknown => 'Date de création inconnue';

  @override
  String get orbitalPlacementEditor => 'Placement Orbital';

  @override
  String get placeInOrbitButton => 'Placer en Orbite';

  @override
  String get centralBodySelector => 'Corps Central';

  @override
  String get orbitRadiusEditor => 'Rayon Orbital';

  @override
  String get orbitPhaseEditor => 'Phase Orbitale';

  @override
  String get orbitInclinationEditor => 'Inclinaison';

  @override
  String get circularOrbitOption => 'Orbite Circulaire';

  @override
  String get ellipticalOrbitOption => 'Orbite Elliptique';

  @override
  String orbitalPeriodDisplay(String period) {
    return 'Période: $period';
  }

  @override
  String get noAvailableCentralBodies =>
      'Aucun autre corps disponible pour le placement orbital';

  @override
  String get orbitalPlacementDescription =>
      'Configurer ce corps pour qu\'il orbite autour d\'un autre corps céleste avec une physique réaliste';

  @override
  String get orbitalPlacementActiveDescription =>
      'Le placement orbital est actif. La position et la vitesse seront calculées automatiquement en fonction des paramètres orbitaux ci-dessous.';

  @override
  String get showGravitationalFieldVisualization =>
      'Afficher la visualisation du champ gravitationnel pour ce corps';

  @override
  String get cancelOrbitalPlacement => 'Annuler le Placement Orbital';

  @override
  String get makeStable => 'Rendre Stable';

  @override
  String get orbitalWarningMassiveBody =>
      '⚠️ Avertissement: Le corps en orbite est très massif par rapport au corps central. Cela peut causer des orbites instables ou les corps peuvent orbiter l\'un autour de l\'autre.';

  @override
  String get orbitalTipSignificantMass =>
      '💡 Astuce: C\'est un rapport de masse significatif. Considérez augmenter la distance orbitale pour la stabilité.';

  @override
  String get orbitalWarningCloseOrbit =>
      '⚠️ Avertissement: Orbite très proche. Risque de collision ou de perturbation de marée.';

  @override
  String get orbitalTipDistantOrbit =>
      '💡 Astuce: Orbite distante. L\'influence gravitationnelle d\'autres corps peut perturber cette orbite.';

  @override
  String get orbitalGoodConfiguration =>
      '✅ Bonne configuration orbitale pour un système stable.';

  @override
  String get orbitalError => 'Erreur';

  @override
  String get orbitalConfigurationWarning =>
      'Cette configuration orbitale peut mener à des collisions ou des éjections. Considérez utiliser le bouton \"Rendre Stable\".';

  @override
  String get defaultBodyName => 'Corps Céleste';

  @override
  String get orbitalPeriodLabel => 'Période Orbitale';

  @override
  String get orbitIsStable => 'L\'Orbite est Stable';

  @override
  String get orbitMayBeUnstable => 'L\'Orbite Peut Être Instable';

  @override
  String bodyTypeGeneric(String bodyType) {
    return 'corps $bodyType';
  }

  @override
  String orbitalRadiusIncreasedFeedback(String amount) {
    return 'augmenté de $amount unités';
  }

  @override
  String orbitalRadiusDecreasedFeedback(String amount) {
    return 'diminué de $amount unités';
  }

  @override
  String get orbitalRadiusFineTunedFeedback => 'affiné';

  @override
  String orbitStabilizedMessage(String changeDescription, String finalRadius) {
    return 'Orbite stabilisée ! Rayon $changeDescription à $finalRadius unités. Phase et inclinaison réinitialisées pour la stabilité.';
  }

  @override
  String get experimentBinaryPulsarName => 'Pulsar Binaire';

  @override
  String get experimentBinaryPulsarDescription =>
      'Deux étoiles à neutrons spiralent vers l\'intérieur en raison des ondes gravitationnelles';

  @override
  String get experimentBinaryPulsarDuration => '100 ans';

  @override
  String get binaryPulsarPulsarA => 'Pulsar A';

  @override
  String get binaryPulsarNeutronStarB => 'Étoile à neutrons B';

  @override
  String get binaryPulsarScenarioDescription =>
      'Ce scénario démontre : les champs gravitationnels extrêmes, les effets relativistes, l\'émission d\'ondes gravitationnelles et la décroissance orbitale. Les étoiles à neutrons spiraleront lentement vers l\'intérieur au fil du temps, fusionnant finalement dans une collision catastrophique qui produit des ondes gravitationnelles.';

  @override
  String get binaryPulsarAuthor => 'Expériences de Physique Graviton';

  @override
  String get binaryPulsarEducationalFocus =>
      'Relativité et Ondes Gravitationnelles';

  @override
  String get experimentTrojanAsteroidsName => 'Astéroïdes Troyens';

  @override
  String get experimentTrojanAsteroidsDescription =>
      'Points stables dans l\'orbite de Jupiter où s\'accumulent les astéroïdes';

  @override
  String get experimentTrojanAsteroidsDuration => '50 ans';

  @override
  String get trojanAsteroidsSun => 'Soleil';

  @override
  String get trojanAsteroidsJupiter => 'Jupiter';

  @override
  String trojanAsteroidsL4Name(int number) {
    return 'Troyen L4 $number';
  }

  @override
  String trojanAsteroidsL5Name(int number) {
    return 'Troyen L5 $number';
  }

  @override
  String get trojanAsteroidsScenarioDescription =>
      'Ce scénario démontre : les points de Lagrange, la mécanique orbitale stable, la dynamique à trois corps et l\'équilibre gravitationnel. Les astéroïdes troyens restent dans des positions stables 60° devant et derrière Jupiter, piégés dans l\'équilibre gravitationnel.';

  @override
  String get trojanAsteroidsEducationalFocus =>
      'Points de Lagrange et Stabilité Orbitale';

  @override
  String get experimentDoubleStarEclipseName => 'Éclipse d\'Étoile Double';

  @override
  String get experimentDoubleStarEclipseDescription =>
      'Système d\'étoile binaire où une étoile éclipse régulièrement l\'autre';

  @override
  String get experimentDoubleStarEclipseDuration => '30 jours';

  @override
  String get experimentRoguePlanetName => 'Planète Vagabonde';

  @override
  String get experimentRoguePlanetDescription =>
      'Une planète éjectée de son système rencontre un nouveau système solaire';

  @override
  String get experimentRoguePlanetDuration => '500 ans';

  @override
  String get experimentGravitationalSlingshotName => 'Fronde Gravitationnelle';

  @override
  String get experimentGravitationalSlingshotDescription =>
      'Un vaisseau spatial utilise la lune de Jupiter Io pour prendre de la vitesse et atteindre Europe';

  @override
  String get experimentGravitationalSlingshotDuration => '2 ans';

  @override
  String get experimentDifficultyAdvanced => 'avancé';

  @override
  String get experimentDifficultyIntermediate => 'intermédiaire';

  @override
  String get experimentDifficultyBeginner => 'débutant';

  @override
  String experimentComingSoon(String scenarioName) {
    return 'Scénario expérimental \"$scenarioName\" - Bientôt disponible !';
  }

  @override
  String get unknownValue => 'Inconnu';

  @override
  String get bodyPrimaryStar => 'Étoile Primaire';

  @override
  String get bodySecondaryStar => 'Étoile Secondaire';

  @override
  String get bodyInnerRockyPlanet => 'Planète Rocheuse Intérieure';

  @override
  String get bodyHabitablePlanet => 'Planète Habitable';

  @override
  String get bodyGasGiant => 'Géante Gazeuse';

  @override
  String get bodyIceGiant => 'Géante de Glace';

  @override
  String get bodyRoguePlanet => 'Planète Errante';

  @override
  String get authorGravitonPhysicsTeam => 'Équipe de Physique Graviton';

  @override
  String get doubleStarEclipseScenarioDescription =>
      'Regardez comment deux étoiles orbitent l\'une autour de l\'autre dans un système binaire proche. Observez comment l\'étoile secondaire plus petite passe régulièrement devant l\'étoile primaire plus grande, causant des éclipses périodiques. Cela démontre la photométrie stellaire, la mécanique orbitale binaire et comment les astronomes découvrent les exoplanètes en utilisant des méthodes de transit similaires.';

  @override
  String get doubleStarEclipseEducationalFocus =>
      'Étoiles binaires, éclipses, photométrie stellaire';

  @override
  String get roguePlanetScenarioDescription =>
      'Un système solaire stable avec des orbites planétaires bien espacées rencontre une planète errante massive approchant de l\'espace interstellaire. Regardez comment la gravité de l\'intrus perturbe l\'équilibre orbital délicat, éjectant potentiellement des planètes ou créant des interactions gravitationnelles chaotiques. Ce scénario démontre la dynamique des systèmes planétaires, les effets de fronde gravitationnelle et comment les planètes errantes peuvent remodeler des systèmes solaires entiers.';

  @override
  String get roguePlanetEducationalFocus =>
      'Planètes errantes, rencontres gravitationnelles, perturbation orbitale';

  @override
  String get simulationInfoTitle => 'Info de Simulation';

  @override
  String get scenarioInfoTitle => 'Info de Scénario';

  @override
  String get scenarioNameLabel => 'Nom de Scénario';

  @override
  String get bodyStatisticsTitle => 'Statistiques des Corps';

  @override
  String get totalBodiesLabel => 'Corps Totaux';

  @override
  String get starsLabel => 'Étoiles';

  @override
  String get planetsLabel => 'Planètes';

  @override
  String get asteroidsLabel => 'Astéroïdes';

  @override
  String get blackHolesLabel => 'Trous Noirs';

  @override
  String get totalMassLabel => 'Masse Totale';

  @override
  String get habitableWorldsLabel => 'Mondes Habitables';

  @override
  String get physicsInfoTitle => 'Info de Physique';

  @override
  String get timeScaleLabel => 'Échelle de Temps';

  @override
  String get gravitationalConstantLabel => 'Constante Gravitationnelle';

  @override
  String get softeningParameterLabel => 'Paramètre d\'Adoucissement';

  @override
  String get collisionRadiusLabel => 'Rayon de Collision';

  @override
  String get scenarioThreeBodyClassic => 'Problème Classique des Trois Corps';

  @override
  String get scenarioThreeBodyClassicDescription =>
      'Le problème classique des trois corps avec dynamique chaotique';

  @override
  String get scenarioCollisionDemo => 'Démo de Collision';

  @override
  String get scenarioCollisionDemoDescription =>
      'Démonstration de collisions entre corps célestes';

  @override
  String get scenarioDeepSpace => 'Espace Profond';

  @override
  String get scenarioDeepSpaceDescription =>
      'Objets aléatoires dans l\'espace profond';

  @override
  String get systemEnergyLabel => 'Énergie du Système';

  @override
  String get kineticEnergyLabel => 'Énergie Cinétique';

  @override
  String get potentialEnergyLabel => 'Énergie Potentielle';

  @override
  String get angularMomentumLabel => 'Moment Angulaire';

  @override
  String get centerOfMassLabel => 'Centre de Masse';

  @override
  String get velocityRangeLabel => 'Plage de Vitesse';

  @override
  String get averageVelocityLabel => 'Vitesse Moyenne';

  @override
  String get temperatureRangeLabel => 'Plage de Température';

  @override
  String get systemMomentumLabel => 'Moment du Système';

  @override
  String get energyDynamicsTitle => 'Énergie et Dynamique';

  @override
  String get orbitalMechanicsTitle => 'Mécanique Orbitale';

  @override
  String get celestialBodiesTitle => 'Corps Célestes';

  @override
  String get bodyNameLabel => 'Nom du Corps';

  @override
  String get bodyMassLabel => 'Masse du Corps';

  @override
  String get bodyRadiusLabel => 'Rayon du Corps';

  @override
  String get bodyVelocityLabel => 'Vitesse du Corps';

  @override
  String get bodyTemperatureLabel => 'Température du Corps';

  @override
  String get bodyLuminosityLabel => 'Luminosité du Corps';

  @override
  String get bodyPositionLabel => 'Position du Corps';

  @override
  String get bodyTypeLabel => 'Type de Corps';

  @override
  String get bodyHabitabilityLabel => 'Habitabilité du Corps';

  @override
  String get bodyKineticEnergyLabel => 'Énergie Cinétique du Corps';

  @override
  String get bodyEscapeVelocityLabel => 'Vitesse d\'Évasion';

  @override
  String get bodyDistanceFromCenterLabel => 'Distance au Centre';

  @override
  String get bodyOrbitalPeriodLabel => 'Période Orbitale';

  @override
  String get notApplicableValue => 'N/A';

  @override
  String get habitableStatus => 'Habitable';

  @override
  String get unknownHabitabilityStatus => 'Inconnu';

  @override
  String get tooHotStatus => 'Trop chaud';

  @override
  String get tooColdStatus => 'Trop froid';

  @override
  String get noAtmosphereStatus => 'Pas d\'Atmosphère';

  @override
  String get selectBody => 'Sélectionner le Corps';

  @override
  String get noBodiesAvailable => 'Aucun corps disponible';

  @override
  String get share => 'Partager';

  @override
  String get shareSimulation => 'Partager la Simulation';

  @override
  String get shareImage => 'Partager l\'Image';

  @override
  String get shareImageDescription => 'Capturer et partager la vue actuelle';

  @override
  String get shareState => 'Partager l\'état';

  @override
  String get shareStateDescription =>
      'Exporter les données de simulation sous forme de fichier importable';

  @override
  String get shareSuccess => 'Partagé avec succès';

  @override
  String get shareFailed => 'Échec du partage';

  @override
  String get shareImageError =>
      'Impossible de capturer l\'image. Veuillez réessayer.';

  @override
  String get shareSubject => 'Simulation Graviton';

  @override
  String get shareSnapshotSubject => 'Instantané de simulation Graviton';

  @override
  String get shareText => 'Découvrez cette simulation gravitationnelle !';

  @override
  String get importScenario => 'Importer un scénario';

  @override
  String get importScenarioDescription =>
      'Charger un scénario à partir d\'un fichier JSON';

  @override
  String get importSuccess => 'Scénario importé avec succès';

  @override
  String get importFailed => 'Échec de l\'importation du scénario';

  @override
  String get importInvalidFile =>
      'Format de fichier non valide. Veuillez sélectionner un fichier JSON valide.';

  @override
  String get importFileNotFound => 'Fichier introuvable. Veuillez réessayer.';

  @override
  String get importCancelled => 'Importation annulée';

  @override
  String get accountManagementTitle => 'Compte';

  @override
  String get accountButtonTooltip => 'Compte et profil';

  @override
  String get signInPromptTitle => 'Connectez-vous à votre compte';

  @override
  String get signInPromptMessage =>
      'Créez un compte ou connectez-vous pour synchroniser vos données et préférences entre appareils.';

  @override
  String get signInButton => 'Se connecter';

  @override
  String get signOutButton => 'Se déconnecter';

  @override
  String get resetSessionButton => 'Réinitialiser la session';

  @override
  String get signOutSuccess => 'Déconnexion réussie';

  @override
  String get operationTimeout => 'L\'opération a expiré. Veuillez réessayer.';

  @override
  String get operationFailed => 'L\'opération a échoué. Veuillez réessayer.';

  @override
  String get couldNotOpenLink =>
      'Impossible d\'ouvrir le lien. Veuillez réessayer.';

  @override
  String get pleaseWaitBeforeRetrying =>
      'Veuillez patienter un instant avant de réessayer.';

  @override
  String rateLimitWithCooldown(int seconds) {
    return 'Veuillez attendre $seconds secondes avant de réessayer.';
  }

  @override
  String get networkError =>
      'Erreur réseau. Veuillez vérifier votre connexion et réessayer.';

  @override
  String get continueAsGuestButton => 'Continuer en tant qu\'invité';

  @override
  String get signInAnonymousSuccess => 'Connecté en tant qu\'invité';

  @override
  String get anonymousUserLabel => 'Utilisateur invité';

  @override
  String get guestAccountLabel => 'Compte invité';

  @override
  String get authenticatedLabel => 'Compte';

  @override
  String get changeAvatarTooltip => 'Changer l\'avatar';

  @override
  String get editDisplayNameTooltip => 'Modifier le nom';

  @override
  String get accountActionsSection => 'Actions du compte';

  @override
  String get upgradeAccountTitle => 'Passer au compte complet';

  @override
  String get upgradeAccountDescription =>
      'Enregistrez vos données et accédez-y depuis n\'importe quel appareil';

  @override
  String get accountManagementSection => 'Gestion du compte';

  @override
  String get dangerZoneSection => 'Gestion du compte';

  @override
  String get deleteAccountButton => 'Supprimer le compte';

  @override
  String get avatarChangedSuccess => 'Avatar mis à jour avec succès';

  @override
  String get avatarChangedError => 'Échec de la mise à jour de l\'avatar';

  @override
  String get accountMenuDescription => 'Gérer votre compte et profil';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get createAccountButton => 'Créer un compte';

  @override
  String get pleaseEnterEmail => 'Veuillez saisir votre e-mail';

  @override
  String get pleaseEnterValidEmail => 'Veuillez saisir un e-mail valide';

  @override
  String get pleaseEnterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? Se connecter';

  @override
  String get needAccount => 'Besoin d\'un compte ? En créer un';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithGitHub => 'Continuer avec GitHub';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get moreProviders => 'Plus de Fournisseurs';

  @override
  String get chooseProvider => 'Choisir le Fournisseur';

  @override
  String get selectAvatarTitle => 'Sélectionner un avatar';

  @override
  String get editAccountInformationTitle => 'Modifier le nom d\'affichage';

  @override
  String get displayNameLabel => 'Nom d\'affichage';

  @override
  String get pleaseEnterDisplayName => 'Veuillez saisir un nom d\'affichage';

  @override
  String get displayNameMinLength =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountWarning => 'Cette action ne peut pas être annulée.';

  @override
  String get deleteAccountMessage =>
      'La suppression de votre compte supprimera définitivement toutes les données qui y sont associées.';

  @override
  String get deleteAccountItem1 => 'Votre profil et avatar';

  @override
  String get deleteAccountItem2 => 'Toutes les préférences enregistrées';

  @override
  String get deleteAccountItem3 => 'Scénarios et paramètres personnalisés';

  @override
  String get deleteAccountItem4 => 'Authentification du compte';

  @override
  String get deleteAccountPasswordPrompt =>
      'Veuillez saisir votre mot de passe pour confirmer :';

  @override
  String get orDivider => 'OU';

  @override
  String get displayNameHint => 'Entrez votre nom (facultatif)';

  @override
  String get emailHint => 'Votre adresse e-mail';

  @override
  String get passwordHint => 'Votre mot de passe';

  @override
  String get alreadyHaveAccountSignIn =>
      'Vous avez déjà un compte ? Se connecter';

  @override
  String get needAccountCreateOne => 'Vous n\'avez pas de compte ? En créer un';

  @override
  String get useGoogleProfilePhoto => 'Utiliser la photo de profil Google';

  @override
  String get customAvatars => 'Avatars personnalisés';

  @override
  String get saveAvatar => 'Enregistrer l\'avatar';

  @override
  String get displayNameFieldLabel => 'Nom d\'affichage';

  @override
  String get displayNameFieldHint => 'Entrez votre nom d\'affichage';

  @override
  String get saveAccountInformation => 'Enregistrer les informations du compte';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get emailInvalid => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordMissingUppercase =>
      'Le mot de passe doit contenir au moins une lettre majuscule';

  @override
  String get passwordMissingLowercase =>
      'Le mot de passe doit contenir au moins une lettre minuscule';

  @override
  String get passwordMissingNumber =>
      'Le mot de passe doit contenir au moins un chiffre';

  @override
  String get passwordMissingSpecialChar =>
      'Le mot de passe doit contenir au moins un caractère spécial (!@#\$%^&*...)';

  @override
  String get tooManyAttempts =>
      'Trop de tentatives de connexion échouées. Veuillez réessayer dans 15 minutes.';

  @override
  String get emailVerificationRequired =>
      'Veuillez vérifier votre adresse e-mail avant d\'accéder à cette fonctionnalité. Consultez votre boîte de réception pour le lien de vérification.';

  @override
  String get defaultUserName => 'Utilisateur';

  @override
  String get googleSignInError =>
      'La connexion Google a été annulée ou a échoué. Veuillez réessayer.';

  @override
  String get gitHubSignInError =>
      'La connexion GitHub a été annulée ou a échoué. Veuillez réessayer.';

  @override
  String get appleSignInError =>
      'La connexion Apple a été annulée ou a échoué. Veuillez réessayer.';

  @override
  String get displayNameUpdated => 'Nom d\'affichage mis à jour';

  @override
  String get displayNameUpdateFailed =>
      'Échec de la mise à jour du nom d\'affichage';

  @override
  String get sessionResetSuccess => 'Session réinitialisée avec succès';

  @override
  String get accountDeletedSuccess => 'Compte supprimé avec succès';

  @override
  String get errorUserNotFound =>
      'Aucun compte trouvé avec cette adresse e-mail.';

  @override
  String get errorWrongPassword =>
      'Mot de passe incorrect. Veuillez réessayer.';

  @override
  String get errorInvalidEmail => 'Format d\'adresse e-mail non valide.';

  @override
  String get errorUserDisabled => 'Ce compte a été désactivé.';

  @override
  String get errorEmailInUse =>
      'Un compte existe déjà avec cette adresse e-mail.';

  @override
  String get errorWeakPassword =>
      'Le mot de passe est trop faible. Veuillez utiliser un mot de passe plus fort.';

  @override
  String get errorOperationNotAllowed =>
      'Cette méthode de connexion n\'est pas activée.';

  @override
  String get errorRequiresRecentLogin =>
      'Veuillez vous reconnecter pour effectuer cette action.';

  @override
  String get errorNetworkFailed =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String errorUnknown(String message) {
    return 'Une erreur s\'est produite : $message';
  }

  @override
  String get exceptionGoogleSignInNotInitialized =>
      'Connexion Google non initialisée';

  @override
  String get exceptionGoogleSignInTimeout => 'La connexion Google a expiré';

  @override
  String get exceptionAppleSignInPlatform =>
      'La connexion Apple n\'est disponible que sur les plateformes Apple';

  @override
  String get exceptionNoAnonymousUser => 'Aucun utilisateur anonyme à lier';

  @override
  String get exceptionNoUserSignedIn => 'Aucun utilisateur connecté';

  @override
  String get firebaseErrorUserNotFound =>
      'Aucun compte trouvé avec cette adresse e-mail.';

  @override
  String get firebaseErrorWrongPassword =>
      'Mot de passe incorrect. Veuillez réessayer.';

  @override
  String get firebaseErrorInvalidEmail =>
      'Format d\'adresse e-mail non valide.';

  @override
  String get firebaseErrorUserDisabled => 'Ce compte a été désactivé.';

  @override
  String get firebaseErrorEmailInUse =>
      'Un compte existe déjà avec cette adresse e-mail.';

  @override
  String get firebaseErrorWeakPassword =>
      'Le mot de passe est trop faible. Veuillez utiliser un mot de passe plus fort.';

  @override
  String get firebaseErrorOperationNotAllowed =>
      'Cette méthode de connexion n\'est pas activée.';

  @override
  String get firebaseErrorRequiresRecentLogin =>
      'Veuillez vous reconnecter pour effectuer cette action.';

  @override
  String get firebaseErrorNetworkFailed =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get firebaseErrorAccountExistsWithDifferentCredential =>
      'Un compte existe déjà avec cet e-mail en utilisant une méthode de connexion différente. Veuillez vous connecter avec la méthode d\'origine.';

  @override
  String firebaseErrorDefault(String message) {
    return 'Une erreur s\'est produite : $message';
  }

  @override
  String get integrityErrorDeviceIntegrityTitle =>
      'Problème de sécurité de l\'appareil';

  @override
  String get integrityErrorDeviceIntegrity =>
      'Votre appareil ne répond pas aux exigences de sécurité pour cette opération.';

  @override
  String integrityGuidanceDeviceIntegrity(String reference) {
    return 'Veuillez vous assurer que votre appareil passe les vérifications Google Play Protect et n\'est pas rooté ou modifié. Si vous pensez qu\'il s\'agit d\'une erreur, contactez le support avec la référence : $reference';
  }

  @override
  String get integrityErrorAppIntegrityTitle =>
      'Problème d\'installation de l\'application';

  @override
  String get integrityErrorAppIntegrity =>
      'L\'installation de l\'application n\'a pas pu être vérifiée.';

  @override
  String integrityGuidanceAppIntegrity(String reference) {
    return 'Veuillez vous assurer que vous utilisez l\'application officielle du Google Play Store. Les applications chargées latéralement ou modifiées ne sont pas prises en charge. Référence : $reference';
  }

  @override
  String get integrityErrorNetworkTitle => 'Erreur de connexion';

  @override
  String get integrityErrorNetwork =>
      'Impossible de vérifier la sécurité de l\'appareil en raison d\'une erreur réseau.';

  @override
  String integrityGuidanceNetwork(String reference) {
    return 'Veuillez vérifier votre connexion Internet et réessayer. Si le problème persiste, contactez le support avec la référence : $reference';
  }

  @override
  String get integrityErrorBackendVerificationTitle =>
      'Échec de la vérification';

  @override
  String get integrityErrorBackendVerification =>
      'La vérification de sécurité n\'a pas pu être complétée.';

  @override
  String integrityGuidanceBackendVerification(String reference) {
    return 'Un problème est survenu lors de la vérification de votre appareil. Veuillez réessayer plus tard. Si cela persiste, contactez le support avec la référence : $reference';
  }

  @override
  String get integrityErrorTokenRequestTitle =>
      'Échec de la vérification de sécurité';

  @override
  String get integrityErrorTokenRequest =>
      'Impossible d\'effectuer la vérification de sécurité.';

  @override
  String integrityGuidanceTokenRequest(String reference) {
    return 'Impossible de générer le jeton de sécurité. Veuillez redémarrer l\'application et réessayer. Si le problème persiste, contactez le support avec la référence : $reference';
  }

  @override
  String get integrityErrorUnknownTitle => 'Erreur de vérification';

  @override
  String get integrityErrorUnknown =>
      'Une erreur inattendue s\'est produite lors de la vérification de sécurité.';

  @override
  String integrityGuidanceUnknown(String reference) {
    return 'Veuillez réessayer. Si le problème persiste, contactez le support avec la référence : $reference';
  }

  @override
  String get emailVerificationSent =>
      'E-mail de vérification envoyé ! Veuillez vérifier votre boîte de réception.';

  @override
  String get emailVerificationResent =>
      'E-mail de vérification renvoyé avec succès.';

  @override
  String get emailNotVerified => 'E-mail non vérifié';

  @override
  String get emailVerified => 'E-mail vérifié';

  @override
  String get verifyEmailAddress => 'Vérifier l\'adresse e-mail';

  @override
  String get verifyEmailMessage =>
      'Veuillez vérifier votre adresse e-mail pour accéder à toutes les fonctionnalités. Consultez votre boîte de réception pour le lien de vérification.';

  @override
  String get sendVerificationEmail => 'Envoyer l\'e-mail de vérification';

  @override
  String get resendVerificationEmail => 'Renvoyer l\'e-mail de vérification';

  @override
  String get checkVerificationStatus => 'Vérifier le statut de vérification';

  @override
  String get emailVerificationPending => 'Vérification d\'e-mail en attente';

  @override
  String verificationEmailCooldown(int seconds) {
    return 'Veuillez attendre $seconds secondes avant de demander un autre e-mail de vérification.';
  }

  @override
  String get termsAndPrivacy => 'Conditions et confidentialité';

  @override
  String get acceptTermsAndPrivacy =>
      'J\'accepte les Conditions d\'utilisation et la Politique de confidentialité';

  @override
  String get mustAcceptTerms =>
      'Vous devez accepter les Conditions d\'utilisation et la Politique de confidentialité pour continuer.';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get viewTermsOfService => 'Voir les Conditions d\'utilisation';

  @override
  String get viewPrivacyPolicy => 'Voir la Politique de confidentialité';

  @override
  String termsLastUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String privacyLastUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get ageRequirement =>
      'Vous devez avoir 13 ans ou plus pour créer un compte.';

  @override
  String get confirmAge => 'Je confirme que j\'ai 13 ans ou plus';

  @override
  String get exceptionEmailVerificationFailed =>
      'exceptionEmailVerificationFailed';

  @override
  String get exceptionEmailVerificationCooldown =>
      'exceptionEmailVerificationCooldown';

  @override
  String get exceptionTermsNotAccepted => 'exceptionTermsNotAccepted';

  @override
  String get collisionEffectsTitle => 'Effets de Collision';

  @override
  String get showCollisionDebris => 'Particules de Débris';

  @override
  String get showCollisionDebrisDescription =>
      'Particules éjectées des impacts de collision avec trajectoires basées sur la physique';

  @override
  String get showCollisionShockwaves => 'Ondes de Choc';

  @override
  String get showCollisionShockwavesDescription =>
      'Anneaux d\'énergie en expansion depuis les points de collision proportionnels à la force d\'impact';

  @override
  String get showCollisionEjection => 'Éjection de Matière';

  @override
  String get showCollisionEjectionDescription =>
      'Nuages ondulants de matière expulsée lors d\'impacts à haute énergie';

  @override
  String get showCollisionPlasmaJets => 'Jets de Plasma';

  @override
  String get showCollisionPlasmaJetsDescription =>
      'Flux directionnels surchauffés issus de collisions d\'étoiles massives (expérimental)';

  @override
  String get liveSessionHosting => 'Session en direct active';

  @override
  String get liveSessionNotHosting => 'Partager une session en direct';

  @override
  String get liveSessionStartHosting => 'Démarrer l\'hébergement';

  @override
  String get liveSessionStopHosting => 'Arrêter le partage';

  @override
  String get liveSessionUpdateSession => 'Mettre à jour la session';

  @override
  String liveSessionViewerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spectateurs',
      one: '1 spectateur',
      zero: 'Aucun spectateur',
    );
    return '$_temp0';
  }

  @override
  String get liveSessionNoViewers => 'Personne ne regarde encore';

  @override
  String get liveSessionBrowseSessions => 'Parcourir les sessions';

  @override
  String get liveSessionNoSessions => 'Aucune session active';

  @override
  String get liveSessionJoin => 'Rejoindre';

  @override
  String get liveSessionYourSession => 'Votre session';

  @override
  String get liveSessionLeave => 'Quitter la session';

  @override
  String get liveSessionViewing => 'Visionnage de session en direct';

  @override
  String liveSessionHostedBy(String hostName) {
    return 'Hébergé par $hostName';
  }

  @override
  String liveSessionScenario(String scenarioName) {
    return 'Scénario : $scenarioName';
  }

  @override
  String get liveSessionRequiresAuth =>
      'Connectez-vous pour partager ou voir des sessions en direct';

  @override
  String get liveSessionStatusDisconnected => 'Déconnecté';

  @override
  String get liveSessionStatusConnecting => 'Connexion...';

  @override
  String get liveSessionStatusConnected => 'Connecté';

  @override
  String get liveSessionStatusReconnecting => 'Reconnexion...';

  @override
  String get liveSessionStatusError => 'Erreur de connexion';

  @override
  String liveSessionConnectionStatusLabel(String status) {
    return 'État de connexion : $status';
  }

  @override
  String get liveSessionTapForSettings =>
      'Appuyez pour les paramètres de session';

  @override
  String get liveSessionIndicatorTooltip => 'Session en Direct';

  @override
  String get liveSessionErrorHostingFailed =>
      'Impossible de démarrer l\'hébergement. Veuillez réessayer.';

  @override
  String get liveSessionErrorJoinFailed =>
      'Impossible de rejoindre la session. Veuillez réessayer.';

  @override
  String get liveSessionErrorConnectionLost =>
      'Connexion perdue. Tentative de reconnexion...';

  @override
  String get liveSessionTitle => 'Session en Direct';

  @override
  String get liveSessionDescription =>
      'Partagez votre simulation ou rejoignez d\'autres en temps réel';

  @override
  String get liveSessionHostingDescription =>
      'Diffusion de votre simulation aux spectateurs';

  @override
  String get liveSessionViewingDescription =>
      'Regarder une diffusion de simulation en direct';

  @override
  String get liveSessionMenuTitle => 'Sessions en Direct';

  @override
  String get liveSessionMenuDescription =>
      'Partager ou rejoindre des simulations en temps réel';

  @override
  String get liveSessionBrowseTab => 'Parcourir';

  @override
  String get liveSessionStartSharingTab => 'Partage';

  @override
  String get liveSessionBrowseDescription =>
      'Rejoignez une session en direct pour regarder la simulation d\'un autre utilisateur en temps réel';

  @override
  String get liveSessionShareDescription =>
      'Partagez votre simulation actuelle avec d\'autres en temps réel';

  @override
  String get liveSessionScenarioToShare => 'Scénario à partager';

  @override
  String get liveSessionPasswordProtection => 'Protection par Mot de Passe';

  @override
  String get liveSessionSetPassword => 'Entrer le mot de passe';

  @override
  String get liveSessionPasswordDescription =>
      'Les spectateurs devront entrer ce mot de passe pour rejoindre votre session';

  @override
  String get liveSessionCameraSync => 'Synchronisation de la Caméra';

  @override
  String get liveSessionCameraSyncDescription =>
      'Les spectateurs verront le même angle de caméra et les mêmes mouvements que vous';

  @override
  String get liveSessionCameraSyncActive => 'Caméra synchronisée';

  @override
  String get liveSessionCameraSyncViewerActive =>
      'Caméra contrôlée par l\'hôte';

  @override
  String get liveSessionPasswordRequired => 'Veuillez entrer un mot de passe';

  @override
  String get liveSessionEnterPassword => 'Entrer le Mot de Passe';

  @override
  String get liveSessionPasswordHint => 'Mot de passe de session';

  @override
  String get liveSessionPasswordProtected => 'Protégé par mot de passe';

  @override
  String get liveSessionPasswordEnabled => 'Mot de passe requis pour rejoindre';

  @override
  String get liveSessionPasswordDisabled => 'Tout le monde peut rejoindre';

  @override
  String get liveSessionIncorrectPassword => 'Mot de passe incorrect';

  @override
  String get liveSessionRequiresAccountTitle => 'Compte requis';

  @override
  String get liveSessionRequiresAccountMessage =>
      'Les sessions en direct sont disponibles pour les utilisateurs enregistrés. Créez un compte gratuit pour partager vos simulations avec d\'autres.';

  @override
  String get liveSessionCreateAccount => 'Créer un compte';

  @override
  String get liveSessionSessionName => 'Nom de la session';

  @override
  String get liveSessionSessionNameHint => 'Donnez un nom à votre session';

  @override
  String get liveSessionSettings => 'Paramètres de session';

  @override
  String get premiumTierFree => 'Gratuit';

  @override
  String get premiumTierPremium => 'Premium';

  @override
  String get premiumTierLifetime => 'À vie';

  @override
  String get premiumTitle => 'Graviton Premium';

  @override
  String get premiumSubtitle => 'Débloquez des sessions en direct illimitées';

  @override
  String get premiumBenefitUnlimitedDuration => 'Durée de session illimitée';

  @override
  String get premiumBenefitUnlimitedDurationDesc =>
      'Hébergez des sessions aussi longtemps que vous le souhaitez';

  @override
  String premiumBenefitViewers(int count) {
    return 'Jusqu\'à $count spectateurs';
  }

  @override
  String get premiumBenefitViewersDesc => 'Partagez avec un public plus large';

  @override
  String get premiumBenefitCameraSync => 'Synchronisation de caméra';

  @override
  String get premiumBenefitCameraSyncDesc =>
      'Synchronisez les vues pour tous les spectateurs';

  @override
  String get premiumBenefitPassword => 'Protection par mot de passe';

  @override
  String get premiumBenefitPasswordDesc => 'Gardez vos sessions privées';

  @override
  String get premiumBenefitUnlimitedSessions => 'Sessions illimitées par jour';

  @override
  String get premiumBenefitUnlimitedSessionsDesc =>
      'Aucune limite quotidienne d\'hébergement';

  @override
  String get premiumPlanMonthly => 'Mensuel';

  @override
  String get premiumPlanYearly => 'Annuel';

  @override
  String get premiumPlanLifetime => 'À vie';

  @override
  String get premiumPeriodMonth => '/mois';

  @override
  String get premiumPeriodYear => '/an';

  @override
  String get premiumPeriodOneTime => ' unique';

  @override
  String premiumSavePercent(String percent) {
    return 'Économisez $percent%';
  }

  @override
  String get premiumBestValue => 'Meilleure valeur';

  @override
  String get premiumStartFreeTrial => 'Démarrer l\'essai gratuit';

  @override
  String get premiumBuyNow => 'Acheter maintenant';

  @override
  String get premiumRestorePurchases => 'Restaurer les achats';

  @override
  String get premiumLegalText =>
      'Les abonnements seront automatiquement renouvelés sauf annulation au moins 24 heures avant la fin de la période en cours. Vous pouvez gérer vos abonnements dans les paramètres de l\'App Store.';

  @override
  String get premiumUpgrade => 'Mettre à niveau';

  @override
  String get premiumUpgradeToPremium => 'Passer à Premium';

  @override
  String get premiumSessionExpired => 'Session expirée';

  @override
  String get premiumSessionExpiredMessage =>
      'Votre temps de session gratuite est terminé. Votre session en direct a été arrêtée.';

  @override
  String get premiumUnlimitedSessionsHint =>
      'Passez à Premium pour un temps de session illimité';

  @override
  String get premiumTimeRemaining => 'Temps restant';

  @override
  String get premiumSessionLimitReached => 'Limite de session atteinte';

  @override
  String premiumSessionLimitMessage(int count) {
    return 'Vous avez atteint votre limite quotidienne de $count sessions. Passez à Premium pour des sessions illimitées.';
  }

  @override
  String premiumDurationLimitMessage(int minutes) {
    return 'Les sessions gratuites sont limitées à $minutes minutes. Mettez à niveau pour un temps de session illimité.';
  }

  @override
  String get premiumFeatureRequiresPremium =>
      'Cette fonctionnalité nécessite Premium';

  @override
  String get premiumPurchaseFailed => 'L\'achat a échoué. Veuillez réessayer.';

  @override
  String get premiumRestoreFailed =>
      'Impossible de restaurer les achats. Veuillez réessayer.';

  @override
  String get premiumRestoreSuccess => 'Achats restaurés avec succès !';

  @override
  String get premiumNoPurchasesToRestore =>
      'Aucun achat précédent trouvé à restaurer.';

  @override
  String get premiumRedirectingToPayment =>
      'Redirection vers le paiement sécurisé...';

  @override
  String get premiumFreeTierLabel => 'Gratuit';

  @override
  String get premiumProBadge => 'PRO';
}
