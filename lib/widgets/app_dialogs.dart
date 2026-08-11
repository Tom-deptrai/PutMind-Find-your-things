import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../l10n/app_localizations.dart';

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
  required VoidCallback onUnlock,
}) {
  return showDialog<void>(
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
                AppLocalizations.of(context)!.paywallTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppLocalizations.of(context)!.paywallBody,
                style: AppTypography.body,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.paywallPrice,
                style: AppTypography.price,
              ),
              Text(
                AppLocalizations.of(context)!.paywallLifetimeLabel,
                style: AppTypography.meta,
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onUnlock();
                },
                child: Text(
                  AppLocalizations.of(context)!.paywallUnlockLifetime,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showEditTranscriptDialog({
  required BuildContext context,
  required String initialText,
  required ValueChanged<String> onSave,
}) {
  final controller = TextEditingController(text: initialText);
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.editMemoryDialogTitle),
        content: TextField(
          controller: controller,
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
              final text = controller.text.trim();
              Navigator.of(context).pop();
              if (text.isNotEmpty) onSave(text);
            },
            child: Text(AppLocalizations.of(context)!.editMemorySave),
          ),
        ],
      );
    },
  ).whenComplete(controller.dispose);
}
