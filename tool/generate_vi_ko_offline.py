#!/usr/bin/env python3
"""Generate vi-VN + ko-KR voice guidance offline (build-time only)."""

from __future__ import annotations

import json
import shutil
import struct
import sys
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "assets" / "voice_guidance" / "scripts.json"
OUT_DIR = ROOT / "assets" / "voice_guidance"
LISTEN_DIR = ROOT / "docs" / "voice_guidance_license" / "listen"


def trim_wav(path: Path, silence_thresh: int = 500) -> None:
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


def peak_normalize(path: Path, peak: float = 0.89) -> None:
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


def wav_stats(path: Path) -> tuple[float, int]:
    with wave.open(str(path), "rb") as wf:
        frames = wf.getnframes()
        rate = wf.getframerate()
        duration = frames / float(rate) if rate else 0.0
    return duration, path.stat().st_size


def finalize(locale: str, path: Path) -> dict:
    trim_wav(path)
    peak_normalize(path)
    dur, size = wav_stats(path)
    if dur < 0.6 or size <= 12844:
        raise RuntimeError(f"{locale} too short/silence-like ({dur:.2f}s, {size}B)")
    LISTEN_DIR.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, LISTEN_DIR / f"{locale}.wav")
    return {"duration_s": round(dur, 2), "bytes": size}


def gen_vi(text: str, out: Path) -> None:
    from vieneu import Vieneu

    # Default v3turbo: ONNX CPU, Apache-licensed commercial path (not 0.3B NC).
    tts = Vieneu(mode="v3turbo")
    audio = tts.infer(text=text)
    tts.save(audio, str(out))


def gen_ko(text: str, out: Path) -> None:
    from melo.api import TTS

    model = TTS(language="KR", device="cpu")
    speaker_ids = model.hps.data.spk2id
    model.tts_to_file(text, speaker_ids["KR"], str(out), speed=1.0)


def main() -> int:
    data = json.loads(SCRIPTS.read_text(encoding="utf-8"))
    locales = data["locales"]
    targets = sys.argv[1:] or ["vi-VN", "ko-KR"]
    results = {}
    failures = []
    for locale in targets:
        text = locales[locale]["text"]
        out = OUT_DIR / f"{locale}.wav"
        print(f"Generating {locale}: {text}")
        try:
            if locale == "vi-VN":
                gen_vi(text, out)
            elif locale == "ko-KR":
                gen_ko(text, out)
            else:
                raise ValueError(locale)
            results[locale] = finalize(locale, out)
            print(f"  OK {results[locale]}")
        except Exception as e:  # noqa: BLE001
            print(f"  FAIL: {e}", file=sys.stderr)
            failures.append(locale)
            results[locale] = {"error": str(e)}
    print(json.dumps(results, ensure_ascii=False, indent=2))
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
