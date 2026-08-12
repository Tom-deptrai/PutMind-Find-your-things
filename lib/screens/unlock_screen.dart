import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class UnlockScreen extends StatelessWidget {
  const UnlockScreen({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.lockGradientTop, AppColors.lockGradientBottom],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: state.showPinFallback
                  ? _PinFallback(state: state)
                  : _BiometricUnlock(state: state),
            ),
          ),
        ),
      ),
    );
  }
}

class _BiometricUnlock extends StatelessWidget {
  const _BiometricUnlock({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const Spacer(flex: 2),
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.white,
            size: 34,
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.unlockTitle, style: AppTypography.unlockTitle),
        const SizedBox(height: 7),
        Text(
          l10n.unlockSubtitle,
          style: AppTypography.body,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        if (!state.biometricCapabilityResolved)
          const SizedBox(
            height: 52,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          )
        else if (state.biometricAvailable)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: state.unlockWithBiometrics,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: Text(l10n.unlockWithBiometrics),
            ),
          )
        else
          Text(
            l10n.biometricUnavailable,
            style: AppTypography.meta,
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 13),
        TextButton(
          onPressed: state.showPinEntry,
          child: Text(
            l10n.unlockUsePin,
            style: const TextStyle(fontSize: 13, color: AppColors.ink),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _PinFallback extends StatelessWidget {
  const _PinFallback({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = switch (state.pinError) {
      'pinIncorrect' => l10n.pinIncorrect,
      'pinMismatch' => l10n.pinMismatch,
      _ => null,
    };
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: state.hidePinEntry,
            child: Text(l10n.pinBack),
          ),
        ),
        const Spacer(),
        Text(l10n.enterPin, style: AppTypography.unlockTitle),
        const SizedBox(height: 8),
        Text(
          error ?? l10n.pinUnlockHint,
          style: AppTypography.body.copyWith(
            color: error != null ? AppColors.danger : null,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final filled = i < state.pinInput.length;
            return Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? AppColors.ink : Colors.transparent,
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
            );
          }),
        ),
        const SizedBox(height: 36),
        _PinPad(state: state),
        const Spacer(),
      ],
    );
  }
}

class _PinPad extends StatelessWidget {
  const _PinPad({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Column(
      children: [
        for (final row in keys)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final key in row)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 72,
                    height: 56,
                    child: key.isEmpty
                        ? const SizedBox.shrink()
                        : OutlinedButton(
                            onPressed: () {
                              if (key == '⌫') {
                                state.deletePinDigit();
                              } else {
                                state.appendPinDigit(key);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              key,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
