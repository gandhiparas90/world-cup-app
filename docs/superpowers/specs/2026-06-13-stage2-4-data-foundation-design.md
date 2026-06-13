# Stage 2.4 Data Foundation Design

## Goal

Replace the narrow demo fixture/team data with a normalized local World Cup data foundation that can support team search, favorite-team selection, fixtures, watch metadata, and future AI prompts without pretending to be live.

## Scope

Stage 2.4 adds:

- A complete 48-team local catalog for groups A-L.
- A full group-stage fixture catalog based on the current public schedule snapshot.
- Separate model types for group metadata, watch options, team stats, and news items.
- A Teams tab with search/filter behavior.
- Repository integrity checks so UI components cannot reference missing teams.
- Progress screenshots for the new Teams surface and full-catalog profile selector.

Stage 2.4 does not add:

- Live sports API refresh.
- Full 26-player rosters for every team.
- AI-generated previews.
- Real-time standings.

## Data Model

The local catalog is still compiled into the app, but it is split conceptually into table-like lists:

- `groups`: group id, display name, team ids.
- `teams`: id, display name, code, group id, confederation, manager placeholder, ratings, short summaries.
- `matches`: id, group, kickoff label, home team id, away team id, venue, status, optional score, broadcaster, source metadata.
- `watchOptions`: match id, country code, provider, channel, language, stream.
- `teamStats`: team id, attack/defense/form fields for the prototype formula.
- `newsItems`: id, related team id or match id, headline, summary, source metadata.
- `players`: partial player/scorer catalog used only where player records exist.

The Flutter models may remain simple Dart classes for this stage, but the repository interface should act like a database boundary.

## UI Behavior

The Profile favorite-team dropdown must use the complete `teams` catalog. A user can pick any World Cup team, including teams that do not have a match today.

The new Teams tab lets the user search by name, code, or group and inspect basic catalog metadata. This directly addresses the current UX gap where a user cannot search for Portugal or other teams.

The Home screen should continue to prioritize the user's favorite team and near-term fixtures. It should not show all 72 fixtures on landing.

## Data Honesty

Every static schedule/watch/news section must carry source/update labels. Player/team stats that are local estimates must be labeled as prototype inputs, not official statistics.

## Validation

Tests must prove:

- The team catalog has 48 teams.
- Groups A-L each have four teams.
- Every match references valid teams.
- Watch options reference valid matches.
- Profile dropdown and Teams tab use the same complete team catalog.
- Existing prediction/detail flows still work.
