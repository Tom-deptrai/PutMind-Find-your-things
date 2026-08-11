import 'package:flutter/material.dart';

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
              const Text(
                'Delete this memory?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'This removes the photo and memory from this device.',
                style: AppTypography.body,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text('Delete memory'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
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
              const Text(
                'Unlock unlimited memories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'You’ve reached the free limit of 20 memories. Existing memories remain available.',
                style: AppTypography.body,
              ),
              const SizedBox(height: 10),
              const Text(r'$6.99', style: AppTypography.price),
              const Text(
                'Lifetime · one-time purchase',
                style: AppTypography.meta,
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onUnlock();
                },
                child: const Text('Unlock Lifetime'),
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
        title: const Text('Edit memory'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'What is this? Where did you put it?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.of(context).pop();
              if (text.isNotEmpty) onSave(text);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  ).whenComplete(controller.dispose);
}
