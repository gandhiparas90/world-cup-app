import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';
import '../widgets/prediction_summary.dart';
import '../widgets/scorer_likelihood_list.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({
    required this.match,
    required this.home,
    required this.away,
    required this.players,
    required this.onSavePrediction,
    super.key,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final List<Player> players;
  final Future<void> Function(SavedPrediction prediction) onSavePrediction;

  @override
  Widget build(BuildContext context) {
    final prediction = estimatePrototypePrediction(home, away);

    return Scaffold(
      appBar: AppBar(title: Text('${home.code} vs ${away.code}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${home.name} vs ${away.name}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text('${match.stage} - ${match.kickoffLabel} - ${match.venue}'),
          const SizedBox(height: 4),
          Text(
            '${match.dataUpdatedLabel} - ${match.sourceLabel}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _FixtureContext(match: match, home: home, away: away),
          const SizedBox(height: 12),
          _TeamComparison(
            homeName: home.name,
            awayName: away.name,
            homeValue: home.style,
            awayValue: away.style,
          ),
          const SizedBox(height: 12),
          PredictionSummary(home: home, away: away),
          const SizedBox(height: 12),
          ScorerLikelihoodList(players: players),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await onSavePrediction(
                SavedPrediction(
                  matchId: match.id,
                  matchLabel: '${home.name} vs ${away.name}',
                  scoreline: prediction.scoreline,
                  confidence: prediction.confidence,
                  createdAt: DateTime.now(),
                ),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
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

class _FixtureContext extends StatelessWidget {
  const _FixtureContext({
    required this.match,
    required this.home,
    required this.away,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match context',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(match.storyline),
            const SizedBox(height: 12),
            Text('${home.code}: ${home.formSummary}'),
            const SizedBox(height: 6),
            Text('${home.code} news: ${home.teamNews}'),
            const SizedBox(height: 12),
            Text('${away.code}: ${away.formSummary}'),
            const SizedBox(height: 6),
            Text('${away.code} news: ${away.teamNews}'),
          ],
        ),
      ),
    );
  }
}
