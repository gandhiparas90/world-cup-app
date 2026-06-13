# Stage 2.5 Explainable Predictions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local explainable prediction engine and expose its reasoning in Match Detail.

**Architecture:** Move prediction calculations from UI widgets into a service returning a `PredictionResult`. Widgets render that result, saved predictions store its scoreline/confidence, and Stage 3 Gemini prompts will reuse the same structured result.

**Tech Stack:** Flutter, Dart service classes, Provider-owned existing repository data, widget tests, Flutter golden screenshots.

---

### Task 1: Prediction Models And Engine

**Files:**
- Create: `world_cup_matchiq_app/lib/models/prediction_result.dart`
- Create: `world_cup_matchiq_app/lib/services/prediction_engine.dart`
- Test: `world_cup_matchiq_app/test/prediction_engine_test.dart`

- [ ] **Step 1: Add failing tests**

```dart
final result = PredictionEngine().predict(
  match: SeedData.matchById('bra-mar'),
  home: SeedData.teamById('bra'),
  away: SeedData.teamById('mar'),
  players: SeedData.playersForMatch('bra-mar'),
);
expect(result.homeWinPercent + result.drawPercent + result.awayWinPercent, 100);
expect(result.factors, isNotEmpty);
expect(result.scorers, isNotEmpty);
```

- [ ] **Step 2: Implement `PredictionResult`**

Include immutable fields for scoreline, confidence, expected goals, probabilities,
factor rows, scorer rows, and disclaimer.

- [ ] **Step 3: Implement `PredictionEngine.predict`**

Use local team/player fields only. Clamp expected goals to `0.1..4.5`, clamp
scorer percentages to `3..55`, and normalize match outcome percentages to `100`.

- [ ] **Step 4: Run prediction tests**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test test/prediction_engine_test.dart
```

Expected: all tests pass.

### Task 2: Match Detail UI

**Files:**
- Modify: `world_cup_matchiq_app/lib/widgets/prediction_summary.dart`
- Modify: `world_cup_matchiq_app/lib/widgets/scorer_likelihood_list.dart`
- Modify: `world_cup_matchiq_app/lib/screens/match_detail_screen.dart`
- Test: `world_cup_matchiq_app/test/widget_test.dart`

- [ ] **Step 1: Replace widget-local calculation**

`PredictionSummary` should accept a `PredictionResult` instead of calculating
from teams.

- [ ] **Step 2: Add factor breakdown**

Render title `Why this prediction?` and each factor label/value/explanation from
`PredictionResult.factors`.

- [ ] **Step 3: Use result for save**

`MatchDetailScreen` creates one `PredictionResult` through `PredictionEngine`
and uses it for display and saved predictions.

- [ ] **Step 4: Update widget tests**

Assert `Win probability`, `Why this prediction?`, and `Likely scorers` appear on
Match Detail.

### Task 3: Docs And Screenshots

**Files:**
- Modify: `README.md`
- Modify: `docs/data-method.md`
- Modify: `docs/screenshots/README.md`
- Modify: `world_cup_matchiq_app/tool/progress_screenshots.dart`
- Create: `docs/screenshots/stage2_5/*.png`

- [ ] **Step 1: Update docs**

Document that Stage 2.5 adds a local heuristic prediction engine and still does
not use Gemini.

- [ ] **Step 2: Generate screenshots**

Run:

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens --dart-define=SCREENSHOT_STAGE=stage2_5
```

Expected: five screenshots under `docs/screenshots/stage2_5/`.

### Task 4: Verification And Push

**Files:**
- All changed files.

- [ ] **Step 1: Format**

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/dart format lib test tool
```

- [ ] **Step 2: Analyze**

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
```

- [ ] **Step 3: Test**

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
```

- [ ] **Step 4: Build web**

```bash
/Users/parasgandhi/Project/temp/flutter/bin/flutter build web --no-wasm-dry-run
```

- [ ] **Step 5: Commit and push**

```bash
git add docs world_cup_matchiq_app
git commit -m "feat: add explainable prediction engine"
git push origin main
```

