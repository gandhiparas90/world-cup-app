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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${player.name} - ${player.position}'),
                          const SizedBox(height: 2),
                          Text(
                            player.news,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text('${_likelihood(player)}%'),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Prototype scorer percentages blend threat rating, recent goal involvement, starter status, and availability. They are not betting odds.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  int _likelihood(Player player) {
    final starterBoost = player.likelyStarter ? 8 : 0;
    final raw =
        10 +
        (player.goalThreatRating * 0.28) +
        (player.goalInvolvement * 2) +
        starterBoost;
    return (raw * player.availabilityFactor).round().clamp(5, 48);
  }
}
