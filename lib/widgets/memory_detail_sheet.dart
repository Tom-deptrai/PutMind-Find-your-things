import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/memory.dart';
import '../screens/photo_viewer_screen.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
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
  AppState? state,
}) {
  return showModalBottomSheet<MemoryDetailAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.overlayScrim,
    builder: (context) {
      return _MemoryDetailBody(memory: memory, state: state);
    },
  );
}

class _MemoryDetailBody extends StatefulWidget {
  const _MemoryDetailBody({required this.memory, this.state});

  final Memory memory;
  final AppState? state;

  @override
  State<_MemoryDetailBody> createState() => _MemoryDetailBodyState();
}

class _MemoryDetailBodyState extends State<_MemoryDetailBody> {
  late final PageController _pageController;
  late int _index;

  Memory get memory => widget.memory;
  List<String> get _paths => memory.imagePaths;

  @override
  void initState() {
    super.initState();
    final initial = (widget.state?.detailPhotoIndex ?? 0).clamp(
      0,
      _paths.isEmpty ? 0 : _paths.length - 1,
    );
    _index = initial;
    _pageController = PageController(initialPage: initial);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _index = index);
    widget.state?.setDetailPhotoIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final variant = memory.id.hashCode.abs();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
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
                SizedBox(
                  height: 210,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _paths.isEmpty ? 1 : _paths.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final path = _paths.isEmpty ? null : _paths[index];
                          return GestureDetector(
                            onTap: () {
                              openPhotoViewer(
                                context,
                                imagePaths: _paths.isEmpty
                                    ? const <String>[]
                                    : _paths,
                                initialIndex: index,
                                variant: variant,
                                semanticsLabel: l10n.photoViewerSemantics,
                              );
                            },
                            child: MemoryPhoto(
                              imagePath: path,
                              height: 210,
                              borderRadius: BorderRadius.circular(19),
                              variant: variant + index,
                            ),
                          );
                        },
                      ),
                      if (_paths.length > 1)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                l10n.memoryDetailPhotoIndex(
                                  _index + 1,
                                  _paths.length,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(memory.transcript, style: AppTypography.body),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: Text(
                    memory.updatedAt == memory.createdAt
                        ? l10n.memoryDetailSaved(
                            formatMemoryTimestamp(context, memory.createdAt),
                          )
                        : l10n.memoryDetailSavedUpdated(
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
                        onPressed: () =>
                            Navigator.of(context).pop(MemoryDetailAction.edit),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(43),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Text(l10n.memoryDetailEdit),
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
                        child: Text(l10n.memoryDetailReplacePhoto),
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
                  child: Text(l10n.memoryDetailDelete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
