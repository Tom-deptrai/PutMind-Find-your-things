// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get homeSearchPlaceholder => 'Tìm đồ của bạn';

  @override
  String get homeRecentMemories => 'Những kỷ niệm gần đây';

  @override
  String get homeNoMemoriesMatch =>
      'Không có kỷ niệm nào khớp với tìm kiếm của bạn.';

  @override
  String get homeEmptyTitle => 'Mọi thứ của bạn sẽ xuất hiện ở đây.';

  @override
  String get homeEmptyBody => 'Chụp ảnh và nói PutMind nơi bạn đã cất.';

  @override
  String get settingsTooltip => 'Cài đặt';

  @override
  String get captureTitle => 'Capture';

  @override
  String get capturePromptTitle => 'Cái này là gì? Bạn cất ở đâu?';

  @override
  String get voiceGuidanceLabel => 'Hướng dẫn bằng giọng nói';

  @override
  String get voiceGuidanceOn => 'Bật';

  @override
  String get voiceGuidanceOff => 'Tắt';

  @override
  String get capturePromptPreview =>
      'Chụp ảnh rồi nói hoặc nhập nơi bạn đã cất.';

  @override
  String get capturePromptGuiding => 'Đang phát hướng dẫn bằng giọng nói…';

  @override
  String get capturePromptListening =>
      'Đang nghe… hãy nói tự nhiên hoặc nhập thay thế.';

  @override
  String get capturePromptEditing => 'Xem lại nội dung và lưu lại.';

  @override
  String get captureTranscriptHint => 'Nhập vào đây nếu bạn muốn…';

  @override
  String get captureRetake => 'Chụp lại';

  @override
  String get captureSave => 'Lưu Memory';

  @override
  String get captureSnapMessage => 'Chụp món đồ bạn đang cất.';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsGroupGeneral => 'Chung';

  @override
  String get settingsGroupPrivacySecurity => 'Quyền riêng tư & bảo mật';

  @override
  String get settingsGroupBackupPurchase => 'Sao lưu & mua';

  @override
  String get settingsGroupAbout => 'Giới thiệu';

  @override
  String get settingsLanguageRowTitle => 'Ngôn ngữ';

  @override
  String get settingsLanguageRowSubtitle =>
      'Ứng dụng, hướng dẫn bằng giọng nói & ngôn ngữ giọng nói';

  @override
  String get settingsVoiceGuidanceRowTitle => 'Hướng dẫn bằng giọng nói';

  @override
  String get settingsVoiceGuidanceRowSubtitle =>
      'Nhắc nhở trước khi bắt đầu nghe';

  @override
  String get settingsDailyReminderRowTitle => 'Nhắc nhở hằng ngày';

  @override
  String get settingsDailyReminderOn => 'Bật';

  @override
  String get settingsDailyReminderOffSuggested => 'Tắt · gợi ý 9:00 PM';

  @override
  String get settingsAppLockRowTitle => 'Khóa ứng dụng';

  @override
  String get settingsAppLockRowSubtitle => 'Sinh trắc với tùy chọn PIN';

  @override
  String get settingsAutoLockRowTitle => 'Tự khóa';

  @override
  String get settingsPrivacyRowTitle => 'Quyền riêng tư';

  @override
  String get settingsBackupRestoreRowTitle => 'Sao lưu & khôi phục';

  @override
  String get settingsLastBackupRowTitle => 'Sao lưu gần nhất';

  @override
  String get settingsUpgradeLifetimeRowTitle => 'Nâng cấp Lifetime';

  @override
  String get settingsRestorePurchaseRowTitle => 'Khôi phục giao dịch';

  @override
  String get settingsAboutPutMindRowTitle => 'Giới thiệu về PutMind';

  @override
  String get languagePickerTitle => 'Ngôn ngữ';

  @override
  String get autoLockPickerTitle => 'Tự khóa';

  @override
  String get backupSheetTitle => 'Sao lưu & khôi phục';

  @override
  String get backupSheetBody =>
      'Sao lưu được mã hóa sẽ kết nối ở bước sau. Các nút này là bản mô phỏng giao diện để bạn xem.';

  @override
  String get createBackup => 'Tạo bản sao lưu';

  @override
  String get restoreBackup => 'Khôi phục bản sao lưu';

  @override
  String get privacyDialogTitle => 'Quyền riêng tư';

  @override
  String get privacyDialogBody =>
      'Kỷ niệm của bạn vẫn là của bạn.\n\nPutMind hoạt động theo hướng local-first: không có tài khoản, không có cơ sở dữ liệu đám mây của PutMind và không tải ảnh lên máy chủ PutMind ở MVP.\n\nNhận dạng giọng nói ưu tiên chạy trên thiết bị. Tệp sao lưu do bạn quản lý.';

  @override
  String get aboutDialogTitle => 'Giới thiệu về PutMind';

  @override
  String get aboutDialogBody =>
      'PutMind: Find Your Things\nSnap it. Say where. Find it later.\n\nVersion 1.0.0 (Step 1 — UI foundation)';

  @override
  String get close => 'Đóng';

  @override
  String get turnOnAppLockDialogTitle => 'Bật Khóa ứng dụng?';

  @override
  String get turnOnAppLockDialogBody =>
      'Mở khóa bằng sinh trắc với tùy chọn PIN sẽ bảo vệ các kỷ niệm trên thiết bị này.\n\nPutMind không có tài khoản/backend, vì vậy PIN bị quên không thể được đặt lại qua email. Nếu sinh trắc vẫn hoạt động: mở khóa → Cài đặt → đổi PIN.';

  @override
  String get cancel => 'Hủy';

  @override
  String get enable => 'Bật';

  @override
  String get lifetimeCardTitle => 'PutMind Lifetime';

  @override
  String get lifetimeCardUnlocked => 'Đã mở khóa bộ nhớ không giới hạn';

  @override
  String get lifetimeAlreadyUnlocked => 'Lifetime đã được mở khóa';

  @override
  String get unlockTitle => 'Mở khóa PutMind';

  @override
  String get unlockSubtitle =>
      'Kỷ niệm của bạn vẫn riêng tư cho đến khi bạn mở khóa ứng dụng.';

  @override
  String get unlockWithBiometrics => 'Mở khóa bằng sinh trắc';

  @override
  String get unlockUsePin => 'Dùng PIN thay thế';

  @override
  String get pinBack => 'Quay lại';

  @override
  String get enterPin => 'Nhập PIN';

  @override
  String get pinMockText =>
      'Bản mô phỏng Step 1: bất kỳ 4 chữ số nào cũng mở khóa được.';

  @override
  String get onboardingSnapTitle => 'Chụp nhanh.';

  @override
  String get onboardingSnapBody =>
      'Chụp ảnh nhanh món đồ bạn đang cất. Không biểu mẫu, không thư mục, không category.';

  @override
  String get onboardingSayWhereTitle => 'Nói bạn cất ở đâu.';

  @override
  String get onboardingSayWhereBody =>
      'Nói tự nhiên — hoặc nhập — bạn đang nói đây là gì và cất ở đâu. Voice Guidance giúp bạn nói cả hai phần.';

  @override
  String get onboardingFindLaterTitle => 'Tìm lại sau.';

  @override
  String get onboardingFindLaterBody =>
      'Tìm lại kỷ niệm khi bạn cần. PutMind nhớ giúp bạn.';

  @override
  String get onboardingContinue => 'Tiếp tục';

  @override
  String get onboardingGetStarted => 'Bắt đầu';

  @override
  String memoryDetailSaved(Object created) {
    return 'Đã lưu $created';
  }

  @override
  String memoryDetailSavedUpdated(Object created, Object updated) {
    return 'Đã lưu $created · Đã cập nhật $updated';
  }

  @override
  String get memoryDetailEdit => 'Chỉnh sửa';

  @override
  String get memoryDetailReplacePhoto => 'Thay ảnh';

  @override
  String get memoryDetailDelete => 'Xóa';

  @override
  String get deleteDialogTitle => 'Xóa kỷ niệm này?';

  @override
  String get deleteDialogBody =>
      'Thao tác này sẽ xóa ảnh và kỷ niệm khỏi thiết bị của bạn.';

  @override
  String get deleteMemory => 'Xóa kỷ niệm';

  @override
  String get editMemoryDialogTitle => 'Chỉnh sửa kỷ niệm';

  @override
  String get editMemoryHint => 'Cái này là gì? Bạn cất ở đâu?';

  @override
  String get editMemorySave => 'Lưu';

  @override
  String get paywallTitle => 'Mở khóa kỷ niệm không giới hạn';

  @override
  String get paywallBody =>
      'Bạn đã đạt giới hạn miễn phí 20 kỷ niệm. Kỷ niệm đã có vẫn có thể dùng.';

  @override
  String get paywallPrice => '\$6.99';

  @override
  String get paywallLifetimeLabel => 'Lifetime · mua một lần';

  @override
  String get paywallUnlockLifetime => 'Mở khóa Lifetime';

  @override
  String get prototype => 'Prototype';

  @override
  String get prototypePreviewStates => 'Xem trạng thái';

  @override
  String get prototypeHint =>
      'Chỉ dùng cho prototype — không thuộc giao diện MVP của PutMind.';

  @override
  String get protoHome => 'Home';

  @override
  String get protoCapture => 'Capture';

  @override
  String get protoSettings => 'Cài đặt';

  @override
  String get protoUnlock => 'Mở khóa';

  @override
  String get protoOnboarding => 'Onboarding';

  @override
  String get protoEmptyHome => 'Empty Home';

  @override
  String get protoMemoryDetail => 'Memory Detail';

  @override
  String get protoPaywall => 'Paywall';

  @override
  String get snackMemorySaved => 'Đã lưu kỷ niệm';

  @override
  String get snackMemoryUpdated => 'Đã cập nhật kỷ niệm';

  @override
  String get snackPhotoReplacedMock => 'Đã thay ảnh (mock)';

  @override
  String get snackMemoryDeleted => 'Đã xóa kỷ niệm';

  @override
  String get snackAppLockMockInfo =>
      'Khóa ứng dụng sẽ lưu thông tin an toàn ở bước sau. Hiện tại đây là state UI.';

  @override
  String get snackReminderSchedulingMock =>
      'Việc nhắc nhở sẽ kết nối ở bước sau (mock)';

  @override
  String get snackBackupCreatedMock => 'Đã tạo bản sao lưu (mock)';

  @override
  String get snackRestoreBackupMock => 'Khôi phục sẽ kết nối ở bước sau (mock)';

  @override
  String get snackLifetimeUnlockedMock => 'Đã mở Lifetime (mock purchase)';

  @override
  String get snackPurchaseRestoredMock => 'Đã khôi phục giao dịch (mock)';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get voiceSearchTooltip => 'Tìm kiếm bằng giọng nói';

  @override
  String get autoLockImmediately => 'Ngay lập tức';

  @override
  String get autoLockOneMinute => 'Sau 1 phút';

  @override
  String get autoLockFiveMinutes => 'Sau 5 phút';

  @override
  String get autoLockFifteenMinutes => 'Sau 15 phút';

  @override
  String get never => 'Không bao giờ';

  @override
  String lifetimeCardLocked(Object limit, Object price, Object used) {
    return 'Kỷ niệm không giới hạn · $price một lần · $used/$limit đã dùng';
  }
}
