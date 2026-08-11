import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../l10n/app_localizations.dart';
import '../screens/photo_viewer_screen.dart';
import '../utils/memory_time_format.dart';
import 'photo_placeholder.dart';

/// Result returned after the memory detail sheet closes.
enum MemoryDetailAction { edit, replacePhoto, delete }

/// Shows memory detail and returns the chosen action (or null if dismissed).
///
/// Callers must handle [MemoryDetailAction] **after** this future completes so
/// sheet teardown cannot race with Edit/Delete dialogs or clear selection early.
Future<MemoryDetailAction?> showMemoryDetailSheet({
  required BuildContext context,
  required Memory memory,
}) {
  return showModalBottomSheet<MemoryDetailAction>(
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.92,
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
                  GestureDetector(
                    onTap: () {
                      openPhotoViewer(
                        context,
                        imagePath: memory.imagePath,
                        variant: memory.id.hashCode.abs(),
                        semanticsLabel: AppLocalizations.of(
                          context,
                        )!.photoViewerSemantics,
                      );
                    },
                    child: MemoryPhoto(
                      imagePath: memory.imagePath,
                      height: 210,
                      borderRadius: BorderRadius.circular(19),
                      variant: memory.id.hashCode.abs(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(memory.title, style: AppTypography.captureTitle),
                  const SizedBox(height: 6),
                  Text(memory.transcript, style: AppTypography.body),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    child: Text(
                      memory.updatedAt == memory.createdAt
                          ? AppLocalizations.of(context)!.memoryDetailSaved(
                              formatMemoryTimestamp(context, memory.createdAt),
                            )
                          : AppLocalizations.of(
                              context,
                            )!.memoryDetailSavedUpdated(
                              formatMemoryTimestamp(context, memory.createdAt),
                              formatMemoryTimestamp(context, memory.updatedAt),
                            ),
                      style: AppTypography.meta,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(MemoryDetailAction.edit),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(43),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.memoryDetailEdit,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(MemoryDetailAction.replacePhoto),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(43),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.memoryDetailReplacePhoto,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(MemoryDetailAction.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      minimumSize: const Size.fromHeight(43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.memoryDetailDelete,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
