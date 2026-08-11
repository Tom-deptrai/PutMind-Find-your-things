import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_icon_button.dart';
import '../widgets/app_switch.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key, required this.state});

  final AppState state;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _transcriptController;
  CameraController? _cameraController;
  Future<void>? _cameraInit;
  bool _permissionDenied = false;
  bool _cameraError = false;
  bool _takingPicture = false;
  String? _webMockNote;

  AppState get state => widget.state;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _transcriptController = TextEditingController(
      text: state.captureTranscript,
    );
    state.addListener(_syncTranscript);
    _prepareCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    state.removeListener(_syncTranscript);
    _transcriptController.dispose();
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;
    if (lifecycle == AppLifecycleState.inactive) {
      _disposeCamera();
    } else if (lifecycle == AppLifecycleState.resumed) {
      _prepareCamera();
    }
  }

  void _syncTranscript() {
    if (_transcriptController.text != state.captureTranscript) {
      _transcriptController.text = state.captureTranscript;
      _transcriptController.selection = TextSelection.collapsed(
        offset: state.captureTranscript.length,
      );
    }
  }

  Future<void> _disposeCamera() async {
    final controller = _cameraController;
    _cameraController = null;
    _cameraInit = null;
    await controller?.dispose();
  }

  Future<void> _prepareCamera() async {
    if (state.capturePhase != CapturePhase.preview) return;

    // Web preview + widget tests use a mock shutter (native camera is source of truth).
    final isTest = Platform.environment.containsKey('FLUTTER_TEST');
    if (kIsWeb || isTest) {
      setState(() {
        _webMockNote = kIsWeb ? 'web' : 'test';
        _permissionDenied = false;
        _cameraError = false;
      });
      return;
    }

    setState(() {
      _permissionDenied = false;
      _cameraError = false;
    });

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        setState(() => _permissionDenied = true);
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _cameraError = true);
        return;
      }
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _cameraController = controller;
      _cameraInit = controller.initialize();
      await _cameraInit;
      if (mounted) setState(() {});
    } catch (_) {
      await _disposeCamera();
      if (mounted) setState(() => _cameraError = true);
    }
  }

  Future<void> _takePicture() async {
    if (_takingPicture || state.capturePhase != CapturePhase.preview) return;

    if (kIsWeb || _webMockNote != null || _cameraController == null) {
      state.takePhoto(
        mockImagePath: 'mock-captured-${state.captureImagePaths.length}',
      );
      setState(() {});
      return;
    }

    final controller = _cameraController!;
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return;
    }

    setState(() => _takingPicture = true);
    try {
      final file = await controller.takePicture();
      state.onPhotoCaptured(file.path);
      await _disposeCamera();
      if (mounted) setState(() => _takingPicture = false);
    } catch (_) {
      if (mounted) {
        setState(() {
          _takingPicture = false;
          _cameraError = true;
        });
      }
    }
  }

  Future<void> _retake() async {
    state.retake();
    await _prepareCamera();
    if (mounted) setState(() {});
  }

  Future<void> _addPhoto() async {
    state.startAddPhoto();
    await _prepareCamera();
    if (mounted) setState(() {});
  }

  String _promptLabel(AppLocalizations l10n) {
    switch (state.capturePhase) {
      case CapturePhase.preview:
        return l10n.capturePromptPreview;
      case CapturePhase.guiding:
        return l10n.capturePromptGuiding;
      case CapturePhase.listening:
        return l10n.capturePromptListening;
      case CapturePhase.editing:
        return l10n.capturePromptEditing;
    }
  }

  Future<void> _save() async {
    final ok = await state.saveMemory();
    if (!ok && state.showPaywall && mounted) {
      await showPaywallDialog(context: context, state: state);
      state.hidePaywall();
    }
  }

  Widget _buildPreview(AppLocalizations l10n) {
    final inCamera = state.capturePhase == CapturePhase.preview;
    if (!inCamera) {
      final path = state.captureImagePath;
      if (path != null &&
          !kIsWeb &&
          !path.startsWith('mock-') &&
          File(path).existsSync()) {
        return Image.file(File(path), fit: BoxFit.cover);
      }
      return const CapturePreviewFallback(captured: true);
    }

    if (_permissionDenied) {
      return _PermissionDeniedView(
        onRetry: _prepareCamera,
        onOpenSettings: openAppSettings,
      );
    }

    if (_cameraError) {
      return _CameraMessageView(
        title: l10n.cameraUnavailableTitle,
        body: l10n.cameraUnavailableBody,
        actionLabel: l10n.cameraPermissionRetry,
        onAction: _prepareCamera,
      );
    }

    if (kIsWeb || _webMockNote != null) {
      return CapturePreviewFallback(
        captured: false,
        label: kIsWeb ? l10n.cameraWebMockHint : null,
        onShutter: _takePicture,
      );
    }

    final controller = _cameraController;
    if (controller == null || _cameraInit == null) {
      return const ColoredBox(
        color: Color(0xFF1A221E),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return FutureBuilder<void>(
      future: _cameraInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const ColoredBox(
            color: Color(0xFF1A221E),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        if (snapshot.hasError || !controller.value.isInitialized) {
          return _CameraMessageView(
            title: l10n.cameraUnavailableTitle,
            body: l10n.cameraUnavailableBody,
            actionLabel: l10n.cameraPermissionRetry,
            onAction: _prepareCamera,
          );
        }
        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize?.height ?? 1,
            height: controller.value.previewSize?.width ?? 1,
            child: CameraPreview(controller),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final inCamera = state.isCameraPhase;
    final showTranscriptSheet = !inCamera && state.hasCapturedPhoto;
    final isReplace = state.captureMode == CaptureMode.replacePhoto;

    return Scaffold(
      backgroundColor: AppColors.captureBg,
      // Scaffold already shrinks for the IME — do not also pad by viewInsets.
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
                    Expanded(
                      child: Text(
                        isReplace
                            ? l10n.captureReplaceTitle
                            : l10n.captureTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
              flex: showTranscriptSheet ? 5 : 7,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildPreview(l10n),
                  if (inCamera &&
                      !_permissionDenied &&
                      !_cameraError &&
                      _webMockNote == null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: _ShutterButton(
                          busy: _takingPicture,
                          onPressed: _takePicture,
                        ),
                      ),
                    ),
                  if (state.captureImagePaths.isNotEmpty)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            l10n.capturePhotoCount(
                              state.captureImagePaths.length,
                              kMaxPhotosPerMemory,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Flexible(
              flex: showTranscriptSheet ? 6 : 3,
              child: Material(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.captureSheet),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    (showTranscriptSheet ? 22 : 18) + bottomPad,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: showTranscriptSheet
                      ? (isReplace
                            ? _ReplacePhotoSheet(
                                onRetake: _retake,
                                onSave: state.isSaving ? null : _save,
                                saving: state.isSaving,
                              )
                            : _CaptureTranscriptSheet(
                                state: state,
                                controller: _transcriptController,
                                prompt: _promptLabel(l10n),
                                onRetake: _retake,
                                onAddPhoto: state.canAddCapturePhoto
                                    ? _addPhoto
                                    : null,
                                onSave:
                                    state.captureTranscript.trim().isEmpty ||
                                        state.isSaving
                                    ? null
                                    : _save,
                              ))
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            l10n.captureSnapMessage,
                            style: AppTypography.body,
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureTranscriptSheet extends StatelessWidget {
  const _CaptureTranscriptSheet({
    required this.state,
    required this.controller,
    required this.prompt,
    required this.onRetake,
    required this.onAddPhoto,
    required this.onSave,
  });

  final AppState state;
  final TextEditingController controller;
  final String prompt;
  final VoidCallback onRetake;
  final VoidCallback? onAddPhoto;
  final Future<void> Function()? onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final photoCount = state.captureImagePaths.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.capturePromptTitle,
                style: AppTypography.captureTitle,
              ),
            ),
            Text(
              l10n.capturePhotoCount(photoCount, kMaxPhotosPerMemory),
              style: AppTypography.meta,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: Text(
                l10n.voiceGuidanceLabel,
                style: AppTypography.toggle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 7),
            AppSwitch(
              value: state.settings.voiceGuidance,
              onChanged: state.setVoiceGuidance,
            ),
            const SizedBox(width: 7),
            Text(
              state.settings.voiceGuidance
                  ? l10n.voiceGuidanceOn
                  : l10n.voiceGuidanceOff,
              style: AppTypography.toggle.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(prompt, style: AppTypography.prompt),
        const SizedBox(height: 8),
        if (state.capturePhase == CapturePhase.listening ||
            state.capturePhase == CapturePhase.guiding)
          const _Waveform()
        else
          const SizedBox(height: 8),
        TextField(
          controller: controller,
          onTap: () => state.beginManualEditing(),
          onChanged: state.setCaptureTranscript,
          maxLines: 3,
          minLines: 2,
          decoration: InputDecoration(
            hintText: l10n.captureTranscriptHint,
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: state.isSaving ? null : onRetake,
                child: Text(
                  l10n.captureRetake,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: OutlinedButton(
                onPressed: state.isSaving ? null : onAddPhoto,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 16,
                      color: onAddPhoto == null
                          ? Theme.of(context).disabledColor
                          : null,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        l10n.captureAddPhoto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: onSave,
                child: Text(
                  state.isSaving ? l10n.savingMemory : l10n.captureSave,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.onPressed, this.busy = false});

  final VoidCallback onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: busy ? null : onPressed,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: busy
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ReplacePhotoSheet extends StatelessWidget {
  const _ReplacePhotoSheet({
    required this.onRetake,
    required this.onSave,
    required this.saving,
  });

  final VoidCallback onRetake;
  final VoidCallback? onSave;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.replacePhotoConfirmTitle, style: AppTypography.captureTitle),
        const SizedBox(height: 8),
        Text(l10n.replacePhotoConfirmBody, style: AppTypography.body),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: saving ? null : onRetake,
                child: Text(l10n.captureRetake),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onSave,
                child: Text(
                  saving ? l10n.savingMemory : l10n.replacePhotoUsePhoto,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({
    required this.onRetry,
    required this.onOpenSettings,
  });

  final VoidCallback onRetry;
  final Future<bool> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _CameraMessageView(
      title: l10n.cameraPermissionTitle,
      body: l10n.cameraPermissionDenied,
      actionLabel: l10n.cameraPermissionRetry,
      onAction: onRetry,
      secondaryLabel: l10n.cameraPermissionOpenSettings,
      onSecondary: () => onOpenSettings(),
    );
  }
}

class _CameraMessageView extends StatelessWidget {
  const _CameraMessageView({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF1A221E),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_camera_outlined,
              size: 48,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onSecondary,
                child: Text(
                  secondaryLabel!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CapturePreviewFallback extends StatelessWidget {
  const CapturePreviewFallback({
    super.key,
    this.captured = false,
    this.label,
    this.onShutter,
  });

  final bool captured;
  final String? label;
  final VoidCallback? onShutter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: captured
                  ? const [
                      AppColors.capturePreviewStart,
                      AppColors.capturePreviewMid,
                      AppColors.capturePreviewEnd,
                    ]
                  : const [
                      Color(0xFF1A221E),
                      Color(0xFF3A4740),
                      Color(0xFF6B7568),
                    ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: captured
              ? null
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                      if (label != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            label!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
        if (!captured && onShutter != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: _ShutterButton(onPressed: onShutter!),
            ),
          ),
      ],
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
