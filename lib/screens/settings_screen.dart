import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../services/memory_repository.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_switch.dart';
import '../widgets/settings_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.state});

  final AppState state;

  Future<void> _pickLanguage(BuildContext context) async {
    final selected = await showModalBottomSheet<AppLanguage>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Language',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
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
        );
      },
    );
    if (selected != null) state.setLanguage(selected);
  }

  Future<void> _pickAutoLock(BuildContext context) async {
    final selected = await showModalBottomSheet<AutoLockInterval>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Auto-lock',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              for (final interval in AutoLockInterval.values)
                ListTile(
                  title: Text(interval.label),
                  trailing: state.settings.autoLock == interval
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : null,
                  onTap: () => Navigator.pop(context, interval),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null) state.setAutoLock(selected);
  }

  Future<void> _pickReminderTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: state.settings.reminderHour,
        minute: state.settings.reminderMinute,
      ),
    );
    if (time != null) {
      state.setReminderTime(time.hour, time.minute);
    }
  }

  Future<void> _showBackupSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Backup & Restore',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encrypted backup connects in a later step. These actions are UI mocks for review.',
                  style: AppTypography.body,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    state.mockCreateBackup();
                  },
                  child: const Text('Create Backup'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    state.mockRestoreBackup();
                  },
                  child: const Text('Restore Backup'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPrivacy(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy'),
          content: const Text(
            'Your memories stay yours.\n\n'
            'PutMind is local-first: no account, no PutMind cloud database, '
            'and no photo upload to PutMind servers in the MVP.\n\n'
            'Speech prefers on-device recognition. Backup files are managed by you.',
            style: AppTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAbout(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About PutMind'),
          content: const Text(
            'PutMind: Find Your Things\n'
            'Snap it. Say where. Find it later.\n\n'
            'Version 1.0.0 (Step 1 — UI foundation)',
            style: AppTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAppLock(BuildContext context, bool enable) async {
    if (!enable) {
      state.setAppLock(false);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Turn on App Lock?'),
          content: const Text(
            'Biometric unlock with PIN fallback will protect your memories on this device.\n\n'
            'PutMind has no account/backend, so a forgotten PIN cannot be reset by email. '
            'If biometric still works, unlock → Settings → change PIN.',
            style: AppTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) state.setAppLock(true);
  }

  @override
  Widget build(BuildContext context) {
    final s = state.settings;
    final bottom = MediaQuery.paddingOf(context).bottom;

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
                    const Expanded(
                      child: Text(
                        'Settings',
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
                        const Text(
                          'PutMind Lifetime',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.isLifetimeUnlocked
                              ? 'Unlimited memories unlocked'
                              : 'Unlimited memories · \$6.99 once · '
                                    '${state.memoryCount}/$kFreeMemoryLimit used',
                          style: AppTypography.meta,
                        ),
                      ],
                    ),
                  ),
                  const SettingsGroupLabel('General'),
                  SettingsRow(
                    title: 'Language',
                    subtitle: 'App, voice guidance & speech locale',
                    trailing: SettingsPill('${s.language.label} ›'),
                    onTap: () => _pickLanguage(context),
                  ),
                  SettingsRow(
                    title: 'Voice Guidance',
                    subtitle: 'Prompt before listening',
                    trailing: AppSwitch(
                      value: s.voiceGuidance,
                      onChanged: state.setVoiceGuidance,
                    ),
                  ),
                  SettingsRow(
                    title: 'Daily Reminder',
                    subtitle: s.dailyReminder
                        ? 'On · ${s.reminderTimeLabel}'
                        : 'Off · suggested 9:00 PM',
                    trailing: AppSwitch(
                      value: s.dailyReminder,
                      onChanged: (v) async {
                        state.setDailyReminder(v);
                        if (v) await _pickReminderTime(context);
                      },
                    ),
                    onTap: s.dailyReminder
                        ? () => _pickReminderTime(context)
                        : null,
                  ),
                  const SettingsGroupLabel('Privacy & security'),
                  SettingsRow(
                    title: 'App Lock',
                    subtitle: 'Biometric with PIN fallback',
                    trailing: AppSwitch(
                      value: s.appLock,
                      onChanged: (v) => _confirmAppLock(context, v),
                    ),
                  ),
                  SettingsRow(
                    title: 'Auto-lock',
                    trailing: SettingsPill('${s.autoLock.label} ›'),
                    onTap: () => _pickAutoLock(context),
                  ),
                  SettingsRow(
                    title: 'Privacy',
                    trailing: const Text('›'),
                    onTap: () => _showPrivacy(context),
                  ),
                  const SettingsGroupLabel('Backup & purchase'),
                  SettingsRow(
                    title: 'Backup & Restore',
                    trailing: const Text('›'),
                    onTap: () => _showBackupSheet(context),
                  ),
                  SettingsRow(
                    title: 'Last Backup',
                    trailing: Text(
                      s.lastBackupLabel,
                      style: AppTypography.meta,
                    ),
                  ),
                  SettingsRow(
                    title: 'Upgrade Lifetime',
                    trailing: const Text('›'),
                    onTap: () async {
                      if (s.isLifetimeUnlocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lifetime already unlocked'),
                          ),
                        );
                        return;
                      }
                      await showPaywallDialog(
                        context: context,
                        onUnlock: state.unlockLifetime,
                      );
                    },
                  ),
                  SettingsRow(
                    title: 'Restore Purchase',
                    trailing: const Text('›'),
                    onTap: state.mockRestorePurchase,
                  ),
                  const SettingsGroupLabel('About'),
                  SettingsRow(
                    title: 'About PutMind',
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
