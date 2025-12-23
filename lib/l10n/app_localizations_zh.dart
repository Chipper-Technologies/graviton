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
  String get setupEditorTitle => '设置';

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
  String colorOptionTooltip(String colorName) {
    return '为天体选择$colorName颜色';
  }

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
  String get relativisticEffectsTitle => '相对论效应';

  @override
  String get relativisticEffectsDescription => '对高速物体应用后牛顿修正';

  @override
  String get relativisticGlowTitle => '相对论光晕';

  @override
  String get relativisticGlowDescription => '通过基于速度的光晕可视化时间膨胀';

  @override
  String get tidalForcesTitle => '潮汐力';

  @override
  String get tidalForcesDescription => '计算潮汐变形和加热效应';

  @override
  String get tidalVisualizationTitle => '潮汐可视化';

  @override
  String get tidalVisualizationDescription => '显示潮汐应力和变形轴';

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
  String get temperatureCelsiusEditorhint => '输入温度（摄氏度）';

  @override
  String get temperatureFahrenheitEditorhint => '输入温度（华氏度）';

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
  String get temperatureUnitCelsiusName => '摄氏度';

  @override
  String get temperatureUnitFahrenheitName => '华氏度';

  @override
  String get temperatureUnitKelvinName => '开尔文';

  @override
  String get velocityMsEditor => '速度 m/s 编辑器';

  @override
  String get addBodyButton => '添加天体按钮';

  @override
  String get tapToEnableAddBodyMode => '点击启用添加天体模式 - 在画布上点击以放置新天体';

  @override
  String get tapToDisableAddBodyMode => '点击禁用添加天体模式并返回正常交互';

  @override
  String get addBodyModeActive => '添加天体模式已激活';

  @override
  String get addBodyModeInactive => '添加天体模式未激活';

  @override
  String get tapToPlaceBody => '在画布上任意位置点击以放置新天体';

  @override
  String get lockInteraction => '锁定交互';

  @override
  String get tapToLockInteraction => '点击锁定 - 防止意外移动天体';

  @override
  String get tapToUnlockInteraction => '点击解锁 - 允许通过拖动移动天体';

  @override
  String get interactionLocked => '交互已锁定';

  @override
  String get interactionUnlocked => '交互已解锁';

  @override
  String get bodyPlacedSuccessfully => '天体放置成功';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      '添加天体以创建自定义场景-编辑器';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      '小行星带和其他粒子系统将在此处配置-编辑器';

  @override
  String get beginnerEditor => '初学者编辑器';

  @override
  String get noBodiesAdded => '尚未添加天体';

  @override
  String get addBodiesInSetupTab => '在设置选项卡中添加天体';

  @override
  String get untitledScenario => '无标题场景';

  @override
  String get noDescriptionProvided => '未提供描述';

  @override
  String get collisionSoftening => '碰撞软化';

  @override
  String get collisionRadius => '碰撞半径';

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
  String get editScenarioButton => '编辑场景';

  @override
  String get editScenarioHint => '编辑此场景';

  @override
  String get editBodyButton => '编辑天体';

  @override
  String get editBodyHint => '编辑此天体';

  @override
  String get deleteScenarioButton => '删除场景';

  @override
  String get deleteScenarioHint => '删除此场景';

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
  String get viewScenarioButton => '查看场景';

  @override
  String get viewScenarioHint => '以只读模式查看场景详情';

  @override
  String get exportScenarioButton => '导出场景';

  @override
  String get exportScenarioHint => '将场景导出为文件以供分享';

  @override
  String exportScenarioFailedMessage(String error) {
    return '场景导出失败';
  }

  @override
  String get exportScenarioNotImplementedMessage => '场景导出未实现';

  @override
  String get saveButton => '保存';

  @override
  String get saveBodyTooltip => '保存天体';

  @override
  String get saveNewBodyAccessibility => '保存新天体';

  @override
  String get saveNewBodyHint => '使用当前设置创建天体';

  @override
  String get saveChangesToBodyAccessibility => '保存天体更改';

  @override
  String get saveChangesToBodyHint => '保存对此天体所做的所有更改';

  @override
  String get moreActionsAccessibility => '更多操作';

  @override
  String get moreActionsHint => '打开包含复制和删除选项的菜单';

  @override
  String get duplicateBodyAccessibility => '创建此天体的副本';

  @override
  String get deleteBodyAccessibility => '永久删除此天体';

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
      '拖动来旋转视图，捏合缩放，使用两个手指滚动相机，使用三个手指平移。底部栏有焦点、居中和自动旋转控件，提供电影般的体验。';

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
  String get testScenarioHint => '在模拟中测试当前场景';

  @override
  String get testScenarioNotImplementedMessage => '测试场景未实现';

  @override
  String get scenarioEditorMenuHint => '打开包含测试和导出选项的菜单';

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
  String get rotateSpeed => '旋转速度';

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
  String scenariosHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个场景',
      one: '1个场景',
      zero: '无场景',
    );
    return '$_temp0';
  }

  @override
  String experimentsHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count个实验',
      one: '1个实验',
      zero: '无实验',
    );
    return '$_temp0';
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
  String get bodyNewDefault => '新天体';

  @override
  String get bodyPlacementTooClose => '距离现有天体太近 - 请点击其他地方';

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
  String get bodySpacecraft => '航天器';

  @override
  String get bodyIo => '木卫一';

  @override
  String get bodyEuropa => '木卫二';

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
  String get bodyPropertiesMassHint => '调整引力影响和轨道动力学';

  @override
  String get bodyPropertiesRadiusHint => '控制大小和碰撞边界';

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
  String bodySelectedTemplate(String bodyNumber) {
    return '已选择 $bodyNumber';
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
  String get bodyTypeNeutronStar => '中子星';

  @override
  String get bodyTypeBlackHole => '黑洞';

  @override
  String get bodyTypeMoon => '月球';

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return '天体类型：$type';
  }

  @override
  String get bodyTypeTooltipStar => '通过核聚变产生光和热的巨大天体。恒星是恒星系统的主要能源。';

  @override
  String get bodyTypeTooltipPlanet => '环绕恒星运行并清空其轨道的大型天体。行星可能是岩石或气体性质，并可能拥有卫星。';

  @override
  String get bodyTypeTooltipMoon => '环绕行星运行的自然卫星。月球可以影响潮汐并为行星系统提供稳定性。';

  @override
  String get bodyTypeTooltipAsteroid => '环绕太阳运行的小型岩石体。小行星是太阳系早期形成的遗留物。';

  @override
  String get bodyTypeTooltipBlackHole => '引力场强度极大，连光线都无法逃脱的时空区域。';

  @override
  String get bodyTypeTooltipNeutronStar => '大质量恒星坍缩形成的极高密度恒星遗迹。具有极强的引力场和磁场。';

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
  String get stellarCoronasTitle => '恒星日冕';

  @override
  String get stellarCoronasDescription => '显示恒星周围发光的等离子体大气';

  @override
  String get atmosphericEffectsTitle => '大气效果';

  @override
  String get atmosphericEffectsDescription => '在行星上显示大气晕圈和散射';

  @override
  String get hemisphereLightingTitle => '半球照明';

  @override
  String get hemisphereLightingDescription => '模拟球体上逼真的3D照明';

  @override
  String get castShadowsTitle => '投射阴影';

  @override
  String get castShadowsDescription => '当天体遮挡光源时显示阴影';

  @override
  String get specularHighlightsTitle => '镜面高光';

  @override
  String get specularHighlightsDescription => '在冰和水表面显示反射高光';

  @override
  String get lightingEffectsLabel => '照明与阴影';

  @override
  String get habitabilityLabel => '宜居性';

  @override
  String get habitabilityTooCold => '太冷';

  @override
  String get habitabilityTooHot => '太热';

  @override
  String get habitabilityUnknown => '未知';

  @override
  String get habitabilityGasGiant => '气体巨星';

  @override
  String get habitabilityTooSmall => '太小';

  @override
  String get habitabilityNoAtmosphere => '无大气';

  @override
  String get habitabilityToxicAtmosphere => '有毒大气';

  @override
  String get habitabilityHighRadiation => '高辐射';

  @override
  String get habitabilityTidallyLocked => '潮汐锁定';

  @override
  String get habitabilityExtremeGravity => '极端重力';

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
  String get languageSelectionHint => '选择您的首选显示语言';

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
  String get languageLabel => '常规';

  @override
  String get temperatureUnitsLabel => '温度单位';

  @override
  String get temperatureUnitsDescription => '整个应用程序中显示温度的首选单位';

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
  String get savedScenariosTitle => '保存的场景';

  @override
  String get experimentsTitle => '实验';

  @override
  String get experimentsSubtitle => '探索有趣的物理概念';

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

  @override
  String get orbitalPlacementEditor => '轨道放置';

  @override
  String get placeInOrbitButton => '放置到轨道';

  @override
  String get centralBodySelector => '中心天体';

  @override
  String get orbitRadiusEditor => '轨道半径';

  @override
  String get orbitPhaseEditor => '轨道相位';

  @override
  String get orbitInclinationEditor => '倾斜角';

  @override
  String get circularOrbitOption => '圆形轨道';

  @override
  String get ellipticalOrbitOption => '椭圆轨道';

  @override
  String orbitalPeriodDisplay(String period) {
    return '周期: $period';
  }

  @override
  String get noAvailableCentralBodies => '没有其他天体可用于轨道放置';

  @override
  String get orbitalPlacementDescription => '配置此天体以现实物理围绕另一个天体运行';

  @override
  String get orbitalPlacementActiveDescription =>
      '轨道放置已激活。位置和速度将根据下面的轨道参数自动计算。';

  @override
  String get showGravitationalFieldVisualization => '显示此天体的引力场可视化';

  @override
  String get cancelOrbitalPlacement => '取消轨道放置';

  @override
  String get makeStable => '使稳定';

  @override
  String get orbitalWarningMassiveBody =>
      '⚠️ 警告：环绕天体相对于中心天体质量很大。这可能导致不稳定轨道或天体相互环绕。';

  @override
  String get orbitalTipSignificantMass => '💡 提示：这是一个显著的质量比。考虑增加轨道距离以获得稳定性。';

  @override
  String get orbitalWarningCloseOrbit => '⚠️ 警告：非常近的轨道。存在碰撞或潮汐破坏的风险。';

  @override
  String get orbitalTipDistantOrbit => '💡 提示：遥远轨道。其他天体的引力影响可能扰乱这个轨道。';

  @override
  String get orbitalGoodConfiguration => '✅ 稳定系统的良好轨道配置。';

  @override
  String get orbitalError => '错误';

  @override
  String get orbitalConfigurationWarning => '此轨道配置可能导致碰撞或抛射。考虑使用\"使稳定\"按钮。';

  @override
  String get defaultBodyName => '天体';

  @override
  String get orbitalPeriodLabel => '轨道周期';

  @override
  String get orbitIsStable => '轨道是稳定的';

  @override
  String get orbitMayBeUnstable => '轨道可能不稳定';

  @override
  String bodyTypeGeneric(String bodyType) {
    return '$bodyType天体';
  }

  @override
  String orbitalRadiusIncreasedFeedback(String amount) {
    return '增加了$amount单位';
  }

  @override
  String orbitalRadiusDecreasedFeedback(String amount) {
    return '减少了$amount单位';
  }

  @override
  String get orbitalRadiusFineTunedFeedback => '微调';

  @override
  String orbitStabilizedMessage(String changeDescription, String finalRadius) {
    return '轨道已稳定！半径$changeDescription到$finalRadius单位。相位和倾斜度重置以保持稳定。';
  }

  @override
  String get experimentBinaryPulsarName => '双星脉冲星';

  @override
  String get experimentBinaryPulsarDescription => '两颗中子星因引力波向内螺旋运动';

  @override
  String get experimentBinaryPulsarDuration => '100年';

  @override
  String get binaryPulsarPulsarA => '脉冲星A';

  @override
  String get binaryPulsarNeutronStarB => '中子星B';

  @override
  String get binaryPulsarScenarioDescription =>
      '此场景演示：极端重力场、相对论效应、引力波发射和轨道衰减。中子星将随时间缓慢螺旋向内，最终在产生引力波的灾难性碰撞中合并。';

  @override
  String get binaryPulsarAuthor => 'Graviton物理实验';

  @override
  String get binaryPulsarEducationalFocus => '相对论与引力波';

  @override
  String get experimentTrojanAsteroidsName => '特洛伊小行星';

  @override
  String get experimentTrojanAsteroidsDescription => '小行星聚集的木星轨道稳定点';

  @override
  String get experimentTrojanAsteroidsDuration => '50年';

  @override
  String get trojanAsteroidsSun => '太阳';

  @override
  String get trojanAsteroidsJupiter => '木星';

  @override
  String trojanAsteroidsL4Name(int number) {
    return 'L4特洛伊$number';
  }

  @override
  String trojanAsteroidsL5Name(int number) {
    return 'L5特洛伊$number';
  }

  @override
  String get trojanAsteroidsScenarioDescription =>
      '此场景演示：拉格朗日点、稳定轨道力学、三体动力学和引力平衡。特洛伊小行星保持在木星前后60°的稳定位置，被困在引力平衡中。';

  @override
  String get trojanAsteroidsEducationalFocus => '拉格朗日点与轨道稳定性';

  @override
  String get experimentDoubleStarEclipseName => '双星食';

  @override
  String get experimentDoubleStarEclipseDescription => '一颗恒星定期遮挡另一颗恒星的双星系统';

  @override
  String get experimentDoubleStarEclipseDuration => '30天';

  @override
  String get experimentRoguePlanetName => '流浪行星';

  @override
  String get experimentRoguePlanetDescription => '从系统中被抛出的行星遭遇新的太阳系';

  @override
  String get experimentRoguePlanetDuration => '500年';

  @override
  String get experimentGravitationalSlingshotName => '重力弹射';

  @override
  String get experimentGravitationalSlingshotDescription =>
      '航天器利用木星的卫星伊奥获得速度并前往欧罗巴';

  @override
  String get experimentGravitationalSlingshotDuration => '2年';

  @override
  String get experimentDifficultyAdvanced => '高级';

  @override
  String get experimentDifficultyIntermediate => '中级';

  @override
  String get experimentDifficultyBeginner => '初级';

  @override
  String experimentComingSoon(String scenarioName) {
    return '实验场景\"$scenarioName\" - 即将推出！';
  }

  @override
  String get unknownValue => '未知';

  @override
  String get bodyPrimaryStar => '主星';

  @override
  String get bodySecondaryStar => '伴星';

  @override
  String get bodyInnerRockyPlanet => '内侧岩质行星';

  @override
  String get bodyHabitablePlanet => '宜居行星';

  @override
  String get bodyGasGiant => '气体巨行星';

  @override
  String get bodyIceGiant => '冰巨行星';

  @override
  String get bodyRoguePlanet => '流浪行星';

  @override
  String get authorGravitonPhysicsTeam => 'Graviton物理团队';

  @override
  String get doubleStarEclipseScenarioDescription =>
      '观察两颗恒星在近密双星系统中相互环绕的情形。看较小的伴星如何定期从较大的主星前方经过，造成周期性的日食。这展示了恒星测光、双星轨道力学，以及天文学家如何使用类似的凌日方法发现系外行星。';

  @override
  String get doubleStarEclipseEducationalFocus => '双星、日食、恒星测光';

  @override
  String get roguePlanetScenarioDescription =>
      '一个拥有良好间隔行星轨道的稳定太阳系遭遇了一颗从星际空间接近的巨大流浪行星。观察入侵者的引力如何扰乱精细的轨道平衡，可能弹射行星或产生混沌的引力相互作用。此场景演示了行星系动力学、引力弹弓效应，以及流浪行星如何重塑整个太阳系。';

  @override
  String get roguePlanetEducationalFocus => '流浪行星、引力遭遇、轨道扰动';

  @override
  String get simulationInfoTitle => '仿真信息';

  @override
  String get scenarioInfoTitle => '场景信息';

  @override
  String get scenarioNameLabel => '场景名称';

  @override
  String get bodyStatisticsTitle => '天体统计';

  @override
  String get totalBodiesLabel => '总天体数';

  @override
  String get starsLabel => '恒星';

  @override
  String get planetsLabel => '行星';

  @override
  String get asteroidsLabel => '小行星';

  @override
  String get blackHolesLabel => '黑洞';

  @override
  String get totalMassLabel => '总质量';

  @override
  String get habitableWorldsLabel => '宜居世界';

  @override
  String get physicsInfoTitle => '物理信息';

  @override
  String get timeScaleLabel => '时间尺度';

  @override
  String get gravitationalConstantLabel => '引力常数';

  @override
  String get softeningParameterLabel => '软化参数';

  @override
  String get collisionRadiusLabel => '碰撞半径';

  @override
  String get scenarioThreeBodyClassic => '经典三体问题';

  @override
  String get scenarioThreeBodyClassicDescription => '具有混沌动力学的经典三体问题';

  @override
  String get scenarioCollisionDemo => '碰撞演示';

  @override
  String get scenarioCollisionDemoDescription => '天体间碰撞的演示';

  @override
  String get scenarioDeepSpace => '深空';

  @override
  String get scenarioDeepSpaceDescription => '深空中的随机物体';

  @override
  String get systemEnergyLabel => '系统能量';

  @override
  String get kineticEnergyLabel => '动能';

  @override
  String get potentialEnergyLabel => '势能';

  @override
  String get angularMomentumLabel => '角动量';

  @override
  String get centerOfMassLabel => '质心';

  @override
  String get velocityRangeLabel => '速度范围';

  @override
  String get averageVelocityLabel => '平均速度';

  @override
  String get temperatureRangeLabel => '温度范围';

  @override
  String get systemMomentumLabel => '系统动量';

  @override
  String get energyDynamicsTitle => '能量与动力学';

  @override
  String get orbitalMechanicsTitle => '轨道力学';

  @override
  String get celestialBodiesTitle => '天体';

  @override
  String get bodyNameLabel => '天体名称';

  @override
  String get bodyMassLabel => '天体质量';

  @override
  String get bodyRadiusLabel => '天体半径';

  @override
  String get bodyVelocityLabel => '天体速度';

  @override
  String get bodyTemperatureLabel => '天体温度';

  @override
  String get bodyLuminosityLabel => '天体光度';

  @override
  String get bodyPositionLabel => '天体位置';

  @override
  String get bodyTypeLabel => '天体类型';

  @override
  String get bodyHabitabilityLabel => '天体宜居性';

  @override
  String get bodyKineticEnergyLabel => '天体动能';

  @override
  String get bodyEscapeVelocityLabel => '逃逸速度';

  @override
  String get bodyDistanceFromCenterLabel => '距离中心';

  @override
  String get bodyOrbitalPeriodLabel => '轨道周期';

  @override
  String get notApplicableValue => '不适用';

  @override
  String get habitableStatus => '适宜居住';

  @override
  String get unknownHabitabilityStatus => '未知';

  @override
  String get tooHotStatus => '太热';

  @override
  String get tooColdStatus => '太冷';

  @override
  String get noAtmosphereStatus => '无大气层';

  @override
  String get selectBody => '选择天体';

  @override
  String get noBodiesAvailable => '没有可用的天体';

  @override
  String get share => '分享';

  @override
  String get shareSimulation => '分享模拟';

  @override
  String get shareImage => '分享图片';

  @override
  String get shareImageDescription => '捕获并分享当前视图';

  @override
  String get shareState => '分享状态';

  @override
  String get shareStateDescription => '将模拟数据导出为可导入的文件';

  @override
  String get shareSuccess => '分享成功';

  @override
  String get shareFailed => '分享失败';

  @override
  String get shareImageError => '无法捕获图像。请重试。';

  @override
  String get shareSubject => 'Graviton模拟';

  @override
  String get shareSnapshotSubject => 'Graviton模拟快照';

  @override
  String get shareText => '看看这个引力模拟！';

  @override
  String get importScenario => '导入场景';

  @override
  String get importScenarioDescription => '从JSON文件加载场景';

  @override
  String get importSuccess => '场景导入成功';

  @override
  String get importFailed => '场景导入失败';

  @override
  String get importInvalidFile => '无效的文件格式。请选择有效的JSON文件。';

  @override
  String get importFileNotFound => '未找到文件。请重试。';

  @override
  String get importCancelled => '导入已取消';

  @override
  String get accountManagementTitle => '账户';

  @override
  String get accountButtonTooltip => '账户和个人资料';

  @override
  String get signInPromptTitle => '登录您的账户';

  @override
  String get signInPromptMessage => '创建账户或登录以在设备间同步您的数据和偏好设置。';

  @override
  String get signInButton => '登录';

  @override
  String get signOutButton => '退出登录';

  @override
  String get resetSessionButton => '重置会话';

  @override
  String get signOutSuccess => '已成功退出登录';

  @override
  String get operationTimeout => '操作超时。请重试。';

  @override
  String get operationFailed => '操作失败。请重试。';

  @override
  String get couldNotOpenLink => '无法打开链接。请重试。';

  @override
  String get pleaseWaitBeforeRetrying => '请稍等片刻再重试。';

  @override
  String rateLimitWithCooldown(int seconds) {
    return '请等待$seconds秒后再重试。';
  }

  @override
  String get networkError => '网络错误。请检查您的连接并重试。';

  @override
  String get continueAsGuestButton => '以访客身份继续';

  @override
  String get signInAnonymousSuccess => '已以访客身份登录';

  @override
  String get anonymousUserLabel => '访客用户';

  @override
  String get guestAccountLabel => '访客账户';

  @override
  String get authenticatedLabel => '账户';

  @override
  String get changeAvatarTooltip => '更改头像';

  @override
  String get editDisplayNameTooltip => '编辑名称';

  @override
  String get accountActionsSection => '账户操作';

  @override
  String get upgradeAccountTitle => '升级到完整账户';

  @override
  String get upgradeAccountDescription => '保存您的数据并从任何设备访问';

  @override
  String get accountManagementSection => '账户管理';

  @override
  String get dangerZoneSection => '账户管理';

  @override
  String get deleteAccountButton => '删除账户';

  @override
  String get avatarChangedSuccess => '头像更新成功';

  @override
  String get avatarChangedError => '头像更新失败';

  @override
  String get accountMenuDescription => '管理您的账户和个人资料';

  @override
  String get emailLabel => '电子邮件';

  @override
  String get passwordLabel => '密码';

  @override
  String get createAccountButton => '创建账户';

  @override
  String get pleaseEnterEmail => '请输入您的电子邮件';

  @override
  String get pleaseEnterValidEmail => '请输入有效的电子邮件';

  @override
  String get pleaseEnterPassword => '请输入您的密码';

  @override
  String get passwordMinLength => '密码必须至少6个字符';

  @override
  String get alreadyHaveAccount => '已有账户？登录';

  @override
  String get needAccount => '需要账户？创建一个';

  @override
  String get continueWithGoogle => '使用 Google 继续';

  @override
  String get continueWithGitHub => '使用 GitHub 继续';

  @override
  String get continueWithApple => '使用 Apple 继续';

  @override
  String get moreProviders => '更多提供商';

  @override
  String get chooseProvider => '选择提供商';

  @override
  String get selectAvatarTitle => '选择头像';

  @override
  String get editAccountInformationTitle => '编辑显示名称';

  @override
  String get displayNameLabel => '显示名称';

  @override
  String get pleaseEnterDisplayName => '请输入显示名称';

  @override
  String get displayNameMinLength => '名称必须至少2个字符';

  @override
  String get deleteAccountTitle => '删除账户';

  @override
  String get deleteAccountWarning => '此操作无法撤消。';

  @override
  String get deleteAccountMessage => '删除您的账户将永久删除与其关联的所有数据。';

  @override
  String get deleteAccountItem1 => '您的个人资料和头像';

  @override
  String get deleteAccountItem2 => '所有保存的偏好设置';

  @override
  String get deleteAccountItem3 => '自定义场景和设置';

  @override
  String get deleteAccountItem4 => '账户身份验证';

  @override
  String get deleteAccountPasswordPrompt => '请输入您的密码以确认：';

  @override
  String get orDivider => '或';

  @override
  String get displayNameHint => '输入您的姓名（可选）';

  @override
  String get emailHint => '您的电子邮件地址';

  @override
  String get passwordHint => '您的密码';

  @override
  String get alreadyHaveAccountSignIn => '已有账户？登录';

  @override
  String get needAccountCreateOne => '没有账户？创建一个';

  @override
  String get useGoogleProfilePhoto => '使用Google个人资料照片';

  @override
  String get customAvatars => '自定义头像';

  @override
  String get saveAvatar => '保存头像';

  @override
  String get displayNameFieldLabel => '显示名称';

  @override
  String get displayNameFieldHint => '输入您的显示名称';

  @override
  String get saveAccountInformation => '保存账户信息';

  @override
  String get emailRequired => '电子邮件为必填项';

  @override
  String get emailInvalid => '请输入有效的电子邮件地址';

  @override
  String get passwordRequired => '密码为必填项';

  @override
  String get passwordTooShort => '密码必须至少8个字符';

  @override
  String get passwordMissingUppercase => '密码必须包含至少一个大写字母';

  @override
  String get passwordMissingLowercase => '密码必须包含至少一个小写字母';

  @override
  String get passwordMissingNumber => '密码必须包含至少一个数字';

  @override
  String get passwordMissingSpecialChar => '密码必须包含至少一个特殊字符 (!@#\$%^&*...)';

  @override
  String get tooManyAttempts => '登录尝试失败次数过多。请在15分钟后重试。';

  @override
  String get emailVerificationRequired =>
      '在访问此功能之前,请验证您的电子邮件地址。请检查您的收件箱以获取验证链接。';

  @override
  String get defaultUserName => '用户';

  @override
  String get googleSignInError => 'Google登录已取消或失败。请重试。';

  @override
  String get gitHubSignInError => 'GitHub登录已取消或失败。请重试。';

  @override
  String get appleSignInError => 'Apple登录已取消或失败。请重试。';

  @override
  String get displayNameUpdated => '显示名称已更新';

  @override
  String get displayNameUpdateFailed => '更新显示名称失败';

  @override
  String get sessionResetSuccess => '会话重置成功';

  @override
  String get accountDeletedSuccess => '账户删除成功';

  @override
  String get errorUserNotFound => '未找到此电子邮件地址的账户。';

  @override
  String get errorWrongPassword => '密码不正确。请重试。';

  @override
  String get errorInvalidEmail => '电子邮件地址格式无效。';

  @override
  String get errorUserDisabled => '此账户已被禁用。';

  @override
  String get errorEmailInUse => '此电子邮件地址已存在账户。';

  @override
  String get errorWeakPassword => '密码太弱。请使用更强的密码。';

  @override
  String get errorOperationNotAllowed => '此登录方法未启用。';

  @override
  String get errorRequiresRecentLogin => '请重新登录以执行此操作。';

  @override
  String get errorNetworkFailed => '网络错误。请检查您的连接。';

  @override
  String errorUnknown(String message) {
    return '发生错误：$message';
  }

  @override
  String get exceptionGoogleSignInNotInitialized => 'Google登录未初始化';

  @override
  String get exceptionGoogleSignInTimeout => 'Google登录超时';

  @override
  String get exceptionAppleSignInPlatform => 'Apple登录仅在Apple平台上可用';

  @override
  String get exceptionNoAnonymousUser => '没有匿名用户可链接';

  @override
  String get exceptionNoUserSignedIn => '没有用户登录';

  @override
  String get firebaseErrorUserNotFound => '未找到使用此电子邮件地址的账户。';

  @override
  String get firebaseErrorWrongPassword => '密码不正确。请重试。';

  @override
  String get firebaseErrorInvalidEmail => '电子邮件地址格式无效。';

  @override
  String get firebaseErrorUserDisabled => '此账户已被禁用。';

  @override
  String get firebaseErrorEmailInUse => '此电子邮件地址已存在账户。';

  @override
  String get firebaseErrorWeakPassword => '密码太弱。请使用更强的密码。';

  @override
  String get firebaseErrorOperationNotAllowed => '此登录方法未启用。';

  @override
  String get firebaseErrorRequiresRecentLogin => '请重新登录以执行此操作。';

  @override
  String get firebaseErrorNetworkFailed => '网络错误。请检查您的连接。';

  @override
  String get firebaseErrorAccountExistsWithDifferentCredential =>
      '该电子邮件已存在使用不同登录方式的账户。请使用原始方法登录。';

  @override
  String firebaseErrorDefault(String message) {
    return '发生错误：$message';
  }

  @override
  String get integrityErrorDeviceIntegrityTitle => '设备安全问题';

  @override
  String get integrityErrorDeviceIntegrity => '您的设备不符合此操作的安全要求。';

  @override
  String integrityGuidanceDeviceIntegrity(String reference) {
    return '请确保您的设备通过了Google Play保护检查，并且没有被root或修改。如果您认为这是一个错误，请联系支持并提供参考编号：$reference';
  }

  @override
  String get integrityErrorAppIntegrityTitle => '应用安装问题';

  @override
  String get integrityErrorAppIntegrity => '无法验证应用安装。';

  @override
  String integrityGuidanceAppIntegrity(String reference) {
    return '请确保您使用的是来自Google Play商店的官方应用。不支持侧载或修改的应用。参考：$reference';
  }

  @override
  String get integrityErrorNetworkTitle => '连接错误';

  @override
  String get integrityErrorNetwork => '由于网络错误，无法验证设备安全性。';

  @override
  String integrityGuidanceNetwork(String reference) {
    return '请检查您的互联网连接并重试。如果问题仍然存在，请联系支持并提供参考编号：$reference';
  }

  @override
  String get integrityErrorBackendVerificationTitle => '验证失败';

  @override
  String get integrityErrorBackendVerification => '无法完成安全验证。';

  @override
  String integrityGuidanceBackendVerification(String reference) {
    return '验证您的设备时出现问题。请稍后重试。如果问题仍然存在，请联系支持并提供参考编号：$reference';
  }

  @override
  String get integrityErrorTokenRequestTitle => '安全检查失败';

  @override
  String get integrityErrorTokenRequest => '无法执行安全验证。';

  @override
  String integrityGuidanceTokenRequest(String reference) {
    return '无法生成安全令牌。请重新启动应用并重试。如果问题仍然存在，请联系支持并提供参考编号：$reference';
  }

  @override
  String get integrityErrorUnknownTitle => '验证错误';

  @override
  String get integrityErrorUnknown => '安全验证期间发生意外错误。';

  @override
  String integrityGuidanceUnknown(String reference) {
    return '请重试。如果问题仍然存在，请联系支持并提供参考编号：$reference';
  }

  @override
  String get emailVerificationSent => '验证邮件已发送！请检查您的收件箱。';

  @override
  String get emailVerificationResent => '验证邮件已成功重新发送。';

  @override
  String get emailNotVerified => '邮箱未验证';

  @override
  String get emailVerified => '邮箱已验证';

  @override
  String get verifyEmailAddress => '验证电子邮件地址';

  @override
  String get verifyEmailMessage => '请验证您的电子邮件地址以访问所有功能。请检查您的收件箱以获取验证链接。';

  @override
  String get sendVerificationEmail => '发送验证邮件';

  @override
  String get resendVerificationEmail => '重新发送验证邮件';

  @override
  String get checkVerificationStatus => '检查验证状态';

  @override
  String get emailVerificationPending => '邮箱验证待处理';

  @override
  String verificationEmailCooldown(int seconds) {
    return '请等待$seconds秒后再请求另一封验证邮件。';
  }

  @override
  String get termsAndPrivacy => '条款与隐私';

  @override
  String get acceptTermsAndPrivacy => '我接受服务条款和隐私政策';

  @override
  String get mustAcceptTerms => '您必须接受服务条款和隐私政策才能继续。';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get viewTermsOfService => '查看服务条款';

  @override
  String get viewPrivacyPolicy => '查看隐私政策';

  @override
  String termsLastUpdated(String date) {
    return '最后更新：$date';
  }

  @override
  String privacyLastUpdated(String date) {
    return '最后更新：$date';
  }

  @override
  String get ageRequirement => '您必须年满13岁才能创建帐户。';

  @override
  String get confirmAge => '我确认我已年满13岁';

  @override
  String get exceptionEmailVerificationFailed =>
      'exceptionEmailVerificationFailed';

  @override
  String get exceptionEmailVerificationCooldown =>
      'exceptionEmailVerificationCooldown';

  @override
  String get exceptionTermsNotAccepted => 'exceptionTermsNotAccepted';

  @override
  String get collisionEffectsTitle => '碰撞效果';

  @override
  String get showCollisionDebris => '碎片粒子';

  @override
  String get showCollisionDebrisDescription => '从碰撞冲击中弹出的具有基于物理的轨迹的粒子';

  @override
  String get showCollisionShockwaves => '冲击波环';

  @override
  String get showCollisionShockwavesDescription => '从碰撞点扩展的能量环，按冲击力缩放';

  @override
  String get showCollisionEjection => '物质喷射';

  @override
  String get showCollisionEjectionDescription => '高能量冲击期间喷出的翻滚物质云';

  @override
  String get showCollisionPlasmaJets => '等离子射流';

  @override
  String get showCollisionPlasmaJetsDescription => '来自大质量恒星碰撞的定向超高温流（实验性）';

  @override
  String get liveSessionHosting => '正在主持直播会话';

  @override
  String get liveSessionNotHosting => '分享直播会话';

  @override
  String get liveSessionStartHosting => '开始主持';

  @override
  String get liveSessionStopHosting => '停止主持';

  @override
  String liveSessionViewerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count位观看者',
      one: '1位观看者',
      zero: '无观看者',
    );
    return '$_temp0';
  }

  @override
  String get liveSessionBrowseSessions => '浏览会话';

  @override
  String get liveSessionNoSessions => '没有活跃会话';

  @override
  String get liveSessionJoin => '加入';

  @override
  String get liveSessionLeave => '离开会话';

  @override
  String get liveSessionViewing => '正在观看直播会话';

  @override
  String liveSessionHostedBy(String hostName) {
    return '由$hostName主持';
  }

  @override
  String liveSessionScenario(String scenarioName) {
    return '场景：$scenarioName';
  }

  @override
  String get liveSessionRequiresAuth => '登录以分享或观看直播会话';

  @override
  String get liveSessionStatusDisconnected => '已断开';

  @override
  String get liveSessionStatusConnecting => '连接中...';

  @override
  String get liveSessionStatusConnected => '已连接';

  @override
  String get liveSessionStatusReconnecting => '重新连接中...';

  @override
  String get liveSessionStatusError => '连接错误';

  @override
  String get liveSessionErrorHostingFailed => '无法开始主持。请重试。';

  @override
  String get liveSessionErrorJoinFailed => '无法加入会话。请重试。';

  @override
  String get liveSessionErrorConnectionLost => '连接丢失。正在尝试重新连接...';
}
