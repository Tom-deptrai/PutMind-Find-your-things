# Voice Guidance — license & provenance

## Approach

PutMind bundles **pre-generated** spoken prompts. The app does **not** call cloud TTS at runtime.

Production audio is generated offline with **Google Cloud Text-to-Speech** (Neural2 / WaveNet voices listed in `assets/voice_guidance/scripts.json`), then committed as app assets.

## Commercial use / redistribution

Google Cloud Text-to-Speech allows customers to use synthesized audio in their products subject to the [Google Cloud Terms of Service](https://cloud.google.com/terms) and [Cloud Text-to-Speech documentation](https://cloud.google.com/text-to-speech/docs). PutMind only ships audio generated under a project owned by the PutMind publisher.

Do **not** commit API keys or service-account JSON to this repository.

## Generation

```bash
# Set credentials (pick one):
#   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
#   export GOOGLE_TTS_API_KEY=your_api_key

python tool/generate_voice_guidance.py
```

After a successful run:

1. Confirm each `assets/voice_guidance/{locale}.wav` is no longer the DEV silence placeholder (~12844 bytes).
2. Set `"productionReady": true` in `assets/voice_guidance/scripts.json`.
3. Update the status table in `assets/voice_guidance/README.md`.
4. Record generate date / GCP project (non-secret) in `docs/voice_guidance_license/GENERATION_LOG.md`.

## Status

Until credentials are provided and the generator is run, assets remain DEV silence placeholders. Scripts and pipeline are ready.
