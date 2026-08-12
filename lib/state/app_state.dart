import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:speech_to_text/speech_to_text.dart' show ListenMode;

import '../models/memory.dart';
import '../models/settings.dart';
import '../services/backup_service.dart';
import '../services/biometric_auth.dart';
import '../services/image_storage.dart';
import '../services/memory_repository.dart';
import '../services/pin_store.dart';
import '../services/purchase_service.dart';
import '../services/reminder_service.dart';
import '../services/settings_store.dart';
import '../services/speech_service.dart';
import '../services/voice_guidance_player.dart';

export '../models/memory.dart' show kMaxPhotosPerMemory;

enum AppRoute { home, capture, settings, unlock, onboarding }

enum CapturePhase { preview, guiding, listening, editing }

enum CaptureMode { create, replacePhoto, addPhoto }

/// App state for PutMind MVP (Step 3: voice, lock, reminders, persistence).
class AppState extends ChangeNotifier {
  AppState({
    required MemoryRepository repository,
    required ImageStorage imageStorage,
    SettingsStore? settingsStore,
    PinStore? pinStore,
    SpeechService? speechService,
    VoiceGuidancePlayer? voiceGuidancePlayer,
    ReminderService? reminderService,
    BiometricAuth? biometricAuth,
    PurchaseService? purchaseService,
    BackupService? backupService,
    AppSettings? settings,
  }) : _repository = repository,
       _imageStorage = imageStorage,
       _settingsStore = settingsStore ?? SettingsStore(),
       _pinStore = pinStore ?? PinStore(),
       _speech = speechService ?? SpeechService(),
       _voicePlayer = voiceGuidancePlayer ?? VoiceGuidancePlayer(),
       _reminders = reminderService ?? ReminderService(),
       _biometric = biometricAuth ?? BiometricAuth(),
       _purchase = purchaseService ?? FakePurchaseService(isAvailable: false),
       _settings = settings ?? const AppSettings() {
    _backup =
        backupService ??
        BackupService(repository: repository, imageStorage: imageStorage);
    _applyLaunchRoute();
  }

  static Future<AppState> create({
    MemoryRepository? repository,
    ImageStorage? imageStorage,
    SettingsStore? settingsStore,
    PinStore? pinStore,
    SpeechService? speechService,
    VoiceGuidancePlayer? voiceGuidancePlayer,
    ReminderService? reminderService,
    BiometricAuth? biometricAuth,
    PurchaseService? purchaseService,
    BackupService? backupService,
    AppSettings? settings,
  }) async {
    final store = settingsStore ?? SettingsStore();
    final loaded = settings ?? await store.load();
    final repo = repository ?? InMemoryMemoryRepository();
    final images = imageStorage ?? await ImageStorage.create();
    final purchases =
        purchaseService ?? FakePurchaseService(isAvailable: false);
    final state = AppState(
      repository: repo,
      imageStorage: images,
      settingsStore: store,
      pinStore: pinStore,
      speechService: speechService,
      voiceGuidancePlayer: voiceGuidancePlayer,
      reminderService: reminderService,
      biometricAuth: biometricAuth,
      purchaseService: purchases,
      backupService: backupService,
      settings: loaded,
    );
    await state.reloadMemories();
    await state._purchase.initialize();
    if (loaded.dailyReminder) {
      // Reschedule after restart — title/body filled by UI locale later via ensureReminder.
      await state._reminders.initialize();
    }
    return state;
  }

  final MemoryRepository _repository;
  final ImageStorage _imageStorage;
  final SettingsStore _settingsStore;
  final PinStore _pinStore;
  final SpeechService _speech;
  final VoiceGuidancePlayer _voicePlayer;
  final ReminderService _reminders;
  final BiometricAuth _biometric;
  final PurchaseService _purchase;
  late final BackupService _backup;
  static const _uuid = Uuid();

  AppSettings _settings;
  List<Memory> _memories = const [];
  int _totalCount = 0;
  String _searchQuery = '';
  int _searchGeneration = 0;
  AppRoute _route = AppRoute.home;
  bool _isLocked = false;
  bool _isReady = false;
  bool _isSaving = false;

  CapturePhase _capturePhase = CapturePhase.preview;
  CaptureMode _captureMode = CaptureMode.create;
  String _captureTranscript = '';
  final List<String> _captureImagePaths = [];
  int _captureActiveIndex = 0;
  String? _replaceMemoryId;
  int _replacePhotoIndex = 0;
  int _detailPhotoIndex = 0;

  /// When set, next capture inserts at this index (Retake current slot).
  int? _pendingRetakeIndex;
  Timer? _captureTimer;
  int _successTick = 0;

  /// Bumps on retake/back/save to cancel in-flight guidance → listen chains.
  int _captureGeneration = 0;

