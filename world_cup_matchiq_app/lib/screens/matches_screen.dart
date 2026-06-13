import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    required this.matches,
    required this.teamById,
    required this.playersForMatch,
    required this.onSavePrediction,
    super.key,
  });

  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final List<Player> Function(String matchId) playersForMatch;
  final Future<void> Function(SavedPrediction prediction) onSavePrediction;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Today\'s fixtures',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Local World Cup snapshot with fixture context, team news, and transparent prototype predictions.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final match in matches)
          MatchCard(
            match: match,
            home: teamById(match.homeTeamId),
            away: teamById(match.awayTeamId),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MatchDetailScreen(
                    match: match,
                    home: teamById(match.homeTeamId),
                    away: teamById(match.awayTeamId),
                    players: playersForMatch(match.id),
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
