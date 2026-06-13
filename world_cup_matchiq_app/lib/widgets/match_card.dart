import 'package:flutter/material.dart';

import '../models/team.dart';
import '../models/world_cup_match.dart';

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
