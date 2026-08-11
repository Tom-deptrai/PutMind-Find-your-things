import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.state});

  final AppState state;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  static const _steps = [
    (
      title: 'Snap it.',
      body:
          'Take a quick photo of the thing you’re putting away. No forms, folders or categories.',
    ),
    (
      title: 'Say where you put it.',
      body:
          'Speak naturally — or type — what it is and where you stored it. Voice Guidance helps you say both.',
    ),
    (
      title: 'Find it later.',
      body:
          'Search your memories when you need something. PutMind remembers so you don’t have to.',
    ),
  ];

  void _next() {
    if (_step < _steps.length - 1) {
      setState(() => _step += 1);
    } else {
      widget.state.completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25, 40, 25, 28 + bottom * 0.2),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppRadius.onboardingArt,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        AppColors.white,
                        AppColors.onboardingArtInner,
                        AppColors.onboardingArtOuter,
                      ],
                      stops: const [0.0, 0.42, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      switch (_step) {
                        0 => Icons.photo_camera_outlined,
                        1 => Icons.mic_none_rounded,
                        _ => Icons.search_rounded,
                      },
                      size: 64,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 27),
              Text(
                step.title,
                style: AppTypography.onboardingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                step.body,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (i) {
                  final active = i == _step;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: active ? 18 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: active ? AppColors.ink : AppColors.line,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    _step == _steps.length - 1 ? 'Get started' : 'Continue',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
