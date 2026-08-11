# Voice Guidance assets

Product Spec requires **pre-generated, licensed, redistributable** spoken prompts per locale
(same meaning as “What is this? Where did you put it?”). Source text lives in `scripts.json`.

## Status

| Locale | Production voice | Status |
|--------|------------------|--------|
| en-US | pending | DEV silence placeholder |
| ja-JP | pending | DEV silence placeholder |
| de-DE | pending | DEV silence placeholder |
| vi-VN | pending | DEV silence placeholder |
| ko-KR | pending | DEV silence placeholder |
| fr-FR | pending | DEV silence placeholder |
| es-ES | pending | DEV silence placeholder |
| pt-BR | pending | DEV silence placeholder |
| it-IT | pending | DEV silence placeholder |
| zh-TW | pending | DEV silence placeholder |

`scripts.json` → `"productionReady": false` until `tool/generate_voice_guidance.py` succeeds with publisher Google Cloud credentials.

License / provenance: [`docs/voice_guidance_license/`](../../docs/voice_guidance_license/).

Do **not** use runtime cloud TTS in the app.
