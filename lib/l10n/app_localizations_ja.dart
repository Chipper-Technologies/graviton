// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appDescription =>
      '重力動力学と軌道力学を探求する物理シミュレーション。インタラクティブな3D可視化を通じて天体運動の美しさと複雑さを体験してください。';

  @override
  String get appFlavorDevelopment => '開発';

  @override
  String get appFlavorProduction => '本番';

  @override
  String get appInformationCredits => 'アプリ情報とクレジット';

  @override
  String get appTitle => 'Graviton';

  @override
  String get backButtonTooltip => '戻る';

  @override
  String get bottomNavVisualsLabel => '視覚';

  @override
  String get collisionHapticFeedbackDescription =>
      'シミュレーション中に天体が衝突したときのハプティックフィードバックを有効にする';

  @override
  String get exitFullscreenHint => 'フルスクリーンモードを終了するには任意の場所をタップ';

  @override
  String get fullscreenMode => 'フルスクリーンモード';

  @override
  String get fullscreenModeDescription => '没入感のある表示のためにすべてのUI要素を非表示にする';

  @override
  String get hapticFeedbackCollisions => '衝突時のハプティックフィードバック';

  @override
  String get hapticFeedbackDescription => 'UIインタラクションと衝突のハプティックフィードバックを有効にする';

  @override
  String get uiHapticFeedbackDescription =>
      'ボタンタップ、トグル、ナビゲーションなどのUIインタラクションのハプティックフィードバックを有効にする';

  @override
  String get displayOptionsTitle => '表示オプション';

  @override
  String get pauseButton => '一時停止';

  @override
  String get playButton => '再生';

  @override
  String get presetAsteroidBeltChaos => '小惑星帯カオス';

  @override
  String get presetAsteroidBeltChaosDesc => '重力効果を持つ密集した小惑星フィールド';

  @override
  String get presetBinaryStarDrama => '連星ドラマ';

  @override
  String get presetBinaryStarDramaDesc => '重力ダンスを踊る2つの大質量星の正面ビュー';

  @override
  String get presetBinaryStarPlanetMoon => '連星惑星と月';

  @override
  String get presetBinaryStarPlanetMoonDesc => '混沌とした連星系で軌道を回る惑星と月';

  @override
  String get presetCompleteSolarSystem => '完全太陽系';

  @override
  String get presetCompleteSolarSystemDesc => '美しい軌道軌跡で見えるすべての惑星';

  @override
  String get presetEarthMoonSystem => '地月系';

  @override
  String get presetEarthMoonSystemDesc => '可視軌道力学を持つ地球と月';

  @override
  String get presetEarthView => '地球ビュー';

  @override
  String get presetEarthViewDesc => '大気詳細を持つ地球のクローズアップ視点';

  @override
  String get presetGalaxyBlackHole => '銀河ブラックホール';

  @override
  String get presetGalaxyBlackHoleDesc => '銀河中心の超大質量ブラックホールのクローズアップビュー';

  @override
  String get presetGalaxyCoreDetail => '銀河中心核詳細';

  @override
  String get presetGalaxyCoreDetailDesc => '降着円盤を持つ明るい銀河中心のクローズアップ';

  @override
  String get presetGalaxyFormationOverview => '銀河形成概観';

  @override
  String get presetGalaxyFormationOverviewDesc => '宇宙背景を持つ螺旋銀河形成の広角ビュー';

  @override
  String get presetInnerSolarSystem => '内太陽系';

  @override
  String get presetInnerSolarSystemDesc => 'ハビタブルゾーン指標付きの水星、金星、地球、火星のクローズアップ';

  @override
  String get presetSaturnRings => '土星の壮大なリング';

  @override
  String get presetSaturnRingsDesc => '詳細なリングシステムを持つ土星のクローズアップ';

  @override
  String get presetThreeBodyBallet => '三体バレエ';

  @override
  String get presetThreeBodyBalletDesc => 'エレガントな動きの古典的三体問題';

  @override
  String get resetButton => 'リセット';

  @override
  String get resetChangelogButton => '変更履歴の状態をリセット';

  @override
  String get resetChangelogDescription => '変更履歴の既読状態をリセット';

  @override
  String get resetSettingsDescription => 'すべての設定をデフォルト値にリセット';

  @override
  String get resetTutorialDescription => 'チュートリアルの進行状況をリセット';

  @override
  String get simulationCanvasFocused =>
      'シミュレーションキャンバスにフォーカス - メイン物理シミュレーションエリア';

  @override
  String get simulationCanvasHint =>
      'キーボードショートカットでシミュレーションを制御してください。スペースで一時停止、Rで再開、Cでカメラ中央揃え';

  @override
  String get simulationCanvasLabel => '重力物理シミュレーション';

  @override
  String get simulationControlsFocused => 'シミュレーションコントロールにフォーカス';

  @override
  String simulationDescription(
    int bodyCount,
    String status,
    String speed,
    int steps,
  ) {
    return '$bodyCount個の天体がある重力シミュレーション。状態：$status。速度：$speed。ステップ：$steps';
  }

  @override
  String get simulationSpeed => 'シミュレーション速度';

  @override
  String get simulationSpeedHint =>
      'シミュレーション速度を0.1倍から16倍の通常速度まで調整します。矢印キーで細かく調整できます。';

  @override
  String simulationStateDescription(
    int bodyCount,
    String status,
    String speed,
    int stepCount,
  ) {
    return '$bodyCount個の天体がある重力シミュレーション。状態：$status。速度：$speed。完了したステップ：$stepCount。シミュレーションと相互作用するにはタップするか、キーボードショートカットを使用してください。';
  }

  @override
  String get simulationStats => 'シミュレーション統計';

  @override
  String get simulationStepsLabel => 'シミュレーションステップ';

  @override
  String get speedDouble => '2倍速';

  @override
  String get speedFast => '高速';

  @override
  String speedFormatted(String speed) {
    return '$speed倍';
  }

  @override
  String get speedHalf => '1/2倍速';

  @override
  String get speedLabel => '速度';

  @override
  String get speedMaximum => '最高速';

  @override
  String get speedNormal => '標準';

  @override
  String get speedQuarter => '1/4倍速';

  @override
  String get speedVeryFast => '超高速';

  @override
  String get stopFollowTitle => '追跡停止';

  @override
  String get stopFollowingTooltip => 'オブジェクトの追跡を停止';

  @override
  String get stopRotateTitle => '回転停止';

  @override
  String get testPresetForUnitTesting => 'ユニットテスト用テストプリセット';

  @override
  String get trailsLabel => '軌跡';

  @override
  String get cameraControlsFocused => 'カメラコントロールにフォーカス';

  @override
  String get cameraControlsLabel => 'カメラ操作';

  @override
  String get cameraDynamicFraming => '動的フレーミング';

  @override
  String get cameraDynamicFramingDescription => 'シーンコンテンツに基づいてフレーミングを自動調整';

  @override
  String cameraFollowingDescription(
    String bodyName,
    String distance,
    String rotation,
  ) {
    return '距離$distanceで$bodyNameを追跡するカメラ。自動回転：$rotation';
  }

  @override
  String cameraFreeDescription(String distance, String rotation) {
    return '距離$distanceでの自由モードカメラ。自動回転：$rotation';
  }

  @override
  String get cameraLabel => 'カメラ';

  @override
  String get cameraManual => '手動制御';

  @override
  String get cameraManualDescription => 'フォローモード付きの従来の手動カメラ制御';

  @override
  String get cameraPredictiveOrbital => '予測軌道';

  @override
  String get cameraPredictiveOrbitalDescription =>
      'AIが軌道経路を予測してドラマチックなカメラ動作を実現';

  @override
  String get cameraSettingsTitle => 'カメラ設定';

  @override
  String get cameraSpeedHint => 'AIカメラの移動速度を遅いから速いまで調整します。矢印キーで小刻みに変更できます。';

  @override
  String get cameraSpeedLabel => 'カメラ速度';

  @override
  String get cameraTooltip => 'カメラ設定とAIモード';

  @override
  String distanceFormatted(String distance) {
    return '$distance';
  }

  @override
  String get distanceLabel => '距離';

  @override
  String get previewEditortitle => 'プレビューエディターのタイトル';

  @override
  String get setupEditorTitle => 'セットアップ';

  @override
  String get rotateLabel => '回転';

  @override
  String get viewPhysicsSettings => '物理設定を表示';

  @override
  String get zoomInAction => 'ズームイン';

  @override
  String get zoomLabel => 'ズーム';

  @override
  String get zoomOutAction => 'ズームアウト';

  @override
  String get colorEditor => '色エディター';

  @override
  String colorOptionTemplate(String colorName, Object color) {
    return '色のオプション $color';
  }

  @override
  String get colorSelector => '色選択';

  @override
  String colorOptionTooltip(String colorName) {
    return '天体に$colorName色を選択';
  }

  @override
  String get visualsTooltip => '視覚表示オプション';

  @override
  String get collisionHapticFeedback => '衝突ハプティックフィードバック';

  @override
  String get collisionSensitivity => '衝突感度';

  @override
  String get gravityColorSchemeClassic => 'クラシック';

  @override
  String get gravityColorSchemeEmerald => 'エメラルド';

  @override
  String get gravityColorSchemeMonochrome => 'モノクロ';

  @override
  String get gravityColorSchemeNeon => 'ネオン';

  @override
  String get gravityColorSchemeSpectral => 'スペクトラル';

  @override
  String get gravityEditor => '重力エディター';

  @override
  String get gravityFieldColorSchemeDescription => '重力場可視化のカラースキームを選択';

  @override
  String get gravityFieldColorSchemeLabel => '重力場の色';

  @override
  String get gravityFieldIndicatorsDescription => '重力場の強度の視覚的インジケーターを表示';

  @override
  String get gravityFieldIndicatorsLabel => '場の強度インジケーター';

  @override
  String gravityFieldStrengthFormatted(String strength, String unit) {
    return '$strength $unit';
  }

  @override
  String get gravityFieldStrengthLabel => '場の強度';

  @override
  String get gravityFieldStrengthUnit => 'm/s²';

  @override
  String get gravityFieldsDescription => '重力場可視化を表示';

  @override
  String get gravityFieldsTitle => '重力場';

  @override
  String get gravityWellsDescription => 'オブジェクト周辺の重力場の強度を表示';

  @override
  String get gravityWellsLabel => '重力井戸';

  @override
  String get massKgEditorhint => '質量をキログラムで入力';

  @override
  String get physicsConfigurationWillBeImplementedHereEditor =>
      '物理設定はここで実装されます-エディター';

  @override
  String physicsFieldRangeError(String field, double min, double max) {
    return '物理フィールドが範囲外';
  }

  @override
  String get physicsSection => '物理学';

  @override
  String get physicsSettingsDescription => 'シミュレーションパラメータ';

  @override
  String get physicsSettingsTitle => '物理設定';

  @override
  String physicsStatsDescription(String time, String earthYears, int steps) {
    return '物理：$time時間単位、$earthYears地球年、$stepsシミュレーションステップ完了';
  }

  @override
  String get physicsTooltip => '物理可視化と設定';

  @override
  String get physicsVisualizationTitle => '物理可視化';

  @override
  String get temperatureCold => '寒冷';

  @override
  String get temperatureEditorlabel => '温度エディターラベル';

  @override
  String get temperatureFrozen => '凍結';

  @override
  String get temperatureHot => '高温';

  @override
  String get temperatureKEditorhint => '温度をケルビンで入力';

  @override
  String get temperatureCelsiusEditorhint => '温度 (°C)';

  @override
  String get temperatureFahrenheitEditorhint => '温度 (°F)';

  @override
  String get temperatureModerate => '温和';

  @override
  String get temperatureNotApplicable => '該当なし';

  @override
  String get temperatureScorching => '灼熱';

  @override
  String get temperatureUnitCelsius => '°C';

  @override
  String get temperatureUnitFahrenheit => '°F';

  @override
  String get temperatureUnitKelvin => 'K';

  @override
  String get temperatureUnitCelsiusName => '摂氏';

  @override
  String get temperatureUnitFahrenheitName => '華氏';

  @override
  String get temperatureUnitKelvinName => 'ケルビン';

  @override
  String get velocityMsEditor => '速度m/sエディター';

  @override
  String get addBodyButton => '天体追加ボタン';

  @override
  String get addCelestialBodiesToCreateYourCustomScenarioEditor =>
      'カスタムシナリオを作成するために天体を追加-エディター';

  @override
  String get asteroidBeltAndOtherParticleSystemsWillBeConfiguredHereEditor =>
      '小惑星帯とその他の粒子システムはここで設定されます-エディター';

  @override
  String get beginnerEditor => '初心者エディター';

  @override
  String get noBodiesAdded => 'まだ天体が追加されていません';

  @override
  String get addBodiesInSetupTab => '設定タブで天体を追加';

  @override
  String get untitledScenario => 'タイトル未設定のシナリオ';

  @override
  String get noDescriptionProvided => '説明が提供されていません';

  @override
  String get collisionSoftening => '衝突軟化';

  @override
  String get collisionRadius => '衝突半径';

  @override
  String get bodyTypeEditor => '天体タイプエディター';

  @override
  String get createACopyOfThisCelestialBodyEditorHint => 'この天体のコピーを作成-エディターヒント';

  @override
  String get createCustomScenarioButton => 'カスタムシナリオ作成ボタン';

  @override
  String get createCustomScenarioDescription => 'カスタムシナリオの説明';

  @override
  String get createScenarioButton => 'シナリオ作成ボタン';

  @override
  String get createScenarioTitle => 'シナリオ作成タイトル';

  @override
  String get editScenarioButton => 'シナリオを編集';

  @override
  String get editScenarioHint => 'このシナリオを編集';

  @override
  String get editBodyButton => '天体を編集';

  @override
  String get editBodyHint => 'この天体を編集';

  @override
  String get deleteScenarioButton => 'シナリオを削除';

  @override
  String get deleteScenarioHint => 'このシナリオを削除';

  @override
  String get customGravitationalSimulationEditor => 'カスタム重力シミュレーションエディター';

  @override
  String get deleteBodyConfirmMessage => '天体削除確認メッセージ';

  @override
  String deleteBodyConfirmTitle(String bodyName) {
    return '天体削除確認タイトル';
  }

  @override
  String deleteBodyNameTemplate(String bodyName) {
    return '$bodyNameを削除';
  }

  @override
  String get deleteBodyTooltip => '天体削除ツールチップ';

  @override
  String get deleteButton => '削除ボタン';

  @override
  String deleteScenarioConfirmMessage(String scenarioName) {
    return 'シナリオ削除確認メッセージ';
  }

  @override
  String get deleteScenarioTitle => 'シナリオ削除タイトル';

  @override
  String deleteScenarioSuccessMessage(String scenarioName) {
    return 'シナリオが正常に削除されました: $scenarioName';
  }

  @override
  String deleteScenarioFailedMessage(String error) {
    return 'シナリオの削除に失敗しました: $error';
  }

  @override
  String get editEditorLabel => '編集エディターラベル';

  @override
  String get editScenarioTitle => 'シナリオ編集タイトル';

  @override
  String get gravitationalForcesEditor => '重力エディター';

  @override
  String get newScenarioEditor => '新しいシナリオエディター';

  @override
  String get noBodiesYetEditor => 'まだ天体がありません-エディター';

  @override
  String get positionMEditor => '位置mエディター';

  @override
  String get positionMotionEditor => '位置・運動エディター';

  @override
  String get propertiesEditor => 'プロパティエディター';

  @override
  String get removeThisCelestialBodyFromTheScenarioEditorHint =>
      'この天体をシナリオから削除-エディターヒント';

  @override
  String get softeningEditor => 'ソフトニングエディター';

  @override
  String get stellarPropertiesEditor => '恒星プロパティエディター';

  @override
  String get trailPointsEditor => '軌跡ポイントエディター';

  @override
  String get customColor => 'カスタム色';

  @override
  String get customLabel => 'カスタムラベル';

  @override
  String get customScenarioDescription => 'カスタムシナリオの説明';

  @override
  String get viewScenarioButton => 'シナリオ表示';

  @override
  String get viewScenarioHint => '読み取り専用モードでシナリオの詳細を表示';

  @override
  String get exportScenarioButton => 'シナリオエクスポート';

  @override
  String get exportScenarioHint => '共有用にシナリオをファイルに出力する';

  @override
  String exportScenarioFailedMessage(String error) {
    return 'シナリオエクスポート失敗';
  }

  @override
  String get exportScenarioNotImplementedMessage => 'シナリオエクスポート未実装';

  @override
  String get saveButton => '保存';

  @override
  String get saveBodyTooltip => '天体を保存';

  @override
  String get saveNewBodyAccessibility => '新しい天体を保存';

  @override
  String get saveNewBodyHint => '現在の設定で天体を作成します';

  @override
  String get saveChangesToBodyAccessibility => '天体の変更を保存';

  @override
  String get saveChangesToBodyHint => 'この天体に加えた全ての変更を保存します';

  @override
  String get moreActionsAccessibility => 'その他のアクション';

  @override
  String get moreActionsHint => '複製と削除オプションのメニューを開く';

  @override
  String get duplicateBodyAccessibility => 'この天体のコピーを作成';

  @override
  String get deleteBodyAccessibility => 'この天体を完全に削除';

  @override
  String get settingsButtonFocused => '設定ボタンにフォーカス';

  @override
  String get settingsMenuDescription => '視覚的および動作オプション';

  @override
  String get settingsTooltip => 'アプリケーション設定';

  @override
  String get toggleAutoRotateAction => '自動回転切り替え';

  @override
  String get toggleGravityFieldsTooltip => '重力場を切り替え';

  @override
  String get toggleHabitabilityIndicatorsTooltip => '惑星居住可能性状態の切り替え';

  @override
  String get toggleHabitableZonesTooltip => 'ハビタブルゾーンの切り替え';

  @override
  String get toggleLabelsTooltip => '天体ラベルの切り替え';

  @override
  String get toggleStatsTooltip => '統計の切り替え';

  @override
  String get statsLabel => '統計';

  @override
  String get helpMenuDescription => 'チュートリアルと目標';

  @override
  String get tutorialButton => 'チュートリアル';

  @override
  String get tutorialCameraDescription =>
      'ドラッグしてビューを回転、ピンチしてズーム、2本指でカメラをロール、3本指でパンします。下部バーには映画的な体験のためのフォーカス、センタリング、自動回転コントロールがあります。';

  @override
  String get tutorialCameraTitle => 'カメラ & ビュー操作';

  @override
  String get tutorialControlsDescription =>
      'どこでもタップしてシミュレーションのフローティング再生/一時停止コントロールを表示します。速度コントロールは右上角にあります。シナリオ、設定、物理調整のためにメニュー（⋮）をタップしてください。';

  @override
  String get tutorialControlsDescriptionPart1 =>
      'どこでもタップしてシミュレーションのフローティング再生/一時停止コントロールを表示します。速度コントロールは右上角にあります。メニュー';

  @override
  String get tutorialControlsDescriptionPart2 => 'をタップしてシナリオ、設定、物理調整を行ってください。';

  @override
  String get tutorialControlsTitle => 'シミュレーション操作';

  @override
  String get tutorialDescription => 'アプリのインタラクティブガイドツアー';

  @override
  String get tutorialExploreDescription =>
      '準備完了です！身近な惑星を見るには太陽系から始めるか、混沌とした楽しみのために三体問題に飛び込んでください。覚えておいてください：リセットするたびに探索する新しい宇宙が作られます！';

  @override
  String get tutorialExploreTitle => '探索の準備完了！';

  @override
  String get tutorialNavigationHint => '左右にスワイプするか、ボタンを使用してナビゲートしてください';

  @override
  String get tutorialObjectivesDescription =>
      '• リアルな軌道力学を観察\n• さまざまな天文シナリオを探索\n• 重力相互作用を実験\n• 衝突と合体を観察\n• 惑星運動について学習\n• 混沌とした三体力学を発見';

  @override
  String get tutorialObjectivesTitle => '何ができますか？';

  @override
  String get tutorialResetMessage =>
      'チュートリアルの状態がリセットされました！アプリを再起動して初回体験を確認してください。';

  @override
  String get tutorialResetSuccess => 'チュートリアルの進行状況がリセットされました';

  @override
  String get tutorialScenariosDescription =>
      '右上角のメニュー（⋮）にアクセスして異なるシナリオを探索：太陽系、地球-月力学、連星、または混沌とした三体問題。それぞれが発見すべき独特な物理学を提供します！';

  @override
  String get tutorialScenariosDescriptionPart1 => '右上角のメニュー';

  @override
  String get tutorialScenariosDescriptionPart2 =>
      'にアクセスして異なるシナリオを探索：太陽系、地球-月力学、連星、または混沌とした三体問題。それぞれが発見すべき独特な物理学を提供します！';

  @override
  String get tutorialScenariosTitle => '冒険を選択';

  @override
  String get tutorialWelcomeDescription =>
      'Gravitonへようこそ。重力物理学の魅力的な世界への窓です！このアプリでは、天体が重力を通じてどのように相互作用し、空間と時間を通じて美しい軌道ダンスを作り出すかを探索できます。';

  @override
  String get tutorialWelcomeTitle => 'Gravitonへようこそ！';

  @override
  String get welcomeCardDescription =>
      'インタラクティブなシミュレーションを通じて重力物理学を探索しましょう。さまざまなシナリオを試し、コントロールを調整し、宇宙の展開を観察してください！';

  @override
  String get cancel => 'キャンセル';

  @override
  String get descriptionEditorLabel => '説明エディターラベル';

  @override
  String get next => '次へ';

  @override
  String get ok => 'OK';

  @override
  String get previous => '前へ';

  @override
  String liveUpdateAnnouncement(String updateType, String value) {
    return '$updateTypeが$valueに変更されました';
  }

  @override
  String timeFormatted(String time) {
    return '$time秒';
  }

  @override
  String get timeLabel => '時間';

  @override
  String get timeScaleStatLabel => '時間スケール';

  @override
  String get updateLater => '後で';

  @override
  String get updateNow => '今すぐ更新';

  @override
  String get updateRequiredMessage =>
      'このアプリの新しいバージョンが利用可能です。最新の機能と改善を引き続きご利用いただくために、アップデートしてください。';

  @override
  String get updateRequiredTitle => '更新が必要';

  @override
  String get updateRequiredWarning => 'このバージョンはサポートされなくなりました。';

  @override
  String errorLoadingChangelogs(String error) {
    return '変更履歴の読み込みエラー: $error';
  }

  @override
  String errorOpeningLink(String error) {
    return 'リンクを開くエラー：$error';
  }

  @override
  String get notificationTypeDebug => 'デバッグ';

  @override
  String get notificationTypeInfo => '情報';

  @override
  String get warningTitle => '警告';

  @override
  String accessibilityAnnouncementSkippedNoBindingMessage(String message) {
    return 'アクセシビリティアナウンスメントスキップ - バインディングなし';
  }

  @override
  String get accessibilityCameraFocus => 'カメラが最も近い天体にフォーカスしました';

  @override
  String get accessibilityCameraFollow => 'カメラが選択された天体を追跡し始めました';

  @override
  String get accessibilityCameraReset => 'カメラビューがデフォルト位置にリセットされました';

  @override
  String get accessibilityCameraUnfollow => 'カメラが天体の追跡を停止しました';

  @override
  String accessibilityCollisionRadiusChange(String newValue) {
    return '衝突感度が$newValueに変更されました';
  }

  @override
  String accessibilityError(String errorMessage) {
    return 'エラー：$errorMessage';
  }

  @override
  String accessibilityGravityChange(String newValue) {
    return '重力の強さが$newValueに変更されました';
  }

  @override
  String accessibilityMergeEvent(String body1, String body2) {
    return '衝突検出：$body1が$body2と合体しました';
  }

  @override
  String get accessibilityMergeEventContext => '合体した質量が新しい天体を作りました';

  @override
  String accessibilityScenarioChange(String scenarioName) {
    return 'シナリオが$scenarioNameに変更されました';
  }

  @override
  String get accessibilityScenarioChangeContext => '新しい天体と物理パラメータが読み込まれました';

  @override
  String accessibilitySettingDisabled(String settingName) {
    return '$settingNameが無効になりました';
  }

  @override
  String accessibilitySettingEnabled(String settingName) {
    return '$settingNameが有効になりました';
  }

  @override
  String get accessibilitySimulationPaused => 'シミュレーション一時停止';

  @override
  String get accessibilitySimulationPausedContext => 'すべての天体が停止しました';

  @override
  String get accessibilitySimulationReset => 'シミュレーションリセット';

  @override
  String get accessibilitySimulationResetContext => '新しいシナリオが新しい天体とともに読み込まれました';

  @override
  String get accessibilitySimulationResumed => 'シミュレーション再開';

  @override
  String get accessibilitySimulationResumedContext => '天体が再び動き始めました';

  @override
  String get accessibilitySimulationStarted => 'シミュレーション開始';

  @override
  String get accessibilitySimulationStartedContext => '天体が動き始めました';

  @override
  String get accessibilitySimulationStopped => 'シミュレーション停止';

  @override
  String get accessibilitySimulationStoppedContext => 'すべての天体がリセットされました';

  @override
  String accessibilitySpeedChange(String newValue) {
    return 'シミュレーション速度が$newValueに変更されました';
  }

  @override
  String accessibilityTutorialProgress(
    int currentStep,
    int totalSteps,
    String stepName,
  ) {
    return 'チュートリアルステップ$currentStep/$totalSteps：$stepName';
  }

  @override
  String get changelogAdded => '新機能';

  @override
  String get changelogButton => '変更履歴を表示';

  @override
  String get changelogCategoryAdded => '追加';

  @override
  String get changelogCategoryFixed => '修正';

  @override
  String get changelogCategoryImproved => '改善';

  @override
  String get changelogDescription => 'アプリの更新と変更を表示';

  @override
  String get changelogDone => '完了';

  @override
  String get changelogFixed => 'バグ修正';

  @override
  String get changelogHometitle => '更新履歴ホームタイトル';

  @override
  String get changelogImproved => '改善';

  @override
  String changelogLoadError(String error) {
    return '変更履歴の読み込みに失敗しました: $error';
  }

  @override
  String changelogNotFoundError(String version) {
    return '変更履歴が見つかりません。まずFirestoreに変更履歴データを追加してください。\n現在のバージョン: $version';
  }

  @override
  String changelogReleaseDate(String date) {
    return '$dateにリリース';
  }

  @override
  String get changelogResetMessage => '変更履歴の状態がリセットされました';

  @override
  String get changelogResetSuccess => '変更履歴の状態がリセットされました';

  @override
  String get changelogTitle => '新機能';

  @override
  String get debugStatisticsTitle => 'デバッグと統計';

  @override
  String errorLoadingChangelogEHome(String error) {
    return '更新履歴読み込みエラー';
  }

  @override
  String noChangelogAvailableForVersionHome(String version) {
    return 'このバージョンの更新履歴がありません';
  }

  @override
  String get testPreset => 'テストプリセット';

  @override
  String get testScenarioButton => 'テストシナリオボタン';

  @override
  String get testScenarioHint => '現在のシナリオをシミュレーションでテストする';

  @override
  String get testScenarioNotImplementedMessage => 'テストシナリオ未実装';

  @override
  String get scenarioEditorMenuHint => 'テストとエクスポートオプションを含むメニューを開く';

  @override
  String get aboutButtonTooltip => 'について';

  @override
  String get aboutMenuDescription => 'アプリ情報とクレジット';

  @override
  String get accessAppPreferences => 'アプリ設定にアクセス';

  @override
  String get accessScenarioOptions => 'シナリオオプションにアクセス';

  @override
  String get adjustSimulationSpeed => 'シミュレーション速度を調整';

  @override
  String get aiCameraModesTitle => 'AIカメラモード';

  @override
  String get allRightsReserved => 'すべての権利を保有';

  @override
  String get announcementTitle => 'お知らせ';

  @override
  String appliedPreset(String presetName) {
    return 'プリセットが適用されました: $presetName';
  }

  @override
  String get applyScene => 'シーンを適用';

  @override
  String get atLeastOneBodyIsRequired => '最低1つの天体が必要';

  @override
  String get authorLabel => '作者';

  @override
  String get autoRotateActive => 'アクティブ';

  @override
  String get autoRotateInactive => '非アクティブ';

  @override
  String get autoRotateLabel => '自動回転';

  @override
  String get autoRotateOff => 'オフ';

  @override
  String get autoRotateOn => 'オン';

  @override
  String get autoRotateTooltip => '自動回転';

  @override
  String get rotateSpeed => '回転速度';

  @override
  String get blackColor => '黒色';

  @override
  String get bodies => '天体';

  @override
  String get bodiesHeaderDescription => '天体ヘッダーの説明';

  @override
  String bodiesHeaderPlural(int count) {
    return '天体';
  }

  @override
  String scenariosHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のシナリオ',
      one: '1つのシナリオ',
      zero: 'シナリオなし',
    );
    return '$_temp0';
  }

  @override
  String experimentsHeaderPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個の実験',
      one: '1つの実験',
      zero: '実験なし',
    );
    return '$_temp0';
  }

  @override
  String bodiesInSimulation(String descriptions) {
    return 'シミュレーションの天体：$descriptions';
  }

  @override
  String get bodiesLabel => '天体';

  @override
  String get bodyAlpha => 'アルファ';

  @override
  String bodyAsteroid(int number) {
    return '小惑星 $number';
  }

  @override
  String get bodyBeta => 'ベータ';

  @override
  String get bodyBlackHole => 'ブラックホール';

  @override
  String get bodyCenterOfMass => '質量中心';

  @override
  String get bodyCentralStar => '中心星';

  @override
  String bodyColorInvalid(String prefix) {
    return '天体の色が無効';
  }

  @override
  String get bodyEarth => '地球';

  @override
  String get bodyEarthLike => '地球型惑星';

  @override
  String get bodyGamma => 'ガンマ';

  @override
  String bodyIndex(int index) {
    return '天体インデックス';
  }

  @override
  String get bodyInnerPlanet => '内惑星';

  @override
  String get bodyJupiter => '木星';

  @override
  String get bodyMars => '火星';

  @override
  String bodyMassInvalid(String prefix) {
    return '天体質量が無効';
  }

  @override
  String get bodyMercury => '水星';

  @override
  String get bodyMoon => '月';

  @override
  String get bodyMoonM => '衛星M';

  @override
  String get bodySpacecraft => '宇宙船';

  @override
  String get bodyIo => 'イオ';

  @override
  String get bodyEuropa => 'エウロパ';

  @override
  String bodyNameCopyTemplate(String bodyName) {
    return '$bodyNameのコピー';
  }

  @override
  String bodyNameRequired(String prefix) {
    return '天体名が必要';
  }

  @override
  String get bodyNeptune => '海王星';

  @override
  String bodyNumberTemplate(String number) {
    return '天体 $number';
  }

  @override
  String get bodyOuterPlanet => '外惑星';

  @override
  String get bodyPlanetP => '惑星P';

  @override
  String bodyPositionComponentInvalid(String prefix, int component) {
    return '天体位置コンポーネントが無効';
  }

  @override
  String bodyPositionInvalid(String prefix) {
    return '天体位置が無効';
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
  String get bodyPropertiesMass => '質量';

  @override
  String get bodyPropertiesName => '名前';

  @override
  String get bodyPropertiesNameHint => '天体名を入力';

  @override
  String get bodyPropertiesRadius => '半径';

  @override
  String get bodyPropertiesMassHint => '重力の影響と軌道力学を調整';

  @override
  String get bodyPropertiesRadiusHint => 'サイズと衝突境界を制御';

  @override
  String get bodyPropertiesTitle => '天体のプロパティ';

  @override
  String get bodyPropertiesVelocity => '速度';

  @override
  String bodyRadiusInvalid(String prefix) {
    return '天体半径が無効';
  }

  @override
  String bodyRing(int number) {
    return 'リング $number';
  }

  @override
  String get bodyRingedPlanet => '環状惑星';

  @override
  String get bodyRockyPlanet => '岩石惑星';

  @override
  String get bodySaturn => '土星';

  @override
  String bodySelectedTemplate(String bodyNumber) {
    return '$bodyNumberが選択されました';
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
  String get bodySun => '太陽';

  @override
  String get bodySuperEarth => 'スーパーアース';

  @override
  String get bodyTypeAsteroid => '小惑星';

  @override
  String bodyTypeAsteroidPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個の小惑星',
    );
    return '$_temp0';
  }

  @override
  String bodyTypeInvalid(String prefix, String bodyType) {
    return '天体タイプが無効';
  }

  @override
  String bodyTypeMoonPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個の月',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypePlanet => '惑星';

  @override
  String bodyTypePlanetPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個の惑星',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeSelector => '天体タイプセレクター';

  @override
  String get bodyTypeStar => '恒星';

  @override
  String bodyTypeStarPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個の恒星',
    );
    return '$_temp0';
  }

  @override
  String get bodyTypeNeutronStar => '中性子星';

  @override
  String get bodyTypeBlackHole => 'ブラックホール';

  @override
  String get bodyTypeMoon => '月';

  @override
  String bodyTypeTemplate(String bodyType, Object type) {
    return '天体タイプ: $type';
  }

  @override
  String get bodyTypeTooltipStar => '核融合によって光と熱を生成する巨大な天体。恒星は恒星系の主要なエネルギー源です。';

  @override
  String get bodyTypeTooltipPlanet =>
      '恒星を周回し、軌道を掃除した大きな天体。惑星は岩石質またはガス状で、月を持つことがあります。';

  @override
  String get bodyTypeTooltipMoon =>
      '惑星を周回する自然の衛星。月は潮汐に影響し、惑星系に安定性をもたらすことができます。';

  @override
  String get bodyTypeTooltipAsteroid => '太陽を周回する小さな岩石体。小惑星は太陽系の初期形成時の残骸です。';

  @override
  String get bodyTypeTooltipBlackHole => '重力場が非常に強く、光さえも脱出できない時空の領域。';

  @override
  String get bodyTypeTooltipNeutronStar =>
      '巨大な恒星が崩壊して形成される極めて密度の高い恒星の残骸。信じられないほど強い重力場と磁場を持っています。';

  @override
  String get bodyUranus => '天王星';

  @override
  String bodyVelocityComponentInvalid(String prefix, int component) {
    return '天体速度コンポーネントが無効';
  }

  @override
  String bodyVelocityInvalid(String prefix) {
    return '天体速度が無効';
  }

  @override
  String get bodyVenus => '金星';

  @override
  String get bottomSheetFocused => 'ボトムシートにフォーカス';

  @override
  String get bottomSheetLabel => 'ボトムシート';

  @override
  String get browseAvailableSimulations => '利用可能なシミュレーションを参照';

  @override
  String celestialBodyNameTemplate(String bodyName, Object name) {
    return '天体 $name';
  }

  @override
  String get centerLabel => '中央';

  @override
  String get centerViewTooltip => 'ビューを中央に';

  @override
  String get cinematicCameraTechniqueDescription => 'オブジェクトを追跡する際のAIカメラ制御方法を選択';

  @override
  String get cinematicCameraTechniqueLabel => 'AIカメラ技術';

  @override
  String get cinematicTechniqueDynamicFramingDesc => 'カオスシナリオ用のリアルタイム劇的ターゲティング';

  @override
  String get cinematicTechniquePredictiveOrbitalDesc => '教育シナリオ用のAIツアーと軌道予測';

  @override
  String get closeButton => '閉じる';

  @override
  String get collapsedState => '折りたたみ済み';

  @override
  String get collisionsSection => '衝突';

  @override
  String get colorsLabel => '色';

  @override
  String get companyName => 'Chipper Technologies LLC';

  @override
  String get coolTrails => '❄️ 寒色';

  @override
  String copiedToClipboard(String text) {
    return 'クリップボードにコピーしました：$text';
  }

  @override
  String get copyButton => 'コピー';

  @override
  String get copyrightLabel => '著作権';

  @override
  String couldNotOpenUrl(String url) {
    return '$urlを開けませんでした';
  }

  @override
  String get crosshairsDescription => '画面中央のインジケーターを表示';

  @override
  String get crosshairsTitle => 'クロスヘア';

  @override
  String get currentScenario => '現在のシナリオ';

  @override
  String get currentStatisticsTitle => '現在の統計';

  @override
  String get currentlySelected => '現在選択中';

  @override
  String get cyanColor => 'シアン色';

  @override
  String get deactivate => '無効化';

  @override
  String get describeWhatThisScenarioDemonstratesEditorHint =>
      'このシナリオが何を実証するかを説明-エディターヒント';

  @override
  String get detailsEditorLabel => '詳細エディターラベル';

  @override
  String get developerToolsMenuDescription => '開発用デバッグツール';

  @override
  String get developerToolsTitle => '開発者ツール';

  @override
  String get difficultyEditorLabel => '難易度エディターラベル';

  @override
  String get discardButton => '破棄ボタン';

  @override
  String get dragToRotateCameraView => 'ドラッグしてカメラビューを回転';

  @override
  String get dualOrbitalPaths => '二重軌道パス';

  @override
  String get dualOrbitalPathsDescription => '理想的な円軌道と実際の楕円軌道の両方を表示';

  @override
  String duplicateBodyNameTemplate(String bodyName) {
    return '$bodyNameを複製';
  }

  @override
  String get duplicateBodyTooltip => '天体複製ツールチップ';

  @override
  String get dynamicFramingDescription => 'AIがすべてのオブジェクトを動的にフレーミング';

  @override
  String get earthBlueColor => '地球ブルー色';

  @override
  String earthYearsFormatted(String years) {
    return '$years年';
  }

  @override
  String get earthYearsLabel => '地球年';

  @override
  String get educationalFocusBinaryOrbits => '連星軌道';

  @override
  String get educationalFocusChaoticDynamics => 'カオス力学';

  @override
  String get educationalFocusManyBodyDynamics => '多体力学';

  @override
  String get educationalFocusPlanetaryMotion => '惑星運動';

  @override
  String get educationalFocusRealWorldSystem => '実世界システム';

  @override
  String get educationalFocusStructureFormation => '構造形成';

  @override
  String get educationalObjectivesEditortitle => '教育目標エディタータイトル';

  @override
  String get educationalObjectivesFutureMessage => '教育目標は将来のバージョンでここで設定可能になります';

  @override
  String get educationalObjectivesListMessage =>
      'これには以下が含まれます:\n• 学習目標\n• 成功基準\n• ガイド付きチャレンジ\n• 評価ルーブリック';

  @override
  String get emergencyNotificationTitle => '重要なお知らせ';

  @override
  String get enterScenarioNameEditorHint => 'シナリオ名を入力-エディターヒント';

  @override
  String get equipotentialSurfacesDescription => '等しい重力ポテンシャルエネルギーの面を表示';

  @override
  String get equipotentialSurfacesLabel => '等ポテンシャル面';

  @override
  String get exit => '終了';

  @override
  String get exitAppMessage => '本当にGravitonを終了しますか？';

  @override
  String get exitAppTitle => 'アプリを終了';

  @override
  String get expandedState => '展開済み';

  @override
  String failedToSwitchScenarioError(String error) {
    return 'シナリオ切り替えエラー';
  }

  @override
  String get fieldOfViewLabel => '視野角';

  @override
  String get focusOnNearestTooltip => '最寄りの天体にフォーカス';

  @override
  String get followLabel => '追従';

  @override
  String get followObjectTooltip => '選択したオブジェクトを追跡';

  @override
  String get getStarted => '始める！';

  @override
  String get globalGravityFieldsDescription => 'すべての大質量オブジェクトの重力場可視化を有効にする';

  @override
  String get globalGravityFieldsLabel => 'グローバル重力場';

  @override
  String get gotItButton => '了解！';

  @override
  String get gravitationalConstant => '重力定数';

  @override
  String get greenColor => '緑色';

  @override
  String get habitabilityHabitable => '居住可能';

  @override
  String get habitabilityIndicatorsDescription =>
      '居住可能性に基づく惑星周りの色分けされた状態リングを表示';

  @override
  String get habitabilityIndicatorsLabel => '惑星の状態';

  @override
  String get habitabilityLabel => '居住可能性';

  @override
  String get habitabilityTooCold => '低温すぎ';

  @override
  String get habitabilityTooHot => '高温すぎ';

  @override
  String get habitabilityUnknown => '不明';

  @override
  String get habitabilityGasGiant => 'ガス惑星';

  @override
  String get habitabilityTooSmall => '小さすぎ';

  @override
  String get habitabilityNoAtmosphere => '大気なし';

  @override
  String get habitabilityToxicAtmosphere => '有毒大気';

  @override
  String get habitabilityHighRadiation => '高放射線';

  @override
  String get habitabilityTidallyLocked => '潮汐固定';

  @override
  String get habitabilityExtremeGravity => '極限重力';

  @override
  String get habitableZonesDescription => '居住可能な領域を示す星の周りの色付きゾーンを表示';

  @override
  String get habitableZonesLabel => 'ハビタブルゾーン';

  @override
  String get hapticsSection => 'ハプティクス';

  @override
  String get hideUIInScreenshotMode => 'ナビゲーションを非表示';

  @override
  String get hideUIInScreenshotModeSubtitle =>
      'スクリーンショットモードがアクティブな時にアプリバー、ボトムナビゲーション、コピーライトを非表示にする';

  @override
  String get initialMotionVectorsDescription => '初期運動ベクトルの説明';

  @override
  String invalidJsonFormat(String error) {
    return '無効なJSONフォーマット';
  }

  @override
  String get invertPitchControlsDescription => '上下ドラッグ方向を反転';

  @override
  String get invertPitchControlsLabel => 'ピッチ操作を反転';

  @override
  String get jupiterTanColor => '木星タン色';

  @override
  String get keyboardShortcutsHint => 'スペースで一時停止/再開、Rで再開、Cでカメラ中央揃え、Aで自動回転切り替え';

  @override
  String get languageChinese => '中文';

  @override
  String get languageDescription => 'アプリの言語を変更';

  @override
  String get languageSelectionHint => '優先する表示言語を選択してください';

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
  String get languageLabel => '一般';

  @override
  String get temperatureUnitsLabel => '温度単位';

  @override
  String get temperatureUnitsDescription => 'アプリ全体で温度を表示する際の優先単位';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageSystem => 'システムデフォルト';

  @override
  String get lightEnergyOutputDescription => '光エネルギー出力の説明';

  @override
  String get loadingVersion => 'バージョンを読み込み中...';

  @override
  String get luminosityEditorLabel => '光度エディターラベル';

  @override
  String get luminosityWEditorhint => '光度をワットで入力-エディターヒント';

  @override
  String get maintenanceTitle => 'メンテナンス';

  @override
  String get manualControlDescription => '完全な手動カメラ制御';

  @override
  String get manualControlsTitle => '手動制御';

  @override
  String get marketingLabel => 'マーケティング';

  @override
  String get marsRedColor => '火星赤色';

  @override
  String get maxTrailPointsInvalid => '最大軌跡ポイント数が無効';

  @override
  String get maximum50BodiesAllowed => '最大50個の天体まで許可';

  @override
  String get mercuryGrayColor => '水星グレー色';

  @override
  String get missingRequiredFieldBodies => '必須フィールド「天体」が不足';

  @override
  String get missingRequiredFieldConfiguration => '必須フィールド「設定」が不足';

  @override
  String get missingRequiredFieldMetadata => '必須フィールド「メタデータ」が不足';

  @override
  String get missingRequiredFieldParticleSystems => '必須フィールド「粒子システム」が不足';

  @override
  String get missingRequiredFieldPhysics => '必須フィールド「物理」が不足';

  @override
  String get missingRequiredFieldVersion => '必須フィールド「バージョン」が不足';

  @override
  String get moreOptionsTooltip => 'その他のオプション';

  @override
  String get navigationAidsTitle => 'ナビゲーション補助';

  @override
  String get neptuneBlueColor => '海王星ブルー色';

  @override
  String get newsTitle => 'ニュース';

  @override
  String get nextPreset => '次のプリセット';

  @override
  String get nextSceneTooltip => '次のシーンツールチップ';

  @override
  String get noActionsAvailable => '利用可能なアクションなし';

  @override
  String get noBodiesInSimulation => '現在シミュレーションに天体がありません';

  @override
  String get noChangelogsAvailable => '利用可能な変更履歴がありません';

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
  String get objectivesDescription =>
      '• 重力が宇宙をどう形作るかを理解\n• 安定対混沌軌道系を観察\n• なぜ惑星が楕円軌道で動くかを学習\n• 連星がどう相互作用するかを発見\n• オブジェクトが衝突するとどうなるかを観察\n• 三体問題の複雑さを理解';

  @override
  String get objectivesTitle => '学習目標';

  @override
  String get offScreenIndicatorsDescription => '可視領域外のオブジェクトを指す矢印を表示';

  @override
  String get offScreenIndicatorsTitle => '画面外インジケーター';

  @override
  String get orangeColor => 'オレンジ色';

  @override
  String get particleSystemsEditortitle => '粒子システムエディタータイトル';

  @override
  String get pathVisualizationTitle => '軌道の可視化';

  @override
  String get physicalPropertiesDescription => '物理プロパティの説明';

  @override
  String get pinchToZoomInOut => 'ピンチでズームイン・アウト';

  @override
  String get pitchLabel => 'ピッチ';

  @override
  String get positionEditorLabel => '位置エディターラベル';

  @override
  String get predictiveOrbitalDescription => 'AIが最適な軌道視点を予測';

  @override
  String get previousPreset => '前のプリセット';

  @override
  String get previousSceneTooltip => '前のシーンツールチップ';

  @override
  String get privacyPolicyLabel => 'プライバシーポリシー';

  @override
  String get promotionTitle => 'プロモーション';

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
  String get quickStartDescription =>
      '1. シナリオを選択（初心者には太陽系推奨）\n2. 再生を押してシミュレーション開始\n3. ドラッグでビュー回転、ピンチでズーム\n4. 速度スライダーをタップして時間制御\n5. リセットで新しいランダム構成を試行\n6. 軌跡を有効にして軌道パスを表示';

  @override
  String get quickStartTitle => 'クイックスタートガイド';

  @override
  String get quickTutorialButton => 'クイックチュートリアル';

  @override
  String get radiusMEditorhint => '半径をメートルで入力-エディターヒント';

  @override
  String get realisticColors => 'リアルな色';

  @override
  String get realisticColorsDescription => '温度と恒星分類に基づく科学的に正確な色を使用';

  @override
  String get redColor => '赤色';

  @override
  String get rollLabel => 'ロール';

  @override
  String get saturnCreamColor => '土星クリーム色';

  @override
  String get scenarioAsteroidBelt => '小惑星帯';

  @override
  String get scenarioAsteroidBeltDescription => '岩石の小惑星と破片の帯に囲まれた中央星';

  @override
  String get scenarioBestBinary => '最適対象: 高度な物理学探究';

  @override
  String get scenarioBestEarthMoon => '最適対象: 地球-月システムの理解';

  @override
  String get scenarioBestEmoji => '⭐';

  @override
  String get scenarioBestRandom => '最適対象: 探索と実験';

  @override
  String get scenarioBestSolar => '最適対象: 初心者、天文学愛好家';

  @override
  String get scenarioBestThreeBody => '最適対象: 数理物理学愛好家';

  @override
  String get scenarioBinaryStars => '連星';

  @override
  String get scenarioBinaryStarsDescription => '互いに軌道を描く二つの大質量星と周連星惑星';

  @override
  String get scenarioCustom => 'カスタムシナリオ';

  @override
  String get scenarioCustomDescription => 'カスタムシナリオの説明';

  @override
  String get scenarioEarthMoonSun => '地球-月-太陽';

  @override
  String get scenarioEarthMoonSunDescription => '馴染み深い地球-月-太陽系の教育的シミュレーション';

  @override
  String get scenarioGalaxyFormation => '銀河形成';

  @override
  String get scenarioGalaxyFormationDescription =>
      '中央のブラックホール周りに物質が螺旋構造に組織化される様子を観察';

  @override
  String get scenarioInformationEditortitle => 'シナリオ情報エディタータイトル';

  @override
  String get scenarioLearnBinary => '学習内容: 恒星進化、連星系、極端重力';

  @override
  String get scenarioLearnEarthMoon => '学習内容: 三体力学、月の力学、潮汐力';

  @override
  String get scenarioLearnEmoji => '🎯';

  @override
  String get scenarioLearnRandom => '学習内容: 未知の構成発見、実験物理学';

  @override
  String get scenarioLearnSolar => '学習内容: 惑星運動、軌道力学、身近な天体';

  @override
  String get scenarioLearnThreeBody => '学習内容: カオス理論、予測不可能な運動、不安定システム';

  @override
  String get scenarioNameRequired => 'シナリオ名が必要';

  @override
  String get scenarioNameTooLong => 'シナリオ名が長すぎます';

  @override
  String get scenarioPlanetaryRings => '惑星の環';

  @override
  String get scenarioPlanetaryRingsDescription => '土星のような大質量惑星周りの環系の動力学';

  @override
  String get scenarioRandom => 'ランダムシステム';

  @override
  String get scenarioRandomDescription => '予測不可能な動力学を持つランダムに生成された混沌とした三体系';

  @override
  String scenarioSaveFailedMessage(String error) {
    return 'シナリオ保存失敗';
  }

  @override
  String get scenarioSavedSuccessMessage => 'シナリオ保存成功';

  @override
  String get scenarioSelectorFocused => 'シナリオセレクターにフォーカス';

  @override
  String get scenarioSolarSystem => '太陽系';

  @override
  String get scenarioSolarSystemDescription => '内惑星と外惑星を含む太陽系の簡略版';

  @override
  String get scenarioSpecial => '特別シナリオ';

  @override
  String get scenarioSpecialDescription => 'スクリーンショットモード用の特別シナリオ';

  @override
  String get scenariosAvailable => '利用可能なシナリオ';

  @override
  String get scenariosMenuDescription => 'さまざまなシナリオを探索';

  @override
  String get sceneActive => 'シーンがアクティブ - スクリーンショット撮影のため一時停止中';

  @override
  String get scenePreset => 'シーンプリセット';

  @override
  String get scheduledMaintenanceInProgress => '定期メンテナンス中';

  @override
  String screenshotCountdown(int seconds) {
    return 'スクリーンショット $seconds秒後';
  }

  @override
  String get screenshotMode => 'スクリーンショットモード';

  @override
  String get screenshotModeSubtitle => 'マーケティング用スクリーンショット撮影のプリセットシーンを有効化';

  @override
  String get selectAColorForTheCelestialBody => '天体の色を選択';

  @override
  String get selectNearestTitle => '最近を選択';

  @override
  String get selectObjectToFollowTooltip => '追跡するオブジェクトを選択';

  @override
  String get selectScenarioTooltip => 'シナリオを選択';

  @override
  String get selectTheTypeOfCelestialBody => '天体のタイプを選択';

  @override
  String get selectedStatLabel => '選択済み';

  @override
  String get showHelpTooltip => 'ヘルプと目標';

  @override
  String get showLabelsDescription => 'シミュレーションで天体名を表示';

  @override
  String get showLabelsTitle => 'ラベル表示';

  @override
  String get showOrbitalPaths => '軌道パスを表示';

  @override
  String get showOrbitalPathsDescription => '安定した軌道を持つシナリオで予測された軌道パスを表示';

  @override
  String get showStatisticsDescription => 'パフォーマンスと物理統計を表示';

  @override
  String get showStatisticsTitle => '統計表示';

  @override
  String get showTrails => '軌跡を表示';

  @override
  String get showTrailsDescription => 'オブジェクトの後ろに動きの軌跡を表示';

  @override
  String get showTutorialTooltip => 'チュートリアルを表示';

  @override
  String get skipTutorial => 'スキップ';

  @override
  String get softeningParameter => 'ソフト化パラメータ';

  @override
  String get spatialCoordinatesDescription => '空間座標の説明';

  @override
  String get statusError => 'エラー';

  @override
  String get statusLabel => '状態';

  @override
  String get statusPaused => '一時停止中';

  @override
  String get statusRunning => '実行中';

  @override
  String get statusStopped => '停止';

  @override
  String get stellarColorBlue => '青';

  @override
  String get stellarColorBlueWhite => '青白';

  @override
  String get stellarColorOrange => '橙';

  @override
  String get stellarColorRed => '赤';

  @override
  String get stellarColorWhite => '白';

  @override
  String get stellarColorYellow => '黄';

  @override
  String get stellarColorYellowWhite => '黄白';

  @override
  String get stellarTemperatureDescription => '恒星温度の説明';

  @override
  String stepsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString';
  }

  @override
  String get stepsLabel => 'ステップ';

  @override
  String get successTitle => '成功';

  @override
  String get swipeUpToExpand => '上にスワイプして展開';

  @override
  String get tapPlayPauseButton => '再生・一時停止ボタンをタップ';

  @override
  String get tapResetButton => 'リセットボタンをタップ';

  @override
  String get tapToCenterCamera => 'タップしてカメラを中央に';

  @override
  String get tapToChangeScenario => 'タップしてシナリオを変更';

  @override
  String get tapToInteractWithSimulation => 'タップしてシミュレーションと相互作用';

  @override
  String get tapToOpenSettings => 'タップして設定を開く';

  @override
  String get tapToSelect => 'タップして選択';

  @override
  String get tapToToggleAutoRotation => 'タップして自動回転を切り替え';

  @override
  String get tapToToggleFullscreen => 'タップしてフルスクリーンを切り替え';

  @override
  String
  tapToViewAndEditDetailsBodyBodyTypeNameWithNumberUtilsFormatMassBodyMassEditorhint(
    String bodyType,
    String mass,
  ) {
    return 'タップして詳細を表示・編集-天体-天体タイプ-番号付き名前-ユーティル-フォーマット-質量-天体質量-エディターヒント';
  }

  @override
  String get trackingModeEssential => '必須のみ';

  @override
  String get trackingModeEssentialDescription => '重要なクラッシュとエラーのみ';

  @override
  String get trackingModeFull => '完全トラッキング';

  @override
  String get trackingModeFullDescription => 'すべての分析、クラッシュ、インタラクション';

  @override
  String get trackingModeLimited => '限定トラッキング';

  @override
  String get trackingModeLimitedDescription => 'ユーザーインタラクションのみ';

  @override
  String get trackingModeNone => 'トラッキングなし';

  @override
  String get trackingModeNoneDescription => 'データ収集なし';

  @override
  String get trailColorLabel => '軌跡の色';

  @override
  String get trailFadeRate => '軌跡のフェード率';

  @override
  String get trailLength => '軌跡の長さ';

  @override
  String get typeEditorLabel => 'タイプエディターラベル';

  @override
  String get uiHapticFeedback => 'UIハプティックフィードバック';

  @override
  String get unsavedChangesMessage => '未保存の変更メッセージ';

  @override
  String get unsavedChangesTitle => '未保存の変更';

  @override
  String get uranusCyanColor => '天王星シアン色';

  @override
  String get useKeyboardShortcutsForControls => 'コントロールにキーボードショートカットを使用';

  @override
  String get useZoomControls => 'ズームコントロールを使用';

  @override
  String get venusYellowColor => '金星イエロー色';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get versionStatusCurrent => '最新';

  @override
  String get versionStatusOutdated => '古いバージョン';

  @override
  String get vibrationEnabled => '振動有効';

  @override
  String get vibrationThrottle => '振動スロットル';

  @override
  String get warmTrails => '🔥 暖色';

  @override
  String get websiteLabel => 'ウェブサイト';

  @override
  String get whatToDoDescription =>
      'Gravitonは物理学の遊び場です：\n\n🪐 リアルな軌道力学を探索\n🌟 恒星進化と衝突を観察\n🎯 重力について学習\n🎮 異なるシナリオで実験\n📚 天体力学を理解\n🔄 無限のランダム構成を作成';

  @override
  String get whatToDoTitle => 'Gravitonでできること';

  @override
  String get whiteColor => '白色';

  @override
  String get xCoordinateEditorhint => 'X座標を入力-エディターヒント';

  @override
  String get xCoordinateLabel => 'X座標ラベル';

  @override
  String get xVelocityEditorhint => 'X速度を入力-エディターヒント';

  @override
  String get yCoordinateEditorhint => 'Y座標を入力-エディターヒント';

  @override
  String get yCoordinateLabel => 'Y座標ラベル';

  @override
  String get yVelocityEditorhint => 'Y速度を入力-エディターヒント';

  @override
  String get yawLabel => 'ヨー';

  @override
  String get yellowColor => '黄色';

  @override
  String get zCoordinateEditorhint => 'Z座標を入力-エディターヒント';

  @override
  String get zCoordinateLabel => 'Z座標ラベル';

  @override
  String get zVelocityEditorhint => 'Z速度を入力-エディターヒント';

  @override
  String orbitalEventCloseApproach(String distance) {
    return '接近アプローチ: $distance 単位';
  }

  @override
  String get accessibilityBodiesCombined => '結合された質量が新しい天体を作成します';

  @override
  String get accessibilityBodiesInMotion => '天体が現在動いています';

  @override
  String get accessibilityBodiesStopped => 'すべての天体が動きを停止しました';

  @override
  String get accessibilityBodiesResumed => '天体が再び動いています';

  @override
  String get accessibilityBodiesReset => 'すべての天体がリセットされました';

  @override
  String get accessibilityNewScenarioLoaded => '新しい天体で新しいシナリオがロードされました';

  @override
  String get accessibilityNewParametersLoaded => '新しい天体と物理パラメータがロードされました';

  @override
  String get scenarioTabPresets => 'プリセット';

  @override
  String get scenarioTabCustom => 'カスタム';

  @override
  String get savedScenariosTitle => '保存されたシナリオ';

  @override
  String get experimentsTitle => '実験';

  @override
  String get experimentsSubtitle => '興味深い物理概念を探求する';

  @override
  String customScenarioBodyCount(int count) {
    return '$count個の天体';
  }

  @override
  String get customScenarioCreatedToday => '今日作成';

  @override
  String get customScenarioCreatedYesterday => '昨日作成';

  @override
  String customScenarioCreatedDaysAgo(int count, Object days) {
    return '$days日前に作成';
  }

  @override
  String customScenarioCreatedWeeksAgo(int count, Object weeks) {
    return '$weeks週間前に作成';
  }

  @override
  String customScenarioCreatedMonthsAgo(int count, Object months) {
    return '$monthsヶ月前に作成';
  }

  @override
  String get customScenarioCreatedUnknown => '作成日不明';

  @override
  String get orbitalPlacementEditor => '軌道配置';

  @override
  String get placeInOrbitButton => '軌道に配置';

  @override
  String get centralBodySelector => '中心天体';

  @override
  String get orbitRadiusEditor => '軌道半径';

  @override
  String get orbitPhaseEditor => '軌道位相';

  @override
  String get orbitInclinationEditor => '傾斜角';

  @override
  String get circularOrbitOption => '円軌道';

  @override
  String get ellipticalOrbitOption => '楕円軌道';

  @override
  String orbitalPeriodDisplay(String period) {
    return '周期: $period';
  }

  @override
  String get noAvailableCentralBodies => '軌道配置に使用可能な他の天体がありません';

  @override
  String get orbitalPlacementDescription => 'この天体を他の天体の周りをリアルな物理で軌道運動するよう設定';

  @override
  String get orbitalPlacementActiveDescription =>
      '軌道配置が有効です。位置と速度は以下の軌道パラメータに基づいて自動的に計算されます。';

  @override
  String get showGravitationalFieldVisualization => 'この天体の重力場可視化を表示';

  @override
  String get cancelOrbitalPlacement => '軌道配置をキャンセル';

  @override
  String get makeStable => '安定化';

  @override
  String get orbitalWarningMassiveBody =>
      '⚠️ 警告：周回天体は中心天体に対して非常に質量が大きいです。これは不安定な軌道を引き起こしたり、天体同士が周回し合う可能性があります。';

  @override
  String get orbitalTipSignificantMass =>
      '💡 ヒント：これは大きな質量比です。安定性のため軌道距離を増加することを考慮してください。';

  @override
  String get orbitalWarningCloseOrbit => '⚠️ 警告：非常に近い軌道。衝突や潮汐破壊のリスクがあります。';

  @override
  String get orbitalTipDistantOrbit =>
      '💡 ヒント：遠い軌道。他の天体からの重力の影響がこの軌道を摂動させる可能性があります。';

  @override
  String get orbitalGoodConfiguration => '✅ 安定したシステムのための良い軌道構成。';

  @override
  String get orbitalError => 'エラー';

  @override
  String get orbitalConfigurationWarning =>
      'この軌道構成は衝突や放出につながる可能性があります。「安定化」ボタンの使用を検討してください。';

  @override
  String get defaultBodyName => '天体';

  @override
  String get orbitalPeriodLabel => '軌道周期';

  @override
  String get orbitIsStable => '軌道は安定';

  @override
  String get orbitMayBeUnstable => '軌道が不安定な可能性';

  @override
  String bodyTypeGeneric(String bodyType) {
    return '$bodyType天体';
  }

  @override
  String orbitalRadiusIncreasedFeedback(String amount) {
    return '$amount単位増加';
  }

  @override
  String orbitalRadiusDecreasedFeedback(String amount) {
    return '$amount単位減少';
  }

  @override
  String get orbitalRadiusFineTunedFeedback => '微調整';

  @override
  String orbitStabilizedMessage(String changeDescription, String finalRadius) {
    return '軌道が安定化されました！半径が$changeDescriptionして$finalRadius単位になりました。位相と傾斜角が安定性のためにリセットされました。';
  }

  @override
  String get experimentBinaryPulsarName => '連星パルサー';

  @override
  String get experimentBinaryPulsarDescription => '重力波により内側に螺旋運動する2つの中性子星';

  @override
  String get experimentBinaryPulsarDuration => '100年';

  @override
  String get binaryPulsarPulsarA => 'パルサーA';

  @override
  String get binaryPulsarNeutronStarB => '中性子星B';

  @override
  String get binaryPulsarScenarioDescription =>
      'このシナリオは以下を実演します：極端な重力場、相対論的効果、重力波放出、軌道減衰。中性子星は時間とともにゆっくりと内向きにスパイラルし、最終的に重力波を生成する壊滅的な衝突で合体します。';

  @override
  String get binaryPulsarAuthor => 'Graviton物理学実験';

  @override
  String get binaryPulsarEducationalFocus => '相対性理論と重力波';

  @override
  String get experimentTrojanAsteroidsName => 'トロヤ群小惑星';

  @override
  String get experimentTrojanAsteroidsDescription => '木星の軌道上で小惑星が蓄積する安定点';

  @override
  String get experimentTrojanAsteroidsDuration => '50年';

  @override
  String get trojanAsteroidsSun => '太陽';

  @override
  String get trojanAsteroidsJupiter => '木星';

  @override
  String trojanAsteroidsL4Name(int number) {
    return 'L4トロヤ群$number';
  }

  @override
  String trojanAsteroidsL5Name(int number) {
    return 'L5トロヤ群$number';
  }

  @override
  String get trojanAsteroidsScenarioDescription =>
      'このシナリオは以下を実演します：ラグランジュ点、安定な軌道力学、三体力学、重力平衡。トロヤ群小惑星は木星の60度前後の安定した位置に留まり、重力平衡に捕らわれています。';

  @override
  String get trojanAsteroidsEducationalFocus => 'ラグランジュ点と軌道安定性';

  @override
  String get experimentDoubleStarEclipseName => '連星食';

  @override
  String get experimentDoubleStarEclipseDescription => '一つの星が定期的にもう一つの星を隠す連星系';

  @override
  String get experimentDoubleStarEclipseDuration => '30日';

  @override
  String get experimentRoguePlanetName => '放浪惑星';

  @override
  String get experimentRoguePlanetDescription => '系から追放された惑星が新しい太陽系に遭遇';

  @override
  String get experimentRoguePlanetDuration => '500年';

  @override
  String get experimentGravitationalSlingshotName => '重力アシスト';

  @override
  String get experimentGravitationalSlingshotDescription =>
      '宇宙船は木星の衛星イオを利用して加速し、エウロパに到達する';

  @override
  String get experimentGravitationalSlingshotDuration => '2年';

  @override
  String get experimentDifficultyAdvanced => '上級';

  @override
  String get experimentDifficultyIntermediate => '中級';

  @override
  String get experimentDifficultyBeginner => '初心者';

  @override
  String experimentComingSoon(String scenarioName) {
    return '実験シナリオ「$scenarioName」- 近日公開！';
  }

  @override
  String get unknownValue => '不明';

  @override
  String get bodyPrimaryStar => '主星';

  @override
  String get bodySecondaryStar => '伴星';

  @override
  String get bodyInnerRockyPlanet => '内側岩石惑星';

  @override
  String get bodyHabitablePlanet => '居住可能惑星';

  @override
  String get bodyGasGiant => 'ガス巨星';

  @override
  String get bodyIceGiant => '氷巨星';

  @override
  String get bodyRoguePlanet => '浮遊惑星';

  @override
  String get authorGravitonPhysicsTeam => 'Graviton物理学チーム';

  @override
  String get doubleStarEclipseScenarioDescription =>
      '近接連星系で二つの星が互いに軌道を回る様子を観察してください。より小さな伴星が定期的により大きな主星の前を通過し、周期的な食を引き起こす様子をご覧ください。これは恒星測光、連星軌道力学、および天文学者が類似の通過方法を使用して系外惑星を発見する方法を実演します。';

  @override
  String get doubleStarEclipseEducationalFocus => '連星、食、恒星測光';

  @override
  String get roguePlanetScenarioDescription =>
      'よく間隔の空いた惑星軌道を持つ安定した太陽系が、星間空間から接近する巨大な浮遊惑星に遭遇します。侵入者の重力が繊細な軌道バランスを乱し、惑星を放出したり混沌とした重力相互作用を生み出す様子を観察してください。このシナリオは惑星系力学、重力スリングショット効果、および浮遊惑星が太陽系全体をどのように再形成できるかを実演します。';

  @override
  String get roguePlanetEducationalFocus => '浮遊惑星、重力遭遇、軌道破綻';

  @override
  String get simulationInfoTitle => 'シミュレーション情報';

  @override
  String get scenarioInfoTitle => 'シナリオ情報';

  @override
  String get scenarioNameLabel => 'シナリオ名';

  @override
  String get bodyStatisticsTitle => '天体統計';

  @override
  String get totalBodiesLabel => '総天体数';

  @override
  String get starsLabel => '恒星';

  @override
  String get planetsLabel => '惑星';

  @override
  String get asteroidsLabel => '小惑星';

  @override
  String get blackHolesLabel => 'ブラックホール';

  @override
  String get totalMassLabel => '総質量';

  @override
  String get habitableWorldsLabel => '居住可能世界';

  @override
  String get physicsInfoTitle => '物理情報';

  @override
  String get timeScaleLabel => '時間スケール';

  @override
  String get gravitationalConstantLabel => '重力定数';

  @override
  String get softeningParameterLabel => '軟化パラメータ';

  @override
  String get collisionRadiusLabel => '衝突半径';

  @override
  String get scenarioThreeBodyClassic => '古典的三体問題';

  @override
  String get scenarioThreeBodyClassicDescription => 'カオス力学を持つ古典的三体問題';

  @override
  String get scenarioCollisionDemo => '衝突デモ';

  @override
  String get scenarioCollisionDemoDescription => '天体間の衝突のデモンストレーション';

  @override
  String get scenarioDeepSpace => '深宇宙';

  @override
  String get scenarioDeepSpaceDescription => '深宇宙のランダムオブジェクト';

  @override
  String get systemEnergyLabel => 'システムエネルギー';

  @override
  String get kineticEnergyLabel => '運動エネルギー';

  @override
  String get potentialEnergyLabel => '位置エネルギー';

  @override
  String get angularMomentumLabel => '角運動量';

  @override
  String get centerOfMassLabel => '質量中心';

  @override
  String get velocityRangeLabel => '速度範囲';

  @override
  String get averageVelocityLabel => '平均速度';

  @override
  String get temperatureRangeLabel => '温度範囲';

  @override
  String get systemMomentumLabel => 'システム運動量';

  @override
  String get energyDynamicsTitle => 'エネルギーと力学';

  @override
  String get orbitalMechanicsTitle => '軌道力学';

  @override
  String get celestialBodiesTitle => '天体';

  @override
  String get bodyNameLabel => '天体名';

  @override
  String get bodyMassLabel => '天体質量';

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
  String get bodyTypeLabel => '天体タイプ';

  @override
  String get bodyHabitabilityLabel => '天体居住可能性';

  @override
  String get bodyKineticEnergyLabel => '天体運動エネルギー';

  @override
  String get bodyEscapeVelocityLabel => '脱出速度';

  @override
  String get bodyDistanceFromCenterLabel => '中心からの距離';

  @override
  String get bodyOrbitalPeriodLabel => '軌道周期';

  @override
  String get notApplicableValue => '該当なし';

  @override
  String get habitableStatus => '居住可能';

  @override
  String get unknownHabitabilityStatus => '不明';

  @override
  String get tooHotStatus => '高温すぎ';

  @override
  String get tooColdStatus => '低温すぎ';

  @override
  String get noAtmosphereStatus => '大気なし';

  @override
  String get selectBody => '天体を選択';

  @override
  String get noBodiesAvailable => '利用可能な天体がありません';

  @override
  String get share => '共有';

  @override
  String get shareSimulation => 'シミュレーションを共有';

  @override
  String get shareImage => '画像を共有';

  @override
  String get shareImageDescription => '現在のビューをキャプチャして共有';

  @override
  String get shareState => '状態を共有';

  @override
  String get shareStateDescription => 'インポート可能なファイルとしてシミュレーションデータをエクスポート';

  @override
  String get shareSuccess => '共有に成功しました';

  @override
  String get shareFailed => '共有に失敗しました';

  @override
  String get shareImageError => '画像をキャプチャできません。もう一度お試しください。';

  @override
  String get shareSubject => 'Gravitonシミュレーション';

  @override
  String get shareSnapshotSubject => 'Gravitonシミュレーションスナップショット';

  @override
  String get shareText => 'この重力シミュレーションをチェックしてください！';

  @override
  String get importScenario => 'シナリオをインポート';

  @override
  String get importScenarioDescription => 'JSONファイルからシナリオを読み込む';

  @override
  String get importSuccess => 'シナリオが正常にインポートされました';

  @override
  String get importFailed => 'シナリオのインポートに失敗しました';

  @override
  String get importInvalidFile => 'ファイル形式が無効です。有効なJSONファイルを選択してください。';

  @override
  String get importFileNotFound => 'ファイルが見つかりません。もう一度お試しください。';

  @override
  String get importCancelled => 'インポートがキャンセルされました';

  @override
  String get accountManagementTitle => 'アカウント';

  @override
  String get accountButtonTooltip => 'アカウントとプロフィール';

  @override
  String get signInPromptTitle => 'アカウントにサインイン';

  @override
  String get signInPromptMessage => 'アカウントを作成またはサインインして、デバイス間でデータと設定を同期します。';

  @override
  String get signInButton => 'サインイン';

  @override
  String get signOutButton => 'サインアウト';

  @override
  String get resetSessionButton => 'セッションをリセット';

  @override
  String get signOutSuccess => 'サインアウトに成功しました';

  @override
  String get operationTimeout => '操作がタイムアウトしました。もう一度お試しください。';

  @override
  String get operationFailed => '操作が失敗しました。もう一度お試しください。';

  @override
  String get couldNotOpenLink => 'リンクを開けませんでした。もう一度お試しください。';

  @override
  String get pleaseWaitBeforeRetrying => 'もう一度試す前に少しお待ちください。';

  @override
  String rateLimitWithCooldown(int seconds) {
    return 'もう一度試す前に$seconds秒お待ちください。';
  }

  @override
  String get networkError => 'ネットワークエラー。接続を確認してもう一度お試しください。';

  @override
  String get continueAsGuestButton => 'ゲストとして続ける';

  @override
  String get signInAnonymousSuccess => 'ゲストとしてサインインしました';

  @override
  String get anonymousUserLabel => 'ゲストユーザー';

  @override
  String get guestAccountLabel => 'ゲストアカウント';

  @override
  String get authenticatedLabel => 'アカウント';

  @override
  String get changeAvatarTooltip => 'アバターを変更';

  @override
  String get editDisplayNameTooltip => '名前を編集';

  @override
  String get accountActionsSection => 'アカウント操作';

  @override
  String get upgradeAccountTitle => '完全なアカウントにアップグレード';

  @override
  String get upgradeAccountDescription => 'データを保存し、どのデバイスからでもアクセスできます';

  @override
  String get accountManagementSection => 'アカウント管理';

  @override
  String get dangerZoneSection => 'アカウント管理';

  @override
  String get deleteAccountButton => 'アカウントを削除';

  @override
  String get avatarChangedSuccess => 'アバターを更新しました';

  @override
  String get avatarChangedError => 'アバターの更新に失敗しました';

  @override
  String get accountMenuDescription => 'アカウントとプロフィールを管理';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get createAccountButton => 'アカウントを作成';

  @override
  String get pleaseEnterEmail => 'メールアドレスを入力してください';

  @override
  String get pleaseEnterValidEmail => '有効なメールアドレスを入力してください';

  @override
  String get pleaseEnterPassword => 'パスワードを入力してください';

  @override
  String get passwordMinLength => 'パスワードは6文字以上である必要があります';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？サインイン';

  @override
  String get needAccount => 'アカウントが必要ですか？作成する';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get continueWithGitHub => 'GitHubで続ける';

  @override
  String get continueWithApple => 'Appleで続ける';

  @override
  String get moreProviders => '他のプロバイダー';

  @override
  String get chooseProvider => 'プロバイダーを選択';

  @override
  String get selectAvatarTitle => 'アバターを選択';

  @override
  String get editAccountInformationTitle => '表示名を編集';

  @override
  String get displayNameLabel => '表示名';

  @override
  String get pleaseEnterDisplayName => '表示名を入力してください';

  @override
  String get displayNameMinLength => '名前は2文字以上である必要があります';

  @override
  String get deleteAccountTitle => 'アカウントを削除';

  @override
  String get deleteAccountWarning => 'この操作は元に戻せません。';

  @override
  String get deleteAccountMessage => 'アカウントを削除すると、それに関連するすべてのデータが完全に削除されます。';

  @override
  String get deleteAccountItem1 => 'プロフィールとアバター';

  @override
  String get deleteAccountItem2 => 'すべての保存された設定';

  @override
  String get deleteAccountItem3 => 'カスタムシナリオと設定';

  @override
  String get deleteAccountItem4 => 'アカウント認証';

  @override
  String get deleteAccountPasswordPrompt => '確認のためパスワードを入力してください：';

  @override
  String get orDivider => 'または';

  @override
  String get displayNameHint => 'お名前を入力してください（任意）';

  @override
  String get emailHint => 'メールアドレス';

  @override
  String get passwordHint => 'パスワード';

  @override
  String get alreadyHaveAccountSignIn => 'すでにアカウントをお持ちですか？ログイン';

  @override
  String get needAccountCreateOne => 'アカウントをお持ちでないですか？作成する';

  @override
  String get useGoogleProfilePhoto => 'Googleプロフィール写真を使用';

  @override
  String get customAvatars => 'カスタムアバター';

  @override
  String get saveAvatar => 'アバターを保存';

  @override
  String get displayNameFieldLabel => '表示名';

  @override
  String get displayNameFieldHint => '表示名を入力してください';

  @override
  String get saveAccountInformation => 'アカウント情報を保存';

  @override
  String get emailRequired => 'メールアドレスは必須です';

  @override
  String get emailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get passwordRequired => 'パスワードは必須です';

  @override
  String get passwordTooShort => 'パスワードは8文字以上である必要があります';

  @override
  String get passwordMissingUppercase => 'パスワードには少なくとも1つの大文字が必要です';

  @override
  String get passwordMissingLowercase => 'パスワードには少なくとも1つの小文字が必要です';

  @override
  String get passwordMissingNumber => 'パスワードには少なくとも1つの数字が必要です';

  @override
  String get passwordMissingSpecialChar =>
      'パスワードには少なくとも1つの特殊文字が必要です (!@#\$%^&*...)';

  @override
  String get tooManyAttempts => 'サインイン試行が多すぎます。15分後に再試行してください。';

  @override
  String get emailVerificationRequired =>
      'この機能にアクセスする前に、メールアドレスを確認してください。受信トレイで確認リンクを確認してください。';

  @override
  String get defaultUserName => 'ユーザー';

  @override
  String get googleSignInError => 'Googleログインがキャンセルされたか失敗しました。もう一度お試しください。';

  @override
  String get gitHubSignInError => 'GitHubログインがキャンセルされたか失敗しました。もう一度お試しください。';

  @override
  String get appleSignInError => 'Appleログインがキャンセルされたか失敗しました。もう一度お試しください。';

  @override
  String get displayNameUpdated => '表示名を更新しました';

  @override
  String get displayNameUpdateFailed => '表示名の更新に失敗しました';

  @override
  String get sessionResetSuccess => 'セッションを正常にリセットしました';

  @override
  String get accountDeletedSuccess => 'アカウントを正常に削除しました';

  @override
  String get errorUserNotFound => 'このメールアドレスのアカウントが見つかりません。';

  @override
  String get errorWrongPassword => 'パスワードが正しくありません。もう一度お試しください。';

  @override
  String get errorInvalidEmail => 'メールアドレスの形式が無効です。';

  @override
  String get errorUserDisabled => 'このアカウントは無効化されています。';

  @override
  String get errorEmailInUse => 'このメールアドレスのアカウントは既に存在します。';

  @override
  String get errorWeakPassword => 'パスワードが弱すぎます。より強力なパスワードを使用してください。';

  @override
  String get errorOperationNotAllowed => 'このログイン方法は有効になっていません。';

  @override
  String get errorRequiresRecentLogin => 'この操作を実行するには、もう一度ログインしてください。';

  @override
  String get errorNetworkFailed => 'ネットワークエラー。接続を確認してください。';

  @override
  String errorUnknown(String message) {
    return 'エラーが発生しました：$message';
  }

  @override
  String get exceptionGoogleSignInNotInitialized => 'Googleサインインが初期化されていません';

  @override
  String get exceptionGoogleSignInTimeout => 'Googleサインインがタイムアウトしました';

  @override
  String get exceptionAppleSignInPlatform =>
      'Apple Sign-InはAppleプラットフォームでのみ利用可能です';

  @override
  String get exceptionNoAnonymousUser => 'リンクする匿名ユーザーがありません';

  @override
  String get exceptionNoUserSignedIn => 'サインインしているユーザーがいません';

  @override
  String get firebaseErrorUserNotFound => 'このメールアドレスのアカウントが見つかりません。';

  @override
  String get firebaseErrorWrongPassword => 'パスワードが正しくありません。もう一度お試しください。';

  @override
  String get firebaseErrorInvalidEmail => 'メールアドレスの形式が無効です。';

  @override
  String get firebaseErrorUserDisabled => 'このアカウントは無効になっています。';

  @override
  String get firebaseErrorEmailInUse => 'このメールアドレスのアカウントは既に存在します。';

  @override
  String get firebaseErrorWeakPassword => 'パスワードが弱すぎます。より強力なパスワードを使用してください。';

  @override
  String get firebaseErrorOperationNotAllowed => 'このサインイン方法は有効になっていません。';

  @override
  String get firebaseErrorRequiresRecentLogin => 'この操作を実行するには、再度サインインしてください。';

  @override
  String get firebaseErrorNetworkFailed => 'ネットワークエラー。接続を確認してください。';

  @override
  String get firebaseErrorAccountExistsWithDifferentCredential =>
      'このメールアドレスのアカウントは既に別のサインイン方法で存在しています。元の方法でサインインしてください。';

  @override
  String firebaseErrorDefault(String message) {
    return 'エラーが発生しました: $message';
  }

  @override
  String get emailVerificationSent => '確認メールを送信しました！受信トレイをご確認ください。';

  @override
  String get emailVerificationResent => '確認メールを再送信しました。';

  @override
  String get emailNotVerified => 'メール未確認';

  @override
  String get emailVerified => 'メール確認済み';

  @override
  String get verifyEmailAddress => 'メールアドレスを確認';

  @override
  String get verifyEmailMessage =>
      'すべての機能にアクセスするには、メールアドレスを確認してください。受信トレイで確認リンクを確認してください。';

  @override
  String get sendVerificationEmail => '確認メールを送信';

  @override
  String get resendVerificationEmail => '確認メールを再送信';

  @override
  String get checkVerificationStatus => '確認ステータスを確認';

  @override
  String get emailVerificationPending => 'メール確認保留中';

  @override
  String verificationEmailCooldown(int seconds) {
    return '別の確認メールをリクエストする前に、$seconds秒お待ちください。';
  }

  @override
  String get termsAndPrivacy => '利用規約とプライバシー';

  @override
  String get acceptTermsAndPrivacy => '利用規約とプライバシーポリシーに同意します';

  @override
  String get mustAcceptTerms => '続行するには、利用規約とプライバシーポリシーに同意する必要があります。';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get viewTermsOfService => '利用規約を表示';

  @override
  String get viewPrivacyPolicy => 'プライバシーポリシーを表示';

  @override
  String termsLastUpdated(String date) {
    return '最終更新: $date';
  }

  @override
  String privacyLastUpdated(String date) {
    return '最終更新: $date';
  }

  @override
  String get ageRequirement => 'アカウントを作成するには13歳以上である必要があります。';

  @override
  String get confirmAge => '私は13歳以上であることを確認します';

  @override
  String get exceptionEmailVerificationFailed =>
      'exceptionEmailVerificationFailed';

  @override
  String get exceptionEmailVerificationCooldown =>
      'exceptionEmailVerificationCooldown';

  @override
  String get exceptionTermsNotAccepted => 'exceptionTermsNotAccepted';

  @override
  String get collisionEffectsTitle => '衝突エフェクト';

  @override
  String get showCollisionDebris => '破片粒子';

  @override
  String get showCollisionDebrisDescription => '物理ベースの軌道を持つ衝突衝撃から放出される粒子';

  @override
  String get showCollisionShockwaves => '衝撃波リング';

  @override
  String get showCollisionShockwavesDescription => '衝突地点から衝撃力に応じて拡大するエネルギーリング';

  @override
  String get showCollisionEjection => '物質放出';

  @override
  String get showCollisionEjectionDescription => '高エネルギー衝撃時に排出される物質の渦巻く雲';

  @override
  String get showCollisionPlasmaJets => 'プラズマジェット';

  @override
  String get showCollisionPlasmaJetsDescription =>
      '大質量星衝突からの方向性のある超高温ストリーム（実験的）';
}
