import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:world_cup_matchiq/data/fixture_result_repository.dart';
import 'package:world_cup_matchiq/models/fixture_result.dart';

void main() {
  group('FixtureResult storage', () {
    test('serializes and restores fixture results', () {
      final result = FixtureResult(
        matchId: 'bra-mar',
        homeScore: 1,
        awayScore: 2,
        sourceLabel: 'Manual local result',
        updatedAt: DateTime(2026, 6, 13, 20, 45),
      );

      final restored = FixtureResult.fromStorageMap(result.toStorageMap());

      expect(restored.matchId, result.matchId);
      expect(restored.homeScore, result.homeScore);
      expect(restored.awayScore, result.awayScore);
      expect(restored.sourceLabel, result.sourceLabel);
      expect(restored.updatedAt, result.updatedAt);
      expect(restored.updatedLabel, 'Updated Jun 13, 2026 8:45 PM');
    });

    test('Hive repository persists and deletes fixture results', () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'matchiq_fixture_result_hive_test_',
      );
      Hive.init(tempDir.path);

      try {
        var box = await Hive.openBox<dynamic>('fixture_results_test');
        var repository = HiveFixtureResultRepository(box: box);
        final result = FixtureResult(
          matchId: 'bra-mar',
          homeScore: 1,
          awayScore: 2,
          sourceLabel: 'Manual local result',
          updatedAt: DateTime(2026, 6, 13, 20, 45),
        );

        await repository.save(result);
        await box.close();

        box = await Hive.openBox<dynamic>('fixture_results_test');
        repository = HiveFixtureResultRepository(box: box);
        final saved = await repository.load();

        expect(saved, hasLength(1));
        expect(saved.single.matchId, 'bra-mar');
        expect(saved.single.homeScore, 1);
        expect(saved.single.awayScore, 2);

        await repository.delete('bra-mar');
        expect(await repository.load(), isEmpty);

        await repository.save(result);
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
