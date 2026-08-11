# PutMind

**PutMind: Find Your Things**  
Snap it. Say where. Find it later.

Flutter MVP foundation + complete UI (Step 1). Product source of truth: `DAC_TA_SAN_PHAM.md`. UI baseline: `mobile.html`.

## Run (mobile)

```bash
flutter pub get
flutter run
```

Normal launch opens **Home** (or Unlock / Onboarding when those states are active).

## Run (web / browser review)

```bash
flutter pub get
flutter run -d chrome
```

On a wide desktop browser window, PutMind stays inside a **mobile-sized frame** (430px, matching `mobile.html`) so the Step 1 UI is reviewable without stretching into a desktop layout.

Production web build:

```bash
flutter build web
```

Output: `build/web/`

## Prototype / Debug Navigator

In **debug** builds only (including `flutter run -d chrome`), tap the **Prototype** button (bottom-right) to jump between:

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
flutter build web
```

## Step 1 scope

UI + in-memory/mock state for review. Native camera, speech-to-text, biometric, SQLite, billing, encrypted backup, and notifications are intentionally deferred to later steps. Web uses the same mocks.
