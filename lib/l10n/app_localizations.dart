import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @homeSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Find your things'**
  String get homeSearchPlaceholder;

  /// No description provided for @homeRecentMemories.
  ///
  /// In en, this message translates to:
  /// **'Recent memories'**
  String get homeRecentMemories;

  /// No description provided for @homeNoMemoriesMatch.
  ///
  /// In en, this message translates to:
  /// **'No memories match your search.'**
  String get homeNoMemoriesMatch;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your things will appear here.'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Take a photo and tell PutMind where you stored it.'**
  String get homeEmptyBody;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @captureTitle.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get captureTitle;

  /// No description provided for @capturePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'What is this? Where did you put it?'**
  String get capturePromptTitle;

  /// No description provided for @voiceGuidanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Voice Guidance'**
  String get voiceGuidanceLabel;

  /// No description provided for @voiceGuidanceOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get voiceGuidanceOn;

  /// No description provided for @voiceGuidanceOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get voiceGuidanceOff;

  /// No description provided for @capturePromptPreview.
  ///
  /// In en, this message translates to:
  /// **'Take a photo, then speak or type where you put it.'**
  String get capturePromptPreview;

  /// No description provided for @capturePromptGuiding.
  ///
  /// In en, this message translates to:
  /// **'Playing voice guidance…'**
  String get capturePromptGuiding;

  /// No description provided for @capturePromptListening.
  ///
  /// In en, this message translates to:
  /// **'Listening… speak naturally, or type instead.'**
  String get capturePromptListening;

  /// No description provided for @capturePromptEditing.
  ///
  /// In en, this message translates to:
  /// **'Review the transcript, then save.'**
  String get capturePromptEditing;

  /// No description provided for @captureTranscriptHint.
  ///
  /// In en, this message translates to:
  /// **'Type here if you prefer…'**
  String get captureTranscriptHint;

  /// No description provided for @captureRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get captureRetake;

  /// No description provided for @captureSave.
  ///
  /// In en, this message translates to:
  /// **'Save memory'**
  String get captureSave;

  /// No description provided for @captureSnapMessage.
  ///
  /// In en, this message translates to:
  /// **'Snap the thing you’re putting away.'**
  String get captureSnapMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGroupGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGroupGeneral;

  /// No description provided for @settingsGroupPrivacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get settingsGroupPrivacySecurity;

  /// No description provided for @settingsGroupBackupPurchase.
  ///
  /// In en, this message translates to:
  /// **'Backup & purchase'**
  String get settingsGroupBackupPurchase;

  /// No description provided for @settingsGroupAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsGroupAbout;

  /// No description provided for @settingsLanguageRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageRowTitle;

  /// No description provided for @settingsLanguageRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App, voice guidance & speech locale'**
  String get settingsLanguageRowSubtitle;

  /// No description provided for @settingsVoiceGuidanceRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Guidance'**
  String get settingsVoiceGuidanceRowTitle;

  /// No description provided for @settingsVoiceGuidanceRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prompt before listening'**
  String get settingsVoiceGuidanceRowSubtitle;

  /// No description provided for @settingsDailyReminderRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get settingsDailyReminderRowTitle;

  /// No description provided for @settingsDailyReminderOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsDailyReminderOn;

  /// No description provided for @settingsDailyReminderOffSuggested.
  ///
  /// In en, this message translates to:
  /// **'Off · suggested 9:00 PM'**
  String get settingsDailyReminderOffSuggested;

  /// No description provided for @settingsAppLockRowTitle.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get settingsAppLockRowTitle;

  /// No description provided for @settingsAppLockRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric with PIN fallback'**
  String get settingsAppLockRowSubtitle;

  /// No description provided for @settingsAutoLockRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get settingsAutoLockRowTitle;

  /// No description provided for @settingsPrivacyRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacyRowTitle;

  /// No description provided for @settingsBackupRestoreRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackupRestoreRowTitle;

  /// No description provided for @settingsLastBackupRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get settingsLastBackupRowTitle;

  /// No description provided for @settingsUpgradeLifetimeRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Lifetime'**
  String get settingsUpgradeLifetimeRowTitle;

  /// No description provided for @settingsRestorePurchaseRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get settingsRestorePurchaseRowTitle;

  /// No description provided for @settingsAboutPutMindRowTitle.
  ///
  /// In en, this message translates to:
  /// **'About PutMind'**
  String get settingsAboutPutMindRowTitle;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagePickerTitle;

  /// No description provided for @autoLockPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get autoLockPickerTitle;

  /// No description provided for @backupSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupSheetTitle;

  /// No description provided for @backupSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup connects in a later step. These actions are UI mocks for review.'**
  String get backupSheetBody;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @privacyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyDialogTitle;

  /// No description provided for @privacyDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Your memories stay yours.\n\nPutMind is local-first: no account, no PutMind cloud database, and no photo upload to PutMind servers in the MVP.\n\nSpeech prefers on-device recognition. Backup files are managed by you.'**
  String get privacyDialogBody;

  /// No description provided for @aboutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'About PutMind'**
  String get aboutDialogTitle;

  /// No description provided for @aboutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)'**
  String get aboutDialogBody;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @turnOnAppLockDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on App Lock?'**
  String get turnOnAppLockDialogTitle;

  /// No description provided for @turnOnAppLockDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock with PIN fallback will protect your memories on this device.\n\nPutMind has no account/backend, so a forgotten PIN cannot be reset by email. If biometric still works, unlock → Settings → change PIN.'**
  String get turnOnAppLockDialogBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @lifetimeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'PutMind Lifetime'**
  String get lifetimeCardTitle;

  /// No description provided for @lifetimeCardUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlimited memories unlocked'**
  String get lifetimeCardUnlocked;

  /// No description provided for @lifetimeAlreadyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Lifetime already unlocked'**
  String get lifetimeAlreadyUnlocked;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock PutMind'**
  String get unlockTitle;

  /// No description provided for @unlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your memories stay private until you unlock the app.'**
  String get unlockSubtitle;

  /// No description provided for @unlockWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get unlockWithBiometrics;

  /// No description provided for @unlockUsePin.
  ///
  /// In en, this message translates to:
  /// **'Use PIN instead'**
  String get unlockUsePin;

  /// No description provided for @pinBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get pinBack;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @pinMockText.
  ///
  /// In en, this message translates to:
  /// **'Step 1 mock: any 4 digits unlock.'**
  String get pinMockText;

  /// No description provided for @onboardingSnapTitle.
  ///
  /// In en, this message translates to:
  /// **'Snap it.'**
  String get onboardingSnapTitle;

  /// No description provided for @onboardingSnapBody.
  ///
  /// In en, this message translates to:
  /// **'Take a quick photo of the thing you’re putting away. No forms, folders or categories.'**
  String get onboardingSnapBody;

  /// No description provided for @onboardingSayWhereTitle.
  ///
  /// In en, this message translates to:
  /// **'Say where you put it.'**
  String get onboardingSayWhereTitle;

  /// No description provided for @onboardingSayWhereBody.
  ///
  /// In en, this message translates to:
  /// **'Speak naturally — or type — what it is and where you stored it. Voice Guidance helps you say both.'**
  String get onboardingSayWhereBody;

  /// No description provided for @onboardingFindLaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Find it later.'**
  String get onboardingFindLaterTitle;

  /// No description provided for @onboardingFindLaterBody.
  ///
  /// In en, this message translates to:
  /// **'Search your memories when you need something. PutMind remembers so you don’t have to.'**
  String get onboardingFindLaterBody;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @memoryDetailSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {created}'**
  String memoryDetailSaved(Object created);

  /// No description provided for @memoryDetailSavedUpdated.
  ///
  /// In en, this message translates to:
  /// **'Saved {created} · Updated {updated}'**
  String memoryDetailSavedUpdated(Object created, Object updated);

  /// No description provided for @memoryDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get memoryDetailEdit;

  /// No description provided for @memoryDetailReplacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get memoryDetailReplacePhoto;

  /// No description provided for @memoryDetailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get memoryDetailDelete;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the photo and memory from this device.'**
  String get deleteDialogBody;

  /// No description provided for @deleteMemory.
  ///
  /// In en, this message translates to:
  /// **'Delete memory'**
  String get deleteMemory;

  /// No description provided for @editMemoryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit memory'**
  String get editMemoryDialogTitle;

  /// No description provided for @editMemoryHint.
  ///
  /// In en, this message translates to:
  /// **'What is this? Where did you put it?'**
  String get editMemoryHint;

  /// No description provided for @editMemorySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editMemorySave;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited memories'**
  String get paywallTitle;

  /// No description provided for @paywallBody.
  ///
  /// In en, this message translates to:
  /// **'You’ve reached the free limit of 20 memories. Existing memories remain available.'**
  String get paywallBody;

  /// No description provided for @paywallPrice.
  ///
  /// In en, this message translates to:
  /// **'\$6.99'**
  String get paywallPrice;

  /// No description provided for @paywallLifetimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Lifetime · one-time purchase'**
  String get paywallLifetimeLabel;

  /// No description provided for @paywallUnlockLifetime.
  ///
  /// In en, this message translates to:
  /// **'Unlock Lifetime'**
  String get paywallUnlockLifetime;

  /// No description provided for @prototype.
  ///
  /// In en, this message translates to:
  /// **'Prototype'**
  String get prototype;

  /// No description provided for @prototypePreviewStates.
  ///
  /// In en, this message translates to:
  /// **'Preview states'**
  String get prototypePreviewStates;

  /// No description provided for @prototypeHint.
  ///
  /// In en, this message translates to:
  /// **'Prototype controls only — not part of the PutMind MVP interface.'**
  String get prototypeHint;

  /// No description provided for @protoHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get protoHome;

  /// No description provided for @protoCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get protoCapture;

  /// No description provided for @protoSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get protoSettings;

  /// No description provided for @protoUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get protoUnlock;

  /// No description provided for @protoOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get protoOnboarding;

  /// No description provided for @protoEmptyHome.
  ///
  /// In en, this message translates to:
  /// **'Empty Home'**
  String get protoEmptyHome;

  /// No description provided for @protoMemoryDetail.
  ///
  /// In en, this message translates to:
  /// **'Memory Detail'**
  String get protoMemoryDetail;

  /// No description provided for @protoPaywall.
  ///
  /// In en, this message translates to:
  /// **'Paywall'**
  String get protoPaywall;

  /// No description provided for @snackMemorySaved.
  ///
  /// In en, this message translates to:
  /// **'Memory saved'**
  String get snackMemorySaved;

  /// No description provided for @snackMemoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Memory updated'**
  String get snackMemoryUpdated;

  /// No description provided for @snackPhotoReplacedMock.
  ///
  /// In en, this message translates to:
  /// **'Photo replaced (mock)'**
  String get snackPhotoReplacedMock;

  /// No description provided for @snackMemoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Memory deleted'**
  String get snackMemoryDeleted;

  /// No description provided for @snackAppLockMockInfo.
  ///
  /// In en, this message translates to:
  /// **'App Lock stores credentials securely in a later step. For now this is UI state.'**
  String get snackAppLockMockInfo;

  /// No description provided for @snackReminderSchedulingMock.
  ///
  /// In en, this message translates to:
  /// **'Reminder scheduling will connect in a later step'**
  String get snackReminderSchedulingMock;

  /// No description provided for @snackBackupCreatedMock.
  ///
  /// In en, this message translates to:
  /// **'Backup created (mock)'**
  String get snackBackupCreatedMock;

  /// No description provided for @snackRestoreBackupMock.
  ///
  /// In en, this message translates to:
  /// **'Restore will connect in a later step'**
  String get snackRestoreBackupMock;

  /// No description provided for @snackLifetimeUnlockedMock.
  ///
  /// In en, this message translates to:
  /// **'Lifetime unlocked (mock purchase)'**
  String get snackLifetimeUnlockedMock;

  /// No description provided for @snackPurchaseRestoredMock.
  ///
  /// In en, this message translates to:
  /// **'Purchase restored (mock)'**
  String get snackPurchaseRestoredMock;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @voiceSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Voice search'**
  String get voiceSearchTooltip;

  /// No description provided for @autoLockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get autoLockImmediately;

  /// No description provided for @autoLockOneMinute.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get autoLockOneMinute;

  /// No description provided for @autoLockFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get autoLockFiveMinutes;

  /// No description provided for @autoLockFifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'After 15 minutes'**
  String get autoLockFifteenMinutes;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @lifetimeCardLocked.
  ///
  /// In en, this message translates to:
  /// **'Unlimited memories · {price} once · {used}/{limit} used'**
  String lifetimeCardLocked(Object limit, Object price, Object used);

  /// No description provided for @cameraPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access needed'**
  String get cameraPermissionTitle;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'PutMind needs the camera to photograph what you’re putting away. You can enable it in Settings.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraPermissionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get cameraPermissionRetry;

  /// No description provided for @cameraPermissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get cameraPermissionOpenSettings;

  /// No description provided for @cameraUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get cameraUnavailableTitle;

  /// No description provided for @cameraUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t open the camera on this device. Please try again.'**
  String get cameraUnavailableBody;

  /// No description provided for @cameraWebMockHint.
  ///
  /// In en, this message translates to:
  /// **'Web preview uses a mock camera. Tap the shutter to continue.'**
  String get cameraWebMockHint;

  /// No description provided for @captureReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get captureReplaceTitle;

  /// No description provided for @replacePhotoConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Use this photo?'**
  String get replacePhotoConfirmTitle;

  /// No description provided for @replacePhotoConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This replaces the photo for this memory. Your transcript stays the same.'**
  String get replacePhotoConfirmBody;

  /// No description provided for @replacePhotoUsePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use photo'**
  String get replacePhotoUsePhoto;

  /// No description provided for @savingMemory.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingMemory;

  /// No description provided for @photoReplaced.
  ///
  /// In en, this message translates to:
  /// **'Photo replaced'**
  String get photoReplaced;

  /// No description provided for @saveMemoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save this memory. Please try again.'**
  String get saveMemoryFailed;

  /// No description provided for @replacePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t replace this photo. Please try again.'**
  String get replacePhotoFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'pt',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
