import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/match_repository.dart';
import 'package:world_cup_matchiq/data/saved_prediction_repository.dart';
import 'package:world_cup_matchiq/data/user_profile_repository.dart';
import 'package:world_cup_matchiq/models/saved_prediction.dart';
import 'package:world_cup_matchiq/models/user_profile.dart';
import 'package:world_cup_matchiq/state/matchiq_controller.dart';

void main() {
  test(
    'controller loads, saves predictions on Home, and clears predictions',
    () async {
      final controller = MatchIqController(
        matchRepository: MatchRepository.seeded(),
        savedPredictionRepository: InMemorySavedPredictionRepository(),
        userProfileRepository: InMemoryUserProfileRepository(),
      );

      await controller.load();
      expect(controller.isLoading, isFalse);
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
}
