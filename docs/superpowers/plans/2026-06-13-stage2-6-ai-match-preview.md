# Stage 2.6 AI Match Preview Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a visible AI-assisted match preview that can call Gemini with a local key and falls back safely when the key or network is unavailable.

**Architecture:** Keep Provider and repository boundaries. Add preview models, cache repository, service interface, Gemini REST client, deterministic fallback, and match-detail UI connected through `MatchIqController`.

**Tech Stack:** Flutter, Provider, Hive, Dart `http`, Gemini REST `generateContent`, local `--dart-define=GEMINI_API_KEY=...`.

---

### Task 1: Models And Preview Cache

**Files:**
- Create: `world_cup_matchiq_app/lib/models/ai_match_preview.dart`
- Create: `world_cup_matchiq_app/lib/data/ai_preview_repository.dart`
- Test: `world_cup_matchiq_app/test/ai_preview_repository_test.dart`

- [ ] Add `AiMatchPreview` with `matchId`, `headline`, `tacticalSummary`, `keyPlayers`, `predictionRationale`, `watchNote`, `disclaimer`, `source`, and `createdAt`.
- [ ] Add `AiPreviewRepository` plus in-memory and Hive implementations.
- [ ] Test save, load, replacement by match id, and clear.

### Task 2: AI Preview Service

**Files:**
- Create: `world_cup_matchiq_app/lib/services/ai_match_preview_service.dart`
- Modify: `world_cup_matchiq_app/pubspec.yaml`
- Test: `world_cup_matchiq_app/test/ai_match_preview_service_test.dart`

- [ ] Add `http` dependency.
- [ ] Add `AiPreviewRequest` with match, home team, away team, players, prediction, and viewing line.
- [ ] Add `AiMatchPreviewService` interface.
- [ ] Add `FallbackAiMatchPreviewService`.
- [ ] Add `GeminiAiMatchPreviewService` with injectable HTTP sender.
- [ ] Test fallback output, Gemini request body, success parsing, and malformed response fallback.

### Task 3: Controller Integration

**Files:**
- Modify: `world_cup_matchiq_app/lib/state/matchiq_controller.dart`
- Modify: `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart`
- Modify: `world_cup_matchiq_app/lib/main.dart`
- Test: `world_cup_matchiq_app/test/matchiq_controller_test.dart`

- [ ] Inject `AiPreviewRepository` and `AiMatchPreviewService`.
- [ ] Load cached previews during controller load.
- [ ] Track per-match generation state.
- [ ] Add `generateAiPreview`.
- [ ] Open Hive box for previews in `main.dart`.
- [ ] Test generate, cache, and loading state.

### Task 4: Match Detail UI

**Files:**
- Modify: `world_cup_matchiq_app/lib/screens/match_detail_screen.dart`
- Modify: `world_cup_matchiq_app/lib/screens/matches_screen.dart`
- Test: `world_cup_matchiq_app/test/widget_test.dart`

- [ ] Pass preview state and generate callback from fixtures to detail.
- [ ] Add an `AI match preview` card below probability summary.
- [ ] Show generate button, loading state, cached preview, source, and disclaimer.
- [ ] Test the AI preview button and rendered generated preview.

### Task 5: Docs, Screenshots, Verification

**Files:**
- Modify: `world_cup_matchiq_app/.env.example`
- Modify: `world_cup_matchiq_app/tool/progress_screenshots.dart`
- Create: `docs/screenshots/stage2_6/*.png`
- Modify: `docs/screenshots/README.md`
- Modify: `docs/data-method.md`

- [ ] Document `GEMINI_API_KEY` local usage.
- [ ] Add stage2_6 screenshots.
- [ ] Run `dart format`.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run screenshot capture.
- [ ] Run `flutter build web --no-wasm-dry-run`.
- [ ] Commit and push.
