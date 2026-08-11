// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Find your things';

  @override
  String get homeRecentMemories => 'Recent memories';

  @override
  String get homeNoMemoriesMatch => 'No memories match your search.';

  @override
  String get homeEmptyTitle => 'Your things will appear here.';

  @override
  String get homeEmptyBody =>
      'Take a photo and tell PutMind where you stored it.';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'What is this? Where did you put it?';

  @override
  String get voiceGuidanceLabel => 'Voice Guidance';

  @override
  String get voiceGuidanceOn => 'On';

  @override
  String get voiceGuidanceOff => 'Off';

  @override
  String get capturePromptPreview =>
      'Take a photo, then speak or type where you put it.';

  @override
  String get capturePromptGuiding => 'Playing voice guidance…';

  @override
  String get capturePromptListening =>
      'Listening… speak naturally, or type instead.';

  @override
  String get capturePromptEditing => 'Review the transcript, then save.';

  @override
  String get captureTranscriptHint => 'Type here if you prefer…';

  @override
  String get captureRetake => 'Retake';

  @override
  String get captureAddPhoto => 'Add photo';

  @override
  String capturePhotoCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String memoryDetailPhotoIndex(int current, int total) {
    return '$current/$total';
  }

  @override
  String get captureSave => 'Save memory';

  @override
  String get captureSnapMessage => 'Snap the thing you’re putting away.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGroupGeneral => 'General';

  @override
  String get settingsGroupPrivacySecurity => 'Privacy & security';

  @override
  String get settingsGroupBackupPurchase => 'Backup & purchase';

  @override
  String get settingsGroupAbout => 'About';

  @override
  String get settingsLanguageRowTitle => 'Language';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, voice guidance & speech locale';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Voice Guidance';

  @override
  String get settingsVoiceGuidanceRowSubtitle => 'Prompt before listening';

  @override
  String get settingsDailyReminderRowTitle => 'Daily Reminder';

  @override
  String get settingsDailyReminderOn => 'On';

  @override
  String get settingsDailyReminderOffSuggested => 'Off · suggested 9:00 PM';

  @override
  String get settingsAppLockRowTitle => 'App Lock';

  @override
  String get settingsAppLockRowSubtitle => 'Biometric with PIN fallback';

  @override
  String get settingsAutoLockRowTitle => 'Auto-lock';

  @override
  String get settingsPrivacyRowTitle => 'Privacy';

  @override
  String get settingsBackupRestoreRowTitle => 'Backup & Restore';

  @override
  String get settingsLastBackupRowTitle => 'Last Backup';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Upgrade Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Restore Purchase';

  @override
  String get settingsAboutPutMindRowTitle => 'About PutMind';

  @override
  String get languagePickerTitle => 'Language';

  @override
  String get autoLockPickerTitle => 'Auto-lock';

  @override
  String get backupSheetTitle => 'Backup & Restore';

  @override
  String get backupSheetBody =>
      'Create an encrypted backup file you can save anywhere, or restore from a previous backup. The backup password is separate from App Lock PIN.';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get restoreBackup => 'Restore Backup';

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
  String get privacyDialogTitle => 'Privacy';

  @override
  String get privacyDialogBody =>
      'Your memories stay yours.\n\nPutMind is local-first: no account, no PutMind cloud database, and no photo upload to PutMind servers in the MVP.\n\nSpeech prefers on-device recognition. Backup files are managed by you.';

  @override
  String get aboutDialogTitle => 'About PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => 'Close';

  @override
  String get turnOnAppLockDialogTitle => 'Turn on App Lock?';

  @override
  String get turnOnAppLockDialogBody =>
      'Biometric unlock with PIN fallback will protect your memories on this device.\n\nPutMind has no account/backend, so a forgotten PIN cannot be reset by email. If biometric still works, unlock → Settings → change PIN.';

  @override
  String get cancel => 'Cancel';

  @override
  String get enable => 'Enable';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Unlimited memories unlocked';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime already unlocked';

  @override
  String get unlockTitle => 'Unlock PutMind';

  @override
  String get unlockSubtitle =>
      'Your memories stay private until you unlock the app.';

  @override
  String get unlockWithBiometrics => 'Unlock with biometrics';

  @override
  String get unlockUsePin => 'Use PIN instead';

  @override
  String get pinBack => 'Back';

  @override
  String get enterPin => 'Enter PIN';

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
      'Speech recognition isn’t available. Type your memory instead.';

  @override
  String get notificationPermissionDenied =>
      'Notification permission is required for Daily Reminder.';

  @override
  String get biometricFailed =>
      'Biometric unlock didn’t work. Try again or use your PIN.';

  @override
  String get biometricUnavailable =>
      'Biometrics aren’t available. Use your PIN to unlock.';

  @override
  String get snackAppLockEnabled => 'App Lock is on';

  @override
  String get dailyReminderNotificationTitle => 'PutMind';

  @override
  String get dailyReminderNotificationBody =>
      'Snap it. Say where. Find it later.';

  @override
  String get onboardingSnapTitle => 'Snap it.';

  @override
  String get onboardingSnapBody =>
      'Take a quick photo of the thing you’re putting away. No forms, folders or categories.';

  @override
  String get onboardingSayWhereTitle => 'Say where you put it.';

  @override
  String get onboardingSayWhereBody =>
      'Speak naturally — or type — what it is and where you stored it. Voice Guidance helps you say both.';

  @override
  String get onboardingFindLaterTitle => 'Find it later.';

  @override
  String get onboardingFindLaterBody =>
      'Search your memories when you need something. PutMind remembers so you don’t have to.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String memoryDetailSaved(Object created) {
    return 'Saved $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Saved $created · Updated $updated';
  }

  @override
  String get memoryDetailEdit => 'Edit';

  @override
  String get memoryDetailReplacePhoto => 'Replace photo';

  @override
  String get memoryDetailDelete => 'Delete';

  @override
  String get deleteDialogTitle => 'Delete this memory?';

  @override
  String get deleteDialogBody =>
      'This removes the photo and memory from this device.';

  @override
  String get deleteMemory => 'Delete memory';

  @override
  String get editMemoryDialogTitle => 'Edit memory';

  @override
  String get editMemoryHint => 'What is this? Where did you put it?';

  @override
  String get editMemorySave => 'Save';

  @override
  String get paywallTitle => 'Unlock unlimited memories';

  @override
  String get paywallBody =>
      'You’ve reached the free limit of 20 memories. Existing memories remain available.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · one-time purchase';

  @override
  String get paywallUnlockLifetime => 'Unlock Lifetime';

  @override
  String get snackMemorySaved => 'Memory saved';

  @override
  String get snackMemoryUpdated => 'Memory updated';

  @override
  String get snackPhotoReplacedMock => 'Photo replaced (mock)';

  @override
  String get snackMemoryDeleted => 'Memory deleted';

  @override
  String get snackAppLockMockInfo =>
      'App Lock uses biometrics with a local PIN fallback on this device.';

  @override
  String get snackReminderSchedulingMock => 'Daily Reminder scheduled';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get voiceSearchTooltip => 'Voice search';

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
  String get cameraPermissionTitle => 'Camera access needed';

  @override
  String get cameraPermissionDenied =>
      'PutMind needs the camera to photograph what you’re putting away. You can enable it in Settings.';

  @override
  String get cameraPermissionRetry => 'Try again';

  @override
  String get cameraPermissionOpenSettings => 'Open Settings';

  @override
  String get cameraUnavailableTitle => 'Camera unavailable';

  @override
  String get cameraUnavailableBody =>
      'We couldn’t open the camera on this device. Please try again.';

  @override
  String get cameraWebMockHint =>
      'Web preview uses a mock camera. Tap the shutter to continue.';

  @override
  String get captureReplaceTitle => 'Replace photo';

  @override
  String get replacePhotoConfirmTitle => 'Use this photo?';

  @override
  String get replacePhotoConfirmBody =>
      'This replaces the photo for this memory. Your transcript stays the same.';

  @override
  String get replacePhotoUsePhoto => 'Use photo';

  @override
  String get savingMemory => 'Saving…';

  @override
  String get photoReplaced => 'Photo replaced';

  @override
  String get saveMemoryFailed => 'Couldn’t save this memory. Please try again.';

  @override
  String get replacePhotoFailed =>
      'Couldn’t replace this photo. Please try again.';
}
