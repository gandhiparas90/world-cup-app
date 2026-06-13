# Stage 2.6 AI Match Preview Design

## Goal

Stage 2.6 adds a visible AI-assisted match preview to the match detail screen. The feature uses the app's existing local match, team, player, and prediction data as the source context, then asks Gemini to produce a concise preview when a local API key is supplied.

## Scope

- Add a match preview domain model with tactical summary, key players, model rationale, and disclaimer fields.
- Add a repository for preview caching so a generated preview can be reused without another API call.
- Add an AI preview service that can call Gemini through REST using a local `GEMINI_API_KEY` dart define.
- Add an offline deterministic fallback preview for missing keys, failed calls, or tests.
- Add match-detail UI controls for generating, refreshing, and displaying the preview.
- Add tests for prompt construction, fallback behavior, controller state, cache behavior, and widget visibility.

## Architecture

The app keeps Provider as its state-management approach. `MatchIqController` owns preview loading/generation state and delegates storage to `AiPreviewRepository` and content generation to `AiMatchPreviewService`.

The Gemini client is isolated behind an interface so the UI and controller do not depend on HTTP details. The direct Flutter web call is acceptable for the course prototype, but it is not production secret handling because browser clients expose runtime credentials. The repository remains safe for a public GitHub repo because the key is not committed and is supplied only from local build/run configuration.

## Data Flow

1. Match detail builds the deterministic prediction from local data.
2. It asks the controller for an existing preview by match id.
3. If the user taps generate, the controller builds an `AiPreviewRequest`.
4. The preview service either calls Gemini or produces an offline fallback.
5. The controller saves the returned preview to Hive and notifies the UI.
6. The match detail screen displays the preview, source label, created time, and safety disclaimer.

## Error Handling

Network failures, missing keys, malformed responses, and blocked API responses fall back to an offline preview. The UI never breaks if AI generation fails. The preview source explicitly shows whether the content came from Gemini or the offline fallback.

## Testing

Tests cover:

- Gemini request JSON structure and response parsing using a fake HTTP sender.
- Fallback preview content when no API key is configured.
- Hive/in-memory preview repository behavior.
- Controller generation, cache lookup, and loading state.
- Match detail widget showing the AI preview action and generated content.

## Known Limitation

Direct Gemini calls from Flutter web are not production-safe secret handling. A production app should use a backend proxy or serverless function that keeps the API key server-side. For this course prototype, the key stays out of Git and the feature remains demonstrable locally.
