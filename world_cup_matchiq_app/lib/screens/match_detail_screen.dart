import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/saved_prediction.dart';
import '../models/world_cup_match.dart';
import '../widgets/prediction_summary.dart';
import '../widgets/scorer_likelihood_list.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({
    required this.match,
    required this.onSavePrediction,
    super.key,
  });

  final WorldCupMatch match;
  final ValueChanged<SavedPrediction> onSavePrediction;

  @override
  Widget build(BuildContext context) {
    final home = SeedData.teamById(match.homeTeamId);
    final away = SeedData.teamById(match.awayTeamId);
    final prediction = estimatePrototypePrediction(home, away);

    return Scaffold(
      appBar: AppBar(
        title: Text('${home.code} vs ${away.code}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${home.flagLabel} ${home.name} vs ${away.flagLabel} ${away.name}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text('${match.stage} - ${match.kickoffLabel} - ${match.venue}'),
          const SizedBox(height: 16),
          _TeamComparison(
            homeName: home.name,
            awayName: away.name,
            homeValue: home.style,
            awayValue: away.style,
          ),
          const SizedBox(height: 12),
          PredictionSummary(home: home, away: away),
          const SizedBox(height: 12),
          ScorerLikelihoodList(players: SeedData.playersForMatch(match.id)),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              onSavePrediction(
                SavedPrediction(
                  matchId: match.id,
                  matchLabel: '${home.name} vs ${away.name}',
                  scoreline: prediction.scoreline,
                  confidence: prediction.confidence,
                  createdAt: DateTime.now(),
                ),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.bookmark_add),
            label: const Text('Save prediction'),
          ),
        ],
      ),
    );
  }
}

class _TeamComparison extends StatelessWidget {
  const _TeamComparison({
    required this.homeName,
    required this.awayName,
    required this.homeValue,
    required this.awayValue,
  });

  final String homeName;
  final String awayName;
  final String homeValue;
  final String awayValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Style comparison',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Text('$homeName: $homeValue'),
            const SizedBox(height: 8),
            Text('$awayName: $awayValue'),
          ],
        ),
      ),
    );
  }
}
