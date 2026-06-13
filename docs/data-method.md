# Local Data Method

World Cup MatchIQ currently uses a local snapshot, not a live sports API.

## Snapshot

- Snapshot date: June 13, 2026
- Primary fixture/broadcast source: SB Nation World Cup schedule
- Source URL: https://www.sbnation.com/soccer/1117513/world-cup-schedule-2026-how-to-watch-every-match-scores-and-more
- Catalog scope: 48 teams, Groups A-L, and 72 group-stage fixtures
- Broadcast scope: US English TV channel plus a Spanish-language Telemundo/Peacock option
- Player scope: partial local scorer records for covered prototype matches only

The local model is deliberately shaped like table data so a later stage can
replace the backing source with SQLite, Firebase, a sports-data API, or an
ingested JSON feed without rewriting screens.

## Local Tables

- `teams`: team identity, group, confederation, style notes, local strength inputs
- `groups`: group ID and four team IDs
- `matches`: fixture ID, teams, date, kickoff, venue, broadcast channel, status, source metadata
- `watchOptions`: match-to-country broadcast rows for US viewing context
- `teamStats`: local attack, defense, form, and goals inputs used by prototype predictions
- `players`: partial scorer inputs for selected matches
- `newsItems`: partial local notes used to explain the current data scope

## Prototype Prediction Inputs

Team outcome and scoreline estimates use:

- Recent goals for
- Opponent recent goals against
- Local attack rating
- Local defense rating
- Recent form points
- Listed home-side display adjustment

The app converts those local inputs into:

- win/draw/loss percentages
- expected goals
- predicted scoreline
- confidence label
- factor explanations shown under "Why this prediction?"

Player scorer estimates use:

- Local goal threat rating
- Recent goal involvement
- Likely starter status
- Availability factor
- Team expected-goals context

These estimates are intentionally labeled as prototype predictions. They are
not betting odds and should not be presented as official probabilities.

## AI Boundary

Stage 2.5 still does not call Gemini. The local engine creates the prediction
and explanation factors. The future Gemini stage should receive this structured
result and generate a readable match preview without inventing new statistics.
