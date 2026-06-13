import 'package:flutter/material.dart';

import '../models/ai_match_preview.dart';
import '../models/player.dart';
import '../models/prediction_result.dart';
import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/user_profile.dart';
import '../models/world_cup_match.dart';
import '../services/ai_match_preview_service.dart';
import '../services/prediction_engine.dart';
import '../utils/match_viewing.dart';
import '../widgets/prediction_summary.dart';
import '../widgets/scorer_likelihood_list.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({
    required this.match,
    required this.home,
    required this.away,
    required this.players,
    required this.onSavePrediction,
    required this.aiPreview,
    required this.isGeneratingAiPreview,
    required this.onGenerateAiPreview,
    this.profile,
    super.key,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final List<Player> players;
  final Future<void> Function(SavedPrediction prediction) onSavePrediction;
  final AiMatchPreview? aiPreview;
  final bool isGeneratingAiPreview;
  final Future<void> Function(AiPreviewRequest request) onGenerateAiPreview;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final prediction = const PredictionEngine().predict(
      match: match,
      home: home,
      away: away,
      players: players,
    );
    final matchViewingLine = profile == null
        ? '${match.broadcastChannel} coverage listed at ${match.kickoffLabel}'
        : viewingLine(match, profile!.countryCode, profile!.timezone);
    final aiPreviewRequest = AiPreviewRequest(
      match: match,
      home: home,
      away: away,
      players: players,
      prediction: prediction,
      viewingLine: matchViewingLine,
    );

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
          Text(
            '${match.stage} - ${match.dateLabel} ${match.kickoffLabel} - ${match.venue}',
          ),
          if (match.isCompleted &&
              match.homeScore != null &&
              match.awayScore != null) ...[
            const SizedBox(height: 6),
            Text(
              'Final: ${home.code} ${match.homeScore} - ${match.awayScore} ${away.code}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            '${match.dataUpdatedLabel} - ${match.sourceLabel}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          if (profile != null) ...[
            _ViewingContext(match: match, profile: profile!),
            const SizedBox(height: 12),
          ],
          PredictionSummary(prediction: prediction, home: home, away: away),
          const SizedBox(height: 12),
          _AiPreviewCard(
            preview: aiPreview,
            isGenerating: isGeneratingAiPreview,
            onGenerate: () => onGenerateAiPreview(aiPreviewRequest),
          ),
          const SizedBox(height: 12),
          _PredictionFactors(prediction: prediction),
          const SizedBox(height: 12),
          ScorerLikelihoodList(scorers: prediction.scorers),
          const SizedBox(height: 12),
          _FixtureContext(match: match, home: home, away: away),
          const SizedBox(height: 12),
          _TeamComparison(
            homeName: home.name,
            awayName: away.name,
            homeValue: home.style,
            awayValue: away.style,
          ),
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

class _AiPreviewCard extends StatelessWidget {
  const _AiPreviewCard({
    required this.preview,
    required this.isGenerating,
    required this.onGenerate,
  });

  final AiMatchPreview? preview;
  final bool isGenerating;
  final Future<void> Function() onGenerate;

  @override
  Widget build(BuildContext context) {
    final currentPreview = preview;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI match preview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (currentPreview == null) ...[
              Text(
                'Generate a concise preview from the local match, team, player, and prediction data.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
            ] else ...[
              Text(
                currentPreview.headline,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(currentPreview.tacticalSummary),
              const SizedBox(height: 12),
              Text(
                'Key players',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              for (final playerLine in currentPreview.keyPlayers)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('- $playerLine'),
                ),
              const SizedBox(height: 8),
              Text(currentPreview.predictionRationale),
              const SizedBox(height: 8),
              Text(currentPreview.watchNote),
              const SizedBox(height: 8),
              Text(
                currentPreview.disclaimer,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Source: ${currentPreview.source}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: isGenerating ? null : onGenerate,
              icon: isGenerating
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                isGenerating
                    ? 'Generating preview'
                    : currentPreview == null
                    ? 'Generate AI preview'
                    : 'Refresh AI preview',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PredictionFactors extends StatelessWidget {
  const _PredictionFactors({required this.prediction});

  final PredictionResult prediction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why this prediction?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            for (final factor in prediction.factors)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${factor.label}: ${factor.value}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      factor.explanation,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ViewingContext extends StatelessWidget {
  const _ViewingContext({required this.match, required this.profile});

  final WorldCupMatch match;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Viewing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(viewingLine(match, profile.countryCode, profile.timezone)),
            const SizedBox(height: 4),
            Text(
              '${countryLabel(profile.countryCode)} - ${timezoneLabel(profile.timezone)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
