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
      'O backup criptografado será conectado em uma etapa posterior. Estas ações são mocks de UI para revisão.';

  @override
  String get createBackup => 'Criar backup';

  @override
  String get restoreBackup => 'Restaurar backup';

  @override
  String get privacyDialogTitle => 'Privacidade';

  @override
  String get privacyDialogBody =>
      'Suas memórias continuam sendo suas.\n\nO PutMind é local-first: sem conta, sem banco de dados em nuvem do PutMind e sem upload de fotos para servidores do PutMind no MVP.\n\nO reconhecimento de voz prefere ser executado no dispositivo. Arquivos de backup são gerenciados por você.';

  @override
  String get aboutDialogTitle => 'Sobre o PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

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
  String get pinMockText => 'Mock do passo 1: qualquer 4 dígitos desbloqueiam.';

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
  String get prototype => 'Protótipo';

  @override
  String get prototypePreviewStates => 'Pré-visualizar estados';

  @override
  String get prototypeHint =>
      'Somente controles de protótipo — não faz parte da interface MVP do PutMind.';

  @override
  String get protoHome => 'Início';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Configurações';

  @override
  String get protoUnlock => 'Desbloquear';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Início vazio';

  @override
  String get protoMemoryDetail => 'Detalhe da memória';

  @override
  String get protoPaywall => 'Paywall';

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
  String get snackBackupCreatedMock => 'Backup criado (mock)';

  @override
  String get snackRestoreBackupMock =>
      'A restauração será conectada em uma etapa posterior (mock)';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime desbloqueado (compra mock)';

  @override
  String get snackPurchaseRestoredMock => 'Compra restaurada (mock)';

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
      'O backup criptografado será conectado em uma etapa posterior. Estas ações são mocks de UI para revisão.';

  @override
  String get createBackup => 'Criar backup';

  @override
  String get restoreBackup => 'Restaurar backup';

  @override
  String get privacyDialogTitle => 'Privacidade';

  @override
  String get privacyDialogBody =>
      'Suas memórias continuam sendo suas.\n\nO PutMind é local-first: sem conta, sem banco de dados em nuvem do PutMind e sem upload de fotos para servidores do PutMind no MVP.\n\nO reconhecimento de voz prefere ser executado no dispositivo. Arquivos de backup são gerenciados por você.';

  @override
  String get aboutDialogTitle => 'Sobre o PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

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
  String get pinMockText => 'Mock do passo 1: qualquer 4 dígitos desbloqueiam.';

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
  String get prototype => 'Protótipo';

  @override
  String get prototypePreviewStates => 'Pré-visualizar estados';

  @override
  String get prototypeHint =>
      'Somente controles de protótipo — não faz parte da interface MVP do PutMind.';

  @override
  String get protoHome => 'Início';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Configurações';

  @override
  String get protoUnlock => 'Desbloquear';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Início vazio';

  @override
  String get protoMemoryDetail => 'Detalhe da memória';

  @override
  String get protoPaywall => 'Paywall';

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
  String get snackBackupCreatedMock => 'Backup criado (mock)';

  @override
  String get snackRestoreBackupMock =>
      'A restauração será conectada em uma etapa posterior (mock)';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime desbloqueado (compra mock)';

  @override
  String get snackPurchaseRestoredMock => 'Compra restaurada (mock)';

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
}
