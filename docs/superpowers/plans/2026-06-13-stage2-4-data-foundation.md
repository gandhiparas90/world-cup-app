# Stage 2.4 Data Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a normalized local World Cup data foundation with all 48 teams, all group-stage fixtures, and a searchable Teams surface.

**Architecture:** Keep the app offline-first by compiling a local catalog into Dart. Add model types and repository methods that behave like table reads so future API/SQLite work can replace the backing store without rewriting screens.

**Tech Stack:** Flutter, Provider, Hive for user state, local Dart catalog data, Material 3/FlexColorScheme, Lucide icons.

---

### Task 1: Data Models

**Files:**
- Create: `world_cup_matchiq_app/lib/models/group_info.dart`
- Create: `world_cup_matchiq_app/lib/models/watch_option.dart`
- Create: `world_cup_matchiq_app/lib/models/news_item.dart`
- Create: `world_cup_matchiq_app/lib/models/team_stats.dart`
- Modify: `world_cup_matchiq_app/lib/models/team.dart`
- Modify: `world_cup_matchiq_app/lib/models/world_cup_match.dart`

- [ ] Add group, watch, news, and stats models.
- [ ] Extend team metadata with `confederation`.
- [ ] Extend match metadata with `dateLabel`, `broadcastChannel`, `status`, and optional score fields.
- [ ] Format and analyze.

### Task 2: Full Local Catalog

**Files:**
- Modify: `world_cup_matchiq_app/lib/data/seed_data.dart`
- Modify: `world_cup_matchiq_app/lib/data/match_repository.dart`
- Test: `world_cup_matchiq_app/test/seed_data_test.dart`

- [ ] Replace the nine-team catalog with all 48 teams.
- [ ] Add groups A-L with four teams each.
- [ ] Add all group-stage fixtures from the current public schedule snapshot.
- [ ] Add watch options derived from match broadcast channels.
- [ ] Add source metadata to the catalog.
- [ ] Add integrity tests for team count, groups, matches, and watch references.

### Task 3: Teams Search UI

**Files:**
- Create: `world_cup_matchiq_app/lib/screens/teams_screen.dart`
- Modify: `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart`
- Modify: `world_cup_matchiq_app/lib/state/matchiq_controller.dart`
- Test: `world_cup_matchiq_app/test/widget_test.dart`

- [ ] Add Teams tab to bottom navigation.
- [ ] Add search field filtering by team name, code, group, and confederation.
- [ ] Show every team from the catalog when search is empty.
- [ ] Show next match for each team when one exists.
- [ ] Add widget test proving Portugal and United States can be found.

### Task 4: Existing Screens Use Catalog APIs

**Files:**
- Modify: `world_cup_matchiq_app/lib/screens/home_screen.dart`
- Modify: `world_cup_matchiq_app/lib/screens/matches_screen.dart`
- Modify: `world_cup_matchiq_app/lib/screens/profile_screen.dart`
- Modify: `world_cup_matchiq_app/lib/utils/match_viewing.dart`

- [ ] Keep Home focused on upcoming/featured fixtures instead of all fixtures.
- [ ] Ensure Profile favorite dropdown is backed by all 48 teams.
- [ ] Use watch options where available instead of hardcoded provider text.
- [ ] Keep incomplete player records out of full-catalog claims.

### Task 5: Screenshots And Docs

**Files:**
- Modify: `world_cup_matchiq_app/tool/progress_screenshots.dart`
- Create: `docs/screenshots/stage2_4/*.png`
- Modify: `docs/screenshots/README.md`
- Modify: `docs/data-method.md`
- Modify: `README.md`

- [ ] Generate Stage 2.4 screenshots.
- [ ] Update docs to describe complete local team/match catalog and partial player catalog.
- [ ] Verify screenshots render without icon/font issues.

### Task 6: Verification And Push

**Commands:**

```bash
cd world_cup_matchiq_app
/Users/parasgandhi/Project/temp/flutter/bin/flutter analyze
/Users/parasgandhi/Project/temp/flutter/bin/flutter test
/Users/parasgandhi/Project/temp/flutter/bin/flutter test tool/progress_screenshots.dart --update-goldens --dart-define=SCREENSHOT_STAGE=stage2_4
/Users/parasgandhi/Project/temp/flutter/bin/flutter build web --no-wasm-dry-run
```

- [ ] Commit model/catalog changes.
- [ ] Commit UI/search/docs/screenshots.
- [ ] Push to `origin/main`.
- [ ] Refresh local preview server.
