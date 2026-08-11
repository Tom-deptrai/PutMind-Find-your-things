// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get homeSearchPlaceholder => '내 물건 찾기';

  @override
  String get homeRecentMemories => '최근 메모리';

  @override
  String get homeNoMemoriesMatch => '검색 결과와 일치하는 메모리가 없습니다.';

  @override
  String get homeEmptyTitle => '여기에 내 물건이 표시됩니다.';

  @override
  String get homeEmptyBody => '사진을 찍고 PutMind에 보관한 위치를 알려주세요.';

  @override
  String get settingsTooltip => '설정';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => '이건 무엇인가요? 어디에 두었나요?';

  @override
  String get voiceGuidanceLabel => '음성 안내';

  @override
  String get voiceGuidanceOn => '켬';

  @override
  String get voiceGuidanceOff => '끔';

  @override
  String get capturePromptPreview => '사진을 찍고, 어디에 두었는지 말하거나 입력하세요.';

  @override
  String get capturePromptGuiding => '음성 안내를 재생 중…';

  @override
  String get capturePromptListening => '듣고 있어요… 자연스럽게 말하거나 대신 입력하세요.';

  @override
  String get capturePromptEditing => '전사를 확인한 뒤 저장하세요.';

  @override
  String get captureTranscriptHint => '원하면 여기 입력하세요…';

  @override
  String get captureRetake => '다시 찍기';

  @override
  String get captureSave => '메모리 저장';

  @override
  String get captureSnapMessage => '치우는 물건을 찍어보세요.';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsGroupGeneral => '일반';

  @override
  String get settingsGroupPrivacySecurity => '개인정보 & 보안';

  @override
  String get settingsGroupBackupPurchase => '백업 & 구매';

  @override
  String get settingsGroupAbout => '정보';

  @override
  String get settingsLanguageRowTitle => '언어';

  @override
  String get settingsLanguageRowSubtitle => '앱, 음성 안내 & 음성 인식 로케일';

  @override
  String get settingsVoiceGuidanceRowTitle => '음성 안내';

  @override
  String get settingsVoiceGuidanceRowSubtitle => '듣기 전에 안내 문구';

  @override
  String get settingsDailyReminderRowTitle => '매일 알림';

  @override
  String get settingsDailyReminderOn => '켬';

  @override
  String get settingsDailyReminderOffSuggested => '끔 · 권장 9:00 PM';

  @override
  String get settingsAppLockRowTitle => '앱 잠금';

  @override
  String get settingsAppLockRowSubtitle => '생체 인식 + PIN 대체';

  @override
  String get settingsAutoLockRowTitle => '자동 잠금';

  @override
  String get settingsPrivacyRowTitle => '개인정보';

  @override
  String get settingsBackupRestoreRowTitle => '백업 & 복원';

  @override
  String get settingsLastBackupRowTitle => '마지막 백업';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Lifetime 업그레이드';

  @override
  String get settingsRestorePurchaseRowTitle => '구매 복원';

  @override
  String get settingsAboutPutMindRowTitle => 'PutMind 정보';

  @override
  String get languagePickerTitle => '언어';

  @override
  String get autoLockPickerTitle => '자동 잠금';

  @override
  String get backupSheetTitle => '백업 & 복원';

  @override
  String get backupSheetBody => '암호화 백업은 다음 단계에서 연결됩니다. 지금은 리뷰용 UI 모크입니다.';

  @override
  String get createBackup => '백업 만들기';

  @override
  String get restoreBackup => '백업 복원';

  @override
  String get privacyDialogTitle => '개인정보';

  @override
  String get privacyDialogBody =>
      '내 메모리는 내 것이에요.\n\nPutMind는 로컬 우선입니다: 계정 없음, PutMind 클라우드 DB 없음, 그리고 MVP에서는 PutMind 서버로 사진 업로드 없음.\n\n음성 인식은 가능한 경우 기기에서 처리합니다. 백업 파일은 사용자가 관리합니다.';

  @override
  String get aboutDialogTitle => 'PutMind 정보';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => '닫기';

  @override
  String get turnOnAppLockDialogTitle => '앱 잠금을 켤까요?';

  @override
  String get turnOnAppLockDialogBody =>
      'PIN 대체가 있는 생체 잠금 해제로 이 기기에서 메모리를 보호합니다.\n\nPutMind에는 계정/백엔드가 없어서, 잊어버린 PIN은 이메일로 재설정할 수 없습니다. 생체 인식이 계속된다면: 잠금 해제 → 설정 → PIN 변경.';

  @override
  String get cancel => '취소';

  @override
  String get enable => '켜기';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => '무제한 메모리 잠금 해제 완료';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime은 이미 잠금 해제됨';

  @override
  String get unlockTitle => 'PutMind 잠금 해제';

  @override
  String get unlockSubtitle => '앱을 잠금 해제할 때까지 메모리는 비공개로 유지됩니다.';

  @override
  String get unlockWithBiometrics => '생체 인식으로 잠금 해제';

  @override
  String get unlockUsePin => 'PIN을 사용';

  @override
  String get pinBack => '뒤로';

  @override
  String get enterPin => 'PIN 입력';

  @override
  String get pinMockText => 'Step 1 모크: 어떤 4자리든 잠금 해제됩니다.';

  @override
  String get onboardingSnapTitle => '바로 찍기.';

  @override
  String get onboardingSnapBody =>
      '정리할 물건을 빠르게 사진으로 찍어주세요. 양식, 폴더, 카테고리는 없습니다.';

  @override
  String get onboardingSayWhereTitle => '어디에 두었는지 말하기.';

  @override
  String get onboardingSayWhereBody =>
      '무엇인지와 어디에 두었는지 자연스럽게 말하거나(또는 입력)하세요. 음성 안내가 둘 다를 도와줍니다.';

  @override
  String get onboardingFindLaterTitle => '나중에 찾기.';

  @override
  String get onboardingFindLaterBody =>
      '필요할 때 메모리를 검색하세요. PutMind가 기억해 주기 때문에 신경 쓰지 않아도 됩니다.';

  @override
  String get onboardingContinue => '계속';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String memoryDetailSaved(Object created) {
    return '$created에 저장됨';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return '$created에 저장 · $updated에 업데이트됨';
  }

  @override
  String get memoryDetailEdit => '편집';

  @override
  String get memoryDetailReplacePhoto => '사진 교체';

  @override
  String get memoryDetailDelete => '삭제';

  @override
  String get deleteDialogTitle => '이 메모리를 삭제할까요?';

  @override
  String get deleteDialogBody => '사진과 메모리를 이 기기에서 삭제합니다.';

  @override
  String get deleteMemory => '메모리 삭제';

  @override
  String get editMemoryDialogTitle => '메모리 편집';

  @override
  String get editMemoryHint => '이건 무엇인가요? 어디에 두었나요?';

  @override
  String get editMemorySave => '저장';

  @override
  String get paywallTitle => '무제한 메모리 잠금 해제';

  @override
  String get paywallBody => '무료 한도(20개 메모리)에 도달했어요. 기존 메모리는 계속 사용할 수 있습니다.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · 일회성 구매';

  @override
  String get paywallUnlockLifetime => 'Lifetime 잠금 해제';

  @override
  String get prototype => '프로토타입';

  @override
  String get prototypePreviewStates => '상태 미리보기';

  @override
  String get prototypeHint => '프로토타입용 컨트롤만 있습니다 — PutMind MVP 인터페이스의 일부가 아닙니다.';

  @override
  String get protoHome => '홈';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => '설정';

  @override
  String get protoUnlock => '잠금 해제';

  @override
  String get protoOnboarding => '온보딩';

  @override
  String get protoEmptyHome => '빈 홈';

  @override
  String get protoMemoryDetail => '메모리 상세';

  @override
  String get protoPaywall => '페이월';

  @override
  String get snackMemorySaved => '메모리 저장됨';

  @override
  String get snackMemoryUpdated => '메모리 업데이트됨';

  @override
  String get snackPhotoReplacedMock => '사진 교체(모크)';

  @override
  String get snackMemoryDeleted => '메모리 삭제됨';

  @override
  String get snackAppLockMockInfo => '앱 잠금은 다음 단계에서 안전하게 저장됩니다. 지금은 UI 상태입니다.';

  @override
  String get snackReminderSchedulingMock => '알림 설정은 다음 단계에서 연결됩니다(모크)';

  @override
  String get snackBackupCreatedMock => '백업 생성(모크)';

  @override
  String get snackRestoreBackupMock => '복원은 다음 단계에서 연결됩니다(모크)';

  @override
  String get snackLifetimeUnlockedMock => 'Lifetime 잠금 해제(모크 구매)';

  @override
  String get snackPurchaseRestoredMock => '구매 복원(모크)';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get voiceSearchTooltip => '음성 검색';

  @override
  String get autoLockImmediately => '즉시';

  @override
  String get autoLockOneMinute => '1분 후';

  @override
  String get autoLockFiveMinutes => '5분 후';

  @override
  String get autoLockFifteenMinutes => '15분 후';

  @override
  String get never => '안 함';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return '무제한 메모리 · $price 1회 · $used/$limit 사용 중';
  }

  @override
  String get cameraPermissionTitle => '카메라 접근 필요';

  @override
  String get cameraPermissionDenied =>
      'PutMind는 정리하는 물건을 촬영하기 위해 카메라가 필요합니다. 설정에서 켤 수 있습니다.';

  @override
  String get cameraPermissionRetry => '다시 시도';

  @override
  String get cameraPermissionOpenSettings => '설정 열기';

  @override
  String get cameraUnavailableTitle => '카메라를 사용할 수 없음';

  @override
  String get cameraUnavailableBody => '이 기기에서 카메라를 열 수 없습니다. 다시 시도해 주세요.';

  @override
  String get cameraWebMockHint => '웹 미리보기는 모의 카메라를 사용합니다. 셔터를 눌러 계속하세요.';

  @override
  String get captureReplaceTitle => '사진 교체';

  @override
  String get replacePhotoConfirmTitle => '이 사진을 사용할까요?';

  @override
  String get replacePhotoConfirmBody => '이 메모리의 사진을 교체합니다. 전사는 그대로 유지됩니다.';

  @override
  String get replacePhotoUsePhoto => '사진 사용';

  @override
  String get savingMemory => '저장 중…';

  @override
  String get photoReplaced => '사진이 교체됨';

  @override
  String get saveMemoryFailed => '메모리를 저장할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get replacePhotoFailed => '사진을 교체할 수 없습니다. 다시 시도해 주세요.';
}
