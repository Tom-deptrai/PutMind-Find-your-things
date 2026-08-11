#!/usr/bin/env python3
"""Generate Kokoro-backed locales (ja/zh/it)."""

from __future__ import annotations

import json
import struct
import wave
from pathlib import Path

import numpy as np
import soundfile as sf
from kokoro import KPipeline

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = json.loads(
    (ROOT / "assets" / "voice_guidance" / "scripts.json").read_text(encoding="utf-8")
)
OUT = ROOT / "assets" / "voice_guidance"
LISTEN = ROOT / "docs" / "voice_guidance_license" / "listen"
LISTEN.mkdir(parents=True, exist_ok=True)

# Apache-2.0 Kokoro voices
MAP = {
    "ja-JP": ("j", "jf_alpha"),
    "zh-TW": ("z", "zf_xiaobei"),
    "it-IT": ("i", "if_sara"),
}


def trim_norm_wav(path: Path) -> None:
    with wave.open(str(path), "rb") as wf:
        params = wf.getparams()
        frames = wf.readframes(wf.getnframes())
    if params.sampwidth != 2:
        return
    samples = memoryview(frames).cast("h")
    n = len(samples)
    thr = 400
    start = 0
    while start < n and abs(samples[start]) < thr:
        start += 1
    end = n - 1
    while end > start and abs(samples[end]) < thr:
        end -= 1
    pad = int(params.framerate * 0.02)
    start = max(0, start - pad)
    end = min(n - 1, end + pad)
    arr = list(samples[start : end + 1])
    mx = max((abs(x) for x in arr), default=1) or 1
    target = int(32767 * 0.89)
    if mx < target:
        gain = target / mx
        arr = [max(-32767, min(32767, int(x * gain))) for x in arr]
    data = struct.pack("<" + "h" * len(arr), *arr)
    with wave.open(str(path), "wb") as wf:
        wf.setparams(params)
        wf.writeframes(data)


def main() -> None:
    for loc, (lang, voice) in MAP.items():
        text = SCRIPTS["locales"][loc]["text"]
        out = OUT / f"{loc}.wav"
        print(f"KOKORO {loc} voice={voice}: {text}")
        pipeline = KPipeline(lang_code=lang)
        parts = []
        for _, _, audio in pipeline(text, voice=voice, speed=0.95):
            parts.append(np.asarray(audio, dtype=np.float32))
        if not parts:
            raise SystemExit(f"No audio for {loc}")
        audio = np.concatenate(parts)
        sf.write(str(out), audio, 24000)
        trim_norm_wav(out)
        (LISTEN / f"{loc}.wav").write_bytes(out.read_bytes())
        with wave.open(str(out), "rb") as wf:
            dur = wf.getnframes() / wf.getframerate()
        print(f"  OK {dur:.2f}s {out.stat().st_size}B")
    print("kokoro batch done")


if __name__ == "__main__":
    main()
