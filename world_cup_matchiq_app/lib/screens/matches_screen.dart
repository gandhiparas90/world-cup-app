import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/saved_prediction.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    required this.onSavePrediction,
    super.key,
  });

  final ValueChanged<SavedPrediction> onSavePrediction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Featured fixtures',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Seeded demo coverage for match previews, predictions, and player-impact analysis.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final match in SeedData.matches)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                '${SeedData.teamById(match.homeTeamId).name} vs ${SeedData.teamById(match.awayTeamId).name}',
              ),
              subtitle: Text('${match.stage} - ${match.kickoffLabel} - ${match.venue}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
      ],
    );
  }
}