  /// When true, user chose typing; do not auto-restart speech.
  bool _manualCaptureEditing = false;

  /// Transcript committed before a speech session restart (for merge).
  String _speechListenPrefix = '';

  /// Caps auto-restarts within one Capture voice session.
  int _speechRestartCount = 0;
  static const int _maxSpeechRestarts = 12;

  Memory? _selectedMemory;
  bool _showMemoryDetail = false;
  bool _showPaywall = false;
  bool _showDeleteConfirm = false;
  bool _showPinFallback = false;
  String _pinInput = '';
  String _snackMessage = '';
  String? _errorMessage;
  String? _pinError;
  bool _awaitingPinSetup = false;
  String? _pinSetupFirst;
  DateTime? _pausedAt;
  bool _biometricAvailable = false;

  // Reminder copy set by UI layer when scheduling (localized).
  String reminderTitle = 'PutMind';
  String reminderBody = 'Snap it. Say where. Find it later.';

  void _applyLaunchRoute() {
    if (!_settings.onboardingCompleted) {
      _route = AppRoute.onboarding;
    } else if (_settings.appLock) {
      _isLocked = true;
      _route = AppRoute.unlock;
    }
  }

  // --- Getters ---

  bool get isReady => _isReady;
  bool get isSaving => _isSaving;
  AppSettings get settings => _settings;
  List<Memory> get memories => _memories;
  String get searchQuery => _searchQuery;
  AppRoute get route => _route;
  bool get isLocked => _isLocked;
  CapturePhase get capturePhase => _capturePhase;
  CaptureMode get captureMode => _captureMode;
  String get captureTranscript => _captureTranscript;
  List<String> get captureImagePaths => List.unmodifiable(_captureImagePaths);
  int get captureActiveIndex => _captureActiveIndex;
  int get replacePhotoIndex => _replacePhotoIndex;
  int get detailPhotoIndex => _detailPhotoIndex;
  String? get captureImagePath => _captureImagePaths.isEmpty
      ? null
      : _captureImagePaths[_captureActiveIndex.clamp(
          0,
          _captureImagePaths.length - 1,
        )];
  bool get hasCapturedPhoto => _captureImagePaths.isNotEmpty;

  /// True while the Capture screen should show the live camera (incl. Add/Retake).
  bool get isCameraPhase => _capturePhase == CapturePhase.preview;
  bool get canAddCapturePhoto =>
      _captureMode != CaptureMode.replacePhoto &&
      _captureImagePaths.isNotEmpty &&
      _captureImagePaths.length < kMaxPhotosPerMemory;
  int get successTick => _successTick;
  Memory? get selectedMemory => _selectedMemory;
  bool get showMemoryDetail => _showMemoryDetail;
  bool get showPaywall => _showPaywall;
  bool get showDeleteConfirm => _showDeleteConfirm;
  bool get showPinFallback => _showPinFallback;
  String get pinInput => _pinInput;
  String get snackMessage => _snackMessage;
  String? get errorMessage => _errorMessage;
  String? get pinError => _pinError;
  bool get awaitingPinSetup => _awaitingPinSetup;
  bool get biometricAvailable => _biometricAvailable;
  int get memoryCount => _totalCount;
  bool get canAddMemory =>
      _settings.isLifetimeUnlocked || _totalCount < kFreeMemoryLimit;
  int get remainingFreeSlots =>
      (_settings.isLifetimeUnlocked ? 999 : (kFreeMemoryLimit - _totalCount))
          .clamp(0, kFreeMemoryLimit);

  List<Memory> get filteredMemories => _memories;

  Future<void> reloadMemories() async {
    final all = await _repository.getAll();
    _totalCount = all.length;
    if (_searchQuery.trim().isEmpty) {
      _memories = all;
    } else {
      _memories = await _repository.search(_searchQuery);
    }
    _isReady = true;
    notifyListeners();
  }

  Future<void> _persistSettings() async {
    await _settingsStore.save(_settings);
  }

  Future<void> refreshBiometricAvailability() async {
    _biometricAvailable = await _biometric.isAvailable;
    notifyListeners();
  }

  // --- Lifecycle / auto-lock ---

  void onAppPaused() {
    if (!_settings.appLock || _isLocked) return;
    _pausedAt = DateTime.now();
  }

