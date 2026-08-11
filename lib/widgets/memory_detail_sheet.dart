import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../models/settings.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'photo_placeholder.dart';

Future<void> showMemoryDetailSheet({
  required BuildContext context,
  required Memory memory,
  required VoidCallback onEdit,
  required VoidCallback onReplacePhoto,
  required VoidCallback onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.overlayScrim,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.sheet),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            17,
            12,
            17,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.grabber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                MemoryPhotoPlaceholder(
                  height: 210,
                  borderRadius: BorderRadius.circular(19),
                  variant: memory.id.hashCode.abs(),
                ),
                const SizedBox(height: 14),
                Text(memory.title, style: AppTypography.captureTitle),
                const SizedBox(height: 6),
                Text(memory.transcript, style: AppTypography.body),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: Text(
                    'Saved ${formatMemoryTimestamp(memory.createdAt).toLowerCase()}'
                    '${memory.updatedAt != memory.createdAt ? ' · Updated ${formatMemoryTimestamp(memory.updatedAt).toLowerCase()}' : ''}',
                    style: AppTypography.meta,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onEdit();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(43),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onReplacePhoto();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(43),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text('Replace photo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDelete();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    minimumSize: const Size.fromHeight(43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
