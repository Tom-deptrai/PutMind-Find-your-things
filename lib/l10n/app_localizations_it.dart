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
  String get captureAddPhoto => '+ Foto';

  @override
  String capturePhotoCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String memoryDetailPhotoIndex(int current, int total) {
    return '$current/$total';
  }

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
      'Crea un backup crittografato e scegli dove salvarlo, oppure ripristina un backup precedente. La password del backup è distinta dal PIN di blocco.';

  @override
  String get createBackup => 'Crea backup';

  @override
  String get restoreBackup => 'Ripristina backup';

  @override
  String get backupPasswordCreateTitle => 'Imposta password di backup';

  @override
  String get backupPasswordEnterTitle => 'Inserisci password di backup';

  @override
  String get backupPasswordLabel => 'Password di backup';

  @override
  String get backupPasswordConfirmLabel => 'Conferma password';

  @override
  String get backupPasswordWarning =>
      'Se dimentichi questa password, PutMind non può recuperare il backup. Non c’è reset dell’account.';

  @override
  String get backupPasswordTooShort => 'Usa almeno 4 caratteri.';

  @override
  String get backupPasswordMismatch => 'Le password non corrispondono.';

  @override
  String get restoreConfirmTitle => 'Sostituire le memorie attuali?';

  @override
  String get restoreConfirmBody =>
      'Il ripristino sostituirà le memorie su questo dispositivo. Non si può annullare.';

  @override
  String get snackBackupCreated => 'Backup creato';

  @override
  String get snackBackupRestored => 'Backup ripristinato';

  @override
  String get snackBackupFailed =>
      'Backup non riuscito. I dati attuali non sono cambiati.';

  @override
  String get snackBackupWrongPassword => 'Password di backup errata.';

  @override
  String get snackBackupCorrupted =>
      'Questo file di backup è danneggiato o incompleto.';

  @override
  String get snackBackupUnsupported =>
      'Questa versione di backup non è supportata.';

  @override
  String get snackBackupCancelled => 'Backup annullato.';

  @override
  String get paywallPurchasePending => 'Elaborazione…';

  @override
  String get snackLifetimeUnlocked => 'Lifetime sbloccato';

  @override
  String get snackPurchaseRestored => 'Acquisto ripristinato';

  @override
  String get snackPurchaseRestoreNone =>
      'Nessun acquisto Lifetime trovato per questo account.';

  @override
  String get snackPurchaseCancelled => 'Acquisto annullato.';

  @override
  String get snackPurchaseFailed => 'Acquisto non riuscito. Riprova.';

  @override
  String get snackPurchaseAlreadyOwned => 'Lifetime già acquistato.';

  @override
  String get snackStoreUnavailable => 'Lo store non è disponibile al momento.';

  @override
  String get privacyDialogTitle => 'Privacy';

  @override
  String get privacyDialogBody =>
      'Le tue memorie restano tue.\\n\\nPutMind è local-first: memorie, foto e trascrizioni restano su questo dispositivo. Nessun account PutMind e nessun sync cloud PutMind. Fotocamera e microfono solo per le funzioni che scegli. Il riconoscimento vocale usa le capacità del dispositivo/piattaforma. Il promemoria giornaliero usa notifiche locali. PIN e biometria restano sul dispositivo. I backup crittografati sono file che crei e salvi tu. Gli acquisti in-app sono gestiti da Apple o Google. PutMind non vende i tuoi dati.';

  @override
  String get aboutDialogTitle => 'Info su PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\\nSnap it. Say where. Find it later.';

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

  @override
  String get cameraPermissionTitle => 'Serve l’accesso alla fotocamera';

  @override
  String get cameraPermissionDenied =>
      'PutMind ha bisogno della fotocamera per fotografare ciò che riponi. Puoi attivarla nelle Impostazioni.';

  @override
  String get cameraPermissionRetry => 'Riprova';

  @override
  String get cameraPermissionOpenSettings => 'Apri Impostazioni';

  @override
  String get cameraUnavailableTitle => 'Fotocamera non disponibile';

  @override
  String get cameraUnavailableBody =>
      'Impossibile aprire la fotocamera su questo dispositivo. Riprova.';

  @override
  String get cameraWebMockHint =>
      'L’anteprima web usa una fotocamera mock. Tocca l’otturatore per continuare.';

  @override
  String get captureReplaceTitle => 'Sostituisci foto';

  @override
  String get replacePhotoConfirmTitle => 'Usare questa foto?';

  @override
  String get replacePhotoConfirmBody =>
      'Sostituisce la foto di questa memoria. La trascrizione resta uguale.';

  @override
  String get replacePhotoUsePhoto => 'Usa foto';

  @override
  String get savingMemory => 'Salvataggio…';

  @override
  String get photoReplaced => 'Foto sostituita';

  @override
  String get saveMemoryFailed => 'Impossibile salvare questa memoria. Riprova.';

  @override
  String get replacePhotoFailed =>
      'Impossibile sostituire questa foto. Riprova.';

  @override
  String get viewPrivacyPolicy => 'Vedi Informativa sulla privacy';

  @override
  String get snackBackupSaveFailed =>
      'Impossibile salvare il file di backup. Riprova.';

  @override
  String aboutVersionLabel(String version, String buildNumber) {
    return 'Versione $version ($buildNumber)';
  }
}
