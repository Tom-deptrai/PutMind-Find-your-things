# Voice Guidance — license & provenance

## Approach

PutMind bundles **pre-generated** spoken prompts. The app does **not** call cloud TTS at runtime and has **no** Google Cloud / Azure / Polly / ElevenLabs / OpenAI / Edge online TTS dependency.

Production audio is synthesized **offline** (build-time tooling under `tool/`), trimmed/normalized, then committed as `assets/voice_guidance/{locale}.wav`.

## Engines used

| Engine | Code license | Used for |
|--------|--------------|----------|
| Piper (rhasspy binary + voice ONNX) | MIT binary; per-voice MODEL_CARD | en-US, de-DE, fr-FR, es-ES, pt-BR |
| Kokoro-82M (`hexgrad/Kokoro-82M`) | Apache-2.0 | ja-JP, it-IT, zh-TW |
| VieNeu-TTS-v3-Turbo | Apache-2.0 (model + code) | vi-VN |
| MeloTTS Korean | MIT (library + model card) | ko-KR |

Per-locale gate notes: [`locales/`](locales/).

## Rejected for commercial PutMind shipping

| Candidate | Reason |
|-----------|--------|
| Piper `vi_VN-vivos-*` | MODEL_CARD CC BY-NC-SA |
| Piper `zh_CN-huayan-*` | MODEL_CARD license unclear |
| Piper `it_IT-paola-*` | MODEL_CARD unclear → Kokoro used instead |
| VieNeu-TTS-0.3B | CC BY-NC 4.0 |
| Hosted cloud TTS APIs | Out of scope for this offline task |

## Generation

```powershell
# One-shot orchestrator (Piper + Kokoro + VieNeu + Melo as configured)
.\tool\.venv_tts312\Scripts\python.exe tool\generate_voice_guidance_offline.py

# Or only missing locales:
.\tool\.venv_tts312\Scripts\python.exe tool\generate_vi_ko_offline.py
```

Do **not** commit `tool/.tts_cache/`, `tool/.venv*/`, or ONNX/model weights.

## Owner listening

```powershell
.\tool\play_voice_guidance.ps1
```

Copies assets into `docs/voice_guidance_license/listen/` (gitignored) and opens Explorer + a `.m3u` playlist.
