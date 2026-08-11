import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/memory.dart';
import '../models/settings.dart';
import '../services/image_storage.dart';
import '../services/memory_repository.dart';

enum AppRoute { home, capture, settings, unlock, onboarding }

enum CapturePhase { preview, guiding, listening, editing }

enum CaptureMode { create, replacePhoto }

/// App state for PutMind MVP.
///
/// Step 2: SQLite + local images + real camera capture paths.
/// Voice / biometric / billing remain mocked until later steps.
class AppState extends ChangeNotifier {
  AppState({
    required MemoryRepository repository,
    required ImageStorage imageStorage,
    AppSettings? settings,
  }) : _repository = repository,
       _imageStorage = imageStorage,
       _settings = settings ?? const AppSettings() {
    if (!_settings.onboardingCompleted) {
      _route = AppRoute.onboarding;
    } else if (_settings.appLock) {
      _isLocked = true;
      _route = AppRoute.unlock;
    }
  }

  /// Factory used by the real app entrypoint.
  static Future<AppState> create({
    MemoryRepository? repository,
    ImageStorage? imageStorage,
    AppSettings? settings,
  }) async {
    final repo = repository ?? InMemoryMemoryRepository();
    final images = imageStorage ?? await ImageStorage.create();
    final state = AppState(
      repository: repo,
      imageStorage: images,
      settings: settings,
    );
    await state.reloadMemories();
    return state;
  }

  final MemoryRepository _repository;
  final ImageStorage _imageStorage;
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
  String? _captureImagePath;
  String? _replaceMemoryId;
  Timer? _captureTimer;

  Memory? _selectedMemory;
  bool _showMemoryDetail = false;
  bool _showPaywall = false;
  bool _showDeleteConfirm = false;
  bool _showPinFallback = false;
  String _pinInput = '';
  String _snackMessage = '';
  String? _errorMessage;

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
  String? get captureImagePath => _captureImagePath;
  bool get hasCapturedPhoto =>
      _captureImagePath != null && _captureImagePath!.isNotEmpty;
  Memory? get selectedMemory => _selectedMemory;
  bool get showMemoryDetail => _showMemoryDetail;
  bool get showPaywall => _showPaywall;
  bool get showDeleteConfirm => _showDeleteConfirm;
  bool get showPinFallback => _showPinFallback;
  String get pinInput => _pinInput;
  String get snackMessage => _snackMessage;
  String? get errorMessage => _errorMessage;
  int get memoryCount => _totalCount;
  bool get canAddMemory =>
      _settings.isLifetimeUnlocked || _totalCount < kFreeMemoryLimit;
  int get remainingFreeSlots =>
      (_settings.isLifetimeUnlocked ? 999 : (kFreeMemoryLimit - _totalCount))
          .clamp(0, kFreeMemoryLimit);

  List<Memory> get filteredMemories {
    // Populated via [reloadMemories] / [setSearchQuery] from repository search.
    return _memories;
  }

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

  // --- Navigation ---

