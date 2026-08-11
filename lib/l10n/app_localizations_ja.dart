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
  String get backupSheetBody =>
      '暗号化バックアップを作成して保存するか、以前のバックアップから復元します。バックアップパスワードはApp Lock PINとは別です。';

  @override
  String get createBackup => 'バックアップ作成';

  @override
  String get restoreBackup => 'バックアップを復元';

  @override
  String get backupPasswordCreateTitle => 'バックアップパスワードを設定';

  @override
  String get backupPasswordEnterTitle => 'バックアップパスワードを入力';

  @override
  String get backupPasswordLabel => 'バックアップパスワード';

  @override
  String get backupPasswordConfirmLabel => 'パスワードを確認';

  @override
  String get backupPasswordWarning =>
      'このパスワードを忘れると、PutMindはバックアップを復元できません。アカウントでの再設定はありません。';

  @override
  String get backupPasswordTooShort => '4文字以上にしてください。';

  @override
  String get backupPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get restoreConfirmTitle => '現在のメモリーを置き換えますか？';

  @override
  String get restoreConfirmBody => '復元すると、この端末のメモリーがバックアップの内容に置き換わります。元に戻せません。';

  @override
  String get snackBackupCreated => 'バックアップを作成しました';

  @override
  String get snackBackupRestored => 'バックアップを復元しました';

  @override
  String get snackBackupFailed => 'バックアップに失敗しました。現在のデータは変更されていません。';

  @override
  String get snackBackupWrongPassword => 'バックアップパスワードが違います。';

  @override
  String get snackBackupCorrupted => 'このバックアップファイルは破損しているか不完全です。';

  @override
  String get snackBackupUnsupported => 'このバックアップ版はサポートされていません。';

  @override
  String get snackBackupCancelled => 'バックアップをキャンセルしました。';

  @override
  String get paywallPurchasePending => '処理中…';

  @override
  String get snackLifetimeUnlocked => 'Lifetimeを解除しました';

  @override
  String get snackPurchaseRestored => '購入を復元しました';

  @override
  String get snackPurchaseRestoreNone => 'このアカウントのLifetime購入は見つかりませんでした。';

  @override
  String get snackPurchaseCancelled => '購入をキャンセルしました。';

  @override
  String get snackPurchaseFailed => '購入に失敗しました。もう一度お試しください。';

  @override
  String get snackPurchaseAlreadyOwned => 'Lifetimeはすでに購入済みです。';

  @override
  String get snackStoreUnavailable => 'ストアを利用できません。';

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
  String get pinUnlockHint => 'Enter your 4-digit App Lock PIN.';

  @override
  String get pinSetupTitle => 'Create App Lock PIN';

  @override
  String get pinConfirmTitle => 'Confirm PIN';

  @override
  String get pinMismatch => 'PINs did not match. Try again.';

  @override
  String get pinIncorrect => 'Incorrect PIN. Try again.';

  @override
  String get photoViewerSemantics => 'Memory photo, double-tap to zoom';

  @override
  String get microphoneDenied =>
      'Microphone access is needed for voice. You can type instead.';

  @override
  String get speechUnavailable =>
      'Speech recognition isn\'t available. Type your memory instead.';

  @override
  String get notificationPermissionDenied =>
      'Notification permission is required for Daily Reminder.';

  @override
  String get biometricFailed =>
      'Biometric unlock didn\'t work. Try again or use your PIN.';

  @override
  String get biometricUnavailable =>
      'Biometrics aren\'t available. Use your PIN to unlock.';

  @override
  String get snackAppLockEnabled => 'App Lock is on';

  @override
  String get dailyReminderNotificationTitle => 'PutMind';

  @override
  String get dailyReminderNotificationBody =>
      'Snap it. Say where. Find it later.';

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

  @override
  String get cameraPermissionTitle => 'カメラへのアクセスが必要です';

  @override
  String get cameraPermissionDenied =>
      'PutMindは片付けるものを撮影するためにカメラが必要です。設定で有効にできます。';

  @override
  String get cameraPermissionRetry => '再試行';

  @override
  String get cameraPermissionOpenSettings => '設定を開く';

  @override
  String get cameraUnavailableTitle => 'カメラを利用できません';

  @override
  String get cameraUnavailableBody => 'この端末でカメラを開けませんでした。もう一度お試しください。';

  @override
  String get cameraWebMockHint => 'Webプレビューではモックカメラを使います。シャッターをタップして続けてください。';

  @override
  String get captureReplaceTitle => '写真を置き換える';

  @override
  String get replacePhotoConfirmTitle => 'この写真を使いますか？';

  @override
  String get replacePhotoConfirmBody => 'このメモリーの写真を置き換えます。文字起こしはそのままです。';

  @override
  String get replacePhotoUsePhoto => 'この写真を使う';

  @override
  String get savingMemory => '保存中…';

  @override
  String get photoReplaced => '写真を置き換えました';

  @override
  String get saveMemoryFailed => 'メモリーを保存できませんでした。もう一度お試しください。';

  @override
  String get replacePhotoFailed => '写真を置き換えできませんでした。もう一度お試しください。';
}
