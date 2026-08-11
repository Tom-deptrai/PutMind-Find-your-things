# PutMind

PutMind ("Find Your Things") is a local-first mobile app concept that helps people remember where they physically stored real-world objects. The `main` branch of this repo currently contains the product spec (Vietnamese docs `DAC_TA_SAN_PHAM.md`, `BOI_CANH_THIET_KE.md`) and two self-contained, static HTML clickable prototypes:

- `index.html` — desktop/phone-frame prototype with a sidebar screen picker.
- `mobile.html` — mobile single-page prototype with a floating "Prototype" button to jump between states.

A separate branch (`cursor/flutter-mvp-ui-foundation-05da`) contains a Flutter implementation; the `main` branch does not.

## Cursor Cloud specific instructions

- Scope: on `main` this is a pure static HTML prototype — no package manager, no build step, and no backend/database (the product is intentionally local-first with no server component). There is nothing to install; the update script is a no-op.
- Run (dev): serve the repo root over HTTP, e.g. `python3 -m http.server 8000` (Python 3 and Node are preinstalled), then open `http://localhost:8000/mobile.html` or `http://localhost:8000/index.html`. Opening the files directly via `file://` also works, but serving over HTTP mirrors the GitHub Pages deploy.
- Lint/test/build: none exist on `main`. The only automation is `.github/workflows/pages.yml`, which deploys the repo root to GitHub Pages on push to `main`.
- Prototype behavior gotcha: these are click-through prototypes, not functional apps. Buttons like "Save memory" only navigate between static screens — new memories are NOT persisted or added to the list. Search filtering (Home screen) and screen navigation are the interactive parts that actually work.
- Working on the actual Flutter app requires checking out the `cursor/flutter-mvp-ui-foundation-05da` branch and installing the Flutter SDK; that is out of scope for the `main` branch.
