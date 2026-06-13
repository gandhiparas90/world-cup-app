import 'package:flutter/material.dart';

import '../models/team.dart';

class PrototypePrediction {
  const PrototypePrediction({
    required this.scoreline,
    required this.confidence,
    required this.homeExpectedGoals,
    required this.awayExpectedGoals,
    required this.calculationNote,
  });

  final String scoreline;
  final String confidence;
  final double homeExpectedGoals;
  final double awayExpectedGoals;
  final String calculationNote;
}

PrototypePrediction estimatePrototypePrediction(Team home, Team away) {
  final homeRaw = _expectedGoals(home, away);
  final awayRaw = _expectedGoals(away, home);
  final homeScore = homeRaw.clamp(0.0, 4.0).round();
  final awayScore = awayRaw.clamp(0.0, 4.0).round();
  final ratingGap =
      (home.attackRating + home.defenseRating + home.formPoints) -
      (away.attackRating + away.defenseRating + away.formPoints);
  final confidence = ratingGap.abs() > 8
      ? 'High'
      : ratingGap.abs() > 3
      ? 'Medium'
      : 'Low';

  return PrototypePrediction(
    scoreline: '${home.name} $homeScore-$awayScore ${away.name}',
    confidence: confidence,
    homeExpectedGoals: homeRaw.clamp(0.0, 4.0),
    awayExpectedGoals: awayRaw.clamp(0.0, 4.0),
    calculationNote:
        'Expected goals blend recent scoring, opponent concession rate, attack-vs-defense ratings, and form gap.',
  );
}

double _expectedGoals(Team attack, Team defense) {
  final scoringBase =
      (attack.avgGoalsFor * 0.65) + (defense.avgGoalsAgainst * 0.35);
  final ratingAdjustment = (attack.attackRating - defense.defenseRating) / 50;
  final formAdjustment = (attack.formPoints - defense.formPoints) / 30;
  return scoringBase + ratingAdjustment + formAdjustment;
}

class PredictionSummary extends StatelessWidget {
  const PredictionSummary({required this.home, required this.away, super.key});

  final Team home;
  final Team away;

  @override
  Widget build(BuildContext context) {
    final prediction = estimatePrototypePrediction(home, away);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prototype scoreline',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              prediction.scoreline,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '${prediction.confidence} confidence prototype estimate. Not betting odds.',
            ),
            const SizedBox(height: 12),
            Text(
              '${home.code} xG ${prediction.homeExpectedGoals.toStringAsFixed(1)} - ${away.code} xG ${prediction.awayExpectedGoals.toStringAsFixed(1)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              prediction.calculationNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
