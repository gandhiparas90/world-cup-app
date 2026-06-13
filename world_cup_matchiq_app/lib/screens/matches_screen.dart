import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/saved_prediction.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

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
          MatchCard(
            match: match,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MatchDetailScreen(
                    match: match,
                    onSavePrediction: onSavePrediction,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
