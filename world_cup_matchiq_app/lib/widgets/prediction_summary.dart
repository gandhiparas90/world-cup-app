import 'package:flutter/material.dart';

import '../models/prediction_result.dart';
import '../models/team.dart';

class PredictionSummary extends StatelessWidget {
  const PredictionSummary({
    required this.prediction,
    required this.home,
    required this.away,
    super.key,
  });

  final PredictionResult prediction;
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
            Text('${prediction.confidence} confidence prototype estimate.'),
            const SizedBox(height: 12),
            _OutcomeRow(prediction: prediction, home: home, away: away),
            const SizedBox(height: 12),
            Text(
              '${home.code} xG ${prediction.homeExpectedGoals.toStringAsFixed(1)} - ${away.code} xG ${prediction.awayExpectedGoals.toStringAsFixed(1)}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              prediction.disclaimer,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _OutcomeRow extends StatelessWidget {
  const _OutcomeRow({
    required this.prediction,
    required this.home,
    required this.away,
  });

  final PredictionResult prediction;
  final Team home;
  final Team away;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Win / draw / loss probability',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          '${home.name} win ${prediction.homeWinPercent}% - Draw ${prediction.drawPercent}% - ${away.name} win ${prediction.awayWinPercent}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ProbabilityPill(
                label: '${home.code} win',
                value: prediction.homeWinPercent,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ProbabilityPill(
                label: 'Draw',
                value: prediction.drawPercent,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ProbabilityPill(
                label: '${away.code} win',
                value: prediction.awayWinPercent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProbabilityPill extends StatelessWidget {
  const _ProbabilityPill({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$value%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
