# Stage 2.5 Explainable Predictions Design

## Goal

Replace the thin scoreline-only prototype with a local explainable prediction
engine that produces defensible match probabilities, scoreline estimates,
scorer likelihoods, and factor explanations without requiring an AI API.

## Scope

Stage 2.5 adds:

- A `PredictionResult` model with scoreline, confidence, expected goals,
  win/draw/loss probabilities, factor explanations, and scorer probabilities.
- A deterministic `PredictionEngine` that uses existing local team and player
  data.
- A Match Detail "Why this prediction?" section.
- Tests proving probabilities are bounded and scorer likelihoods respect player
  availability.
- Stage 2.5 screenshots and docs.

Stage 2.5 does not add:

- Gemini API calls.
- Live sports data.
- Betting odds.
- Official model calibration.

## Architecture

Prediction logic moves out of widgets into `lib/services/prediction_engine.dart`.
Widgets render a `PredictionResult` and do not calculate prediction values.
This creates a clean input for Stage 3, where Gemini will summarize the local
prediction rather than inventing match outcomes.

## Prediction Method

The engine calculates expected goals from:

- team average goals for
- opponent average goals against
- attack rating versus opponent defense rating
- form points gap
- small home-side display advantage for the listed home team

It converts strength difference into win/draw/loss percentages with a bounded,
transparent heuristic. Draw probability is highest when expected goals and
ratings are close. Home and away win probabilities share the remaining
probability based on the strength gap.

Scorer likelihood uses the existing player fields:

- goal threat rating
- recent goals plus assists
- likely starter flag
- availability factor
- team expected-goals context

All labels must say prototype estimate and not betting odds.

## UI Behavior

Match Detail should show:

- scoreline estimate
- expected goals
- win/draw/loss percentage row
- confidence label
- factor breakdown under "Why this prediction?"
- scorer likelihoods when player records exist
- a clear empty state when player records are missing

Saved predictions continue storing scoreline and confidence, but now the values
come from `PredictionResult`.

## Risks

The model is explainable but not calibrated against historical results. That is
acceptable for the course prototype only if the UI and paper disclose it as a
local heuristic prediction layer. The next meaningful quality improvement would
be importing real team/player stat feeds and calibrating weights.

