# World Cup MatchIQ Design

## Goal

Build a Flutter mobile app prototype for FIFA World Cup match coverage that combines seeded football data, local prediction logic, saved user predictions, and AI-generated match previews. The app must remain runnable at every implementation stage.

## Assignment Fit

World Cup MatchIQ satisfies the course requirements through:

- A clean Flutter UI with at least three screens.
- A consistent state management approach, planned as Provider unless implementation evidence favors Riverpod.
- Local data storage, planned as Hive for favorites, notes, and saved predictions.
- AI-powered match previews that explain scoreline predictions, scorer likelihoods, tactical factors, and confidence.
- A graduate-level paper topic with clear architecture, AI rationale, ethics, development process, and evaluation material.

## Core User Flow

1. User opens a World Cup match dashboard.
2. User browses seeded matches, teams, and featured players.
3. User opens a match detail screen.
4. App shows form indicators, likely key players, local scoreline estimate, and scorer likelihoods.
5. User requests an AI preview.
6. AI explains the prediction in fan-friendly language.
7. User saves their own prediction or saves the generated preview.
8. User reviews saved predictions/history later.

## Screens

### Matches

The Matches screen lists upcoming or sample World Cup fixtures. Each row shows teams, kickoff label, group/stage label, simple form, and a quick predicted score once the local engine exists.

### Match Detail

The Match Detail screen shows team comparison, recent form, expected goals-for/goals-against indicators, top attacking players, predicted scoreline, scorer likelihoods, and AI preview controls.

### Saved Predictions

The Saved Predictions screen shows user-saved match predictions, AI previews, timestamps, and notes. This gives the app persistent behavior and a visible reflection/history workflow.

Optional later screen: Settings for API key/provider mode and demo-data reset. This should be added only if API integration needs user-facing controls.

## AI Scope

AI should generate narrative analysis, not invent unsupported statistics.

AI outputs:

- Match preview.
- Tactical keys.
- Key player impact notes.
- Upset risk explanation.
- Confidence explanation.
- Short fan-facing summary.

The local app computes scoreline and scorer likelihood first. The AI receives structured inputs and explains them. This boundary matters because match win probability is already available from public sports surfaces, and raw LLM percentages would be hard to defend in the paper.

## Prediction Logic

The local prediction engine will use simple transparent inputs:

- Team attack rating.
- Team defense rating.
- Recent form points.
- Average goals for and against.
- Player recent goals.
- Player assists or goal involvement.
- Likely starter flag.

The output should include:

- Home/team A score estimate.
- Away/team B score estimate.
- Win/draw/loss confidence band.
- Top likely scorers with percentage-like likelihood scores.
- Explanation inputs used.

The percentages should be labeled as prototype likelihood estimates, not betting odds or true probabilities.

## Data Strategy

Stage 1 uses seeded local JSON data. This avoids blocking the working app on API keys, quota, network, or undocumented World Cup coverage.

Seeded entities:

- Team.
- Player.
- Match.
- TeamForm.
- Prediction.
- SavedPrediction.

Later API options:

- API-Football if the free account is easy to obtain. Its public pricing page lists a free plan with 100 requests per day and football endpoints including fixtures, players, statistics, predictions, and related data.
- football-data.org only if the project needs simpler fixtures/tables and can tolerate limited deep player data on free access.
- StatsBomb Open Data only for historical analysis or paper support, not live World Cup coverage.

Local fallback remains required even after an API is added.

## AI Provider Strategy

Gemini is the preferred first integration because it appears easier for a free-first class prototype. The app should support mock AI previews first, then real Gemini calls after the local app is working.

Security boundary:

- Do not commit API keys.
- Do not hardcode API keys in Flutter source.
- Prefer a local environment variable or a tiny proxy when using real APIs.
- Keep mock mode available for classroom demos.

OpenAI can remain a secondary option if Gemini setup fails or the user already has an OpenAI API key ready.

## Architecture

Planned Flutter structure:

