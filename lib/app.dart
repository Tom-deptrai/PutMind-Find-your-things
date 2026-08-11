import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'screens/capture_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/unlock_screen.dart';
import 'services/image_storage.dart';
import 'services/purchase_service.dart';
import 'services/repository_factory.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/mobile_viewport_frame.dart';

class PutMindApp extends StatefulWidget {
  const PutMindApp({super.key, this.state});

  /// Optional injectable state for tests.
  final AppState? state;

  @override
  State<PutMindApp> createState() => _PutMindAppState();
}

class _PutMindAppState extends State<PutMindApp> with WidgetsBindingObserver {
  AppState? _state;
  bool _bootstrapping = false;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.state != null) {
      _state = widget.state;
      _state!.addListener(_onStateChanged);
      _syncReminderCopy(_state!);
    } else {
      _bootstrapping = true;
      _bootstrap();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final state = _state;
    if (state == null) return;
    // Use paused/resumed — inactive fires for permission dialogs / camera.
    if (lifecycle == AppLifecycleState.paused) {
      state.onAppPaused();
    } else if (lifecycle == AppLifecycleState.resumed) {
      state.onAppResumed();
    }
  }

  Future<void> _bootstrap() async {
    final repository = await createMemoryRepository();
    final imageStorage = await ImageStorage.create();
    final purchaseService = kIsWeb
        ? FakePurchaseService(isAvailable: false)
        : StorePurchaseService();
    final state = await AppState.create(
      repository: repository,
      imageStorage: imageStorage,
      purchaseService: purchaseService,
    );
    if (!mounted) {
      state.dispose();
      return;
    }
    await state.refreshBiometricAvailability();
    setState(() {
      _state = state;
      _bootstrapping = false;
    });
    _state!.addListener(_onStateChanged);
    _syncReminderCopy(state);
    if (state.settings.dailyReminder) {
      await state.ensureReminderScheduled();
    }
  }

  void _syncReminderCopy(AppState state) {
    final loc = _messengerKey.currentContext == null
        ? null
        : AppLocalizations.of(_messengerKey.currentContext!);
    if (loc != null) {
      state.reminderTitle = loc.dailyReminderNotificationTitle;
      state.reminderBody = loc.dailyReminderNotificationBody;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _state?.removeListener(_onStateChanged);
    if (widget.state == null) {
      _state?.dispose();
    }
    super.dispose();
  }

  void _onStateChanged() {
    final state = _state;
    if (state == null) return;
    _syncReminderCopy(state);
    final messageKey = state.snackMessage;
    if (messageKey.isNotEmpty) {
      final loc = _messengerKey.currentContext == null
          ? null
          : AppLocalizations.of(_messengerKey.currentContext!);
      final text = _localizeSnack(loc, messageKey);
      _messengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
      state.clearSnack();
    }
    setState(() {});
  }

  String _localizeSnack(AppLocalizations? loc, String key) {
    if (loc == null) return key;
    return switch (key) {
      'snackMemorySaved' => loc.snackMemorySaved,
      'snackMemoryUpdated' => loc.snackMemoryUpdated,
      'snackMemoryDeleted' => loc.snackMemoryDeleted,
      'photoReplaced' => loc.photoReplaced,
      'saveMemoryFailed' => loc.saveMemoryFailed,
      'replacePhotoFailed' => loc.replacePhotoFailed,
      'snackAppLockMockInfo' => loc.snackAppLockMockInfo,
      'snackAppLockEnabled' => loc.snackAppLockEnabled,
      'snackReminderSchedulingMock' => loc.snackReminderSchedulingMock,
      'snackBackupCreated' => loc.snackBackupCreated,
      'snackBackupRestored' => loc.snackBackupRestored,
      'snackBackupFailed' => loc.snackBackupFailed,
      'snackBackupWrongPassword' => loc.snackBackupWrongPassword,
      'snackBackupCorrupted' => loc.snackBackupCorrupted,
      'snackBackupUnsupported' => loc.snackBackupUnsupported,
      'snackBackupCancelled' => loc.snackBackupCancelled,
      'snackLifetimeUnlocked' => loc.snackLifetimeUnlocked,
      'snackPurchaseRestored' => loc.snackPurchaseRestored,
      'snackPurchaseRestoreNone' => loc.snackPurchaseRestoreNone,
      'snackPurchaseCancelled' => loc.snackPurchaseCancelled,
      'snackPurchaseFailed' => loc.snackPurchaseFailed,
      'snackPurchaseAlreadyOwned' => loc.snackPurchaseAlreadyOwned,
      'snackStoreUnavailable' => loc.snackStoreUnavailable,
      'snackPhotoReplacedMock' => loc.snackPhotoReplacedMock,
      'microphoneDenied' => loc.microphoneDenied,
      'speechUnavailable' => loc.speechUnavailable,
      'notificationPermissionDenied' => loc.notificationPermissionDenied,
      'biometricFailed' => loc.biometricFailed,
      'biometricUnavailable' => loc.biometricUnavailable,
      _ => key,
    };
  }

  Widget _screenFor(AppState state, AppRoute route) {
    switch (route) {
      case AppRoute.home:
        return HomeScreen(state: state);
      case AppRoute.capture:
        return CaptureScreen(state: state);
      case AppRoute.settings:
        return SettingsScreen(state: state);
      case AppRoute.unlock:
        return UnlockScreen(state: state);
      case AppRoute.onboarding:
        return OnboardingScreen(state: state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;

    if (state == null || _bootstrapping) {
      return MaterialApp(
        title: 'PutMind',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'PutMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      scaffoldMessengerKey: _messengerKey,
      locale: state.settings.language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return MobileViewportFrame(child: child ?? const SizedBox.shrink());
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: KeyedSubtree(
          key: ValueKey('${state.route}-${state.captureMode}'),
          child: _screenFor(state, state.route),
        ),
      ),
    );
  }
}
