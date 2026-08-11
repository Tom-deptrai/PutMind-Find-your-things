import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/camera_fab.dart';
import '../widgets/empty_memories_view.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/memory_card.dart';
import '../widgets/memory_detail_sheet.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.state});

  final AppState state;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  AppState get state => widget.state;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: state.searchQuery);
    state.addListener(_syncSearch);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      oldWidget.state.removeListener(_syncSearch);
      widget.state.addListener(_syncSearch);
      _searchController.text = widget.state.searchQuery;
    }
  }

  void _syncSearch() {
    if (_searchController.text != state.searchQuery) {
      _searchController.text = state.searchQuery;
      _searchController.selection = TextSelection.collapsed(
        offset: state.searchQuery.length,
      );
    }
  }

  @override
  void dispose() {
    state.removeListener(_syncSearch);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openDetail(Memory memory) async {
    state.openMemoryDetail(memory);
    final action = await showMemoryDetailSheet(
      context: context,
      memory: memory,
      state: state,
    );
    if (!mounted) return;

    switch (action) {
      case MemoryDetailAction.edit:
        final current = state.selectedMemory ?? memory;
        final text = await showEditTranscriptDialog(
          context: context,
          initialText: current.transcript,
        );
        if (!mounted) return;
        if (text != null) {
          await state.updateSelectedTranscript(text);
        }
        if (state.route == AppRoute.home) {
          state.closeMemoryDetail();
        }
      case MemoryDetailAction.replacePhoto:
        state.openReplacePhoto(memory, photoIndex: state.detailPhotoIndex);
      case MemoryDetailAction.delete:
        final confirmed = await showDeleteMemoryDialog(context);
        if (!mounted) return;
        if (confirmed == true) {
          await state.confirmDeleteSelected();
        } else {
          state.cancelDelete();
          if (state.route == AppRoute.home) {
            state.closeMemoryDetail();
          }
        }
      case null:
        // Dismissed — clear selection unless replace-photo already navigated.
        if (state.route == AppRoute.home &&
            state.captureMode != CaptureMode.replacePhoto) {
          state.closeMemoryDetail();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final memories = state.filteredMemories;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(17, 7, 17, 0),
                  child: SizedBox(
                    height: 58,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('PutMind', style: AppTypography.title),
                        ),
                        AppIconButton(
                          icon: Icons.settings_outlined,
                          tooltip: AppLocalizations.of(
                            context,
                          )!.settingsTooltip,
                          onPressed: state.openSettings,
                        ),
                      ],
                    ),
                  ),
                ),
                HomeSearchBar(
                  controller: _searchController,
                  onChanged: (q) {
                    state.setSearchQuery(q);
                  },
                  onMicPressed: () {
                    state.mockVoiceSearch();
                  },
                ),
                Expanded(
                  child: memories.isEmpty
                      ? ListView(
                          padding: EdgeInsets.only(
                            bottom: AppSpacing.contentBottomPad + bottomInset,
                          ),
                          children: [
                            if (state.searchQuery.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(28),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.homeNoMemoriesMatch,
                                  style: AppTypography.body,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              const EmptyMemoriesView(),
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.screenH,
                            0,
                            AppSpacing.screenH,
                            AppSpacing.contentBottomPad + bottomInset,
                          ),
                          itemCount: memories.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 9, 2, 8),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.homeRecentMemories,
                                  style: AppTypography.section,
                                ),
                              );
                            }
                            final memory = memories[index - 1];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: MemoryCard(
                                memory: memory,
                                onTap: () => _openDetail(memory),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.fabBottom + bottomInset,
              child: Center(child: CameraFab(onPressed: state.openCapture)),
            ),
          ],
        ),
      ),
    );
  }
}
