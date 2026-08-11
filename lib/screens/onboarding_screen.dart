import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.state});

  final AppState state;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  void _next() {
    if (_step < 2) {
      setState(() => _step += 1);
    } else {
      widget.state.completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.paddingOf(context).bottom;

    final title = switch (_step) {
      0 => l10n.onboardingSnapTitle,
      1 => l10n.onboardingSayWhereTitle,
      _ => l10n.onboardingFindLaterTitle,
    };

    final body = switch (_step) {
      0 => l10n.onboardingSnapBody,
      1 => l10n.onboardingSayWhereBody,
      _ => l10n.onboardingFindLaterBody,
    };

    final stepCount = 3;

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
                title,
                style: AppTypography.onboardingTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(stepCount, (i) {
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
                    _step == stepCount - 1
                        ? l10n.onboardingGetStarted
                        : l10n.onboardingContinue,
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
