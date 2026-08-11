#!/usr/bin/env python3
"""Generate Piper-backed locales only (no extra pip deps)."""

from __future__ import annotations

import json
import struct
import subprocess
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = json.loads(
    (ROOT / "assets" / "voice_guidance" / "scripts.json").read_text(encoding="utf-8")
)
PIPER = ROOT / "tool" / ".tts_cache" / "piper" / "piper" / "piper.exe"
VOICES = ROOT / "tool" / ".tts_cache" / "voices"
OUT = ROOT / "assets" / "voice_guidance"
LISTEN = ROOT / "docs" / "voice_guidance_license" / "listen"
LISTEN.mkdir(parents=True, exist_ok=True)

MAP = {
    "en-US": "en_US-joe-medium",
    "de-DE": "de_DE-thorsten-medium",
    "fr-FR": "fr_FR-siwis-medium",
    "es-ES": "es_ES-davefx-medium",
    "pt-BR": "pt_BR-faber-medium",
}


def trim_norm(path: Path) -> None:
    with wave.open(str(path), "rb") as wf:
        params = wf.getparams()
        frames = wf.readframes(wf.getnframes())
    if params.sampwidth != 2:
        return
    samples = memoryview(frames).cast("h")
    n = len(samples)
    thr = 500
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
    for loc, mid in MAP.items():
        text = SCRIPTS["locales"][loc]["text"]
        out = OUT / f"{loc}.wav"
        model = VOICES / f"{mid}.onnx"
        print("PIPER", loc, text)
        proc = subprocess.run(
            [str(PIPER), "--model", str(model), "--output_file", str(out)],
            input=text.encode("utf-8"),
            capture_output=True,
            check=False,
        )
        if proc.returncode != 0:
            raise SystemExit(proc.stderr.decode("utf-8", errors="replace"))
        trim_norm(out)
        (LISTEN / f"{loc}.wav").write_bytes(out.read_bytes())
        with wave.open(str(out), "rb") as wf:
            dur = wf.getnframes() / wf.getframerate()
        print(f"  OK {dur:.2f}s {out.stat().st_size}B")
    print("piper batch done")


if __name__ == "__main__":
    main()
