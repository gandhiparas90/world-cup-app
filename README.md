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

Stage 2.3 is the current runnable Flutter checkpoint:

- Personalized Home screen that starts with profile setup instead of a dense fixture list.
- Fixtures screen with seeded World Cup matches, local viewing metadata, team news, and prototype predictions.
- Match Detail screen with scoreline estimates, scorer likelihoods, team context, and US viewing info when a profile exists.
- Profile screen with local Hive-backed display name, country, time zone, favorite team, and saved predictions.
- Portugal exists in the local team catalog so a user can select Portugal even when Portugal is not in today's fixture snapshot.

Run the app:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter run -d chrome
```

Verified Stage 2.3 commands:

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens --dart-define=SCREENSHOT_STAGE=stage2_3
/Users/parasgandhi/Project/temp/flutter/bin/flutter build web --no-wasm-dry-run
```

Stage 2.3 screenshots are stored in `docs/screenshots/stage2_3/`.
