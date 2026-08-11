// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Trouve tes affaires';

  @override
  String get homeRecentMemories => 'Dernières mémoires';

  @override
  String get homeNoMemoriesMatch =>
      'Aucune mémoire ne correspond à ta recherche.';

  @override
  String get homeEmptyTitle => 'Tes affaires apparaîtront ici.';

  @override
  String get homeEmptyBody =>
      'Prends une photo et dis à PutMind où tu les as rangées.';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'Qu’est-ce que c’est ? Où l’as-tu rangé ?';

  @override
  String get voiceGuidanceLabel => 'Guidage vocal';

  @override
  String get voiceGuidanceOn => 'Actif';

  @override
  String get voiceGuidanceOff => 'Désactivé';

  @override
  String get capturePromptPreview =>
      'Prends une photo, puis dis ou tape où tu l’as rangé(e).';

  @override
  String get capturePromptGuiding => 'Lecture du guidage vocal…';

  @override
  String get capturePromptListening =>
      'J’écoute… parle naturellement, ou tape plutôt.';

  @override
  String get capturePromptEditing =>
      'Vérifie la transcription, puis enregistre.';

  @override
  String get captureTranscriptHint => 'Tape ici si tu préfères…';

  @override
  String get captureRetake => 'Reprendre';

  @override
  String get captureAddPhoto => '+ Photo';

  @override
  String capturePhotoCount(int count, int max) {
    return '$count/$max';
  }

  @override
  String memoryDetailPhotoIndex(int current, int total) {
    return '$current/$total';
  }

  @override
  String get captureSave => 'Enregistrer la mémoire';

  @override
  String get captureSnapMessage => 'Prends une photo de ce que tu ranges.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsGroupGeneral => 'Général';

  @override
  String get settingsGroupPrivacySecurity => 'Confidentialité & sécurité';

  @override
  String get settingsGroupBackupPurchase => 'Sauvegarde & achat';

  @override
  String get settingsGroupAbout => 'À propos';

  @override
  String get settingsLanguageRowTitle => 'Langue';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, guidage vocal et langue de reconnaissance';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Guidage vocal';

  @override
  String get settingsVoiceGuidanceRowSubtitle => 'Texte avant l’écoute';

  @override
  String get settingsDailyReminderRowTitle => 'Rappel quotidien';

  @override
  String get settingsDailyReminderOn => 'Activé';

  @override
  String get settingsDailyReminderOffSuggested => 'Désactivé · suggéré 21:00';

  @override
  String get settingsAppLockRowTitle => 'Verrouillage de l’app';

  @override
  String get settingsAppLockRowSubtitle => 'Biométrie avec secours par PIN';

  @override
  String get settingsAutoLockRowTitle => 'Verrouillage automatique';

  @override
  String get settingsPrivacyRowTitle => 'Confidentialité';

  @override
  String get settingsBackupRestoreRowTitle => 'Sauvegarde & restauration';

  @override
  String get settingsLastBackupRowTitle => 'Dernière sauvegarde';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Pass Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Restaurer l’achat';

  @override
  String get settingsAboutPutMindRowTitle => 'À propos de PutMind';

  @override
  String get languagePickerTitle => 'Langue';

  @override
  String get autoLockPickerTitle => 'Verrouillage automatique';

  @override
  String get backupSheetTitle => 'Sauvegarde & restauration';

  @override
  String get backupSheetBody =>
      'Créez une sauvegarde chiffrée à enregistrer où vous voulez, ou restaurez une sauvegarde. Le mot de passe de sauvegarde est distinct du code PIN App Lock.';

  @override
  String get createBackup => 'Créer une sauvegarde';

  @override
  String get restoreBackup => 'Restaurer la sauvegarde';

  @override
  String get backupPasswordCreateTitle =>
      'Définir le mot de passe de sauvegarde';

  @override
  String get backupPasswordEnterTitle => 'Entrer le mot de passe de sauvegarde';

  @override
  String get backupPasswordLabel => 'Mot de passe de sauvegarde';

  @override
  String get backupPasswordConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get backupPasswordWarning =>
      'Si vous oubliez ce mot de passe, PutMind ne peut pas récupérer la sauvegarde. Il n’y a pas de réinitialisation de compte.';

  @override
  String get backupPasswordTooShort => 'Utilisez au moins 4 caractères.';

  @override
  String get backupPasswordMismatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get restoreConfirmTitle => 'Remplacer les mémoires actuelles ?';

  @override
  String get restoreConfirmBody =>
      'La restauration remplacera les mémoires sur cet appareil. Action irréversible.';

  @override
  String get snackBackupCreated => 'Sauvegarde créée';

  @override
  String get snackBackupRestored => 'Sauvegarde restaurée';

  @override
  String get snackBackupFailed =>
      'Échec de la sauvegarde. Vos données actuelles n’ont pas changé.';

  @override
  String get snackBackupWrongPassword =>
      'Mot de passe de sauvegarde incorrect.';

  @override
  String get snackBackupCorrupted =>
      'Ce fichier de sauvegarde est corrompu ou incomplet.';

  @override
  String get snackBackupUnsupported =>
      'Cette version de sauvegarde n’est pas prise en charge.';

  @override
  String get snackBackupCancelled => 'Sauvegarde annulée.';

  @override
  String get paywallPurchasePending => 'Traitement…';

  @override
  String get snackLifetimeUnlocked => 'Lifetime déverrouillé';

  @override
  String get snackPurchaseRestored => 'Achat restauré';

  @override
  String get snackPurchaseRestoreNone =>
      'Aucun achat Lifetime trouvé pour ce compte.';

  @override
  String get snackPurchaseCancelled => 'Achat annulé.';

  @override
  String get snackPurchaseFailed => 'Échec de l’achat. Réessayez.';

  @override
  String get snackPurchaseAlreadyOwned => 'Lifetime déjà acheté.';

  @override
  String get snackStoreUnavailable =>
      'Le magasin est indisponible pour le moment.';

  @override
  String get privacyDialogTitle => 'Confidentialité';

  @override
  String get privacyDialogBody =>
      'Tes mémoires restent les tiennes.\n\nPutMind est local-first : pas de compte, pas de base de données cloud PutMind, et pas d’envoi de photos vers les serveurs PutMind dans le MVP.\n\nLa reconnaissance audio privilégie l’exécution sur l’appareil. Les fichiers de sauvegarde sont gérés par toi.';

  @override
  String get aboutDialogTitle => 'À propos de PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => 'Fermer';

  @override
  String get turnOnAppLockDialogTitle => 'Activer le verrouillage de l’app ?';

  @override
  String get turnOnAppLockDialogBody =>
      'Le déverrouillage biométrique avec secours par PIN protégera tes mémoires sur cet appareil.\n\nPutMind n’a pas de compte/backend : un PIN oublié ne peut pas être réinitialisé par email. Si la biométrie fonctionne encore : déverrouiller → Paramètres → changer le PIN.';

  @override
  String get cancel => 'Annuler';

  @override
  String get enable => 'Activer';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Mémoires illimitées débloquées';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime est déjà débloqué';

  @override
  String get unlockTitle => 'Déverrouiller PutMind';

  @override
  String get unlockSubtitle =>
      'Tes mémoires restent privées jusqu’à ce que tu déverrouilles l’app.';

  @override
  String get unlockWithBiometrics => 'Déverrouiller avec biométrie';

  @override
  String get unlockUsePin => 'Utiliser le PIN à la place';

  @override
  String get pinBack => 'Retour';

  @override
  String get enterPin => 'Entrer le PIN';

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
  String get onboardingSnapTitle => 'Prends une photo.';

  @override
  String get onboardingSnapBody =>
      'Prends rapidement une photo de l’objet que tu ranges. Pas de formulaires, dossiers ni catégories.';

  @override
  String get onboardingSayWhereTitle => 'Dis où tu l’as rangé(e).';

  @override
  String get onboardingSayWhereBody =>
      'Parle naturellement — ou tape — ce que c’est et où tu l’as stocké. Le guidage vocal t’aide pour les deux.';

  @override
  String get onboardingFindLaterTitle => 'Retrouve-le plus tard.';

  @override
  String get onboardingFindLaterBody =>
      'Cherche dans tes mémoires quand tu as besoin. PutMind s’en souvient pour toi.';

  @override
  String get onboardingContinue => 'Continuer';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String memoryDetailSaved(Object created) {
    return 'Enregistré $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Enregistré $created · Mis à jour $updated';
  }

  @override
  String get memoryDetailEdit => 'Modifier';

  @override
  String get memoryDetailReplacePhoto => 'Remplacer la photo';

  @override
  String get memoryDetailDelete => 'Supprimer';

  @override
  String get deleteDialogTitle => 'Supprimer cette mémoire ?';

  @override
  String get deleteDialogBody =>
      'Cela retire la photo et la mémoire de cet appareil.';

  @override
  String get deleteMemory => 'Supprimer la mémoire';

  @override
  String get editMemoryDialogTitle => 'Modifier la mémoire';

  @override
  String get editMemoryHint => 'C’est quoi ? Où l’as-tu rangé ?';

  @override
  String get editMemorySave => 'Enregistrer';

  @override
  String get paywallTitle => 'Débloquer des mémoires illimitées';

  @override
  String get paywallBody =>
      'Tu as atteint la limite gratuite de 20 mémoires. Les mémoires existantes restent disponibles.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · achat unique';

  @override
  String get paywallUnlockLifetime => 'Débloquer Lifetime';

  @override
  String get snackMemorySaved => 'Mémoire enregistrée';

  @override
  String get snackMemoryUpdated => 'Mémoire mise à jour';

  @override
  String get snackPhotoReplacedMock => 'Photo remplacée (mock)';

  @override
  String get snackMemoryDeleted => 'Mémoire supprimée';

  @override
  String get snackAppLockMockInfo =>
      'Le verrouillage de l’app sera sécurisé plus tard. Pour l’instant : état UI.';

  @override
  String get snackReminderSchedulingMock =>
      'Le rappel sera connecté plus tard (mock)';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get voiceSearchTooltip => 'Recherche vocale';

  @override
  String get autoLockImmediately => 'Immédiatement';

  @override
  String get autoLockOneMinute => 'Après 1 minute';

  @override
  String get autoLockFiveMinutes => 'Après 5 minutes';

  @override
  String get autoLockFifteenMinutes => 'Après 15 minutes';

  @override
  String get never => 'Jamais';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Mémoires illimitées · $price une fois · $used/$limit utilisé';
  }

  @override
  String get cameraPermissionTitle => 'Accès à la caméra requis';

  @override
  String get cameraPermissionDenied =>
      'PutMind a besoin de la caméra pour photographier ce que tu ranges. Tu peux l’activer dans Réglages.';

  @override
  String get cameraPermissionRetry => 'Réessayer';

  @override
  String get cameraPermissionOpenSettings => 'Ouvrir Réglages';

  @override
  String get cameraUnavailableTitle => 'Caméra indisponible';

  @override
  String get cameraUnavailableBody =>
      'Impossible d’ouvrir la caméra sur cet appareil. Réessaie.';

  @override
  String get cameraWebMockHint =>
      'L’aperçu web utilise une caméra fictive. Appuie sur le déclencheur pour continuer.';

  @override
  String get captureReplaceTitle => 'Remplacer la photo';

  @override
  String get replacePhotoConfirmTitle => 'Utiliser cette photo ?';

  @override
  String get replacePhotoConfirmBody =>
      'Cela remplace la photo de cette mémoire. La transcription reste la même.';

  @override
  String get replacePhotoUsePhoto => 'Utiliser la photo';

  @override
  String get savingMemory => 'Enregistrement…';

  @override
  String get photoReplaced => 'Photo remplacée';

  @override
  String get saveMemoryFailed =>
      'Impossible d’enregistrer cette mémoire. Réessaie.';

  @override
  String get replacePhotoFailed =>
      'Impossible de remplacer cette photo. Réessaie.';
}
