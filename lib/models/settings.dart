import 'dart:ui' show Locale;

enum AppLanguage {
  english(Locale('en'), 'English'),
  japanese(Locale('ja'), '日本語'),
  german(Locale('de'), 'Deutsch'),
  vietnamese(Locale('vi'), 'Tiếng Việt'),
  korean(Locale('ko'), '한국어'),
  french(Locale('fr'), 'Français'),
  spanish(Locale('es'), 'Español'),
  portugueseBrazil(Locale('pt', 'BR'), 'Português (Brasil)'),
  italian(Locale('it'), 'Italiano'),
  traditionalChineseHant(Locale('zh', 'Hant'), '繁體中文');

  const AppLanguage(this.locale, this.label);

  final Locale locale;
  final String label;
}

enum AutoLockInterval { immediately, oneMinute, fiveMinutes, fifteenMinutes }

/// Settings state for MVP UI (native wiring comes in later steps).
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.english,
    this.voiceGuidance = true,
    this.dailyReminder = false,
    this.reminderHour = 21,
    this.reminderMinute = 0,
    this.appLock = false,
    this.autoLock = AutoLockInterval.immediately,
    this.isLifetimeUnlocked = false,
    this.lastBackupAt,
    this.onboardingCompleted = true,
  });

  final AppLanguage language;
  final bool voiceGuidance;
  final bool dailyReminder;
  final int reminderHour;
  final int reminderMinute;
  final bool appLock;
  final AutoLockInterval autoLock;
  final bool isLifetimeUnlocked;
  final DateTime? lastBackupAt;
  final bool onboardingCompleted;

  AppSettings copyWith({
    AppLanguage? language,
    bool? voiceGuidance,
    bool? dailyReminder,
    int? reminderHour,
    int? reminderMinute,
    bool? appLock,
    AutoLockInterval? autoLock,
    bool? isLifetimeUnlocked,
    DateTime? lastBackupAt,
    bool clearLastBackup = false,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      language: language ?? this.language,
      voiceGuidance: voiceGuidance ?? this.voiceGuidance,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      appLock: appLock ?? this.appLock,
      autoLock: autoLock ?? this.autoLock,
      isLifetimeUnlocked: isLifetimeUnlocked ?? this.isLifetimeUnlocked,
      lastBackupAt: clearLastBackup
          ? null
          : (lastBackupAt ?? this.lastBackupAt),
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
