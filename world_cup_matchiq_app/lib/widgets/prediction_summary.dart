import 'package:flutter/material.dart';

import '../models/team.dart';

class PrototypePrediction {
  const PrototypePrediction({
    required this.scoreline,
    required this.confidence,
  });

  final String scoreline;
  final String confidence;
}

PrototypePrediction estimatePrototypePrediction(Team home, Team away) {
  final homeRaw = home.avgGoalsFor + ((home.attackRating - away.defenseRating) / 30);
  final awayRaw = away.avgGoalsFor + ((away.attackRating - home.defenseRating) / 30);
  final homeScore = homeRaw.clamp(0.0, 4.0).round();
  final awayScore = awayRaw.clamp(0.0, 4.0).round();
  final ratingGap = (home.attackRating + home.defenseRating + home.formPoints) -
      (away.attackRating + away.defenseRating + away.formPoints);
  final confidence = ratingGap.abs() > 8
      ? 'High'
      : ratingGap.abs() > 3
          ? 'Medium'
          : 'Low';

  return PrototypePrediction(
    scoreline: '${home.name} $homeScore-$awayScore ${away.name}',
    confidence: confidence,
  );
}

class PredictionSummary extends StatelessWidget {
  const PredictionSummary({
    required this.home,
    required this.away,
    super.key,
  });

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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              prediction.scoreline,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text('${prediction.confidence} confidence estimate based on seeded team ratings.'),
          ],
        ),
      ),
    );
  }
}
