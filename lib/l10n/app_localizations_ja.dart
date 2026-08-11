// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'あなたの持ち物を見つける';

  @override
  String get homeRecentMemories => '最近の思い出';

  @override
  String get homeNoMemoriesMatch => '検索に一致する思い出がありません。';

  @override
  String get homeEmptyTitle => 'ここにあなたの持ち物が表示されます。';

  @override
  String get homeEmptyBody => '写真を撮って、置き場所を PutMind に教えてください。';

  @override
  String get settingsTooltip => '設定';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'これは何ですか？どこにしまいましたか？';

  @override
  String get voiceGuidanceLabel => '音声ガイダンス';

  @override
  String get voiceGuidanceOn => 'オン';

  @override
  String get voiceGuidanceOff => 'オフ';

  @override
  String get capturePromptPreview => '写真を撮ったら、置き場所を話すか入力してください。';

  @override
  String get capturePromptGuiding => '音声ガイダンスを再生中…';

  @override
  String get capturePromptListening => '聞いています…自然に話すか、代わりに入力してください。';

  @override
  String get capturePromptEditing => '文字起こしを確認して保存してください。';

  @override
  String get captureTranscriptHint => '入力したい場合はこちらに書いてください…';

  @override
  String get captureRetake => '撮り直す';

  @override
  String get captureSave => 'メモリーを保存';

  @override
  String get captureSnapMessage => 'しまうものをパッと撮ってください。';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGroupGeneral => '一般';

  @override
  String get settingsGroupPrivacySecurity => 'プライバシーとセキュリティ';

  @override
  String get settingsGroupBackupPurchase => 'バックアップと購入';

  @override
  String get settingsGroupAbout => 'アバウト';

  @override
  String get settingsLanguageRowTitle => '言語';

  @override
  String get settingsLanguageRowSubtitle => 'アプリ／音声ガイダンス／音声認識のロケール';

  @override
  String get settingsVoiceGuidanceRowTitle => '音声ガイダンス';

  @override
  String get settingsVoiceGuidanceRowSubtitle => '聞く前に表示する案内';

  @override
  String get settingsDailyReminderRowTitle => '毎日のリマインダー';

  @override
  String get settingsDailyReminderOn => 'オン';

  @override
  String get settingsDailyReminderOffSuggested => 'オフ · 推奨 21:00';

  @override
  String get settingsAppLockRowTitle => 'アプリロック';

  @override
  String get settingsAppLockRowSubtitle => '生体認証（PINでの代替あり）';

  @override
  String get settingsAutoLockRowTitle => '自動ロック';

  @override
  String get settingsPrivacyRowTitle => 'プライバシー';

  @override
  String get settingsBackupRestoreRowTitle => 'バックアップと復元';

  @override
  String get settingsLastBackupRowTitle => '最後のバックアップ';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Lifetime を購入';

  @override
  String get settingsRestorePurchaseRowTitle => '購入を復元';

  @override
  String get settingsAboutPutMindRowTitle => 'PutMind について';

  @override
  String get languagePickerTitle => '言語';

  @override
  String get autoLockPickerTitle => '自動ロック';

  @override
  String get backupSheetTitle => 'バックアップと復元';

  @override
  String get backupSheetBody => '暗号化バックアップは後で連携します。今はレビュー用のUIモックです。';

  @override
  String get createBackup => 'バックアップ作成';

  @override
  String get restoreBackup => 'バックアップを復元';

  @override
  String get privacyDialogTitle => 'プライバシー';

  @override
  String get privacyDialogBody =>
      'あなたの思い出は、あなたのもののままです。\n\nPutMindはローカルファーストです：アカウントなし、PutMindのクラウドDBなし、そしてMVPではPutMindサーバーへの写真アップロードなし。\n\n音声は可能な限り端末内で認識します。バックアップファイルはあなたが管理します。';

  @override
  String get aboutDialogTitle => 'PutMind について';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => '閉じる';

  @override
  String get turnOnAppLockDialogTitle => 'アプリロックをオンにしますか？';

  @override
  String get turnOnAppLockDialogBody =>
      'PINの代替を含む生体認証で、この端末の思い出を保護します。\n\nPutMindにはアカウント／バックエンドがないため、忘れたPINはメールでリセットできません。生体認証が引き続き使える場合は、解除 → 設定 → PINを変更してください。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get enable => '有効にする';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => '無制限メモリーを解除済み';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime はすでに解除されています';

  @override
  String get unlockTitle => 'PutMindを解除';

  @override
  String get unlockSubtitle => 'アプリを解除するまで、思い出は非公開のままです。';

  @override
  String get unlockWithBiometrics => '生体認証で解除';

  @override
  String get unlockUsePin => 'PINを使う';

  @override
  String get pinBack => '戻る';

  @override
  String get enterPin => 'PINを入力';

  @override
  String get pinMockText => 'Step 1のモック：任意の4桁で解除できます。';

  @override
  String get onboardingSnapTitle => 'パッと撮る。';

  @override
  String get onboardingSnapBody => '片付けるものをサッと写真に。フォーム、フォルダー、カテゴリはありません。';

  @override
  String get onboardingSayWhereTitle => 'どこにしまったかを言う。';

  @override
  String get onboardingSayWhereBody =>
      'それが何か、どこにしまったかを自然に話す（または入力する）だけ。音声ガイダンスが両方を手伝います。';

  @override
  String get onboardingFindLaterTitle => 'あとで見つける。';

  @override
  String get onboardingFindLaterBody =>
      '必要なものがあったら、思い出を検索。PutMindが覚えているので、あなたは探さなくていい。';

  @override
  String get onboardingContinue => '続ける';

  @override
  String get onboardingGetStarted => '使い始める';

  @override
  String memoryDetailSaved(Object created) {
    return '$created に保存しました';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return '$created に保存 · $updated に更新';
  }

  @override
  String get memoryDetailEdit => '編集';

  @override
  String get memoryDetailReplacePhoto => '写真を置き換える';

  @override
  String get memoryDetailDelete => '削除';

  @override
  String get deleteDialogTitle => 'このメモリーを削除しますか？';

  @override
  String get deleteDialogBody => '写真とメモリーを、この端末から削除します。';

  @override
  String get deleteMemory => 'メモリーを削除';

  @override
  String get editMemoryDialogTitle => 'メモリーを編集';

  @override
  String get editMemoryHint => 'これは何ですか？どこにしまいましたか？';

  @override
  String get editMemorySave => '保存';

  @override
  String get paywallTitle => '無制限メモリーを解除';

  @override
  String get paywallBody => '無料の上限（20メモリー）に到達しました。既存のメモリーは引き続き使えます。';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · 1回限りの購入';

  @override
  String get paywallUnlockLifetime => 'Lifetime を解除';

  @override
  String get prototype => 'プロトタイプ';

  @override
  String get prototypePreviewStates => '状態のプレビュー';

  @override
  String get prototypeHint => 'このプロトタイプはPutMind MVPの一部ではありません（デバッグ用）。';

  @override
  String get protoHome => 'ホーム';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => '設定';

  @override
  String get protoUnlock => '解除';

  @override
  String get protoOnboarding => 'オンボーディング';

  @override
  String get protoEmptyHome => 'ホーム（空）';

  @override
  String get protoMemoryDetail => 'メモリー詳細';

  @override
  String get protoPaywall => 'ペイウォール';

  @override
  String get snackMemorySaved => 'メモリーを保存しました';

  @override
  String get snackMemoryUpdated => 'メモリーを更新しました';

  @override
  String get snackPhotoReplacedMock => '写真を置き換え（モック）';

  @override
  String get snackMemoryDeleted => 'メモリーを削除しました';

  @override
  String get snackAppLockMockInfo => 'アプリロックは、今後のステップで安全に保護します。今はUIモックです。';

  @override
  String get snackReminderSchedulingMock => 'リマインダーは今後連携します（モック）。';

  @override
  String get snackBackupCreatedMock => 'バックアップ作成（モック）';

  @override
  String get snackRestoreBackupMock => '復元は今後連携します（モック）';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime を解除しました（モック購入）';

  @override
  String get snackPurchaseRestoredMock => '購入を復元しました（モック）';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get voiceSearchTooltip => '音声検索';

  @override
  String get autoLockImmediately => 'すぐに';

  @override
  String get autoLockOneMinute => '1分後';

  @override
  String get autoLockFiveMinutes => '5分後';

  @override
  String get autoLockFifteenMinutes => '15分後';

  @override
  String get never => 'なし';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return '無制限メモリー · $price（1回） · $used/$limit 使用中';
  }
}
