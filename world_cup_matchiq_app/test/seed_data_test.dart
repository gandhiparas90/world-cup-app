import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';

void main() {
  test('seed data has real current fixtures for Stage 2.1', () {
    expect(SeedData.teams.length, greaterThanOrEqualTo(8));
    expect(SeedData.players.length, greaterThanOrEqualTo(16));
    expect(SeedData.matches.map((match) => match.id), [
      'qat-sui',
      'bra-mar',
      'hai-sco',
      'aus-tur',
    ]);
  });

  test(
    'every seeded match can resolve teams, scorers, and source metadata',
    () {
      for (final match in SeedData.matches) {
        final home = SeedData.teamById(match.homeTeamId);
        final away = SeedData.teamById(match.awayTeamId);
        final scorers = SeedData.playersForMatch(match.id);

        expect(home.name, isNotEmpty);
        expect(home.teamNews, isNotEmpty);
        expect(away.name, isNotEmpty);
        expect(away.teamNews, isNotEmpty);
        expect(scorers.length, greaterThanOrEqualTo(4));
        expect(match.sourceUrl, startsWith('https://'));
        expect(match.dataUpdatedLabel, contains('Jun 13, 2026'));
      }
    },
  );
}
