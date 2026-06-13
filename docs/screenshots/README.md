# Progress Screenshots

This directory tracks staged screenshots for the World Cup MatchIQ Flutter app.

Each implementation stage should add or refresh screenshots under a stage folder:

```text
docs/screenshots/
  stage1/
  stage2/
  stage3/
```

Capture the current stage screenshots from the app project with:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens
```

Stage 1 screenshots:

- `stage1/01_matches_dashboard.png`
- `stage1/02_match_detail.png`
- `stage1/03_saved_predictions.png`
