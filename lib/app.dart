import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'debug/prototype_navigator.dart';
import 'screens/capture_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/unlock_screen.dart';
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
  late final AppState _state = widget.state ?? AppState();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    if (widget.state == null) {
      _state.dispose();
    }
    super.dispose();
  }

  void _onStateChanged() {
    final message = _state.snackMessage;
    if (message.isNotEmpty) {
      _messengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
      _state.clearSnack();
    }
    setState(() {});
  }

  Widget _screenFor(AppRoute route) {
    switch (route) {
      case AppRoute.home:
        return HomeScreen(state: _state);
      case AppRoute.capture:
        return CaptureScreen(state: _state);
      case AppRoute.settings:
        return SettingsScreen(state: _state);
      case AppRoute.unlock:
        return UnlockScreen(state: _state);
      case AppRoute.onboarding:
        return OnboardingScreen(state: _state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prototype = kDebugMode
        ? PrototypeNavigator(state: _state, navigatorKey: _navigatorKey)
        : null;

    return MaterialApp(
      title: 'PutMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      scaffoldMessengerKey: _messengerKey,
      navigatorKey: _navigatorKey,
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
          key: ValueKey(_state.route),
          child: _screenFor(_state.route),
        ),
      ),
    );
  }
}
