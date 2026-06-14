# Local Data Method

World Cup MatchIQ currently uses a local snapshot, not a live sports API.

## Snapshot

- Snapshot date: June 14, 2026
- Primary fixture/broadcast source: SB Nation World Cup schedule
- Result refresh source: Guardian match reports/live blogs for completed Jun 13 and early Jun 14 fixtures
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
- `matches`: fixture ID, teams, date, kickoff, venue, broadcast channel, status, score, source metadata
- `watchOptions`: match-to-country broadcast rows for US viewing context
- `teamStats`: local attack, defense, form, and goals inputs used by prototype predictions
- `players`: partial scorer inputs for selected matches
- `newsItems`: partial local notes used to explain the current data scope
- `fixtureResults`: local Hive overrides for final scores entered on the device

`fixtureResults` is the first step toward live score updates. The seeded
schedule remains the baseline, and the controller overlays any local result
override onto the matching fixture. A later sports-data API or backend search
job can write the same result shape without changing the match detail UI.

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

Stage 2.6 adds an AI-assisted match preview. The Gemini prompt receives only
the local match, team, player, viewing, and prototype prediction fields. It is
instructed not to invent live news, official odds, or certainty. If no local
`GEMINI_API_KEY` dart define is supplied, or if the API call fails, the app
falls back to a deterministic offline preview built from the same local data.

The API key remains outside Git. For local Chrome runs, start
`world_cup_matchiq_app/tool/gemini_proxy.dart` and build or run Flutter with
`GEMINI_PROXY_URL=http://127.0.0.1:8787/generateContent`. The proxy reads
`.env.local`, calls Gemini server-side, and returns the Gemini response to the
app. This avoids shipping the key in the browser bundle.
