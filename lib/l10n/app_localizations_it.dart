// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Trova le tue cose';

  @override
  String get homeRecentMemories => 'Memorie recenti';

  @override
  String get homeNoMemoriesMatch =>
      'Nessuna memoria corrisponde alla tua ricerca.';

  @override
  String get homeEmptyTitle => 'Le tue cose appariranno qui.';

  @override
  String get homeEmptyBody =>
      'Scatta una foto e dì a PutMind dove le hai messe.';

  @override
  String get settingsTooltip => 'Impostazioni';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'Che cos’è? Dove l’hai messo?';

  @override
  String get voiceGuidanceLabel => 'Guida vocale';

  @override
  String get voiceGuidanceOn => 'On';

  @override
  String get voiceGuidanceOff => 'Off';

  @override
  String get capturePromptPreview =>
      'Scatta una foto, poi parla o scrivi dove l’hai messa.';

  @override
  String get capturePromptGuiding => 'Riproduzione guida vocale…';

  @override
  String get capturePromptListening =>
      'In ascolto… parla naturalmente, oppure digita.';

  @override
  String get capturePromptEditing => 'Rivedi la trascrizione e salva.';

  @override
  String get captureTranscriptHint => 'Scrivi qui se preferisci…';

  @override
  String get captureRetake => 'Rifai';

  @override
  String get captureSave => 'Salva memoria';

  @override
  String get captureSnapMessage => 'Scatta la foto di ciò che stai riponendo.';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsGroupGeneral => 'Generale';

  @override
  String get settingsGroupPrivacySecurity => 'Privacy e sicurezza';

  @override
  String get settingsGroupBackupPurchase => 'Backup e acquisto';

  @override
  String get settingsGroupAbout => 'Info';

  @override
  String get settingsLanguageRowTitle => 'Lingua';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, guida vocale e lingua per la voce';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Guida vocale';

  @override
  String get settingsVoiceGuidanceRowSubtitle =>
      'Promemoria prima dell’ascolto';

  @override
  String get settingsDailyReminderRowTitle => 'Promemoria giornaliero';

  @override
  String get settingsDailyReminderOn => 'On';

  @override
  String get settingsDailyReminderOffSuggested => 'Off · suggerito 21:00';

  @override
  String get settingsAppLockRowTitle => 'Blocco app';

  @override
  String get settingsAppLockRowSubtitle => 'Biometrico con fallback PIN';

  @override
  String get settingsAutoLockRowTitle => 'Blocco automatico';

  @override
  String get settingsPrivacyRowTitle => 'Privacy';

  @override
  String get settingsBackupRestoreRowTitle => 'Backup e ripristino';

  @override
  String get settingsLastBackupRowTitle => 'Ultimo backup';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Sblocca Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Ripristina acquisto';

  @override
  String get settingsAboutPutMindRowTitle => 'Info su PutMind';

  @override
  String get languagePickerTitle => 'Lingua';

  @override
  String get autoLockPickerTitle => 'Blocco automatico';

  @override
  String get backupSheetTitle => 'Backup e ripristino';

  @override
  String get backupSheetBody =>
      'Il backup cifrato si collegherà in un passaggio successivo. Queste azioni sono mock dell’interfaccia per la revisione.';

  @override
  String get createBackup => 'Crea backup';

  @override
  String get restoreBackup => 'Ripristina backup';

  @override
  String get privacyDialogTitle => 'Privacy';

  @override
  String get privacyDialogBody =>
      'Le tue memorie restano tue.\n\nPutMind è local-first: niente account, niente database cloud PutMind e nessun upload di foto ai server PutMind nel MVP.\n\nIl riconoscimento vocale preferisce il dispositivo. I file di backup li gestisci tu.';

  @override
  String get aboutDialogTitle => 'Info su PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => 'Chiudi';

  @override
  String get turnOnAppLockDialogTitle => 'Attivare Blocco app?';

  @override
  String get turnOnAppLockDialogBody =>
      'Lo sblocco biometrico con fallback PIN proteggerà le tue memorie su questo dispositivo.\n\nPutMind non ha account/backend, quindi un PIN dimenticato non può essere reimpostato via email. Se la biometria funziona ancora: sblocca → Impostazioni → cambia PIN.';

  @override
  String get cancel => 'Annulla';

  @override
  String get enable => 'Attiva';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Memorie illimitate sbloccate';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime è già sbloccato';

  @override
  String get unlockTitle => 'Sblocca PutMind';

  @override
  String get unlockSubtitle =>
      'Le tue memorie restano private finché non sblocchi l’app.';

  @override
  String get unlockWithBiometrics => 'Sblocca con biometria';

  @override
  String get unlockUsePin => 'Usa PIN invece';

  @override
  String get pinBack => 'Indietro';

  @override
  String get enterPin => 'Inserisci PIN';

  @override
  String get pinMockText => 'Mock passo 1: qualsiasi 4 cifre sbloccano.';

  @override
  String get onboardingSnapTitle => 'Scatta.';

  @override
  String get onboardingSnapBody =>
      'Fai una foto veloce di ciò che stai riponendo. Niente moduli, cartelle o categorie.';

  @override
  String get onboardingSayWhereTitle => 'Dì dove l’hai messo.';

  @override
  String get onboardingSayWhereBody =>
      'Parla naturalmente — oppure digita — cos’è e dove l’hai conservato. La guida vocale ti aiuta con entrambe le cose.';

  @override
  String get onboardingFindLaterTitle => 'Trovalo dopo.';

  @override
  String get onboardingFindLaterBody =>
      'Cerca le tue memorie quando ti serve qualcosa. PutMind ricorda per te.';

  @override
  String get onboardingContinue => 'Continua';

  @override
  String get onboardingGetStarted => 'Inizia';

  @override
  String memoryDetailSaved(Object created) {
    return 'Salvato $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Salvato $created · Aggiornato $updated';
  }

  @override
  String get memoryDetailEdit => 'Modifica';

  @override
  String get memoryDetailReplacePhoto => 'Sostituisci foto';

  @override
  String get memoryDetailDelete => 'Elimina';

  @override
  String get deleteDialogTitle => 'Eliminare questa memoria?';

  @override
  String get deleteDialogBody =>
      'Rimuove la foto e la memoria da questo dispositivo.';

  @override
  String get deleteMemory => 'Elimina memoria';

  @override
  String get editMemoryDialogTitle => 'Modifica memoria';

  @override
  String get editMemoryHint => 'Che cos’è? Dove l’hai messo?';

  @override
  String get editMemorySave => 'Salva';

  @override
  String get paywallTitle => 'Sblocca memorie illimitate';

  @override
  String get paywallBody =>
      'Hai raggiunto il limite gratuito di 20 memorie. Le memorie esistenti restano disponibili.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · acquisto una tantum';

  @override
  String get paywallUnlockLifetime => 'Sblocca Lifetime';

  @override
  String get prototype => 'Prototipo';

  @override
  String get prototypePreviewStates => 'Anteprima stati';

  @override
  String get prototypeHint =>
      'Solo controlli del prototipo — non fa parte dell’interfaccia MVP di PutMind.';

  @override
  String get protoHome => 'Home';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Impostazioni';

  @override
  String get protoUnlock => 'Sblocca';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Home vuota';

  @override
  String get protoMemoryDetail => 'Dettaglio memoria';

  @override
  String get protoPaywall => 'Paywall';

  @override
  String get snackMemorySaved => 'Memoria salvata';

  @override
  String get snackMemoryUpdated => 'Memoria aggiornata';

  @override
  String get snackPhotoReplacedMock => 'Foto sostituita (mock)';

  @override
  String get snackMemoryDeleted => 'Memoria eliminata';

  @override
  String get snackAppLockMockInfo =>
      'Il Blocco app salverà le credenziali in modo sicuro in un passaggio successivo. Per ora: stato UI.';

  @override
  String get snackReminderSchedulingMock =>
      'Il promemoria si collegherà in un passaggio successivo (mock)';

  @override
  String get snackBackupCreatedMock => 'Backup creato (mock)';

  @override
  String get snackRestoreBackupMock =>
      'Il ripristino si collegherà in un passaggio successivo (mock)';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime sbloccato (acquisto mock)';

  @override
  String get snackPurchaseRestoredMock => 'Acquisto ripristinato (mock)';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get voiceSearchTooltip => 'Ricerca vocale';

  @override
  String get autoLockImmediately => 'Immediatamente';

  @override
  String get autoLockOneMinute => 'Dopo 1 minuto';

  @override
  String get autoLockFiveMinutes => 'Dopo 5 minuti';

  @override
  String get autoLockFifteenMinutes => 'Dopo 15 minuti';

  @override
  String get never => 'Mai';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Memorie illimitate · $price una volta · $used/$limit usate';
  }
}
