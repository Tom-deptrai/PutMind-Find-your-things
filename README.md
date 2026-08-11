# PutMind

**PutMind: Find Your Things**  
Snap it. Say where. Find it later.

Flutter MVP through **Step 2 (Core Memory)**: UI, 10-language localization, SQLite persistence, local image storage, and real camera on Android/iOS. Product source of truth: `DAC_TA_SAN_PHAM.md`. UI baseline: `mobile.html`.

## Running PutMind on a real Android device

### Clone lần đầu

```bash
git clone https://github.com/Tom-deptrai/PutMind-Find-your-things.git
cd PutMind-Find-your-things
flutter pub get
```

### Kiểm tra môi trường

```bash
flutter doctor
flutter devices
```

On the Samsung phone: enable **Developer options** → **USB debugging**, then connect USB (or use wireless debugging). Accept the debugging prompt on the phone until it appears under `flutter devices`.

### Chạy trên Samsung

```bash
flutter run
```

If more than one device is listed:

```bash
flutter run -d <device-id>
```

### Những lần Cursor cập nhật sau

```bash
git pull
flutter pub get
flutter run
```

## Run (web / browser review)

```bash
flutter pub get
flutter run -d chrome
```

On a wide desktop browser window, PutMind stays inside a **mobile-sized frame** (430px, matching `mobile.html`) so UI is reviewable without stretching into a desktop layout. Web uses an in-memory store and mock camera — native Android/iOS is the source of truth for Core Memory.

```bash
flutter build web
```

Output: `build/web/`

## Quality checks

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

Debug APK output: `build/app/outputs/flutter-apk/app-debug.apk`

## Current MVP scope

**Done (through Step 3):** Home / Capture / Search / Memory Detail CRUD, SQLite + local images, real camera, speech-to-text, voice guidance playback, daily reminder notifications, App Lock (biometric + PIN) + auto-lock, settings persistence, fullscreen photo viewer, 10 languages.

**Still mocked / later steps:** Backup encryption & restore, StoreKit / Play Billing Lifetime purchase.
