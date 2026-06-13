import 'package:flutter/material.dart';

import '../models/prediction_result.dart';

class ScorerLikelihoodList extends StatelessWidget {
  const ScorerLikelihoodList({required this.scorers, super.key});

  final List<ScorerPrediction> scorers;

  @override
  Widget build(BuildContext context) {
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
            if (scorers.isEmpty)
              const Text(
                'No player scoring inputs are available for this match yet.',
              )
            else
              for (final scorer in scorers)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${scorer.playerName} - ${scorer.position}'),
                            const SizedBox(height: 2),
                            Text(
                              scorer.explanation,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text('${scorer.percent}%'),
                    ],
                  ),
                ),
            const SizedBox(height: 8),
            Text(
              'Prototype scorer percentages are local estimates and not betting odds.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
