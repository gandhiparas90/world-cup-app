import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/ai_preview_repository.dart';
import 'package:world_cup_matchiq/data/match_repository.dart';
import 'package:world_cup_matchiq/data/saved_prediction_repository.dart';
import 'package:world_cup_matchiq/data/user_profile_repository.dart';
import 'package:world_cup_matchiq/models/ai_match_preview.dart';
import 'package:world_cup_matchiq/models/saved_prediction.dart';
import 'package:world_cup_matchiq/models/user_profile.dart';
import 'package:world_cup_matchiq/services/ai_match_preview_service.dart';
import 'package:world_cup_matchiq/services/prediction_engine.dart';
import 'package:world_cup_matchiq/state/matchiq_controller.dart';

void main() {
  test(
    'controller loads, saves predictions on Home, and clears predictions',
    () async {
      final controller = MatchIqController(
        matchRepository: MatchRepository.seeded(),
        savedPredictionRepository: InMemorySavedPredictionRepository(),
        userProfileRepository: InMemoryUserProfileRepository(),
        aiPreviewRepository: InMemoryAiPreviewRepository(),
        aiMatchPreviewService: const FallbackAiMatchPreviewService(),
      );

      await controller.load();
      expect(controller.isLoading, isFalse);
      expect(controller.teams, hasLength(48));
      expect(controller.groups, hasLength(12));
      expect(controller.matches, hasLength(72));
      expect(controller.upcomingMatches, hasLength(12));
      expect(controller.savedPredictions, isEmpty);
      expect(controller.profile, isNull);
      expect(controller.selectedIndex, 0);

      final prediction = SavedPrediction(
        matchId: 'bra-mar',
        matchLabel: 'Brazil vs Morocco',
        scoreline: 'Brazil 1-1 Morocco',
        confidence: 'Low',
        createdAt: DateTime(2026, 6, 13, 14),
      );

      await controller.savePrediction(prediction);
      expect(controller.savedPredictions, hasLength(1));
      expect(controller.selectedIndex, 0);

      await controller.clearSavedPredictions();
      expect(controller.savedPredictions, isEmpty);
      expect(controller.selectedIndex, 0);
    },
  );

  test('controller saves and resets profile state', () async {
    final controller = MatchIqController(
      matchRepository: MatchRepository.seeded(),
      savedPredictionRepository: InMemorySavedPredictionRepository(),
      userProfileRepository: InMemoryUserProfileRepository(),
      aiPreviewRepository: InMemoryAiPreviewRepository(),
      aiMatchPreviewService: const FallbackAiMatchPreviewService(),
    );

    await controller.load();

    final profile = UserProfile(
      displayName: 'Paras',
      countryCode: 'US',
      timezone: 'America/Chicago',
      favoriteTeamId: 'por',
      createdAt: DateTime(2026, 6, 13, 10),
      updatedAt: DateTime(2026, 6, 13, 10),
    );

    await controller.saveProfile(profile);
    expect(controller.profile?.favoriteTeamId, 'por');
    expect(controller.hasProfile, isTrue);

    await controller.resetProfile();
    expect(controller.profile, isNull);
    expect(controller.hasProfile, isFalse);
  });

  test('controller generates and caches an AI preview', () async {
    final service = _StubAiPreviewService();
    final controller = MatchIqController(
      matchRepository: MatchRepository.seeded(),
      savedPredictionRepository: InMemorySavedPredictionRepository(),
      userProfileRepository: InMemoryUserProfileRepository(),
      aiPreviewRepository: InMemoryAiPreviewRepository(),
      aiMatchPreviewService: service,
    );

    await controller.load();
    expect(controller.aiPreviewForMatch('bra-mar'), isNull);
    expect(controller.isGeneratingAiPreview('bra-mar'), isFalse);

    await controller.generateAiPreview(_request(controller));

    expect(service.callCount, 1);
    expect(controller.aiPreviewForMatch('bra-mar')?.headline, 'AI headline');
    expect(controller.aiPreviews, hasLength(1));
    expect(controller.isGeneratingAiPreview('bra-mar'), isFalse);
  });
}

AiPreviewRequest _request(MatchIqController controller) {
  final match = controller.matchRepository.matchById('bra-mar');
  final home = controller.teamById(match.homeTeamId);
  final away = controller.teamById(match.awayTeamId);
  final players = controller.playersForMatch(match.id);
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

class _StubAiPreviewService implements AiMatchPreviewService {
  var callCount = 0;

  @override
  Future<AiMatchPreview> generate(AiPreviewRequest request) async {
    callCount += 1;
    return AiMatchPreview(
      matchId: request.match.id,
      headline: 'AI headline',
      tacticalSummary: 'AI tactical summary for the selected match.',
      keyPlayers: const ['Player one', 'Player two'],
      predictionRationale: 'AI prediction rationale.',
      watchNote: request.viewingLine,
      disclaimer: 'AI disclaimer.',
      source: 'Stub AI',
      createdAt: DateTime(2026, 6, 13, 17),
    );
  }
}
