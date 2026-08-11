import 'dart:ui' show Locale;

enum AppLanguage {
  /// locale tag for UI (Flutter localization)
  english(
    Locale('en'),
    'English',
    voiceGuidanceLocale: 'en-US',
    speechToTextLocale: 'en-US',
  ),
  japanese(
    Locale('ja'),
    '日本語',
    voiceGuidanceLocale: 'ja-JP',
    speechToTextLocale: 'ja-JP',
  ),
  german(
    Locale('de'),
    'Deutsch',
    voiceGuidanceLocale: 'de-DE',
    speechToTextLocale: 'de-DE',
  ),
  vietnamese(
    Locale('vi'),
    'Tiếng Việt',
    voiceGuidanceLocale: 'vi-VN',
    speechToTextLocale: 'vi-VN',
  ),
  korean(
    Locale('ko'),
    '한국어',
    voiceGuidanceLocale: 'ko-KR',
    speechToTextLocale: 'ko-KR',
  ),
  french(
    Locale('fr'),
    'Français',
    voiceGuidanceLocale: 'fr-FR',
    speechToTextLocale: 'fr-FR',
  ),
  spanish(
    Locale('es'),
    'Español',
    voiceGuidanceLocale: 'es-ES',
    speechToTextLocale: 'es-ES',
  ),
  portugueseBrazil(
    Locale('pt', 'BR'),
    'Português (Brasil)',
    voiceGuidanceLocale: 'pt-BR',
    speechToTextLocale: 'pt-BR',
  ),
  italian(
    Locale('it'),
    'Italiano',
    voiceGuidanceLocale: 'it-IT',
    speechToTextLocale: 'it-IT',
  ),
  traditionalChineseHant(
    Locale('zh', 'Hant'),
    '繁體中文',
    voiceGuidanceLocale: 'zh-TW',
    speechToTextLocale: 'zh-TW',
  );

  const AppLanguage(
    this.locale,
    this.label, {
    required this.voiceGuidanceLocale,
    required this.speechToTextLocale,
  });

  final Locale locale;
  final String label;

  /// Locale tag for future voice guidance assets/tts selection.
  final String voiceGuidanceLocale;

  /// Locale tag for future speech-to-text recognition selection.
  final String speechToTextLocale;
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
