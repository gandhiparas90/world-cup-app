# Local Data Method

World Cup MatchIQ currently uses a local snapshot, not a live sports API.

## Snapshot

- Snapshot date: June 13, 2026
- Primary fixture/news source: Guardian World Cup guide
- Source URL: https://www.theguardian.com/football/2026/jun/13/how-to-watch-world-cup-brazil-morocco-haiti-scotland

## Prototype Prediction Inputs

Team scoreline estimates use:

- Recent goals for
- Opponent recent goals against
- Local attack rating
- Local defense rating
- Recent form points

Player scorer estimates use:

- Local goal threat rating
- Recent goal involvement
- Likely starter status
- Availability factor

These estimates are intentionally labeled as prototype predictions. They are
not betting odds and should not be presented as official probabilities.
