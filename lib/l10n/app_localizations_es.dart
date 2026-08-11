// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Encuentra tus cosas';

  @override
  String get homeRecentMemories => 'Recientes';

  @override
  String get homeNoMemoriesMatch =>
      'No hay memorias que coincidan con tu búsqueda.';

  @override
  String get homeEmptyTitle => 'Tus cosas aparecerán aquí.';

  @override
  String get homeEmptyBody =>
      'Haz una foto y dile a PutMind dónde las guardaste.';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => '¿Qué es esto? ¿Dónde lo guardaste?';

  @override
  String get voiceGuidanceLabel => 'Guía por voz';

  @override
  String get voiceGuidanceOn => 'Activado';

  @override
  String get voiceGuidanceOff => 'Desactivado';

  @override
  String get capturePromptPreview =>
      'Haz una foto y luego di o escribe dónde lo guardaste.';

  @override
  String get capturePromptGuiding => 'Reproduciendo la guía de voz…';

  @override
  String get capturePromptListening =>
      'Escuchando… habla natural o escribe en su lugar.';

  @override
  String get capturePromptEditing => 'Revisa la transcripción y guarda.';

  @override
  String get captureTranscriptHint => 'Escribe aquí si prefieres…';

  @override
  String get captureRetake => 'Repetir';

  @override
  String get captureSave => 'Guardar memoria';

  @override
  String get captureSnapMessage => 'Haz una foto de lo que vas a guardar.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsGroupGeneral => 'General';

  @override
  String get settingsGroupPrivacySecurity => 'Privacidad y seguridad';

  @override
  String get settingsGroupBackupPurchase => 'Copia de seguridad y compra';

  @override
  String get settingsGroupAbout => 'Acerca de';

  @override
  String get settingsLanguageRowTitle => 'Idioma';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, guía por voz y idioma del habla';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Guía por voz';

  @override
  String get settingsVoiceGuidanceRowSubtitle => 'Texto antes de escuchar';

  @override
  String get settingsDailyReminderRowTitle => 'Recordatorio diario';

  @override
  String get settingsDailyReminderOn => 'Activado';

  @override
  String get settingsDailyReminderOffSuggested =>
      'Desactivado · sugerido 9:00 PM';

  @override
  String get settingsAppLockRowTitle => 'Bloqueo de la app';

  @override
  String get settingsAppLockRowSubtitle => 'Biometría con PIN alternativo';

  @override
  String get settingsAutoLockRowTitle => 'Auto-bloqueo';

  @override
  String get settingsPrivacyRowTitle => 'Privacidad';

  @override
  String get settingsBackupRestoreRowTitle =>
      'Copia de seguridad y restauración';

  @override
  String get settingsLastBackupRowTitle => 'Última copia';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Mejorar Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Restaurar compra';

  @override
  String get settingsAboutPutMindRowTitle => 'Acerca de PutMind';

  @override
  String get languagePickerTitle => 'Idioma';

  @override
  String get autoLockPickerTitle => 'Auto-bloqueo';

  @override
  String get backupSheetTitle => 'Copia de seguridad y restauración';

  @override
  String get backupSheetBody =>
      'La copia cifrada se conectará más adelante. Estas acciones son mocks de UI.';

  @override
  String get createBackup => 'Crear copia';

  @override
  String get restoreBackup => 'Restaurar copia';

  @override
  String get privacyDialogTitle => 'Privacidad';

  @override
  String get privacyDialogBody =>
      'Tus memorias siguen siendo tuyas.\n\nPutMind es local-first: sin cuenta, sin base de datos en la nube de PutMind y sin subir fotos a servidores de PutMind en el MVP.\n\nEl reconocimiento de voz prefiere funcionar en el dispositivo. Los archivos de copia los gestionas tú.';

  @override
  String get aboutDialogTitle => 'Acerca de PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => 'Cerrar';

  @override
  String get turnOnAppLockDialogTitle => '¿Activar bloqueo de la app?';

  @override
  String get turnOnAppLockDialogBody =>
      'Desbloqueo biométrico con PIN alternativo protegerá tus memorias en este dispositivo.\n\nPutMind no tiene cuenta/backend: si olvidas el PIN, no se puede restablecer por email. Si la biometría sigue funcionando: desbloquea → Ajustes → cambia el PIN.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get enable => 'Activar';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Memorias ilimitadas desbloqueadas';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime ya está desbloqueado';

  @override
  String get unlockTitle => 'Desbloquear PutMind';

  @override
  String get unlockSubtitle =>
      'Tus memorias siguen privadas hasta que desbloqueas la app.';

  @override
  String get unlockWithBiometrics => 'Desbloquear con biometría';

  @override
  String get unlockUsePin => 'Usar PIN en su lugar';

  @override
  String get pinBack => 'Atrás';

  @override
  String get enterPin => 'Introduce PIN';

  @override
  String get pinMockText => 'Mock del paso 1: cualquier 4 dígitos desbloquean.';

  @override
  String get onboardingSnapTitle => 'Hazlo ya.';

  @override
  String get onboardingSnapBody =>
      'Haz una foto rápida de lo que vas a guardar. Sin formularios, carpetas ni categorías.';

  @override
  String get onboardingSayWhereTitle => 'Di dónde lo guardaste.';

  @override
  String get onboardingSayWhereBody =>
      'Habla natural — o escribe — qué es y dónde lo guardaste. La guía por voz te ayuda con ambas cosas.';

  @override
  String get onboardingFindLaterTitle => 'Encuéntralo después.';

  @override
  String get onboardingFindLaterBody =>
      'Busca tus memorias cuando necesites algo. PutMind lo recuerda por ti.';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String memoryDetailSaved(Object created) {
    return 'Guardado $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Guardado $created · Actualizado $updated';
  }

  @override
  String get memoryDetailEdit => 'Editar';

  @override
  String get memoryDetailReplacePhoto => 'Reemplazar foto';

  @override
  String get memoryDetailDelete => 'Eliminar';

  @override
  String get deleteDialogTitle => '¿Eliminar esta memoria?';

  @override
  String get deleteDialogBody =>
      'Esto elimina la foto y la memoria de este dispositivo.';

  @override
  String get deleteMemory => 'Eliminar memoria';

  @override
  String get editMemoryDialogTitle => 'Editar memoria';

  @override
  String get editMemoryHint => '¿Qué es esto? ¿Dónde lo guardaste?';

  @override
  String get editMemorySave => 'Guardar';

  @override
  String get paywallTitle => 'Desbloquear memorias ilimitadas';

  @override
  String get paywallBody =>
      'Has alcanzado el límite gratuito de 20 memorias. Las memorias existentes siguen disponibles.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · compra única';

  @override
  String get paywallUnlockLifetime => 'Desbloquear Lifetime';

  @override
  String get prototype => 'Prototipo';

  @override
  String get prototypePreviewStates => 'Ver estados';

  @override
  String get prototypeHint =>
      'Solo controles de prototipo — no es parte de la interfaz MVP de PutMind.';

  @override
  String get protoHome => 'Inicio';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Ajustes';

  @override
  String get protoUnlock => 'Desbloquear';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Inicio vacío';

  @override
  String get protoMemoryDetail => 'Detalle de memoria';

  @override
  String get protoPaywall => 'Paywall';

  @override
  String get snackMemorySaved => 'Memoria guardada';

  @override
  String get snackMemoryUpdated => 'Memoria actualizada';

  @override
  String get snackPhotoReplacedMock => 'Foto reemplazada (mock)';

  @override
  String get snackMemoryDeleted => 'Memoria eliminada';

  @override
  String get snackAppLockMockInfo =>
      'El bloqueo de la app guardará credenciales de forma segura más adelante. Por ahora, es estado UI.';

  @override
  String get snackReminderSchedulingMock =>
      'Los recordatorios se conectarán más adelante (mock)';

  @override
  String get snackBackupCreatedMock => 'Copia creada (mock)';

  @override
  String get snackRestoreBackupMock =>
      'La restauración se conectará más adelante (mock)';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime desbloqueado (compra mock)';

  @override
  String get snackPurchaseRestoredMock => 'Compra restaurada (mock)';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get voiceSearchTooltip => 'Búsqueda por voz';

  @override
  String get autoLockImmediately => 'Inmediatamente';

  @override
  String get autoLockOneMinute => 'Después de 1 minuto';

  @override
  String get autoLockFiveMinutes => 'Después de 5 minutos';

  @override
  String get autoLockFifteenMinutes => 'Después de 15 minutos';

  @override
  String get never => 'Nunca';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Memorias ilimitadas · $price una vez · $used/$limit usado';
  }
}
