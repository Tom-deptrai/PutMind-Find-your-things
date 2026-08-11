import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/memory.dart';
import '../models/settings.dart';
import '../services/memory_repository.dart';

enum AppRoute { home, capture, settings, unlock, onboarding }

enum CapturePhase { preview, guiding, listening, editing }

/// In-memory app state for Step 1 UI review.
///
/// Native camera / speech / biometric / billing / SQLite arrive in later steps.
class AppState extends ChangeNotifier {
  AppState({
    MemoryRepository? repository,
    AppSettings? settings,
    bool seedDemoMemories = true,
  }) : _repository =
           repository ??
           InMemoryMemoryRepository(
             seed: seedDemoMemories ? createSeedMemories() : const [],
           ),
       _settings = settings ?? const AppSettings() {
    _refreshMemories();
    if (!_settings.onboardingCompleted) {
      _route = AppRoute.onboarding;
    } else if (_settings.appLock) {
      _isLocked = true;
      _route = AppRoute.unlock;
    }
  }

  final MemoryRepository _repository;

  AppSettings _settings;
  List<Memory> _memories = const [];
  String _searchQuery = '';
  AppRoute _route = AppRoute.home;
  bool _isLocked = false;

  CapturePhase _capturePhase = CapturePhase.preview;
  String _captureTranscript = '';
  bool _hasCapturedPhoto = false;
  Timer? _captureTimer;

  Memory? _selectedMemory;
  bool _showMemoryDetail = false;
  bool _showPaywall = false;
  bool _showDeleteConfirm = false;
  bool _showPinFallback = false;
  String _pinInput = '';
  String _snackMessage = '';

  // --- Getters ---

  AppSettings get settings => _settings;
  List<Memory> get memories => _memories;
  String get searchQuery => _searchQuery;
  AppRoute get route => _route;
  bool get isLocked => _isLocked;
  CapturePhase get capturePhase => _capturePhase;
  String get captureTranscript => _captureTranscript;
  bool get hasCapturedPhoto => _hasCapturedPhoto;
  Memory? get selectedMemory => _selectedMemory;
  bool get showMemoryDetail => _showMemoryDetail;
  bool get showPaywall => _showPaywall;
  bool get showDeleteConfirm => _showDeleteConfirm;
  bool get showPinFallback => _showPinFallback;
  String get pinInput => _pinInput;
  String get snackMessage => _snackMessage;
  int get memoryCount => _memories.length;
  bool get canAddMemory =>
      _settings.isLifetimeUnlocked || _memories.length < kFreeMemoryLimit;
  int get remainingFreeSlots =>
      (_settings.isLifetimeUnlocked
              ? 999
              : (kFreeMemoryLimit - _memories.length))
          .clamp(0, kFreeMemoryLimit);

