// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Finde deine Dinge';

  @override
  String get homeRecentMemories => 'Letzte Erinnerungen';

  @override
  String get homeNoMemoriesMatch =>
      'Keine Erinnerungen passen zu deiner Suche.';

  @override
  String get homeEmptyTitle => 'Deine Dinge erscheinen hier.';

  @override
  String get homeEmptyBody =>
      'Mach ein Foto und sag PutMind, wo du es abgelegt hast.';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'Was ist das? Wo hast du es hingelegt?';

  @override
  String get voiceGuidanceLabel => 'Sprachhinweise';

  @override
  String get voiceGuidanceOn => 'Ein';

  @override
  String get voiceGuidanceOff => 'Aus';

  @override
  String get capturePromptPreview =>
      'Mach ein Foto und sag oder tippe, wo du es abgelegt hast.';

  @override
  String get capturePromptGuiding => 'Sprachhinweis wird abgespielt…';

  @override
  String get capturePromptListening =>
      'Ich höre zu… sprich natürlich oder gib stattdessen Text ein.';

  @override
  String get capturePromptEditing =>
      'Überprüfe das Transkript und speichere dann.';

  @override
  String get captureTranscriptHint => 'Hier eingeben, wenn du lieber möchtest…';

  @override
  String get captureRetake => 'Neu aufnehmen';

  @override
  String get captureSave => 'Erinnerung speichern';

  @override
  String get captureSnapMessage => 'Mach ein Foto von dem, was du weglegst.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsGroupGeneral => 'Allgemein';

  @override
  String get settingsGroupPrivacySecurity => 'Datenschutz & Sicherheit';

  @override
  String get settingsGroupBackupPurchase => 'Backup & Kauf';

  @override
  String get settingsGroupAbout => 'Über';

  @override
  String get settingsLanguageRowTitle => 'Sprache';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, Sprachhinweise & Spracheinstellung';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Sprachhinweise';

  @override
  String get settingsVoiceGuidanceRowSubtitle => 'Hinweis vor dem Zuhören';

  @override
  String get settingsDailyReminderRowTitle => 'Tägliche Erinnerung';

  @override
  String get settingsDailyReminderOn => 'Ein';

  @override
  String get settingsDailyReminderOffSuggested => 'Aus · empfohlen 21:00';

  @override
  String get settingsAppLockRowTitle => 'App-Sperre';

  @override
  String get settingsAppLockRowSubtitle => 'Biometrisch mit PIN-Backup';

  @override
  String get settingsAutoLockRowTitle => 'Automatische Sperre';

  @override
  String get settingsPrivacyRowTitle => 'Datenschutz';

  @override
  String get settingsBackupRestoreRowTitle => 'Backup & Wiederherstellen';

  @override
  String get settingsLastBackupRowTitle => 'Letztes Backup';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Lifetime freischalten';

  @override
  String get settingsRestorePurchaseRowTitle => 'Kauf wiederherstellen';

  @override
  String get settingsAboutPutMindRowTitle => 'Über PutMind';

  @override
  String get languagePickerTitle => 'Sprache';

  @override
  String get autoLockPickerTitle => 'Automatische Sperre';

  @override
  String get backupSheetTitle => 'Backup & Wiederherstellen';

  @override
  String get backupSheetBody =>
      'Verschlüsseltes Backup ist später verfügbar. Das sind nur UI-Mocks zum Prüfen.';

  @override
  String get createBackup => 'Backup erstellen';

  @override
  String get restoreBackup => 'Backup wiederherstellen';

  @override
  String get privacyDialogTitle => 'Datenschutz';

  @override
  String get privacyDialogBody =>
      'Deine Erinnerungen bleiben deine.\n\nPutMind ist local-first: kein Konto, keine PutMind-Cloud-Datenbank und im MVP kein Foto-Upload an PutMind-Server.\n\nSpracherkennung bevorzugt auf dem Gerät. Backup-Dateien verwaltest du selbst.';

  @override
  String get aboutDialogTitle => 'Über PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => 'Schließen';

  @override
  String get turnOnAppLockDialogTitle => 'App-Sperre einschalten?';

  @override
  String get turnOnAppLockDialogBody =>
      'Biometrisches Entsperren mit PIN-Backup schützt deine Erinnerungen auf diesem Gerät.\n\nPutMind hat kein Konto/Backend, daher kann eine vergessene PIN nicht per E-Mail zurückgesetzt werden. Wenn Biometrie noch funktioniert: Entsperren → Einstellungen → PIN ändern.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get enable => 'Aktivieren';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Unbegrenzte Erinnerungen freigeschaltet';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime ist bereits freigeschaltet';

  @override
  String get unlockTitle => 'PutMind entsperren';

  @override
  String get unlockSubtitle =>
      'Deine Erinnerungen bleiben privat, bis du die App entsperrst.';

  @override
  String get unlockWithBiometrics => 'Mit Biometrie entsperren';

  @override
  String get unlockUsePin => 'Stattdessen PIN verwenden';

  @override
  String get pinBack => 'Zurück';

  @override
  String get enterPin => 'PIN eingeben';

  @override
  String get pinMockText =>
      'Step 1 Mock: Biege beliebige 4 Ziffern für die Entsperrung.';

  @override
  String get onboardingSnapTitle => 'Schnapp es.';

  @override
  String get onboardingSnapBody =>
      'Mach ein schnelles Foto von dem, was du wegräumst. Keine Formulare, Ordner oder Kategorien.';

  @override
  String get onboardingSayWhereTitle => 'Sag, wo du es hingetan hast.';

  @override
  String get onboardingSayWhereBody =>
      'Sprich natürlich — oder tippe — was es ist und wo du es gelassen hast. Sprachhinweise helfen dir bei beidem.';

  @override
  String get onboardingFindLaterTitle => 'Später finden.';

  @override
  String get onboardingFindLaterBody =>
      'Suche in deinen Erinnerungen, wenn du etwas brauchst. PutMind merkt sich’s für dich.';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingGetStarted => 'Los geht’s';

  @override
  String memoryDetailSaved(Object created) {
    return 'Gespeichert: $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Gespeichert: $created · Aktualisiert: $updated';
  }

  @override
  String get memoryDetailEdit => 'Bearbeiten';

  @override
  String get memoryDetailReplacePhoto => 'Foto ersetzen';

  @override
  String get memoryDetailDelete => 'Löschen';

  @override
  String get deleteDialogTitle => 'Diese Erinnerung löschen?';

  @override
  String get deleteDialogBody =>
      'Das Foto und die Erinnerung werden von diesem Gerät entfernt.';

  @override
  String get deleteMemory => 'Erinnerung löschen';

  @override
  String get editMemoryDialogTitle => 'Erinnerung bearbeiten';

  @override
  String get editMemoryHint => 'Was ist das? Wo hast du es hingelegt?';

  @override
  String get editMemorySave => 'Speichern';

  @override
  String get paywallTitle => 'Unbegrenzte Erinnerungen freischalten';

  @override
  String get paywallBody =>
      'Du hast das kostenlose Limit von 20 Erinnerungen erreicht. Bestehende Erinnerungen bleiben verfügbar.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · einmaliger Kauf';

  @override
  String get paywallUnlockLifetime => 'Lifetime freischalten';

  @override
  String get prototype => 'Prototyp';

  @override
  String get prototypePreviewStates => 'Zustände ansehen';

  @override
  String get prototypeHint =>
      'Nur Prototyp-Steuerung — nicht Teil des PutMind MVP.';

  @override
  String get protoHome => 'Home';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Einstellungen';

  @override
  String get protoUnlock => 'Entsperren';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Leeres Home';

  @override
  String get protoMemoryDetail => 'Erinnerungsdetails';

  @override
  String get protoPaywall => 'Paywall';

  @override
  String get snackMemorySaved => 'Erinnerung gespeichert';

  @override
  String get snackMemoryUpdated => 'Erinnerung aktualisiert';

  @override
  String get snackPhotoReplacedMock => 'Foto ersetzt (Mock)';

  @override
  String get snackMemoryDeleted => 'Erinnerung gelöscht';

  @override
  String get snackAppLockMockInfo =>
      'App-Sperre speichert die Daten sicher in einem späteren Schritt. Aktuell ist es nur UI-State.';

  @override
  String get snackReminderSchedulingMock =>
      'Erinnerungen werden später verbunden (Mock).';

  @override
  String get snackBackupCreatedMock => 'Backup erstellt (Mock)';

  @override
  String get snackRestoreBackupMock =>
      'Wiederherstellung kommt in einem späteren Schritt (Mock)';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime freigeschaltet (Mock-Kauf)';

  @override
  String get snackPurchaseRestoredMock => 'Kauf wiederhergestellt (Mock)';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get voiceSearchTooltip => 'Sprachsuche';

  @override
  String get autoLockImmediately => 'Sofort';

  @override
  String get autoLockOneMinute => 'Nach 1 Minute';

  @override
  String get autoLockFiveMinutes => 'Nach 5 Minuten';

  @override
  String get autoLockFifteenMinutes => 'Nach 15 Minuten';

  @override
  String get never => 'Nie';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Unbegrenzte Erinnerungen · $price einmal · $used/$limit genutzt';
  }
}
