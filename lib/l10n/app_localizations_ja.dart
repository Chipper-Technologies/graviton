// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Graviton';

  @override
  String get playButton => '再生';

  @override
  String get pauseButton => '一時停止';

  @override
  String get resetButton => 'リセット';

  @override
  String get speedLabel => '速度';

  @override
  String get trailsLabel => '軌跡';

  @override
  String get statsLabel => '統計';

  @override
  String get selectLabel => '選択';

  @override
  String get followLabel => '追従';

  @override
  String get centerLabel => '中央';

  @override
  String get rotateLabel => '回転';

  @override
  String get warmTrails => '🔥 暖色';

  @override
  String get coolTrails => '❄️ 寒色';

  @override
  String get toggleStatsTooltip => '統計の切り替え';

  @override
  String get toggleLabelsTooltip => '天体ラベルの切り替え';

  @override
  String get showLabelsDescription => 'シミュレーションで天体名を表示';

  @override
  String get offScreenIndicatorsTitle => '画面外インジケーター';

  @override
  String get offScreenIndicatorsDescription => '可視領域外のオブジェクトを指す矢印を表示';

  @override
  String get autoRotateTooltip => '自動回転';

  @override
  String get centerViewTooltip => 'ビューを中央に';

  @override
  String get focusOnNearestTooltip => '最寄りの天体にフォーカス';

  @override
  String get followObjectTooltip => '選択したオブジェクトを追跡';

  @override
  String get stopFollowingTooltip => 'オブジェクトの追跡を停止';

  @override
  String get selectObjectToFollowTooltip => '追跡するオブジェクトを選択';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsTooltip => '設定';

  @override
  String get selectScenarioTooltip => 'シナリオを選択';

  @override
  String get moreOptionsTooltip => 'その他のオプション';

  @override
  String get physicsSettingsTitle => '物理設定';

  @override
  String get physicsSettingsDescription => 'シミュレーションパラメータ';

  @override
  String get physicsSection => '物理学';

  @override
  String get gravitationalConstant => '重力定数';

  @override
  String get softeningParameter => 'ソフト化パラメータ';

  @override
  String get simulationSpeed => 'シミュレーション速度';

  @override
  String get collisionsSection => '衝突';

  @override
  String get collisionSensitivity => '衝突感度';

  @override
  String get trailsSection => '軌跡';

  @override
  String get trailLength => '軌跡の長さ';

  @override
  String get trailFadeRate => '軌跡のフェード率';

  @override
  String get hapticsSection => 'ハプティクス';

  @override
  String get vibrationEnabled => '振動有効';

  @override
  String get hapticFeedbackCollisions => '衝突時のハプティックフィードバック';

  @override
  String get vibrationThrottle => '振動スロットル';

  @override
  String get scenariosMenuDescription => 'さまざまなシナリオを探索';

  @override
  String get settingsMenuDescription => '視覚的および動作オプション';

  @override
  String get helpMenuDescription => 'チュートリアルと目標';

  @override
  String get showTrails => '軌跡を表示';

  @override
  String get showTrailsDescription => 'オブジェクトの後ろに動きの軌跡を表示';

  @override
  String get showOrbitalPaths => '軌道パスを表示';

  @override
  String get showOrbitalPathsDescription => '安定した軌道を持つシナリオで予測された軌道パスを表示';

  @override
  String get dualOrbitalPaths => '二重軌道パス';

  @override
  String get dualOrbitalPathsDescription => '理想的な円軌道と実際の楕円軌道の両方を表示';

  @override
  String get trailColorLabel => '軌跡の色';

  @override
  String get colorsLabel => '色';

  @override
  String get realisticColors => 'リアルな色';

  @override
  String get realisticColorsDescription => '温度と恒星分類に基づく科学的に正確な色を使用';

  @override
  String get closeButton => '閉じる';

  @override
  String get simulationStats => 'シミュレーション統計';

  @override
  String get stepsLabel => 'ステップ';

  @override
  String get timeLabel => '時間';

  @override
  String get earthYearsLabel => '地球年';

  @override
  String get speedStatsLabel => '速度';

  @override
  String get bodiesLabel => '天体';

  @override
  String get statusLabel => '状態';

  @override
  String get statusRunning => '実行中';

  @override
  String get statusPaused => '一時停止中';

  @override
  String get cameraLabel => 'カメラ';

  @override
  String get distanceLabel => '距離';

  @override
  String get autoRotateLabel => '自動回転';

  @override
  String get autoRotateOn => 'オン';

  @override
  String get autoRotateOff => 'オフ';

  @override
  String get cameraControlsLabel => 'カメラ操作';

  @override
  String get invertPitchControlsLabel => 'ピッチ操作を反転';

  @override
  String get invertPitchControlsDescription => '上下ドラッグ方向を反転';

  @override
  String get cinematicCameraTechniqueLabel => 'AIカメラ技術';

  @override
  String get cinematicCameraTechniqueDescription => 'オブジェクトを追跡する際のAIカメラ制御方法を選択';

  @override
  String get cinematicTechniqueManual => '手動制御';

  @override
  String get cinematicTechniqueManualDesc => 'フォローモード付きの従来の手動カメラ制御';

  @override
  String get cinematicTechniquePredictiveOrbital => '予測軌道';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc => '教育シナリオ用のAIツアーと軌道予測';

  @override
  String get cinematicTechniqueDynamicFraming => 'ダイナミックフレーミング';

  @override
  String get cinematicTechniqueDynamicFramingDesc => 'カオスシナリオ用のリアルタイム劇的ターゲティング';

  @override
  String get marketingLabel => 'マーケティング';

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
  String get scenarioSelectionTitle => 'シナリオを選択';

  @override
  String get cancel => 'キャンセル';

  @override
  String get bodies => '天体';

  @override
  String get scenarioRandom => 'ランダムシステム';

  @override
  String get scenarioRandomDescription => '予測不可能な動力学を持つランダムに生成された混沌とした三体系';

  @override
  String get scenarioEarthMoonSun => '地球-月-太陽';

  @override
  String get scenarioEarthMoonSunDescription => '馴染み深い地球-月-太陽系の教育的シミュレーション';

  @override
  String get scenarioBinaryStars => '連星';

  @override
  String get scenarioBinaryStarsDescription => '互いに軌道を描く二つの大質量星と周連星惑星';

  @override
  String get scenarioAsteroidBelt => '小惑星帯';

  @override
  String get scenarioAsteroidBeltDescription => '岩石の小惑星と破片の帯に囲まれた中央星';

  @override
  String get scenarioGalaxyFormation => '銀河形成';

  @override
  String get scenarioGalaxyFormationDescription =>
      '中央のブラックホール周りに物質が螺旋構造に組織化される様子を観察';

  @override
  String get scenarioPlanetaryRings => '惑星の環';

  @override
  String get scenarioPlanetaryRingsDescription => '土星のような大質量惑星周りの環系の動力学';

  @override
  String get scenarioSolarSystem => '太陽系';

  @override
  String get scenarioSolarSystemDescription => '内惑星と外惑星を含む太陽系の簡略版';

  @override
  String get habitabilityLabel => '居住可能性';

  @override
  String get habitableZonesLabel => 'ハビタブルゾーン';

  @override
  String get habitabilityIndicatorsLabel => '惑星の状態';

  @override
  String get habitabilityHabitable => '居住可能';

  @override
  String get habitabilityTooHot => '高温すぎ';

  @override
  String get habitabilityTooCold => '低温すぎ';

  @override
  String get habitabilityUnknown => '不明';

  @override
  String get temperatureFrozen => '凍結';

  @override
  String get temperatureCold => '寒冷';

  @override
  String get temperatureModerate => '温和';

  @override
  String get temperatureHot => '高温';

  @override
  String get temperatureScorching => '灼熱';

  @override
  String get temperatureNotApplicable => '該当なし';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get toggleHabitableZonesTooltip => 'ハビタブルゾーンの切り替え';

  @override
  String get toggleHabitabilityIndicatorsTooltip => '惑星居住可能性状態の切り替え';

  @override
  String get habitableZonesDescription => '居住可能な領域を示す星の周りの色付きゾーンを表示';

  @override
  String get habitabilityIndicatorsDescription =>
      '居住可能性に基づく惑星周りの色分けされた状態リングを表示';

  @override
  String get aboutDialogTitle => 'について';

  @override
  String get appDescription =>
      '重力動力学と軌道力学を探求する物理シミュレーション。インタラクティブな3D可視化を通じて天体運動の美しさと複雑さを体験してください。';

  @override
  String get authorLabel => '作者';

  @override
  String get websiteLabel => 'ウェブサイト';

  @override
  String get aboutButtonTooltip => 'について';

  @override
  String get appNameGraviton => 'Graviton';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get loadingVersion => 'バージョンを読み込み中...';

  @override
  String get companyName => 'Chipper Technologies, LLC';

  @override
  String get gravityWellsLabel => '重力井戸';

  @override
  String get gravityWellsDescription => 'オブジェクト周辺の重力場の強度を表示';

  @override
  String get languageLabel => '言語';

  @override
  String get languageDescription => 'アプリの言語を変更';

  @override
  String get languageSystem => 'システムデフォルト';

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
  String get bodyAlpha => 'アルファ';

  @override
  String get bodyBeta => 'ベータ';

  @override
  String get bodyGamma => 'ガンマ';

  @override
  String get bodyRockyPlanet => '岩石惑星';

  @override
  String get bodyEarthLike => '地球型惑星';

  @override
  String get bodySuperEarth => 'スーパーアース';

  @override
  String get bodySun => '太陽';

  @override
  String get bodyPropertiesTitle => '天体のプロパティ';

  @override
  String get bodyPropertiesName => '名前';

  @override
  String get bodyPropertiesNameHint => '天体名を入力';

  @override
  String get bodyPropertiesType => '天体タイプ';

  @override
  String get bodyPropertiesColor => '色';

  @override
  String get bodyPropertiesMass => '質量';

  @override
  String get bodyPropertiesRadius => '半径';

  @override
  String get bodyPropertiesLuminosity => '恒星光度';

  @override
  String get bodyPropertiesVelocity => '速度';

  @override
  String get bodyPropertiesAxisX => 'X:';

  @override
  String get bodyPropertiesAxisY => 'Y:';

  @override
  String get bodyPropertiesAxisZ => 'Z:';

  @override
  String get bodyEarth => '地球';

  @override
  String get bodyMoon => '月';

  @override
  String get bodyStarA => '恒星A';

  @override
  String get bodyStarB => '恒星B';

  @override
  String get bodyPlanetP => '惑星P';

  @override
  String get bodyMoonM => '衛星M';

  @override
  String get bodyCentralStar => '中心星';

  @override
  String bodyAsteroid(int number) {
    return '小惑星 $number';
  }

  @override
  String get bodyBlackHole => 'ブラックホール';

  @override
  String get bodyRingedPlanet => '環状惑星';

  @override
  String bodyRing(int number) {
    return 'リング $number';
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
  String get bodyInnerPlanet => '内惑星';

  @override
  String get bodyOuterPlanet => '外惑星';

  @override
  String get bodyCenterOfMass => '質量中心';

  @override
  String bodyStarNumber(int number) {
    return '恒星 $number';
  }

  @override
  String get educationalFocusChaoticDynamics => 'カオス力学';

  @override
  String get educationalFocusRealWorldSystem => '実世界システム';

  @override
  String get educationalFocusBinaryOrbits => '連星軌道';

  @override
  String get educationalFocusManyBodyDynamics => '多体力学';

  @override
  String get educationalFocusStructureFormation => '構造形成';

  @override
  String get educationalFocusPlanetaryMotion => '惑星運動';

  @override
  String get updateRequiredTitle => '更新が必要';

  @override
  String get updateRequiredMessage =>
      'このアプリの新しいバージョンが利用可能です。最新の機能と改善を引き続きご利用いただくために、アップデートしてください。';

  @override
  String get updateRequiredWarning => 'このバージョンはサポートされなくなりました。';

  @override
  String get updateNow => '今すぐ更新';

  @override
  String get updateLater => '後で';

  @override
  String get versionStatusCurrent => '最新';

  @override
  String get versionStatusBeta => 'ベータ';

  @override
  String get versionStatusOutdated => '古いバージョン';

  @override
  String get maintenanceTitle => 'メンテナンス';

  @override
  String get newsTitle => 'ニュース';

  @override
  String get emergencyNotificationTitle => '重要なお知らせ';

  @override
  String get ok => 'OK';

  @override
  String get screenshotMode => 'スクリーンショットモード';

  @override
  String get screenshotModeSubtitle => 'マーケティング用スクリーンショット撮影のプリセットシーンを有効化';

  @override
  String get hideUIInScreenshotMode => 'ナビゲーションを非表示';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'スクリーンショットモードがアクティブな時にアプリバー、ボトムナビゲーション、コピーライトを非表示にする';

  @override
  String get scenePreset => 'シーンプリセット';

  @override
  String get previousPreset => '前のプリセット';

  @override
  String get nextPreset => '次のプリセット';

  @override
  String get applyScene => 'シーンを適用';

  @override
  String appliedPreset(String presetName) {
    return 'プリセットが適用されました: $presetName';
  }

  @override
  String get deactivate => '無効化';

  @override
  String get sceneActive => 'シーンがアクティブ - スクリーンショット撮影のため一時停止中';

  @override
  String get presetGalaxyFormationOverview => '銀河形成概観';

  @override
  String get presetGalaxyFormationOverviewDesc => '宇宙背景を持つ螺旋銀河形成の広角ビュー';

  @override
  String get presetGalaxyCoreDetail => '銀河中心核詳細';

  @override
  String get presetGalaxyCoreDetailDesc => '降着円盤を持つ明るい銀河中心のクローズアップ';

  @override
  String get presetGalaxyBlackHole => '銀河ブラックホール';

  @override
  String get presetGalaxyBlackHoleDesc => '銀河中心の超大質量ブラックホールのクローズアップビュー';

  @override
  String get presetCompleteSolarSystem => '完全太陽系';

  @override
  String get presetCompleteSolarSystemDesc => '美しい軌道軌跡で見えるすべての惑星';

  @override
  String get presetInnerSolarSystem => '内太陽系';

  @override
  String get presetInnerSolarSystemDesc => 'ハビタブルゾーン指標付きの水星、金星、地球、火星のクローズアップ';

  @override
  String get presetEarthView => '地球ビュー';

  @override
  String get presetEarthViewDesc => '大気詳細を持つ地球のクローズアップ視点';

  @override
  String get presetSaturnRings => '土星の壮大なリング';

  @override
  String get presetSaturnRingsDesc => '詳細なリングシステムを持つ土星のクローズアップ';

  @override
  String get presetEarthMoonSystem => '地月系';

  @override
  String get presetEarthMoonSystemDesc => '可視軌道力学を持つ地球と月';

  @override
  String get presetBinaryStarDrama => '連星ドラマ';

  @override
  String get presetBinaryStarDramaDesc => '重力ダンスを踊る2つの大質量星の正面ビュー';

  @override
  String get presetBinaryStarPlanetMoon => '連星惑星と月';

  @override
  String get presetBinaryStarPlanetMoonDesc => '混沌とした連星系で軌道を回る惑星と月';

  @override
  String get presetAsteroidBeltChaos => '小惑星帯カオス';

  @override
  String get presetAsteroidBeltChaosDesc => '重力効果を持つ密集した小惑星フィールド';

  @override
  String get presetThreeBodyBallet => '三体バレエ';

  @override
  String get presetThreeBodyBalletDesc => 'エレガントな動きの古典的三体問題';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioLearnSolar => '学習内容: 惑星運動、軌道力学、身近な天体';

  @override
  String get scenarioBestSolar => '最適対象: 初心者、天文学愛好家';

  @override
  String get scenarioLearnEarthMoon => '学習内容: 三体力学、月の力学、潮汐力';

  @override
  String get scenarioBestEarthMoon => '最適対象: 地球-月システムの理解';

  @override
  String get scenarioLearnBinary => '学習内容: 恒星進化、連星系、極端重力';

  @override
  String get scenarioBestBinary => '最適対象: 高度な物理学探究';

  @override
  String get scenarioLearnThreeBody => '学習内容: カオス理論、予測不可能な運動、不安定システム';

  @override
  String get scenarioBestThreeBody => '最適対象: 数理物理学愛好家';

  @override
  String get scenarioLearnRandom => '学習内容: 未知の構成発見、実験物理学';

  @override
  String get scenarioBestRandom => '最適対象: 探索と実験';

  @override
  String get privacyPolicyLabel => 'プライバシーポリシー';

  @override
  String get tutorialWelcomeTitle => 'Gravitonへようこそ！';

  @override
  String get tutorialWelcomeDescription =>
      'Gravitonへようこそ。重力物理学の魅力的な世界への窓です！このアプリでは、天体が重力を通じてどのように相互作用し、空間と時間を通じて美しい軌道ダンスを作り出すかを探索できます。';

  @override
  String get welcomeCardDescription =>
      'インタラクティブなシミュレーションを通じて重力物理学を探索しましょう。さまざまなシナリオを試し、コントロールを調整し、宇宙の展開を観察してください！';

  @override
  String get quickTutorialButton => 'クイックチュートリアル';

  @override
  String get gotItButton => '了解！';

  @override
  String get tutorialNavigationHint => '左右にスワイプするか、ボタンを使用してナビゲートしてください';

  @override
  String get tutorialObjectivesTitle => '何ができますか？';

  @override
  String get tutorialObjectivesDescription =>
      '• リアルな軌道力学を観察\n• さまざまな天文シナリオを探索\n• 重力相互作用を実験\n• 衝突と合体を観察\n• 惑星運動について学習\n• 混沌とした三体力学を発見';

  @override
  String get tutorialControlsTitle => 'シミュレーション操作';

  @override
  String get tutorialControlsDescription =>
      'どこでもタップしてシミュレーションのフローティング再生/一時停止コントロールを表示します。速度コントロールは右上角にあります。シナリオ、設定、物理調整のためにメニュー（⋮）をタップしてください。';

  @override
  String get tutorialControlsDescriptionPart1 =>
      'どこでもタップしてシミュレーションのフローティング再生/一時停止コントロールを表示します。速度コントロールは右上角にあります。メニュー';

  @override
  String get tutorialControlsDescriptionPart2 => 'をタップしてシナリオ、設定、物理調整を行ってください。';

  @override
  String get tutorialCameraTitle => 'カメラ & ビュー操作';

  @override
  String get tutorialCameraDescription =>
      'ドラッグしてビューを回転、ピンチしてズーム、2本指でカメラをロールします。下部バーには映画的な体験のためのフォーカス、センタリング、自動回転コントロールがあります。';

  @override
  String get tutorialScenariosTitle => '冒険を選択';

  @override
  String get tutorialScenariosDescription =>
      '右上角のメニュー（⋮）にアクセスして異なるシナリオを探索：太陽系、地球-月力学、連星、または混沌とした三体問題。それぞれが発見すべき独特な物理学を提供します！';

  @override
  String get tutorialScenariosDescriptionPart1 => '右上角のメニュー';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'にアクセスして異なるシナリオを探索：太陽系、地球-月力学、連星、または混沌とした三体問題。それぞれが発見すべき独特な物理学を提供します！';

  @override
  String get tutorialExploreTitle => '探索の準備完了！';

  @override
  String get tutorialExploreDescription =>
      '準備完了です！身近な惑星を見るには太陽系から始めるか、混沌とした楽しみのために三体問題に飛び込んでください。覚えておいてください：リセットするたびに探索する新しい宇宙が作られます！';

  @override
  String get skipTutorial => 'スキップ';

  @override
  String get previous => '前へ';

  @override
  String get next => '次へ';

  @override
  String get getStarted => '始める！';

  @override
  String get showTutorialTooltip => 'チュートリアルを表示';

  @override
  String get helpAndObjectivesTitle => 'ヘルプと目標';

  @override
  String get whatToDoTitle => 'Gravitonでできること';

  @override
  String get whatToDoDescription =>
      'Gravitonは物理学の遊び場です：\n\n🪐 リアルな軌道力学を探索\n🌟 恒星進化と衝突を観察\n🎯 重力について学習\n🎮 異なるシナリオで実験\n📚 天体力学を理解\n🔄 無限のランダム構成を作成';

  @override
  String get objectivesTitle => '学習目標';

  @override
  String get objectives1 => '重力が宇宙をどう形作るかを理解';

  @override
  String get objectives2 => '安定対混沌軌道系を観察';

  @override
  String get objectives3 => 'なぜ惑星が楕円軌道で動くかを学習';

  @override
  String get objectives4 => '連星がどう相互作用するかを発見';

  @override
  String get objectives5 => 'オブジェクトが衝突するとどうなるかを観察';

  @override
  String get objectives6 => '三体問題の複雑さを理解';

  @override
  String get quickStartTitle => 'クイックスタートガイド';

  @override
  String get quickStart1 => 'シナリオを選択（初心者には太陽系推奨）';

  @override
  String get quickStart2 => '再生を押してシミュレーション開始';

  @override
  String get quickStart3 => 'ドラッグでビュー回転、ピンチでズーム';

  @override
  String get quickStart4 => '速度スライダーをタップして時間制御';

  @override
  String get quickStart5 => 'リセットで新しいランダム構成を試行';

  @override
  String get quickStart6 => '軌跡を有効にして軌道パスを表示';

  @override
  String get objectivesDescription =>
      '• 重力が宇宙をどう形作るかを理解\n• 安定対混沌軌道系を観察\n• なぜ惑星が楕円軌道で動くかを学習\n• 連星がどう相互作用するかを発見\n• オブジェクトが衝突するとどうなるかを観察\n• 三体問題の複雑さを理解';

  @override
  String get quickStartDescription =>
      '1. シナリオを選択（初心者には太陽系推奨）\n2. 再生を押してシミュレーション開始\n3. ドラッグでビュー回転、ピンチでズーム\n4. 速度スライダーをタップして時間制御\n5. リセットで新しいランダム構成を試行\n6. 軌跡を有効にして軌道パスを表示';

  @override
  String get showHelpTooltip => 'ヘルプと目標';

  @override
  String get tutorialButton => 'チュートリアル';

  @override
  String get resetTutorialButton => 'リセット';

  @override
  String get tutorialResetMessage =>
      'チュートリアルの状態がリセットされました！アプリを再起動して初回体験を確認してください。';

  @override
  String get copyButton => 'コピー';

  @override
  String couldNotOpenUrl(String url) {
    return '$urlを開けませんでした';
  }

  @override
  String errorOpeningLink(String error) {
    return 'リンクを開くエラー：$error';
  }

  @override
  String copiedToClipboard(String text) {
    return 'クリップボードにコピーしました：$text';
  }

  @override
  String get changelogTitle => '新機能';

  @override
  String get closeDialog => '閉じる';

  @override
  String changelogReleaseDate(String date) {
    return '$dateにリリース';
  }

  @override
  String get changelogAdded => '新機能';

  @override
  String get changelogImproved => '改善';

  @override
  String get changelogFixed => 'バグ修正';

  @override
  String get changelogSkip => 'スキップ';

  @override
  String get changelogDone => '完了';

  @override
  String get changelogButton => '変更履歴を表示';

  @override
  String get resetChangelogButton => '変更履歴の状態をリセット';

  @override
  String get changelogResetMessage => '変更履歴の状態がリセットされました';
}
