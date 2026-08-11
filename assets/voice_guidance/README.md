# Voice Guidance assets

Product Spec requires **pre-generated, licensed, redistributable** spoken prompts per locale
(same meaning as “What is this? Where did you put it?”). Source text lives in `scripts.json`.

Audio is generated **once offline**, then bundled. The Flutter app does **not** call cloud TTS.

## Status

| Locale | Engine / voice | Status |
|--------|----------------|--------|
| en-US | Piper `en_US-joe-medium` | production |
| ja-JP | Kokoro `jf_alpha` | production |
| de-DE | Piper `de_DE-thorsten-medium` | production |
| vi-VN | VieNeu-TTS-v3-Turbo default (`Ngọc Lan`) | production |
| ko-KR | MeloTTS Korean `KR` | production |
| fr-FR | Piper `fr_FR-siwis-medium` | production |
| es-ES | Piper `es_ES-davefx-medium` | production |
| pt-BR | Piper `pt_BR-faber-medium` | production |
| it-IT | Kokoro `if_sara` | production |
| zh-TW | Kokoro `zf_xiaobei` (Mandarin voice + Traditional script) | production |

`scripts.json` → `"productionReady": true`.

Regenerate (build-time only):

```powershell
# Requires local models under tool/.tts_cache (gitignored) + tool/.venv_tts312
.\tool\.venv_tts312\Scripts\python.exe tool\generate_voice_guidance_offline.py
```

Listen on Windows:

```powershell
.\tool\play_voice_guidance.ps1
```

License / provenance: [`docs/voice_guidance_license/`](../../docs/voice_guidance_license/).
