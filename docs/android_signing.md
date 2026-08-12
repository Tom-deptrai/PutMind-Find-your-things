# Android upload signing (PutMind)

Release builds read `android/key.properties` (gitignored) when present.

## One-time local setup

```bash
cd android
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
cp key.properties.example key.properties
# Edit key.properties with store/key passwords and storeFile path.
```

Keep `upload-keystore.jks` and `key.properties` off git (see `android/.gitignore`).

Without `key.properties`, `flutter build apk --release` still signs with the **debug** key so local smoke tests work — do **not** upload that artifact to Play.
