// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => '재생';

  @override
  String get pauseButton => '일시정지';

  @override
  String get resetButton => '재설정';

  @override
  String get resetSettingsDescription => '모든 설정을 기본값으로 재설정';

  @override
  String get speedLabel => '속도';

  @override
  String get trailsLabel => '궤적';

  @override
  String get statsLabel => '통계';

  @override
  String get bottomNavCameraLabel => '카메라';

  @override
  String get bottomNavVisualsLabel => '시각적';

  @override
  String get bottomNavPhysicsLabel => '물리';

  @override
  String get cameraTooltip => '카메라 설정 및 AI 모드';

  @override
  String get visualsTooltip => '시각적 디스플레이 옵션';

  @override
  String get physicsTooltip => '물리 시각화 및 설정';

  @override
  String get aiCameraModesTitle => 'AI 카메라 모드';

  @override
  String get manualControlTitle => '수동 제어';

  @override
  String get manualControlDescription => '완전한 수동 카메라 제어';

  @override
  String get predictiveOrbitalTitle => '예측 궤도';

  @override
  String get predictiveOrbitalDescription => 'AI가 최적의 궤도 뷰를 예측';

  @override
  String get dynamicFramingTitle => '동적 프레이밍';

  @override
  String get dynamicFramingDescription => 'AI가 모든 객체를 동적으로 프레이밍';

  @override
  String get manualControlsTitle => '수동 제어';

  @override
  String get selectNearestTitle => '가장 가까운 선택';

  @override
  String get stopFollowTitle => '추적 중지';

  @override
  String get followTitle => '추적';

  @override
  String get centerViewTitle => '중앙 뷰';

  @override
  String get stopRotateTitle => '회전 중지';

  @override
  String get autoRotateTitle => '자동 회전';

  @override
  String get displayOptionsTitle => '디스플레이 옵션';

  @override
  String get showTrailsTitle => '궤적 표시';

  @override
  String get showLabelsTitle => '라벨 표시';

  @override
  String get realisticColorsTitle => '사실적인 색상';

  @override
  String get physicsVisualizationTitle => '물리 시각화';

  @override
  String get gravityFieldsTitle => '중력장';

  @override
  String get gravityFieldsDescription => '중력장 시각화 표시';

  @override
  String get debugStatisticsTitle => '디버그 및 통계';

  @override
  String get showStatisticsTitle => '통계 표시';

  @override
  String get showStatisticsDescription => '성능 및 물리 통계 표시';

  @override
  String get currentStatisticsTitle => '현재 통계';

  @override
  String get bodiesStatLabel => '천체';

  @override
  String get timeScaleStatLabel => '시간 배율';

  @override
  String get selectedStatLabel => '선택됨';

  @override
  String get followLabel => '추적';

  @override
  String get centerLabel => '중앙';

  @override
  String get rotateLabel => '회전';

  @override
  String get warmTrails => '🔥 따뜻한';

  @override
  String get coolTrails => '❄️ 차가운';

  @override
  String get toggleStatsTooltip => '통계 전환';

  @override
  String get toggleLabelsTooltip => '천체 라벨 전환';

  @override
  String get showLabelsDescription => '시뮬레이션에서 천체 이름 표시';

  @override
  String get offScreenIndicatorsTitle => '화면 밖 표시기';

  @override
  String get offScreenIndicatorsDescription => '보이는 영역 밖의 객체를 가리키는 화살표 표시';

  @override
  String get autoRotateTooltip => '자동 회전';

  @override
  String get centerViewTooltip => '중앙 보기';

  @override
  String get focusOnNearestTooltip => '가장 가까운 천체에 초점 맞추기';

  @override
  String get followObjectTooltip => '선택한 객체 추적';

  @override
  String get stopFollowingTooltip => '객체 추적 중지';

  @override
  String get selectObjectToFollowTooltip => '추적할 객체 선택';

  @override
  String get settingsTitle => '애플리케이션 설정';

  @override
  String get settingsTooltip => '애플리케이션 설정';

  @override
  String get selectScenarioTooltip => '시나리오 선택';

  @override
  String get moreOptionsTooltip => '더 많은 옵션';

  @override
  String get physicsSettingsTitle => '물리 설정';

  @override
  String get physicsSettingsDescription => '시뮬레이션 매개변수';

  @override
  String get physicsSection => '물리학';

  @override
  String get gravitationalConstant => '중력 상수';

  @override
  String get softeningParameter => '소프트닝 매개변수';

  @override
  String get simulationSpeed => '시뮬레이션 속도';

  @override
  String get collisionsSection => '충돌';

  @override
  String get collisionSensitivity => '충돌 감도';

  @override
  String get trailsSection => '궤적';

  @override
  String get trailLength => '궤적 길이';

  @override
  String get trailFadeRate => '궤적 페이드 비율';

  @override
  String get hapticsSection => '햅틱';

  @override
  String get uiHapticFeedback => 'UI 햅틱 피드백';

  @override
  String get uiHapticFeedbackDescription =>
      '버튼 탭, 토글, 내비게이션과 같은 UI 상호작용에 대한 햅틱 피드백 활성화';

  @override
  String get collisionHapticFeedback => '충돌 햅틱 피드백';

  @override
  String get collisionHapticFeedbackDescription =>
      '시뮬레이션 중 천체가 충돌할 때 햅틱 피드백 활성화';

  @override
  String get vibrationEnabled => '진동 활성화';

  @override
  String get hapticFeedbackCollisions => '충돌 시 햅틱 피드백';

  @override
  String get hapticFeedbackDescription => 'UI 상호작용 및 충돌에 대한 햅틱 피드백 활성화';

  @override
  String get vibrationThrottle => '진동 제한';

  @override
  String get scenariosMenuDescription => '다양한 시나리오 탐색';

  @override
  String get settingsMenuDescription => '시각적 및 동작 옵션';

  @override
  String get helpMenuDescription => '튜토리얼 및 목표';

  @override
  String get aboutMenuDescription => '앱 정보 및 크레딧';

  @override
  String get showTrails => '궤적 표시';

  @override
  String get showTrailsDescription => '객체 뒤에 움직임의 궤적 표시';

  @override
  String get showOrbitalPaths => '궤도 경로 표시';

  @override
  String get showOrbitalPathsDescription => '안정된 궤도를 가진 시나리오에서 예측된 궤도 경로 표시';

  @override
  String get dualOrbitalPaths => '이중 궤도 경로';

  @override
  String get dualOrbitalPathsDescription => '이상적인 원형 궤도와 실제 타원형 궤도를 모두 표시';

  @override
  String get trailColorLabel => '궤적 색상';

  @override
  String get colorsLabel => '색상';

  @override
  String get realisticColors => '현실적인 색상';

  @override
  String get realisticColorsDescription => '온도와 항성 분류에 기반한 과학적으로 정확한 색상 사용';

  @override
  String get closeButton => '닫기';

  @override
  String get simulationStats => '시뮬레이션 통계';

  @override
  String get stepsLabel => '단계';

  @override
  String get timeLabel => '시간';

  @override
  String get earthYearsLabel => '지구년';

  @override
  String get speedStatsLabel => '속도';

  @override
  String get bodiesLabel => '천체';

  @override
  String get statusLabel => '상태';

  @override
  String get statusRunning => '실행 중';

  @override
  String get statusPaused => '일시정지됨';

  @override
  String get statusStopped => '정지됨';

  @override
  String get statusError => '오류';

  @override
  String get cameraLabel => '카메라';

  @override
  String get distanceLabel => '거리';

  @override
  String get autoRotateLabel => '자동 회전';

  @override
  String get autoRotateOn => '켜짐';

  @override
  String get autoRotateOff => '꺼짐';

  @override
  String get yawLabel => '요';

  @override
  String get pitchLabel => '피치';

  @override
  String get rollLabel => '롤';

  @override
  String get zoomLabel => '줌';

  @override
  String get cameraControlsLabel => '카메라 조작';

  @override
  String get invertPitchControlsLabel => '피치 조작 반전';

  @override
  String get invertPitchControlsDescription => '위/아래 드래그 방향 반전';

  @override
  String get cinematicCameraTechniqueLabel => 'AI 카메라 기술';

  @override
  String get cinematicCameraTechniqueDescription =>
      '객체를 추적할 때 AI가 카메라를 제어하는 방법 선택';

  @override
  String get cinematicTechniqueManual => '수동 제어';

  @override
  String get cinematicTechniqueManualDesc => '팔로우 모드가 있는 전통적인 수동 카메라 제어';

  @override
  String get cinematicTechniquePredictiveOrbital => '예측 궤도';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      '교육 시나리오용 AI 투어 및 궤도 예측';

  @override
  String get cinematicTechniqueDynamicFraming => '동적 프레이밍';

  @override
  String get cinematicTechniqueDynamicFramingDesc => '혼돈 시나리오용 실시간 극적 타겟팅';

  @override
  String get marketingLabel => '마케팅';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String timeFormatted(String time) {
    return '$time초';
  }

  @override
  String earthYearsFormatted(String years) {
    return '$years년';
  }

  @override
  String speedFormatted(String speed) {
    return '$speed배';
  }

  @override
  String get speedQuarter => '1/4 속도';

  @override
  String get speedHalf => '절반 속도';

  @override
  String get speedNormal => '보통';

  @override
  String get speedDouble => '2배 속도';

  @override
  String get speedFast => '빠름';

  @override
  String get speedVeryFast => '매우 빠름';

  @override
  String get speedMaximum => '최대';

  @override
  String bodiesCount(int count) {
    return '$count';
  }

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get scenarioSelectionTitle => '시나리오 선택';

  @override
  String get cancel => '취소';

  @override
  String get bodies => '천체';

  @override
  String get scenarioRandom => '무작위 시스템';

  @override
  String get scenarioRandomDescription => '예측 불가능한 역학을 가진 무작위로 생성된 혼돈 삼체 시스템';

  @override
  String get scenarioEarthMoonSun => '지구-달-태양';

  @override
  String get scenarioEarthMoonSunDescription => '친숙한 지구-달-태양 시스템의 교육적 시뮬레이션';

  @override
  String get scenarioBinaryStars => '이중성';

  @override
  String get scenarioBinaryStarsDescription =>
      '서로 궤도를 도는 두 개의 거대한 별과 주변 이중성 행성';

  @override
  String get scenarioAsteroidBelt => '소행성대';

  @override
  String get scenarioAsteroidBeltDescription => '암석 소행성과 파편 띠로 둘러싸인 중심별';

  @override
  String get scenarioGalaxyFormation => '은하 형성';

  @override
  String get scenarioGalaxyFormationDescription =>
      '중심 블랙홀 주위로 물질이 나선 구조로 조직화되는 것을 관찰';

  @override
  String get scenarioPlanetaryRings => '행성 고리';

  @override
  String get scenarioPlanetaryRingsDescription => '토성 같은 거대한 행성 주위의 고리 시스템 역학';

  @override
  String get scenarioSolarSystem => '태양계';

  @override
  String get scenarioSolarSystemDescription => '내행성과 외행성을 포함한 우리 태양계의 간소화된 버전';

  @override
  String get scenarioSpecial => '특별 시나리오';

  @override
  String get scenarioSpecialDescription => '스크린샷 모드용 특별 시나리오';

  @override
  String get habitabilityLabel => '거주 가능성';

  @override
  String get habitableZonesLabel => '거주 가능 지역';

  @override
  String get habitabilityIndicatorsLabel => '행성 상태';

  @override
  String get habitabilityHabitable => '거주 가능';

  @override
  String get habitabilityTooHot => '너무 뜨거움';

  @override
  String get habitabilityTooCold => '너무 차가움';

  @override
  String get habitabilityUnknown => '알 수 없음';

  @override
  String get temperatureFrozen => '얼어붙음';

  @override
  String get temperatureCold => '추위';

  @override
  String get temperatureModerate => '온화함';

  @override
  String get temperatureHot => '뜨거움';

  @override
  String get temperatureScorching => '타는 듯함';

  @override
  String get temperatureNotApplicable => '해당 없음';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get toggleHabitableZonesTooltip => '거주 가능 지역 전환';

  @override
  String get toggleHabitabilityIndicatorsTooltip => '행성 거주 가능성 상태 전환';

  @override
  String get habitableZonesDescription => '거주 가능한 지역을 나타내는 별 주위의 색상 영역 표시';

  @override
  String get habitabilityIndicatorsDescription =>
      '거주 가능성에 따른 행성 주위의 색상 코드 상태 고리 표시';

  @override
  String get aboutDialogTitle => '정보';

  @override
  String get appDescription =>
      '중력 역학과 궤도 역학을 탐구하는 물리 시뮬레이션. 대화형 3D 시각화를 통해 천체 운동의 아름다움과 복잡성을 경험하세요.';

  @override
  String get authorLabel => '작성자';

  @override
  String get websiteLabel => '웹사이트';

  @override
  String get aboutButtonTooltip => '정보';

  @override
  String get backButtonTooltip => '뒤로';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => '버전';

  @override
  String get loadingVersion => '버전 로딩 중...';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get gravityWellsLabel => '중력장';

  @override
  String get gravityWellsDescription => '객체 주변의 중력장 강도 표시';

  @override
  String get globalGravityFieldsLabel => '전역 중력장';

  @override
  String get globalGravityFieldsDescription => '모든 거대한 객체에 대한 중력장 시각화 활성화';

  @override
  String get gravityFieldColorSchemeLabel => '중력장 색상';

  @override
  String get gravityFieldColorSchemeDescription => '중력장 시각화를 위한 색상 스키마 선택';

  @override
  String get gravityColorSchemeClassic => '클래식';

  @override
  String get gravityColorSchemeSpectral => '스펙트럼';

  @override
  String get gravityColorSchemeMonochrome => '단색';

  @override
  String get gravityColorSchemeNeon => '네온';

  @override
  String get gravityColorSchemeEmerald => '에메랄드';

  @override
  String get gravityFieldStrengthLabel => '장 강도';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get equipotentialSurfacesLabel => '등전위면';

  @override
  String get equipotentialSurfacesDescription => '동일한 중력 위치 에너지의 표면 표시';

  @override
  String get gravityFieldIndicatorsLabel => '장 강도 지시기';

  @override
  String get gravityFieldIndicatorsDescription => '중력장 강도의 시각적 지시기 표시';

  @override
  String get toggleGravityFieldsTooltip => '중력장 전환';

  @override
  String get languageLabel => '언어';

  @override
  String get languageDescription => '앱 언어 변경';

  @override
  String get languageSystem => '시스템 기본값';

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
  String get bodyAlpha => '알파';

  @override
  String get bodyBeta => '베타';

  @override
  String get bodyGamma => '감마';

  @override
  String get bodyRockyPlanet => '암석 행성';

  @override
  String get bodyEarthLike => '지구형 행성';

  @override
  String get bodySuperEarth => '슈퍼지구';

  @override
  String get bodySun => '태양';

  @override
  String get bodyPropertiesTitle => '천체 속성';

  @override
  String get bodyPropertiesName => '이름';

  @override
  String get bodyPropertiesNameHint => '천체 이름 입력';

  @override
  String get bodyPropertiesType => '천체 유형';

  @override
  String get bodyPropertiesColor => '색상';

  @override
  String get bodyPropertiesMass => '질량';

  @override
  String get bodyPropertiesRadius => '반지름';

  @override
  String get bodyPropertiesLuminosity => '항성 광도';

  @override
  String get bodyPropertiesVelocity => '속도';

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyEarth => '지구';

  @override
  String get bodyMoon => '달';

  @override
  String get bodyStarA => '항성 A';

  @override
  String get bodyStarB => '항성 B';

  @override
  String get bodyPlanetP => '행성P';

  @override
  String get bodyMoonM => '위성M';

  @override
  String get bodyCentralStar => '중심별';

  @override
  String bodyAsteroid(int number) {
    return '소행성 $number';
  }

  @override
  String get bodyBlackHole => '블랙홀';

  @override
  String get bodyRingedPlanet => '고리 행성';

  @override
  String bodyRing(int number) {
    return '고리 $number';
  }

  @override
  String get bodyMercury => '수성';

  @override
  String get bodyVenus => '금성';

  @override
  String get bodyMars => '화성';

  @override
  String get bodyJupiter => '목성';

  @override
  String get bodySaturn => '토성';

  @override
  String get bodyUranus => '천왕성';

  @override
  String get bodyNeptune => '해왕성';

  @override
  String get bodyInnerPlanet => '내행성';

  @override
  String get bodyOuterPlanet => '외행성';

  @override
  String get bodyCenterOfMass => '질량 중심';

  @override
  String bodyStarNumber(int number) {
    return '별 $number';
  }

  @override
  String get educationalFocusChaoticDynamics => '혼돈 역학';

  @override
  String get educationalFocusRealWorldSystem => '실제 세계 시스템';

  @override
  String get educationalFocusBinaryOrbits => '이진 궤도';

  @override
  String get educationalFocusManyBodyDynamics => '다체 역학';

  @override
  String get educationalFocusStructureFormation => '구조 형성';

  @override
  String get educationalFocusPlanetaryMotion => '행성 운동';

  @override
  String get updateRequiredTitle => '업데이트 필요';

  @override
  String get updateRequiredMessage =>
      '이 앱의 새 버전이 사용 가능합니다. 최신 기능과 개선 사항을 계속 사용하려면 업데이트해주세요.';

  @override
  String get updateRequiredWarning => '이 버전은 더 이상 지원되지 않습니다.';

  @override
  String get updateNow => '지금 업데이트';

  @override
  String get updateLater => '나중에';

  @override
  String get versionStatusCurrent => '최신';

  @override
  String get versionStatusBeta => '베타';

  @override
  String get versionStatusOutdated => '구버전';

  @override
  String get maintenanceTitle => '유지보수';

  @override
  String get newsTitle => '뉴스';

  @override
  String get emergencyNotificationTitle => '중요한 공지';

  @override
  String get ok => '확인';

  @override
  String get screenshotMode => '스크린샷 모드';

  @override
  String get screenshotModeSubtitle => '마케팅 스크린샷 촬영을 위한 프리셋 장면 활성화';

  @override
  String get hideUIInScreenshotMode => '내비게이션 숨기기';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      '스크린샷 모드가 활성화될 때 앱 바, 하단 내비게이션, 저작권을 숨김';

  @override
  String screenshotCountdown(int seconds) {
    return '스크린샷 $seconds초 후';
  }

  @override
  String get scenePreset => '장면 프리셋';

  @override
  String get previousPreset => '이전 프리셋';

  @override
  String get nextPreset => '다음 프리셋';

  @override
  String get applyScene => '장면 적용';

  @override
  String appliedPreset(String presetName) {
    return '프리셋 적용됨: $presetName';
  }

  @override
  String get deactivate => '비활성화';

  @override
  String get sceneActive => '장면 활성화 - 스크린샷 촬영을 위해 시뮬레이션 일시정지';

  @override
  String get presetGalaxyFormationOverview => '은하 형성 개요';

  @override
  String get presetGalaxyFormationOverviewDesc => '우주 배경이 있는 나선 은하 형성의 광각 뷰';

  @override
  String get presetGalaxyCoreDetail => '은하 중심핵 세부사항';

  @override
  String get presetGalaxyCoreDetailDesc => '강착 원반이 있는 밝은 은하 중심의 클로즈업';

  @override
  String get presetGalaxyBlackHole => '은하 블랙홀';

  @override
  String get presetGalaxyBlackHoleDesc => '은하 중심의 초대질량 블랙홀의 클로즈업 뷰';

  @override
  String get presetCompleteSolarSystem => '완전한 태양계';

  @override
  String get presetCompleteSolarSystemDesc => '아름다운 궤도 궤적으로 보이는 모든 행성';

  @override
  String get presetInnerSolarSystem => '내태양계';

  @override
  String get presetInnerSolarSystemDesc =>
      '거주 가능 구역 지시기가 있는 수성, 금성, 지구, 화성의 클로즈업';

  @override
  String get presetEarthView => '지구 뷰';

  @override
  String get presetEarthViewDesc => '대기 세부사항이 있는 지구의 클로즈업 관점';

  @override
  String get presetSaturnRings => '토성의 장엄한 고리';

  @override
  String get presetSaturnRingsDesc => '상세한 고리 시스템이 있는 토성의 클로즈업';

  @override
  String get presetEarthMoonSystem => '지구-달 시스템';

  @override
  String get presetEarthMoonSystemDesc => '가시적인 궤도 역학이 있는 지구와 달';

  @override
  String get presetBinaryStarDrama => '쌍성 드라마';

  @override
  String get presetBinaryStarDramaDesc => '중력 춤을 추는 두 거대한 별의 정면 뷰';

  @override
  String get presetBinaryStarPlanetMoon => '쌍성 행성과 달';

  @override
  String get presetBinaryStarPlanetMoonDesc => '혼돈스러운 쌍성계에서 궤도를 도는 행성과 달';

  @override
  String get presetAsteroidBeltChaos => '소행성대 혼돈';

  @override
  String get presetAsteroidBeltChaosDesc => '중력 효과가 있는 밀집한 소행성 필드';

  @override
  String get presetThreeBodyBallet => '삼체 발레';

  @override
  String get presetThreeBodyBalletDesc => '우아한 움직임의 고전적 삼체 문제';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioLearnSolar => '학습 내용: 행성 운동, 궤도 역학, 친숙한 천체';

  @override
  String get scenarioBestSolar => '최적 대상: 초보자, 천문학 애호가';

  @override
  String get scenarioLearnEarthMoon => '학습 내용: 삼체 역학, 달의 역학, 조석력';

  @override
  String get scenarioBestEarthMoon => '최적 대상: 지구-달 시스템 이해';

  @override
  String get scenarioLearnBinary => '학습 내용: 항성 진화, 쌍성계, 극한 중력';

  @override
  String get scenarioBestBinary => '최적 대상: 고급 물리학 탐구';

  @override
  String get scenarioLearnThreeBody => '학습 내용: 카오스 이론, 예측 불가능한 운동, 불안정 시스템';

  @override
  String get scenarioBestThreeBody => '최적 대상: 수리물리학 애호가';

  @override
  String get scenarioLearnRandom => '학습 내용: 알려지지 않은 구성 발견, 실험 물리학';

  @override
  String get scenarioBestRandom => '최적 대상: 탐색과 실험';

  @override
  String get privacyPolicyLabel => '개인정보 보호정책';

  @override
  String get tutorialWelcomeTitle => 'Graviton에 오신 것을 환영합니다!';

  @override
  String get tutorialWelcomeDescription =>
      '중력 물리학의 매혹적인 세계로의 창문인 Graviton에 오신 것을 환영합니다! 이 앱을 통해 천체들이 중력을 통해 어떻게 상호작용하며 공간과 시간을 통해 아름다운 궤도 춤을 만들어내는지 탐구할 수 있습니다.';

  @override
  String get welcomeCardDescription =>
      '대화형 시뮬레이션을 통해 중력 물리학을 탐구하세요. 다양한 시나리오를 시도하고, 조작을 조정하며, 우주의 전개를 관찰하세요!';

  @override
  String get quickTutorialButton => '빠른 튜토리얼';

  @override
  String get gotItButton => '알겠습니다!';

  @override
  String get tutorialNavigationHint => '좌우로 스와이프하거나 버튼을 사용하여 탐색하세요';

  @override
  String get tutorialObjectivesTitle => '무엇을 할 수 있나요?';

  @override
  String get tutorialObjectivesDescription =>
      '• 현실적인 궤도 역학 관찰\n• 다양한 천문학적 시나리오 탐구\n• 중력 상호작용 실험\n• 충돌과 합병 관찰\n• 행성 운동에 대해 학습\n• 혼돈스러운 삼체 역학 발견';

  @override
  String get tutorialControlsTitle => '시뮬레이션 조작';

  @override
  String get tutorialControlsDescription =>
      '아무 곳이나 탭하여 시뮬레이션의 플로팅 재생/일시정지 컨트롤을 불러오세요. 속도 컨트롤은 우상단 모서리에 있습니다. 시나리오, 설정, 물리 조정을 위해 메뉴(⋮)를 탭하세요.';

  @override
  String get tutorialControlsDescriptionPart1 =>
      '아무 곳이나 탭하여 시뮬레이션의 플로팅 재생/일시정지 컨트롤을 불러오세요. 속도 컨트롤은 우상단 모서리에 있습니다. 메뉴';

  @override
  String get tutorialControlsDescriptionPart2 => '를 탭하여 시나리오, 설정, 물리 조정을 하세요.';

  @override
  String get tutorialCameraTitle => '카메라 & 뷰 조작';

  @override
  String get tutorialCameraDescription =>
      '드래그하여 뷰 회전, 핀치하여 줌, 두 손가락으로 카메라를 롤하세요. 하단 바에는 영화적 경험을 위한 포커스, 중앙 배치, 자동 회전 컨트롤이 있습니다.';

  @override
  String get tutorialScenariosTitle => '모험을 선택하세요';

  @override
  String get tutorialScenariosDescription =>
      '우상단 모서리의 메뉴(⋮)에 접근하여 다양한 시나리오를 탐구하세요: 우리의 태양계, 지구-달 역학, 쌍성, 또는 혼돈의 삼체 문제. 각각은 발견할 독특한 물리학을 제공합니다!';

  @override
  String get tutorialScenariosDescriptionPart1 => '우상단 모서리의 메뉴';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      '에 접근하여 다양한 시나리오를 탐구하세요: 우리의 태양계, 지구-달 역학, 쌍성, 또는 혼돈의 삼체 문제. 각각은 발견할 독특한 물리학을 제공합니다!';

  @override
  String get tutorialExploreTitle => '탐구할 준비 완료!';

  @override
  String get tutorialExploreDescription =>
      '준비 완료입니다! 친숙한 행성들을 보려면 태양계부터 시작하거나, 혼돈스러운 재미를 위해 삼체 문제에 뛰어드세요. 기억하세요: 매번 리셋할 때마다 탐구할 새로운 우주가 만들어집니다!';

  @override
  String get skipTutorial => '건너뛰기';

  @override
  String get previous => '이전';

  @override
  String get next => '다음';

  @override
  String get getStarted => '시작하기!';

  @override
  String get showTutorialTooltip => '튜토리얼 표시';

  @override
  String get helpAndObjectivesTitle => '도움말 및 목표';

  @override
  String get whatToDoTitle => 'Graviton에서 할 수 있는 것';

  @override
  String get whatToDoDescription =>
      'Graviton은 물리학 놀이터입니다:\n\n🪐 현실적인 궤도 역학 탐구\n🌟 항성 진화와 충돌 관찰\n🎯 중력에 대해 학습\n🎮 다양한 시나리오로 실험\n📚 천체 역학 이해\n🔄 무한한 랜덤 구성 생성';

  @override
  String get objectivesTitle => '학습 목표';

  @override
  String get objectives1 => '중력이 우주를 어떻게 형성하는지 이해';

  @override
  String get objectives2 => '안정적 vs 혼돈적 궤도 시스템 관찰';

  @override
  String get objectives3 => '행성이 왜 타원 궤도로 움직이는지 학습';

  @override
  String get objectives4 => '쌍성이 어떻게 상호작용하는지 발견';

  @override
  String get objectives5 => '객체가 충돌할 때 무슨 일이 일어나는지 관찰';

  @override
  String get objectives6 => '삼체 문제의 복잡성 이해';

  @override
  String get quickStartTitle => '빠른 시작 가이드';

  @override
  String get quickStart1 => '시나리오 선택 (초보자에게는 태양계 추천)';

  @override
  String get quickStart2 => '재생을 눌러 시뮬레이션 시작';

  @override
  String get quickStart3 => '드래그하여 뷰 회전, 핀치하여 줌';

  @override
  String get quickStart4 => '속도 슬라이더를 터치하여 시간 제어';

  @override
  String get quickStart5 => '새로운 랜덤 구성을 위해 리셋 시도';

  @override
  String get quickStart6 => '궤도 경로를 보려면 궤적 활성화';

  @override
  String get objectivesDescription =>
      '• 중력이 우주를 어떻게 형성하는지 이해\n• 안정적 vs 혼돈적 궤도 시스템 관찰\n• 행성이 왜 타원 궤도로 움직이는지 학습\n• 쌍성이 어떻게 상호작용하는지 발견\n• 객체가 충돌할 때 무슨 일이 일어나는지 관찰\n• 삼체 문제의 복잡성 이해';

  @override
  String get quickStartDescription =>
      '1. 시나리오 선택 (초보자에게는 태양계 추천)\n2. 재생을 눌러 시뮬레이션 시작\n3. 드래그하여 뷰 회전, 핀치하여 줌\n4. 속도 슬라이더를 터치하여 시간 제어\n5. 새로운 랜덤 구성을 위해 리셋 시도\n6. 궤도 경로를 보려면 궤적 활성화';

  @override
  String get showHelpTooltip => '도움말 및 목표';

  @override
  String get tutorialButton => '튜토리얼';

  @override
  String get resetTutorialButton => '재설정';

  @override
  String get tutorialResetMessage =>
      '튜토리얼 상태가 재설정되었습니다! 앱을 다시 시작하여 첫 사용 경험을 확인하세요.';

  @override
  String get copyButton => '복사';

  @override
  String couldNotOpenUrl(String url) {
    return '$url을 열 수 없습니다';
  }

  @override
  String errorOpeningLink(String error) {
    return '링크 열기 오류: $error';
  }

  @override
  String copiedToClipboard(String text) {
    return '클립보드에 복사됨: $text';
  }

  @override
  String get changelogTitle => '새로운 기능';

  @override
  String get closeDialog => '닫기';

  @override
  String changelogReleaseDate(String date) {
    return '$date에 출시';
  }

  @override
  String get changelogAdded => '새로운 기능';

  @override
  String get changelogImproved => '개선사항';

  @override
  String get changelogFixed => '버그 수정';

  @override
  String get changelogSkip => '건너뛰기';

  @override
  String get changelogDone => '완료';

  @override
  String get changelogButton => '변경 로그 표시';

  @override
  String get resetChangelogButton => '변경 로그 상태 재설정';

  @override
  String get changelogResetMessage => '변경 로그 상태가 재설정되었습니다';

  @override
  String get changelogDebugTitle => '변경 로그 (디버그)';

  @override
  String changelogNotFoundError(String version) {
    return '변경 로그를 찾을 수 없습니다. 먼저 Firestore에 변경 로그 데이터를 추가하세요.\n현재 버전: $version';
  }

  @override
  String changelogLoadError(String error) {
    return '변경 로그 로드 실패: $error';
  }

  @override
  String get noChangelogsAvailable => '사용 가능한 변경 로그가 없습니다';

  @override
  String errorLoadingChangelogs(String error) {
    return '변경 로그 로드 오류: $error';
  }

  @override
  String get stellarColorBlue => '파랑';

  @override
  String get stellarColorBlueWhite => '청백색';

  @override
  String get stellarColorWhite => '흰색';

  @override
  String get stellarColorYellowWhite => '황백색';

  @override
  String get stellarColorYellow => '노랑';

  @override
  String get stellarColorOrange => '주황';

  @override
  String get stellarColorRed => '빨강';

  @override
  String get pathVisualizationTitle => '궤도 시각화';

  @override
  String get navigationAidsTitle => '탐색 도구';

  @override
  String get gravityFieldClassicLabel => '클래식';

  @override
  String get gravityFieldSpectralLabel => '스펙트럼';

  @override
  String get gravityFieldMonochromeLabel => '모노크롬';

  @override
  String get gravityFieldNeonLabel => '네온';

  @override
  String get gravityFieldEmeraldLabel => '에메랄드';

  @override
  String get appInformationCredits => '앱 정보 및 크레딧';

  @override
  String get developerToolsTitle => '개발자 도구';

  @override
  String get developerToolsMenuDescription => '개발용 디버그 도구';

  @override
  String get tutorialDescription => '앱의 인터랙티브 가이드 투어';

  @override
  String get resetTutorialDescription => '튜토리얼 진행 상황 재설정';

  @override
  String get changelogDescription => '앱 업데이트 및 변경 사항 보기';

  @override
  String get resetChangelogDescription => '변경 로그 읽음 상태 재설정';

  @override
  String get tutorialResetSuccess => '튜토리얼 진행 상황이 재설정되었습니다';

  @override
  String get changelogResetSuccess => '변경 로그 상태가 재설정되었습니다';

  @override
  String get copyrightLabel => '저작권';

  @override
  String get allRightsReserved => '모든 권리 보유';

  @override
  String get bodyTypeStar => '항성';

  @override
  String get bodyTypePlanet => '행성';

  @override
  String get bodyTypeMoon => '달';

  @override
  String get bodyTypeAsteroid => '소행성';

  @override
  String get appFlavorDevelopment => '개발';

  @override
  String get appFlavorProduction => '프로덕션';

  @override
  String get notificationTypeError => '오류';

  @override
  String get notificationTypeWarning => '경고';

  @override
  String get notificationTypeInfo => '정보';

  @override
  String get notificationTypeSuccess => '성공';

  @override
  String get notificationTypeDebug => '디버그';

  @override
  String get trackingModeFull => '전체 추적';

  @override
  String get trackingModeEssential => '필수만';

  @override
  String get trackingModeNone => '추적 없음';

  @override
  String get trackingModeLimited => '제한된 추적';

  @override
  String get trackingModeFullDescription => '모든 분석, 충돌 및 상호작용';

  @override
  String get trackingModeEssentialDescription => '중요한 충돌 및 오류만';

  @override
  String get trackingModeNoneDescription => '데이터 수집 없음';

  @override
  String get trackingModeLimitedDescription => '사용자 상호작용만';

  @override
  String get changelogCategoryAdded => '추가됨';

  @override
  String get changelogCategoryImproved => '개선됨';

  @override
  String get changelogCategoryFixed => '수정됨';

  @override
  String get cameraManual => '수동 제어';

  @override
  String get cameraPredictiveOrbital => '예측 궤도';

  @override
  String get cameraDynamicFraming => '동적 프레이밍';

  @override
  String get cameraManualDescription => '팔로우 모드가 있는 전통적인 수동 카메라 제어';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'AI가 궤도 경로를 예측하여 극적인 카메라 움직임 제공';

  @override
  String get cameraDynamicFramingDescription => '장면 콘텐츠를 기반으로 프레이밍을 자동 조정';

  @override
  String get fullscreenMode => '전체화면 모드';

  @override
  String get fullscreenModeDescription => '몰입감 있는 보기를 위해 모든 UI 요소 숨기기';

  @override
  String get tapToToggleFullscreen => '탭하여 전체화면 전환';

  @override
  String get exitFullscreenHint => '전체화면 모드를 종료하려면 아무 곳이나 탭하세요';

  @override
  String get simulationCanvasLabel => '중력 물리 시뮬레이션';

  @override
  String get simulationCanvasHint =>
      '키보드 단축키로 시뮬레이션을 제어하세요. 스페이스로 일시정지, R로 재시작, C로 카메라 중앙 맞춤';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return '$bodyCount개의 천체가 있는 중력 시뮬레이션. 상태: $status. 속도: $speed. 단계: $steps';
  }

  @override
  String get noBodiesInSimulation => '현재 시뮬레이션에 천체가 없습니다';

  @override
  String bodiesInSimulation(String descriptions) {
    return '시뮬레이션의 천체: $descriptions';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return '거리 $distance에서 자유 모드 카메라. 자동 회전: $rotation';
  }

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return '거리 $distance에서 $bodyName을(를) 따라가는 카메라. 자동 회전: $rotation';
  }

  @override
  String get autoRotateActive => '활성';

  @override
  String get autoRotateInactive => '비활성';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType이(가) $value(으)로 변경됨';
  }

  @override
  String get keyboardShortcutsHint =>
      '스페이스로 일시정지/재개, R로 재시작, C로 카메라 중앙 맞춤, A로 자동 회전 전환';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return '물리: $time 시간 단위, $earthYears년, $steps 시뮬레이션 단계 완료';
  }

  @override
  String get toggleAutoRotateAction => '자동 회전 전환';

  @override
  String get zoomInAction => '확대';

  @override
  String get zoomOutAction => '축소';

  @override
  String get expandedState => '확장됨';

  @override
  String get collapsedState => '축소됨';

  @override
  String get currentScenario => '현재 시나리오';

  @override
  String get scenariosAvailable => '사용 가능한 시나리오';

  @override
  String get bottomSheetLabel => '하단 시트';

  @override
  String get gravitationalSimulationLabel => '중력 물리 시뮬레이션';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return '$bodyCount개의 천체가 있는 중력 시뮬레이션. 상태: $status. 속도: $speed. 완료된 단계: $stepCount. 시뮬레이션과 상호작용하려면 탭하거나 키보드 단축키를 사용하세요.';
  }
}
