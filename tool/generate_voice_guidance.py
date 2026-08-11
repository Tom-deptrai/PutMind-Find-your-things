#!/usr/bin/env python3
"""Generate PutMind Voice Guidance WAV assets via Google Cloud Text-to-Speech.

Requires one of:
  GOOGLE_APPLICATION_CREDENTIALS  — path to service-account JSON
  GOOGLE_TTS_API_KEY              — API key with Cloud Text-to-Speech enabled

Usage (from repo root):
  python tool/generate_voice_guidance.py

Outputs LINEAR16 mono WAV files under assets/voice_guidance/{locale}.wav
and updates scripts.json productionReady when all succeed.
"""

from __future__ import annotations

import base64
import json
import os
import struct
import sys
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "assets" / "voice_guidance" / "scripts.json"
OUT_DIR = ROOT / "assets" / "voice_guidance"
TTS_URL = "https://texttospeech.googleapis.com/v1/text:synthesize"
SAMPLE_RATE = 24000


def _wav_from_pcm(pcm: bytes, sample_rate: int = SAMPLE_RATE) -> bytes:
    channels = 1
    bits = 16
    byte_rate = sample_rate * channels * bits // 8
    block_align = channels * bits // 8
    data_size = len(pcm)
    header = struct.pack(
        "<4sI4s4sIHHIIHH4sI",
        b"RIFF",
        36 + data_size,
        b"WAVE",
        b"fmt ",
        16,
        1,
        channels,
        sample_rate,
        byte_rate,
        block_align,
        bits,
        b"data",
        data_size,
    )
    return header + pcm


def _auth_query_and_headers() -> tuple[str, dict[str, str]]:
    api_key = os.environ.get("GOOGLE_TTS_API_KEY", "").strip()
    if api_key:
        return f"?key={api_key}", {"Content-Type": "application/json; charset=utf-8"}

    cred_path = os.environ.get("GOOGLE_APPLICATION_CREDENTIALS", "").strip()
    if not cred_path:
        print(
            "Missing credentials. Set GOOGLE_TTS_API_KEY or "
            "GOOGLE_APPLICATION_CREDENTIALS.",
            file=sys.stderr,
        )
        sys.exit(2)

    try:
        from google.auth.transport.requests import Request
        from google.oauth2 import service_account
    except ImportError:
        print(
            "Install google-auth: pip install google-auth",
            file=sys.stderr,
        )
        sys.exit(2)

    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    creds = service_account.Credentials.from_service_account_file(
        cred_path, scopes=scopes
    )
    creds.refresh(Request())
    return "", {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": f"Bearer {creds.token}",
    }


def synthesize(text: str, voice_name: str, language_code: str, query: str, headers: dict) -> bytes:
    # cmn-TW voices use languageCode cmn-TW
    lang = "cmn-TW" if language_code == "zh-TW" else language_code
    body = {
        "input": {"text": text},
        "voice": {"languageCode": lang, "name": voice_name},
        "audioConfig": {
            "audioEncoding": "LINEAR16",
            "sampleRateHertz": SAMPLE_RATE,
            "speakingRate": 1.0,
            "pitch": 0.0,
            "volumeGainDb": 0.0,
        },
    }
    req = urllib.request.Request(
        TTS_URL + query,
        data=json.dumps(body).encode("utf-8"),
        headers=headers,
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        payload = json.loads(resp.read().decode("utf-8"))
    audio_b64 = payload.get("audioContent")
    if not audio_b64:
        raise RuntimeError(f"No audioContent for {language_code}")
    return base64.b64decode(audio_b64)


def main() -> int:
    query, headers = _auth_query_and_headers()
    data = json.loads(SCRIPTS.read_text(encoding="utf-8"))
    locales = data["locales"]
    failures: list[str] = []

    for locale, entry in locales.items():
        text = entry["text"]
        voice = entry["voice"]
        print(f"Generating {locale} ({voice})…")
        try:
            pcm = synthesize(text, voice, locale, query, headers)
            # API returns WAV for LINEAR16 on some paths; detect RIFF vs raw PCM
            if pcm[:4] == b"RIFF":
                wav = pcm
            else:
                wav = _wav_from_pcm(pcm)
            out = OUT_DIR / f"{locale}.wav"
            out.write_bytes(wav)
            print(f"  wrote {out.name} ({len(wav)} bytes)")
        except urllib.error.HTTPError as e:
            body = e.read().decode("utf-8", errors="replace")
            print(f"  FAIL HTTP {e.code}: {body}", file=sys.stderr)
            failures.append(locale)
        except Exception as e:  # noqa: BLE001
            print(f"  FAIL {e}", file=sys.stderr)
            failures.append(locale)

    if failures:
        print(f"Failed locales: {', '.join(failures)}", file=sys.stderr)
        return 1

    data["productionReady"] = True
    SCRIPTS.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("All 10 locales generated. scripts.json productionReady=true")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
