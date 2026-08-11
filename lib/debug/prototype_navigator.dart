import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/memory_detail_sheet.dart';
import '../l10n/app_localizations.dart';

/// Development-only prototype navigator (mirrors mobile.html).
///
/// Tree-shaken / gated by [kDebugMode] — never shown in release builds.
class PrototypeNavigator extends StatefulWidget {
  const PrototypeNavigator({
    super.key,
    required this.state,
    required this.navigatorKey,
  });

  final AppState state;

  /// Dialogs/sheets need a context under [MaterialApp]'s Navigator.
  /// The prototype overlay lives in [MaterialApp.builder], so it receives
  /// the app navigator key explicitly.
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<PrototypeNavigator> createState() => _PrototypeNavigatorState();
}

class _PrototypeNavigatorState extends State<PrototypeNavigator> {
  bool _open = false;

  AppState get state => widget.state;

  BuildContext get _navContext {
    final ctx = widget.navigatorKey.currentContext;
    assert(ctx != null, 'Navigator context unavailable');
    return ctx!;
  }

  Future<void> _go(VoidCallback action) async {
    setState(() => _open = false);
    action();
  }

  Future<void> _openDetail() async {
    setState(() => _open = false);
    state.prototypeShowMemoryDetail();
    final memory = state.selectedMemory;
    if (memory == null || !mounted) return;
    await showMemoryDetailSheet(
      context: _navContext,
      memory: memory,
      onEdit: () {
        showEditTranscriptDialog(
          context: _navContext,
          initialText: memory.transcript,
          onSave: (text) async {
            state.openMemoryDetail(memory);
            await state.updateSelectedTranscript(text);
            state.closeMemoryDetail();
          },
        );
      },
      onReplacePhoto: () {
        state.openMemoryDetail(memory);
        state.mockReplacePhoto();
      },
      onDelete: () async {
        state.openMemoryDetail(memory);
        final confirmed = await showDeleteMemoryDialog(_navContext);
        if (confirmed == true) {
          await state.confirmDeleteSelected();
        } else {
          state.cancelDelete();
          state.closeMemoryDetail();
        }
      },
    );
    state.closeMemoryDetail();
  }

  Future<void> _openPaywall() async {
    setState(() => _open = false);
    state.prototypeShowPaywall();
    await showPaywallDialog(
      context: _navContext,
      onUnlock: state.unlockLifetime,
    );
    state.hidePaywall();
  }

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode, 'PrototypeNavigator must not ship in release builds');
    final bottom = MediaQuery.paddingOf(context).bottom;
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_open) ...[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _open = false),
              child: const ColoredBox(color: Color(0x00000000)),
            ),
          ),
          Positioned(
            left: 11,
            right: 11,
            bottom: 62 + bottom,
            child: Material(
              color: AppColors.white,
              elevation: 12,
              shadowColor: const Color(0x3818211D),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.prototypePreviewStates,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _open = false),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.line),
                            ),
                            child: const Icon(Icons.close, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.6,
                      children: [
                        _ProtoButton(
                          label: l10n.protoHome,
                          onTap: () => _go(state.prototypeRestoreDemoMemories),
                        ),
                        _ProtoButton(
                          label: l10n.protoCapture,
                          onTap: () => _go(state.openCapture),
                        ),
                        _ProtoButton(
                          label: l10n.protoSettings,
                          onTap: () => _go(state.openSettings),
                        ),
                        _ProtoButton(
                          label: l10n.protoUnlock,
                          onTap: () => _go(state.prototypeShowUnlock),
                        ),
                        _ProtoButton(
                          label: l10n.protoOnboarding,
                          onTap: () => _go(state.prototypeShowOnboarding),
                        ),
                        _ProtoButton(
                          label: l10n.protoEmptyHome,
                          onTap: () => _go(state.prototypeShowEmptyHome),
                        ),
                        _ProtoButton(
                          label: l10n.protoMemoryDetail,
                          onTap: _openDetail,
                        ),
                        _ProtoButton(
                          label: l10n.protoPaywall,
                          onTap: _openPaywall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      l10n.prototypeHint,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        Positioned(
          right: 12,
          bottom: 12 + bottom,
          child: Material(
            color: const Color(0xF2FFFFFF),
            elevation: 8,
            shadowColor: const Color(0x2C18211D),
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              onTap: () => setState(() => _open = !_open),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(
                  l10n.prototype,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProtoButton extends StatelessWidget {
  const _ProtoButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.soft,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
