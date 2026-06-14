import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';
import 'package:world_cup_matchiq/utils/match_timing.dart';

void main() {
  test('parses fixture kickoff labels as UTC timestamps', () {
    expect(
      matchKickoffUtc(SeedData.matchById('ger-cur')),
      DateTime.utc(2026, 6, 14, 17),
    );
    expect(
      matchKickoffUtc(SeedData.matchById('aus-tur')),
      DateTime.utc(2026, 6, 14, 4),
    );
  });

  test('classifies completed, upcoming, live, and awaiting-result matches', () {
    final morning = DateTime.utc(2026, 6, 14, 13, 45);
    expect(
      matchTiming(SeedData.matchById('bra-mar'), nowUtc: morning).state,
      MatchTimingState.completed,
    );
    expect(
      matchTiming(SeedData.matchById('ger-cur'), nowUtc: morning).state,
      MatchTimingState.upcoming,
    );
    expect(
      matchTiming(
        SeedData.matchById('ger-cur'),
        nowUtc: DateTime.utc(2026, 6, 14, 18),
      ).state,
      MatchTimingState.live,
    );
    expect(
      matchTiming(
        SeedData.matchById('ger-cur'),
        nowUtc: DateTime.utc(2026, 6, 14, 20),
      ).state,
      MatchTimingState.awaitingResult,
    );
  });

  test('returns recent results and next matches in kickoff order', () {
    final morning = DateTime.utc(2026, 6, 14, 13, 45);

    expect(
      recentResultMatches(
        SeedData.matches,
        nowUtc: morning,
        limit: 3,
      ).map((match) => match.id),
      ['aus-tur', 'hai-sco', 'bra-mar'],
    );
    expect(
      nextUpcomingMatches(
        SeedData.matches,
        nowUtc: morning,
        limit: 3,
      ).map((match) => match.id),
      ['ger-cur', 'ned-jpn', 'civ-ecu'],
    );
  });

  test('labels upcoming matches relative to the current central date', () {
    final morning = DateTime.utc(2026, 6, 14, 13, 45);
    expect(
      timingLabel(SeedData.matchById('ger-cur'), nowUtc: morning),
      'Today',
    );
    expect(
      timingLabel(SeedData.matchById('bel-egy'), nowUtc: morning),
      'Tomorrow',
    );
    expect(
      timingLabel(SeedData.matchById('bra-mar'), nowUtc: morning),
      'Final',
    );
  });
}
