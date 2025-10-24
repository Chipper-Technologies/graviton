// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => '播放';

  @override
  String get pauseButton => '暂停';

  @override
  String get resetButton => '重置';

  @override
  String get speedLabel => '速度';

  @override
  String get trailsLabel => '轨迹';

  @override
  String get warmTrails => '🔥 热';

  @override
  String get coolTrails => '❄️ 冷';

  @override
  String get toggleStatsTooltip => '切换统计';

  @override
  String get toggleLabelsTooltip => '切换天体标签';

  @override
  String get showLabelsDescription => '在模拟中显示天体名称';

  @override
  String get offScreenIndicatorsTitle => '屏幕外指示器';

  @override
  String get offScreenIndicatorsDescription => '显示指向可见区域外对象的箭头';

  @override
  String get autoRotateTooltip => '自动旋转';

  @override
  String get centerViewTooltip => '居中视图';

  @override
  String get focusOnNearestTooltip => '聚焦最近的天体';

  @override
  String get followObjectTooltip => '跟踪选定对象';

  @override
  String get stopFollowingTooltip => '停止跟踪对象';

  @override
  String get selectObjectToFollowTooltip => '选择要跟踪的对象';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsTooltip => '设置';

  @override
  String get selectScenarioTooltip => '选择场景';

  @override
  String get showTrails => '显示轨迹';

  @override
  String get showTrailsDescription => '在物体后面显示运动轨迹';

  @override
  String get showOrbitalPaths => '显示轨道路径';

  @override
  String get showOrbitalPathsDescription => '在具有稳定轨道的场景中显示预测的轨道路径';

  @override
  String get dualOrbitalPaths => '双轨道路径';

  @override
  String get dualOrbitalPathsDescription => '显示理想圆形轨道和实际椭圆轨道';

  @override
  String get trailColorLabel => '轨迹颜色';

  @override
  String get closeButton => '关闭';

  @override
  String get simulationStats => '模拟统计';

  @override
  String get stepsLabel => '步数';

  @override
  String get timeLabel => '时间';

  @override
  String get earthYearsLabel => '地球年';

  @override
  String get speedStatsLabel => '速度';

  @override
  String get bodiesLabel => '天体';

  @override
  String get statusLabel => '状态';

  @override
  String get statusRunning => '运行中';

  @override
  String get statusPaused => '已暂停';

  @override
  String get cameraLabel => '相机';

  @override
  String get distanceLabel => '距离';

  @override
  String get autoRotateLabel => '自动旋转';

  @override
  String get autoRotateOn => '开启';

  @override
  String get autoRotateOff => '关闭';

  @override
  String get cameraControlsLabel => '相机控制';

  @override
  String get invertPitchControlsLabel => '反转俯仰控制';

  @override
  String get invertPitchControlsDescription => '反转上下拖拽方向';

  @override
  String get marketingLabel => '营销';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String timeFormatted(String time) {
    return '$time秒';
  }

  @override
  String earthYearsFormatted(String years) {
    return '$years年';
  }

  @override
  String speedFormatted(String speed) {
    return '$speed倍';
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
  String get scenarioSelectionTitle => '选择场景';

  @override
  String get cancel => '取消';

  @override
  String get bodies => '天体';

  @override
  String get scenarioRandom => '随机系统';

  @override
  String get scenarioRandomDescription => '随机生成的混沌三体系统，具有不可预测的动力学';

  @override
  String get scenarioEarthMoonSun => '地球-月球-太阳';

  @override
  String get scenarioEarthMoonSunDescription => '我们熟悉的地球-月球-太阳系统的教育模拟';

  @override
  String get scenarioBinaryStars => '双星系统';

  @override
  String get scenarioBinaryStarsDescription => '两颗大质量恒星相互环绕，周围有环双星行星';

  @override
  String get scenarioAsteroidBelt => '小行星带';

  @override
  String get scenarioAsteroidBeltDescription => '中央恒星被岩石小行星和碎片带环绕';

  @override
  String get scenarioGalaxyFormation => '星系形成';

  @override
  String get scenarioGalaxyFormationDescription => '观察物质围绕中央黑洞组织成螺旋结构';

  @override
  String get scenarioPlanetaryRings => '行星环';

  @override
  String get scenarioPlanetaryRingsDescription => '像土星这样大质量行星周围的环系动力学';

  @override
  String get scenarioSolarSystem => '太阳系';

  @override
  String get scenarioSolarSystemDescription => '我们太阳系的简化版本，包含内行星和外行星';

  @override
  String get habitabilityLabel => '宜居性';

  @override
  String get habitableZonesLabel => '宜居带';

  @override
  String get habitabilityIndicatorsLabel => '行星状态';

  @override
  String get habitabilityHabitable => '宜居';

  @override
  String get habitabilityTooHot => '太热';

  @override
  String get habitabilityTooCold => '太冷';

  @override
  String get habitabilityUnknown => '未知';

  @override
  String get toggleHabitableZonesTooltip => '切换宜居带';

  @override
  String get toggleHabitabilityIndicatorsTooltip => '切换行星宜居性状态';

  @override
  String get habitableZonesDescription => '显示恒星周围表示宜居区域的彩色区域';

  @override
  String get habitabilityIndicatorsDescription => '根据行星的宜居性在其周围显示颜色编码的状态环';

  @override
  String get aboutDialogTitle => '关于';

  @override
  String get appDescription => '探索引力动力学和轨道力学的物理模拟。通过交互式3D可视化体验天体运动的美丽和复杂性。';

  @override
  String get authorLabel => '作者';

  @override
  String get websiteLabel => '网站';

  @override
  String get aboutButtonTooltip => '关于';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => '版本';

  @override
  String get loadingVersion => '加载版本中...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => '重力井';

  @override
  String get gravityWellsDescription => '显示物体周围的引力场强度';

  @override
  String get languageLabel => '语言';

  @override
  String get languageDescription => '更改应用程序语言';

  @override
  String get languageSystem => '系统默认';

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
  String get bodyAlpha => '阿尔法';

  @override
  String get bodyBeta => '贝塔';

  @override
  String get bodyGamma => '伽马';

  @override
  String get bodyRockyPlanet => '岩石行星';

  @override
  String get bodyEarthLike => '类地行星';

  @override
  String get bodySuperEarth => '超级地球';

  @override
  String get bodySun => '太阳';

  @override
  String get bodyEarth => '地球';

  @override
  String get bodyMoon => '月球';

  @override
  String get bodyStarA => '恒星A';

  @override
  String get bodyStarB => '恒星B';

  @override
  String get bodyPlanetP => '行星P';

  @override
  String get bodyMoonM => '卫星M';

  @override
  String get bodyCentralStar => '中央恒星';

  @override
  String bodyAsteroid(int number) {
    return '小行星 $number';
  }

  @override
  String get bodyBlackHole => '黑洞';

  @override
  String bodyStar(int number) {
    return '恒星 $number';
  }

  @override
  String get bodyRingedPlanet => '环状行星';

  @override
  String bodyRing(int number) {
    return '环 $number';
  }

  @override
  String get bodyMercury => '水星';

  @override
  String get bodyVenus => '金星';

  @override
  String get bodyMars => '火星';

  @override
  String get bodyJupiter => '木星';

  @override
  String get bodySaturn => '土星';

  @override
  String get bodyUranus => '天王星';

  @override
  String get bodyNeptune => '海王星';

  @override
  String get bodyInnerPlanet => '内行星';

  @override
  String get bodyOuterPlanet => '外行星';

  @override
  String get educationalFocusChaoticDynamics => '混沌动力学';

  @override
  String get educationalFocusRealWorldSystem => '真实世界系统';

  @override
  String get educationalFocusBinaryOrbits => '双星轨道';

  @override
  String get educationalFocusManyBodyDynamics => '多体动力学';

  @override
  String get educationalFocusStructureFormation => '结构形成';

  @override
  String get educationalFocusPlanetaryMotion => '行星运动';

  @override
  String get updateRequiredTitle => '需要更新';

  @override
  String get updateRequiredMessage => '此应用程序有新版本可用。请更新以继续使用最新功能和改进的应用程序。';

  @override
  String get updateRequiredWarning => '此版本不再受支持。';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateLater => '稍后';

  @override
  String get versionStatusCurrent => '最新';

  @override
  String get versionStatusBeta => '测试版';

  @override
  String get versionStatusOutdated => '过期';

  @override
  String get maintenanceTitle => '维护';

  @override
  String get newsTitle => '新闻';

  @override
  String get emergencyNotificationTitle => '重要通知';

  @override
  String get ok => '确定';

  @override
  String get screenshotMode => '截图模式';

  @override
  String get screenshotModeSubtitle => '启用预设场景以捕获营销截图';

  @override
  String get hideUIInScreenshotMode => '隐藏导航';

  @override
  String get hideUIInScreenshotModeSubtitle => '当截图模式激活时隐藏应用栏、底部导航和版权信息';

  @override
  String get scenePreset => '场景预设';

  @override
  String get previousPreset => '上一个预设';

  @override
  String get nextPreset => '下一个预设';

  @override
  String get applyScene => '应用场景';

  @override
  String appliedPreset(String presetName) {
    return '已应用预设：$presetName';
  }

  @override
  String get deactivate => '停用';

  @override
  String get sceneActive => '场景已激活 - 模拟已暂停以便截图';

  @override
  String get presetGalaxyFormationOverview => '星系形成概览';

  @override
  String get presetGalaxyFormationOverviewDesc => '螺旋星系形成的广角视图，背景是宇宙';

  @override
  String get presetGalaxyCoreDetail => '星系核心细节';

  @override
  String get presetGalaxyCoreDetailDesc => '明亮星系中心与吸积盘的特写';

  @override
  String get presetGalaxyBlackHole => '星系黑洞';

  @override
  String get presetGalaxyBlackHoleDesc => '星系中心超大质量黑洞的特写视图';

  @override
  String get presetCompleteSolarSystem => '完整太阳系';

  @override
  String get presetCompleteSolarSystemDesc => '所有行星可见，具有美丽的轨道轨迹';

  @override
  String get presetInnerSolarSystem => '内太阳系';

  @override
  String get presetInnerSolarSystemDesc => '水星、金星、地球和火星的特写，带有宜居带指示器';

  @override
  String get presetEarthView => '地球视图';

  @override
  String get presetEarthViewDesc => '地球的近距离视角，具有大气细节';

  @override
  String get presetSaturnRings => '土星的壮丽光环';

  @override
  String get presetSaturnRingsDesc => '土星的特写，具有详细的环系统';

  @override
  String get presetEarthMoonSystem => '地月系统';

  @override
  String get presetEarthMoonSystemDesc => '地球和月球，具有可见的轨道力学';

  @override
  String get presetBinaryStarDrama => '双星戏剧';

  @override
  String get presetBinaryStarDramaDesc => '两颗大质量恒星引力舞蹈的正面视图';

  @override
  String get presetBinaryStarPlanetMoon => '双星行星与月球';

  @override
  String get presetBinaryStarPlanetMoonDesc => '在混沌双星系统中轨道运行的行星和月球';

  @override
  String get presetAsteroidBeltChaos => '小行星带混沌';

  @override
  String get presetAsteroidBeltChaosDesc => '密集的小行星场，具有引力效应';

  @override
  String get presetThreeBodyBallet => '三体芭蕾';

  @override
  String get presetThreeBodyBalletDesc => '经典三体问题的优雅运动';

  @override
  String get privacyPolicyLabel => '隐私政策';

  @override
  String get helpAndObjectivesTitle => '帮助和目标';

  @override
  String get whatToDoTitle => '要做什么';

  @override
  String get whatToDoDescription => '学习如何导航和与三体引力模拟进行交互。';

  @override
  String get getStarted => '开始';

  @override
  String get objectivesTitle => '目标';

  @override
  String get objectivesDescription => '探索三体引力系统的迷人动力学，学习轨道力学。';

  @override
  String get quickStartTitle => '快速入门指南';

  @override
  String get quickStartDescription => '通过选择场景、调整控件和观察引力相互作用来开始探索模拟。';

  @override
  String get showHelpTooltip => '显示帮助';

  @override
  String get tutorialButton => '教程';

  @override
  String get resetTutorialButton => '重置教程';

  @override
  String get tutorialComingSoon => '教程功能即将推出！';

  @override
  String get tutorialResetMessage => '教程状态已重置！';

  @override
  String get tutorialOverlayTitle => '教程即将推出！';

  @override
  String get tutorialOverlayDescription => '交互式教程功能将在未来的更新中提供。';

  @override
  String get continueButton => '继续';

  @override
  String get objectives1 =>
      'Understand gravitational interactions between three bodies';

  @override
  String get objectives2 =>
      'Observe orbital mechanics and chaos theory in action';

  @override
  String get objectives3 => 'Experiment with different initial conditions';

  @override
  String get objectives4 =>
      'Learn about Lagrange points and stable configurations';

  @override
  String get objectives5 =>
      'Explore how small changes lead to dramatically different outcomes';

  @override
  String get objectives6 =>
      'Develop intuition for N-body gravitational systems';

  @override
  String get quickStart1 =>
      'Select a scenario from the menu to start with predefined conditions';

  @override
  String get quickStart2 =>
      'Use play/pause controls to start and stop the simulation';

  @override
  String get quickStart3 =>
      'Adjust simulation speed to observe at different time scales';

  @override
  String get quickStart4 => 'Toggle trails to see orbital paths over time';

  @override
  String get quickStart5 =>
      'Tap bodies to select and view detailed information';

  @override
  String get quickStart6 =>
      'Experiment with different settings to explore various outcomes';

  @override
  String get moreOptionsTooltip => '更多选项';

  @override
  String get exploreScenarios => '探索不同场景';

  @override
  String get physicsSettingsTitle => '物理设置';

  @override
  String get customParametersActive => '自定义参数已激活';

  @override
  String get advancedSimulationParameters => '高级仿真参数';

  @override
  String get visualBehaviorOptions => '视觉和行为选项';

  @override
  String get tutorialObjectives => '教程和目标';
}
