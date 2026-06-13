# UX Foundation And Personalized Home Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the abrupt fixture-list landing screen with a modern minimal Flutter UI and a local personalized World Cup home experience.

**Architecture:** Keep match data local and profile data local-only in Hive. The app shell moves from two tabs to Home, Fixtures, and Profile; saved predictions remain available through profile/home context rather than as the landing experience.

**Tech Stack:** Flutter, Provider, Hive, FlexColorScheme, Google Fonts, Lucide icons, Flutter Animate.

---

### Task 1: UI Dependency And Theme Foundation

**Files:**
- Modify: `world_cup_matchiq_app/pubspec.yaml`
- Modify: `world_cup_matchiq_app/lib/app/theme.dart`

- [ ] Add `flex_color_scheme`, `google_fonts`, `lucide_icons_flutter`, and `flutter_animate`.
- [ ] Replace the hand-written theme with a FlexColorScheme Material 3 theme.
- [ ] Use a restrained typeface and 8px component radius.
- [ ] Run `flutter analyze` to catch package/API mistakes.

### Task 2: Local Profile Model And Repository

**Files:**
- Create: `world_cup_matchiq_app/lib/models/user_profile.dart`
- Create: `world_cup_matchiq_app/lib/data/user_profile_repository.dart`
- Modify: `world_cup_matchiq_app/lib/main.dart`
- Modify: `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart`
- Modify: `world_cup_matchiq_app/lib/state/matchiq_controller.dart`
- Test: `world_cup_matchiq_app/test/user_profile_repository_test.dart`
- Test: `world_cup_matchiq_app/test/matchiq_controller_test.dart`

- [ ] Add local-only profile fields: display name, country code, timezone, favorite team id.
- [ ] Add Hive-backed profile repository with in-memory test implementation.
- [ ] Load profile alongside saved predictions.
- [ ] Add controller methods to save/reset profile.
- [ ] Test profile save/load and controller profile state.

### Task 3: Home, Fixtures, Profile Navigation

**Files:**
- Create: `world_cup_matchiq_app/lib/screens/home_screen.dart`
- Create: `world_cup_matchiq_app/lib/screens/profile_screen.dart`
- Modify: `world_cup_matchiq_app/lib/app/world_cup_matchiq_app.dart`
- Modify: `world_cup_matchiq_app/lib/screens/matches_screen.dart`
- Test: `world_cup_matchiq_app/test/widget_test.dart`

- [ ] Add Home tab as the default first screen.
- [ ] Show setup card when no profile exists.
- [ ] Let the user pick country/timezone/favorite team with simple controls.
- [ ] After setup, show "Your World Cup", favorite team, today matches, and where-to-watch teaser.
- [ ] Move the fixture list to the Fixtures tab.
- [ ] Add Profile tab to edit/reset local profile.
- [ ] Update widget tests for the new landing flow.

### Task 4: Screenshots, Verification, Push

**Files:**
- Modify: `world_cup_matchiq_app/tool/progress_screenshots.dart`
- Modify: `docs/screenshots/README.md`
- Create: `docs/screenshots/stage2_3/*.png`

- [ ] Generate Stage 2.3 screenshots.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
- [ ] Run `flutter build web --no-wasm-dry-run`.
- [ ] Commit and push the stage.
