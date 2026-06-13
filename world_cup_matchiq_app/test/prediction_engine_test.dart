import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_matchiq/data/seed_data.dart';
import 'package:world_cup_matchiq/services/prediction_engine.dart';

void main() {
  const engine = PredictionEngine();

  test('predicts bounded outcome probabilities and factor explanations', () {
    final match = SeedData.matchById('bra-mar');
    final result = engine.predict(
      match: match,
      home: SeedData.teamById(match.homeTeamId),
      away: SeedData.teamById(match.awayTeamId),
      players: SeedData.playersForMatch(match.id),
    );

    expect(
      result.homeWinPercent + result.drawPercent + result.awayWinPercent,
      100,
    );
    expect(result.homeWinPercent, inInclusiveRange(0, 100));
    expect(result.drawPercent, inInclusiveRange(0, 100));
    expect(result.awayWinPercent, inInclusiveRange(0, 100));
    expect(result.homeExpectedGoals, inInclusiveRange(0.1, 4.5));
    expect(result.awayExpectedGoals, inInclusiveRange(0.1, 4.5));
    expect(result.scoreline, contains('Brazil'));
    expect(result.confidence, anyOf('Low', 'Medium', 'High'));
    expect(
      result.factors.map((factor) => factor.label),
      contains('Expected goals'),
    );
    expect(result.disclaimer, contains('Not betting odds'));
  });

  test('ranks scorer probabilities and respects availability factors', () {
    final match = SeedData.matchById('bra-mar');
    final result = engine.predict(
      match: match,
      home: SeedData.teamById(match.homeTeamId),
      away: SeedData.teamById(match.awayTeamId),
      players: SeedData.playersForMatch(match.id),
    );

    expect(result.scorers, isNotEmpty);
    expect(
      result.scorers.first.percent,
      greaterThanOrEqualTo(result.scorers.last.percent),
    );
    expect(
      result.scorers.map((scorer) => scorer.percent),
      everyElement(inInclusiveRange(3, 55)),
    );

    final neymar = result.scorers.where(
      (scorer) => scorer.playerId == 'neymar',
    );
    expect(neymar, isNotEmpty);
    expect(neymar.single.percent, lessThan(20));
  });

  test('returns no scorer predictions when no player records exist', () {
    final match = SeedData.matchById('ger-cur');
    final result = engine.predict(
      match: match,
      home: SeedData.teamById(match.homeTeamId),
      away: SeedData.teamById(match.awayTeamId),
      players: SeedData.playersForMatch(match.id),
    );

    expect(result.scorers, isEmpty);
    expect(result.factors, isNotEmpty);
  });
}
