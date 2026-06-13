import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';

void main() {
  test('seed data has enough teams, players, and matches for Stage 1', () {
    expect(SeedData.teams.length, greaterThanOrEqualTo(6));
    expect(SeedData.players.length, greaterThanOrEqualTo(12));
    expect(SeedData.matches.length, greaterThanOrEqualTo(3));
  });

  test('every seeded match can resolve both teams and likely scorers', () {
    for (final match in SeedData.matches) {
      final home = SeedData.teamById(match.homeTeamId);
      final away = SeedData.teamById(match.awayTeamId);
      final scorers = SeedData.playersForMatch(match.id);

      expect(home.name, isNotEmpty);
      expect(away.name, isNotEmpty);
      expect(scorers.length, greaterThanOrEqualTo(4));
    }
  });
}
