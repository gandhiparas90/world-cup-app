import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/team.dart';
import '../models/world_cup_match.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({
    required this.teams,
    required this.matchesForTeam,
    required this.teamById,
    super.key,
  });

  final List<Team> teams;
  final List<WorldCupMatch> Function(String teamId) matchesForTeam;
  final Team Function(String id) teamById;

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim().toLowerCase();
    final filteredTeams = widget.teams.where((team) {
      if (normalizedQuery.isEmpty) {
        return true;
      }
      return team.name.toLowerCase().contains(normalizedQuery) ||
          team.code.toLowerCase().contains(normalizedQuery) ||
          team.group.toLowerCase().contains(normalizedQuery) ||
          team.confederation.toLowerCase().contains(normalizedQuery);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Teams',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.teams.length} World Cup teams across 12 groups.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search teams',
            prefixIcon: Icon(LucideIcons.search),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 16),
        if (filteredTeams.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Text(
              'No teams match that search.',
              textAlign: TextAlign.center,
            ),
          )
        else
          for (final team in filteredTeams)
            _TeamCatalogCard(
              team: team,
              matches: widget.matchesForTeam(team.id),
              teamById: widget.teamById,
            ),
      ],
    );
  }
}

class _TeamCatalogCard extends StatelessWidget {
  const _TeamCatalogCard({
    required this.team,
    required this.matches,
    required this.teamById,
  });

  final Team team;
  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;

  @override
  Widget build(BuildContext context) {
    final nextMatch = _firstScheduled(matches);
    final opponent = nextMatch == null ? null : _opponentFor(team, nextMatch);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    team.code,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text('${team.group} - ${team.confederation}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(team.formSummary),
            const SizedBox(height: 8),
            if (nextMatch == null)
              const Text('No remaining group fixture in the local snapshot.')
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.calendarDays, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Next: ${nextMatch.dateLabel} ${nextMatch.kickoffLabel} vs ${teamById(opponent!).name}',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  WorldCupMatch? _firstScheduled(List<WorldCupMatch> matches) {
    for (final match in matches) {
      if (match.isScheduled) {
        return match;
      }
    }
    return null;
  }

  String _opponentFor(Team team, WorldCupMatch match) {
    return match.homeTeamId == team.id ? match.awayTeamId : match.homeTeamId;
  }
}