```text
lib/
  main.dart
  app/
    world_cup_matchiq_app.dart
    theme.dart
  models/
    match.dart
    player.dart
    prediction.dart
    saved_prediction.dart
    team.dart
  data/
    seed_data.dart
    match_repository.dart
    saved_prediction_repository.dart
  state/
    matchiq_controller.dart
  services/
    prediction_engine.dart
    ai_preview_service.dart
    mock_ai_preview_service.dart
    gemini_ai_preview_service.dart
  screens/
    matches_screen.dart
    match_detail_screen.dart
    saved_predictions_screen.dart
  widgets/
    match_card.dart
    prediction_summary.dart
    scorer_likelihood_list.dart
```

Provider will expose a controller that coordinates repositories and services. Storage details stay behind repositories so the UI does not know whether data is seeded, stored in Hive, or refreshed from an API.

## Iterative Delivery Plan

Every stage must end with a runnable app.

### Stage 0: New Repo Baseline

Create a new git repository with the design spec and project README. No app code yet.

Validation:

- Git repo exists.
- Design spec is committed.

### Stage 1: Runnable Flutter App With Three Screens

Create or replace the Flutter app with a World Cup-themed shell, seeded match data, and navigation across Matches, Match Detail, and Saved Predictions.

Validation:

- `flutter analyze` passes.
- `flutter test` passes.
- App runs in Chrome or an available device.

### Stage 2: State And Local Persistence

Add Provider state management and Hive storage for favorites and saved predictions.

Validation:

- User can save a prediction.
- Prediction appears in Saved Predictions.
- Data persists after restart.
- Tests cover controller/repository behavior.

### Stage 3: Local Prediction Engine

Add transparent scoreline and scorer-likelihood estimates from seeded stats.

Validation:

- Each match detail screen shows predicted scoreline.
- Each match detail screen shows top scorer likelihoods.
- Tests cover representative prediction calculations.

### Stage 4: Mock AI Preview

Add AI preview UI and a mock AI service that formats realistic analysis from prediction data.

Validation:

- User can tap Generate Preview.
- App displays preview, tactical keys, upset risk, and confidence explanation.
- Works without API keys.

### Stage 5: Real Gemini Integration

Add real Gemini integration behind the same AI service interface.

Validation:

- Mock mode still works.
- Real mode works only when a key is configured.
- Missing-key and API-error states are clear.
- No secret is committed.

### Stage 6: Optional Sports Data Refresh

Add API-Football refresh if account setup is easy and coverage fits the project.

Validation:

- App can refresh supported match/player data.
- Local fallback is still available.
- Quota/API failures do not break demo mode.

### Stage 7: Paper Support Package

Prepare screenshots, architecture notes, source list, and an AI-use disclosure note. The final written paper must be authored by the student team, not generated as final prose by AI.

Validation:

- Screenshots exist.
- Architecture notes map to app code.
- References list has at least seven credible sources.
- AI-use disclosure is accurate.

## Risks And Corrections

- Risk: Scorer percentages look like betting odds. Correction: label them as prototype likelihood estimates based on visible local stats.
- Risk: AI hallucinates team/player facts. Correction: pass structured data into the prompt and tell the AI not to introduce unsupported facts.
- Risk: API key setup delays progress. Correction: mock and local modes are first-class and remain available.
- Risk: Free sports-data APIs do not expose enough World Cup/player data. Correction: seeded data remains the source of truth for the prototype.
- Risk: Direct API keys in Flutter source leak through GitHub. Correction: no committed keys; use environment/proxy/mock mode.
- Risk: The app becomes too broad. Correction: focus on match preview, scoreline, scorer likelihood, and saved predictions only.

## Paper Argument

The paper can argue that a sports companion app is a useful case study for combining deterministic analytics with generative AI. The deterministic layer provides traceable predictions, while the AI layer turns structured outputs into readable explanations. The ethical analysis should cover uncertainty, overconfidence, hallucination, privacy around saved preferences, and the need to avoid gambling-style claims.