  void onAppResumed() {
    if (!_settings.appLock || _isLocked) {
      _pausedAt = null;
      return;
    }
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt == null) return;
    final elapsed = DateTime.now().difference(pausedAt);
    final limit = _settings.autoLock.duration;
    if (elapsed >= limit) {
      lockNow();
    }
  }

  void lockNow() {
    if (!_settings.appLock) return;
    _isLocked = true;
    _showPinFallback = false;
    _pinInput = '';
    _pinError = null;
    _route = AppRoute.unlock;
    unawaited(_speech.cancel());
    unawaited(_voicePlayer.stop());
    notifyListeners();
  }

  // --- Navigation ---

  void goTo(AppRoute route) {
    _route = route;
    if (route == AppRoute.capture) {
      if (_captureMode == CaptureMode.create) {
        _resetCapture();
      }
    } else {
      _captureMode = CaptureMode.create;
      _replaceMemoryId = null;
      _resetCapture();
    }
    if (route != AppRoute.unlock) {
      _showPinFallback = false;
      _pinInput = '';
      _pinError = null;
    }
    _dismissTransientOverlays(keepDetail: false);
    _errorMessage = null;
    notifyListeners();
  }

  void openHome() => goTo(AppRoute.home);

  void openCapture() {
    if (_isLocked) {
      goTo(AppRoute.unlock);
      return;
    }
    _captureMode = CaptureMode.create;
    _replaceMemoryId = null;
    goTo(AppRoute.capture);
  }

  void openSettings() => goTo(AppRoute.settings);

  void openReplacePhoto(Memory memory, {int photoIndex = 0}) {
    final idx = memory.imagePaths.isEmpty
        ? 0
        : photoIndex.clamp(0, memory.imagePaths.length - 1);
    _selectedMemory = memory;
    _replaceMemoryId = memory.id;
    _replacePhotoIndex = idx;
    _detailPhotoIndex = idx;
    _captureMode = CaptureMode.replacePhoto;
    _resetCapture(keepReplaceContext: true);
    _captureMode = CaptureMode.replacePhoto;
    _replaceMemoryId = memory.id;
    _replacePhotoIndex = idx;
    _route = AppRoute.capture;
    _dismissTransientOverlays(keepDetail: false);
    notifyListeners();
  }

  // --- Search ---

  Future<void> setSearchQuery(String value) async {
    _searchQuery = value;
    final generation = ++_searchGeneration;
    final all = await _repository.getAll();
    if (generation != _searchGeneration) return;
    _totalCount = all.length;
    if (_searchQuery.trim().isEmpty) {
      _memories = all;
    } else {
      final results = await _repository.search(_searchQuery);
      if (generation != _searchGeneration) return;
      _memories = results;
    }
    _isReady = true;
    notifyListeners();
  }

  Future<void> clearSearch() async {
    _searchQuery = '';
    _searchGeneration++;
    await reloadMemories();
  }

  Future<void> startVoiceSearch() async {
    if (kIsWeb) {
      _snackMessage = 'speechUnavailable';
      notifyListeners();
      return;
    }
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      _snackMessage = 'microphoneDenied';
      notifyListeners();
      return;
    }
    final available = await _speech.initialize();
    if (!available) {
      _snackMessage = 'speechUnavailable';
      notifyListeners();
      return;
    }
    await _speech.listen(
      localeId: _settings.language.speechToTextLocale,
      onResult: (text) {
        if (text.trim().isEmpty) return;
        unawaited(setSearchQuery(text.trim()));
      },
      onStatus: (status) {
        if (status == SpeechListenStatus.permissionDenied) {
          _snackMessage = 'microphoneDenied';
          notifyListeners();
        } else if (status == SpeechListenStatus.unavailable ||
            status == SpeechListenStatus.error) {
          _snackMessage = 'speechUnavailable';
          notifyListeners();
        }
      },
      listenFor: const Duration(seconds: 8),
      pauseFor: const Duration(seconds: 3),
      listenMode: ListenMode.confirmation,
    );
  }

  /// Backward-compatible name used by older UI hooks.
  Future<void> mockVoiceSearch() => startVoiceSearch();

  // --- Capture ---

  void _emitSuccess() {
    _successTick++;
  }

  void _emitError(String key) {
    _snackMessage = key;
  }

  void _resetCapture({bool keepReplaceContext = false}) {
    _captureGeneration++;
    _captureTimer?.cancel();
    _captureTimer = null;
    _manualCaptureEditing = false;
    _speechListenPrefix = '';
    _speechRestartCount = 0;
    unawaited(_speech.cancel());
    unawaited(_voicePlayer.stop());
    _capturePhase = CapturePhase.preview;
    _pendingRetakeIndex = null;
    if (!keepReplaceContext) {
      _captureTranscript = '';
      _captureImagePaths.clear();
      _captureActiveIndex = 0;
      _replaceMemoryId = null;
      _replacePhotoIndex = 0;
      _captureMode = CaptureMode.create;
    } else {
      _captureImagePaths.clear();
      _captureActiveIndex = 0;
    }
  }

  void onPhotoCaptured(String imagePath) {
    _captureTimer?.cancel();

    if (_captureMode == CaptureMode.replacePhoto) {
      _captureImagePaths
        ..clear()
        ..add(imagePath);
      _captureActiveIndex = 0;
      _pendingRetakeIndex = null;
      _capturePhase = CapturePhase.editing;
      notifyListeners();
      return;
    }

    if (_captureMode == CaptureMode.addPhoto) {
      if (_captureImagePaths.length >= kMaxPhotosPerMemory) {
        notifyListeners();
        return;
      }
      _captureImagePaths.add(imagePath);
      _captureActiveIndex = _captureImagePaths.length - 1;
      _pendingRetakeIndex = null;
      _captureMode = CaptureMode.create;
      _manualCaptureEditing = true;
      _capturePhase = CapturePhase.editing;
      unawaited(_speech.stop());
      unawaited(_voicePlayer.stop());
      notifyListeners();
      return;
    }

    // Retake: insert into the vacated slot; keep transcript; no voice replay.
    if (_pendingRetakeIndex != null) {
      final insertAt = _pendingRetakeIndex!.clamp(0, _captureImagePaths.length);
      _captureImagePaths.insert(insertAt, imagePath);
      _captureActiveIndex = insertAt;
      _pendingRetakeIndex = null;
      _manualCaptureEditing = true;
      _capturePhase = CapturePhase.editing;
      unawaited(_speech.stop());
      unawaited(_voicePlayer.stop());
      notifyListeners();
      return;
    }

    // First photo of a new Memory.
    if (_captureImagePaths.isEmpty) {
      _captureImagePaths.add(imagePath);
      _captureActiveIndex = 0;
      _manualCaptureEditing = false;
      _speechListenPrefix = '';
      _speechRestartCount = 0;
      if (_settings.voiceGuidance) {
        _capturePhase = CapturePhase.guiding;
        notifyListeners();
        unawaited(_playGuidanceThenListen());
      } else {
        unawaited(startListening());
      }
      return;
    }

    // Safety: replace active slot in place.
    final idx = _captureActiveIndex.clamp(0, _captureImagePaths.length - 1);
    final previous = _captureImagePaths[idx];
    _captureImagePaths[idx] = imagePath;
    if (previous != imagePath && !previous.startsWith('mock-')) {
      unawaited(_imageStorage.deleteImage(previous));
    }
    _manualCaptureEditing = true;
    _capturePhase = CapturePhase.editing;
    unawaited(_speech.stop());
    unawaited(_voicePlayer.stop());
    notifyListeners();
  }

  Future<void> _playGuidanceThenListen() async {
    final generation = _captureGeneration;
    try {
      await _voicePlayer.play(_settings.language);
    } catch (_) {
      // Playback failure must never block Speech-to-Text.
    }
    if (generation != _captureGeneration) return;
    if (_manualCaptureEditing) return;
    if (_capturePhase == CapturePhase.guiding) {
      await startListening();
    }
  }

  void takePhoto({String? mockImagePath}) {
    onPhotoCaptured(mockImagePath ?? 'mock-captured');
  }

  /// Opens camera to append another photo to the current draft Memory.
  void startAddPhoto() {
    if (!canAddCapturePhoto) return;
    unawaited(_speech.stop());
    unawaited(_voicePlayer.stop());
    _manualCaptureEditing = true;
    _captureMode = CaptureMode.addPhoto;
    _capturePhase = CapturePhase.preview;
    notifyListeners();
  }

  void setDetailPhotoIndex(int index) {
    _detailPhotoIndex = index;
    notifyListeners();
  }

  Future<void> startListening({bool isRestart = false}) async {
    if (_manualCaptureEditing) return;
    if (_capturePhase == CapturePhase.preview) return;

    _captureTimer?.cancel();
    if (!isRestart) {
      _speechListenPrefix = '';
      _speechRestartCount = 0;
    }
    _capturePhase = CapturePhase.listening;
    notifyListeners();

    final generation = _captureGeneration;

    if (kIsWeb) {
      return;
    }

    // Controllable fakes skip platform permission channels in unit tests.
    final usingFakeSpeech = _speech is FakeSpeechService;

    // Unit/widget tests without a fake: stay listening until manual edit.
    if (!usingFakeSpeech && Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    if (!usingFakeSpeech) {
      final mic = await Permission.microphone.request();
      if (generation != _captureGeneration || _manualCaptureEditing) return;
      if (!mic.isGranted) {
        _snackMessage = 'microphoneDenied';
        _capturePhase = CapturePhase.editing;
        notifyListeners();
        return;
      }
    }

    final available = await _speech.initialize();
    if (generation != _captureGeneration || _manualCaptureEditing) return;
    if (!available) {
      _snackMessage = 'speechUnavailable';
      _capturePhase = CapturePhase.editing;
      notifyListeners();
      return;
    }

    await _speech.listen(
      localeId: _settings.language.speechToTextLocale,
      listenFor: kCaptureListenFor,
      pauseFor: kCapturePauseFor,
      onResult: (text) {
        if (generation != _captureGeneration) return;
        if (_manualCaptureEditing) return;
        if (_capturePhase != CapturePhase.listening &&
            _capturePhase != CapturePhase.editing) {
          return;
        }
        _captureTranscript = _mergeSpeechResult(text);
        notifyListeners();
      },
      onStatus: (status) {
        if (generation != _captureGeneration) return;
        if (status == SpeechListenStatus.permissionDenied) {
          _snackMessage = 'microphoneDenied';
          _manualCaptureEditing = true;
          _capturePhase = CapturePhase.editing;
          notifyListeners();
          return;
        }
        if (status == SpeechListenStatus.unavailable ||
            status == SpeechListenStatus.error) {
          _snackMessage = 'speechUnavailable';
          _manualCaptureEditing = true;
          _capturePhase = CapturePhase.editing;
          notifyListeners();
          return;
        }
        if (status == SpeechListenStatus.notListening ||
            status == SpeechListenStatus.done) {
          unawaited(_onSpeechSessionEnded(generation));
        }
      },
    );
  }

  String _mergeSpeechResult(String live) {
    final trimmed = live.trim();
    if (_speechListenPrefix.isEmpty) return trimmed;
    if (trimmed.isEmpty) return _speechListenPrefix;
    return '$_speechListenPrefix $trimmed';
  }

  Future<void> _onSpeechSessionEnded(int generation) async {
    if (generation != _captureGeneration) return;
    if (_manualCaptureEditing) return;
    if (_capturePhase != CapturePhase.listening) return;

    // Unexpected platform end → safe restart while still in voice Capture.
    if (_speechRestartCount >= _maxSpeechRestarts) {
      _capturePhase = CapturePhase.editing;
      notifyListeners();
      return;
    }

    _speechListenPrefix = _captureTranscript.trim();
    _speechRestartCount++;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (generation != _captureGeneration) return;
    if (_manualCaptureEditing) return;
    if (_capturePhase != CapturePhase.listening) return;
    await startListening(isRestart: true);
  }

  /// User focused the transcript field → stop mic, no auto-restart.
  Future<void> beginManualEditing() async {
    if (!hasCapturedPhoto) return;
    _manualCaptureEditing = true;
    _captureTimer?.cancel();
    _captureTimer = null;
    await _speech.stop();
    if (_capturePhase == CapturePhase.guiding) {
      await _voicePlayer.stop();
    }
    _capturePhase = CapturePhase.editing;
    notifyListeners();
  }

  void setCaptureTranscript(String value) {
    _captureTranscript = value;
    if (hasCapturedPhoto) {
      _manualCaptureEditing = true;
      _captureTimer?.cancel();
      _captureTimer = null;
      unawaited(_speech.stop());
      if (_capturePhase == CapturePhase.guiding) {
        unawaited(_voicePlayer.stop());
      }
      _capturePhase = CapturePhase.editing;
    }
    notifyListeners();
  }

  void retake() {
    if (_captureMode == CaptureMode.replacePhoto) {
      _resetCapture(keepReplaceContext: true);
      _captureMode = CaptureMode.replacePhoto;
      notifyListeners();
      return;
    }

    if (_captureImagePaths.isEmpty) {
      _resetCapture();
      notifyListeners();
      return;
    }

    // Retake only the current/active photo; keep transcript + other photos.
    final idx = _captureActiveIndex.clamp(0, _captureImagePaths.length - 1);
    final removed = _captureImagePaths.removeAt(idx);
    _pendingRetakeIndex = idx;
    if (_captureImagePaths.isEmpty) {
      _captureActiveIndex = 0;
    } else if (_captureActiveIndex >= _captureImagePaths.length) {
      _captureActiveIndex = _captureImagePaths.length - 1;
    }
    unawaited(_speech.cancel());
    unawaited(_voicePlayer.stop());
    _capturePhase = CapturePhase.preview;
    _captureMode = CaptureMode.create;
    notifyListeners();
    if (!removed.startsWith('mock-')) {
      unawaited(_imageStorage.deleteImage(removed));
    }
  }

  @override
  void dispose() {
    _captureTimer?.cancel();
    unawaited(_speech.cancel());
    unawaited(_voicePlayer.dispose());
    unawaited(_repository.close());
    super.dispose();
  }

  Future<bool> saveMemory() async {
    if (_isSaving) return false;

    if (_captureMode == CaptureMode.replacePhoto) {
      return _saveReplacedPhoto();
    }

    final text = _captureTranscript.trim();
    if (_captureImagePaths.isEmpty || text.isEmpty) {
      return false;
    }

    if (!canAddMemory) {
      _showPaywall = true;
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final id = _uuid.v4();
      final persisted = <String>[];
      for (var i = 0; i < _captureImagePaths.length; i++) {
        final path = await _persistOrKeep(_captureImagePaths[i], id: '$id-$i');
        persisted.add(path);
      }
      final memory = Memory(
        id: id,
        transcript: text,
        createdAt: now,
        updatedAt: now,
        imagePaths: persisted,
      );
      await _repository.upsert(memory);
      _searchQuery = '';
      await reloadMemories();
      _resetCapture();
      _route = AppRoute.home;
      _emitSuccess();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'saveFailed';
      _emitError('saveMemoryFailed');
      notifyListeners();
      return false;
    }
  }

  Future<bool> _saveReplacedPhoto() async {
    final memoryId = _replaceMemoryId;
    final sourcePath = captureImagePath;
    if (memoryId == null || sourcePath == null || sourcePath.isEmpty) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final existing = await _repository.getById(memoryId);
      if (existing == null) {
        _isSaving = false;
        _errorMessage = 'saveFailed';
        notifyListeners();
        return false;
      }

      final paths = [...existing.imagePaths];
      final idx = paths.isEmpty
          ? 0
          : _replacePhotoIndex.clamp(0, paths.isEmpty ? 0 : paths.length - 1);
      final previous = paths.isEmpty ? null : paths[idx];
      final newPath = await _imageStorage.replaceImage(
        sourcePath: sourcePath,
        previousPath: previous,
        id: '$memoryId-${DateTime.now().millisecondsSinceEpoch}',
      );
      if (paths.isEmpty) {
        paths.add(newPath);
      } else {
        paths[idx] = newPath;
      }
      final updated = existing.copyWith(
        imagePaths: paths,
        updatedAt: DateTime.now(),
      );
      await _repository.upsert(updated);
      await reloadMemories();
      _resetCapture();
      _selectedMemory = updated;
      _detailPhotoIndex = idx;
      _route = AppRoute.home;
      _emitSuccess();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isSaving = false;
      _errorMessage = 'saveFailed';
      _emitError('replacePhotoFailed');
      notifyListeners();
      return false;
    }
  }

  Future<String> _persistOrKeep(String sourcePath, {required String id}) async {
    if (kIsWeb || sourcePath.startsWith('mock-')) {
      return sourcePath;
    }
    final file = File(sourcePath);
    if (!await file.exists()) {
      return sourcePath;
    }
    return _imageStorage.persistCapturedImage(sourcePath, id: id);
  }

  // --- Memory detail ---

  void openMemoryDetail(Memory memory) {
    _selectedMemory = memory;
    _detailPhotoIndex = 0;
    _showMemoryDetail = true;
    _showDeleteConfirm = false;
    notifyListeners();
  }

  void closeMemoryDetail() {
    _showMemoryDetail = false;
    _showDeleteConfirm = false;
    _selectedMemory = null;
    notifyListeners();
  }

  Future<void> updateSelectedTranscript(String transcript) async {
    final selected = _selectedMemory;
    if (selected == null) return;
    final trimmed = transcript.trim();
    if (trimmed.isEmpty) return;
    final updated = selected.copyWith(
      transcript: trimmed,
      updatedAt: DateTime.now(),
    );
    await _repository.upsert(updated);
    await reloadMemories();
    _selectedMemory =
        _memories.where((m) => m.id == updated.id).firstOrNull ?? updated;
    _emitSuccess();
    notifyListeners();
  }

  void requestDeleteSelected() {
    _showDeleteConfirm = true;
    notifyListeners();
  }

  void cancelDelete() {
    _showDeleteConfirm = false;
    notifyListeners();
  }

  Future<void> confirmDeleteSelected() async {
    final selected = _selectedMemory;
    if (selected == null) return;
    await _repository.delete(selected.id);
    await _imageStorage.deleteImages(selected.imagePaths);
    await reloadMemories();
    _showDeleteConfirm = false;
    _showMemoryDetail = false;
    _selectedMemory = null;
    _emitSuccess();
    notifyListeners();
  }

  // --- Settings ---

  Future<void> setLanguage(AppLanguage language) async {
    _settings = _settings.copyWith(language: language);
    await _persistSettings();
    if (_settings.dailyReminder) {
      await ensureReminderScheduled();
    }
    notifyListeners();
  }

  Future<void> setVoiceGuidance(bool value) async {
    _settings = _settings.copyWith(voiceGuidance: value);
    await _persistSettings();
    notifyListeners();
  }

  /// Returns false if notification permission was denied.
  Future<bool> setDailyReminder(bool value) async {
    if (value) {
      final ok = await _reminders.requestPermission();
      if (!ok) {
        _snackMessage = 'notificationPermissionDenied';
        notifyListeners();
        return false;
      }
      _settings = _settings.copyWith(dailyReminder: true);
      await _persistSettings();
      await ensureReminderScheduled();
      notifyListeners();
      return true;
    }
    _settings = _settings.copyWith(dailyReminder: false);
    await _persistSettings();
    await _reminders.cancel();
    notifyListeners();
    return true;
  }

  Future<void> setReminderTime(int hour, int minute) async {
    _settings = _settings.copyWith(reminderHour: hour, reminderMinute: minute);
    await _persistSettings();
    if (_settings.dailyReminder) {
      await ensureReminderScheduled();
    }
    notifyListeners();
  }

  Future<void> ensureReminderScheduled() async {
    if (!_settings.dailyReminder) return;
    await _reminders.scheduleDaily(
      hour: _settings.reminderHour,
      minute: _settings.reminderMinute,
      title: reminderTitle,
      body: reminderBody,
    );
  }

  /// Begin enabling App Lock — caller should collect a new PIN via [submitPinSetupDigit].
  Future<void> beginEnableAppLock() async {
    _awaitingPinSetup = true;
    _pinSetupFirst = null;
    _pinInput = '';
    _pinError = null;
    notifyListeners();
  }

  void cancelPinSetup() {
    _awaitingPinSetup = false;
    _pinSetupFirst = null;
    _pinInput = '';
    _pinError = null;
    notifyListeners();
  }

  Future<bool> submitPinSetupDigit(String digit) async {
    if (!_awaitingPinSetup) return false;
    if (_pinInput.length >= 4) return false;
    _pinInput += digit;
    _pinError = null;
    notifyListeners();
    if (_pinInput.length < 4) return false;

    final entered = _pinInput;
    _pinInput = '';
    if (_pinSetupFirst == null) {
      _pinSetupFirst = entered;
      notifyListeners();
      return false;
    }
    if (_pinSetupFirst != entered) {
      _pinError = 'pinMismatch';
      _pinSetupFirst = null;
      notifyListeners();
      return false;
    }
    await _pinStore.setPin(entered);
    _awaitingPinSetup = false;
    _pinSetupFirst = null;
    _settings = _settings.copyWith(appLock: true);
    await _persistSettings();
    await refreshBiometricAvailability();
    _emitSuccess();
    notifyListeners();
    return true;
  }

  bool get pinSetupConfirming => _awaitingPinSetup && _pinSetupFirst != null;

  Future<void> setAppLock(bool value) async {
    if (!value) {
      _settings = _settings.copyWith(appLock: false);
      _isLocked = false;
      await _persistSettings();
      // Keep PIN stored so re-enable can reuse or user can reset later.
      notifyListeners();
      return;
    }
    final hasPin = await _pinStore.hasPin();
    if (hasPin) {
      _settings = _settings.copyWith(appLock: true);
      await _persistSettings();
      await refreshBiometricAvailability();
      notifyListeners();
      return;
    }
    await beginEnableAppLock();
  }

  Future<void> setAutoLock(AutoLockInterval interval) async {
    _settings = _settings.copyWith(autoLock: interval);
    await _persistSettings();
    notifyListeners();
  }

  PurchaseService get purchaseService => _purchase;
  BackupService get backupService => _backup;

  /// Creates encrypted backup bytes only. Does **not** update Last Backup or
  /// emit success — that happens after the user saves via [markBackupSaved].
  Future<Uint8List?> exportBackupBytes(String password) async {
    try {
      return await _backup.createBackupBytes(password);
    } on BackupException catch (e) {
      _snackMessage = switch (e.reason) {
        BackupFailureReason.wrongPassword => 'snackBackupWrongPassword',
        BackupFailureReason.corrupted => 'snackBackupCorrupted',
        BackupFailureReason.unsupportedVersion => 'snackBackupUnsupported',
        BackupFailureReason.cancelled => 'snackBackupCancelled',
        _ => 'snackBackupFailed',
      };
      notifyListeners();
      return null;
    } catch (_) {
      _snackMessage = 'snackBackupFailed';
      notifyListeners();
      return null;
    }
  }

  /// Call only after the backup file was written to the user-chosen location.
  Future<void> markBackupSaved() async {
    _settings = _settings.copyWith(lastBackupAt: DateTime.now());
    await _persistSettings();
    _emitSuccess();
    notifyListeners();
  }

  /// Persistable error when the system save picker fails (not user cancel).
  void reportBackupSaveFailed() {
    _snackMessage = 'snackBackupSaveFailed';
    notifyListeners();
  }

  /// Restores from an encrypted backup file. Does not update Last Backup.
  Future<bool> restoreBackupFromPath({
    required String path,
    required String password,
  }) async {
    try {
      await _backup.restoreFromFile(filePath: path, password: password);
      await reloadMemories();
      _emitSuccess();
      notifyListeners();
      return true;
    } on BackupException catch (e) {
      _snackMessage = switch (e.reason) {
        BackupFailureReason.wrongPassword => 'snackBackupWrongPassword',
        BackupFailureReason.corrupted => 'snackBackupCorrupted',
        BackupFailureReason.unsupportedVersion => 'snackBackupUnsupported',
        BackupFailureReason.cancelled => 'snackBackupCancelled',
        BackupFailureReason.missingData => 'snackBackupCorrupted',
        BackupFailureReason.ioError => 'snackBackupFailed',
      };
      notifyListeners();
      return false;
    } catch (_) {
      _snackMessage = 'snackBackupFailed';
      notifyListeners();
      return false;
    }
  }

  /// Grants lifetime entitlement after a verified store purchase/restore.
  Future<void> grantLifetimeEntitlement({
    String snackKey = 'snackLifetimeUnlocked',
  }) async {
    _settings = _settings.copyWith(isLifetimeUnlocked: true);
    await _persistSettings();
    _showPaywall = false;
    // Lifetime unlock is success feedback (compact check), not a snackbar.
    _emitSuccess();
    notifyListeners();
  }

  /// Test/debug helper — prefer [purchaseLifetime] in production UI.
  Future<void> unlockLifetime() => grantLifetimeEntitlement();

  Future<PurchasePhase> purchaseLifetime() async {
    await _purchase.buyLifetime();
    final phase = _purchase.phase;
    if (phase == PurchasePhase.success ||
        phase == PurchasePhase.alreadyPurchased) {
      await grantLifetimeEntitlement(
        snackKey: phase == PurchasePhase.alreadyPurchased
            ? 'snackPurchaseAlreadyOwned'
            : 'snackLifetimeUnlocked',
      );
    } else {
      _snackMessage = switch (phase) {
        PurchasePhase.cancelled => 'snackPurchaseCancelled',
        PurchasePhase.storeUnavailable => 'snackStoreUnavailable',
        PurchasePhase.failed => 'snackPurchaseFailed',
        _ => 'snackPurchaseFailed',
      };
      notifyListeners();
    }
    return phase;
  }

  Future<PurchasePhase> restorePurchases() async {
    await _purchase.restorePurchases();
    final phase = _purchase.phase;
    if (phase == PurchasePhase.success ||
        phase == PurchasePhase.alreadyPurchased) {
      await grantLifetimeEntitlement(snackKey: 'snackPurchaseRestored');
    } else if (phase == PurchasePhase.restoreNone) {
      _snackMessage = 'snackPurchaseRestoreNone';
      notifyListeners();
    } else {
      _snackMessage = switch (phase) {
        PurchasePhase.cancelled => 'snackPurchaseCancelled',
        PurchasePhase.storeUnavailable => 'snackStoreUnavailable',
        _ => 'snackPurchaseFailed',
      };
      notifyListeners();
    }
    return phase;
  }

  Future<void> completeOnboarding() async {
    _settings = _settings.copyWith(onboardingCompleted: true);
    await _persistSettings();
    _route = AppRoute.home;
    notifyListeners();
  }

  // --- Unlock ---

  Future<void> unlockWithBiometrics() async {
    final ok = await _biometric.authenticate(localizedReason: 'Unlock PutMind');
    if (!ok) {
      _snackMessage = 'biometricFailed';
      notifyListeners();
      return;
    }
    _finishUnlock();
  }

  void showPinEntry() {
    _showPinFallback = true;
    _pinInput = '';
    _pinError = null;
    notifyListeners();
  }

  void hidePinEntry() {
    _showPinFallback = false;
    _pinInput = '';
    _pinError = null;
    notifyListeners();
  }

  Future<void> appendPinDigit(String digit) async {
    if (_awaitingPinSetup) {
      await submitPinSetupDigit(digit);
      return;
    }
    if (_pinInput.length >= 4) return;
    _pinInput += digit;
    _pinError = null;
    notifyListeners();
    if (_pinInput.length == 4) {
      final ok = await _pinStore.verifyPin(_pinInput);
      if (ok) {
        _finishUnlock();
      } else {
        _pinError = 'pinIncorrect';
        _pinInput = '';
        notifyListeners();
      }
    }
  }

  void deletePinDigit() {
    if (_pinInput.isEmpty) return;
    _pinInput = _pinInput.substring(0, _pinInput.length - 1);
    notifyListeners();
  }

  void _finishUnlock() {
    _isLocked = false;
    _showPinFallback = false;
    _pinInput = '';
    _pinError = null;
    _route = AppRoute.home;
    notifyListeners();
  }

  // --- Overlays ---

  void openPaywall() {
    _showPaywall = true;
    notifyListeners();
  }

  void hidePaywall() {
    _showPaywall = false;
    notifyListeners();
  }

  void clearSnack() {
    _snackMessage = '';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _dismissTransientOverlays({required bool keepDetail}) {
    _showPaywall = false;
    _showDeleteConfirm = false;
    if (!keepDetail) {
      _showMemoryDetail = false;
      _selectedMemory = null;
    }
  }
}
