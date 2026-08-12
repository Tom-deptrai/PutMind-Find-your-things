import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_urls.dart';
import '../models/settings.dart';
import '../services/app_package_info.dart';
import '../services/backup_file_saver.dart';
import '../services/memory_repository.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_switch.dart';
import '../widgets/settings_widgets.dart';
import '../l10n/app_localizations.dart';
import '../utils/memory_time_format.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.state,
    this.backupFileSaver = const SystemBackupFileSaver(),
    this.packageInfoLoader = AppPackageInfo.load,
    this.privacyUrlLauncher,
  });

  final AppState state;
  final BackupFileSaver backupFileSaver;
  final Future<AppPackageInfo> Function() packageInfoLoader;
  final Future<bool> Function(Uri uri)? privacyUrlLauncher;

  Future<void> _pickLanguage(BuildContext context) async {
    final selected = await showModalBottomSheet<AppLanguage>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.languagePickerTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (final lang in AppLanguage.values)
                      ListTile(
                        title: Text(lang.label),
                        trailing: state.settings.language == lang
                            ? const Icon(Icons.check, color: AppColors.accent)
                            : null,
                        onTap: () => Navigator.pop(context, lang),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) await state.setLanguage(selected);
  }

  Future<void> _pickAutoLock(BuildContext context) async {
    final selected = await showModalBottomSheet<AutoLockInterval>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.autoLockPickerTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (final interval in AutoLockInterval.values)
                      ListTile(
                        title: Text(_autoLockLabel(context, interval)),
                        trailing: state.settings.autoLock == interval
                            ? const Icon(Icons.check, color: AppColors.accent)
                            : null,
                        onTap: () => Navigator.pop(context, interval),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) await state.setAutoLock(selected);
  }

  Future<void> _pickReminderTime(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: state.settings.reminderHour,
        minute: state.settings.reminderMinute,
      ),
    );
    if (time == null || !context.mounted) return;
    state.reminderTitle = l10n.dailyReminderNotificationTitle;
    state.reminderBody = l10n.dailyReminderNotificationBody;
    await state.setReminderTime(time.hour, time.minute);
  }

  Future<void> _showBackupSheet(BuildContext context) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.backupSheetTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(l10n.backupSheetBody, style: AppTypography.body),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'create'),
                  child: Text(l10n.createBackup),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'restore'),
                  child: Text(l10n.restoreBackup),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!context.mounted || action == null) return;
    if (action == 'create') {
      await _createBackup(context);
    } else if (action == 'restore') {
      await _restoreBackup(context);
    }
  }

  Future<void> _createBackup(BuildContext context) async {
    final password = await showBackupPasswordDialog(
      context: context,
      confirm: true,
    );
    if (password == null || !context.mounted) return;

    final bytes = await state.exportBackupBytes(password);
    if (bytes == null || !context.mounted) return;

    final fileName = defaultBackupFileName();
    String? savedPath;
    try {
      savedPath = await backupFileSaver.saveBackup(
        fileName: fileName,
        bytes: bytes,
      );
    } catch (_) {
      state.reportBackupSaveFailed();
      return;
    }

    // User cancelled the system save picker — silent, no Last Backup update.
    if (savedPath == null) return;

    await state.markBackupSaved();
  }

  Future<void> _restoreBackup(BuildContext context) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: false,
    );
    if (picked == null || picked.files.isEmpty) return;
    final path = picked.files.single.path;
    if (path == null) return;
    if (!context.mounted) return;

    final password = await showBackupPasswordDialog(
      context: context,
      confirm: false,
    );
    if (password == null || !context.mounted) return;

    final confirmed = await showRestoreConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    await state.restoreBackupFromPath(path: path, password: password);
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(kPrivacyPolicyUrl);
    try {
      final launcher = privacyUrlLauncher;
      if (launcher != null) {
        await launcher(uri);
        return;
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Offline / no browser — in-app summary remains readable; never crash.
    }
  }

  Future<void> _showPrivacy(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          scrollable: true,
          title: Text(l10n.privacyDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.privacyDialogBody, style: AppTypography.body),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _openPrivacyPolicy();
                },
                child: Text(l10n.viewPrivacyPolicy),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAbout(BuildContext context) async {
    final info = await packageInfoLoader();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          scrollable: true,
          title: Text(l10n.aboutDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.aboutDialogBody, style: AppTypography.body),
              const SizedBox(height: 12),
              Text(
                l10n.aboutVersionLabel(info.version, info.buildNumber),
                style: AppTypography.meta,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAppLock(BuildContext context, bool enable) async {
    if (!enable) {
      await state.setAppLock(false);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.turnOnAppLockDialogTitle),
          content: Text(
            l10n.turnOnAppLockDialogBody,
            style: AppTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.enable),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await state.setAppLock(true);
      if (state.awaitingPinSetup && context.mounted) {
        await showPinSetupDialog(context: context, state: state);
      }
    }
  }

  String _autoLockLabel(BuildContext context, AutoLockInterval interval) {
    final l10n = AppLocalizations.of(context)!;
    return switch (interval) {
      AutoLockInterval.immediately => l10n.autoLockImmediately,
      AutoLockInterval.oneMinute => l10n.autoLockOneMinute,
      AutoLockInterval.fiveMinutes => l10n.autoLockFiveMinutes,
      AutoLockInterval.fifteenMinutes => l10n.autoLockFifteenMinutes,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = state.settings;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final l10n = AppLocalizations.of(context)!;
    final timeOfDay = TimeOfDay(hour: s.reminderHour, minute: s.reminderMinute);
    final timeLabel = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(timeOfDay);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 7, 17, 0),
              child: SizedBox(
                height: 58,
                child: Row(
                  children: [
                    AppIconButton(
                      icon: Icons.arrow_back,
                      onPressed: state.openHome,
                    ),
                    Expanded(
                      child: Text(
                        l10n.settingsTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.screenTitle,
                      ),
                    ),
                    const SizedBox(width: 42),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(17, 0, 17, 95 + bottom),
                children: [
                  Container(
                    padding: const EdgeInsets.all(13),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.upgradeBg,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: AppColors.upgradeBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.lifetimeCardTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.isLifetimeUnlocked
                              ? l10n.lifetimeCardUnlocked
                              : l10n.lifetimeCardLocked(
                                  kFreeMemoryLimit.toString(),
                                  state.purchaseService.localizedPrice ??
                                      l10n.paywallPrice,
                                  state.memoryCount.toString(),
                                ),
                          style: AppTypography.meta,
                        ),
                      ],
                    ),
                  ),
                  SettingsGroupLabel(l10n.settingsGroupGeneral),
                  SettingsRow(
                    title: l10n.settingsLanguageRowTitle,
                    subtitle: l10n.settingsLanguageRowSubtitle,
                    trailing: SettingsPill('${s.language.label} ›'),
                    onTap: () => _pickLanguage(context),
                  ),
                  SettingsRow(
                    title: l10n.settingsVoiceGuidanceRowTitle,
                    subtitle: l10n.settingsVoiceGuidanceRowSubtitle,
                    trailing: AppSwitch(
                      value: s.voiceGuidance,
                      onChanged: (v) => state.setVoiceGuidance(v),
                    ),
                  ),
                  SettingsRow(
                    title: l10n.settingsDailyReminderRowTitle,
                    subtitle: s.dailyReminder
                        ? '${l10n.settingsDailyReminderOn} · $timeLabel'
                        : l10n.settingsDailyReminderOffSuggested,
                    trailing: AppSwitch(
                      value: s.dailyReminder,
                      onChanged: (v) async {
                        state.reminderTitle =
                            l10n.dailyReminderNotificationTitle;
                        state.reminderBody = l10n.dailyReminderNotificationBody;
                        final ok = await state.setDailyReminder(v);
                        if (ok && v && context.mounted) {
                          await _pickReminderTime(context);
                        }
                      },
                    ),
                    onTap: s.dailyReminder
                        ? () async {
                            state.reminderTitle =
                                l10n.dailyReminderNotificationTitle;
                            state.reminderBody =
                                l10n.dailyReminderNotificationBody;
                            await _pickReminderTime(context);
                          }
                        : null,
                  ),
                  SettingsGroupLabel(l10n.settingsGroupPrivacySecurity),
                  SettingsRow(
                    title: l10n.settingsAppLockRowTitle,
                    subtitle: l10n.settingsAppLockRowSubtitle,
                    trailing: AppSwitch(
                      value: s.appLock,
                      onChanged: (v) => _confirmAppLock(context, v),
                    ),
                  ),
                  SettingsRow(
                    title: l10n.settingsAutoLockRowTitle,
                    trailing: SettingsPill(
                      '${_autoLockLabel(context, s.autoLock)} ›',
                    ),
                    onTap: () => _pickAutoLock(context),
                  ),
                  SettingsRow(
                    title: l10n.settingsPrivacyRowTitle,
                    trailing: const Text('›'),
                    onTap: () => _showPrivacy(context),
                  ),
                  SettingsGroupLabel(l10n.settingsGroupBackupPurchase),
                  SettingsRow(
                    title: l10n.settingsBackupRestoreRowTitle,
                    trailing: const Text('›'),
                    onTap: () => _showBackupSheet(context),
                  ),
                  SettingsRow(
                    title: l10n.settingsLastBackupRowTitle,
                    trailing: Text(
                      s.lastBackupAt == null
                          ? l10n.never
                          : formatMemoryTimestamp(context, s.lastBackupAt!),
                      style: AppTypography.meta,
                    ),
                  ),
                  SettingsRow(
                    title: l10n.settingsUpgradeLifetimeRowTitle,
                    trailing: s.isLifetimeUnlocked
                        ? Text(
                            l10n.lifetimeAlreadyUnlocked,
                            style: AppTypography.meta,
                          )
                        : const Text('›'),
                    onTap: s.isLifetimeUnlocked
                        ? null
                        : () =>
                              showPaywallDialog(context: context, state: state),
                  ),
                  SettingsRow(
                    title: l10n.settingsRestorePurchaseRowTitle,
                    trailing: const Text('›'),
                    onTap: () => state.restorePurchases(),
                  ),
                  SettingsGroupLabel(l10n.settingsGroupAbout),
                  SettingsRow(
                    title: l10n.settingsAboutPutMindRowTitle,
                    trailing: const Text('›'),
                    showDivider: false,
                    onTap: () => _showAbout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
