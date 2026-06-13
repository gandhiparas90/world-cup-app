import 'package:flutter/material.dart';

import '../models/player.dart';

class ScorerLikelihoodList extends StatelessWidget {
  const ScorerLikelihoodList({required this.players, super.key});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final ranked = [...players]
      ..sort((a, b) => b.goalInvolvement.compareTo(a.goalInvolvement));
    final topPlayers = ranked.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Likely scorers',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            for (final player in topPlayers)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('${player.name} - ${player.position}'),
                    ),
                    Text('${_likelihood(player)}%'),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Prototype likelihoods are based on recent seeded goal involvement, not betting odds.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  int _likelihood(Player player) {
    final base = player.likelyStarter ? 18 : 10;
    final involvementBoost = player.goalInvolvement * 3;
    return (base + involvementBoost).clamp(8, 42);
  }
}
