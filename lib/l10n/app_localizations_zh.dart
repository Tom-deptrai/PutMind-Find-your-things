// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get homeSearchPlaceholder => '查找你的物品';

  @override
  String get homeRecentMemories => '近期記憶';

  @override
  String get homeNoMemoriesMatch => '沒有任何記憶符合你的搜尋。';

  @override
  String get homeEmptyTitle => '你的物品會出現在這裡。';

  @override
  String get homeEmptyBody => '拍一張照片，並告訴 PutMind 你把它放在哪裡。';

  @override
  String get settingsTooltip => '設定';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => '這是什麼？你把它放在哪裡？';

  @override
  String get voiceGuidanceLabel => '語音引導';

  @override
  String get voiceGuidanceOn => '開啟';

  @override
  String get voiceGuidanceOff => '關閉';

  @override
  String get capturePromptPreview => '拍下照片，然後說出或輸入你放在哪裡。';

  @override
  String get capturePromptGuiding => '正在播放語音引導…';

  @override
  String get capturePromptListening => '正在聆聽…自然地說，或改用輸入。';

  @override
  String get capturePromptEditing => '檢查文字內容，然後儲存。';

  @override
  String get captureTranscriptHint => '如果你想輸入，就在這裡輸入…';

  @override
  String get captureRetake => '重拍';

  @override
  String get captureSave => '儲存記憶';

  @override
  String get captureSnapMessage => '拍下你正在收起的那樣東西。';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGroupGeneral => '一般';

  @override
  String get settingsGroupPrivacySecurity => '隱私與安全';

  @override
  String get settingsGroupBackupPurchase => '備份與購買';

  @override
  String get settingsGroupAbout => '關於';

  @override
  String get settingsLanguageRowTitle => '語言';

  @override
  String get settingsLanguageRowSubtitle => 'App、語音引導與語音區域';

  @override
  String get settingsVoiceGuidanceRowTitle => '語音引導';

  @override
  String get settingsVoiceGuidanceRowSubtitle => '開始聆聽前的提示';

  @override
  String get settingsDailyReminderRowTitle => '每日提醒';

  @override
  String get settingsDailyReminderOn => '開啟';

  @override
  String get settingsDailyReminderOffSuggested => '關閉 · 建議 21:00';

  @override
  String get settingsAppLockRowTitle => 'App 鎖定';

  @override
  String get settingsAppLockRowSubtitle => '生物辨識並提供 PIN 兜底';

  @override
  String get settingsAutoLockRowTitle => '自動鎖定';

  @override
  String get settingsPrivacyRowTitle => '隱私';

  @override
  String get settingsBackupRestoreRowTitle => '備份與還原';

  @override
  String get settingsLastBackupRowTitle => '上次備份';

  @override
  String get settingsUpgradeLifetimeRowTitle => '升級 Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => '還原購買';

  @override
  String get settingsAboutPutMindRowTitle => '關於 PutMind';

  @override
  String get languagePickerTitle => '語言';

  @override
  String get autoLockPickerTitle => '自動鎖定';

  @override
  String get backupSheetTitle => '備份與還原';

  @override
  String get backupSheetBody =>
      'Create an encrypted backup file you can save anywhere, or restore from a previous backup. The backup password is separate from App Lock PIN.';

  @override
  String get createBackup => '建立備份';

  @override
  String get restoreBackup => '還原備份';

  @override
  String get backupPasswordCreateTitle => 'Set backup password';

  @override
  String get backupPasswordEnterTitle => 'Enter backup password';

  @override
  String get backupPasswordLabel => 'Backup password';

  @override
  String get backupPasswordConfirmLabel => 'Confirm password';

  @override
  String get backupPasswordWarning =>
      'If you forget this password, PutMind cannot recover the backup. There is no account reset.';

  @override
  String get backupPasswordTooShort => 'Use at least 4 characters.';

  @override
  String get backupPasswordMismatch => 'Passwords do not match.';

  @override
  String get restoreConfirmTitle => 'Replace current memories?';

  @override
  String get restoreConfirmBody =>
      'Restoring will replace memories on this device with the backup. This cannot be undone.';

  @override
  String get snackBackupCreated => 'Backup created';

  @override
  String get snackBackupRestored => 'Backup restored';

  @override
  String get snackBackupFailed =>
      'Backup failed. Your current data was not changed.';

  @override
  String get snackBackupWrongPassword => 'Wrong backup password.';

  @override
  String get snackBackupCorrupted =>
      'This backup file is corrupted or incomplete.';

  @override
  String get snackBackupUnsupported => 'This backup version isn’t supported.';

  @override
  String get snackBackupCancelled => 'Backup cancelled.';

  @override
  String get paywallPurchasePending => 'Processing…';

  @override
  String get snackLifetimeUnlocked => 'Lifetime unlocked';

  @override
  String get snackPurchaseRestored => 'Purchase restored';

  @override
  String get snackPurchaseRestoreNone =>
      'No Lifetime purchase found for this account.';

  @override
  String get snackPurchaseCancelled => 'Purchase cancelled.';

  @override
  String get snackPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get snackPurchaseAlreadyOwned => 'Lifetime already purchased.';

  @override
  String get snackStoreUnavailable => 'Store is unavailable right now.';

  @override
  String get privacyDialogTitle => '隱私';

  @override
  String get privacyDialogBody =>
      '你的記憶仍然屬於你。\n\nPutMind 採用本機優先：沒有帳號、沒有 PutMind 雲端資料庫，且 MVP 不會把照片上傳到 PutMind 伺服器。\n\n語音辨識優先使用裝置上的能力。備份檔案由你管理。';

  @override
  String get aboutDialogTitle => '關於 PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => '關閉';

  @override
  String get turnOnAppLockDialogTitle => '要開啟 App 鎖定嗎？';

  @override
  String get turnOnAppLockDialogBody =>
      '使用生物辨識並搭配 PIN 兜底，將保護此裝置上的你的記憶。\n\nPutMind 沒有帳號/後端，所以忘記的 PIN 無法透過電子郵件重設。若生物辨識仍可使用：解鎖 → 設定 → 變更 PIN。';

  @override
  String get cancel => '取消';

  @override
  String get enable => '啟用';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => '已解鎖無限記憶';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime 已經解鎖';

  @override
  String get unlockTitle => '解鎖 PutMind';

  @override
  String get unlockSubtitle => '在你解鎖 App 前，你的記憶會保持私密。';

  @override
  String get unlockWithBiometrics => '使用生物辨識解鎖';

  @override
  String get unlockUsePin => '改用 PIN';

  @override
  String get pinBack => '返回';

  @override
  String get enterPin => '輸入 PIN';

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
  String get onboardingSnapTitle => '拍一下。';

  @override
  String get onboardingSnapBody => '快速拍下你正在收起的物品。不需要表單、資料夾或分類。';

  @override
  String get onboardingSayWhereTitle => '告訴我放在哪裡。';

  @override
  String get onboardingSayWhereBody =>
      '自然地說 — 或直接輸入 — 這是什麼、你把它放在哪裡。語音引導會幫你說完整。';

  @override
  String get onboardingFindLaterTitle => '之後再找。';

  @override
  String get onboardingFindLaterBody => '需要的時候就用搜尋找你的記憶。PutMind 會記得，你不用硬記。';

  @override
  String get onboardingContinue => '繼續';

  @override
  String get onboardingGetStarted => '開始使用';

  @override
  String memoryDetailSaved(Object created) {
    return '已儲存 $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return '已儲存 $created · 已更新 $updated';
  }

  @override
  String get memoryDetailEdit => '編輯';

  @override
  String get memoryDetailReplacePhoto => '替換照片';

  @override
  String get memoryDetailDelete => '刪除';

  @override
  String get deleteDialogTitle => '刪除此記憶？';

  @override
  String get deleteDialogBody => '此操作會從此裝置移除照片與記憶。';

  @override
  String get deleteMemory => '刪除記憶';

  @override
  String get editMemoryDialogTitle => '編輯記憶';

  @override
  String get editMemoryHint => '這是什麼？你把它放在哪裡？';

  @override
  String get editMemorySave => '儲存';

  @override
  String get paywallTitle => '解鎖無限記憶';

  @override
  String get paywallBody => '你已達到免費上限 20 則記憶。既有記憶仍可使用。';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · 一次性購買';

  @override
  String get paywallUnlockLifetime => '解鎖 Lifetime';

  @override
  String get snackMemorySaved => '已儲存記憶';

  @override
  String get snackMemoryUpdated => '已更新記憶';

  @override
  String get snackPhotoReplacedMock => '已替換照片（示意）';

  @override
  String get snackMemoryDeleted => '已刪除記憶';

  @override
  String get snackAppLockMockInfo => 'App 鎖定會在之後步驟安全地儲存。現在只是介面狀態。';

  @override
  String get snackReminderSchedulingMock => '提醒會在之後步驟連接（示意）';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get voiceSearchTooltip => '語音搜尋';

  @override
  String get autoLockImmediately => 'Immediately';

  @override
  String get autoLockOneMinute => 'After 1 minute';

  @override
  String get autoLockFiveMinutes => 'After 5 minutes';

  @override
  String get autoLockFifteenMinutes => 'After 15 minutes';

  @override
  String get never => 'Never';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Unlimited memories · $price once · $used/$limit used';
  }

  @override
  String get cameraPermissionTitle => '需要相機權限';

  @override
  String get cameraPermissionDenied => 'PutMind 需要相機來拍攝你正在收起的物品。你可以在設定中開啟。';

  @override
  String get cameraPermissionRetry => '再試一次';

  @override
  String get cameraPermissionOpenSettings => '開啟設定';

  @override
  String get cameraUnavailableTitle => '無法使用相機';

  @override
  String get cameraUnavailableBody => '無法在此裝置開啟相機。請再試一次。';

  @override
  String get cameraWebMockHint => '網頁預覽使用模擬相機。點擊快門以繼續。';

  @override
  String get captureReplaceTitle => '替換照片';

  @override
  String get replacePhotoConfirmTitle => '使用這張照片？';

  @override
  String get replacePhotoConfirmBody => '這會替換此記憶的照片。文字內容保持不變。';

  @override
  String get replacePhotoUsePhoto => '使用照片';

  @override
  String get savingMemory => '儲存中…';

  @override
  String get photoReplaced => '已替換照片';

  @override
  String get saveMemoryFailed => '無法儲存此記憶。請再試一次。';

  @override
  String get replacePhotoFailed => '無法替換此照片。請再試一次。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get homeSearchPlaceholder => '查找你的物品';

  @override
  String get homeRecentMemories => '近期記憶';

  @override
  String get homeNoMemoriesMatch => '沒有任何記憶符合你的搜尋。';

  @override
  String get homeEmptyTitle => '你的物品會出現在這裡。';

  @override
  String get homeEmptyBody => '拍一張照片，並告訴 PutMind 你把它放在哪裡。';

  @override
  String get settingsTooltip => '設定';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => '這是什麼？你把它放在哪裡？';

  @override
  String get voiceGuidanceLabel => '語音引導';

  @override
  String get voiceGuidanceOn => '開啟';

  @override
  String get voiceGuidanceOff => '關閉';

  @override
  String get capturePromptPreview => '拍下照片，然後說出或輸入你放在哪裡。';

  @override
  String get capturePromptGuiding => '正在播放語音引導…';

  @override
  String get capturePromptListening => '正在聆聽…自然地說，或改用輸入。';

  @override
  String get capturePromptEditing => '檢查文字內容，然後儲存。';

  @override
  String get captureTranscriptHint => '如果你想輸入，就在這裡輸入…';

  @override
  String get captureRetake => '重拍';

  @override
  String get captureSave => '儲存記憶';

  @override
  String get captureSnapMessage => '拍下你正在收起的那樣東西。';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGroupGeneral => '一般';

  @override
  String get settingsGroupPrivacySecurity => '隱私與安全';

  @override
  String get settingsGroupBackupPurchase => '備份與購買';

  @override
  String get settingsGroupAbout => '關於';

  @override
  String get settingsLanguageRowTitle => '語言';

  @override
  String get settingsLanguageRowSubtitle => 'App、語音引導與語音區域';

  @override
  String get settingsVoiceGuidanceRowTitle => '語音引導';

  @override
  String get settingsVoiceGuidanceRowSubtitle => '開始聆聽前的提示';

  @override
  String get settingsDailyReminderRowTitle => '每日提醒';

  @override
  String get settingsDailyReminderOn => '開啟';

  @override
  String get settingsDailyReminderOffSuggested => '關閉 · 建議 21:00';

  @override
  String get settingsAppLockRowTitle => 'App 鎖定';

  @override
  String get settingsAppLockRowSubtitle => '生物辨識並提供 PIN 兜底';

  @override
  String get settingsAutoLockRowTitle => '自動鎖定';

  @override
  String get settingsPrivacyRowTitle => '隱私';

  @override
  String get settingsBackupRestoreRowTitle => '備份與還原';

  @override
  String get settingsLastBackupRowTitle => '上次備份';

  @override
  String get settingsUpgradeLifetimeRowTitle => '升級 Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => '還原購買';

  @override
  String get settingsAboutPutMindRowTitle => '關於 PutMind';

  @override
  String get languagePickerTitle => '語言';

  @override
  String get autoLockPickerTitle => '自動鎖定';

  @override
  String get backupSheetTitle => '備份與還原';

  @override
  String get backupSheetBody =>
      '建立加密備份檔並自行保存，或從先前備份還原。備份密碼與 App Lock PIN 完全分開。';

  @override
  String get createBackup => '建立備份';

  @override
  String get restoreBackup => '還原備份';

  @override
  String get backupPasswordCreateTitle => '設定備份密碼';

  @override
  String get backupPasswordEnterTitle => '輸入備份密碼';

  @override
  String get backupPasswordLabel => '備份密碼';

  @override
  String get backupPasswordConfirmLabel => '確認密碼';

  @override
  String get backupPasswordWarning => '若忘記此密碼，PutMind 無法還原備份。沒有帳號可重設。';

  @override
  String get backupPasswordTooShort => '請至少使用 4 個字元。';

  @override
  String get backupPasswordMismatch => '密碼不相符。';

  @override
  String get restoreConfirmTitle => '取代目前的記憶？';

  @override
  String get restoreConfirmBody => '還原會以備份內容取代此裝置上的記憶。無法復原。';

  @override
  String get snackBackupCreated => '已建立備份';

  @override
  String get snackBackupRestored => '已還原備份';

  @override
  String get snackBackupFailed => '備份失敗。目前資料未變更。';

  @override
  String get snackBackupWrongPassword => '備份密碼錯誤。';

  @override
  String get snackBackupCorrupted => '此備份檔損壞或不完整。';

  @override
  String get snackBackupUnsupported => '不支援此備份版本。';

  @override
  String get snackBackupCancelled => '已取消備份。';

  @override
  String get paywallPurchasePending => '處理中…';

  @override
  String get snackLifetimeUnlocked => '已解鎖 Lifetime';

  @override
  String get snackPurchaseRestored => '已還原購買';

  @override
  String get snackPurchaseRestoreNone => '此帳號找不到 Lifetime 購買紀錄。';

  @override
  String get snackPurchaseCancelled => '已取消購買。';

  @override
  String get snackPurchaseFailed => '購買失敗。請再試一次。';

  @override
  String get snackPurchaseAlreadyOwned => '已購買 Lifetime。';

  @override
  String get snackStoreUnavailable => '目前無法使用商店。';

  @override
  String get privacyDialogTitle => '隱私';

  @override
  String get privacyDialogBody =>
      '你的記憶仍然屬於你。\n\nPutMind 採用本機優先：沒有帳號、沒有 PutMind 雲端資料庫，且 MVP 不會把照片上傳到 PutMind 伺服器。\n\n語音辨識優先使用裝置上的能力。備份檔案由你管理。';

  @override
  String get aboutDialogTitle => '關於 PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => '關閉';

  @override
  String get turnOnAppLockDialogTitle => '要開啟 App 鎖定嗎？';

  @override
  String get turnOnAppLockDialogBody =>
      '使用生物辨識並搭配 PIN 兜底，將保護此裝置上的你的記憶。\n\nPutMind 沒有帳號/後端，所以忘記的 PIN 無法透過電子郵件重設。若生物辨識仍可使用：解鎖 → 設定 → 變更 PIN。';

  @override
  String get cancel => '取消';

  @override
  String get enable => '啟用';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => '已解鎖無限記憶';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime 已經解鎖';

  @override
  String get unlockTitle => '解鎖 PutMind';

  @override
  String get unlockSubtitle => '在你解鎖 App 前，你的記憶會保持私密。';

  @override
  String get unlockWithBiometrics => '使用生物辨識解鎖';

  @override
  String get unlockUsePin => '改用 PIN';

  @override
  String get pinBack => '返回';

  @override
  String get enterPin => '輸入 PIN';

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
  String get onboardingSnapTitle => '拍一下。';

  @override
  String get onboardingSnapBody => '快速拍下你正在收起的物品。不需要表單、資料夾或分類。';

  @override
  String get onboardingSayWhereTitle => '告訴我放在哪裡。';

  @override
  String get onboardingSayWhereBody =>
      '自然地說 — 或直接輸入 — 這是什麼、你把它放在哪裡。語音引導會幫你說完整。';

  @override
  String get onboardingFindLaterTitle => '之後再找。';

  @override
  String get onboardingFindLaterBody => '需要的時候就用搜尋找你的記憶。PutMind 會記得，你不用硬記。';

  @override
  String get onboardingContinue => '繼續';

  @override
  String get onboardingGetStarted => '開始使用';

  @override
  String memoryDetailSaved(Object created) {
    return '已儲存 $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return '已儲存 $created · 已更新 $updated';
  }

  @override
  String get memoryDetailEdit => '編輯';

  @override
  String get memoryDetailReplacePhoto => '替換照片';

  @override
  String get memoryDetailDelete => '刪除';

  @override
  String get deleteDialogTitle => '刪除此記憶？';

  @override
  String get deleteDialogBody => '此操作會從此裝置移除照片與記憶。';

  @override
  String get deleteMemory => '刪除記憶';

  @override
  String get editMemoryDialogTitle => '編輯記憶';

  @override
  String get editMemoryHint => '這是什麼？你把它放在哪裡？';

  @override
  String get editMemorySave => '儲存';

  @override
  String get paywallTitle => '解鎖無限記憶';

  @override
  String get paywallBody => '你已達到免費上限 20 則記憶。既有記憶仍可使用。';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · 一次性購買';

  @override
  String get paywallUnlockLifetime => '解鎖 Lifetime';

  @override
  String get snackMemorySaved => '已儲存記憶';

  @override
  String get snackMemoryUpdated => '已更新記憶';

  @override
  String get snackPhotoReplacedMock => '已替換照片（示意）';

  @override
  String get snackMemoryDeleted => '已刪除記憶';

  @override
  String get snackAppLockMockInfo => 'App 鎖定會在之後步驟安全地儲存。現在只是介面狀態。';

  @override
  String get snackReminderSchedulingMock => '提醒會在之後步驟連接（示意）';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get voiceSearchTooltip => '語音搜尋';

  @override
  String get autoLockImmediately => '立即';

  @override
  String get autoLockOneMinute => '1分鐘後';

  @override
  String get autoLockFiveMinutes => '5分鐘後';

  @override
  String get autoLockFifteenMinutes => '15分鐘後';

  @override
  String get never => '从不';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return '無限記憶 · $price 一次 · $used/$limit 已使用';
  }

  @override
  String get cameraPermissionTitle => '需要相機權限';

  @override
  String get cameraPermissionDenied => 'PutMind 需要相機來拍攝你正在收起的物品。你可以在設定中開啟。';

  @override
  String get cameraPermissionRetry => '再試一次';

  @override
  String get cameraPermissionOpenSettings => '開啟設定';

  @override
  String get cameraUnavailableTitle => '無法使用相機';

  @override
  String get cameraUnavailableBody => '無法在此裝置開啟相機。請再試一次。';

  @override
  String get cameraWebMockHint => '網頁預覽使用模擬相機。點擊快門以繼續。';

  @override
  String get captureReplaceTitle => '替換照片';

  @override
  String get replacePhotoConfirmTitle => '使用這張照片？';

  @override
  String get replacePhotoConfirmBody => '這會替換此記憶的照片。文字內容保持不變。';

  @override
  String get replacePhotoUsePhoto => '使用照片';

  @override
  String get savingMemory => '儲存中…';

  @override
  String get photoReplaced => '已替換照片';

  @override
  String get saveMemoryFailed => '無法儲存此記憶。請再試一次。';

  @override
  String get replacePhotoFailed => '無法替換此照片。請再試一次。';
}
