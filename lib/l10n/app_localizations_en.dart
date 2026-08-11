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
      'Encrypted backup connects in a later step. These actions are UI mocks for review.';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get restoreBackup => 'Restore Backup';

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
  String get pinMockText => 'Step 1 mock: any 4 digits unlock.';

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
  String get prototype => 'Prototype';

  @override
  String get prototypePreviewStates => 'Preview states';

  @override
  String get prototypeHint =>
      'Prototype controls only — not part of the PutMind MVP interface.';

  @override
  String get protoHome => 'Home';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Settings';

  @override
  String get protoUnlock => 'Unlock';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Empty Home';

  @override
  String get protoMemoryDetail => 'Memory Detail';

  @override
  String get protoPaywall => 'Paywall';

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
      'App Lock stores credentials securely in a later step. For now this is UI state.';

  @override
  String get snackReminderSchedulingMock =>
      'Reminder scheduling will connect in a later step';

  @override
  String get snackBackupCreatedMock => 'Backup created (mock)';

  @override
  String get snackRestoreBackupMock => 'Restore will connect in a later step';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime unlocked (mock purchase)';

  @override
  String get snackPurchaseRestoredMock => 'Purchase restored (mock)';

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
}
