import 'package:flutter/material.dart';

import '../models/team.dart';
import '../models/world_cup_match.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    required this.match,
    required this.home,
    required this.away,
    required this.onTap,
    super.key,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final VoidCallback onTap;

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
              Text('${match.stage} - ${match.kickoffLabel}'),
              const SizedBox(height: 4),
              Text(match.venue),
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
