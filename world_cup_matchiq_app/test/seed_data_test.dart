import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';

void main() {
  test('seed data includes the full 48-team group catalog', () {
    expect(SeedData.teams, hasLength(48));
    expect(SeedData.groups, hasLength(12));

    for (final group in SeedData.groups) {
      expect(group.teamIds, hasLength(4), reason: group.name);
      for (final teamId in group.teamIds) {
        final team = SeedData.teamById(teamId);
        expect(team.group, group.name);
        expect(team.confederation, isNotEmpty);
      }
    }

    final portugal = SeedData.teamById('por');
    expect(portugal.name, 'Portugal');
    expect(portugal.group, 'Group K');
  });

  test('seed data includes a complete group-stage fixture catalog', () {
    expect(SeedData.matches, hasLength(72));
    expect(SeedData.upcomingMatches(), hasLength(12));

    for (final match in SeedData.matches) {
      final home = SeedData.teamById(match.homeTeamId);
      final away = SeedData.teamById(match.awayTeamId);

      expect(home.name, isNotEmpty);
      expect(away.name, isNotEmpty);
      expect(match.dateLabel, matches(RegExp(r'^[A-Z][a-z]{2} Jun \d{1,2}$')));
      expect(match.kickoffLabel, contains('ET'));
      expect(match.venue, isNotEmpty);
      expect(match.broadcastChannel, anyOf('FOX', 'FS1'));
      expect(match.sourceUrl, startsWith('https://'));
      expect(match.dataUpdatedLabel, contains('Jun 14, 2026'));
    }
  });

  test('seed data includes current Jun 13 and early Jun 14 results', () {
    expect(_scoreline('qat-sui'), '1-1');
    expect(_scoreline('bra-mar'), '1-1');
    expect(_scoreline('hai-sco'), '0-1');
    expect(_scoreline('aus-tur'), '2-0');
  });

  test(
    'watch options cover each match in English and Spanish for US users',
    () {
      expect(SeedData.watchOptions, hasLength(SeedData.matches.length * 2));

      for (final match in SeedData.matches) {
        final options = SeedData.watchOptionsForMatch(match.id);
        expect(options, hasLength(2), reason: match.id);
        expect(options.map((option) => option.countryCode), everyElement('US'));
        expect(
          options.map((option) => option.language),
          containsAll(['English', 'Spanish']),
        );
      }
    },
  );

  test(
    'player scoring inputs are partial but available for covered matches',
    () {
      expect(SeedData.players.length, greaterThanOrEqualTo(18));
      expect(
        SeedData.playersForMatch('bra-mar'),
        hasLength(greaterThanOrEqualTo(4)),
      );
      expect(
        SeedData.playersForMatch('por-cod'),
        hasLength(greaterThanOrEqualTo(2)),
      );
      expect(SeedData.playersForMatch('ger-cur'), isEmpty);
    },
  );
}

String _scoreline(String matchId) {
  final match = SeedData.matchById(matchId);
  expect(match.isCompleted, isTrue, reason: matchId);
  return '${match.homeScore}-${match.awayScore}';
}
