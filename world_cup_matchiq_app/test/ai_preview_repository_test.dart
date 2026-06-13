import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/ai_preview_repository.dart';
import 'package:world_cup_matchiq/models/ai_match_preview.dart';

void main() {
  group('AiMatchPreview storage', () {
    test('serializes and restores AI previews', () {
      final preview = _preview(
        matchId: 'bra-mar',
        headline: 'Brazil need control',
      );

      final restored = AiMatchPreview.fromStorageMap(preview.toStorageMap());

      expect(restored.matchId, preview.matchId);
      expect(restored.headline, preview.headline);
      expect(restored.keyPlayers, preview.keyPlayers);
      expect(restored.source, preview.source);
      expect(restored.createdAt, preview.createdAt);
    });

    test('in-memory repository replaces previews by match id', () async {
      final repository = InMemoryAiPreviewRepository();

      await repository.save(
        _preview(matchId: 'bra-mar', headline: 'First preview'),
      );
      await repository.save(
        _preview(matchId: 'bra-mar', headline: 'Updated preview'),
      );
      await repository.save(
        _preview(matchId: 'por-uzb', headline: 'Portugal preview'),
      );

      final saved = await repository.load();

      expect(saved, hasLength(2));
      expect(
        saved.where((preview) => preview.matchId == 'bra-mar').single.headline,
        'Updated preview',
      );

      await repository.clear();
      expect(await repository.load(), isEmpty);
    });
  });
}

AiMatchPreview _preview({required String matchId, required String headline}) {
  return AiMatchPreview(
    matchId: matchId,
    headline: headline,
    tacticalSummary: 'A tactical summary with enough substance.',
    keyPlayers: const ['Player one', 'Player two'],
    predictionRationale: 'The model rationale is explainable.',
    watchNote: 'FOX 4 PM local time.',
    disclaimer: 'Prototype only.',
    source: 'Test source',
    createdAt: DateTime(2026, 6, 13, 12),
  );
}