  List<Memory> get filteredMemories {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) return _memories;
    final scored = <({Memory memory, int score})>[];
    for (final m in _memories) {
      final hay = '${m.transcript} ${m.title} ${m.location}'.toLowerCase();
      if (!hay.contains(q) && !_fuzzyContains(hay, q)) continue;
      final score = hay.contains(q) ? 2 : 1;
      scored.add((memory: m, score: score));
    }
    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return b.memory.updatedAt.compareTo(a.memory.updatedAt);
    });
    return scored.map((e) => e.memory).toList(growable: false);
  }

  // --- Navigation ---

  void goTo(AppRoute route) {
    _route = route;
    if (route == AppRoute.capture) {
      _resetCapture();
    }
    if (route != AppRoute.unlock) {
      _showPinFallback = false;
      _pinInput = '';
    }
    _dismissTransientOverlays(keepDetail: false);
    notifyListeners();
  }

  void openHome() => goTo(AppRoute.home);

  void openCapture() {
    if (_isLocked) {
      goTo(AppRoute.unlock);
      return;
    }
    goTo(AppRoute.capture);
  }

  void openSettings() => goTo(AppRoute.settings);

  // --- Search ---

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Step 1 mock voice-search: fills a sample query.
  void mockVoiceSearch() {
    _searchQuery = 'passport';
    notifyListeners();
  }

  // --- Capture ---

  void _resetCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
    _capturePhase = CapturePhase.preview;
    _captureTranscript = '';
    _hasCapturedPhoto = false;
  }

  void takePhoto() {
    _captureTimer?.cancel();
    _hasCapturedPhoto = true;
    if (_settings.voiceGuidance) {
      _capturePhase = CapturePhase.guiding;
      notifyListeners();
      // Mock Voice Guidance duration, then listen.
      _captureTimer = Timer(const Duration(milliseconds: 900), () {
        if (_capturePhase == CapturePhase.guiding) {
          startListening();
        }
      });
    } else {
      startListening();
    }
  }

  void startListening() {
    _captureTimer?.cancel();
    _capturePhase = CapturePhase.listening;
    notifyListeners();
    // Mock speech-to-text result for reviewable UI.
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
    if (_hasCapturedPhoto && value.trim().isNotEmpty) {
      _captureTimer?.cancel();
      _captureTimer = null;
      _capturePhase = CapturePhase.editing;
    }
    notifyListeners();
  }

  void retake() {
    _resetCapture();
    notifyListeners();
  }

  @override
  void dispose() {
    _captureTimer?.cancel();
    super.dispose();
  }

  Future<bool> saveMemory() async {
    final text = _captureTranscript.trim();
    if (!_hasCapturedPhoto || text.isEmpty) return false;

    if (!canAddMemory) {
      _showPaywall = true;
      notifyListeners();
      return false;
    }

    final now = DateTime.now();
    final memory = Memory(
      id: 'mem-${now.microsecondsSinceEpoch}',
      transcript: text,
      createdAt: now,
      updatedAt: now,
      imageAssetKey: 'mock-captured',
    );
    await _repository.upsert(memory);
    _refreshMemories();
    _resetCapture();
    _route = AppRoute.home;
    _searchQuery = '';
    _snackMessage = 'Memory saved';
    notifyListeners();
    return true;
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
    final updated = Memory(
      id: selected.id,
      transcript: transcript.trim(),
      createdAt: selected.createdAt,
      updatedAt: DateTime.now(),
      imageAssetKey: selected.imageAssetKey,
    );
    await _repository.upsert(updated);
    _refreshMemories();
    _selectedMemory = updated;
    _snackMessage = 'Memory updated';
    notifyListeners();
  }

  /// Step 1: mock replace-photo (UI feedback only).
  void mockReplacePhoto() {
    final selected = _selectedMemory;
    if (selected == null) return;
    final updated = selected.copyWith(
      imageAssetKey: 'mock-replaced-${DateTime.now().millisecondsSinceEpoch}',
      updatedAt: DateTime.now(),
    );
    _repository.upsert(updated);
    _refreshMemories();
    _selectedMemory = updated;
    _snackMessage = 'Photo replaced (mock)';
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
    _refreshMemories();
    _showDeleteConfirm = false;
    _showMemoryDetail = false;
    _selectedMemory = null;
    _snackMessage = 'Memory deleted';
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
      _snackMessage = 'Reminder scheduling will connect in a later step';
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
      _snackMessage =
          'App Lock stores credentials securely in a later step. For now this is UI state.';
    }
    notifyListeners();
  }

  void setAutoLock(AutoLockInterval interval) {
    _settings = _settings.copyWith(autoLock: interval);
    notifyListeners();
  }

  void mockCreateBackup() {
    _settings = _settings.copyWith(lastBackupAt: DateTime.now());
    _snackMessage = 'Backup created (mock)';
    notifyListeners();
  }

  void mockRestoreBackup() {
    _snackMessage = 'Restore will connect in a later step';
    notifyListeners();
  }

  void unlockLifetime() {
    _settings = _settings.copyWith(isLifetimeUnlocked: true);
    _showPaywall = false;
    _snackMessage = 'Lifetime unlocked (mock purchase)';
    notifyListeners();
  }

  void mockRestorePurchase() {
    _settings = _settings.copyWith(isLifetimeUnlocked: true);
    _snackMessage = 'Purchase restored (mock)';
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
      // Step 1: any 4-digit PIN unlocks (real validation later).
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

  // --- Prototype / debug helpers ---

  void prototypeShowEmptyHome() {
    _repository.clear();
    _refreshMemories();
    _searchQuery = '';
    _isLocked = false;
    _route = AppRoute.home;
    _dismissTransientOverlays(keepDetail: false);
    notifyListeners();
  }

  void prototypeRestoreDemoMemories() {
    _repository.replaceAll(createSeedMemories());
    _refreshMemories();
    _isLocked = false;
    _route = AppRoute.home;
    _dismissTransientOverlays(keepDetail: false);
    notifyListeners();
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

  void prototypeShowMemoryDetail() {
    if (_memories.isEmpty) {
      prototypeRestoreDemoMemories();
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

  void _refreshMemories() {
    final all = [..._repository.getAll()];
    all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _memories = all;
  }

  void _dismissTransientOverlays({required bool keepDetail}) {
    _showPaywall = false;
    _showDeleteConfirm = false;
    if (!keepDetail) {
      _showMemoryDetail = false;
      _selectedMemory = null;
    }
  }

  bool _fuzzyContains(String haystack, String needle) {
    if (needle.length < 3) return false;
    // Simple near-match: allow one missing contiguous character pair.
    for (var i = 0; i < needle.length - 1; i++) {
      final partial = needle.substring(0, i) + needle.substring(i + 1);
      if (haystack.contains(partial)) return true;
    }
    return false;
  }
}
