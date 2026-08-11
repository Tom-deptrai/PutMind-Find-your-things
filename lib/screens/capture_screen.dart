import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_switch.dart';
import '../widgets/photo_placeholder.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key, required this.state});

  final AppState state;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  late final TextEditingController _transcriptController;

  AppState get state => widget.state;

  @override
  void initState() {
    super.initState();
    _transcriptController = TextEditingController(
      text: state.captureTranscript,
    );
    state.addListener(_syncTranscript);
  }

  @override
  void dispose() {
    state.removeListener(_syncTranscript);
    _transcriptController.dispose();
    super.dispose();
  }

  void _syncTranscript() {
    if (_transcriptController.text != state.captureTranscript) {
      _transcriptController.text = state.captureTranscript;
      _transcriptController.selection = TextSelection.collapsed(
        offset: state.captureTranscript.length,
      );
    }
  }

  String get _promptLabel {
    switch (state.capturePhase) {
      case CapturePhase.preview:
        return 'Take a photo, then speak or type where you put it.';
      case CapturePhase.guiding:
        return 'Playing voice guidance…';
      case CapturePhase.listening:
        return 'Listening… speak naturally, or type instead.';
      case CapturePhase.editing:
        return 'Review the transcript, then save.';
    }
  }

  Future<void> _save() async {
    final ok = await state.saveMemory();
    if (!ok && state.showPaywall && mounted) {
      await showPaywallDialog(context: context, onUnlock: state.unlockLifetime);
      state.hidePaywall();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final captured = state.hasCapturedPhoto;

    return Scaffold(
      backgroundColor: AppColors.captureBg,
      resizeToAvoidBottomInset: true,
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
                      dark: true,
                      onPressed: state.openHome,
                    ),
                    const Expanded(
                      child: Text(
                        'Capture',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 42),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: captured ? 6 : 7,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CapturePreviewPlaceholder(captured: captured),
                  if (!captured)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: GestureDetector(
                          onTap: state.takePhoto,
                          child: Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Center(
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                (captured ? 22 : 18) + bottomPad + keyboard,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.captureSheet),
                ),
              ),
              child: captured
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'What is this? Where did you put it?',
                          style: AppTypography.captureTitle,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Voice Guidance',
                              style: AppTypography.toggle,
                            ),
                            const SizedBox(width: 7),
                            AppSwitch(
                              value: state.settings.voiceGuidance,
                              onChanged: state.setVoiceGuidance,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              state.settings.voiceGuidance ? 'On' : 'Off',
                              style: AppTypography.toggle.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_promptLabel, style: AppTypography.prompt),
                        const SizedBox(height: 8),
                        if (state.capturePhase == CapturePhase.listening ||
                            state.capturePhase == CapturePhase.guiding)
                          const _Waveform()
                        else
                          const SizedBox(height: 8),
                        TextField(
                          controller: _transcriptController,
                          onChanged: state.setCaptureTranscript,
                          maxLines: 3,
                          minLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Type here if you prefer…',
                            filled: true,
                            fillColor: AppColors.white,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: const BorderSide(
                                color: AppColors.line,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: const BorderSide(
                                color: AppColors.line,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: const BorderSide(
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: state.retake,
                                child: const Text('Retake'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed:
                                    state.captureTranscript.trim().isEmpty
                                    ? null
                                    : _save,
                                child: const Text('Save memory'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Snap the thing you’re putting away.',
                        style: AppTypography.body,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Waveform extends StatefulWidget {
  const _Waveform();

  @override
  State<_Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<_Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.soft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              final t = ((_controller.value + i * 0.12) % 1.0);
              final h = 10.0 + (t * 16);
              return Container(
                width: 3,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
