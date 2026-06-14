import 'package:flutter/material.dart';

import '../models/team.dart';
import '../models/world_cup_match.dart';
import '../utils/match_timing.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    required this.match,
    required this.home,
    required this.away,
    required this.onTap,
    this.metaLine,
    super.key,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final VoidCallback onTap;
  final String? metaLine;

  @override
  Widget build(BuildContext context) {
    final timing = matchTiming(match);
    final statusLabel = timingLabel(match);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${home.name} vs ${away.name}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusChip(label: statusLabel, state: timing.state),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(metaLine ?? '${match.stage} - ${match.kickoffLabel}'),
              if (match.isCompleted &&
                  match.homeScore != null &&
                  match.awayScore != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Final: ${home.code} ${match.homeScore} - ${match.awayScore} ${away.code}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ] else if (timing.state == MatchTimingState.live ||
                  timing.state == MatchTimingState.awaitingResult) ...[
                const SizedBox(height: 6),
                Text(
                  timing.state == MatchTimingState.live
                      ? 'Match window is live; final score not stored yet.'
                      : 'Kickoff has passed; result update needed.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ],
              const SizedBox(height: 4),
              Text(match.venue),
              const SizedBox(height: 4),
              Text(
                '${match.dataUpdatedLabel} - ${match.sourceLabel}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                match.storyline,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.state});

  final String label;
  final MatchTimingState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = switch (state) {
      MatchTimingState.completed => colors.primaryContainer,
      MatchTimingState.live => colors.tertiaryContainer,
      MatchTimingState.awaitingResult => colors.errorContainer,
      MatchTimingState.upcoming => colors.secondaryContainer,
    };
    final foreground = switch (state) {
      MatchTimingState.completed => colors.onPrimaryContainer,
      MatchTimingState.live => colors.onTertiaryContainer,
      MatchTimingState.awaitingResult => colors.onErrorContainer,
      MatchTimingState.upcoming => colors.onSecondaryContainer,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
