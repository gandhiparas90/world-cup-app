import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/match_repository.dart';
import 'package:world_cup_matchiq/data/saved_prediction_repository.dart';
import 'package:world_cup_matchiq/models/saved_prediction.dart';
import 'package:world_cup_matchiq/state/matchiq_controller.dart';

void main() {
  test('controller loads, saves, selects Saved tab, and clears predictions', () async {
    final controller = MatchIqController(
      matchRepository: MatchRepository.seeded(),
      savedPredictionRepository: InMemorySavedPredictionRepository(),
    );

    await controller.load();
    expect(controller.isLoading, isFalse);
    expect(controller.savedPredictions, isEmpty);
    expect(controller.selectedIndex, 0);

    final prediction = SavedPrediction(
      matchId: 'arg-fra',
      matchLabel: 'Argentina vs France',
      scoreline: 'Argentina 2-3 France',
      confidence: 'Low',
      createdAt: DateTime(2026, 6, 13, 14),
    );

    await controller.savePrediction(prediction);
    expect(controller.savedPredictions, hasLength(1));
    expect(controller.selectedIndex, 1);

    await controller.clearSavedPredictions();
    expect(controller.savedPredictions, isEmpty);
    expect(controller.selectedIndex, 1);
  });
}
