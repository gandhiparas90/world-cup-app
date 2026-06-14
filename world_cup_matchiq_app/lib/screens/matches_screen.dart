import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/user_profile.dart';
import '../models/world_cup_match.dart';
import '../state/matchiq_controller.dart';
import '../utils/match_viewing.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    required this.matches,
    required this.teamById,
    required this.playersForMatch,
    required this.onSavePrediction,
    this.profile,
    super.key,
  });

  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final List<Player> Function(String matchId) playersForMatch;
  final Future<void> Function(SavedPrediction prediction) onSavePrediction;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Group fixtures',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Full local group-stage catalog with kickoff times, US broadcast context, team notes, and transparent prototype predictions.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final match in matches)
          MatchCard(
            match: match,
            home: teamById(match.homeTeamId),
            away: teamById(match.awayTeamId),
            metaLine: profile == null
                ? '${match.stage} - ${match.dateLabel} ${match.kickoffLabel}'
                : '${match.stage} - ${viewingLine(match, profile!.countryCode, profile!.timezone)}',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Consumer<MatchIqController>(
                    builder: (context, controller, _) {
                      final currentMatch = controller.matchById(match.id);
                      return MatchDetailScreen(
                        match: currentMatch,
                        home: controller.teamById(currentMatch.homeTeamId),
                        away: controller.teamById(currentMatch.awayTeamId),
                        players: controller.playersForMatch(currentMatch.id),
                        profile: controller.profile,
                        onSavePrediction: controller.savePrediction,
                        fixtureResult: controller.fixtureResultForMatch(
                          currentMatch.id,
                        ),
                        onSaveFixtureResult: controller.saveFixtureResult,
                        onClearFixtureResult: controller.clearFixtureResult,
                        aiPreview: controller.aiPreviewForMatch(
                          currentMatch.id,
                        ),
                        isGeneratingAiPreview: controller.isGeneratingAiPreview(
                          currentMatch.id,
                        ),
                        onGenerateAiPreview: controller.generateAiPreview,
                      );
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
