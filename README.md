# PutMind

**PutMind: Find Your Things**  
Snap it. Say where. Find it later.

Flutter MVP foundation + complete UI (Step 1). Product source of truth: `DAC_TA_SAN_PHAM.md`. UI baseline: `mobile.html`.

## Run

```bash
flutter pub get
flutter run
```

Normal launch opens **Home** (or Unlock / Onboarding when those states are active).

## Prototype / Debug Navigator

In **debug** builds only, tap the **Prototype** button (bottom-right) to jump between:

- Home
- Capture
- Settings
- Unlock
- Onboarding
- Empty Home
- Memory Detail
- Paywall

This control is not part of the PutMind product UI and does not appear in release builds (`kDebugMode` gated).

## Quality checks

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

## Step 1 scope

UI + in-memory/mock state for review. Native camera, speech-to-text, biometric, SQLite, billing, encrypted backup, and notifications are intentionally deferred to later steps.
