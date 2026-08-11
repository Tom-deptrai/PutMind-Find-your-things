enum AppLanguage {
  english('en', 'English'),
  japanese('ja', '日本語'),
  german('de', 'Deutsch'),
  vietnamese('vi', 'Tiếng Việt');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;
}

enum AutoLockInterval {
  immediately('Immediately'),
  oneMinute('After 1 minute'),
  fiveMinutes('After 5 minutes'),
  fifteenMinutes('After 15 minutes');

  const AutoLockInterval(this.label);

  final String label;
}

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

  String get reminderTimeLabel {
    final h = reminderHour % 12 == 0 ? 12 : reminderHour % 12;
    final amPm = reminderHour >= 12 ? 'PM' : 'AM';
    final m = reminderMinute.toString().padLeft(2, '0');
    return '$h:$m $amPm';
  }

  String get lastBackupLabel {
    if (lastBackupAt == null) return 'Never';
    return formatMemoryTimestamp(lastBackupAt!);
  }

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

String formatMemoryTimestamp(DateTime dateTime, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final local = dateTime.toLocal();
  final today = DateTime(current.year, current.month, current.day);
  final thatDay = DateTime(local.year, local.month, local.day);
  final time = _formatTime(local);

  if (thatDay == today) return 'Today, $time';
  if (thatDay == today.subtract(const Duration(days: 1))) {
    return 'Yesterday, $time';
  }

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[local.month - 1]} ${local.day}, $time';
}

String _formatTime(DateTime dt) {
  final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final amPm = dt.hour >= 12 ? 'PM' : 'AM';
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m $amPm';
}
