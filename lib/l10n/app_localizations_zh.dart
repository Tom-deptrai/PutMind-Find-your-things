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
  String get backupSheetBody => '加密備份會在之後步驟連接。以下按鈕僅作為介面示意供你檢查。';

  @override
  String get createBackup => '建立備份';

  @override
  String get restoreBackup => '還原備份';

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
  String get pinMockText => 'Step 1 示意：任何 4 位數即可解鎖。';

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
  String get prototype => '原型';

  @override
  String get prototypePreviewStates => '預覽狀態';

  @override
  String get prototypeHint => '僅供原型控制 — 不是 PutMind MVP 介面的一部分。';

  @override
  String get protoHome => '首頁';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => '設定';

  @override
  String get protoUnlock => '解鎖';

  @override
  String get protoOnboarding => '入門';

  @override
  String get protoEmptyHome => '空的首頁';

  @override
  String get protoMemoryDetail => '記憶細節';

  @override
  String get protoPaywall => '付費牆';

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
  String get snackBackupCreatedMock => '已建立備份（示意）';

  @override
  String get snackRestoreBackupMock => '還原會在之後步驟連接（示意）';

  @override
  String get snackLifetimeUnlockedMock => '已解鎖 Lifetime（示意購買）';

  @override
  String get snackPurchaseRestoredMock => '已還原購買（示意）';

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
  String get backupSheetBody => '加密備份會在之後步驟連接。以下按鈕僅作為介面示意供你檢查。';

  @override
  String get createBackup => '建立備份';

  @override
  String get restoreBackup => '還原備份';

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
  String get pinMockText => 'Step 1 示意：任何 4 位數即可解鎖。';

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
  String get prototype => '原型';

  @override
  String get prototypePreviewStates => '預覽狀態';

  @override
  String get prototypeHint => '僅供原型控制 — 不是 PutMind MVP 介面的一部分。';

  @override
  String get protoHome => '首頁';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => '設定';

  @override
  String get protoUnlock => '解鎖';

  @override
  String get protoOnboarding => '入門';

  @override
  String get protoEmptyHome => '空的首頁';

  @override
  String get protoMemoryDetail => '記憶細節';

  @override
  String get protoPaywall => '付費牆';

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
  String get snackBackupCreatedMock => '已建立備份（示意）';

  @override
  String get snackRestoreBackupMock => '還原會在之後步驟連接（示意）';

  @override
  String get snackLifetimeUnlockedMock => '已解鎖 Lifetime（示意購買）';

  @override
  String get snackPurchaseRestoredMock => '已還原購買（示意）';

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
}
