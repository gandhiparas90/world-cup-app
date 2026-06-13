import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ai_match_preview.dart';
import '../models/player.dart';
import '../models/prediction_result.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';

class AiPreviewRequest {
  const AiPreviewRequest({
    required this.match,
    required this.home,
    required this.away,
    required this.players,
    required this.prediction,
    required this.viewingLine,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final List<Player> players;
  final PredictionResult prediction;
  final String viewingLine;
}

abstract class AiMatchPreviewService {
  Future<AiMatchPreview> generate(AiPreviewRequest request);
}

class FallbackAiMatchPreviewService implements AiMatchPreviewService {
  const FallbackAiMatchPreviewService({
    this.source = 'Offline AI draft',
    this.clock,
  });

  final String source;
  final DateTime Function()? clock;

  @override
  Future<AiMatchPreview> generate(AiPreviewRequest request) async {
    return buildFallbackPreview(request, source: source, clock: clock);
  }
}

typedef GeminiHttpPost =
    Future<http.Response> Function(
      Uri url, {
      Map<String, String>? headers,
      Object? body,
    });

class GeminiAiMatchPreviewService implements AiMatchPreviewService {
  GeminiAiMatchPreviewService({
    required this.apiKey,
    this.model = 'gemini-3.5-flash',
    this.proxyUrl = '',
    GeminiHttpPost? post,
    this.fallback = const FallbackAiMatchPreviewService(),
  }) : _post = post ?? http.post;

  final String apiKey;
  final String model;
  final String proxyUrl;
  final AiMatchPreviewService fallback;
  final GeminiHttpPost _post;

  @override
  Future<AiMatchPreview> generate(AiPreviewRequest request) async {
    if (proxyUrl.trim().isEmpty && apiKey.trim().isEmpty) {
      return buildFallbackPreview(
        request,
        source: 'Offline AI draft - missing Gemini key',
      );
    }

    try {
      final target = _requestUri();
      final response = await _post(
        target,
        headers: _headersFor(target),
        body: jsonEncode(buildGeminiPayload(request)),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return buildFallbackPreview(
          request,
          source: 'Offline AI draft - Gemini HTTP ${response.statusCode}',
        );
      }

      return previewFromGeminiResponse(
        response.body,
        request: request,
        source: proxyUrl.trim().isEmpty
            ? 'Gemini $model'
            : 'Gemini $model via local proxy',
      );
    } catch (error) {
      final reason = _fallbackReason(error);
      // Kept intentionally key-free. Browser console should explain fallback.
      // ignore: avoid_print
      print('Gemini preview failed: $reason');
      return buildFallbackPreview(
        request,
        source: 'Offline AI draft - $reason',
      );
    }
  }

  Uri _requestUri() {
    if (proxyUrl.trim().isEmpty) {
      return Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
      );
    }

    final uri = Uri.parse(proxyUrl);
    return uri.replace(
      queryParameters: {...uri.queryParameters, 'model': model},
    );
  }

  Map<String, String> _headersFor(Uri target) {
    final headers = {'Content-Type': 'application/json'};
    if (target.host == 'generativelanguage.googleapis.com') {
      headers['x-goog-api-key'] = apiKey;
    }
    return headers;
  }
}

Map<String, Object?> buildGeminiPayload(AiPreviewRequest request) {
  return {
    'system_instruction': {
      'parts': [
        {
          'text':
              'You write concise football match previews for MatchIQ. '
              'Use only the supplied local app data. Do not claim live news, official odds, or certainty. '
              'Return only valid JSON with these string fields: headline, tactical_summary, '
              'prediction_rationale, watch_note, disclaimer; and key_players as a list of 2 to 4 strings.',
        },
      ],
    },
    'contents': [
      {
        'parts': [
          {'text': _prompt(request)},
        ],
      },
    ],
    'generationConfig': {
      'temperature': 0.35,
      'maxOutputTokens': 700,
      'responseMimeType': 'application/json',
    },
  };
}

AiMatchPreview previewFromGeminiResponse(
  String responseBody, {
  required AiPreviewRequest request,
  required String source,
}) {
  final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
  final candidates = decoded['candidates'] as List<dynamic>?;
  final content = candidates?.isNotEmpty == true
      ? candidates!.first['content'] as Map<String, dynamic>?
      : null;
  final parts = content?['parts'] as List<dynamic>?;
  final text = parts?.isNotEmpty == true
      ? parts!.first['text'] as String?
      : null;

  if (text == null || text.trim().isEmpty) {
    throw const FormatException('Gemini response did not contain text');
  }

  final previewJson = jsonDecode(_stripJsonFence(text)) as Map<String, dynamic>;
  final keyPlayers = (previewJson['key_players'] as List<dynamic>?)
      ?.map((value) => value.toString().trim())
      .where((value) => value.isNotEmpty)
      .take(4)
      .toList();

  final preview = AiMatchPreview(
    matchId: request.match.id,
    headline: _requiredField(previewJson, 'headline'),
    tacticalSummary: _requiredField(previewJson, 'tactical_summary'),
    keyPlayers: keyPlayers == null || keyPlayers.isEmpty
        ? _fallbackKeyPlayers(request)
        : keyPlayers,
    predictionRationale: _requiredField(previewJson, 'prediction_rationale'),
    watchNote: _requiredField(previewJson, 'watch_note'),
    disclaimer: _requiredField(previewJson, 'disclaimer'),
    source: source,
    createdAt: DateTime.now(),
  );

  if (preview.headline.length < 6 || preview.tacticalSummary.length < 20) {
    throw const FormatException('Gemini preview was too sparse');
  }

  return preview;
}

AiMatchPreview buildFallbackPreview(
  AiPreviewRequest request, {
  required String source,
  DateTime Function()? clock,
}) {
  final favoriteScorers = request.prediction.scorers.take(3).toList();
  final leader =
      request.prediction.homeWinPercent >= request.prediction.awayWinPercent
      ? request.home
      : request.away;
  final opponent = leader.id == request.home.id ? request.away : request.home;
  final drawRisk = request.prediction.drawPercent >= 27
      ? 'The draw number is high enough that game state and finishing variance matter.'
      : 'The draw path is present, but the model sees a clearer winning lane.';

  return AiMatchPreview(
    matchId: request.match.id,
    headline: '${leader.name} carry the stronger local signal',
    tacticalSummary:
        '${request.home.name} bring ${request.home.style.toLowerCase()}, while ${request.away.name} lean on ${request.away.style.toLowerCase()}. '
        'The local ratings point to ${leader.name} having the cleaner route if they can turn territory into shots against ${opponent.name}.',
    keyPlayers: favoriteScorers.isEmpty
        ? _fallbackKeyPlayers(request)
        : favoriteScorers
              .map(
                (scorer) =>
                    '${scorer.playerName}: ${scorer.percent}% scorer signal from local player inputs.',
              )
              .toList(),
    predictionRationale:
        'MatchIQ projects ${request.prediction.scoreline} with ${request.prediction.homeWinPercent}% ${request.home.code} win, '
        '${request.prediction.drawPercent}% draw, and ${request.prediction.awayWinPercent}% ${request.away.code} win. $drawRisk',
    watchNote: request.viewingLine.isEmpty
        ? '${request.match.broadcastChannel} coverage is listed in the local fixture data.'
        : request.viewingLine,
    disclaimer:
        'AI-generated from local match data. Not betting advice, official probabilities, or live team news.',
    source: source,
    createdAt: clock?.call() ?? DateTime.now(),
  );
}

String _prompt(AiPreviewRequest request) {
  final players = request.players
      .take(8)
      .map(
        (player) =>
            '- ${player.name}, ${player.position}, team=${player.teamId}, news=${player.news}, threat=${player.goalThreatRating}, involvement=${player.goalInvolvement}, starter=${player.likelyStarter}',
      )
      .join('\n');
  final factors = request.prediction.factors
      .map(
        (factor) => '- ${factor.label}: ${factor.value}. ${factor.explanation}',
      )
      .join('\n');

  return '''
Match: ${request.home.name} (${request.home.code}) vs ${request.away.name} (${request.away.code})
Stage: ${request.match.stage}
Kickoff: ${request.match.dateLabel} ${request.match.kickoffLabel}
Venue: ${request.match.venue}
Viewing context: ${request.viewingLine}
Broadcast channel: ${request.match.broadcastChannel}
Fixture storyline: ${request.match.storyline}
Home style: ${request.home.style}
Home form: ${request.home.formSummary}
Home team news: ${request.home.teamNews}
Away style: ${request.away.style}
Away form: ${request.away.formSummary}
Away team news: ${request.away.teamNews}
Prototype scoreline: ${request.prediction.scoreline}
Expected goals: ${request.home.code} ${request.prediction.homeExpectedGoals.toStringAsFixed(1)} - ${request.away.code} ${request.prediction.awayExpectedGoals.toStringAsFixed(1)}
Outcome probabilities: ${request.home.name} win ${request.prediction.homeWinPercent}%, draw ${request.prediction.drawPercent}%, ${request.away.name} win ${request.prediction.awayWinPercent}%
Confidence: ${request.prediction.confidence}
Factors:
$factors
Players:
$players
''';
}

String _stripJsonFence(String value) {
  final trimmed = value.trim();
  if (!trimmed.startsWith('```')) {
    return trimmed;
  }
  return trimmed
      .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
      .replaceFirst(RegExp(r'\s*```$'), '')
      .trim();
}

String _requiredField(Map<String, dynamic> json, String key) {
  final value = json[key]?.toString().trim();
  if (value == null || value.isEmpty) {
    throw FormatException('Missing Gemini preview field: $key');
  }
  return value;
}

List<String> _fallbackKeyPlayers(AiPreviewRequest request) {
  return [
    '${request.home.name}: ${request.home.formSummary}',
    '${request.away.name}: ${request.away.formSummary}',
  ];
}

String _fallbackReason(Object error) {
  if (error is http.ClientException) {
    return 'browser/network request failed';
  }
  if (error is FormatException) {
    return 'Gemini response parse failed';
  }

  final message = error.toString();
  if (message.contains('XMLHttpRequest') ||
      message.contains('Failed to fetch')) {
    return 'browser/network request failed';
  }
  if (message.contains('FormatException')) {
    return 'Gemini response parse failed';
  }
  return 'Gemini request failed';
}