  void goTo(AppRoute route) {
    _route = route;
    if (route == AppRoute.capture) {
      // Keep replace mode if already set; otherwise reset for create.
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

  /// Opens Capture to replace the photo of [memory].
  void openReplacePhoto(Memory memory) {
    _selectedMemory = memory;
    _replaceMemoryId = memory.id;
    _captureMode = CaptureMode.replacePhoto;
    _resetCapture();
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

  /// Step 2: voice search still mocked until speech lands in Step 3+.
  Future<void> mockVoiceSearch() async {
    await setSearchQuery('passport');
  }

  // --- Capture ---

  void _resetCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
    _capturePhase = CapturePhase.preview;
    _captureTranscript = '';
    _captureImagePath = null;
  }

  /// Called by CaptureScreen after a successful camera shutter.
  void onPhotoCaptured(String imagePath) {
    _captureTimer?.cancel();
    _captureImagePath = imagePath;
    if (_captureMode == CaptureMode.replacePhoto) {
      _capturePhase = CapturePhase.editing;
      notifyListeners();
      return;
    }
    if (_settings.voiceGuidance) {
      _capturePhase = CapturePhase.guiding;
      notifyListeners();
      _captureTimer = Timer(const Duration(milliseconds: 900), () {
        if (_capturePhase == CapturePhase.guiding) {
          startListening();
        }
      });
    } else {
      startListening();
    }
  }

  /// Web / test helper: mark a photo as captured without a real camera file.
  void takePhoto({String? mockImagePath}) {
    onPhotoCaptured(mockImagePath ?? 'mock-captured');
  }

  void startListening() {
    _captureTimer?.cancel();
    _capturePhase = CapturePhase.listening;
    notifyListeners();
    // Mock speech-to-text until Step 3.
    _captureTimer = Timer(const Duration(milliseconds: 1400), () {
      if (_capturePhase == CapturePhase.listening &&
          _captureTranscript.trim().isEmpty) {
        _captureTranscript = 'Passport, in the second drawer of my work desk.';
        _capturePhase = CapturePhase.editing;
        notifyListeners();
      }
    });
  }

  void setCaptureTranscript(String value) {
    _captureTranscript = value;
    if (hasCapturedPhoto && value.trim().isNotEmpty) {
      _captureTimer?.cancel();
      _captureTimer = null;
      _capturePhase = CapturePhase.editing;
    }
    notifyListeners();
  }

  void retake() {
    final previous = _captureImagePath;
    _resetCapture();
    notifyListeners();
    // Best-effort cleanup of temp capture if it was under managed storage.
    if (previous != null && !previous.startsWith('mock-')) {
      unawaited(_imageStorage.deleteImage(previous));
    }
  }

  @override
  void dispose() {
    _captureTimer?.cancel();
    unawaited(_repository.close());
    super.dispose();
  }

  Future<bool> saveMemory() async {
    if (_isSaving) return false;

    if (_captureMode == CaptureMode.replacePhoto) {
      return _saveReplacedPhoto();
    }

    final text = _captureTranscript.trim();
    final sourcePath = _captureImagePath;
    if (sourcePath == null || sourcePath.isEmpty || text.isEmpty) {
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
      final persistedPath = await _persistOrKeep(sourcePath, id: id);
      final memory = Memory(
        id: id,
        transcript: text,
        createdAt: now,
        updatedAt: now,
        imagePath: persistedPath,
      );
      await _repository.upsert(memory);
      _searchQuery = '';
      await reloadMemories();
      _resetCapture();
      _captureMode = CaptureMode.create;
      _replaceMemoryId = null;
      _route = AppRoute.home;
      _snackMessage = 'snackMemorySaved';
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'saveFailed';
      _snackMessage = 'saveMemoryFailed';
      notifyListeners();
      return false;
    }
  }

  Future<bool> _saveReplacedPhoto() async {
    final memoryId = _replaceMemoryId;
    final sourcePath = _captureImagePath;
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

      final newPath = await _imageStorage.replaceImage(
        sourcePath: sourcePath,
        previousPath: existing.imagePath,
        id: '$memoryId-${DateTime.now().millisecondsSinceEpoch}',
      );
      final updated = existing.copyWith(
        imagePath: newPath,
        updatedAt: DateTime.now(),
      );
      await _repository.upsert(updated);
      await reloadMemories();
      _resetCapture();
      _captureMode = CaptureMode.create;
      _replaceMemoryId = null;
      _selectedMemory = updated;
      _route = AppRoute.home;
      _snackMessage = 'photoReplaced';
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isSaving = false;
      _errorMessage = 'saveFailed';
      _snackMessage = 'replacePhotoFailed';
      notifyListeners();
      return false;
    }
  }

  Future<String?> _persistOrKeep(
    String sourcePath, {
    required String id,
  }) async {
    if (kIsWeb || sourcePath.startsWith('mock-')) {
      return sourcePath.startsWith('mock-') ? null : sourcePath;
    }
    final file = File(sourcePath);
    if (!await file.exists()) {
      // Allow tests that pass a synthetic path.
      return sourcePath;
    }
    return _imageStorage.persistCapturedImage(sourcePath, id: id);
  }

  // --- Memory detail ---

  void openMemoryDetail(Memory memory) {
    _selectedMemory = memory;
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
    final updated = selected.copyWith(
      transcript: transcript.trim(),
      updatedAt: DateTime.now(),
    );
    await _repository.upsert(updated);
    await reloadMemories();
    _selectedMemory = updated;
    _snackMessage = 'snackMemoryUpdated';
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
    await _imageStorage.deleteImage(selected.imagePath);
    await reloadMemories();
    _showDeleteConfirm = false;
    _showMemoryDetail = false;
    _selectedMemory = null;
    _snackMessage = 'snackMemoryDeleted';
    notifyListeners();
  }

  // --- Settings ---

  void setLanguage(AppLanguage language) {
    _settings = _settings.copyWith(language: language);
    notifyListeners();
  }

  void setVoiceGuidance(bool value) {
    _settings = _settings.copyWith(voiceGuidance: value);
    notifyListeners();
  }

  void setDailyReminder(bool value) {
    _settings = _settings.copyWith(dailyReminder: value);
    if (value) {
      _snackMessage = 'snackReminderSchedulingMock';
    }
    notifyListeners();
  }

  void setReminderTime(int hour, int minute) {
    _settings = _settings.copyWith(reminderHour: hour, reminderMinute: minute);
    notifyListeners();
  }

  void setAppLock(bool value) {
    _settings = _settings.copyWith(appLock: value);
    if (value) {
      _snackMessage = 'snackAppLockMockInfo';
    }
    notifyListeners();
  }

  void setAutoLock(AutoLockInterval interval) {
    _settings = _settings.copyWith(autoLock: interval);
    notifyListeners();
  }

  void mockCreateBackup() {
    _settings = _settings.copyWith(lastBackupAt: DateTime.now());
    _snackMessage = 'snackBackupCreatedMock';
    notifyListeners();
  }

  void mockRestoreBackup() {
    _snackMessage = 'snackRestoreBackupMock';
    notifyListeners();
  }

  void unlockLifetime() {
    _settings = _settings.copyWith(isLifetimeUnlocked: true);
    _showPaywall = false;
    _snackMessage = 'snackLifetimeUnlockedMock';
    notifyListeners();
  }

  void mockRestorePurchase() {
    _settings = _settings.copyWith(isLifetimeUnlocked: true);
    _snackMessage = 'snackPurchaseRestoredMock';
    notifyListeners();
  }

  void completeOnboarding() {
    _settings = _settings.copyWith(onboardingCompleted: true);
    _route = AppRoute.home;
    notifyListeners();
  }

  // --- Unlock ---

  void unlockWithBiometrics() {
    _isLocked = false;
    _showPinFallback = false;
    _pinInput = '';
    _route = AppRoute.home;
    notifyListeners();
  }

  void showPinEntry() {
    _showPinFallback = true;
    _pinInput = '';
    notifyListeners();
  }

  void hidePinEntry() {
    _showPinFallback = false;
    _pinInput = '';
    notifyListeners();
  }

  void appendPinDigit(String digit) {
    if (_pinInput.length >= 4) return;
    _pinInput += digit;
    notifyListeners();
    if (_pinInput.length == 4) {
      unlockWithBiometrics();
    }
  }

  void deletePinDigit() {
    if (_pinInput.isEmpty) return;
    _pinInput = _pinInput.substring(0, _pinInput.length - 1);
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

  // --- Prototype / debug helpers ---

  Future<void> prototypeShowEmptyHome() async {
    await _repository.clear();
    _searchQuery = '';
    _isLocked = false;
    _route = AppRoute.home;
    _dismissTransientOverlays(keepDetail: false);
    await reloadMemories();
  }

  Future<void> prototypeRestoreDemoMemories() async {
    await _repository.replaceAll(createSeedMemories());
    _isLocked = false;
    _route = AppRoute.home;
    _dismissTransientOverlays(keepDetail: false);
    await reloadMemories();
  }

  void prototypeShowOnboarding() {
    _settings = _settings.copyWith(onboardingCompleted: false);
    _isLocked = false;
    _route = AppRoute.onboarding;
    _dismissTransientOverlays(keepDetail: false);
    notifyListeners();
  }

  void prototypeShowUnlock() {
    _settings = _settings.copyWith(appLock: true);
    _isLocked = true;
    _route = AppRoute.unlock;
    _dismissTransientOverlays(keepDetail: false);
    notifyListeners();
  }

  Future<void> prototypeShowMemoryDetail() async {
    if (_memories.isEmpty) {
      await prototypeRestoreDemoMemories();
    }
    _route = AppRoute.home;
    _isLocked = false;
    openMemoryDetail(_memories.first);
  }

  void prototypeShowPaywall() {
    _route = AppRoute.home;
    _isLocked = false;
    _showPaywall = true;
    _showMemoryDetail = false;
    _showDeleteConfirm = false;
    notifyListeners();
  }

  // --- Internals ---

  void _dismissTransientOverlays({required bool keepDetail}) {
    _showPaywall = false;
    _showDeleteConfirm = false;
    if (!keepDetail) {
      _showMemoryDetail = false;
      _selectedMemory = null;
    }
  }
}
