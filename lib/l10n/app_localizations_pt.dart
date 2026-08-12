// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Encontre suas coisas';

  @override
  String get homeRecentMemories => 'Memórias recentes';

  @override
  String get homeNoMemoriesMatch =>
      'Não há memórias que correspondam à sua busca.';

  @override
  String get homeEmptyTitle => 'Suas coisas aparecerão aqui.';

  @override
  String get homeEmptyBody =>
      'Tire uma foto e diga ao PutMind onde você guardou.';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'O que é isso? Onde você guardou?';

  @override
  String get voiceGuidanceLabel => 'Guia por voz';

  @override
  String get voiceGuidanceOn => 'Ligado';

  @override
  String get voiceGuidanceOff => 'Desligado';

  @override
  String get capturePromptPreview =>
      'Tire uma foto e depois diga ou digite onde você guardou.';

  @override
  String get capturePromptGuiding => 'Reproduzindo guia por voz…';

  @override
  String get capturePromptListening =>
      'Ouvindo… fale naturalmente, ou digite em vez disso.';

  @override
  String get capturePromptEditing => 'Revise a transcrição e salve.';

  @override
  String get captureTranscriptHint => 'Digite aqui se preferir…';

  @override
  String get captureRetake => 'Repetir';

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
  String get captureSave => 'Salvar memória';

  @override
  String get captureSnapMessage => 'Tire uma foto do que você vai guardar.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsGroupGeneral => 'Geral';

  @override
  String get settingsGroupPrivacySecurity => 'Privacidade e segurança';

  @override
  String get settingsGroupBackupPurchase => 'Backup e compra';

  @override
  String get settingsGroupAbout => 'Sobre';

  @override
  String get settingsLanguageRowTitle => 'Idioma';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, guia por voz e idioma do reconhecimento';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Guia por voz';

  @override
  String get settingsVoiceGuidanceRowSubtitle => 'Texto antes de ouvir';

  @override
  String get settingsDailyReminderRowTitle => 'Lembrete diário';

  @override
  String get settingsDailyReminderOn => 'Ligado';

  @override
  String get settingsDailyReminderOffSuggested => 'Desligado · sugerido 21:00';

  @override
  String get settingsAppLockRowTitle => 'Bloqueio do app';

  @override
  String get settingsAppLockRowSubtitle => 'Biometria com PIN alternativo';

  @override
  String get settingsAutoLockRowTitle => 'Bloqueio automático';

  @override
  String get settingsPrivacyRowTitle => 'Privacidade';

  @override
  String get settingsBackupRestoreRowTitle => 'Backup e restauração';

  @override
  String get settingsLastBackupRowTitle => 'Último backup';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Ativar Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Restaurar compra';

  @override
  String get settingsAboutPutMindRowTitle => 'Sobre o PutMind';

  @override
  String get languagePickerTitle => 'Idioma';

  @override
  String get autoLockPickerTitle => 'Bloqueio automático';

  @override
  String get backupSheetTitle => 'Backup e restauração';

  @override
  String get backupSheetBody =>
      'Crie um backup criptografado e escolha onde salvar, ou restaure um backup anterior. A senha do backup é separada do PIN do bloqueio.';

  @override
  String get createBackup => 'Criar backup';

  @override
  String get restoreBackup => 'Restaurar backup';

  @override
  String get backupPasswordCreateTitle => 'Definir senha do backup';

  @override
  String get backupPasswordEnterTitle => 'Digite a senha do backup';

  @override
  String get backupPasswordLabel => 'Senha do backup';

  @override
  String get backupPasswordConfirmLabel => 'Confirmar senha';

  @override
  String get backupPasswordWarning =>
      'Se esquecer esta senha, o PutMind não pode recuperar o backup. Não há redefinição por conta.';

  @override
  String get backupPasswordTooShort => 'Use pelo menos 4 caracteres.';

  @override
  String get backupPasswordMismatch => 'As senhas não coincidem.';

  @override
  String get restoreConfirmTitle => 'Substituir memórias atuais?';

  @override
  String get restoreConfirmBody =>
      'Restaurar substituirá as memórias neste dispositivo. Não pode ser desfeito.';

  @override
  String get snackBackupCreated => 'Backup criado';

  @override
  String get snackBackupRestored => 'Backup restaurado';

  @override
  String get snackBackupFailed =>
      'Falha no backup. Seus dados atuais não mudaram.';

  @override
  String get snackBackupWrongPassword => 'Senha do backup incorreta.';

  @override
  String get snackBackupCorrupted =>
      'Este arquivo de backup está corrompido ou incompleto.';

  @override
  String get snackBackupUnsupported => 'Esta versão de backup não é suportada.';

  @override
  String get snackBackupCancelled => 'Backup cancelado.';

  @override
  String get paywallPurchasePending => 'Processando…';

  @override
  String get snackLifetimeUnlocked => 'Lifetime desbloqueado';

  @override
  String get snackPurchaseRestored => 'Compra restaurada';

  @override
  String get snackPurchaseRestoreNone =>
      'Nenhuma compra Lifetime encontrada para esta conta.';

  @override
  String get snackPurchaseCancelled => 'Compra cancelada.';

  @override
  String get snackPurchaseFailed => 'Falha na compra. Tente novamente.';

  @override
  String get snackPurchaseAlreadyOwned => 'Lifetime já comprado.';

  @override
  String get snackStoreUnavailable => 'A loja está indisponível no momento.';

  @override
  String get privacyDialogTitle => 'Privacidade';

  @override
  String get privacyDialogBody =>
      'Suas memórias continuam sendo suas.\\n\\nO PutMind é local-first: memórias, fotos e transcrições ficam neste dispositivo. Não há conta PutMind nem sincronização na nuvem do PutMind. Câmera e microfone só para funções que você escolher. O reconhecimento de voz usa recursos do dispositivo/plataforma. O lembrete diário usa notificações locais. PIN e biometria ficam no dispositivo. Backups criptografados são arquivos que você cria e salva. Compras no app são processadas pela Apple ou Google. O PutMind não vende seus dados.';

  @override
  String get aboutDialogTitle => 'Sobre o PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\\nSnap it. Say where. Find it later.';

  @override
  String get close => 'Fechar';

  @override
  String get turnOnAppLockDialogTitle => 'Ativar bloqueio do app?';

  @override
  String get turnOnAppLockDialogBody =>
      'Desbloqueio biométrico com PIN alternativo protegerá suas memórias neste dispositivo.\n\nO PutMind não tem conta/backend, então um PIN esquecido não pode ser redefinido por e-mail. Se a biometria ainda funcionar: desbloqueie → Configurações → altere o PIN.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get enable => 'Ativar';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Memórias ilimitadas desbloqueadas';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime já está desbloqueado';

  @override
  String get unlockTitle => 'Desbloquear PutMind';

  @override
  String get unlockSubtitle =>
      'Suas memórias ficam privadas até você desbloquear o app.';

  @override
  String get unlockWithBiometrics => 'Desbloquear com biometria';

  @override
  String get unlockUsePin => 'Usar PIN em vez disso';

  @override
  String get pinBack => 'Voltar';

  @override
  String get enterPin => 'Digite o PIN';

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
  String get onboardingSnapTitle => 'Tire.';

  @override
  String get onboardingSnapBody =>
      'Tire uma foto rápida do que você está guardando. Sem formulários, pastas ou categorias.';

  @override
  String get onboardingSayWhereTitle => 'Diga onde você colocou.';

  @override
  String get onboardingSayWhereBody =>
      'Fale naturalmente — ou digite — o que é e onde você guardou. O guia por voz ajuda nos dois.';

  @override
  String get onboardingFindLaterTitle => 'Encontre depois.';

  @override
  String get onboardingFindLaterBody =>
      'Busque suas memórias quando precisar de algo. O PutMind lembra por você.';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String memoryDetailSaved(Object created) {
    return 'Salvo $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Salvo $created · Atualizado $updated';
  }

  @override
  String get memoryDetailEdit => 'Editar';

  @override
  String get memoryDetailReplacePhoto => 'Substituir foto';

  @override
  String get memoryDetailDelete => 'Excluir';

  @override
  String get deleteDialogTitle => 'Excluir esta memória?';

  @override
  String get deleteDialogBody => 'Remove a foto e a memória deste dispositivo.';

  @override
  String get deleteMemory => 'Excluir memória';

  @override
  String get editMemoryDialogTitle => 'Editar memória';

  @override
  String get editMemoryHint => 'O que é isso? Onde você guardou?';

  @override
  String get editMemorySave => 'Salvar';

  @override
  String get paywallTitle => 'Desbloquear memórias ilimitadas';

  @override
  String get paywallBody =>
      'Você atingiu o limite gratuito de 20 memórias. As memórias existentes continuam disponíveis.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · compra única';

  @override
  String get paywallUnlockLifetime => 'Desbloquear Lifetime';

  @override
  String get snackMemorySaved => 'Memória salva';

  @override
  String get snackMemoryUpdated => 'Memória atualizada';

  @override
  String get snackPhotoReplacedMock => 'Foto substituída (mock)';

  @override
  String get snackMemoryDeleted => 'Memória excluída';

  @override
  String get snackAppLockMockInfo =>
      'O bloqueio do app salva credenciais com segurança em uma etapa posterior. Por enquanto é apenas estado de UI.';

  @override
  String get snackReminderSchedulingMock =>
      'O lembrete será conectado em uma etapa posterior (mock)';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get voiceSearchTooltip => 'Pesquisa por voz';

  @override
  String get autoLockImmediately => 'Imediatamente';

  @override
  String get autoLockOneMinute => 'Após 1 minuto';

  @override
  String get autoLockFiveMinutes => 'Após 5 minutos';

  @override
  String get autoLockFifteenMinutes => 'Após 15 minutos';

  @override
  String get never => 'Nunca';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Memórias ilimitadas · $price uma vez · $used/$limit usado';
  }

  @override
  String get cameraPermissionTitle => 'Acesso à câmera necessário';

  @override
  String get cameraPermissionDenied =>
      'O PutMind precisa da câmera para fotografar o que você está guardando. Você pode ativá-la em Configurações.';

  @override
  String get cameraPermissionRetry => 'Tentar novamente';

  @override
  String get cameraPermissionOpenSettings => 'Abrir Configurações';

  @override
  String get cameraUnavailableTitle => 'Câmera indisponível';

  @override
  String get cameraUnavailableBody =>
      'Não foi possível abrir a câmera neste dispositivo. Tente novamente.';

  @override
  String get cameraWebMockHint =>
      'A prévia web usa uma câmera simulada. Toque no obturador para continuar.';

  @override
  String get captureReplaceTitle => 'Substituir foto';

  @override
  String get replacePhotoConfirmTitle => 'Usar esta foto?';

  @override
  String get replacePhotoConfirmBody =>
      'Isso substitui a foto desta memória. A transcrição permanece a mesma.';

  @override
  String get replacePhotoUsePhoto => 'Usar foto';

  @override
  String get savingMemory => 'Salvando…';

  @override
  String get photoReplaced => 'Foto substituída';

  @override
  String get saveMemoryFailed =>
      'Não foi possível salvar esta memória. Tente novamente.';

  @override
  String get replacePhotoFailed =>
      'Não foi possível substituir esta foto. Tente novamente.';

  @override
  String get viewPrivacyPolicy => 'Ver Política de Privacidade';

  @override
  String get snackBackupSaveFailed =>
      'Não foi possível salvar o arquivo de backup. Tente novamente.';

  @override
  String aboutVersionLabel(String version, String buildNumber) {
    return 'Versão $version ($buildNumber)';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get homeSearchPlaceholder => 'Encontre suas coisas';

  @override
  String get homeRecentMemories => 'Memórias recentes';

  @override
  String get homeNoMemoriesMatch =>
      'Não há memórias que correspondam à sua busca.';

  @override
  String get homeEmptyTitle => 'Suas coisas aparecerão aqui.';

  @override
  String get homeEmptyBody =>
      'Tire uma foto e diga ao PutMind onde você guardou.';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'O que é isso? Onde você guardou?';

  @override
  String get voiceGuidanceLabel => 'Guia por voz';

  @override
  String get voiceGuidanceOn => 'Ligado';

  @override
  String get voiceGuidanceOff => 'Desligado';

  @override
  String get capturePromptPreview =>
      'Tire uma foto e depois diga ou digite onde você guardou.';

  @override
  String get capturePromptGuiding => 'Reproduzindo guia por voz…';

  @override
  String get capturePromptListening =>
      'Ouvindo… fale naturalmente, ou digite em vez disso.';

  @override
  String get capturePromptEditing => 'Revise a transcrição e salve.';

  @override
  String get captureTranscriptHint => 'Digite aqui se preferir…';

  @override
  String get captureRetake => 'Repetir';

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
  String get captureSave => 'Salvar memória';

  @override
  String get captureSnapMessage => 'Tire uma foto do que você vai guardar.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsGroupGeneral => 'Geral';

  @override
  String get settingsGroupPrivacySecurity => 'Privacidade e segurança';

  @override
  String get settingsGroupBackupPurchase => 'Backup e compra';

  @override
  String get settingsGroupAbout => 'Sobre';

  @override
  String get settingsLanguageRowTitle => 'Idioma';

  @override
  String get settingsLanguageRowSubtitle =>
      'App, guia por voz e idioma do reconhecimento';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Guia por voz';

  @override
  String get settingsVoiceGuidanceRowSubtitle => 'Texto antes de ouvir';

  @override
  String get settingsDailyReminderRowTitle => 'Lembrete diário';

  @override
  String get settingsDailyReminderOn => 'Ligado';

  @override
  String get settingsDailyReminderOffSuggested => 'Desligado · sugerido 21:00';

  @override
  String get settingsAppLockRowTitle => 'Bloqueio do app';

  @override
  String get settingsAppLockRowSubtitle => 'Biometria com PIN alternativo';

  @override
  String get settingsAutoLockRowTitle => 'Bloqueio automático';

  @override
  String get settingsPrivacyRowTitle => 'Privacidade';

  @override
  String get settingsBackupRestoreRowTitle => 'Backup e restauração';

  @override
  String get settingsLastBackupRowTitle => 'Último backup';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Ativar Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Restaurar compra';

  @override
  String get settingsAboutPutMindRowTitle => 'Sobre o PutMind';

  @override
  String get languagePickerTitle => 'Idioma';

  @override
  String get autoLockPickerTitle => 'Bloqueio automático';

  @override
  String get backupSheetTitle => 'Backup e restauração';

  @override
  String get backupSheetBody =>
      'Crie um backup criptografado e escolha onde salvar, ou restaure um backup anterior. A senha do backup é separada do PIN do bloqueio.';

  @override
  String get createBackup => 'Criar backup';

  @override
  String get restoreBackup => 'Restaurar backup';

  @override
  String get backupPasswordCreateTitle => 'Definir senha do backup';

  @override
  String get backupPasswordEnterTitle => 'Digite a senha do backup';

  @override
  String get backupPasswordLabel => 'Senha do backup';

  @override
  String get backupPasswordConfirmLabel => 'Confirmar senha';

  @override
  String get backupPasswordWarning =>
      'Se esquecer esta senha, o PutMind não pode recuperar o backup. Não há redefinição por conta.';

  @override
  String get backupPasswordTooShort => 'Use pelo menos 4 caracteres.';

  @override
  String get backupPasswordMismatch => 'As senhas não coincidem.';

  @override
  String get restoreConfirmTitle => 'Substituir memórias atuais?';

  @override
  String get restoreConfirmBody =>
      'Restaurar substituirá as memórias neste dispositivo. Não pode ser desfeito.';

  @override
  String get snackBackupCreated => 'Backup criado';

  @override
  String get snackBackupRestored => 'Backup restaurado';

  @override
  String get snackBackupFailed =>
      'Falha no backup. Seus dados atuais não mudaram.';

  @override
  String get snackBackupWrongPassword => 'Senha do backup incorreta.';

  @override
  String get snackBackupCorrupted =>
      'Este arquivo de backup está corrompido ou incompleto.';

  @override
  String get snackBackupUnsupported => 'Esta versão de backup não é suportada.';

  @override
  String get snackBackupCancelled => 'Backup cancelado.';

  @override
  String get paywallPurchasePending => 'Processando…';

  @override
  String get snackLifetimeUnlocked => 'Lifetime desbloqueado';

  @override
  String get snackPurchaseRestored => 'Compra restaurada';

  @override
  String get snackPurchaseRestoreNone =>
      'Nenhuma compra Lifetime encontrada para esta conta.';

  @override
  String get snackPurchaseCancelled => 'Compra cancelada.';

  @override
  String get snackPurchaseFailed => 'Falha na compra. Tente novamente.';

  @override
  String get snackPurchaseAlreadyOwned => 'Lifetime já comprado.';

  @override
  String get snackStoreUnavailable => 'A loja está indisponível no momento.';

  @override
  String get privacyDialogTitle => 'Privacidade';

  @override
  String get privacyDialogBody =>
      'Suas memórias continuam sendo suas.\\n\\nO PutMind é local-first: memórias, fotos e transcrições ficam neste dispositivo. Não há conta PutMind nem sincronização na nuvem do PutMind. Câmera e microfone só para funções que você escolher. O reconhecimento de voz usa recursos do dispositivo/plataforma. O lembrete diário usa notificações locais. PIN e biometria ficam no dispositivo. Backups criptografados são arquivos que você cria e salva. Compras no app são processadas pela Apple ou Google. O PutMind não vende seus dados.';

  @override
  String get aboutDialogTitle => 'Sobre o PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\\nSnap it. Say where. Find it later.';

  @override
  String get close => 'Fechar';

  @override
  String get turnOnAppLockDialogTitle => 'Ativar bloqueio do app?';

  @override
  String get turnOnAppLockDialogBody =>
      'Desbloqueio biométrico com PIN alternativo protegerá suas memórias neste dispositivo.\n\nO PutMind não tem conta/backend, então um PIN esquecido não pode ser redefinido por e-mail. Se a biometria ainda funcionar: desbloqueie → Configurações → altere o PIN.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get enable => 'Ativar';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Memórias ilimitadas desbloqueadas';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime já está desbloqueado';

  @override
  String get unlockTitle => 'Desbloquear PutMind';

  @override
  String get unlockSubtitle =>
      'Suas memórias ficam privadas até você desbloquear o app.';

  @override
  String get unlockWithBiometrics => 'Desbloquear com biometria';

  @override
  String get unlockUsePin => 'Usar PIN em vez disso';

  @override
  String get pinBack => 'Voltar';

  @override
  String get enterPin => 'Digite o PIN';

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
  String get onboardingSnapTitle => 'Tire.';

  @override
  String get onboardingSnapBody =>
      'Tire uma foto rápida do que você está guardando. Sem formulários, pastas ou categorias.';

  @override
  String get onboardingSayWhereTitle => 'Diga onde você colocou.';

  @override
  String get onboardingSayWhereBody =>
      'Fale naturalmente — ou digite — o que é e onde você guardou. O guia por voz ajuda nos dois.';

  @override
  String get onboardingFindLaterTitle => 'Encontre depois.';

  @override
  String get onboardingFindLaterBody =>
      'Busque suas memórias quando precisar de algo. O PutMind lembra por você.';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingGetStarted => 'Começar';

  @override
  String memoryDetailSaved(Object created) {
    return 'Salvo $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Salvo $created · Atualizado $updated';
  }

  @override
  String get memoryDetailEdit => 'Editar';

  @override
  String get memoryDetailReplacePhoto => 'Substituir foto';

  @override
  String get memoryDetailDelete => 'Excluir';

  @override
  String get deleteDialogTitle => 'Excluir esta memória?';

  @override
  String get deleteDialogBody => 'Remove a foto e a memória deste dispositivo.';

  @override
  String get deleteMemory => 'Excluir memória';

  @override
  String get editMemoryDialogTitle => 'Editar memória';

  @override
  String get editMemoryHint => 'O que é isso? Onde você guardou?';

  @override
  String get editMemorySave => 'Salvar';

  @override
  String get paywallTitle => 'Desbloquear memórias ilimitadas';

  @override
  String get paywallBody =>
      'Você atingiu o limite gratuito de 20 memórias. As memórias existentes continuam disponíveis.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · compra única';

  @override
  String get paywallUnlockLifetime => 'Desbloquear Lifetime';

  @override
  String get snackMemorySaved => 'Memória salva';

  @override
  String get snackMemoryUpdated => 'Memória atualizada';

  @override
  String get snackPhotoReplacedMock => 'Foto substituída (mock)';

  @override
  String get snackMemoryDeleted => 'Memória excluída';

  @override
  String get snackAppLockMockInfo =>
      'O bloqueio do app salva credenciais com segurança em uma etapa posterior. Por enquanto é apenas estado de UI.';

  @override
  String get snackReminderSchedulingMock =>
      'O lembrete será conectado em uma etapa posterior (mock)';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get voiceSearchTooltip => 'Pesquisa por voz';

  @override
  String get autoLockImmediately => 'Imediatamente';

  @override
  String get autoLockOneMinute => 'Após 1 minuto';

  @override
  String get autoLockFiveMinutes => 'Após 5 minutos';

  @override
  String get autoLockFifteenMinutes => 'Após 15 minutos';

  @override
  String get never => 'Nunca';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Memórias ilimitadas · $price uma vez · $used/$limit usado';
  }

  @override
  String get cameraPermissionTitle => 'Acesso à câmera necessário';

  @override
  String get cameraPermissionDenied =>
      'O PutMind precisa da câmera para fotografar o que você está guardando. Você pode ativá-la em Configurações.';

  @override
  String get cameraPermissionRetry => 'Tentar novamente';

  @override
  String get cameraPermissionOpenSettings => 'Abrir Configurações';

  @override
  String get cameraUnavailableTitle => 'Câmera indisponível';

  @override
  String get cameraUnavailableBody =>
      'Não foi possível abrir a câmera neste dispositivo. Tente novamente.';

  @override
  String get cameraWebMockHint =>
      'A prévia web usa uma câmera simulada. Toque no obturador para continuar.';

  @override
  String get captureReplaceTitle => 'Substituir foto';

  @override
  String get replacePhotoConfirmTitle => 'Usar esta foto?';

  @override
  String get replacePhotoConfirmBody =>
      'Isso substitui a foto desta memória. A transcrição permanece a mesma.';

  @override
  String get replacePhotoUsePhoto => 'Usar foto';

  @override
  String get savingMemory => 'Salvando…';

  @override
  String get photoReplaced => 'Foto substituída';

  @override
  String get saveMemoryFailed =>
      'Não foi possível salvar esta memória. Tente novamente.';

  @override
  String get replacePhotoFailed =>
      'Não foi possível substituir esta foto. Tente novamente.';

  @override
  String get viewPrivacyPolicy => 'Ver Política de Privacidade';

  @override
  String get snackBackupSaveFailed =>
      'Não foi possível salvar o arquivo de backup. Tente novamente.';

  @override
  String aboutVersionLabel(String version, String buildNumber) {
    return 'Versão $version ($buildNumber)';
  }
}
