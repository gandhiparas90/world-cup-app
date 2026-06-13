import '../models/player.dart';
import '../models/prediction_result.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';

class PredictionEngine {
  const PredictionEngine();

  PredictionResult predict({
    required WorldCupMatch match,
    required Team home,
    required Team away,
    required List<Player> players,
  }) {
    final homeExpectedGoals = _expectedGoals(
      attack: home,
      defense: away,
      listedHomeSide: true,
    );
    final awayExpectedGoals = _expectedGoals(
      attack: away,
      defense: home,
      listedHomeSide: false,
    );
    final outcome = _outcomeProbabilities(
      home: home,
      away: away,
      homeExpectedGoals: homeExpectedGoals,
      awayExpectedGoals: awayExpectedGoals,
    );
    final homeScore = homeExpectedGoals.clamp(0.0, 4.0).round();
    final awayScore = awayExpectedGoals.clamp(0.0, 4.0).round();
    final confidence = _confidence(
      home: home,
      away: away,
      homeExpectedGoals: homeExpectedGoals,
      awayExpectedGoals: awayExpectedGoals,
    );
    final scorers = _scorerPredictions(
      players: players,
      homeTeamId: home.id,
      homeExpectedGoals: homeExpectedGoals,
      awayExpectedGoals: awayExpectedGoals,
    );

    return PredictionResult(
      scoreline: '${home.name} $homeScore-$awayScore ${away.name}',
      confidence: confidence,
      homeExpectedGoals: homeExpectedGoals,
      awayExpectedGoals: awayExpectedGoals,
      homeWinPercent: outcome.homeWinPercent,
      drawPercent: outcome.drawPercent,
      awayWinPercent: outcome.awayWinPercent,
      factors: _factors(
        match: match,
        home: home,
        away: away,
        homeExpectedGoals: homeExpectedGoals,
        awayExpectedGoals: awayExpectedGoals,
      ),
      scorers: scorers,
      disclaimer:
          'Prototype estimate using local team/player inputs. Not betting odds or official probabilities.',
    );
  }

  double _expectedGoals({
    required Team attack,
    required Team defense,
    required bool listedHomeSide,
  }) {
    final scoringBase =
        (attack.avgGoalsFor * 0.58) + (defense.avgGoalsAgainst * 0.42);
    final ratingAdjustment = (attack.attackRating - defense.defenseRating) / 45;
    final formAdjustment = (attack.formPoints - defense.formPoints) / 35;
    final homeSideAdjustment = listedHomeSide ? 0.08 : 0.0;
    return (scoringBase +
            ratingAdjustment +
            formAdjustment +
            homeSideAdjustment)
        .clamp(0.1, 4.5);
  }

  _OutcomeProbabilities _outcomeProbabilities({
    required Team home,
    required Team away,
    required double homeExpectedGoals,
    required double awayExpectedGoals,
  }) {
    final ratingGap =
        (home.attackRating + home.defenseRating + home.formPoints) -
        (away.attackRating + away.defenseRating + away.formPoints);
    final expectedGoalsGap = homeExpectedGoals - awayExpectedGoals;
    final strengthGap = (ratingGap / 18) + (expectedGoalsGap * 18);
    final closeness = strengthGap.abs().clamp(0.0, 26.0);
    final drawPercent = (31 - (closeness * 0.55)).round().clamp(16, 31);
    final remaining = 100 - drawPercent;
    final homeShare = (0.5 + (strengthGap / 70)).clamp(0.22, 0.78);
    final homeWin = (remaining * homeShare).round();
    final awayWin = 100 - drawPercent - homeWin;
    return _OutcomeProbabilities(
      homeWinPercent: homeWin,
      drawPercent: drawPercent,
      awayWinPercent: awayWin,
    );
  }

  String _confidence({
    required Team home,
    required Team away,
    required double homeExpectedGoals,
    required double awayExpectedGoals,
  }) {
    final ratingGap =
        (home.attackRating + home.defenseRating + home.formPoints) -
        (away.attackRating + away.defenseRating + away.formPoints);
    final goalGap = (homeExpectedGoals - awayExpectedGoals).abs();
    final signal = ratingGap.abs() + (goalGap * 7);
    if (signal >= 14) {
      return 'High';
    }
    if (signal >= 7) {
      return 'Medium';
    }
    return 'Low';
  }

  List<PredictionFactor> _factors({
    required WorldCupMatch match,
    required Team home,
    required Team away,
    required double homeExpectedGoals,
    required double awayExpectedGoals,
  }) {
    final attackGap = home.attackRating - away.defenseRating;
    final awayAttackGap = away.attackRating - home.defenseRating;
    final formGap = home.formPoints - away.formPoints;
    final goalsGap = homeExpectedGoals - awayExpectedGoals;

    return [
      PredictionFactor(
        label: 'Attack vs defense',
        value:
            '${home.code} ${_signed(attackGap)} / ${away.code} ${_signed(awayAttackGap)}',
        explanation:
            'Compares each attack rating against the opponent defense rating.',
      ),
      PredictionFactor(
        label: 'Recent form',
        value: formGap == 0
            ? 'Even'
            : formGap > 0
            ? '${home.code} +$formGap'
            : '${away.code} +${formGap.abs()}',
        explanation:
            'Uses local form points as a small adjustment, not live standings.',
      ),
      PredictionFactor(
        label: 'Expected goals',
        value:
            '${home.code} ${homeExpectedGoals.toStringAsFixed(1)} - ${away.code} ${awayExpectedGoals.toStringAsFixed(1)}',
        explanation:
            'Blends scoring rate, opponent concession rate, rating gap, and form.',
      ),
      PredictionFactor(
        label: 'Match status',
        value: match.isCompleted ? 'Completed snapshot' : 'Scheduled fixture',
        explanation:
            'Completed scores are displayed separately; the model remains a prototype estimate.',
      ),
      PredictionFactor(
        label: 'Upset risk',
        value: goalsGap.abs() < 0.35 ? 'Elevated' : 'Moderate',
        explanation:
            'Close expected-goal margins increase draw and upset uncertainty.',
      ),
    ];
  }

  List<ScorerPrediction> _scorerPredictions({
    required List<Player> players,
    required String homeTeamId,
    required double homeExpectedGoals,
    required double awayExpectedGoals,
  }) {
    final ranked = players.map((player) {
      final teamExpectedGoals = player.teamId == homeTeamId
          ? homeExpectedGoals
          : awayExpectedGoals;
      final starterBoost = player.likelyStarter ? 8 : 0;
      final raw =
          7 +
          (player.goalThreatRating * 0.25) +
          (player.goalInvolvement * 1.8) +
          (teamExpectedGoals * 3) +
          starterBoost;
      final percent = (raw * player.availabilityFactor).round().clamp(3, 55);
      return ScorerPrediction(
        playerId: player.id,
        playerName: player.name,
        teamId: player.teamId,
        position: player.position,
        percent: percent,
        explanation:
            '${player.position}; blends threat rating, recent involvement, starter status, availability, and team xG.',
      );
    }).toList()..sort((a, b) => b.percent.compareTo(a.percent));

    return ranked.take(5).toList();
  }

  String _signed(int value) {
    if (value > 0) {
      return '+$value';
    }
    return value.toString();
  }
}

class _OutcomeProbabilities {
  const _OutcomeProbabilities({
    required this.homeWinPercent,
    required this.drawPercent,
    required this.awayWinPercent,
  });

  final int homeWinPercent;
  final int drawPercent;
  final int awayWinPercent;
}
