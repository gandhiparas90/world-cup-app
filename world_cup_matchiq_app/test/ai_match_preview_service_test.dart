import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:world_cup_matchiq/data/match_repository.dart';
import 'package:world_cup_matchiq/services/ai_match_preview_service.dart';
import 'package:world_cup_matchiq/services/prediction_engine.dart';

void main() {
  group('AI match preview service', () {
    test(
      'fallback service builds a local preview without an API key',
      () async {
        final request = _request();
        final service = FallbackAiMatchPreviewService(
          clock: () => DateTime(2026, 6, 13, 15),
        );

        final preview = await service.generate(request);

        expect(preview.matchId, request.match.id);
        expect(preview.source, 'Offline AI draft');
        expect(preview.headline, contains('local signal'));
        expect(preview.predictionRationale, contains('%'));
        expect(
          preview.disclaimer,
          contains('AI-generated from local match data'),
        );
        expect(preview.createdAt, DateTime(2026, 6, 13, 15));
      },
    );

    test('Gemini payload includes local match and prediction data', () {
      final request = _request();

      final payload = buildGeminiPayload(request);
      final contents = payload['contents']! as List<Object?>;
      final content = contents.single! as Map<String, Object?>;
      final parts = content['parts']! as List<Object?>;
      final prompt = (parts.single! as Map<String, Object?>)['text'] as String;

      expect(prompt, contains('Brazil'));
      expect(prompt, contains('Morocco'));
      expect(prompt, contains('Outcome probabilities'));
      expect(prompt, contains('Prototype scoreline'));
      expect(jsonEncode(payload), contains('responseMimeType'));
      expect(jsonEncode(payload), contains('responseSchema'));
      expect(jsonEncode(payload), contains('thinkingLevel'));
      expect(jsonEncode(payload), contains('minimal'));
      expect(jsonEncode(payload), contains('tactical_summary'));
    });

    test('Gemini service parses structured JSON response', () async {
      final request = _request();
      late Uri capturedUrl;
      late Map<String, String>? capturedHeaders;
      late Object? capturedBody;
      final service = GeminiAiMatchPreviewService(
        apiKey: 'test-key',
        model: 'gemini-test',
        post: (url, {headers, body}) async {
          capturedUrl = url;
          capturedHeaders = headers;
          capturedBody = body;
          return http.Response(
            jsonEncode({
              'candidates': [
                {
                  'content': {
                    'parts': [
                      {
                        'text': jsonEncode({
                          'headline': 'Brazil face a transition test',
                          'tactical_summary':
                              'Brazil must manage Morocco transition pressure while protecting central spaces.',
                          'key_players': [
                            'Vinicius Junior: carries the main shot threat.',
                            'Achraf Hakimi: drives Morocco counters.',
                          ],
                          'prediction_rationale':
                              'The scoreline stays close because the draw probability is meaningful.',
                          'watch_note':
                              'FOX coverage is listed in the local fixture data.',
                          'disclaimer':
                              'AI-generated from local match data, not official odds.',
                        }),
                      },
                    ],
                  },
                },
              ],
            }),
            200,
          );
        },
      );

      final preview = await service.generate(request);

      expect(capturedUrl.toString(), contains('gemini-test:generateContent'));
      expect(capturedHeaders?['x-goog-api-key'], 'test-key');
      expect(capturedBody.toString(), contains('Brazil'));
      expect(preview.source, 'Gemini gemini-test');
      expect(preview.headline, 'Brazil face a transition test');
      expect(preview.keyPlayers, hasLength(2));
    });

    test('Gemini parser extracts JSON from wrapped text parts', () {
      final request = _request();
      final preview = previewFromGeminiResponse(
        jsonEncode({
          'candidates': [
            {
              'finishReason': 'STOP',
              'content': {
                'parts': [
                  {'text': 'Here is the JSON requested:\n'},
                  {
                    'text': jsonEncode({
                      'headline': 'Morocco carry transition threat',
                      'tactical_summary':
                          'Morocco can pressure Brazil by defending compactly and breaking quickly into wide channels.',
                      'key_players': [
                        'Achraf Hakimi: counter-attacking outlet.',
                        'Vinicius Junior: Brazil shot creator.',
                      ],
                      'prediction_rationale':
                          'The local model gives Morocco the strongest win signal while preserving a live draw path.',
                      'watch_note': 'FOX at 4 PM local time.',
                      'disclaimer':
                          'AI-generated from local match data, not official odds.',
                    }),
                  },
                ],
              },
            },
          ],
        }),
        request: request,
        source: 'Gemini test',
      );

      expect(preview.headline, 'Morocco carry transition threat');
      expect(preview.source, 'Gemini test');
    });

    test(
      'Gemini service can route through a local proxy without key header',
      () async {
        final request = _request();
        late Uri capturedUrl;
        late Map<String, String>? capturedHeaders;
        final service = GeminiAiMatchPreviewService(
          apiKey: 'test-key',
          model: 'gemini-test',
          proxyUrl: 'http://127.0.0.1:8787/generateContent',
          post: (url, {headers, body}) async {
            capturedUrl = url;
            capturedHeaders = headers;
            return http.Response(
              jsonEncode({
                'candidates': [
                  {
                    'content': {
                      'parts': [
                        {
                          'text': jsonEncode({
                            'headline': 'Proxy generated preview',
                            'tactical_summary':
                                'Proxy route returns a structured tactical summary from Gemini.',
                            'key_players': ['Player one', 'Player two'],
                            'prediction_rationale':
                                'The proxy preserves the same prediction context.',
                            'watch_note': 'FOX local coverage.',
                            'disclaimer': 'AI-generated from local match data.',
                          }),
                        },
                      ],
                    },
                  },
                ],
              }),
              200,
            );
          },
        );

        final preview = await service.generate(request);

        expect(
          capturedUrl.toString(),
          'http://127.0.0.1:8787/generateContent?model=gemini-test',
        );
        expect(capturedHeaders?['x-goog-api-key'], isNull);
        expect(preview.source, 'Gemini gemini-test via local proxy');
        expect(preview.headline, 'Proxy generated preview');
      },
    );

    test('Gemini service falls back when response is malformed', () async {
      final request = _request();
      final service = GeminiAiMatchPreviewService(
        apiKey: 'test-key',
        post: (url, {headers, body}) async {
          return http.Response('{"candidates":[]}', 200);
        },
        fallback: FallbackAiMatchPreviewService(
          clock: () => DateTime(2026, 6, 13, 16),
        ),
      );

      final preview = await service.generate(request);

      expect(preview.source, 'Offline AI draft - Gemini response parse failed');
    });

    test('Gemini service reports HTTP fallback reason', () async {
      final request = _request();
      final service = GeminiAiMatchPreviewService(
        apiKey: 'test-key',
        post: (url, {headers, body}) async {
          return http.Response('forbidden', 403);
        },
      );

      final preview = await service.generate(request);

      expect(preview.source, 'Offline AI draft - Gemini HTTP 403');
    });

    test('Gemini service reports missing key fallback reason', () async {
      final request = _request();
      final service = GeminiAiMatchPreviewService(apiKey: '');

      final preview = await service.generate(request);

      expect(preview.source, 'Offline AI draft - missing Gemini key');
    });

    test('Gemini service reports browser request failures readably', () async {
      final request = _request();
      final service = GeminiAiMatchPreviewService(
        apiKey: 'test-key',
        post: (url, {headers, body}) async {
          throw http.ClientException('XMLHttpRequest error');
        },
      );

      final preview = await service.generate(request);

      expect(
        preview.source,
        'Offline AI draft - browser/network request failed',
      );
    });
  });
}

AiPreviewRequest _request() {
  const repository = MatchRepository.seeded();
  final match = repository.matchById('bra-mar');
  final home = repository.teamById(match.homeTeamId);
  final away = repository.teamById(match.awayTeamId);
  final players = repository.playersForMatch(match.id);
  final prediction = const PredictionEngine().predict(
    match: match,
    home: home,
    away: away,
    players: players,
  );

  return AiPreviewRequest(
    match: match,
    home: home,
    away: away,
    players: players,
    prediction: prediction,
    viewingLine: 'FOX at 4 PM local time',
  );
}
