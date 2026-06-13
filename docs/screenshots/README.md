# Progress Screenshots

This directory tracks staged screenshots for the World Cup MatchIQ Flutter app.

Each implementation stage should add or refresh screenshots under a stage folder:

```text
docs/screenshots/
  stage1/
  stage2/
  stage2_1/
  stage3/
```

Capture the current stage screenshots from the app project with:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens --dart-define=SCREENSHOT_STAGE=stage2_1
```

Stage 1 screenshots:

- `stage1/01_matches_dashboard.png`
- `stage1/02_match_detail.png`
- `stage1/03_saved_predictions.png`

Stage 2 screenshots:

- `stage2/01_matches_dashboard.png`
- `stage2/02_match_detail.png`
- `stage2/03_saved_predictions.png`

Stage 2.1 screenshots:

- `stage2_1/01_matches_dashboard.png`
- `stage2_1/02_match_detail.png`
- `stage2_1/03_saved_predictions.png`
