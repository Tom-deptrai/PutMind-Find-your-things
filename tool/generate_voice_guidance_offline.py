#!/usr/bin/env python3
"""Offline PutMind Voice Guidance generator (no cloud TTS).

Engines (build-time only; models stay in tool/.tts_cache / HF cache, not committed):
  - Piper — en / de / fr / es / pt (commercially-safe MODEL_CARD voices)
  - Kokoro-82M (Apache-2.0) — ja / zh-TW / it
  - MeloTTS Korean (MIT) — ko-KR
  - VieNeu-TTS-v3-Turbo (Apache-2.0) — vi-VN

Requires tool/.venv_tts312 with packages installed, Piper binary + ONNX under tool/.tts_cache.
"""

from __future__ import annotations

import json
import shutil
import struct
import subprocess
import sys
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "assets" / "voice_guidance" / "scripts.json"
OUT_DIR = ROOT / "assets" / "voice_guidance"
CACHE = ROOT / "tool" / ".tts_cache"
VOICES = CACHE / "voices"
PIPER = CACHE / "piper" / "piper" / "piper.exe"
LISTEN_DIR = ROOT / "docs" / "voice_guidance_license" / "listen"

PIPER_MAP = {
    "en-US": "en_US-joe-medium",
    "de-DE": "de_DE-thorsten-medium",
    "fr-FR": "fr_FR-siwis-medium",
    "es-ES": "es_ES-davefx-medium",
    "pt-BR": "pt_BR-faber-medium",
}


def _trim_wav(path: Path, silence_thresh: int = 500) -> None:
    with wave.open(str(path), "rb") as wf:
        params = wf.getparams()
        frames = wf.readframes(wf.getnframes())
    if params.sampwidth != 2:
        return
    samples = memoryview(frames).cast("h")
    n = len(samples)
    start = 0
    while start < n and abs(samples[start]) < silence_thresh:
        start += 1
    end = n - 1
    while end > start and abs(samples[end]) < silence_thresh:
        end -= 1
    pad = int(params.framerate * 0.02)
    start = max(0, start - pad)
    end = min(n - 1, end + pad)
    trimmed = samples[start : end + 1].tobytes()
    with wave.open(str(path), "wb") as wf:
        wf.setparams(params)
        wf.writeframes(trimmed)


def _peak_normalize(path: Path, peak: float = 0.89) -> None:
    with wave.open(str(path), "rb") as wf:
        params = wf.getparams()
        frames = wf.readframes(wf.getnframes())
    if params.sampwidth != 2 or not frames:
        return
    samples = list(struct.unpack("<" + "h" * (len(frames) // 2), frames))
    mx = max(abs(s) for s in samples) or 1
    target = int(32767 * peak)
    if mx >= target:
        return
    gain = target / mx
    out = [max(-32767, min(32767, int(s * gain))) for s in samples]
    data = struct.pack("<" + "h" * len(out), *out)
    with wave.open(str(path), "wb") as wf:
        wf.setparams(params)
        wf.writeframes(data)


def _wav_stats(path: Path) -> tuple[float, int]:
    with wave.open(str(path), "rb") as wf:
        frames = wf.getnframes()
        rate = wf.getframerate()
        duration = frames / float(rate) if rate else 0.0
    return duration, path.stat().st_size


def synthesize_piper(locale: str, text: str, out: Path) -> None:
    model_id = PIPER_MAP[locale]
    model = VOICES / f"{model_id}.onnx"
    if not PIPER.exists():
        raise FileNotFoundError(f"Missing piper: {PIPER}")
    if not model.exists():
        raise FileNotFoundError(f"Missing model: {model}")
    proc = subprocess.run(
        [str(PIPER), "--model", str(model), "--output_file", str(out)],
        input=text.encode("utf-8"),
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0 or not out.exists():
        raise RuntimeError(
            f"Piper failed for {locale}: {proc.stderr.decode('utf-8', errors='replace')}"
        )


def synthesize_kokoro(locale: str, text: str, out: Path) -> None:
    from kokoro import KPipeline
    import numpy as np
    import soundfile as sf

    mapping = {
        "ja-JP": ("j", "jf_alpha"),
        "zh-TW": ("z", "zf_xiaobei"),
        "it-IT": ("i", "if_sara"),
    }
    if locale not in mapping:
        raise ValueError(f"Kokoro not configured for {locale}")
    lang, voice = mapping[locale]
    pipeline = KPipeline(lang_code=lang)
    audio_parts = []
    for _, _, audio in pipeline(text, voice=voice, speed=1.0):
        audio_parts.append(audio)
    if not audio_parts:
        raise RuntimeError(f"Kokoro produced no audio for {locale}")
    audio = np.concatenate(audio_parts)
    sf.write(str(out), audio, 24000)


def synthesize_melo_ko(text: str, out: Path) -> None:
    from melo.api import TTS

    model = TTS(language="KR", device="cpu")
    speaker_ids = model.hps.data.spk2id
    model.tts_to_file(text, speaker_ids["KR"], str(out), speed=1.0)


def synthesize_vieneu(text: str, out: Path) -> None:
    from vieneu import Vieneu

    # Apache-2.0 VieNeu-TTS-v3-Turbo (not 0.3B NC). Default built-in voice.
    tts = Vieneu(mode="v3turbo")
    audio = tts.infer(text=text)
    tts.save(audio, str(out))


def main() -> int:
    data = json.loads(SCRIPTS.read_text(encoding="utf-8"))
    locales = data["locales"]
    LISTEN_DIR.mkdir(parents=True, exist_ok=True)

    plan = {
        "en-US": "piper",
        "de-DE": "piper",
        "fr-FR": "piper",
        "es-ES": "piper",
        "pt-BR": "piper",
        "it-IT": "kokoro",
        "ja-JP": "kokoro",
        "zh-TW": "kokoro",
        "ko-KR": "melo",
        "vi-VN": "vieneu",
    }

    results = {}
    failures = []
    for locale, entry in locales.items():
        text = entry["text"]
        out = OUT_DIR / f"{locale}.wav"
        engine = plan[locale]
        print(f"[{engine}] {locale}: {text}")
        try:
            if engine == "piper":
                synthesize_piper(locale, text, out)
            elif engine == "kokoro":
                synthesize_kokoro(locale, text, out)
            elif engine == "melo":
                synthesize_melo_ko(text, out)
            elif engine == "vieneu":
                synthesize_vieneu(text, out)
            else:
                raise RuntimeError(engine)
            _trim_wav(out)
            _peak_normalize(out)
            dur, size = _wav_stats(out)
            if dur < 0.6 or size <= 12844:
                raise RuntimeError(f"Audio too short/silence-like ({dur:.2f}s, {size}B)")
            shutil.copy2(out, LISTEN_DIR / f"{locale}.wav")
            results[locale] = {"engine": engine, "duration_s": round(dur, 2), "bytes": size}
            print(f"  OK {dur:.2f}s {size} bytes")
        except Exception as e:  # noqa: BLE001
            print(f"  FAIL: {e}", file=sys.stderr)
            failures.append(locale)
            results[locale] = {"engine": engine, "error": str(e)}

    report = CACHE / "generation_report.json"
    CACHE.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps(results, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    ok = [k for k, v in results.items() if "error" not in v]
    data["productionReady"] = len(ok) == 10
    data["generationEngines"] = {k: v.get("engine") for k, v in results.items()}
    SCRIPTS.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(f"Completed {len(ok)}/10. Failures: {failures or 'none'}")
    print(f"Listen copies: {LISTEN_DIR}")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
