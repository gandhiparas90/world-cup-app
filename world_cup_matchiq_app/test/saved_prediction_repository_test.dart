import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:world_cup_matchiq/data/saved_prediction_repository.dart';
import 'package:world_cup_matchiq/models/saved_prediction.dart';

void main() {
  group('SavedPrediction storage', () {
    test('serializes and restores saved predictions', () {
      final prediction = SavedPrediction(
        matchId: 'arg-fra',
        matchLabel: 'Argentina vs France',
        scoreline: 'Argentina 2-3 France',
        confidence: 'Low',
        createdAt: DateTime(2026, 6, 13, 14),
      );

      final restored = SavedPrediction.fromStorageMap(prediction.toStorageMap());

      expect(restored.matchId, prediction.matchId);
      expect(restored.matchLabel, prediction.matchLabel);
      expect(restored.scoreline, prediction.scoreline);
      expect(restored.confidence, prediction.confidence);
      expect(restored.createdAt, prediction.createdAt);
    });

    test('Hive repository persists saved predictions after reopening the box', () async {
      final tempDir = await Directory.systemTemp.createTemp('matchiq_hive_test_');
      Hive.init(tempDir.path);

      try {
        var box = await Hive.openBox<dynamic>('saved_predictions_test');
        var repository = HiveSavedPredictionRepository(box: box);
        final prediction = SavedPrediction(
          matchId: 'arg-fra',
          matchLabel: 'Argentina vs France',
          scoreline: 'Argentina 2-3 France',
          confidence: 'Low',
          createdAt: DateTime(2026, 6, 13, 14),
        );

        await repository.save(prediction);
        await box.close();

        box = await Hive.openBox<dynamic>('saved_predictions_test');
        repository = HiveSavedPredictionRepository(box: box);
        final saved = await repository.load();

        expect(saved, hasLength(1));
        expect(saved.single.matchId, 'arg-fra');
        expect(saved.single.scoreline, 'Argentina 2-3 France');

        await repository.clear();
        expect(await repository.load(), isEmpty);
        await box.close();
      } finally {
        await Hive.close();
        await tempDir.delete(recursive: true);
      }
    });
  });
}
