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

Stage 1 is the first runnable Flutter checkpoint:

- Matches screen with seeded World Cup fixtures.
- Match Detail screen with prototype scoreline and scorer likelihood estimates.
- Saved Predictions screen with in-memory saved predictions.

Run the app:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter run -d chrome
```

Verified Stage 1 commands:

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
/Users/parasgandhi/Project/temp/flutter/bin/flutter build web --no-wasm-dry-run
```
