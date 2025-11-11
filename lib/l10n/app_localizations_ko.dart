// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appDescription =>
      '중력 역학과 궤도 역학을 탐구하는 물리 시뮬레이션. 대화형 3D 시각화를 통해 천체 운동의 아름다움과 복잡성을 경험하세요.';

  @override
  String get appFlavorDevelopment => '개발';

  @override
  String get appFlavorProduction => '프로덕션';

  @override
  String get appInformationCredits => '앱 정보 및 크레딧';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => '뒤로';

  @override
  String get bottomNavVisualsLabel => '시각적';

  @override
  String get collisionHapticFeedbackDescription =>
      '시뮬레이션 중 천체가 충돌할 때 햅틱 피드백 활성화';

  @override
  String get exitFullscreenHint => '전체화면 모드를 종료하려면 아무 곳이나 탭하세요';

  @override
  String get fullscreenMode => '전체화면 모드';

  @override
  String get fullscreenModeDescription => '몰입감 있는 보기를 위해 모든 UI 요소 숨기기';

  @override
  String get hapticFeedbackCollisions => '충돌 시 햅틱 피드백';

  @override
  String get hapticFeedbackDescription => 'UI 상호작용 및 충돌에 대한 햅틱 피드백 활성화';

  @override
  String get uiHapticFeedbackDescription =>
      '버튼 탭, 토글, 내비게이션과 같은 UI 상호작용에 대한 햅틱 피드백 활성화';

  @override
  String get displayOptionsTitle => '디스플레이 옵션';

  @override
  String get pauseButton => '일시정지';

  @override
  String get playButton => '재생';

  @override
  String get presetAsteroidBeltChaos => '소행성대 혼돈';

  @override
  String get presetAsteroidBeltChaosDesc => '중력 효과가 있는 밀집한 소행성 필드';

  @override
  String get presetBinaryStarDrama => '쌍성 드라마';

  @override
  String get presetBinaryStarDramaDesc => '중력 춤을 추는 두 거대한 별의 정면 뷰';

  @override
  String get presetBinaryStarPlanetMoon => '쌍성 행성과 달';

  @override
  String get presetBinaryStarPlanetMoonDesc => '혼돈스러운 쌍성계에서 궤도를 도는 행성과 달';

  @override
  String get presetCompleteSolarSystem => '완전한 태양계';

  @override
  String get presetCompleteSolarSystemDesc => '아름다운 궤도 궤적으로 보이는 모든 행성';

  @override
  String get presetEarthMoonSystem => '지구-달 시스템';

  @override
  String get presetEarthMoonSystemDesc => '가시적인 궤도 역학이 있는 지구와 달';

  @override
  String get presetEarthView => '지구 뷰';

  @override
  String get presetEarthViewDesc => '대기 세부사항이 있는 지구의 클로즈업 관점';

  @override
  String get presetGalaxyBlackHole => '은하 블랙홀';

  @override
  String get presetGalaxyBlackHoleDesc => '은하 중심의 초대질량 블랙홀의 클로즈업 뷰';

  @override
  String get presetGalaxyCoreDetail => '은하 중심핵 세부사항';

  @override
  String get presetGalaxyCoreDetailDesc => '강착 원반이 있는 밝은 은하 중심의 클로즈업';

  @override
  String get presetGalaxyFormationOverview => '은하 형성 개요';

  @override
  String get presetGalaxyFormationOverviewDesc => '우주 배경이 있는 나선 은하 형성의 광각 뷰';

  @override
  String get presetInnerSolarSystem => '내태양계';

  @override
  String get presetInnerSolarSystemDesc =>
      '거주 가능 구역 지시기가 있는 수성, 금성, 지구, 화성의 클로즈업';

  @override
  String get presetSaturnRings => '토성의 장엄한 고리';

  @override
  String get presetSaturnRingsDesc => '상세한 고리 시스템이 있는 토성의 클로즈업';

  @override
  String get presetThreeBodyBallet => '삼체 발레';

  @override
  String get presetThreeBodyBalletDesc => '우아한 움직임의 고전적 삼체 문제';

  @override
  String get resetButton => '재설정';

  @override
  String get resetChangelogButton => '변경 로그 상태 재설정';

  @override
  String get resetChangelogDescription => '변경 로그 읽음 상태 재설정';

  @override
  String get resetSettingsDescription => '모든 설정을 기본값으로 재설정';

  @override
  String get resetTutorialDescription => '튜토리얼 진행 상황 재설정';

  @override
  String get simulationCanvasFocused => '시뮬레이션 캔버스에 포커스 - 주요 물리 시뮬레이션 영역';

  @override
  String get simulationCanvasHint =>
      '키보드 단축키로 시뮬레이션을 제어하세요. 스페이스로 일시정지, R로 재시작, C로 카메라 중앙 맞춤';

  @override
  String get simulationCanvasLabel => '중력 물리 시뮬레이션';

  @override
  String get simulationControlsFocused => '시뮬레이션 컨트롤에 포커스';

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
  String get simulationSpeed => '시뮬레이션 속도';

  @override
  String get simulationSpeedHint =>
      '시뮬레이션 속도를 0.1배에서 16배 정상 속도까지 조정합니다. 화살표 키를 사용하여 세밀하게 조정할 수 있습니다.';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return '$bodyCount개의 천체가 있는 중력 시뮬레이션. 상태: $status. 속도: $speed. 완료된 단계: $stepCount. 시뮬레이션과 상호작용하려면 탭하거나 키보드 단축키를 사용하세요.';
  }

  @override
  String get simulationStats => '시뮬레이션 통계';

  @override
  String get simulationStepsLabel => '시뮬레이션 단계';

  @override
  String get speedDouble => '2배 속도';

  @override
  String get speedFast => '빠름';

  @override
  String speedFormatted(String speed) {
    return '$speed배';
  }

  @override
  String get speedHalf => '절반 속도';

  @override
  String get speedLabel => '속도';

  @override
  String get speedMaximum => '최대';

  @override
  String get speedNormal => '보통';

  @override
  String get speedQuarter => '1/4 속도';

  @override
  String get speedVeryFast => '매우 빠름';

  @override
  String get stopFollowTitle => '추적 중지';

  @override
  String get stopFollowingTooltip => '객체 추적 중지';

  @override
  String get stopRotateTitle => '회전 중지';

  @override
  String get testPresetForUnitTesting => '단위 테스트용 테스트 프리셋';

  @override
  String get trailsLabel => '궤적';

  @override
  String get cameraControlsFocused => '카메라 컨트롤에 포커스';

  @override
  String get cameraControlsLabel => '카메라 조작';

  @override
  String get cameraDynamicFraming => '동적 프레이밍';

  @override
  String get cameraDynamicFramingDescription => '장면 콘텐츠를 기반으로 프레이밍을 자동 조정';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return '거리 $distance에서 $bodyName을(를) 따라가는 카메라. 자동 회전: $rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return '거리 $distance에서 자유 모드 카메라. 자동 회전: $rotation';
  }

  @override
  String get cameraLabel => '카메라';

  @override
  String get cameraManual => '수동 제어';

  @override
  String get cameraManualDescription => '팔로우 모드가 있는 전통적인 수동 카메라 제어';

  @override
  String get cameraPredictiveOrbital => '예측 궤도';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'AI가 궤도 경로를 예측하여 극적인 카메라 움직임 제공';

  @override
  String get cameraSettingsTitle => '카메라 설정';

  @override
  String get cameraSpeedHint =>
      'AI 카메라 이동 속도를 느림에서 빠름까지 조정하세요. 화살표 키를 사용하여 작은 단위로 변경할 수 있습니다.';

  @override
  String get cameraSpeedLabel => '카메라 속도';

  @override
  String get cameraTooltip => '카메라 설정 및 AI 모드';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => '거리';

  @override
  String get previewEditortitle => '미리보기 편집기 제목';

  @override
  String get setupEditorTitle => '설정';

  @override
  String get rotateLabel => '회전';

  @override
  String get viewPhysicsSettings => '물리 설정 보기';

  @override
  String get zoomInAction => '확대';

  @override
  String get zoomLabel => '줌';

  @override
  String get zoomOutAction => '축소';

  @override
  String get colorEditor => '색상 편집기';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return '색상 옵션 $color';
  }

  @override
  String get colorSelector => '색상 선택기';

  @override
  String colorOptionTooltip(String colorName) {
    return '천체에 $colorName 색상 선택';
  }

  @override
  String get visualsTooltip => '시각적 디스플레이 옵션';

  @override
  String get collisionHapticFeedback => '충돌 햅틱 피드백';

  @override
  String get collisionSensitivity => '충돌 감도';

  @override
  String get gravityColorSchemeClassic => '클래식';

  @override
  String get gravityColorSchemeEmerald => '에메랄드';

  @override
  String get gravityColorSchemeMonochrome => '단색';

  @override
  String get gravityColorSchemeNeon => '네온';

  @override
  String get gravityColorSchemeSpectral => '스펙트럼';

  @override
  String get gravityEditor => '중력 편집기';

  @override
  String get gravityFieldColorSchemeDescription => '중력장 시각화를 위한 색상 스키마 선택';

  @override
  String get gravityFieldColorSchemeLabel => '중력장 색상';

  @override
  String get gravityFieldIndicatorsDescription => '중력장 강도의 시각적 지시기 표시';

  @override
  String get gravityFieldIndicatorsLabel => '장 강도 지시기';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => '장 강도';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription => '중력장 시각화 표시';

  @override
  String get gravityFieldsTitle => '중력장';

  @override
  String get gravityWellsDescription => '객체 주변의 중력장 강도 표시';

  @override
  String get gravityWellsLabel => '중력장';

  @override
  String get massKgEditorhint => '질량을 킬로그램으로 입력';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      '물리 구성이 여기에서 구현됩니다-편집기';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return '물리 필드가 범위를 벗어남';
  }

  @override
  String get physicsSection => '물리학';

  @override
  String get physicsSettingsDescription => '시뮬레이션 매개변수';

  @override
  String get physicsSettingsTitle => '물리 설정';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return '물리: $time 시간 단위, $earthYears년, $steps 시뮬레이션 단계 완료';
  }

  @override
  String get physicsTooltip => '물리 시각화 및 설정';

  @override
  String get physicsVisualizationTitle => '물리 시각화';

  @override
  String get temperatureCold => '추위';

  @override
  String get temperatureEditorlabel => '온도 편집기 라벨';

  @override
  String get temperatureFrozen => '얼어붙음';

  @override
  String get temperatureHot => '뜨거움';

  @override
  String get temperatureKEditorhint => '온도를 켈빈으로 입력';

  @override
  String get temperatureCelsiusEditorhint => '온도 (°C)';

  @override
  String get temperatureFahrenheitEditorhint => '온도 (°F)';

  @override
  String get temperatureModerate => '온화함';

  @override
  String get temperatureNotApplicable => '해당 없음';

  @override
  String get temperatureScorching => '타는 듯함';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitCelsiusName => '섭씨';

  @override
  String get temperatureUnitFahrenheitName => '화씨';

  @override
  String get temperatureUnitKelvinName => '켈빈';

  @override
  String get velocityMsEditor => '속도 m/s 편집기';

  @override
  String get addBodyButton => '천체 추가 버튼';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      '사용자 정의 시나리오를 만들기 위해 천체 추가-편집기';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      '소행성대 및 기타 입자 시스템이 여기에서 구성됩니다-편집기';

  @override
  String get beginnerEditor => '초보자 편집기';

  @override
  String get noBodiesAdded => '아직 천체가 추가되지 않음';

  @override
  String get addBodiesInSetupTab => '설정 탭에서 천체 추가';

  @override
  String get untitledScenario => '제목 없는 시나리오';

  @override
  String get noDescriptionProvided => '설명이 제공되지 않음';

  @override
  String get collisionSoftening => '충돌 완화';

  @override
  String get collisionRadius => '충돌 반경';

  @override
  String get bodyTypeEditor => '천체 유형 편집기';

  @override
  String get createACopyOfThisCelestialBodyEditorHint => '이 천체의 사본 만들기-편집기 힌트';

  @override
  String get createCustomScenarioButton => '사용자 정의 시나리오 생성 버튼';

  @override
  String get createCustomScenarioDescription => '사용자 정의 시나리오 설명';

  @override
  String get createScenarioButton => '시나리오 생성 버튼';

  @override
  String get createScenarioTitle => '시나리오 생성 제목';

  @override
  String get editScenarioButton => '시나리오 편집';

  @override
  String get editScenarioHint => '이 시나리오 편집';

  @override
  String get deleteScenarioButton => '시나리오 삭제';

  @override
  String get deleteScenarioHint => '이 시나리오 삭제';

  @override
  String get customGravitationalSimulationEditor => '사용자 정의 중력 시뮬레이션 편집기';

  @override
  String get deleteBodyConfirmMessage => '천체 삭제 확인 메시지';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return '천체 삭제 확인 제목';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return '$bodyName 삭제';
  }

  @override
  String get deleteBodyTooltip => '천체 삭제 툴팁';

  @override
  String get deleteButton => '삭제 버튼';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return '시나리오 삭제 확인 메시지';
  }

  @override
  String get deleteScenarioTitle => '시나리오 삭제 제목';

  @override
  String deleteScenarioSuccessMessage(String scenarioName) {
    return '시나리오가 성공적으로 삭제되었습니다: $scenarioName';
  }

  @override
  String deleteScenarioFailedMessage(String error) {
    return '시나리오 삭제에 실패했습니다: $error';
  }

  @override
  String get editEditorLabel => '편집 편집기 라벨';

  @override
  String get editScenarioTitle => '시나리오 편집 제목';

  @override
  String get gravitationalForcesEditor => '중력 편집기';

  @override
  String get newScenarioEditor => '새 시나리오 편집기';

  @override
  String get noBodiesYetEditor => '아직 천체가 없음-편집기';

  @override
  String get positionMEditor => '위치 m 편집기';

  @override
  String get positionMotionEditor => '위치/운동 편집기';

  @override
  String get propertiesEditor => '속성 편집기';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      '시나리오에서 이 천체 제거-편집기 힌트';

  @override
  String get softeningEditor => '소프트닝 편집기';

  @override
  String get stellarPropertiesEditor => '항성 속성 편집기';

  @override
  String get trailPointsEditor => '궤적 포인트 편집기';

  @override
  String get customColor => '사용자 정의 색상';

  @override
  String get customLabel => '사용자 정의 라벨';

  @override
  String get customScenarioDescription => '사용자 정의 시나리오 설명';

  @override
  String get exportScenarioButton => '시나리오 내보내기';

  @override
  String get exportScenarioHint => '공유를 위해 시나리오를 파일로 내보내기';

  @override
  String exportScenarioFailedMessage(String error) {
    return '시나리오 내보내기 실패';
  }

  @override
  String get exportScenarioNotImplementedMessage => '시나리오 내보내기 미구현';

  @override
  String get saveButton => '저장';

  @override
  String get saveBodyTooltip => '천체 저장';

  @override
  String get saveNewBodyAccessibility => '새 천체 저장';

  @override
  String get saveNewBodyHint => '현재 설정으로 천체를 생성합니다';

  @override
  String get saveChangesToBodyAccessibility => '천체 변경사항 저장';

  @override
  String get saveChangesToBodyHint => '이 천체에 대한 모든 변경사항을 저장합니다';

  @override
  String get moreActionsAccessibility => '추가 작업';

  @override
  String get moreActionsHint => '복제 및 삭제 옵션 메뉴 열기';

  @override
  String get duplicateBodyAccessibility => '이 천체의 사본을 생성';

  @override
  String get deleteBodyAccessibility => '이 천체를 영구적으로 제거';

  @override
  String get settingsButtonFocused => '설정 버튼에 포커스';

  @override
  String get settingsMenuDescription => '시각적 및 동작 옵션';

  @override
  String get settingsTooltip => '애플리케이션 설정';

  @override
  String get toggleAutoRotateAction => '자동 회전 전환';

  @override
  String get toggleGravityFieldsTooltip => '중력장 전환';

  @override
  String get toggleHabitabilityIndicatorsTooltip => '행성 거주 가능성 상태 전환';

  @override
  String get toggleHabitableZonesTooltip => '거주 가능 지역 전환';

  @override
  String get toggleLabelsTooltip => '천체 라벨 전환';

  @override
  String get toggleStatsTooltip => '통계 전환';

  @override
  String get statsLabel => '통계';

  @override
  String get helpMenuDescription => '튜토리얼 및 목표';

  @override
  String get tutorialButton => '튜토리얼';

  @override
  String get tutorialCameraDescription =>
      '드래그하여 뷰 회전, 핀치하여 줌, 두 손가락으로 카메라를 롤하세요. 하단 바에는 영화적 경험을 위한 포커스, 중앙 배치, 자동 회전 컨트롤이 있습니다.';

  @override
  String get tutorialCameraTitle => '카메라 & 뷰 조작';

  @override
  String get tutorialControlsDescription =>
      '아무 곳이나 탭하여 시뮬레이션의 플로팅 재생/일시정지 컨트롤을 불러오세요. 속도 컨트롤은 우상단 모서리에 있습니다. 시나리오, 설정, 물리 조정을 위해 메뉴(⋮)를 탭하세요.';

  @override
  String get tutorialControlsDescriptionPart1 =>
      '아무 곳이나 탭하여 시뮬레이션의 플로팅 재생/일시정지 컨트롤을 불러오세요. 속도 컨트롤은 우상단 모서리에 있습니다. 메뉴';

  @override
  String get tutorialControlsDescriptionPart2 => '를 탭하여 시나리오, 설정, 물리 조정을 하세요.';

  @override
  String get tutorialControlsTitle => '시뮬레이션 조작';

  @override
  String get tutorialDescription => '앱의 인터랙티브 가이드 투어';

  @override
  String get tutorialExploreDescription =>
      '준비 완료입니다! 친숙한 행성들을 보려면 태양계부터 시작하거나, 혼돈스러운 재미를 위해 삼체 문제에 뛰어드세요. 기억하세요: 매번 리셋할 때마다 탐구할 새로운 우주가 만들어집니다!';

  @override
  String get tutorialExploreTitle => '탐구할 준비 완료!';

  @override
  String get tutorialNavigationHint => '좌우로 스와이프하거나 버튼을 사용하여 탐색하세요';

  @override
  String get tutorialObjectivesDescription =>
      '• 현실적인 궤도 역학 관찰\n• 다양한 천문학적 시나리오 탐구\n• 중력 상호작용 실험\n• 충돌과 합병 관찰\n• 행성 운동에 대해 학습\n• 혼돈스러운 삼체 역학 발견';

  @override
  String get tutorialObjectivesTitle => '무엇을 할 수 있나요?';

  @override
  String get tutorialResetMessage =>
      '튜토리얼 상태가 재설정되었습니다! 앱을 다시 시작하여 첫 사용 경험을 확인하세요.';

  @override
  String get tutorialResetSuccess => '튜토리얼 진행 상황이 재설정되었습니다';

  @override
  String get tutorialScenariosDescription =>
      '우상단 모서리의 메뉴(⋮)에 접근하여 다양한 시나리오를 탐구하세요: 우리의 태양계, 지구-달 역학, 쌍성, 또는 혼돈의 삼체 문제. 각각은 발견할 독특한 물리학을 제공합니다!';

  @override
  String get tutorialScenariosDescriptionPart1 => '우상단 모서리의 메뉴';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      '에 접근하여 다양한 시나리오를 탐구하세요: 우리의 태양계, 지구-달 역학, 쌍성, 또는 혼돈의 삼체 문제. 각각은 발견할 독특한 물리학을 제공합니다!';

  @override
  String get tutorialScenariosTitle => '모험을 선택하세요';

  @override
  String get tutorialWelcomeDescription =>
      '중력 물리학의 매혹적인 세계로의 창문인 Graviton에 오신 것을 환영합니다! 이 앱을 통해 천체들이 중력을 통해 어떻게 상호작용하며 공간과 시간을 통해 아름다운 궤도 춤을 만들어내는지 탐구할 수 있습니다.';

  @override
  String get tutorialWelcomeTitle => 'Graviton에 오신 것을 환영합니다!';

  @override
  String get welcomeCardDescription =>
      '대화형 시뮬레이션을 통해 중력 물리학을 탐구하세요. 다양한 시나리오를 시도하고, 조작을 조정하며, 우주의 전개를 관찰하세요!';

  @override
  String get cancel => '취소';

  @override
  String get descriptionEditorLabel => '설명 편집기 라벨';

  @override
  String get next => '다음';

  @override
  String get ok => 'OK';

  @override
  String get previous => '이전';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateType이(가) $value(으)로 변경됨';
  }

  @override
  String timeFormatted(String time) {
    return '$time초';
  }

  @override
  String get timeLabel => '시간';

  @override
  String get timeScaleStatLabel => '시간 배율';

  @override
  String get updateLater => '나중에';

  @override
  String get updateNow => '지금 업데이트';

  @override
  String get updateRequiredMessage =>
      '이 앱의 새 버전이 사용 가능합니다. 최신 기능과 개선 사항을 계속 사용하려면 업데이트해주세요.';

  @override
  String get updateRequiredTitle => '업데이트 필요';

  @override
  String get updateRequiredWarning => '이 버전은 더 이상 지원되지 않습니다.';

  @override
  String errorLoadingChangelogs(String error) {
    return '변경 로그 로드 오류: $error';
  }

  @override
  String errorOpeningLink(String error) {
    return '링크 열기 오류: $error';
  }

  @override
  String get notificationTypeDebug => '디버그';

  @override
  String get notificationTypeInfo => '정보';

  @override
  String get warningTitle => '경고';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return '접근성 안내 건너뜀 - 바인딩 없음';
  }

  @override
  String get accessibilityCameraFocus => '카메라가 가장 가까운 천체에 초점을 맞췄습니다';

  @override
  String get accessibilityCameraFollow => '카메라가 이제 선택된 천체를 따라갑니다';

  @override
  String get accessibilityCameraReset => '카메라 뷰가 기본 위치로 재설정되었습니다';

  @override
  String get accessibilityCameraUnfollow => '카메라가 천체 따라가기를 중지했습니다';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return '충돌 민감도가 $newValue(으)로 변경되었습니다';
  }

  @override
  String accessibilityError(String errorMessage) {
    return '오류: $errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return '중력 강도가 $newValue(으)로 변경되었습니다';
  }

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return '충돌 감지됨: $body1이(가) $body2와(과) 합쳐졌습니다';
  }

  @override
  String get accessibilityMergeEventContext => '결합된 질량이 새로운 천체를 만들었습니다';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return '시나리오가 $scenarioName(으)로 변경되었습니다';
  }

  @override
  String get accessibilityScenarioChangeContext => '새로운 천체들과 물리 매개변수가 로드되었습니다';

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingName이(가) 비활성화되었습니다';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingName이(가) 활성화되었습니다';
  }

  @override
  String get accessibilitySimulationPaused => '시뮬레이션 일시정지됨';

  @override
  String get accessibilitySimulationPausedContext => '모든 천체가 움직임을 멈췄습니다';

  @override
  String get accessibilitySimulationReset => '시뮬레이션 재설정됨';

  @override
  String get accessibilitySimulationResetContext =>
      '새로운 시나리오가 새로운 천체들과 함께 로드되었습니다';

  @override
  String get accessibilitySimulationResumed => '시뮬레이션 재개됨';

  @override
  String get accessibilitySimulationResumedContext => '천체들이 다시 움직이기 시작했습니다';

  @override
  String get accessibilitySimulationStarted => '시뮬레이션 시작됨';

  @override
  String get accessibilitySimulationStartedContext => '천체들이 이제 움직이고 있습니다';

  @override
  String get accessibilitySimulationStopped => '시뮬레이션 중지됨';

  @override
  String get accessibilitySimulationStoppedContext => '모든 천체가 재설정되었습니다';

  @override
  String accessibilitySpeedChange(String newValue) {
    return '시뮬레이션 속도가 $newValue(으)로 변경되었습니다';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return '튜토리얼 단계 $currentStep/$totalSteps: $stepName';
  }

  @override
  String get changelogAdded => '새로운 기능';

  @override
  String get changelogButton => '변경 로그 표시';

  @override
  String get changelogCategoryAdded => '추가됨';

  @override
  String get changelogCategoryFixed => '수정됨';

  @override
  String get changelogCategoryImproved => '개선됨';

  @override
  String get changelogDescription => '앱 업데이트 및 변경 사항 보기';

  @override
  String get changelogDone => '완료';

  @override
  String get changelogFixed => '버그 수정';

  @override
  String get changelogHometitle => '변경 로그 홈 제목';

  @override
  String get changelogImproved => '개선사항';

  @override
  String changelogLoadError(String error) {
    return '변경 로그 로드 실패: $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return '변경 로그를 찾을 수 없습니다. 먼저 Firestore에 변경 로그 데이터를 추가하세요.\n현재 버전: $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return '$date에 출시';
  }

  @override
  String get changelogResetMessage => '변경 로그 상태가 재설정되었습니다';

  @override
  String get changelogResetSuccess => '변경 로그 상태가 재설정되었습니다';

  @override
  String get changelogTitle => '새로운 기능';

  @override
  String get debugStatisticsTitle => '디버그 및 통계';

  @override
  String errorLoadingChangelogEHome(String error) {
    return '변경 로그 로딩 오류';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return '이 버전의 변경 로그가 없습니다';
  }

  @override
  String get testPreset => '테스트 프리셋';

  @override
  String get testScenarioButton => '테스트 시나리오 버튼';

  @override
  String get testScenarioHint => '시뮬레이션에서 현재 시나리오 테스트';

  @override
  String get testScenarioNotImplementedMessage => '테스트 시나리오 미구현';

  @override
  String get scenarioEditorMenuHint => '테스트 및 내보내기 옵션이 있는 메뉴 열기';

  @override
  String get aboutButtonTooltip => '정보';

  @override
  String get aboutMenuDescription => '앱 정보 및 크레딧';

  @override
  String get accessAppPreferences => '앱 환경설정에 액세스';

  @override
  String get accessScenarioOptions => '시나리오 옵션에 액세스';

  @override
  String get adjustSimulationSpeed => '시뮬레이션 속도 조정';

  @override
  String get aiCameraModesTitle => 'AI 카메라 모드';

  @override
  String get allRightsReserved => '모든 권리 보유';

  @override
  String get announcementTitle => '공지';

  @override
  String appliedPreset(String presetName) {
    return '프리셋 적용됨: $presetName';
  }

  @override
  String get applyScene => '장면 적용';

  @override
  String get atLeastOneBodyIsRequired => '최소 하나의 천체가 필요합니다';

  @override
  String get authorLabel => '작성자';

  @override
  String get autoRotateActive => '활성';

  @override
  String get autoRotateInactive => '비활성';

  @override
  String get autoRotateLabel => '자동 회전';

  @override
  String get autoRotateOff => '꺼짐';

  @override
  String get autoRotateOn => '켜짐';

  @override
  String get autoRotateTooltip => '자동 회전';

  @override
  String get blackColor => '검은색';

  @override
  String get bodies => '천체';

  @override
  String get bodiesHeaderDescription => '천체 헤더 설명';

  @override
  String bodiesHeaderPlural(int count) {
    return '천체';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return '시뮬레이션의 천체: $descriptions';
  }

  @override
  String get bodiesLabel => '천체';

  @override
  String get bodyAlpha => '알파';

  @override
  String bodyAsteroid(int number) {
    return '소행성 $number';
  }

  @override
  String get bodyBeta => '베타';

  @override
  String get bodyBlackHole => '블랙홀';

  @override
  String get bodyCenterOfMass => '질량 중심';

  @override
  String get bodyCentralStar => '중심별';

  @override
  String bodyColorInvalid(String prefix) {
    return '천체 색상이 무효';
  }

  @override
  String get bodyEarth => '지구';

  @override
  String get bodyEarthLike => '지구형 행성';

  @override
  String get bodyGamma => '감마';

  @override
  String bodyIndex(int index) {
    return '천체 인덱스';
  }

  @override
  String get bodyInnerPlanet => '내행성';

  @override
  String get bodyJupiter => '목성';

  @override
  String get bodyMars => '화성';

  @override
  String bodyMassInvalid(String prefix) {
    return '천체 질량이 무효';
  }

  @override
  String get bodyMercury => '수성';

  @override
  String get bodyMoon => '달';

  @override
  String get bodyMoonM => '위성M';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return '$bodyName의 사본';
  }

  @override
  String bodyNameRequired(String prefix) {
    return '천체 이름이 필요합니다';
  }

  @override
  String get bodyNeptune => '해왕성';

  @override
  String bodyNumberTemplate(String number) {
    return '천체 $number';
  }

  @override
  String get bodyOuterPlanet => '외행성';

  @override
  String get bodyPlanetP => '행성P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return '천체 위치 구성 요소가 무효';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return '천체 위치가 무효';
  }

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyPropertiesLuminosity => '항성 광도';

  @override
  String get bodyPropertiesMass => '질량';

  @override
  String get bodyPropertiesName => '이름';

  @override
  String get bodyPropertiesNameHint => '천체 이름 입력';

  @override
  String get bodyPropertiesRadius => '반지름';

  @override
  String get bodyPropertiesMassHint => '중력 영향과 궤도 역학 조정';

  @override
  String get bodyPropertiesRadiusHint => '크기와 충돌 경계 제어';

  @override
  String get bodyPropertiesTitle => '천체 속성';

  @override
  String get bodyPropertiesVelocity => '속도';

  @override
  String bodyRadiusInvalid(String prefix) {
    return '천체 반지름이 무효';
  }

  @override
  String bodyRing(int number) {
    return '고리 $number';
  }

  @override
  String get bodyRingedPlanet => '고리 행성';

  @override
  String get bodyRockyPlanet => '암석 행성';

  @override
  String get bodySaturn => '토성';

  @override
  String bodySelectedTemplate(String bodyNumber, Object bodyName) {
    return '$bodyName이(가) 선택됨';
  }

  @override
  String get bodyStarA => '항성 A';

  @override
  String get bodyStarB => '항성 B';

  @override
  String bodyStarNumber(int number) {
    return '별 $number';
  }

  @override
  String get bodySun => '태양';

  @override
  String get bodySuperEarth => '슈퍼지구';

  @override
  String get bodyTypeAsteroid => '소행성';

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 소행성',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeInvalid(String prefix, String bodyType) {
    return '천체 유형이 무효';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 달',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypePlanet => '행성';

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 행성',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeSelector => '천체 유형 선택기';

  @override
  String get bodyTypeStar => '항성';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 항성',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return '천체 유형: $type';
  }

  @override
  String get bodyUranus => '천왕성';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return '천체 속도 구성 요소가 무효';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return '천체 속도가 무효';
  }

  @override
  String get bodyVenus => '금성';

  @override
  String get bottomSheetFocused => '하단 시트에 포커스';

  @override
  String get bottomSheetLabel => '하단 시트';

  @override
  String get browseAvailableSimulations => '사용 가능한 시뮬레이션 탐색';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return '천체 $name';
  }

  @override
  String get centerLabel => '중앙';

  @override
  String get centerViewTooltip => '중앙 보기';

  @override
  String get cinematicCameraTechniqueDescription =>
      '객체를 추적할 때 AI가 카메라를 제어하는 방법 선택';

  @override
  String get cinematicCameraTechniqueLabel => 'AI 카메라 기술';

  @override
  String get cinematicTechniqueDynamicFramingDesc => '혼돈 시나리오용 실시간 극적 타겟팅';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc =>
      '교육 시나리오용 AI 투어 및 궤도 예측';

  @override
  String get closeButton => '닫기';

  @override
  String get collapsedState => '축소됨';

  @override
  String get collisionsSection => '충돌';

  @override
  String get colorsLabel => '색상';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ 차가운';

  @override
  String copiedToClipboard(String text) {
    return '클립보드에 복사됨: $text';
  }

  @override
  String get copyButton => '복사';

  @override
  String get copyrightLabel => '저작권';

  @override
  String couldNotOpenUrl(String url) {
    return '$url을 열 수 없습니다';
  }

  @override
  String get crosshairsDescription => '화면 중앙 표시기 표시';

  @override
  String get crosshairsTitle => '십자선';

  @override
  String get currentScenario => '현재 시나리오';

  @override
  String get currentStatisticsTitle => '현재 통계';

  @override
  String get currentlySelected => '현재 선택됨';

  @override
  String get cyanColor => '청록색';

  @override
  String get deactivate => '비활성화';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      '이 시나리오가 무엇을 보여주는지 설명-편집기 힌트';

  @override
  String get detailsEditorLabel => '세부 정보 편집기 라벨';

  @override
  String get developerToolsMenuDescription => '개발용 디버그 도구';

  @override
  String get developerToolsTitle => '개발자 도구';

  @override
  String get difficultyEditorLabel => '난이도 편집기 라벨';

  @override
  String get discardButton => '버리기 버튼';

  @override
  String get dragToRotateCameraView => '드래그하여 카메라 뷰 회전';

  @override
  String get dualOrbitalPaths => '이중 궤도 경로';

  @override
  String get dualOrbitalPathsDescription => '이상적인 원형 궤도와 실제 타원형 궤도를 모두 표시';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return '$bodyName 복제';
  }

  @override
  String get duplicateBodyTooltip => '천체 복제 툴팁';

  @override
  String get dynamicFramingDescription => 'AI가 모든 객체를 동적으로 프레이밍';

  @override
  String get earthBlueColor => '지구 파란색';

  @override
  String earthYearsFormatted(String years) {
    return '$years년';
  }

  @override
  String get earthYearsLabel => '지구년';

  @override
  String get educationalFocusBinaryOrbits => '이진 궤도';

  @override
  String get educationalFocusChaoticDynamics => '혼돈 역학';

  @override
  String get educationalFocusManyBodyDynamics => '다체 역학';

  @override
  String get educationalFocusPlanetaryMotion => '행성 운동';

  @override
  String get educationalFocusRealWorldSystem => '실제 세계 시스템';

  @override
  String get educationalFocusStructureFormation => '구조 형성';

  @override
  String get educationalObjectivesEditortitle => '교육 목표 편집기 제목';

  @override
  String get educationalObjectivesFutureMessage =>
      '교육 목표는 향후 버전에서 여기에서 구성할 수 있습니다';

  @override
  String get educationalObjectivesListMessage =>
      '이것은 다음을 포함합니다:\n• 학습 목표\n• 성공 기준\n• 가이드 도전\n• 평가 루브릭';

  @override
  String get emergencyNotificationTitle => '중요한 공지';

  @override
  String get enterScenarioNameEditorHint => '시나리오 이름 입력-편집기 힌트';

  @override
  String get equipotentialSurfacesDescription => '동일한 중력 위치 에너지의 표면 표시';

  @override
  String get equipotentialSurfacesLabel => '등전위면';

  @override
  String get exit => '종료';

  @override
  String get exitAppMessage => '정말로 Graviton을 종료하시겠습니까?';

  @override
  String get exitAppTitle => '앱 종료';

  @override
  String get expandedState => '확장됨';

  @override
  String failedToSwitchScenarioError(String error) {
    return '시나리오 전환 실패 오류';
  }

  @override
  String get fieldOfViewLabel => '시야각';

  @override
  String get focusOnNearestTooltip => '가장 가까운 천체에 초점 맞추기';

  @override
  String get followLabel => '추적';

  @override
  String get followObjectTooltip => '선택한 객체 추적';

  @override
  String get getStarted => '시작하기!';

  @override
  String get globalGravityFieldsDescription => '모든 거대한 객체에 대한 중력장 시각화 활성화';

  @override
  String get globalGravityFieldsLabel => '전역 중력장';

  @override
  String get gotItButton => '알겠습니다!';

  @override
  String get gravitationalConstant => '중력 상수';

  @override
  String get greenColor => '초록색';

  @override
  String get habitabilityHabitable => '거주 가능';

  @override
  String get habitabilityIndicatorsDescription =>
      '거주 가능성에 따른 행성 주위의 색상 코드 상태 고리 표시';

  @override
  String get habitabilityIndicatorsLabel => '행성 상태';

  @override
  String get habitabilityLabel => '거주 가능성';

  @override
  String get habitabilityTooCold => '너무 차가움';

  @override
  String get habitabilityTooHot => '너무 뜨거움';

  @override
  String get habitabilityUnknown => '알 수 없음';

  @override
  String get habitableZonesDescription => '거주 가능한 지역을 나타내는 별 주위의 색상 영역 표시';

  @override
  String get habitableZonesLabel => '거주 가능 지역';

  @override
  String get hapticsSection => '햅틱';

  @override
  String get hideUIInScreenshotMode => '내비게이션 숨기기';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      '스크린샷 모드가 활성화될 때 앱 바, 하단 내비게이션, 저작권을 숨김';

  @override
  String get initialMotionVectorsDescription => '초기 운동 벡터 설명';

  @override
  String invalidJsonFormat(String error) {
    return '잘못된 JSON 형식';
  }

  @override
  String get invertPitchControlsDescription => '위/아래 드래그 방향 반전';

  @override
  String get invertPitchControlsLabel => '피치 조작 반전';

  @override
  String get jupiterTanColor => '목성 황갈색';

  @override
  String get keyboardShortcutsHint =>
      '스페이스로 일시정지/재개, R로 재시작, C로 카메라 중앙 맞춤, A로 자동 회전 전환';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => '앱 언어 변경';

  @override
  String get languageSelectionHint => '선호하는 표시 언어를 선택하세요';

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
  String get languageLabel => '일반';

  @override
  String get temperatureUnitsLabel => '온도 단위';

  @override
  String get temperatureUnitsDescription => '앱 전체에서 온도를 표시하는 기본 단위';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => '시스템 기본값';

  @override
  String get lightEnergyOutputDescription => '광 에너지 출력 설명';

  @override
  String get loadingVersion => '버전 로딩 중...';

  @override
  String get luminosityEditorLabel => '광도 편집기 라벨';

  @override
  String get luminosityWEditorhint => '광도를 와트로 입력-편집기 힌트';

  @override
  String get maintenanceTitle => '유지보수';

  @override
  String get manualControlDescription => '완전한 수동 카메라 제어';

  @override
  String get manualControlsTitle => '수동 제어';

  @override
  String get marketingLabel => '마케팅';

  @override
  String get marsRedColor => '화성 빨간색';

  @override
  String get maxTrailPointsInvalid => '최대 궤적 포인트가 무효';

  @override
  String get maximum50BodiesAllowed => '최대 50개의 천체만 허용';

  @override
  String get mercuryGrayColor => '수성 회색';

  @override
  String get missingRequiredFieldBodies => '필수 필드 \'천체\' 누락';

  @override
  String get missingRequiredFieldConfiguration => '필수 필드 \'구성\' 누락';

  @override
  String get missingRequiredFieldMetadata => '필수 필드 \'메타데이터\' 누락';

  @override
  String get missingRequiredFieldParticleSystems => '필수 필드 \'입자 시스템\' 누락';

  @override
  String get missingRequiredFieldPhysics => '필수 필드 \'물리\' 누락';

  @override
  String get missingRequiredFieldVersion => '필수 필드 \'버전\' 누락';

  @override
  String get moreOptionsTooltip => '더 많은 옵션';

  @override
  String get navigationAidsTitle => '탐색 도구';

  @override
  String get neptuneBlueColor => '해왕성 파란색';

  @override
  String get newsTitle => '뉴스';

  @override
  String get nextPreset => '다음 프리셋';

  @override
  String get nextSceneTooltip => '다음 장면 툴팁';

  @override
  String get noActionsAvailable => '사용 가능한 작업 없음';

  @override
  String get noBodiesInSimulation => '현재 시뮬레이션에 천체가 없습니다';

  @override
  String get noChangelogsAvailable => '사용 가능한 변경 로그가 없습니다';

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
  String get objectivesDescription =>
      '• 중력이 우주를 어떻게 형성하는지 이해\n• 안정적 vs 혼돈적 궤도 시스템 관찰\n• 행성이 왜 타원 궤도로 움직이는지 학습\n• 쌍성이 어떻게 상호작용하는지 발견\n• 객체가 충돌할 때 무슨 일이 일어나는지 관찰\n• 삼체 문제의 복잡성 이해';

  @override
  String get objectivesTitle => '학습 목표';

  @override
  String get offScreenIndicatorsDescription => '보이는 영역 밖의 객체를 가리키는 화살표 표시';

  @override
  String get offScreenIndicatorsTitle => '화면 밖 표시기';

  @override
  String get orangeColor => '주황색';

  @override
  String get particleSystemsEditortitle => '입자 시스템 편집기 제목';

  @override
  String get pathVisualizationTitle => '궤도 시각화';

  @override
  String get physicalPropertiesDescription => '물리적 속성 설명';

  @override
  String get pinchToZoomInOut => '핀치하여 확대/축소';

  @override
  String get pitchLabel => '피치';

  @override
  String get positionEditorLabel => '위치 편집기 라벨';

  @override
  String get predictiveOrbitalDescription => 'AI가 최적의 궤도 뷰를 예측';

  @override
  String get previousPreset => '이전 프리셋';

  @override
  String get previousSceneTooltip => '이전 장면 툴팁';

  @override
  String get privacyPolicyLabel => '개인정보 보호정책';

  @override
  String get promotionTitle => '프로모션';

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
  String get quickStartDescription =>
      '1. 시나리오 선택 (초보자에게는 태양계 추천)\n2. 재생을 눌러 시뮬레이션 시작\n3. 드래그하여 뷰 회전, 핀치하여 줌\n4. 속도 슬라이더를 터치하여 시간 제어\n5. 새로운 랜덤 구성을 위해 리셋 시도\n6. 궤도 경로를 보려면 궤적 활성화';

  @override
  String get quickStartTitle => '빠른 시작 가이드';

  @override
  String get quickTutorialButton => '빠른 튜토리얼';

  @override
  String get radiusMEditorhint => '반지름을 미터로 입력-편집기 힌트';

  @override
  String get realisticColors => '현실적인 색상';

  @override
  String get realisticColorsDescription => '온도와 항성 분류에 기반한 과학적으로 정확한 색상 사용';

  @override
  String get redColor => '빨간색';

  @override
  String get rollLabel => '롤';

  @override
  String get saturnCreamColor => '토성 크림색';

  @override
  String get scenarioAsteroidBelt => '소행성대';

  @override
  String get scenarioAsteroidBeltDescription => '암석 소행성과 파편 띠로 둘러싸인 중심별';

  @override
  String get scenarioBestBinary => '최적 대상: 고급 물리학 탐구';

  @override
  String get scenarioBestEarthMoon => '최적 대상: 지구-달 시스템 이해';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom => '최적 대상: 탐색과 실험';

  @override
  String get scenarioBestSolar => '최적 대상: 초보자, 천문학 애호가';

  @override
  String get scenarioBestThreeBody => '최적 대상: 수리물리학 애호가';

  @override
  String get scenarioBinaryStars => '이중성';

  @override
  String get scenarioBinaryStarsDescription =>
      '서로 궤도를 도는 두 개의 거대한 별과 주변 이중성 행성';

  @override
  String get scenarioCustom => '사용자 정의 시나리오';

  @override
  String get scenarioCustomDescription => '사용자 정의 시나리오 설명';

  @override
  String get scenarioEarthMoonSun => '지구-달-태양';

  @override
  String get scenarioEarthMoonSunDescription => '친숙한 지구-달-태양 시스템의 교육적 시뮬레이션';

  @override
  String get scenarioGalaxyFormation => '은하 형성';

  @override
  String get scenarioGalaxyFormationDescription =>
      '중심 블랙홀 주위로 물질이 나선 구조로 조직화되는 것을 관찰';

  @override
  String get scenarioInformationEditortitle => '시나리오 정보 편집기 제목';

  @override
  String get scenarioLearnBinary => '학습 내용: 항성 진화, 쌍성계, 극한 중력';

  @override
  String get scenarioLearnEarthMoon => '학습 내용: 삼체 역학, 달의 역학, 조석력';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom => '학습 내용: 알려지지 않은 구성 발견, 실험 물리학';

  @override
  String get scenarioLearnSolar => '학습 내용: 행성 운동, 궤도 역학, 친숙한 천체';

  @override
  String get scenarioLearnThreeBody => '학습 내용: 카오스 이론, 예측 불가능한 운동, 불안정 시스템';

  @override
  String get scenarioNameRequired => '시나리오 이름이 필요합니다';

  @override
  String get scenarioNameTooLong => '시나리오 이름이 너무 깁니다';

  @override
  String get scenarioPlanetaryRings => '행성 고리';

  @override
  String get scenarioPlanetaryRingsDescription => '토성 같은 거대한 행성 주위의 고리 시스템 역학';

  @override
  String get scenarioRandom => '무작위 시스템';

  @override
  String get scenarioRandomDescription => '예측 불가능한 역학을 가진 무작위로 생성된 혼돈 삼체 시스템';

  @override
  String scenarioSaveFailedMessage(String error) {
    return '시나리오 저장 실패';
  }

  @override
  String get scenarioSavedSuccessMessage => '시나리오 저장 성공';

  @override
  String get scenarioSelectorFocused => '시나리오 선택기에 포커스';

  @override
  String get scenarioSolarSystem => '태양계';

  @override
  String get scenarioSolarSystemDescription => '내행성과 외행성을 포함한 우리 태양계의 간소화된 버전';

  @override
  String get scenarioSpecial => '특별 시나리오';

  @override
  String get scenarioSpecialDescription => '스크린샷 모드용 특별 시나리오';

  @override
  String get scenariosAvailable => '사용 가능한 시나리오';

  @override
  String get scenariosMenuDescription => '다양한 시나리오 탐색';

  @override
  String get sceneActive => '장면 활성화 - 스크린샷 촬영을 위해 시뮬레이션 일시정지';

  @override
  String get scenePreset => '장면 프리셋';

  @override
  String get scheduledMaintenanceInProgress => '예정된 유지보수 진행 중';

  @override
  String screenshotCountdown(int seconds) {
    return '스크린샷 $seconds초 후';
  }

  @override
  String get screenshotMode => '스크린샷 모드';

  @override
  String get screenshotModeSubtitle => '마케팅 스크린샷 촬영을 위한 프리셋 장면 활성화';

  @override
  String get selectAColorForTheCelestialBody => '천체의 색상을 선택하세요';

  @override
  String get selectNearestTitle => '가장 가까운 선택';

  @override
  String get selectObjectToFollowTooltip => '추적할 객체 선택';

  @override
  String get selectScenarioTooltip => '시나리오 선택';

  @override
  String get selectTheTypeOfCelestialBody => '천체의 유형을 선택하세요';

  @override
  String get selectedStatLabel => '선택됨';

  @override
  String get showHelpTooltip => '도움말 및 목표';

  @override
  String get showLabelsDescription => '시뮬레이션에서 천체 이름 표시';

  @override
  String get showLabelsTitle => '라벨 표시';

  @override
  String get showOrbitalPaths => '궤도 경로 표시';

  @override
  String get showOrbitalPathsDescription => '안정된 궤도를 가진 시나리오에서 예측된 궤도 경로 표시';

  @override
  String get showStatisticsDescription => '성능 및 물리 통계 표시';

  @override
  String get showStatisticsTitle => '통계 표시';

  @override
  String get showTrails => '궤적 표시';

  @override
  String get showTrailsDescription => '객체 뒤에 움직임의 궤적 표시';

  @override
  String get showTutorialTooltip => '튜토리얼 표시';

  @override
  String get skipTutorial => '건너뛰기';

  @override
  String get softeningParameter => '소프트닝 매개변수';

  @override
  String get spatialCoordinatesDescription => '공간 좌표 설명';

  @override
  String get statusError => '오류';

  @override
  String get statusLabel => '상태';

  @override
  String get statusPaused => '일시정지됨';

  @override
  String get statusRunning => '실행 중';

  @override
  String get statusStopped => '정지됨';

  @override
  String get stellarColorBlue => '파랑';

  @override
  String get stellarColorBlueWhite => '청백색';

  @override
  String get stellarColorOrange => '주황';

  @override
  String get stellarColorRed => '빨강';

  @override
  String get stellarColorWhite => '흰색';

  @override
  String get stellarColorYellow => '노랑';

  @override
  String get stellarColorYellowWhite => '황백색';

  @override
  String get stellarTemperatureDescription => '항성 온도 설명';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => '단계';

  @override
  String get successTitle => '성공';

  @override
  String get swipeUpToExpand => '위로 스와이프하여 확장';

  @override
  String get tapPlayPauseButton => '재생/일시정지 버튼 탭';

  @override
  String get tapResetButton => '리셋 버튼 탭';

  @override
  String get tapToCenterCamera => '탭하여 카메라 중앙으로';

  @override
  String get tapToChangeScenario => '탭하여 시나리오 변경';

  @override
  String get tapToInteractWithSimulation => '탭하여 시뮬레이션과 상호작용';

  @override
  String get tapToOpenSettings => '탭하여 설정 열기';

  @override
  String get tapToSelect => '탭하여 선택';

  @override
  String get tapToToggleAutoRotation => '탭하여 자동 회전 토글';

  @override
  String get tapToToggleFullscreen => '탭하여 전체화면 전환';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return '탭하여 세부 정보 보기 및 편집-천체-천체 유형-번호가 있는 이름-유틸-형식-질량-천체 질량-편집기 힌트';
  }

  @override
  String get trackingModeEssential => '필수만';

  @override
  String get trackingModeEssentialDescription => '중요한 충돌 및 오류만';

  @override
  String get trackingModeFull => '전체 추적';

  @override
  String get trackingModeFullDescription => '모든 분석, 충돌 및 상호작용';

  @override
  String get trackingModeLimited => '제한된 추적';

  @override
  String get trackingModeLimitedDescription => '사용자 상호작용만';

  @override
  String get trackingModeNone => '추적 없음';

  @override
  String get trackingModeNoneDescription => '데이터 수집 없음';

  @override
  String get trailColorLabel => '궤적 색상';

  @override
  String get trailFadeRate => '궤적 페이드 비율';

  @override
  String get trailLength => '궤적 길이';

  @override
  String get typeEditorLabel => '유형 편집기 라벨';

  @override
  String get uiHapticFeedback => 'UI 햅틱 피드백';

  @override
  String get unsavedChangesMessage => '저장되지 않은 변경 사항 메시지';

  @override
  String get unsavedChangesTitle => '저장되지 않은 변경 사항';

  @override
  String get uranusCyanColor => '천왕성 청록색';

  @override
  String get useKeyboardShortcutsForControls => '컨트롤에 키보드 단축키 사용';

  @override
  String get useZoomControls => '줌 컨트롤 사용';

  @override
  String get venusYellowColor => '금성 노란색';

  @override
  String get versionLabel => '버전';

  @override
  String get versionStatusCurrent => '최신';

  @override
  String get versionStatusOutdated => '구버전';

  @override
  String get vibrationEnabled => '진동 활성화';

  @override
  String get vibrationThrottle => '진동 제한';

  @override
  String get warmTrails => '🔥 따뜻한';

  @override
  String get websiteLabel => '웹사이트';

  @override
  String get whatToDoDescription =>
      'Graviton은 물리학 놀이터입니다:\n\n🪐 현실적인 궤도 역학 탐구\n🌟 항성 진화와 충돌 관찰\n🎯 중력에 대해 학습\n🎮 다양한 시나리오로 실험\n📚 천체 역학 이해\n🔄 무한한 랜덤 구성 생성';

  @override
  String get whatToDoTitle => 'Graviton에서 할 수 있는 것';

  @override
  String get whiteColor => '흰색';

  @override
  String get xCoordinateEditorhint => 'X 좌표 입력-편집기 힌트';

  @override
  String get xCoordinateLabel => 'X 좌표 라벨';

  @override
  String get xVelocityEditorhint => 'X 속도 입력-편집기 힌트';

  @override
  String get yCoordinateEditorhint => 'Y 좌표 입력-편집기 힌트';

  @override
  String get yCoordinateLabel => 'Y 좌표 라벨';

  @override
  String get yVelocityEditorhint => 'Y 속도 입력-편집기 힌트';

  @override
  String get yawLabel => '요';

  @override
  String get yellowColor => '노란색';

  @override
  String get zCoordinateEditorhint => 'Z 좌표 입력-편집기 힌트';

  @override
  String get zCoordinateLabel => 'Z 좌표 라벨';

  @override
  String get zVelocityEditorhint => 'Z 속도 입력-편집기 힌트';

  @override
  String orbitalEventCloseApproach(String distance) {
    return '근접 접근: $distance 단위';
  }

  @override
  String get accessibilityBodiesCombined => '결합된 질량이 새로운 천체를 만듭니다';

  @override
  String get accessibilityBodiesInMotion => '천체들이 현재 움직이고 있습니다';

  @override
  String get accessibilityBodiesStopped => '모든 천체가 움직임을 멈췄습니다';

  @override
  String get accessibilityBodiesResumed => '천체들이 다시 움직이고 있습니다';

  @override
  String get accessibilityBodiesReset => '모든 천체가 재설정되었습니다';

  @override
  String get accessibilityNewScenarioLoaded => '새로운 천체로 새 시나리오가 로드되었습니다';

  @override
  String get accessibilityNewParametersLoaded => '새로운 천체와 물리 매개변수가 로드되었습니다';

  @override
  String get scenarioTabPresets => '프리셋';

  @override
  String get scenarioTabCustom => '커스텀';

  @override
  String get savedScenariosTitle => '저장된 시나리오';

  @override
  String get experimentsTitle => '실험';

  @override
  String get experimentsSubtitle => '흥미로운 물리학 개념 탐구';

  @override
  String customScenarioBodyCount(int count) {
    return '천체 $count개';
  }

  @override
  String get customScenarioCreatedToday => '오늘 생성';

  @override
  String get customScenarioCreatedYesterday => '어제 생성';

  @override
  String customScenarioCreatedDaysAgo(int count, Object days) {
    return '$days일 전 생성';
  }

  @override
  String customScenarioCreatedWeeksAgo(int count, Object weeks) {
    return '$weeks주 전 생성';
  }

  @override
  String customScenarioCreatedMonthsAgo(int count, Object months) {
    return '$months개월 전 생성';
  }

  @override
  String get customScenarioCreatedUnknown => '생성일 알 수 없음';

  @override
  String get orbitalPlacementEditor => '궤도 배치';

  @override
  String get placeInOrbitButton => '궤도에 배치';

  @override
  String get centralBodySelector => '중심 천체';

  @override
  String get orbitRadiusEditor => '궤도 반지름';

  @override
  String get orbitPhaseEditor => '궤도 위상';

  @override
  String get orbitInclinationEditor => '기울기';

  @override
  String get circularOrbitOption => '원형 궤도';

  @override
  String get ellipticalOrbitOption => '타원형 궤도';

  @override
  String orbitalPeriodDisplay(String period) {
    return '주기: $period';
  }

  @override
  String get noAvailableCentralBodies => '궤도 배치에 사용할 수 있는 다른 천체가 없습니다';

  @override
  String get orbitalPlacementDescription =>
      '이 천체가 현실적인 물리학으로 다른 천체 주위를 공전하도록 구성';

  @override
  String get orbitalPlacementActiveDescription =>
      '궤도 배치가 활성화되었습니다. 위치와 속도는 아래의 궤도 매개변수에 따라 자동으로 계산됩니다.';

  @override
  String get showGravitationalFieldVisualization => '이 천체의 중력장 시각화 표시';

  @override
  String get cancelOrbitalPlacement => '궤도 배치 취소';

  @override
  String get makeStable => '안정화';

  @override
  String get orbitalWarningMassiveBody =>
      '⚠️ 경고: 공전하는 천체가 중심 천체에 비해 매우 무겁습니다. 이는 불안정한 궤도를 유발하거나 천체들이 서로 공전할 수 있습니다.';

  @override
  String get orbitalTipSignificantMass =>
      '💡 팁: 이는 상당한 질량비입니다. 안정성을 위해 궤도 거리 증가를 고려하세요.';

  @override
  String get orbitalWarningCloseOrbit =>
      '⚠️ 경고: 매우 가까운 궤도. 충돌이나 조석 파괴의 위험이 있습니다.';

  @override
  String get orbitalTipDistantOrbit =>
      '💡 팁: 먼 궤도. 다른 천체의 중력 영향이 이 궤도를 교란할 수 있습니다.';

  @override
  String get orbitalGoodConfiguration => '✅ 안정적인 시스템을 위한 좋은 궤도 구성.';

  @override
  String get orbitalError => '오류';

  @override
  String get orbitalConfigurationWarning =>
      '이 궤도 구성은 충돌이나 방출로 이어질 수 있습니다. \"안정화\" 버튼 사용을 고려하세요.';

  @override
  String get defaultBodyName => '천체';

  @override
  String get orbitalPeriodLabel => '궤도 주기';

  @override
  String get orbitIsStable => '궤도가 안정적';

  @override
  String get orbitMayBeUnstable => '궤도가 불안정할 수 있음';

  @override
  String bodyTypeGeneric(String bodyType) {
    return '$bodyType 천체';
  }

  @override
  String orbitalRadiusIncreasedFeedback(String amount) {
    return '$amount 단위 증가';
  }

  @override
  String orbitalRadiusDecreasedFeedback(String amount) {
    return '$amount 단위 감소';
  }

  @override
  String get orbitalRadiusFineTunedFeedback => '미세 조정';

  @override
  String orbitStabilizedMessage(String changeDescription, String finalRadius) {
    return '궤도가 안정화되었습니다! 반지름이 $changeDescription하여 $finalRadius 단위가 되었습니다. 안정성을 위해 위상과 기울기가 재설정되었습니다.';
  }

  @override
  String get experimentBinaryPulsarName => '쌍성 펄사';

  @override
  String get experimentBinaryPulsarDescription =>
      '중력파로 인해 내부로 나선운동하는 두 개의 중성자별';

  @override
  String get experimentBinaryPulsarDuration => '100년';

  @override
  String get experimentTrojanAsteroidsName => '트로이군 소행성';

  @override
  String get experimentTrojanAsteroidsDescription => '소행성이 축적되는 목성 궤도의 안정점';

  @override
  String get experimentTrojanAsteroidsDuration => '50년';

  @override
  String get experimentGalacticDanceName => '은하의 춤';

  @override
  String get experimentGalacticDanceDescription => '우주 시간에 걸쳐 충돌하고 합쳐지는 두 은하';

  @override
  String get experimentGalacticDanceDuration => '10억 년';

  @override
  String get experimentRingFormationName => '고리 형성';

  @override
  String get experimentRingFormationDescription => '파괴된 위성으로부터 행성 고리가 형성되는 과정';

  @override
  String get experimentRingFormationDuration => '1000년';

  @override
  String get experimentCometTrajectoryName => '혜성 궤도';

  @override
  String get experimentCometTrajectoryDescription => '보존 법칙을 보여주는 고도 타원 궤도';

  @override
  String get experimentCometTrajectoryDuration => '200년';

  @override
  String get experimentStellarNurseryName => '별 탄생 지역';

  @override
  String get experimentStellarNurseryDescription => '붕괴하는 가스 구름으로부터의 별 형성';

  @override
  String get experimentStellarNurseryDuration => '1000만 년';

  @override
  String get experimentDifficultyAdvanced => '고급';

  @override
  String get experimentDifficultyIntermediate => '중급';

  @override
  String get experimentDifficultyBeginner => '초급';

  @override
  String experimentComingSoon(String scenarioName) {
    return '실험적 시나리오 \"$scenarioName\" - 곧 출시 예정!';
  }

  @override
  String get unknownValue => '알 수 없음';
}
