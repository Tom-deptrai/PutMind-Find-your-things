import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'debug/prototype_navigator.dart';
import 'l10n/app_localizations.dart';
import 'screens/capture_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/unlock_screen.dart';
import 'services/image_storage.dart';
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

class _PutMindAppState extends State<PutMindApp> {
  AppState? _state;
  bool _bootstrapping = false;
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      _state = widget.state;
      _state!.addListener(_onStateChanged);
    } else {
      _bootstrapping = true;
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    final repository = await createMemoryRepository();
    final imageStorage = await ImageStorage.create();
    final state = await AppState.create(
      repository: repository,
      imageStorage: imageStorage,
    );
    if (!mounted) {
      state.dispose();
      return;
    }
    setState(() {
      _state = state;
      _bootstrapping = false;
    });
    _state!.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state?.removeListener(_onStateChanged);
    if (widget.state == null) {
      _state?.dispose();
    }
    super.dispose();
  }

  void _onStateChanged() {
    final state = _state;
    if (state == null) return;
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
      'snackReminderSchedulingMock' => loc.snackReminderSchedulingMock,
      'snackBackupCreatedMock' => loc.snackBackupCreatedMock,
      'snackRestoreBackupMock' => loc.snackRestoreBackupMock,
      'snackLifetimeUnlockedMock' => loc.snackLifetimeUnlockedMock,
      'snackPurchaseRestoredMock' => loc.snackPurchaseRestoredMock,
      'snackPhotoReplacedMock' => loc.snackPhotoReplacedMock,
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

    final prototype = kDebugMode
        ? PrototypeNavigator(state: state, navigatorKey: _navigatorKey)
        : null;

    return MaterialApp(
      title: 'PutMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      scaffoldMessengerKey: _messengerKey,
      navigatorKey: _navigatorKey,
      locale: state.settings.language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final content = Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (prototype != null) prototype,
          ],
        );

        return MobileViewportFrame(child: content);
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
