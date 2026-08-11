import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/purchase_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

Future<bool?> showDeleteMemoryDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: AppColors.overlayScrim,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.deleteDialogTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.deleteDialogBody,
                style: AppTypography.body,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  minimumSize: const Size.fromHeight(45),
                ),
                child: Text(AppLocalizations.of(context)!.deleteMemory),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showPaywallDialog({
  required BuildContext context,
  required AppState state,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.overlayScrim,
    builder: (context) => _PaywallDialog(state: state),
  );
}

class _PaywallDialog extends StatefulWidget {
  const _PaywallDialog({required this.state});

  final AppState state;

  @override
  State<_PaywallDialog> createState() => _PaywallDialogState();
}

class _PaywallDialogState extends State<_PaywallDialog> {
  bool _busy = false;

  Future<void> _buy() async {
    if (_busy) return;
    setState(() => _busy = true);
    final phase = await widget.state.purchaseLifetime();
    if (!mounted) return;
    setState(() => _busy = false);
    if (phase == PurchasePhase.success ||
        phase == PurchasePhase.alreadyPurchased) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final price =
        widget.state.purchaseService.localizedPrice ?? l10n.paywallPrice;
    final pending =
        _busy ||
        widget.state.purchaseService.phase == PurchasePhase.purchasing ||
        widget.state.purchaseService.phase == PurchasePhase.loadingProducts;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.dialog),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.paywallTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(l10n.paywallBody, style: AppTypography.body),
            const SizedBox(height: 10),
            Text(price, style: AppTypography.price),
            Text(l10n.paywallLifetimeLabel, style: AppTypography.meta),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: pending ? null : _buy,
              child: Text(
                pending
                    ? l10n.paywallPurchasePending
                    : l10n.paywallUnlockLifetime,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: pending ? null : () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Returns confirmed backup password, or null if cancelled.
Future<String?> showBackupPasswordDialog({
  required BuildContext context,
  required bool confirm,
}) {
  return showDialog<String>(
    context: context,
    barrierColor: AppColors.overlayScrim,
    builder: (context) => _BackupPasswordDialog(confirm: confirm),
  );
}

class _BackupPasswordDialog extends StatefulWidget {
  const _BackupPasswordDialog({required this.confirm});

  final bool confirm;

  @override
  State<_BackupPasswordDialog> createState() => _BackupPasswordDialogState();
}

class _BackupPasswordDialogState extends State<_BackupPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final pwd = _password.text;
    if (pwd.length < 4) {
      setState(() => _error = l10n.backupPasswordTooShort);
      return;
    }
    if (widget.confirm && pwd != _confirm.text) {
      setState(() => _error = l10n.backupPasswordMismatch);
      return;
    }
    Navigator.of(context).pop(pwd);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.confirm
            ? l10n.backupPasswordCreateTitle
            : l10n.backupPasswordEnterTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.confirm) ...[
            Text(l10n.backupPasswordWarning, style: AppTypography.body),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _password,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.backupPasswordLabel),
          ),
          if (widget.confirm) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.backupPasswordConfirmLabel,
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: AppTypography.body.copyWith(color: AppColors.danger),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.confirm ? l10n.createBackup : l10n.restoreBackup),
        ),
      ],
    );
  }
}

/// Confirm destructive restore.
Future<bool?> showRestoreConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Text(l10n.restoreConfirmBody, style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.restoreBackup),
          ),
        ],
      );
    },
  );
}

/// Edit transcript dialog. Returns trimmed text on Save, or null on Cancel /
/// empty Save. Owns the [TextEditingController] safely across dialog teardown.
Future<String?> showEditTranscriptDialog({
  required BuildContext context,
  required String initialText,
}) {
  return showDialog<String>(
    context: context,
    barrierColor: AppColors.overlayScrim,
    builder: (context) => _EditTranscriptDialog(initialText: initialText),
  );
}

class _EditTranscriptDialog extends StatefulWidget {
  const _EditTranscriptDialog({required this.initialText});

  final String initialText;

  @override
  State<_EditTranscriptDialog> createState() => _EditTranscriptDialogState();
}

class _EditTranscriptDialogState extends State<_EditTranscriptDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.editMemoryDialogTitle),
      content: TextField(
        controller: _controller,
        maxLines: 4,
        autofocus: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.editMemoryHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final text = _controller.text.trim();
            Navigator.of(context).pop(text.isEmpty ? null : text);
          },
          child: Text(AppLocalizations.of(context)!.editMemorySave),
        ),
      ],
    );
  }
}

/// Shows a modal PIN setup pad. Completes when PIN is saved or cancelled.
Future<void> showPinSetupDialog({
  required BuildContext context,
  required AppState state,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final l10n = AppLocalizations.of(context)!;
          if (!state.awaitingPinSetup) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
          final title = state.pinSetupConfirming
              ? l10n.pinConfirmTitle
              : l10n.pinSetupTitle;
          final error = state.pinError == 'pinMismatch'
              ? l10n.pinMismatch
              : null;
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      error,
                      style: AppTypography.body.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final filled = i < state.pinInput.length;
                    return Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled ? AppColors.ink : Colors.transparent,
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                for (final row in [
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                  ['', '0', '⌫'],
                ])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final key in row)
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            width: 56,
                            height: 44,
                            child: key.isEmpty
                                ? const SizedBox.shrink()
                                : OutlinedButton(
                                    onPressed: () {
                                      if (key == '⌫') {
                                        state.deletePinDigit();
                                      } else {
                                        state.appendPinDigit(key);
                                      }
                                    },
                                    child: Text(key),
                                  ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  state.cancelPinSetup();
                  Navigator.of(context).pop();
                },
                child: Text(l10n.cancel),
              ),
            ],
          );
        },
      );
    },
  );
}
