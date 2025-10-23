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
  String get speedLabel => '속도';

  @override
  String get trailsLabel => '궤적';

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
  String get settingsTitle => '설정';

  @override
  String get settingsTooltip => '설정';

  @override
  String get selectScenarioTooltip => '시나리오 선택';

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
  String get cameraControlsLabel => '카메라 조작';

  @override
  String get invertPitchControlsLabel => '피치 조작 반전';

  @override
  String get invertPitchControlsDescription => '위/아래 드래그 방향 반전';

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
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => '버전';

  @override
  String get loadingVersion => '버전 로딩 중...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => '중력장';

  @override
  String get gravityWellsDescription => '객체 주변의 중력장 강도 표시';

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
  String bodyStar(int number) {
    return '별 $number';
  }

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
  String get scenarioObjectivesSolar =>
      '🎯 학습 내용: 행성 운동, 궤도 역학, 친숙한 천체\n⭐ 최적 대상: 초보자, 천문학 애호가';

  @override
  String get scenarioObjectivesEarthMoon =>
      '🎯 학습 내용: 삼체 역학, 달의 역학, 조석력\n⭐ 최적 대상: 지구-달 시스템 이해';

  @override
  String get scenarioObjectivesBinary =>
      '🎯 학습 내용: 항성 진화, 쌍성계, 극한 중력\n⭐ 최적 대상: 고급 물리학 탐구';

  @override
  String get scenarioObjectivesThreeBody =>
      '🎯 학습 내용: 카오스 이론, 예측 불가능한 운동, 불안정 시스템\n⭐ 최적 대상: 수리물리학 애호가';

  @override
  String get scenarioObjectivesRandom =>
      '🎯 학습 내용: 알려지지 않은 구성 발견, 실험 물리학\n⭐ 최적 대상: 탐색과 실험';

  @override
  String get privacyPolicyLabel => '개인정보 보호정책';

  @override
  String get tutorialWelcomeTitle => 'Graviton에 오신 것을 환영합니다!';

  @override
  String get tutorialWelcomeDescription =>
      '중력 물리학의 매혹적인 세계로의 창문인 Graviton에 오신 것을 환영합니다! 이 앱을 통해 천체들이 중력을 통해 어떻게 상호작용하며 공간과 시간을 통해 아름다운 궤도 춤을 만들어내는지 탐구할 수 있습니다.';

  @override
  String get tutorialObjectivesTitle => '무엇을 할 수 있나요?';

  @override
  String get tutorialObjectivesDescription =>
      '• 현실적인 궤도 역학 관찰\n• 다양한 천문학적 시나리오 탐구\n• 중력 상호작용 실험\n• 충돌과 합병 관찰\n• 행성 운동에 대해 학습\n• 혼돈스러운 삼체 역학 발견';

  @override
  String get tutorialControlsTitle => '기본 조작';

  @override
  String get tutorialControlsDescription =>
      '상단 컨트롤을 사용하여 시뮬레이션 재생/일시정지, 새로운 시나리오를 위한 리셋, 시뮬레이션 속도 조정을 하세요. 설정 버튼을 통해 궤적과 기타 시각적 옵션을 사용자 정의할 수 있습니다.';

  @override
  String get tutorialCameraTitle => '카메라 조작';

  @override
  String get tutorialCameraDescription =>
      '드래그하여 뷰 회전, 핀치하여 줌, 두 손가락으로 카메라 롤을 조작하세요. 하단 컨트롤은 객체에 초점을 맞추고, 뷰를 중앙에 배치하며, 영화적 경험을 위한 자동 회전을 활성화하는 데 도움이 됩니다.';

  @override
  String get tutorialScenariosTitle => '모험을 선택하세요';

  @override
  String get tutorialScenariosDescription =>
      '과학 버튼을 눌러 다양한 시나리오를 탐구하세요: 우리의 태양계, 지구-달 역학, 쌍성, 또는 고전적인 혼돈의 삼체 문제. 각각은 발견할 독특한 물리학을 제공합니다!';

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
  String get objectivesDescription =>
      '• 중력이 우주를 어떻게 형성하는지 이해\n• 안정적 vs 혼돈적 궤도 시스템 관찰\n• 행성이 왜 타원 궤도로 움직이는지 학습\n• 쌍성이 어떻게 상호작용하는지 발견\n• 객체가 충돌할 때 무슨 일이 일어나는지 관찰\n• 삼체 문제의 복잡성 이해';

  @override
  String get quickStartTitle => '빠른 시작 가이드';

  @override
  String get quickStartDescription =>
      '1. 시나리오 선택 (초보자에게는 태양계 추천)\n2. 재생을 눌러 시뮬레이션 시작\n3. 드래그하여 뷰 회전, 핀치하여 줌\n4. 속도 슬라이더를 터치하여 시간 제어\n5. 새로운 랜덤 구성을 위해 리셋 시도\n6. 궤도 경로를 보려면 궤적 활성화';

  @override
  String get showHelpTooltip => '도움말 및 목표';
}
