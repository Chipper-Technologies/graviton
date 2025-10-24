// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => 'Reproducir';

  @override
  String get pauseButton => 'Pausar';

  @override
  String get resetButton => 'Reiniciar';

  @override
  String get speedLabel => 'Velocidad';

  @override
  String get trailsLabel => 'Rastros';

  @override
  String get warmTrails => '🔥 Cálido';

  @override
  String get coolTrails => '❄️ Frío';

  @override
  String get toggleStatsTooltip => 'Alternar Estadísticas';

  @override
  String get toggleLabelsTooltip => 'Alternar Etiquetas de Cuerpos';

  @override
  String get showLabelsDescription =>
      'Mostrar nombres de cuerpos celestes en la simulación';

  @override
  String get offScreenIndicatorsTitle => 'Indicadores Fuera de Pantalla';

  @override
  String get offScreenIndicatorsDescription =>
      'Mostrar flechas apuntando a objetos fuera del área visible';

  @override
  String get autoRotateTooltip => 'Rotación Automática';

  @override
  String get centerViewTooltip => 'Centrar Vista';

  @override
  String get focusOnNearestTooltip => 'Enfocar en el Cuerpo Más Cercano';

  @override
  String get followObjectTooltip => 'Seguir Objeto Seleccionado';

  @override
  String get stopFollowingTooltip => 'Dejar de Seguir Objeto';

  @override
  String get selectObjectToFollowTooltip => 'Seleccionar Objeto para Seguir';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsTooltip => 'Configuración';

  @override
  String get selectScenarioTooltip => 'Seleccionar Escenario';

  @override
  String get showTrails => 'Mostrar Rastros';

  @override
  String get showTrailsDescription =>
      'Mostrar estelas de movimiento detrás de los objetos';

  @override
  String get showOrbitalPaths => 'Mostrar Trayectorias Orbitales';

  @override
  String get showOrbitalPathsDescription =>
      'Mostrar trayectorias orbitales predichas en escenarios con órbitas estables';

  @override
  String get dualOrbitalPaths => 'Trayectorias Orbitales Duales';

  @override
  String get dualOrbitalPathsDescription =>
      'Mostrar tanto trayectorias orbitales circulares ideales como elípticas reales';

  @override
  String get trailColorLabel => 'Color de Rastro';

  @override
  String get closeButton => 'Cerrar';

  @override
  String get simulationStats => 'Estadísticas de Simulación';

  @override
  String get stepsLabel => 'Pasos';

  @override
  String get timeLabel => 'Tiempo';

  @override
  String get earthYearsLabel => 'Años Terrestres';

  @override
  String get speedStatsLabel => 'Velocidad';

  @override
  String get bodiesLabel => 'Cuerpos';

  @override
  String get statusLabel => 'Estado';

  @override
  String get statusRunning => 'Ejecutándose';

  @override
  String get statusPaused => 'Pausado';

  @override
  String get cameraLabel => 'Cámara';

  @override
  String get distanceLabel => 'Distancia';

  @override
  String get autoRotateLabel => 'Rotación automática';

  @override
  String get autoRotateOn => 'Activado';

  @override
  String get autoRotateOff => 'Desactivado';

  @override
  String get cameraControlsLabel => 'Controles de Cámara';

  @override
  String get invertPitchControlsLabel => 'Invertir Controles de Inclinación';

  @override
  String get invertPitchControlsDescription =>
      'Invertir la dirección de arrastre arriba/abajo';

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
    return '$years años';
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
  String get scenarioSelectionTitle => 'Seleccionar Escenario';

  @override
  String get cancel => 'Cancelar';

  @override
  String get bodies => 'cuerpos';

  @override
  String get scenarioRandom => 'Sistema Aleatorio';

  @override
  String get scenarioRandomDescription =>
      'Sistema caótico de tres cuerpos generado aleatoriamente con dinámica impredecible';

  @override
  String get scenarioEarthMoonSun => 'Tierra-Luna-Sol';

  @override
  String get scenarioEarthMoonSunDescription =>
      'Simulación educativa de nuestro familiar sistema Tierra-Luna-Sol';

  @override
  String get scenarioBinaryStars => 'Estrellas Binarias';

  @override
  String get scenarioBinaryStarsDescription =>
      'Dos estrellas masivas orbitándose mutuamente con planetas circumbinarios';

  @override
  String get scenarioAsteroidBelt => 'Cinturón de Asteroides';

  @override
  String get scenarioAsteroidBeltDescription =>
      'Estrella central rodeada por un cinturón de asteroides rocosos y escombros';

  @override
  String get scenarioGalaxyFormation => 'Formación de Galaxia';

  @override
  String get scenarioGalaxyFormationDescription =>
      'Observa cómo la materia se organiza en estructuras espirales alrededor de un agujero negro central';

  @override
  String get scenarioPlanetaryRings => 'Anillos Planetarios';

  @override
  String get scenarioPlanetaryRingsDescription =>
      'Dinámica del sistema de anillos alrededor de un planeta masivo como Saturno';

  @override
  String get scenarioSolarSystem => 'Sistema Solar';

  @override
  String get scenarioSolarSystemDescription =>
      'Versión simplificada de nuestro sistema solar con planetas interiores y exteriores';

  @override
  String get habitabilityLabel => 'Habitabilidad';

  @override
  String get habitableZonesLabel => 'Zonas Habitables';

  @override
  String get habitabilityIndicatorsLabel => 'Estado del Planeta';

  @override
  String get habitabilityHabitable => 'Habitable';

  @override
  String get habitabilityTooHot => 'Demasiado Caliente';

  @override
  String get habitabilityTooCold => 'Demasiado Frío';

  @override
  String get habitabilityUnknown => 'Desconocido';

  @override
  String get toggleHabitableZonesTooltip => 'Alternar Zonas Habitables';

  @override
  String get toggleHabitabilityIndicatorsTooltip =>
      'Alternar Estado de Habitabilidad del Planeta';

  @override
  String get habitableZonesDescription =>
      'Mostrar zonas coloreadas alrededor de estrellas indicando regiones habitables';

  @override
  String get habitabilityIndicatorsDescription =>
      'Mostrar anillos de estado codificados por color alrededor de planetas basados en su habitabilidad';

  @override
  String get aboutDialogTitle => 'Acerca de';

  @override
  String get appDescription =>
      'Una simulación de física que explora la dinámica gravitacional y la mecánica orbital. Experimenta la belleza y complejidad del movimiento celestial a través de visualización 3D interactiva.';

  @override
  String get authorLabel => 'Autor';

  @override
  String get websiteLabel => 'Sitio Web';

  @override
  String get aboutButtonTooltip => 'Acerca de';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => 'Versión';

  @override
  String get loadingVersion => 'Cargando versión...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => 'Pozos Gravitacionales';

  @override
  String get gravityWellsDescription =>
      'Mostrar la intensidad del campo gravitacional alrededor de objetos';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageDescription => 'Cambiar el idioma de la aplicación';

  @override
  String get languageSystem => 'Predeterminado del Sistema';

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
  String get bodyAlpha => 'Alfa';

  @override
  String get bodyBeta => 'Beta';

  @override
  String get bodyGamma => 'Gama';

  @override
  String get bodyRockyPlanet => 'Planeta Rocoso';

  @override
  String get bodyEarthLike => 'Tipo Tierra';

  @override
  String get bodySuperEarth => 'Supertierra';

  @override
  String get bodySun => 'Sol';

  @override
  String get bodyEarth => 'Tierra';

  @override
  String get bodyMoon => 'Luna';

  @override
  String get bodyStarA => 'Estrella A';

  @override
  String get bodyStarB => 'Estrella B';

  @override
  String get bodyPlanetP => 'Planeta P';

  @override
  String get bodyMoonM => 'Luna M';

  @override
  String get bodyCentralStar => 'Estrella Central';

  @override
  String bodyAsteroid(int number) {
    return 'Asteroide $number';
  }

  @override
  String get bodyBlackHole => 'Agujero Negro';

  @override
  String bodyStar(int number) {
    return 'Estrella $number';
  }

  @override
  String get bodyRingedPlanet => 'Planeta con Anillos';

  @override
  String bodyRing(int number) {
    return 'Anillo $number';
  }

  @override
  String get bodyMercury => 'Mercurio';

  @override
  String get bodyVenus => 'Venus';

  @override
  String get bodyMars => 'Marte';

  @override
  String get bodyJupiter => 'Júpiter';

  @override
  String get bodySaturn => 'Saturno';

  @override
  String get bodyUranus => 'Urano';

  @override
  String get bodyNeptune => 'Neptuno';

  @override
  String get bodyInnerPlanet => 'Planeta Interior';

  @override
  String get bodyOuterPlanet => 'Planeta Exterior';

  @override
  String get educationalFocusChaoticDynamics => 'dinámicas caóticas';

  @override
  String get educationalFocusRealWorldSystem => 'sistema del mundo real';

  @override
  String get educationalFocusBinaryOrbits => 'órbitas binarias';

  @override
  String get educationalFocusManyBodyDynamics => 'dinámicas de muchos cuerpos';

  @override
  String get educationalFocusStructureFormation => 'formación de estructuras';

  @override
  String get educationalFocusPlanetaryMotion => 'movimiento planetario';

  @override
  String get updateRequiredTitle => 'Actualización requerida';

  @override
  String get updateRequiredMessage =>
      'Una versión más reciente de esta aplicación está disponible. Por favor actualice para continuar usando la aplicación con las últimas características y mejoras.';

  @override
  String get updateRequiredWarning => 'Esta versión ya no es compatible.';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get versionStatusCurrent => 'Actual';

  @override
  String get versionStatusBeta => 'Beta';

  @override
  String get versionStatusOutdated => 'Desactualizado';

  @override
  String get maintenanceTitle => 'Mantenimiento';

  @override
  String get newsTitle => 'Noticias';

  @override
  String get emergencyNotificationTitle => 'Aviso Importante';

  @override
  String get ok => 'OK';

  @override
  String get screenshotMode => 'Modo de Captura';

  @override
  String get screenshotModeSubtitle =>
      'Activar escenas predefinidas para capturas de marketing';

  @override
  String get hideUIInScreenshotMode => 'Ocultar Navegación';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'Ocultar barra de aplicación, navegación inferior y copyright cuando el modo captura esté activo';

  @override
  String get scenePreset => 'Escena Predefinida';

  @override
  String get previousPreset => 'Escena anterior';

  @override
  String get nextPreset => 'Escena siguiente';

  @override
  String get applyScene => 'Aplicar Escena';

  @override
  String appliedPreset(String presetName) {
    return 'Escena aplicada: $presetName';
  }

  @override
  String get deactivate => 'Desactivar';

  @override
  String get sceneActive => 'Escena activa - simulación pausada para captura';

  @override
  String get presetGalaxyFormationOverview =>
      'Vista General de Formación Galáctica';

  @override
  String get presetGalaxyFormationOverviewDesc =>
      'Vista amplia de la formación de galaxia espiral con fondo cósmico';

  @override
  String get presetGalaxyCoreDetail => 'Detalle del Núcleo Galáctico';

  @override
  String get presetGalaxyCoreDetailDesc =>
      'Primer plano del brillante centro galáctico con disco de acreción';

  @override
  String get presetGalaxyBlackHole => 'Agujero Negro Galáctico';

  @override
  String get presetGalaxyBlackHoleDesc =>
      'Vista cercana del agujero negro supermasivo en el centro galáctico';

  @override
  String get presetCompleteSolarSystem => 'Sistema Solar Completo';

  @override
  String get presetCompleteSolarSystemDesc =>
      'Todos los planetas visibles con hermosas órbitas';

  @override
  String get presetInnerSolarSystem => 'Sistema Solar Interior';

  @override
  String get presetInnerSolarSystemDesc =>
      'Primer plano de Mercurio, Venus, Tierra y Marte con indicador de zona habitable';

  @override
  String get presetEarthView => 'Vista de la Tierra';

  @override
  String get presetEarthViewDesc =>
      'Perspectiva cercana de la Tierra con detalle atmosférico';

  @override
  String get presetSaturnRings => 'Anillos Majestuosos de Saturno';

  @override
  String get presetSaturnRingsDesc =>
      'Primer plano de Saturno con sistema de anillos detallado';

  @override
  String get presetEarthMoonSystem => 'Sistema Tierra-Luna';

  @override
  String get presetEarthMoonSystemDesc =>
      'Tierra y Luna con mecánica orbital visible';

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
  String get presetAsteroidBeltChaos => 'Caos del Cinturón de Asteroides';

  @override
  String get presetAsteroidBeltChaosDesc =>
      'Campo denso de asteroides con efectos gravitacionales';

  @override
  String get presetThreeBodyBallet => 'Ballet de Tres Cuerpos';

  @override
  String get presetThreeBodyBalletDesc =>
      'Problema clásico de tres cuerpos en movimiento elegante';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioLearnSolar =>
      'Aprende: Movimiento planetario, mecánica orbital, cuerpos celestes familiares';

  @override
  String get scenarioBestSolar =>
      'Ideal para: Principiantes, entusiastas de la astronomía';

  @override
  String get scenarioLearnEarthMoon =>
      'Aprende: Dinámicas de tres cuerpos, mecánica lunar, fuerzas de marea';

  @override
  String get scenarioBestEarthMoon =>
      'Ideal para: Entender el sistema Tierra-Luna';

  @override
  String get scenarioLearnBinary =>
      'Aprende: Evolución estelar, sistemas binarios, gravedad extrema';

  @override
  String get scenarioBestBinary => 'Ideal para: Exploración avanzada de física';

  @override
  String get scenarioLearnThreeBody =>
      'Aprende: Teoría del caos, movimiento impredecible, sistemas inestables';

  @override
  String get scenarioBestThreeBody =>
      'Ideal para: Entusiastas de la física matemática';

  @override
  String get scenarioLearnRandom =>
      'Aprende: Descubre configuraciones desconocidas, física experimental';

  @override
  String get scenarioBestRandom => 'Ideal para: Exploración y experimentación';

  @override
  String get privacyPolicyLabel => 'Política de Privacidad';

  @override
  String get tutorialWelcomeTitle => '¡Bienvenido a Graviton!';

  @override
  String get tutorialWelcomeDescription =>
      '¡Bienvenido a Graviton, tu ventana al fascinante mundo de la física gravitacional! Esta aplicación te permite explorar cómo los cuerpos celestes interactúan a través de la gravedad, creando hermosas danzas orbitales a través del espacio y el tiempo.';

  @override
  String get tutorialObjectivesTitle => '¿Qué puedes hacer?';

  @override
  String get tutorialObjectivesDescription =>
      '• Observar mecánica orbital realista\n• Explorar diferentes escenarios astronómicos\n• Experimentar con interacciones gravitacionales\n• Ver colisiones y fusiones\n• Aprender sobre movimiento planetario\n• Descubrir dinámicas caóticas de tres cuerpos';

  @override
  String get tutorialControlsTitle => 'Controles Básicos';

  @override
  String get tutorialControlsDescription =>
      'Usa los controles superiores para Reproducir/Pausar la simulación, Reiniciar para nuevos escenarios, y ajustar la Velocidad de simulación. El botón de Configuración te permite personalizar rastros y otras opciones visuales.';

  @override
  String get tutorialCameraTitle => 'Controles de Cámara';

  @override
  String get tutorialCameraDescription =>
      'Arrastra para rotar la vista, pellizca para hacer zoom, y usa los botones inferiores para centrar la vista o seguir objetos específicos. Toca cualquier cuerpo celeste para seleccionarlo y seguir su movimiento.';

  @override
  String get tutorialScenariosTitle => 'Explorar Escenarios';

  @override
  String get tutorialScenariosDescription =>
      'Toca el botón de escenario en la parte inferior para explorar diferentes configuraciones: desde nuestro sistema solar hasta sistemas estelares exóticos y problemas clásicos de tres cuerpos. Cada escenario ofrece perspectivas únicas sobre la mecánica gravitacional.';

  @override
  String get tutorialExploreTitle => '¡Comienza a Explorar!';

  @override
  String get tutorialExploreDescription =>
      '¡Ahora estás listo para explorar el cosmos! Experimenta con diferentes escenarios, ajusta configuraciones, y observa cómo la gravedad da forma al baile de los cuerpos celestes. ¡Que disfrutes tu viaje a través del universo!';

  @override
  String get skipTutorial => 'Saltar Tutorial';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get showTutorialTooltip => 'Mostrar Tutorial';

  @override
  String get helpAndObjectivesTitle => 'Ayuda y Objetivos';

  @override
  String get whatToDoTitle => '¿Qué hacer?';

  @override
  String get whatToDoDescription =>
      'Explora los controles, experimenta con diferentes escenarios, y observa cómo la gravedad afecta el movimiento de los objetos celestes.';

  @override
  String get objectivesTitle => 'Objetivos';

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
  String get quickStartTitle => 'Inicio Rápido';

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
  String get objectivesDescription =>
      '• Comprender cómo la gravedad da forma al cosmos\n• Observar sistemas orbitales estables vs. caóticos\n• Aprender por qué los planetas se mueven en órbitas elípticas\n• Descubrir cómo interactúan las estrellas binarias\n• Ver qué sucede cuando los objetos colisionan\n• Apreciar la complejidad del problema de tres cuerpos';

  @override
  String get quickStartDescription =>
      '1. Elige un escenario (Sistema Solar recomendado para principiantes)\n2. Presiona Play para iniciar la simulación\n3. Arrastra para rotar tu vista, pellizca para hacer zoom\n4. Toca el deslizador de Velocidad para controlar el tiempo\n5. Prueba Reiniciar para nuevas configuraciones aleatorias\n6. Activa Rastros para ver las trayectorias orbitales';

  @override
  String get showHelpTooltip => 'Mostrar Ayuda';

  @override
  String get tutorialButton => 'Tutorial';

  @override
  String get resetTutorialButton => 'Reiniciar';

  @override
  String get tutorialResetMessage =>
      '¡Estado del tutorial reiniciado! Reinicia la aplicación para ver la experiencia de primera vez.';

  @override
  String get copyButton => 'Copiar';

  @override
  String couldNotOpenUrl(String url) {
    return 'No se pudo abrir $url';
  }

  @override
  String errorOpeningLink(String error) {
    return 'Error al abrir el enlace: $error';
  }

  @override
  String copiedToClipboard(String text) {
    return 'Copiado al portapapeles: $text';
  }
}
