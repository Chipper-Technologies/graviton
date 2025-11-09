// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appDescription => '探索引力动力学和轨道力学的物理模拟。通过交互式3D可视化体验天体运动的美丽和复杂性。';

  @override
  String get appFlavorDevelopment => '开发';

  @override
  String get appFlavorProduction => '生产';

  @override
  String get appInformationCredits => '应用信息和致谢';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => '返回';

  @override
  String get bottomNavVisualsLabel => '视觉';

  @override
  String get collisionHapticFeedbackDescription => '在模拟过程中天体碰撞时启用触觉反馈';

  @override
  String get exitFullscreenHint => '点击任意位置退出全屏模式';

  @override
  String get fullscreenMode => '全屏模式';

  @override
  String get fullscreenModeDescription => '隐藏所有UI元素以获得沉浸式观看体验';

  @override
  String get hapticFeedbackCollisions => '碰撞时的触觉反馈';

  @override
  String get hapticFeedbackDescription => '为UI交互和碰撞启用触觉反馈';

  @override
  String get uiHapticFeedbackDescription => '为按钮点击、切换开关和导航等UI交互启用触觉反馈';

  @override
  String get displayOptionsTitle => '显示选项';

  @override
  String get pauseButton => '暂停';

  @override
  String get playButton => '播放';

  @override
  String get presetAsteroidBeltChaos => '小行星带混沌';

  @override
  String get presetAsteroidBeltChaosDesc => '密集的小行星场，具有引力效应';

  @override
  String get presetBinaryStarDrama => '双星戏剧';

  @override
  String get presetBinaryStarDramaDesc => '两颗大质量恒星引力舞蹈的正面视图';

  @override
  String get presetBinaryStarPlanetMoon => '双星行星与月球';

  @override
  String get presetBinaryStarPlanetMoonDesc => '在混沌双星系统中轨道运行的行星和月球';

  @override
  String get presetCompleteSolarSystem => '完整太阳系';

  @override
  String get presetCompleteSolarSystemDesc => '所有行星可见，具有美丽的轨道轨迹';

  @override
  String get presetEarthMoonSystem => '地月系统';

  @override
  String get presetEarthMoonSystemDesc => '地球和月球，具有可见的轨道力学';

  @override
  String get presetEarthView => '地球视图';

  @override
  String get presetEarthViewDesc => '地球的近距离视角，具有大气细节';

  @override
  String get presetGalaxyBlackHole => '星系黑洞';

  @override
  String get presetGalaxyBlackHoleDesc => '星系中心超大质量黑洞的特写视图';

  @override
  String get presetGalaxyCoreDetail => '星系核心细节';

  @override
  String get presetGalaxyCoreDetailDesc => '明亮星系中心与吸积盘的特写';

  @override
  String get presetGalaxyFormationOverview => '星系形成概览';

  @override
  String get presetGalaxyFormationOverviewDesc => '螺旋星系形成的广角视图，背景是宇宙';

  @override
  String get presetInnerSolarSystem => '内太阳系';

  @override
  String get presetInnerSolarSystemDesc => '水星、金星、地球和火星的特写，带有宜居带指示器';

  @override
  String get presetSaturnRings => '土星的壮丽光环';

  @override
  String get presetSaturnRingsDesc => '土星的特写，具有详细的环系统';

  @override
  String get presetThreeBodyBallet => '三体芭蕾';

  @override
  String get presetThreeBodyBalletDesc => '经典三体问题的优雅运动';

  @override
  String get resetButton => '重置';

  @override
  String get resetChangelogButton => '重置更新日志状态';

  @override
  String get resetChangelogDescription => '重置更新日志阅读状态';

  @override
  String get resetSettingsDescription => '将所有设置重置为默认值';

  @override
  String get resetTutorialDescription => '重置教程进度';

  @override
  String get simulationCanvasFocused => '模拟画布已聚焦 - 主要物理模拟区域';

  @override
  String get simulationCanvasHint => '使用键盘快捷键控制模拟。空格键暂停，R键重新开始，C键居中相机';

  @override
  String get simulationCanvasLabel => '引力物理模拟';

  @override
  String get simulationControlsFocused => '模拟控制已聚焦';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return '具有$bodyCount个天体的引力模拟。状态：$status。速度：$speed。步骤：$steps';
  }

  @override
  String get simulationSpeed => '模拟速度';

  @override
  String get simulationSpeedHint => '调整模拟速度从0.1倍到16倍正常速度。使用箭头键进行小幅调整。';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return '具有$bodyCount个天体的引力模拟。状态：$status。速度：$speed。已完成步骤：$stepCount。点击与模拟交互或使用键盘快捷键。';
  }

  @override
  String get simulationStats => '模拟统计';

  @override
  String get simulationStepsLabel => '模拟步骤';

  @override
  String get speedDouble => '二倍速';

  @override
  String get speedFast => '快速';

  @override
  String speedFormatted(String speed) {
    return '$speed倍';
  }

  @override
  String get speedHalf => '半速';

  @override
  String get speedLabel => '速度';

  @override
  String get speedMaximum => '最大';

  @override
  String get speedNormal => '正常';

  @override
  String get speedQuarter => '四分之一速度';

  @override
  String get speedVeryFast => '非常快';

  @override
  String get stopFollowTitle => '停止跟随';

  @override
  String get stopFollowingTooltip => '停止跟踪对象';

  @override
  String get stopRotateTitle => '停止旋转';

  @override
  String get testPresetForUnitTesting => '单元测试的测试预设';

  @override
  String get trailsLabel => '轨迹';

  @override
  String get cameraControlsFocused => '相机控制已聚焦';

  @override
  String get cameraControlsLabel => '相机控制';

  @override
  String get cameraDynamicFraming => '动态构图';

  @override
  String get cameraDynamicFramingDescription => '根据场景内容自动调整构图';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return '距离$distance跟随$bodyName的相机。自动旋转：$rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return '距离$distance的自由模式相机。自动旋转：$rotation';
  }

  @override
  String get cameraLabel => '相机';

  @override
  String get cameraManual => '手动控制';

  @override
  String get cameraManualDescription => '带跟随模式的传统手动相机控制';

  @override
  String get cameraPredictiveOrbital => '预测轨道';

  @override
  String get cameraPredictiveOrbitalDescription => 'AI预测轨道路径以实现戏剧性的相机动作';

  @override
  String get cameraSettingsTitle => '相机设置';

  @override
  String get cameraSpeedHint => '调整AI相机移动速度从慢到快。使用方向键进行小幅调整。';

  @override
  String get cameraSpeedLabel => '相机速度';

  @override
  String get cameraTooltip => '相机设置和AI模式';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => '距离';

  @override
  String get previewEditortitle => '预览编辑器标题';

  @override
  String get rotateLabel => '旋转';

  @override
  String get viewPhysicsSettings => '查看物理设置';

  @override
  String get zoomInAction => '放大';

  @override
  String get zoomLabel => '缩放';

  @override
  String get zoomOutAction => '缩小';

  @override
  String get colorEditor => '颜色编辑器';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return '颜色选项 $color';
  }

  @override
  String get colorSelector => '颜色选择器';

  @override
  String get visualsTooltip => '视觉显示选项';

  @override
  String get collisionHapticFeedback => '碰撞触觉反馈';

  @override
  String get collisionSensitivity => '碰撞敏感度';

  @override
  String get gravityColorSchemeClassic => '经典';

  @override
  String get gravityColorSchemeEmerald => '翡翠';

  @override
  String get gravityColorSchemeMonochrome => '单色';

  @override
  String get gravityColorSchemeNeon => '霓虹';

  @override
  String get gravityColorSchemeSpectral => '光谱';

  @override
  String get gravityEditor => '重力编辑器';

  @override
  String get gravityFieldColorSchemeDescription => '选择引力场可视化的颜色方案';

  @override
  String get gravityFieldColorSchemeLabel => '引力场颜色';

  @override
  String get gravityFieldIndicatorsDescription => '显示引力场强度的视觉指示器';

  @override
  String get gravityFieldIndicatorsLabel => '场强度指示器';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => '场强度';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription => '显示重力场可视化';

  @override
  String get gravityFieldsTitle => '重力场';

  @override
  String get gravityWellsDescription => '显示物体周围的引力场强度';

  @override
  String get gravityWellsLabel => '重力井';

  @override
  String get massKgEditorhint => '输入质量（千克）';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      '物理配置将在此处实现-编辑器';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return '物理字段超出范围';
  }

  @override
  String get physicsSection => '物理学';

  @override
  String get physicsSettingsDescription => '模拟参数';

  @override
  String get physicsSettingsTitle => '物理设置';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return '物理：$time时间单位，$earthYears地球年，$steps模拟步骤已完成';
  }

  @override
  String get physicsTooltip => '物理可视化和设置';

  @override
  String get physicsVisualizationTitle => '物理可视化';

  @override
  String get temperatureCold => '寒冷';

  @override
  String get temperatureEditorlabel => '温度编辑器标签';

  @override
  String get temperatureFrozen => '极寒';

  @override
  String get temperatureHot => '炎热';

  @override
  String get temperatureKEditorhint => '输入温度（开尔文）';

  @override
  String get temperatureModerate => '温和';

  @override
  String get temperatureNotApplicable => '不适用';

  @override
  String get temperatureScorching => '灼热';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get velocityMsEditor => '速度 m/s 编辑器';

  @override
  String get addBodyButton => '添加天体按钮';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      '添加天体以创建自定义场景-编辑器';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      '小行星带和其他粒子系统将在此处配置-编辑器';

  @override
  String get beginnerEditor => '初学者编辑器';

  @override
  String get bodyTypeEditor => '天体类型编辑器';

  @override
  String get createACopyOfThisCelestialBodyEditorHint => '创建此天体的副本-编辑器提示';

  @override
  String get createCustomScenarioButton => '创建自定义场景按钮';

  @override
  String get createCustomScenarioDescription => '自定义场景描述';

  @override
  String get createScenarioButton => '创建场景按钮';

  @override
  String get createScenarioTitle => '创建场景标题';

  @override
  String get customGravitationalSimulationEditor => '自定义引力模拟编辑器';

  @override
  String get deleteBodyConfirmMessage => '天体删除确认消息';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return '天体删除确认标题';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return '删除 $bodyName';
  }

  @override
  String get deleteBodyTooltip => '删除天体工具提示';

  @override
  String get deleteButton => '删除按钮';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return '场景删除确认消息';
  }

  @override
  String get deleteScenarioTitle => '删除场景标题';

  @override
  String deleteScenarioSuccessMessage(String scenarioName) {
    return '场景删除成功: $scenarioName';
  }

  @override
  String deleteScenarioFailedMessage(String error) {
    return '场景删除失败: $error';
  }

  @override
  String get editEditorLabel => '编辑编辑器标签';

  @override
  String get editScenarioTitle => '编辑场景标题';

  @override
  String get gravitationalForcesEditor => '引力编辑器';

  @override
  String get newScenarioEditor => '新场景编辑器';

  @override
  String get noBodiesYetEditor => '尚无天体-编辑器';

  @override
  String get positionMEditor => '位置 m 编辑器';

  @override
  String get positionMotionEditor => '位置/运动编辑器';

  @override
  String get propertiesEditor => '属性编辑器';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      '从场景中移除此天体-编辑器提示';

  @override
  String get softeningEditor => '软化编辑器';

  @override
  String get stellarPropertiesEditor => '恒星属性编辑器';

  @override
  String get trailPointsEditor => '轨迹点编辑器';

  @override
  String get customColor => '自定义颜色';

  @override
  String get customLabel => '自定义标签';

  @override
  String get customScenarioDescription => '自定义场景描述';

  @override
  String get exportScenarioButton => '导出场景';

  @override
  String exportScenarioFailedMessage(String error) {
    return '场景导出失败';
  }

  @override
  String get exportScenarioNotImplementedMessage => '场景导出未实现';

  @override
  String get saveButton => '保存';

  @override
  String get settingsButtonFocused => '设置按钮已聚焦';

  @override
  String get settingsMenuDescription => '视觉和行为选项';

  @override
  String get settingsTooltip => '应用程序设置';

  @override
  String get toggleAutoRotateAction => '切换自动旋转';

  @override
  String get toggleGravityFieldsTooltip => '切换引力场';

  @override
  String get toggleHabitabilityIndicatorsTooltip => '切换行星宜居性状态';

  @override
  String get toggleHabitableZonesTooltip => '切换宜居带';

  @override
  String get toggleLabelsTooltip => '切换天体标签';

  @override
  String get toggleStatsTooltip => '切换统计';

  @override
  String get statsLabel => '统计';

  @override
  String get helpMenuDescription => '教程和目标';

  @override
  String get tutorialButton => '教程';

  @override
  String get tutorialCameraDescription =>
      '拖动来旋转视图，捏合缩放，使用两个手指滚动相机。底部栏有焦点、居中和自动旋转控件，提供电影般的体验。';

  @override
  String get tutorialCameraTitle => '相机和视图控制';

  @override
  String get tutorialControlsDescription =>
      '点击任何地方显示模拟的浮动播放/暂停控件。速度控制在右上角。点击菜单(⋮)获取场景、设置和物理调整。';

  @override
  String get tutorialControlsDescriptionPart1 =>
      '点击任何地方显示模拟的浮动播放/暂停控件。速度控制在右上角。点击菜单';

  @override
  String get tutorialControlsDescriptionPart2 => '获取场景、设置和物理调整。';

  @override
  String get tutorialControlsTitle => '模拟控制';

  @override
  String get tutorialDescription => '应用的交互式导览';

  @override
  String get tutorialExploreDescription =>
      '您已准备就绪！从太阳系开始看熟悉的行星，或深入三体问题享受混沌乐趣。记住：每次重置都会创造一个新的宇宙供您探索！';

  @override
  String get tutorialExploreTitle => '准备探索！';

  @override
  String get tutorialNavigationHint => '左右滑动或使用按钮进行导航';

  @override
  String get tutorialObjectivesDescription =>
      '• 观察真实的轨道力学\n• 探索不同的天文场景\n• 实验引力相互作用\n• 观看碰撞和合并\n• 学习行星运动\n• 发现混沌的三体动力学';

  @override
  String get tutorialObjectivesTitle => '您可以做什么？';

  @override
  String get tutorialResetMessage => '教程状态已重置！重启应用程序以查看首次体验。';

  @override
  String get tutorialResetSuccess => '教程进度已重置';

  @override
  String get tutorialScenariosDescription =>
      '访问右上角的菜单(⋮)探索不同场景：我们的太阳系、地月动力学、双星，或混沌的三体问题。每个都提供独特的物理学供您发现！';

  @override
  String get tutorialScenariosDescriptionPart1 => '访问右上角的菜单';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      '探索不同场景：我们的太阳系、地月动力学、双星，或混沌的三体问题。每个都提供独特的物理学供您发现！';

  @override
  String get tutorialScenariosTitle => '选择您的冒险';

  @override
  String get tutorialWelcomeDescription =>
      '欢迎来到Graviton，这是您进入引力物理学迷人世界的窗口！这个应用程序让您探索天体如何通过重力相互作用，在空间和时间中创造美丽的轨道舞蹈。';

  @override
  String get tutorialWelcomeTitle => '欢迎来到Graviton！';

  @override
  String get welcomeCardDescription => '通过交互式模拟探索引力物理学。尝试不同的场景，调整控制，观看宇宙的展开！';

  @override
  String get cancel => '取消';

  @override
  String get descriptionEditorLabel => '描述编辑器标签';

  @override
  String get next => '下一个';

  @override
  String get ok => '确定';

  @override
  String get previous => '上一个';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType已更改为$value';
  }

  @override
  String timeFormatted(String time) {
    return '$time秒';
  }

  @override
  String get timeLabel => '时间';

  @override
  String get timeScaleStatLabel => '时间尺度';

  @override
  String get updateLater => '稍后';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateRequiredMessage => '此应用程序有新版本可用。请更新以继续使用最新功能和改进的应用程序。';

  @override
  String get updateRequiredTitle => '需要更新';

  @override
  String get updateRequiredWarning => '此版本不再受支持。';

  @override
  String errorLoadingChangelogs(String error) {
    return '加载更新日志时出错: $error';
  }

  @override
  String errorOpeningLink(String error) {
    return '打开链接时出错：$error';
  }

  @override
  String get notificationTypeDebug => '调试';

  @override
  String get notificationTypeInfo => '信息';

  @override
  String get warningTitle => '警告';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return '跳过辅助功能公告 - 无绑定';
  }

  @override
  String get accessibilityCameraFocus => '相机已聚焦于最近的天体';

  @override
  String get accessibilityCameraFollow => '相机现在跟随选定的天体';

  @override
  String get accessibilityCameraReset => '相机视图已重置为默认位置';

  @override
  String get accessibilityCameraUnfollow => '相机停止跟随天体';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return '碰撞敏感度已更改为$newValue';
  }

  @override
  String accessibilityError(String errorMessage) {
    return '错误：$errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return '重力强度已更改为$newValue';
  }

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return '检测到碰撞：$body1与$body2合并';
  }

  @override
  String get accessibilityMergeEventContext => '合并的质量创造了新的天体';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return '场景已更改为$scenarioName';
  }

  @override
  String get accessibilityScenarioChangeContext => '新天体和物理参数已加载';

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName已禁用';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName已启用';
  }

  @override
  String get accessibilitySimulationPaused => '模拟已暂停';

  @override
  String get accessibilitySimulationPausedContext => '所有天体已停止移动';

  @override
  String get accessibilitySimulationReset => '模拟已重置';

  @override
  String get accessibilitySimulationResetContext => '新场景已加载新天体';

  @override
  String get accessibilitySimulationResumed => '模拟已恢复';

  @override
  String get accessibilitySimulationResumedContext => '天体再次开始运动';

  @override
  String get accessibilitySimulationStarted => '模拟已开始';

  @override
  String get accessibilitySimulationStartedContext => '天体现在正在运动';

  @override
  String get accessibilitySimulationStopped => '模拟已停止';

  @override
  String get accessibilitySimulationStoppedContext => '所有天体已重置';

  @override
  String accessibilitySpeedChange(String newValue) {
    return '模拟速度已更改为$newValue';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return '教程步骤$currentStep/$totalSteps：$stepName';
  }

  @override
  String get changelogAdded => '新功能';

  @override
  String get changelogButton => '显示更新日志';

  @override
  String get changelogCategoryAdded => '新增';

  @override
  String get changelogCategoryFixed => '修复';

  @override
  String get changelogCategoryImproved => '改进';

  @override
  String get changelogDescription => '查看应用更新和变更';

  @override
  String get changelogDone => '完成';

  @override
  String get changelogFixed => '错误修复';

  @override
  String get changelogHometitle => '更新日志主页标题';

  @override
  String get changelogImproved => '改进';

  @override
  String changelogLoadError(String error) {
    return '加载更新日志失败: $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return '未找到更新日志。请先将更新日志数据添加到Firestore。\n当前版本: $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return '发布于$date';
  }

  @override
  String get changelogResetMessage => '更新日志状态已重置';

  @override
  String get changelogResetSuccess => '更新日志状态已重置';

  @override
  String get changelogTitle => '新功能';

  @override
  String get debugStatisticsTitle => '调试和统计';

  @override
  String errorLoadingChangelogEHome(String error) {
    return '加载更新日志错误';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return '此版本没有可用的更新日志';
  }

  @override
  String get testPreset => '测试预设';

  @override
  String get testScenarioButton => '测试场景按钮';

  @override
  String get testScenarioNotImplementedMessage => '测试场景未实现';

  @override
  String get aboutButtonTooltip => '关于';

  @override
  String get aboutMenuDescription => '应用信息和致谢';

  @override
  String get accessAppPreferences => '访问应用偏好设置';

  @override
  String get accessScenarioOptions => '访问场景选项';

  @override
  String get adjustSimulationSpeed => '调整模拟速度';

  @override
  String get aiCameraModesTitle => 'AI相机模式';

  @override
  String get allRightsReserved => '保留所有权利';

  @override
  String get announcementTitle => '公告';

  @override
  String appliedPreset(String presetName) {
    return '已应用预设：$presetName';
  }

  @override
  String get applyScene => '应用场景';

  @override
  String get atLeastOneBodyIsRequired => '至少需要一个天体';

  @override
  String get authorLabel => '作者';

  @override
  String get autoRotateActive => '激活';

  @override
  String get autoRotateInactive => '未激活';

  @override
  String get autoRotateLabel => '自动旋转';

  @override
  String get autoRotateOff => '关闭';

  @override
  String get autoRotateOn => '开启';

  @override
  String get autoRotateTooltip => '自动旋转';

  @override
  String get blackColor => '黑色';

  @override
  String get bodies => '天体';

  @override
  String get bodiesHeaderDescription => '天体标题描述';

  @override
  String bodiesHeaderPlural(int count) {
    return '天体';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return '模拟中的天体：$descriptions';
  }

  @override
  String get bodiesLabel => '天体';

  @override
  String get bodyAlpha => '阿尔法';

  @override
  String bodyAsteroid(int number) {
    return '小行星 $number';
  }

  @override
  String get bodyBeta => '贝塔';

  @override
  String get bodyBlackHole => '黑洞';

  @override
  String get bodyCenterOfMass => '质心';

  @override
  String get bodyCentralStar => '中央恒星';

  @override
  String bodyColorInvalid(String prefix) {
    return '天体颜色无效';
  }

  @override
  String get bodyEarth => '地球';

  @override
  String get bodyEarthLike => '类地行星';

  @override
  String get bodyGamma => '伽马';

  @override
  String bodyIndex(int index) {
    return '天体索引';
  }

  @override
  String get bodyInnerPlanet => '内行星';

  @override
  String get bodyJupiter => '木星';

  @override
  String get bodyMars => '火星';

  @override
  String bodyMassInvalid(String prefix) {
    return '天体质量无效';
  }

  @override
  String get bodyMercury => '水星';

  @override
  String get bodyMoon => '月球';

  @override
  String get bodyMoonM => '卫星M';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return '$bodyName的副本';
  }

  @override
  String bodyNameRequired(String prefix) {
    return '需要天体名称';
  }

  @override
  String get bodyNeptune => '海王星';

  @override
  String bodyNumberTemplate(String number) {
    return '天体 $number';
  }

  @override
  String get bodyOuterPlanet => '外行星';

  @override
  String get bodyPlanetP => '行星P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return '天体位置分量无效';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return '天体位置无效';
  }

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyPropertiesLuminosity => '恒星光度';

  @override
  String get bodyPropertiesMass => '质量';

  @override
  String get bodyPropertiesName => '名称';

  @override
  String get bodyPropertiesNameHint => '输入天体名称';

  @override
  String get bodyPropertiesRadius => '半径';

  @override
  String get bodyPropertiesTitle => '天体属性';

  @override
  String get bodyPropertiesVelocity => '速度';

  @override
  String bodyRadiusInvalid(String prefix) {
    return '天体半径无效';
  }

  @override
  String bodyRing(int number) {
    return '环 $number';
  }

  @override
  String get bodyRingedPlanet => '环状行星';

  @override
  String get bodyRockyPlanet => '岩石行星';

  @override
  String get bodySaturn => '土星';

  @override
  String bodySelectedTemplate(String bodyNumber, Object bodyName) {
    return '已选择 $bodyName';
  }

  @override
  String get bodyStarA => '恒星A';

  @override
  String get bodyStarB => '恒星B';

  @override
  String bodyStarNumber(int number) {
    return '恒星 $number';
  }

  @override
  String get bodySun => '太阳';

  @override
  String get bodySuperEarth => '超级地球';

  @override
  String get bodyTypeAsteroid => '小行星';

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count颗小行星',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeInvalid(String prefix, String bodyType) {
    return '天体类型无效';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count颗月球',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypePlanet => '行星';

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count颗行星',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeSelector => '天体类型选择器';

  @override
  String get bodyTypeStar => '恒星';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count颗恒星',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return '天体类型：$type';
  }

  @override
  String get bodyUranus => '天王星';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return '天体速度分量无效';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return '天体速度无效';
  }

  @override
  String get bodyVenus => '金星';

  @override
  String get bottomSheetFocused => '底部工作表已聚焦';

  @override
  String get bottomSheetLabel => '底部面板';

  @override
  String get browseAvailableSimulations => '浏览可用模拟';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return '天体 $name';
  }

  @override
  String get centerLabel => '居中';

  @override
  String get centerViewTooltip => '居中视图';

  @override
  String get cinematicCameraTechniqueDescription => '选择AI在跟踪对象时如何控制相机';

  @override
  String get cinematicCameraTechniqueLabel => 'AI相机技术';

  @override
  String get cinematicTechniqueDynamicFramingDesc => '用于混沌场景的实时戏剧性目标选择';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc => '用于教育场景的AI导览和轨道预测';

  @override
  String get closeButton => '关闭';

  @override
  String get collapsedState => '已折叠';

  @override
  String get collisionsSection => '碰撞';

  @override
  String get colorsLabel => '颜色';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ 冷';

  @override
  String copiedToClipboard(String text) {
    return '已复制到剪贴板：$text';
  }

  @override
  String get copyButton => '复制';

  @override
  String get copyrightLabel => '版权';

  @override
  String couldNotOpenUrl(String url) {
    return '无法打开 $url';
  }

  @override
  String get crosshairsDescription => '显示屏幕中心指示器';

  @override
  String get crosshairsTitle => '十字准线';

  @override
  String get currentScenario => '当前场景';

  @override
  String get currentStatisticsTitle => '当前统计';

  @override
  String get currentlySelected => '当前选中';

  @override
  String get cyanColor => '青色';

  @override
  String get deactivate => '停用';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      '描述此场景演示的内容-编辑器提示';

  @override
  String get detailsEditorLabel => '详细信息编辑器标签';

  @override
  String get developerToolsMenuDescription => '开发调试工具';

  @override
  String get developerToolsTitle => '开发者工具';

  @override
  String get difficultyEditorLabel => '难度编辑器标签';

  @override
  String get discardButton => '丢弃按钮';

  @override
  String get dragToRotateCameraView => '拖动以旋转相机视图';

  @override
  String get dualOrbitalPaths => '双轨道路径';

  @override
  String get dualOrbitalPathsDescription => '显示理想圆形轨道和实际椭圆轨道';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return '复制 $bodyName';
  }

  @override
  String get duplicateBodyTooltip => '复制天体工具提示';

  @override
  String get dynamicFramingDescription => 'AI动态构图所有对象';

  @override
  String get earthBlueColor => '地球蓝色';

  @override
  String earthYearsFormatted(String years) {
    return '$years年';
  }

  @override
  String get earthYearsLabel => '地球年';

  @override
  String get educationalFocusBinaryOrbits => '双星轨道';

  @override
  String get educationalFocusChaoticDynamics => '混沌动力学';

  @override
  String get educationalFocusManyBodyDynamics => '多体动力学';

  @override
  String get educationalFocusPlanetaryMotion => '行星运动';

  @override
  String get educationalFocusRealWorldSystem => '真实世界系统';

  @override
  String get educationalFocusStructureFormation => '结构形成';

  @override
  String get educationalObjectivesEditortitle => '教育目标编辑器标题';

  @override
  String get educationalObjectivesFutureMessage => '教育目标将在未来版本中在此处配置';

  @override
  String get educationalObjectivesListMessage =>
      '这将包括：\n• 学习目标\n• 成功标准\n• 指导挑战\n• 评估标准';

  @override
  String get emergencyNotificationTitle => '重要通知';

  @override
  String get enterScenarioNameEditorHint => '输入场景名称-编辑器提示';

  @override
  String get equipotentialSurfacesDescription => '显示相等引力势能的表面';

  @override
  String get equipotentialSurfacesLabel => '等势面';

  @override
  String get exit => '退出';

  @override
  String get exitAppMessage => '您确定要退出引力子吗？';

  @override
  String get exitAppTitle => '退出应用';

  @override
  String get expandedState => '已展开';

  @override
  String failedToSwitchScenarioError(String error) {
    return '切换场景失败错误';
  }

  @override
  String get fieldOfViewLabel => '视野';

  @override
  String get focusOnNearestTooltip => '聚焦最近的天体';

  @override
  String get followLabel => '跟随';

  @override
  String get followObjectTooltip => '跟踪选定对象';

  @override
  String get getStarted => '开始！';

  @override
  String get globalGravityFieldsDescription => '为所有大质量物体启用引力场可视化';

  @override
  String get globalGravityFieldsLabel => '全局引力场';

  @override
  String get gotItButton => '明白了！';

  @override
  String get gravitationalConstant => '重力常数';

  @override
  String get greenColor => '绿色';

  @override
  String get habitabilityHabitable => '宜居';

  @override
  String get habitabilityIndicatorsDescription => '根据行星的宜居性在其周围显示颜色编码的状态环';

  @override
  String get habitabilityIndicatorsLabel => '行星状态';

  @override
  String get habitabilityLabel => '宜居性';

  @override
  String get habitabilityTooCold => '太冷';

  @override
  String get habitabilityTooHot => '太热';

  @override
  String get habitabilityUnknown => '未知';

  @override
  String get habitableZonesDescription => '显示恒星周围表示宜居区域的彩色区域';

  @override
  String get habitableZonesLabel => '宜居带';

  @override
  String get hapticsSection => '触觉反馈';

  @override
  String get hideUIInScreenshotMode => '隐藏导航';

  @override
  String get hideUIInScreenshotModeSubtitle => '当截图模式激活时隐藏应用栏、底部导航和版权信息';

  @override
  String get initialMotionVectorsDescription => '初始运动矢量描述';

  @override
  String invalidJsonFormat(String error) {
    return '无效的JSON格式';
  }

  @override
  String get invertPitchControlsDescription => '反转上下拖拽方向';

  @override
  String get invertPitchControlsLabel => '反转俯仰控制';

  @override
  String get jupiterTanColor => '木星棕褐色';

  @override
  String get keyboardShortcutsHint => '使用空格键暂停/恢复，R键重新开始，C键居中相机，A键切换自动旋转';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => '更改应用程序语言';

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
  String get languageLabel => '语言';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => '系统默认';

  @override
  String get lightEnergyOutputDescription => '光能输出描述';

  @override
  String get loadingVersion => '加载版本中...';

  @override
  String get luminosityEditorLabel => '光度编辑器标签';

  @override
  String get luminosityWEditorhint => '输入光度（瓦特）-编辑器提示';

  @override
  String get maintenanceTitle => '维护';

  @override
  String get manualControlDescription => '完全手动相机控制';

  @override
  String get manualControlsTitle => '手动控制';

  @override
  String get marketingLabel => '营销';

  @override
  String get marsRedColor => '火星红色';

  @override
  String get maxTrailPointsInvalid => '最大轨迹点无效';

  @override
  String get maximum50BodiesAllowed => '最多允许50个天体';

  @override
  String get mercuryGrayColor => '水星灰色';

  @override
  String get missingRequiredFieldBodies => '缺少必需字段\'天体\'';

  @override
  String get missingRequiredFieldConfiguration => '缺少必需字段\'配置\'';

  @override
  String get missingRequiredFieldMetadata => '缺少必需字段\'元数据\'';

  @override
  String get missingRequiredFieldParticleSystems => '缺少必需字段\'粒子系统\'';

  @override
  String get missingRequiredFieldPhysics => '缺少必需字段\'物理\'';

  @override
  String get missingRequiredFieldVersion => '缺少必需字段\'版本\'';

  @override
  String get moreOptionsTooltip => '更多选项';

  @override
  String get navigationAidsTitle => '导航辅助';

  @override
  String get neptuneBlueColor => '海王星蓝色';

  @override
  String get newsTitle => '新闻';

  @override
  String get nextPreset => '下一个预设';

  @override
  String get nextSceneTooltip => '下一个场景工具提示';

  @override
  String get noActionsAvailable => '没有可用操作';

  @override
  String get noBodiesInSimulation => '当前模拟中没有天体';

  @override
  String get noChangelogsAvailable => '没有可用的更新日志';

  @override
  String get objectives1 => '理解重力如何塑造宇宙';

  @override
  String get objectives2 => '观察稳定与混沌轨道系统';

  @override
  String get objectives3 => '学习为什么行星在椭圆轨道中运动';

  @override
  String get objectives4 => '发现双星如何相互作用';

  @override
  String get objectives5 => '看看物体碰撞时会发生什么';

  @override
  String get objectives6 => '理解三体问题的复杂性';

  @override
  String get objectivesDescription =>
      '• 理解重力如何塑造宇宙\n• 观察稳定与混沌轨道系统\n• 学习为什么行星在椭圆轨道中运动\n• 发现双星如何相互作用\n• 看看物体碰撞时会发生什么\n• 理解三体问题的复杂性';

  @override
  String get objectivesTitle => '学习目标';

  @override
  String get offScreenIndicatorsDescription => '显示指向可见区域外对象的箭头';

  @override
  String get offScreenIndicatorsTitle => '屏幕外指示器';

  @override
  String get orangeColor => '橙色';

  @override
  String get particleSystemsEditortitle => '粒子系统编辑器标题';

  @override
  String get pathVisualizationTitle => '轨道可视化';

  @override
  String get physicalPropertiesDescription => '物理属性描述';

  @override
  String get pinchToZoomInOut => '捏合缩放';

  @override
  String get pitchLabel => '俯仰';

  @override
  String get positionEditorLabel => '位置编辑器标签';

  @override
  String get predictiveOrbitalDescription => 'AI预测最佳轨道视图';

  @override
  String get previousPreset => '上一个预设';

  @override
  String get previousSceneTooltip => '上一个场景工具提示';

  @override
  String get privacyPolicyLabel => '隐私政策';

  @override
  String get promotionTitle => '促销';

  @override
  String get quickStart1 => '选择场景（建议初学者选择太阳系）';

  @override
  String get quickStart2 => '按播放开始模拟';

  @override
  String get quickStart3 => '拖动旋转视图，捏合缩放';

  @override
  String get quickStart4 => '触摸速度滑块控制时间';

  @override
  String get quickStart5 => '尝试重置获得新的随机配置';

  @override
  String get quickStart6 => '启用轨迹查看轨道路径';

  @override
  String get quickStartDescription =>
      '1. 选择场景（建议初学者选择太阳系）\n2. 按播放开始模拟\n3. 拖动旋转视图，捏合缩放\n4. 触摸速度滑块控制时间\n5. 尝试重置获得新的随机配置\n6. 启用轨迹查看轨道路径';

  @override
  String get quickStartTitle => '快速入门指南';

  @override
  String get quickTutorialButton => '快速教程';

  @override
  String get radiusMEditorhint => '输入半径（米）-编辑器提示';

  @override
  String get realisticColors => '真实色彩';

  @override
  String get realisticColorsDescription => '基于温度和恒星分类使用科学准确的颜色';

  @override
  String get redColor => '红色';

  @override
  String get rollLabel => '翻滚';

  @override
  String get saturnCreamColor => '土星奶油色';

  @override
  String get scenarioAsteroidBelt => '小行星带';

  @override
  String get scenarioAsteroidBeltDescription => '中央恒星被岩石小行星和碎片带环绕';

  @override
  String get scenarioBestBinary => '适合对象：高级物理探索';

  @override
  String get scenarioBestEarthMoon => '适合对象：理解地月系统';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom => '适合对象：探索和实验';

  @override
  String get scenarioBestSolar => '适合对象：初学者、天文爱好者';

  @override
  String get scenarioBestThreeBody => '适合对象：数理物理爱好者';

  @override
  String get scenarioBinaryStars => '双星系统';

  @override
  String get scenarioBinaryStarsDescription => '两颗大质量恒星相互环绕，周围有环双星行星';

  @override
  String get scenarioCustom => '自定义场景';

  @override
  String get scenarioCustomDescription => '自定义场景描述';

  @override
  String get scenarioEarthMoonSun => '地球-月球-太阳';

  @override
  String get scenarioEarthMoonSunDescription => '我们熟悉的地球-月球-太阳系统的教育模拟';

  @override
  String get scenarioGalaxyFormation => '星系形成';

  @override
  String get scenarioGalaxyFormationDescription => '观察物质围绕中央黑洞组织成螺旋结构';

  @override
  String get scenarioInformationEditortitle => '场景信息编辑器标题';

  @override
  String get scenarioLearnBinary => '学习内容：恒星演化、双星系统、极端重力';

  @override
  String get scenarioLearnEarthMoon => '学习内容：三体动力学、月球力学、潮汐力';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom => '学习内容：发现未知配置、实验物理';

  @override
  String get scenarioLearnSolar => '学习内容：行星运动、轨道力学、熟悉的天体';

  @override
  String get scenarioLearnThreeBody => '学习内容：混沌理论、不可预测运动、不稳定系统';

  @override
  String get scenarioNameRequired => '需要场景名称';

  @override
  String get scenarioNameTooLong => '场景名称过长';

  @override
  String get scenarioPlanetaryRings => '行星环';

  @override
  String get scenarioPlanetaryRingsDescription => '像土星这样大质量行星周围的环系动力学';

  @override
  String get scenarioRandom => '随机系统';

  @override
  String get scenarioRandomDescription => '随机生成的混沌三体系统，具有不可预测的动力学';

  @override
  String scenarioSaveFailedMessage(String error) {
    return '场景保存失败';
  }

  @override
  String get scenarioSavedSuccessMessage => '场景保存成功';

  @override
  String get scenarioSelectorFocused => '场景选择器已聚焦';

  @override
  String get scenarioSolarSystem => '太阳系';

  @override
  String get scenarioSolarSystemDescription => '我们太阳系的简化版本，包含内行星和外行星';

  @override
  String get scenarioSpecial => '特殊场景';

  @override
  String get scenarioSpecialDescription => '用于截图模式的特殊场景';

  @override
  String get scenariosAvailable => '可用场景';

  @override
  String get scenariosMenuDescription => '探索不同场景';

  @override
  String get sceneActive => '场景已激活 - 模拟已暂停以便截图';

  @override
  String get scenePreset => '场景预设';

  @override
  String get scheduledMaintenanceInProgress => '正在进行计划维护';

  @override
  String screenshotCountdown(int seconds) {
    return '截图倒计时 $seconds秒';
  }

  @override
  String get screenshotMode => '截图模式';

  @override
  String get screenshotModeSubtitle => '启用预设场景以捕获营销截图';

  @override
  String get selectAColorForTheCelestialBody => '为天体选择颜色';

  @override
  String get selectNearestTitle => '选择最近';

  @override
  String get selectObjectToFollowTooltip => '选择要跟踪的对象';

  @override
  String get selectScenarioTooltip => '选择场景';

  @override
  String get selectTheTypeOfCelestialBody => '选择天体类型';

  @override
  String get selectedStatLabel => '已选择';

  @override
  String get showHelpTooltip => '帮助和目标';

  @override
  String get showLabelsDescription => '在模拟中显示天体名称';

  @override
  String get showLabelsTitle => '显示标签';

  @override
  String get showOrbitalPaths => '显示轨道路径';

  @override
  String get showOrbitalPathsDescription => '在具有稳定轨道的场景中显示预测的轨道路径';

  @override
  String get showStatisticsDescription => '显示性能和物理统计';

  @override
  String get showStatisticsTitle => '显示统计';

  @override
  String get showTrails => '显示轨迹';

  @override
  String get showTrailsDescription => '在物体后面显示运动轨迹';

  @override
  String get showTutorialTooltip => '显示教程';

  @override
  String get skipTutorial => '跳过';

  @override
  String get softeningParameter => '软化参数';

  @override
  String get spatialCoordinatesDescription => '空间坐标描述';

  @override
  String get statusError => '错误';

  @override
  String get statusLabel => '状态';

  @override
  String get statusPaused => '已暂停';

  @override
  String get statusRunning => '运行中';

  @override
  String get statusStopped => '已停止';

  @override
  String get stellarColorBlue => '蓝色';

  @override
  String get stellarColorBlueWhite => '蓝白色';

  @override
  String get stellarColorOrange => '橙色';

  @override
  String get stellarColorRed => '红色';

  @override
  String get stellarColorWhite => '白色';

  @override
  String get stellarColorYellow => '黄色';

  @override
  String get stellarColorYellowWhite => '黄白色';

  @override
  String get stellarTemperatureDescription => '恒星温度描述';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => '步数';

  @override
  String get successTitle => '成功';

  @override
  String get swipeUpToExpand => '向上滑动展开';

  @override
  String get tapPlayPauseButton => '点击播放/暂停按钮';

  @override
  String get tapResetButton => '点击重置按钮';

  @override
  String get tapToCenterCamera => '点击使相机居中';

  @override
  String get tapToChangeScenario => '点击更改场景';

  @override
  String get tapToInteractWithSimulation => '点击与模拟交互';

  @override
  String get tapToOpenSettings => '点击打开设置';

  @override
  String get tapToSelect => '点击选择';

  @override
  String get tapToToggleAutoRotation => '点击切换自动旋转';

  @override
  String get tapToToggleFullscreen => '点击切换全屏';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return '点击查看和编辑详细信息-天体-天体类型-带数字的名称-工具-格式-质量-天体质量-编辑器提示';
  }

  @override
  String get trackingModeEssential => '仅必要';

  @override
  String get trackingModeEssentialDescription => '仅关键崩溃和错误';

  @override
  String get trackingModeFull => '完整跟踪';

  @override
  String get trackingModeFullDescription => '所有分析、崩溃和交互';

  @override
  String get trackingModeLimited => '有限跟踪';

  @override
  String get trackingModeLimitedDescription => '仅用户交互';

  @override
  String get trackingModeNone => '无跟踪';

  @override
  String get trackingModeNoneDescription => '无数据收集';

  @override
  String get trailColorLabel => '轨迹颜色';

  @override
  String get trailFadeRate => '轨迹淡化率';

  @override
  String get trailLength => '轨迹长度';

  @override
  String get typeEditorLabel => '类型编辑器标签';

  @override
  String get uiHapticFeedback => 'UI触觉反馈';

  @override
  String get unsavedChangesMessage => '未保存的更改消息';

  @override
  String get unsavedChangesTitle => '未保存的更改';

  @override
  String get uranusCyanColor => '天王星青色';

  @override
  String get useKeyboardShortcutsForControls => '使用键盘快捷键进行控制';

  @override
  String get useZoomControls => '使用缩放控制';

  @override
  String get venusYellowColor => '金星黄色';

  @override
  String get versionLabel => '版本';

  @override
  String get versionStatusCurrent => '最新';

  @override
  String get versionStatusOutdated => '过期';

  @override
  String get vibrationEnabled => '启用振动';

  @override
  String get vibrationThrottle => '振动节流';

  @override
  String get warmTrails => '🔥 热';

  @override
  String get websiteLabel => '网站';

  @override
  String get whatToDoDescription =>
      'Graviton是一个物理游乐场，您可以：\n\n🪐 探索真实的轨道力学\n🌟 观看恒星演化和碰撞\n🎯 学习引力\n🎮 用不同场景实验\n📚 理解天体动力学\n🔄 创建无限随机配置';

  @override
  String get whatToDoTitle => '在Graviton中可以做什么';

  @override
  String get whiteColor => '白色';

  @override
  String get xCoordinateEditorhint => '输入X坐标-编辑器提示';

  @override
  String get xCoordinateLabel => 'X坐标标签';

  @override
  String get xVelocityEditorhint => '输入X速度-编辑器提示';

  @override
  String get yCoordinateEditorhint => '输入Y坐标-编辑器提示';

  @override
  String get yCoordinateLabel => 'Y坐标标签';

  @override
  String get yVelocityEditorhint => '输入Y速度-编辑器提示';

  @override
  String get yawLabel => '偏航';

  @override
  String get yellowColor => '黄色';

  @override
  String get zCoordinateEditorhint => '输入Z坐标-编辑器提示';

  @override
  String get zCoordinateLabel => 'Z坐标标签';

  @override
  String get zVelocityEditorhint => '输入Z速度-编辑器提示';

  @override
  String orbitalEventCloseApproach(String distance) {
    return '近距离接触：$distance 单位';
  }

  @override
  String get accessibilityBodiesCombined => '合并的质量创造了一个新的天体';

  @override
  String get accessibilityBodiesInMotion => '天体现在正在运动';

  @override
  String get accessibilityBodiesStopped => '所有天体都已停止运动';

  @override
  String get accessibilityBodiesResumed => '天体再次开始运动';

  @override
  String get accessibilityBodiesReset => '所有天体已被重置';

  @override
  String get accessibilityNewScenarioLoaded => '已加载带有新天体的新场景';

  @override
  String get accessibilityNewParametersLoaded => '已加载新的天体和物理参数';

  @override
  String get scenarioTabPresets => '预设';

  @override
  String get scenarioTabCustom => '自定义';

  @override
  String customScenarioBodyCount(int count) {
    return '$count个天体';
  }

  @override
  String get customScenarioCreatedToday => '今日创建';

  @override
  String get customScenarioCreatedYesterday => '昨日创建';

  @override
  String customScenarioCreatedDaysAgo(int count, Object days) {
    return '$days天前创建';
  }

  @override
  String customScenarioCreatedWeeksAgo(int count, Object weeks) {
    return '$weeks周前创建';
  }

  @override
  String customScenarioCreatedMonthsAgo(int count, Object months) {
    return '$months个月前创建';
  }

  @override
  String get customScenarioCreatedUnknown => '创建日期未知';
}
