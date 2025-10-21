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
  String bodyStar(int number) {
    return '恒星 $number';
  }

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
  String get privacyPolicyLabel => 'Privacy Policy';
}
