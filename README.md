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

Stage 2.4 is the current runnable Flutter checkpoint:

- Personalized Home screen that starts with profile setup instead of a dense fixture list.
- Full local catalog for all 48 World Cup teams, Groups A-L, and all 72 group-stage fixtures.
- Fixtures screen with local kickoff conversion, US viewing metadata, team notes, completed-result labels, and prototype predictions.
- Teams screen with searchable team catalog sourced from the same local team table as the Profile favorite-team dropdown.
- Match Detail screen with scoreline estimates, scorer likelihoods, team context, and US viewing info when a profile exists.
- Profile screen with local Hive-backed display name, country, time zone, favorite team, and saved predictions.
- Player/scorer records remain partial by design until a roster/stat source is connected.

Run the app:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter run -d chrome
```

Verified Stage 2.4 commands:

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens --dart-define=SCREENSHOT_STAGE=stage2_4
/Users/parasgandhi/Project/temp/flutter/bin/flutter build web --no-wasm-dry-run
```

Stage 2.4 screenshots are stored in `docs/screenshots/stage2_4/`.
