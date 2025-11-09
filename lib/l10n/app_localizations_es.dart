// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appDescription =>
      'Una simulación de física que explora la dinámica gravitacional y la mecánica orbital. Experimenta la belleza y complejidad del movimiento celestial a través de visualización 3D interactiva.';

  @override
  String get appFlavorDevelopment => 'Desarrollo';

  @override
  String get appFlavorProduction => 'Producción';

  @override
  String get appInformationCredits => 'Información de la app y créditos';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => 'Atrás';

  @override
  String get bottomNavVisualsLabel => 'Visuales';

  @override
  String get collisionHapticFeedbackDescription =>
      'Habilitar retroalimentación háptica cuando los cuerpos celestes colisionan durante la simulación';

  @override
  String get exitFullscreenHint =>
      'Toca en cualquier lugar para salir del modo pantalla completa';

  @override
  String get fullscreenMode => 'Modo Pantalla Completa';

  @override
  String get fullscreenModeDescription =>
      'Ocultar todos los elementos de la UI para una visualización inmersiva';

  @override
  String get hapticFeedbackCollisions =>
      'Retroalimentación háptica en colisiones';

  @override
  String get hapticFeedbackDescription =>
      'Habilitar retroalimentación háptica para interacciones de UI y colisiones';

  @override
  String get uiHapticFeedbackDescription =>
      'Habilitar retroalimentación háptica para interacciones de UI como toques de botones, interruptores y navegación';

  @override
  String get displayOptionsTitle => 'Opciones de Visualización';

  @override
  String get pauseButton => 'Pausar';

  @override
  String get playButton => 'Reproducir';

  @override
  String get presetAsteroidBeltChaos => 'Caos del Cinturón de Asteroides';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Campo denso de asteroides con efectos gravitacionales';

  @override
  String get presetBinaryStarDrama => 'Drama de Estrella Binaria';

  @override
  String get presetBinaryStarDramaDesc =>
      'Vista frontal de dos estrellas masivas en danza gravitacional';

  @override
  String get presetBinaryStarPlanetMoon => 'Planeta y Luna de Estrella Binaria';

  @override
  String get presetBinaryStarPlanetMoonDesc =>
      'Planeta y luna orbitando en sistema binario caótico';

  @override
  String get presetCompleteSolarSystem => 'Sistema Solar Completo';

  @override
  String get presetCompleteSolarSystemDesc =>
      'Todos los planetas visibles con hermosas órbitas';

  @override
  String get presetEarthMoonSystem => 'Sistema Tierra-Luna';

  @override
  String get presetEarthMoonSystemDesc =>
      'Tierra y Luna con mecánica orbital visible';

  @override
  String get presetEarthView => 'Vista de la Tierra';

  @override
  String get presetEarthViewDesc =>
      'Perspectiva cercana de la Tierra con detalle atmosférico';

  @override
  String get presetGalaxyBlackHole => 'Agujero Negro Galáctico';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Vista cercana del agujero negro supermasivo en el centro galáctico';

  @override
  String get presetGalaxyCoreDetail => 'Detalle del Núcleo Galáctico';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Primer plano del brillante centro galáctico con disco de acreción';

  @override
  String get presetGalaxyFormationOverview =>
      'Vista General de Formación Galáctica';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Vista amplia de la formación de galaxia espiral con fondo cósmico';

  @override
  String get presetInnerSolarSystem => 'Sistema Solar Interior';

  @override
  String get presetInnerSolarSystemDesc =>
      'Primer plano de Mercurio, Venus, Tierra y Marte con indicador de zona habitable';

  @override
  String get presetSaturnRings => 'Anillos Majestuosos de Saturno';

  @override
  String get presetSaturnRingsDesc =>
      'Primer plano de Saturno con sistema de anillos detallado';

  @override
  String get presetThreeBodyBallet => 'Ballet de Tres Cuerpos';

  @override
  String get presetThreeBodyBalletDesc =>
      'Problema clásico de tres cuerpos en movimiento elegante';

  @override
  String get resetButton => 'Reiniciar';

  @override
  String get resetChangelogButton => 'Restablecer estado del registro';

  @override
  String get resetChangelogDescription =>
      'Restablecer estado de lectura del changelog';

  @override
  String get resetSettingsDescription =>
      'Restablecer todos los ajustes a valores predeterminados';

  @override
  String get resetTutorialDescription => 'Restablecer progreso del tutorial';

  @override
  String get simulationCanvasFocused =>
      'Lienzo de simulación enfocado - área principal de simulación física';

  @override
  String get simulationCanvasHint =>
      'Usa atajos de teclado para controlar la simulación. Espacio para pausar, R para reiniciar, C para centrar cámara';

  @override
  String get simulationCanvasLabel => 'Simulación de Física Gravitacional';

  @override
  String get simulationControlsFocused => 'Controles de simulación enfocados';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return 'Simulación gravitacional con $bodyCount cuerpos celestes. Estado: $status. Velocidad: $speed. Pasos: $steps';
  }

  @override
  String get simulationSpeed => 'Velocidad de simulación';

  @override
  String get simulationSpeedHint =>
      'Ajusta la velocidad de simulación de 0,1x a 16x velocidad normal. Usa las teclas de flecha para cambios pequeños.';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return 'Simulación gravitacional con $bodyCount cuerpos celestes. Estado: $status. Velocidad: $speed. Pasos completados: $stepCount. Toca para interactuar con la simulación o usa atajos de teclado.';
  }

  @override
  String get simulationStats => 'Estadísticas de Simulación';

  @override
  String get simulationStepsLabel => 'Pasos de simulación';

  @override
  String get speedDouble => 'Doble';

  @override
  String get speedFast => 'Rápido';

  @override
  String speedFormatted(String speed) {
    return '${speed}x';
  }

  @override
  String get speedHalf => 'Media Velocidad';

  @override
  String get speedLabel => 'Velocidad';

  @override
  String get speedMaximum => 'Máximo';

  @override
  String get speedNormal => 'Normal';

  @override
  String get speedQuarter => 'Velocidad Cuarto';

  @override
  String get speedVeryFast => 'Muy Rápido';

  @override
  String get stopFollowTitle => 'Dejar de Seguir';

  @override
  String get stopFollowingTooltip => 'Dejar de Seguir Objeto';

  @override
  String get stopRotateTitle => 'Detener Rotación';

  @override
  String get testPresetForUnitTesting =>
      'Preajuste de prueba para pruebas unitarias';

  @override
  String get trailsLabel => 'Rastros';

  @override
  String get cameraControlsFocused => 'Controles de cámara enfocados';

  @override
  String get cameraControlsLabel => 'Controles de Cámara';

  @override
  String get cameraDynamicFraming => 'Encuadre Dinámico';

  @override
  String get cameraDynamicFramingDescription =>
      'Ajusta automáticamente el encuadre basado en el contenido de la escena';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return 'Cámara siguiendo $bodyName a distancia $distance. Auto-rotación: $rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return 'Cámara en modo libre a distancia $distance. Auto-rotación: $rotation';
  }

  @override
  String get cameraLabel => 'Cámara';

  @override
  String get cameraManual => 'Control Manual';

  @override
  String get cameraManualDescription =>
      'Controles manuales tradicionales de cámara con modo seguimiento';

  @override
  String get cameraPredictiveOrbital => 'Orbital Predictivo';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'IA predice trayectorias orbitales para movimientos dramáticos de cámara';

  @override
  String get cameraSettingsTitle => 'Configuración de Cámara';

  @override
  String get cameraSpeedHint =>
      'Ajustar la velocidad de movimiento de la cámara IA de lenta a rápida. Usar las teclas de flecha para cambios en incrementos pequeños.';

  @override
  String get cameraSpeedLabel => 'Velocidad de Cámara';

  @override
  String get cameraTooltip => 'Configuraciones de cámara y modos de IA';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => 'Distancia';

  @override
  String get previewEditortitle => 'Título del editor de vista previa';

  @override
  String get rotateLabel => 'Rotar';

  @override
  String get viewPhysicsSettings => 'Ver configuración de física';

  @override
  String get zoomInAction => 'Acercar';

  @override
  String get zoomLabel => 'Zoom';

  @override
  String get zoomOutAction => 'Alejar';

  @override
  String get colorEditor => 'Editor de color';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return 'Opción de color $color';
  }

  @override
  String get colorSelector => 'Selector de color';

  @override
  String get visualsTooltip => 'Opciones de visualización';

  @override
  String get collisionHapticFeedback =>
      'Retroalimentación Háptica de Colisiones';

  @override
  String get collisionSensitivity => 'Sensibilidad de colisión';

  @override
  String get gravityColorSchemeClassic => 'Clásico';

  @override
  String get gravityColorSchemeEmerald => 'Esmeralda';

  @override
  String get gravityColorSchemeMonochrome => 'Monocromático';

  @override
  String get gravityColorSchemeNeon => 'Neón';

  @override
  String get gravityColorSchemeSpectral => 'Espectral';

  @override
  String get gravityEditor => 'Editor de gravedad';

  @override
  String get gravityFieldColorSchemeDescription =>
      'Elegir el esquema de colores para la visualización de campos gravitacionales';

  @override
  String get gravityFieldColorSchemeLabel =>
      'Colores de Campos Gravitacionales';

  @override
  String get gravityFieldIndicatorsDescription =>
      'Mostrar indicadores visuales de la intensidad del campo gravitacional';

  @override
  String get gravityFieldIndicatorsLabel =>
      'Indicadores de Intensidad del Campo';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => 'Intensidad del Campo';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription =>
      'Mostrar visualización de campo gravitatorio';

  @override
  String get gravityFieldsTitle => 'Campos Gravitatorios';

  @override
  String get gravityWellsDescription =>
      'Mostrar la intensidad del campo gravitacional alrededor de objetos';

  @override
  String get gravityWellsLabel => 'Pozos Gravitacionales';

  @override
  String get massKgEditorhint => 'Introducir masa en kilogramos';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      'La configuración de física se implementará aquí-Editor';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return 'Campo de física fuera de rango';
  }

  @override
  String get physicsSection => 'Física';

  @override
  String get physicsSettingsDescription => 'Parámetros de simulación';

  @override
  String get physicsSettingsTitle => 'Configuración de Física';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return 'Física: $time unidades de tiempo, $earthYears años terrestres, $steps pasos de simulación completados';
  }

  @override
  String get physicsTooltip => 'Visualización y configuraciones de física';

  @override
  String get physicsVisualizationTitle => 'Visualización de Física';

  @override
  String get temperatureCold => 'Frío';

  @override
  String get temperatureEditorlabel => 'Etiqueta del editor de temperatura';

  @override
  String get temperatureFrozen => 'Congelado';

  @override
  String get temperatureHot => 'Caliente';

  @override
  String get temperatureKEditorhint => 'Introducir temperatura en Kelvin';

  @override
  String get temperatureModerate => 'Moderado';

  @override
  String get temperatureNotApplicable => 'N/A';

  @override
  String get temperatureScorching => 'Abrasador';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get velocityMsEditor => 'Editor de velocidad m/s';

  @override
  String get addBodyButton => 'Botón Agregar cuerpo';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      'Agregar cuerpos celestes para crear tu escenario personalizado-Editor';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      'El cinturón de asteroides y otros sistemas de partículas se configurarán aquí-Editor';

  @override
  String get beginnerEditor => 'Editor principiante';

  @override
  String get bodyTypeEditor => 'Editor de tipo de cuerpo';

  @override
  String get createACopyOfThisCelestialBodyEditorHint =>
      'Crear una copia de este cuerpo celeste-Consejo del editor';

  @override
  String get createCustomScenarioButton =>
      'Botón Crear escenario personalizado';

  @override
  String get createCustomScenarioDescription =>
      'Descripción del escenario personalizado';

  @override
  String get createScenarioButton => 'Botón Crear escenario';

  @override
  String get createScenarioTitle => 'Título Crear escenario';

  @override
  String get customGravitationalSimulationEditor =>
      'Editor de simulación gravitacional personalizada';

  @override
  String get deleteBodyConfirmMessage =>
      'Mensaje de confirmación de eliminación del cuerpo';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return 'Título de confirmación de eliminación del cuerpo';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return 'Eliminar $bodyName';
  }

  @override
  String get deleteBodyTooltip => 'Información Eliminar cuerpo';

  @override
  String get deleteButton => 'Botón Eliminar';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return 'Mensaje de confirmación de eliminación del escenario';
  }

  @override
  String get deleteScenarioTitle => 'Título Eliminar escenario';

  @override
  String get editEditorLabel => 'Etiqueta del editor Editar';

  @override
  String get editScenarioTitle => 'Título Editar escenario';

  @override
  String get gravitationalForcesEditor => 'Editor de fuerzas gravitacionales';

  @override
  String get newScenarioEditor => 'Editor de nuevo escenario';

  @override
  String get noBodiesYetEditor => 'Aún no hay cuerpos-Editor';

  @override
  String get positionMEditor => 'Editor de posición m';

  @override
  String get positionMotionEditor => 'Editor de posición/movimiento';

  @override
  String get propertiesEditor => 'Editor de propiedades';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      'Eliminar este cuerpo celeste del escenario-Consejo del editor';

  @override
  String get softeningEditor => 'Editor de suavizado';

  @override
  String get stellarPropertiesEditor => 'Editor de propiedades estelares';

  @override
  String get trailPointsEditor => 'Editor de puntos de rastro';

  @override
  String get customColor => 'Color personalizado';

  @override
  String get customLabel => 'Etiqueta personalizada';

  @override
  String get customScenarioDescription =>
      'Descripción del escenario personalizado';

  @override
  String get exportScenarioButton => 'Exportar escenario';

  @override
  String exportScenarioFailedMessage(String error) {
    return 'Fallo en la exportación del escenario';
  }

  @override
  String get exportScenarioNotImplementedMessage =>
      'Exportación del escenario no implementada';

  @override
  String get saveButton => 'Guardar';

  @override
  String get settingsButtonFocused => 'Botón Configuración enfocado';

  @override
  String get settingsMenuDescription => 'Opciones visuales y de comportamiento';

  @override
  String get settingsTooltip => 'Configuración de la Aplicación';

  @override
  String get toggleAutoRotateAction => 'Alternar auto-rotación';

  @override
  String get toggleGravityFieldsTooltip => 'Alternar Campos Gravitacionales';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Alternar Estado de Habitabilidad del Planeta';

  @override
  String get toggleHabitableZonesTooltip => 'Alternar Zonas Habitables';

  @override
  String get toggleLabelsTooltip => 'Alternar Etiquetas de Cuerpos';

  @override
  String get toggleStatsTooltip => 'Alternar Estadísticas';

  @override
  String get statsLabel => 'Estadísticas';

  @override
  String get helpMenuDescription => 'Tutorial y objetivos';

  @override
  String get tutorialButton => 'Tutorial';

  @override
  String get tutorialCameraDescription =>
      'Arrastra para rotar la vista, pellizca para hacer zoom, y usa dos dedos para rotar la cámara. La barra inferior tiene controles de enfoque, centrado y rotación automática para una experiencia cinematográfica.';

  @override
  String get tutorialCameraTitle => 'Controles de Cámara y Vista';

  @override
  String get tutorialControlsDescription =>
      'Toca en cualquier lugar para mostrar los controles flotantes de Reproducir/Pausar para la simulación. El control de velocidad está en la esquina superior derecha. Toca el menú (⋮) para escenarios, configuración y ajustes de física.';

  @override
  String get tutorialControlsDescriptionPart1 =>
      'Toca en cualquier lugar para mostrar los controles flotantes de Reproducir/Pausar para la simulación. El control de velocidad está en la esquina superior derecha. Toca el menú';

  @override
  String get tutorialControlsDescriptionPart2 =>
      'para escenarios, configuración y ajustes de física.';

  @override
  String get tutorialControlsTitle => 'Controles de Simulación';

  @override
  String get tutorialDescription => 'Tour guiado interactivo de la app';

  @override
  String get tutorialExploreDescription =>
      '¡Ahora estás listo para explorar el cosmos! Experimenta con diferentes escenarios, ajusta configuraciones, y observa cómo la gravedad da forma al baile de los cuerpos celestes. ¡Que disfrutes tu viaje a través del universo!';

  @override
  String get tutorialExploreTitle => '¡Comienza a Explorar!';

  @override
  String get tutorialNavigationHint =>
      'Desliza izquierda/derecha o usa botones para navegar';

  @override
  String get tutorialObjectivesDescription =>
      '• Observar mecánica orbital realista\n• Explorar diferentes escenarios astronómicos\n• Experimentar con interacciones gravitacionales\n• Ver colisiones y fusiones\n• Aprender sobre movimiento planetario\n• Descubrir dinámicas caóticas de tres cuerpos';

  @override
  String get tutorialObjectivesTitle => '¿Qué puedes hacer?';

  @override
  String get tutorialResetMessage =>
      '¡Estado del tutorial reiniciado! Reinicia la aplicación para ver la experiencia de primera vez.';

  @override
  String get tutorialResetSuccess =>
      'El progreso del tutorial ha sido restablecido';

  @override
  String get tutorialScenariosDescription =>
      'Accede al menú (⋮) en la esquina superior derecha para explorar diferentes escenarios: nuestro Sistema Solar, dinámicas Tierra-Luna, Estrellas Binarias, o el caótico Problema de Tres Cuerpos. ¡Cada uno ofrece física única por descubrir!';

  @override
  String get tutorialScenariosDescriptionPart1 => 'Accede al menú';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'en la esquina superior derecha para explorar diferentes escenarios: nuestro Sistema Solar, dinámicas Tierra-Luna, Estrellas Binarias, o el caótico Problema de Tres Cuerpos. ¡Cada uno ofrece física única por descubrir!';

  @override
  String get tutorialScenariosTitle => 'Explorar Escenarios';

  @override
  String get tutorialWelcomeDescription =>
      '¡Bienvenido a Graviton, tu ventana al fascinante mundo de la física gravitacional! Esta aplicación te permite explorar cómo los cuerpos celestes interactúan a través de la gravedad, creando hermosas danzas orbitales a través del espacio y el tiempo.';

  @override
  String get tutorialWelcomeTitle => '¡Bienvenido a Graviton!';

  @override
  String get welcomeCardDescription =>
      'Explora la física gravitacional a través de simulaciones interactivas. ¡Prueba diferentes escenarios, ajusta los controles y observa cómo se desarrolla el cosmos!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get descriptionEditorLabel => 'Etiqueta del editor de descripción';

  @override
  String get next => 'Siguiente';

  @override
  String get ok => 'OK';

  @override
  String get previous => 'Anterior';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType cambió a $value';
  }

  @override
  String timeFormatted(String time) {
    return '${time}s';
  }

  @override
  String get timeLabel => 'Tiempo';

  @override
  String get timeScaleStatLabel => 'Escala de Tiempo';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get updateRequiredMessage =>
      'Una versión más reciente de esta aplicación está disponible. Por favor actualice para continuar usando la aplicación con las últimas características y mejoras.';

  @override
  String get updateRequiredTitle => 'Actualización requerida';

  @override
  String get updateRequiredWarning => 'Esta versión ya no es compatible.';

  @override
  String errorLoadingChangelogs(String error) {
    return 'Error al cargar los registros de cambios: $error';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Error al abrir el enlace: $error';
  }

  @override
  String get notificationTypeDebug => 'Depuración';

  @override
  String get notificationTypeInfo => 'Información';

  @override
  String get warningTitle => 'Advertencia';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return 'Anuncio de accesibilidad omitido - sin enlace';
  }

  @override
  String get accessibilityCameraFocus =>
      'Cámara enfocada en el cuerpo celeste más cercano';

  @override
  String get accessibilityCameraFollow =>
      'La cámara ahora sigue al cuerpo celeste seleccionado';

  @override
  String get accessibilityCameraReset =>
      'Vista de cámara reiniciada a posición predeterminada';

  @override
  String get accessibilityCameraUnfollow =>
      'La cámara dejó de seguir al cuerpo celeste';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return 'Sensibilidad de colisión cambiada a $newValue';
  }

  @override
  String accessibilityError(String errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return 'Fuerza de gravedad cambiada a $newValue';
  }

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return 'Colisión detectada: $body1 se fusionó con $body2';
  }

  @override
  String get accessibilityMergeEventContext =>
      'La masa combinada crea un nuevo cuerpo celeste';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return 'Escenario cambiado a $scenarioName';
  }

  @override
  String get accessibilityScenarioChangeContext =>
      'Nuevos cuerpos celestes y parámetros físicos cargados';

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName desactivado';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName activado';
  }

  @override
  String get accessibilitySimulationPaused => 'Simulación pausada';

  @override
  String get accessibilitySimulationPausedContext =>
      'Todos los cuerpos celestes han dejado de moverse';

  @override
  String get accessibilitySimulationReset => 'Simulación reiniciada';

  @override
  String get accessibilitySimulationResetContext =>
      'Nuevo escenario cargado con cuerpos celestes frescos';

  @override
  String get accessibilitySimulationResumed => 'Simulación reanudada';

  @override
  String get accessibilitySimulationResumedContext =>
      'Los cuerpos celestes se mueven de nuevo';

  @override
  String get accessibilitySimulationStarted => 'Simulación iniciada';

  @override
  String get accessibilitySimulationStartedContext =>
      'Los cuerpos celestes están ahora en movimiento';

  @override
  String get accessibilitySimulationStopped => 'Simulación detenida';

  @override
  String get accessibilitySimulationStoppedContext =>
      'Todos los cuerpos celestes han sido reiniciados';

  @override
  String accessibilitySpeedChange(String newValue) {
    return 'Velocidad de simulación cambiada a $newValue';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return 'Paso del tutorial $currentStep de $totalSteps: $stepName';
  }

  @override
  String get changelogAdded => 'Nuevas características';

  @override
  String get changelogButton => 'Mostrar registro de cambios';

  @override
  String get changelogCategoryAdded => 'Añadido';

  @override
  String get changelogCategoryFixed => 'Corregido';

  @override
  String get changelogCategoryImproved => 'Mejorado';

  @override
  String get changelogDescription => 'Ver actualizaciones y cambios de la app';

  @override
  String get changelogDone => 'Hecho';

  @override
  String get changelogFixed => 'Correcciones de errores';

  @override
  String get changelogHometitle =>
      'Título de la página de inicio del registro de cambios';

  @override
  String get changelogImproved => 'Mejoras';

  @override
  String changelogLoadError(String error) {
    return 'Error al cargar el registro de cambios: $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return 'No se encontró registro de cambios. Agregue primero los datos del registro de cambios a Firestore.\nVersión actual: $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return 'Publicado el $date';
  }

  @override
  String get changelogResetMessage =>
      'El estado del registro de cambios ha sido restablecido';

  @override
  String get changelogResetSuccess =>
      'El estado del changelog ha sido restablecido';

  @override
  String get changelogTitle => 'Novedades';

  @override
  String get debugStatisticsTitle => 'Depuración y Estadísticas';

  @override
  String errorLoadingChangelogEHome(String error) {
    return 'Error cargando el registro de cambios';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return 'No hay registro de cambios disponible para esta versión';
  }

  @override
  String get testPreset => 'Preajuste de prueba';

  @override
  String get testScenarioButton => 'Botón Escenario de prueba';

  @override
  String get testScenarioNotImplementedMessage =>
      'Escenario de prueba no implementado';

  @override
  String get aboutButtonTooltip => 'Acerca de';

  @override
  String get aboutMenuDescription => 'Información de la app y créditos';

  @override
  String get accessAppPreferences => 'Acceder a preferencias de la aplicación';

  @override
  String get accessScenarioOptions => 'Acceder a opciones de escenario';

  @override
  String get adjustSimulationSpeed => 'Ajustar velocidad de simulación';

  @override
  String get aiCameraModesTitle => 'Modos de Cámara IA';

  @override
  String get allRightsReserved => 'Todos los derechos reservados';

  @override
  String get announcementTitle => 'Anuncio';

  @override
  String appliedPreset(String presetName) {
    return 'Escena aplicada: $presetName';
  }

  @override
  String get applyScene => 'Aplicar Escena';

  @override
  String get atLeastOneBodyIsRequired => 'Se requiere al menos un cuerpo';

  @override
  String get authorLabel => 'Autor';

  @override
  String get autoRotateActive => 'activa';

  @override
  String get autoRotateInactive => 'inactiva';

  @override
  String get autoRotateLabel => 'Rotación automática';

  @override
  String get autoRotateOff => 'Desactivado';

  @override
  String get autoRotateOn => 'Activado';

  @override
  String get autoRotateTooltip => 'Rotación Automática';

  @override
  String get blackColor => 'Negro';

  @override
  String get bodies => 'cuerpos';

  @override
  String get bodiesHeaderDescription => 'Descripción del encabezado de cuerpos';

  @override
  String bodiesHeaderPlural(int count) {
    return 'Cuerpos';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return 'Cuerpos en simulación: $descriptions';
  }

  @override
  String get bodiesLabel => 'Cuerpos';

  @override
  String get bodyAlpha => 'Alfa';

  @override
  String bodyAsteroid(int number) {
    return 'Asteroide $number';
  }

  @override
  String get bodyBeta => 'Beta';

  @override
  String get bodyBlackHole => 'Agujero Negro';

  @override
  String get bodyCenterOfMass => 'Centro de Masa';

  @override
  String get bodyCentralStar => 'Estrella Central';

  @override
  String bodyColorInvalid(String prefix) {
    return 'Color del cuerpo inválido';
  }

  @override
  String get bodyEarth => 'Tierra';

  @override
  String get bodyEarthLike => 'Tipo Tierra';

  @override
  String get bodyGamma => 'Gama';

  @override
  String bodyIndex(int index) {
    return 'Índice del cuerpo';
  }

  @override
  String get bodyInnerPlanet => 'Planeta Interior';

  @override
  String get bodyJupiter => 'Júpiter';

  @override
  String get bodyMars => 'Marte';

  @override
  String bodyMassInvalid(String prefix) {
    return 'Masa del cuerpo inválida';
  }

  @override
  String get bodyMercury => 'Mercurio';

  @override
  String get bodyMoon => 'Luna';

  @override
  String get bodyMoonM => 'Luna M';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return 'Copia de $bodyName';
  }

  @override
  String bodyNameRequired(String prefix) {
    return 'Nombre del cuerpo requerido';
  }

  @override
  String get bodyNeptune => 'Neptuno';

  @override
  String bodyNumberTemplate(String number) {
    return 'Cuerpo $number';
  }

  @override
  String get bodyOuterPlanet => 'Planeta Exterior';

  @override
  String get bodyPlanetP => 'Planeta P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return 'Componente de posición del cuerpo inválido';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return 'Posición del cuerpo inválida';
  }

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyPropertiesLuminosity => 'Luminosidad Estelar';

  @override
  String get bodyPropertiesMass => 'Masa';

  @override
  String get bodyPropertiesName => 'Nombre';

  @override
  String get bodyPropertiesNameHint => 'Introducir nombre del cuerpo';

  @override
  String get bodyPropertiesRadius => 'Radio';

  @override
  String get bodyPropertiesTitle => 'Propiedades del Cuerpo';

  @override
  String get bodyPropertiesVelocity => 'Velocidad';

  @override
  String bodyRadiusInvalid(String prefix) {
    return 'Radio del cuerpo inválido';
  }

  @override
  String bodyRing(int number) {
    return 'Anillo $number';
  }

  @override
  String get bodyRingedPlanet => 'Planeta con Anillos';

  @override
  String get bodyRockyPlanet => 'Planeta Rocoso';

  @override
  String get bodySaturn => 'Saturno';

  @override
  String bodySelectedTemplate(String bodyNumber, Object bodyName) {
    return '$bodyName seleccionado';
  }

  @override
  String get bodyStarA => 'Estrella A';

  @override
  String get bodyStarB => 'Estrella B';

  @override
  String bodyStarNumber(int number) {
    return 'Estrella $number';
  }

  @override
  String get bodySun => 'Sol';

  @override
  String get bodySuperEarth => 'Supertierra';

  @override
  String get bodyTypeAsteroid => 'Asteroide';

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Asteroides',
      one: '1 Asteroide',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeInvalid(String prefix, String bodyType) {
    return 'Tipo de cuerpo inválido';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lunas',
      one: '1 Luna',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypePlanet => 'Planeta';

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Planetas',
      one: '1 Planeta',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeSelector => 'Selector de tipo de cuerpo';

  @override
  String get bodyTypeStar => 'Estrella';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Estrellas',
      one: '1 Estrella',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return 'Tipo de cuerpo: $type';
  }

  @override
  String get bodyUranus => 'Urano';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return 'Componente de velocidad del cuerpo inválido';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return 'Velocidad del cuerpo inválida';
  }

  @override
  String get bodyVenus => 'Venus';

  @override
  String get bottomSheetFocused => 'Hoja inferior enfocada';

  @override
  String get bottomSheetLabel => 'Hoja inferior';

  @override
  String get browseAvailableSimulations => 'Navegar simulaciones disponibles';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return 'Cuerpo celeste $name';
  }

  @override
  String get centerLabel => 'Centrar';

  @override
  String get centerViewTooltip => 'Centrar Vista';

  @override
  String get cinematicCameraTechniqueDescription =>
      'Elija cómo la IA controla la cámara al seguir objetos';

  @override
  String get cinematicCameraTechniqueLabel => 'Técnica de Cámara IA';

  @override
  String get cinematicTechniqueDynamicFramingDesc =>
      'Objetivo dramático en tiempo real para escenarios caóticos';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      'Tours de IA y predicciones orbitales para escenarios educativos';

  @override
  String get closeButton => 'Cerrar';

  @override
  String get collapsedState => 'colapsado';

  @override
  String get collisionsSection => 'Colisiones';

  @override
  String get colorsLabel => 'Colores';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ Frío';

  @override
  String copiedToClipboard(String text) {
    return 'Copiado al portapapeles: $text';
  }

  @override
  String get copyButton => 'Copiar';

  @override
  String get copyrightLabel => 'Derechos de Autor';

  @override
  String couldNotOpenUrl(String url) {
    return 'No se pudo abrir $url';
  }

  @override
  String get crosshairsDescription =>
      'Mostrar indicador del centro de pantalla';

  @override
  String get crosshairsTitle => 'Retícula';

  @override
  String get currentScenario => 'Escenario actual';

  @override
  String get currentStatisticsTitle => 'Estadísticas Actuales';

  @override
  String get currentlySelected => 'Actualmente seleccionado';

  @override
  String get cyanColor => 'Cian';

  @override
  String get deactivate => 'Desactivar';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      'Describir qué demuestra este escenario-Consejo del editor';

  @override
  String get detailsEditorLabel => 'Etiqueta del editor de detalles';

  @override
  String get developerToolsMenuDescription =>
      'Herramientas de depuración para desarrollo';

  @override
  String get developerToolsTitle => 'Herramientas de Desarrollador';

  @override
  String get difficultyEditorLabel => 'Etiqueta del editor de dificultad';

  @override
  String get discardButton => 'Botón Descartar';

  @override
  String get dragToRotateCameraView => 'Arrastrar para rotar vista de cámara';

  @override
  String get dualOrbitalPaths => 'Trayectorias Orbitales Duales';

  @override
  String get dualOrbitalPathsDescription =>
      'Mostrar tanto trayectorias orbitales circulares ideales como elípticas reales';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return 'Duplicar $bodyName';
  }

  @override
  String get duplicateBodyTooltip => 'Información Duplicar cuerpo';

  @override
  String get dynamicFramingDescription =>
      'IA encuadra dinámicamente todos los objetos';

  @override
  String get earthBlueColor => 'Azul terrestre';

  @override
  String earthYearsFormatted(String years) {
    return '$years años';
  }

  @override
  String get earthYearsLabel => 'Años Terrestres';

  @override
  String get educationalFocusBinaryOrbits => 'órbitas binarias';

  @override
  String get educationalFocusChaoticDynamics => 'dinámicas caóticas';

  @override
  String get educationalFocusManyBodyDynamics => 'dinámicas de muchos cuerpos';

  @override
  String get educationalFocusPlanetaryMotion => 'movimiento planetario';

  @override
  String get educationalFocusRealWorldSystem => 'sistema del mundo real';

  @override
  String get educationalFocusStructureFormation => 'formación de estructuras';

  @override
  String get educationalObjectivesEditortitle =>
      'Título del editor de objetivos educativos';

  @override
  String get educationalObjectivesFutureMessage =>
      'Los objetivos educativos pueden configurarse aquí en futuras versiones';

  @override
  String get educationalObjectivesListMessage =>
      'Esto incluirá:\n• Objetivos de aprendizaje\n• Criterios de éxito\n• Desafíos guiados\n• Rúbricas de evaluación';

  @override
  String get emergencyNotificationTitle => 'Aviso Importante';

  @override
  String get enterScenarioNameEditorHint =>
      'Introducir nombre del escenario-Consejo del editor';

  @override
  String get equipotentialSurfacesDescription =>
      'Mostrar superficies de igual energía potencial gravitacional';

  @override
  String get equipotentialSurfacesLabel => 'Superficies Equipotenciales';

  @override
  String get exit => 'Salir';

  @override
  String get exitAppMessage =>
      '¿Estás seguro de que quieres salir de Graviton?';

  @override
  String get exitAppTitle => 'Salir de la App';

  @override
  String get expandedState => 'expandido';

  @override
  String failedToSwitchScenarioError(String error) {
    return 'Error al cambiar de escenario';
  }

  @override
  String get fieldOfViewLabel => 'Campo de Visión';

  @override
  String get focusOnNearestTooltip => 'Enfocar en el Cuerpo Más Cercano';

  @override
  String get followLabel => 'Seguir';

  @override
  String get followObjectTooltip => 'Seguir Objeto Seleccionado';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get globalGravityFieldsDescription =>
      'Habilitar la visualización de campos gravitacionales para todos los objetos masivos';

  @override
  String get globalGravityFieldsLabel => 'Campos Gravitacionales Globales';

  @override
  String get gotItButton => '¡Entendido!';

  @override
  String get gravitationalConstant => 'Constante gravitacional';

  @override
  String get greenColor => 'Verde';

  @override
  String get habitabilityHabitable => 'Habitable';

  @override
  String get habitabilityIndicatorsDescription =>
      'Mostrar anillos de estado codificados por color alrededor de planetas basados en su habitabilidad';

  @override
  String get habitabilityIndicatorsLabel => 'Estado del Planeta';

  @override
  String get habitabilityLabel => 'Habitabilidad';

  @override
  String get habitabilityTooCold => 'Demasiado Frío';

  @override
  String get habitabilityTooHot => 'Demasiado Caliente';

  @override
  String get habitabilityUnknown => 'Desconocido';

  @override
  String get habitableZonesDescription =>
      'Mostrar zonas coloreadas alrededor de estrellas indicando regiones habitables';

  @override
  String get habitableZonesLabel => 'Zonas Habitables';

  @override
  String get hapticsSection => 'Hápticos';

  @override
  String get hideUIInScreenshotMode => 'Ocultar Navegación';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'Ocultar barra de aplicación, navegación inferior y copyright cuando el modo captura esté activo';

  @override
  String get initialMotionVectorsDescription =>
      'Descripción de vectores de movimiento inicial';

  @override
  String invalidJsonFormat(String error) {
    return 'Formato JSON inválido';
  }

  @override
  String get invertPitchControlsDescription =>
      'Invertir la dirección de arrastre arriba/abajo';

  @override
  String get invertPitchControlsLabel => 'Invertir Controles de Inclinación';

  @override
  String get jupiterTanColor => 'Color tostado de Júpiter';

  @override
  String get keyboardShortcutsHint =>
      'Usa Espacio para pausar/reanudar, R para reiniciar, C para centrar cámara, A para alternar auto-rotación';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => 'Cambiar el idioma de la aplicación';

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
  String get languageLabel => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => 'Predeterminado del Sistema';

  @override
  String get lightEnergyOutputDescription =>
      'Descripción de salida de energía luminosa';

  @override
  String get loadingVersion => 'Cargando versión...';

  @override
  String get luminosityEditorLabel => 'Etiqueta del editor de luminosidad';

  @override
  String get luminosityWEditorhint =>
      'Introducir luminosidad en vatios-Consejo del editor';

  @override
  String get maintenanceTitle => 'Mantenimiento';

  @override
  String get manualControlDescription => 'Control manual completo de la cámara';

  @override
  String get manualControlsTitle => 'Controles Manuales';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String get marsRedColor => 'Rojo marciano';

  @override
  String get maxTrailPointsInvalid => 'Puntos máximos de rastro inválidos';

  @override
  String get maximum50BodiesAllowed => 'Máximo 50 cuerpos permitidos';

  @override
  String get mercuryGrayColor => 'Gris mercuriano';

  @override
  String get missingRequiredFieldBodies =>
      'Falta el campo requerido \'Cuerpos\'';

  @override
  String get missingRequiredFieldConfiguration =>
      'Falta el campo requerido \'Configuración\'';

  @override
  String get missingRequiredFieldMetadata =>
      'Falta el campo requerido \'Metadatos\'';

  @override
  String get missingRequiredFieldParticleSystems =>
      'Falta el campo requerido \'Sistemas de partículas\'';

  @override
  String get missingRequiredFieldPhysics =>
      'Falta el campo requerido \'Física\'';

  @override
  String get missingRequiredFieldVersion =>
      'Falta el campo requerido \'Versión\'';

  @override
  String get moreOptionsTooltip => 'Más opciones';

  @override
  String get navigationAidsTitle => 'Ayudas de Navegación';

  @override
  String get neptuneBlueColor => 'Azul neptuniano';

  @override
  String get newsTitle => 'Noticias';

  @override
  String get nextPreset => 'Escena siguiente';

  @override
  String get nextSceneTooltip => 'Información Escena siguiente';

  @override
  String get noActionsAvailable => 'No hay acciones disponibles';

  @override
  String get noBodiesInSimulation =>
      'No hay cuerpos celestes en la simulación actualmente';

  @override
  String get noChangelogsAvailable => 'No hay registros de cambios disponibles';

  @override
  String get objectives1 => 'Comprender cómo la gravedad da forma al cosmos';

  @override
  String get objectives2 => 'Observar sistemas orbitales estables vs. caóticos';

  @override
  String get objectives3 =>
      'Aprender por qué los planetas se mueven en órbitas elípticas';

  @override
  String get objectives4 => 'Descubrir cómo interactúan las estrellas binarias';

  @override
  String get objectives5 => 'Ver qué sucede cuando los objetos colisionan';

  @override
  String get objectives6 =>
      'Apreciar la complejidad del problema de tres cuerpos';

  @override
  String get objectivesDescription =>
      '• Comprender cómo la gravedad da forma al cosmos\n• Observar sistemas orbitales estables vs. caóticos\n• Aprender por qué los planetas se mueven en órbitas elípticas\n• Descubrir cómo interactúan las estrellas binarias\n• Ver qué sucede cuando los objetos colisionan\n• Apreciar la complejidad del problema de tres cuerpos';

  @override
  String get objectivesTitle => 'Objetivos';

  @override
  String get offScreenIndicatorsDescription =>
      'Mostrar flechas apuntando a objetos fuera del área visible';

  @override
  String get offScreenIndicatorsTitle => 'Indicadores Fuera de Pantalla';

  @override
  String get orangeColor => 'Naranja';

  @override
  String get particleSystemsEditortitle =>
      'Título del editor de sistemas de partículas';

  @override
  String get pathVisualizationTitle => 'Visualización de Trayectorias';

  @override
  String get physicalPropertiesDescription =>
      'Descripción de propiedades físicas';

  @override
  String get pinchToZoomInOut => 'Pellizcar para acercar/alejar';

  @override
  String get pitchLabel => 'Cabeceo';

  @override
  String get positionEditorLabel => 'Etiqueta del editor de posición';

  @override
  String get predictiveOrbitalDescription =>
      'IA predice vistas orbitales óptimas';

  @override
  String get previousPreset => 'Escena anterior';

  @override
  String get previousSceneTooltip => 'Información Escena anterior';

  @override
  String get privacyPolicyLabel => 'Política de Privacidad';

  @override
  String get promotionTitle => 'Promoción';

  @override
  String get quickStart1 =>
      'Elige un escenario (Sistema Solar recomendado para principiantes)';

  @override
  String get quickStart2 => 'Presiona Play para iniciar la simulación';

  @override
  String get quickStart3 =>
      'Arrastra para rotar tu vista, pellizca para hacer zoom';

  @override
  String get quickStart4 =>
      'Toca el deslizador de Velocidad para controlar el tiempo';

  @override
  String get quickStart5 =>
      'Prueba Reiniciar para nuevas configuraciones aleatorias';

  @override
  String get quickStart6 =>
      'Activa Rastros para ver las trayectorias orbitales';

  @override
  String get quickStartDescription =>
      '1. Elige un escenario (Sistema Solar recomendado para principiantes)\n2. Presiona Play para iniciar la simulación\n3. Arrastra para rotar tu vista, pellizca para hacer zoom\n4. Toca el deslizador de Velocidad para controlar el tiempo\n5. Prueba Reiniciar para nuevas configuraciones aleatorias\n6. Activa Rastros para ver las trayectorias orbitales';

  @override
  String get quickStartTitle => 'Inicio Rápido';

  @override
  String get quickTutorialButton => 'Tutorial Rápido';

  @override
  String get radiusMEditorhint =>
      'Introducir radio en metros-Consejo del editor';

  @override
  String get realisticColors => 'Colores Realistas';

  @override
  String get realisticColorsDescription =>
      'Usar colores científicamente precisos basados en temperatura y clasificación estelar';

  @override
  String get redColor => 'Rojo';

  @override
  String get rollLabel => 'Alabeo';

  @override
  String get saturnCreamColor => 'Color crema de Saturno';

  @override
  String get scenarioAsteroidBelt => 'Cinturón de Asteroides';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Estrella central rodeada por un cinturón de asteroides rocosos y escombros';

  @override
  String get scenarioBestBinary => 'Ideal para: Exploración avanzada de física';

  @override
  String get scenarioBestEarthMoon =>
      'Ideal para: Entender el sistema Tierra-Luna';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom => 'Ideal para: Exploración y experimentación';

  @override
  String get scenarioBestSolar =>
      'Ideal para: Principiantes, entusiastas de la astronomía';

  @override
  String get scenarioBestThreeBody =>
      'Ideal para: Entusiastas de la física matemática';

  @override
  String get scenarioBinaryStars => 'Estrellas Binarias';

  @override
  String get scenarioBinaryStarsDescription =>
      'Dos estrellas masivas orbitándose mutuamente con planetas circumbinarios';

  @override
  String get scenarioCustom => 'Escenario personalizado';

  @override
  String get scenarioCustomDescription =>
      'Descripción del escenario personalizado';

  @override
  String get scenarioEarthMoonSun => 'Tierra-Luna-Sol';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Simulación educativa de nuestro familiar sistema Tierra-Luna-Sol';

  @override
  String get scenarioGalaxyFormation => 'Formación de Galaxia';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Observa cómo la materia se organiza en estructuras espirales alrededor de un agujero negro central';

  @override
  String get scenarioInformationEditortitle =>
      'Título del editor de información del escenario';

  @override
  String get scenarioLearnBinary =>
      'Aprende: Evolución estelar, sistemas binarios, gravedad extrema';

  @override
  String get scenarioLearnEarthMoon =>
      'Aprende: Dinámicas de tres cuerpos, mecánica lunar, fuerzas de marea';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom =>
      'Aprende: Descubre configuraciones desconocidas, física experimental';

  @override
  String get scenarioLearnSolar =>
      'Aprende: Movimiento planetario, mecánica orbital, cuerpos celestes familiares';

  @override
  String get scenarioLearnThreeBody =>
      'Aprende: Teoría del caos, movimiento impredecible, sistemas inestables';

  @override
  String get scenarioNameRequired => 'Nombre de escenario requerido';

  @override
  String get scenarioNameTooLong => 'Nombre del escenario demasiado largo';

  @override
  String get scenarioPlanetaryRings => 'Anillos Planetarios';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Dinámica del sistema de anillos alrededor de un planeta masivo como Saturno';

  @override
  String get scenarioRandom => 'Sistema Aleatorio';

  @override
  String get scenarioRandomDescription =>
      'Sistema caótico de tres cuerpos generado aleatoriamente con dinámica impredecible';

  @override
  String scenarioSaveFailedMessage(String error) {
    return 'Fallo al guardar el escenario';
  }

  @override
  String get scenarioSavedSuccessMessage => 'Escenario guardado exitosamente';

  @override
  String get scenarioSelectorFocused => 'Selector de escenario enfocado';

  @override
  String get scenarioSolarSystem => 'Sistema Solar';

  @override
  String get scenarioSolarSystemDescription =>
      'Versión simplificada de nuestro sistema solar con planetas interiores y exteriores';

  @override
  String get scenarioSpecial => 'Escenario Especial';

  @override
  String get scenarioSpecialDescription =>
      'Escenario especial para modo de captura de pantalla';

  @override
  String get scenariosAvailable => 'escenarios disponibles';

  @override
  String get scenariosMenuDescription => 'Explorar diferentes escenarios';

  @override
  String get sceneActive => 'Escena activa - simulación pausada para captura';

  @override
  String get scenePreset => 'Escena Predefinida';

  @override
  String get scheduledMaintenanceInProgress =>
      'Mantenimiento programado en progreso';

  @override
  String screenshotCountdown(int seconds) {
    return 'Captura en ${seconds}s';
  }

  @override
  String get screenshotMode => 'Modo de Captura';

  @override
  String get screenshotModeSubtitle =>
      'Activar escenas predefinidas para capturas de marketing';

  @override
  String get selectAColorForTheCelestialBody =>
      'Seleccionar un color para el cuerpo celeste';

  @override
  String get selectNearestTitle => 'Seleccionar Más Cercano';

  @override
  String get selectObjectToFollowTooltip => 'Seleccionar Objeto para Seguir';

  @override
  String get selectScenarioTooltip => 'Seleccionar Escenario';

  @override
  String get selectTheTypeOfCelestialBody =>
      'Seleccionar el tipo de cuerpo celeste';

  @override
  String get selectedStatLabel => 'Seleccionado';

  @override
  String get showHelpTooltip => 'Mostrar Ayuda';

  @override
  String get showLabelsDescription =>
      'Mostrar nombres de cuerpos celestes en la simulación';

  @override
  String get showLabelsTitle => 'Mostrar Etiquetas';

  @override
  String get showOrbitalPaths => 'Mostrar Trayectorias Orbitales';

  @override
  String get showOrbitalPathsDescription =>
      'Mostrar trayectorias orbitales predichas en escenarios con órbitas estables';

  @override
  String get showStatisticsDescription =>
      'Mostrar estadísticas de rendimiento y física';

  @override
  String get showStatisticsTitle => 'Mostrar Estadísticas';

  @override
  String get showTrails => 'Mostrar Rastros';

  @override
  String get showTrailsDescription =>
      'Mostrar estelas de movimiento detrás de los objetos';

  @override
  String get showTutorialTooltip => 'Mostrar Tutorial';

  @override
  String get skipTutorial => 'Saltar Tutorial';

  @override
  String get softeningParameter => 'Parámetro de suavizado';

  @override
  String get spatialCoordinatesDescription =>
      'Descripción de coordenadas espaciales';

  @override
  String get statusError => 'Error';

  @override
  String get statusLabel => 'Estado';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get statusRunning => 'Ejecutándose';

  @override
  String get statusStopped => 'Detenido';

  @override
  String get stellarColorBlue => 'Azul';

  @override
  String get stellarColorBlueWhite => 'Blanco-azulado';

  @override
  String get stellarColorOrange => 'Naranja';

  @override
  String get stellarColorRed => 'Rojo';

  @override
  String get stellarColorWhite => 'Blanco';

  @override
  String get stellarColorYellow => 'Amarillo';

  @override
  String get stellarColorYellowWhite => 'Blanco-amarillento';

  @override
  String get stellarTemperatureDescription =>
      'Descripción de temperatura estelar';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => 'Pasos';

  @override
  String get successTitle => 'Éxito';

  @override
  String get swipeUpToExpand => 'Deslizar hacia arriba para expandir';

  @override
  String get tapPlayPauseButton => 'Tocar botón Reproducir/Pausar';

  @override
  String get tapResetButton => 'Tocar botón Reiniciar';

  @override
  String get tapToCenterCamera => 'Tocar para centrar cámara';

  @override
  String get tapToChangeScenario => 'Tocar para cambiar escenario';

  @override
  String get tapToInteractWithSimulation =>
      'Tocar para interactuar con la simulación';

  @override
  String get tapToOpenSettings => 'Tocar para abrir configuración';

  @override
  String get tapToSelect => 'Tocar para seleccionar';

  @override
  String get tapToToggleAutoRotation =>
      'Tocar para activar/desactivar rotación automática';

  @override
  String get tapToToggleFullscreen => 'Toca para alternar pantalla completa';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return 'Tocar para ver y editar detalles-Cuerpo-Tipo de cuerpo-Nombre con número-Utils-Formato-Masa-Masa del cuerpo-Consejo del editor';
  }

  @override
  String get trackingModeEssential => 'Solo Esencial';

  @override
  String get trackingModeEssentialDescription =>
      'Solo fallos críticos y errores';

  @override
  String get trackingModeFull => 'Seguimiento Completo';

  @override
  String get trackingModeFullDescription =>
      'Todas las analíticas, fallos e interacciones';

  @override
  String get trackingModeLimited => 'Seguimiento Limitado';

  @override
  String get trackingModeLimitedDescription => 'Solo interacciones del usuario';

  @override
  String get trackingModeNone => 'Sin Seguimiento';

  @override
  String get trackingModeNoneDescription => 'Sin recolección de datos';

  @override
  String get trailColorLabel => 'Color de Rastro';

  @override
  String get trailFadeRate => 'Tasa de desvanecimiento del rastro';

  @override
  String get trailLength => 'Longitud del rastro';

  @override
  String get typeEditorLabel => 'Etiqueta del editor de tipo';

  @override
  String get uiHapticFeedback => 'Retroalimentación Háptica de UI';

  @override
  String get unsavedChangesMessage => 'Mensaje de cambios sin guardar';

  @override
  String get unsavedChangesTitle => 'Cambios sin guardar';

  @override
  String get uranusCyanColor => 'Color cian de Urano';

  @override
  String get useKeyboardShortcutsForControls =>
      'Usar atajos de teclado para controles';

  @override
  String get useZoomControls => 'Usar controles de zoom';

  @override
  String get venusYellowColor => 'Color amarillo de Venus';

  @override
  String get versionLabel => 'Versión';

  @override
  String get versionStatusCurrent => 'Actual';

  @override
  String get versionStatusOutdated => 'Desactualizado';

  @override
  String get vibrationEnabled => 'Vibración habilitada';

  @override
  String get vibrationThrottle => 'Control de vibración';

  @override
  String get warmTrails => '🔥 Cálido';

  @override
  String get websiteLabel => 'Sitio Web';

  @override
  String get whatToDoDescription =>
      'Explora los controles, experimenta con diferentes escenarios, y observa cómo la gravedad afecta el movimiento de los objetos celestes.';

  @override
  String get whatToDoTitle => '¿Qué hacer?';

  @override
  String get whiteColor => 'Blanco';

  @override
  String get xCoordinateEditorhint =>
      'Introducir coordenada X-Consejo del editor';

  @override
  String get xCoordinateLabel => 'Etiqueta de coordenada X';

  @override
  String get xVelocityEditorhint => 'Introducir velocidad X-Consejo del editor';

  @override
  String get yCoordinateEditorhint =>
      'Introducir coordenada Y-Consejo del editor';

  @override
  String get yCoordinateLabel => 'Etiqueta de coordenada Y';

  @override
  String get yVelocityEditorhint => 'Introducir velocidad Y-Consejo del editor';

  @override
  String get yawLabel => 'Guiñada';

  @override
  String get yellowColor => 'Amarillo';

  @override
  String get zCoordinateEditorhint =>
      'Introducir coordenada Z-Consejo del editor';

  @override
  String get zCoordinateLabel => 'Etiqueta de coordenada Z';

  @override
  String get zVelocityEditorhint => 'Introducir velocidad Z-Consejo del editor';

  @override
  String orbitalEventCloseApproach(String distance) {
    return 'Acercamiento cercano: $distance unidades';
  }

  @override
  String get accessibilityBodiesCombined =>
      'La masa combinada crea un nuevo cuerpo celeste';

  @override
  String get accessibilityBodiesInMotion =>
      'Los cuerpos celestes están ahora en movimiento';

  @override
  String get accessibilityBodiesStopped =>
      'Todos los cuerpos celestes han dejado de moverse';

  @override
  String get accessibilityBodiesResumed =>
      'Los cuerpos celestes se mueven de nuevo';

  @override
  String get accessibilityBodiesReset =>
      'Todos los cuerpos celestes han sido reiniciados';

  @override
  String get accessibilityNewScenarioLoaded =>
      'Nuevo escenario cargado con cuerpos celestes frescos';

  @override
  String get accessibilityNewParametersLoaded =>
      'Nuevos cuerpos celestes y parámetros físicos cargados';

  @override
  String get scenarioTabPresets => 'Preconfigurados';

  @override
  String get scenarioTabCustom => 'Personalizado';
}
