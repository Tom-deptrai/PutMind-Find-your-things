import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Compact top-right success check (no bottom snackbar).
class SuccessIndicatorHost extends StatefulWidget {
  const SuccessIndicatorHost({
    super.key,
    required this.trigger,
    required this.child,
  });

  /// Incrementing token from [AppState.successTick].
  final int trigger;
  final Widget child;

  @override
  State<SuccessIndicatorHost> createState() => _SuccessIndicatorHostState();
}

class _SuccessIndicatorHostState extends State<SuccessIndicatorHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  int _lastTrigger = 0;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _lastTrigger = widget.trigger;
  }

  @override
  void didUpdateWidget(covariant SuccessIndicatorHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != _lastTrigger && widget.trigger > 0) {
      _lastTrigger = widget.trigger;
      _show();
    }
  }

  void _show() {
    _hideTimer?.cancel();
    _controller.forward(from: 0);
    _hideTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + 10;
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: top,
          right: 14,
          child: IgnorePointer(
            child: FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.72, end: 1).animate(_scale),
                child: Material(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  color: AppColors.accent,
                  shape: const CircleBorder(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
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
