# World Cup MatchIQ

World Cup MatchIQ is a Flutter course-project prototype for AI-assisted FIFA
World Cup match previews and scoreline predictions.

The app will be built iteratively so every milestone leaves a runnable app:

1. Seeded local World Cup match browser.
2. Persistent favorites and saved predictions.
3. Local prediction engine for scorelines and scorer likelihoods.
4. AI-generated match previews using a provider such as Gemini.
5. Optional sports-data API refresh when API access is available.

The design spec lives at:

`docs/superpowers/specs/2026-06-13-world-cup-matchiq-design.md`

## Current Checkpoint

Stage 2.8 is the current runnable Flutter checkpoint:

- Personalized Home screen that starts with profile setup instead of a dense fixture list.
- Full local catalog for all 48 World Cup teams, Groups A-L, and all 72 group-stage fixtures.
- Fixtures screen with local kickoff conversion, US viewing metadata, team notes, completed-result labels, local final-score overrides, and prototype predictions.
- Teams screen with searchable team catalog sourced from the same local team table as the Profile favorite-team dropdown.
- Match Detail screen with local final-score update controls, win/draw/loss percentages, scoreline estimates, "Why this prediction?" factors, scorer likelihoods, team context, and US viewing info when a profile exists.
- AI match preview card that can generate a Gemini-backed preview from local match/team/player/prediction data, with deterministic offline fallback when no API key is supplied.
- Profile screen with local Hive-backed display name, country, time zone, favorite team, saved predictions, AI previews, and fixture result overrides.
- Player/scorer records remain partial by design until a roster/stat source is connected.

Run the app:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter run -d chrome
```

## Local AI API Key

The repo is public, so API keys must stay in ignored local env files.

```bash
cd world_cup_matchiq_app
cp .env.example .env.local
```

Then edit `.env.local` locally:

```text
GEMINI_API_KEY=your_google_ai_studio_key
AI_PROVIDER=gemini
AI_MODEL=gemini-3.5-flash
```

Do not add real API keys to Dart source, screenshots, docs, commits, or GitHub
issues.

For local prototype runs with Gemini enabled:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/dart run tool/gemini_proxy.dart
```

In a second terminal:

```bash
cd world_cup_matchiq_app
GEMINI_PROXY_URL=http://127.0.0.1:8787/generateContent bash tool/flutter_with_env.sh run -d chrome
```

The local proxy reads `GEMINI_API_KEY` from `.env.local`, calls Gemini
server-side, and enables CORS for the local Flutter web app. The helper passes
`AI_MODEL` and `GEMINI_PROXY_URL` as dart defines. This keeps the key out of
Git and out of the browser bundle.

Verified Stage 2.8 commands:

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens --dart-define=SCREENSHOT_STAGE=stage2_8
GEMINI_PROXY_URL=http://127.0.0.1:8787/generateContent bash tool/flutter_with_env.sh build web --no-wasm-dry-run
```

Stage 2.8 screenshots are stored in `docs/screenshots/stage2_8/`.
