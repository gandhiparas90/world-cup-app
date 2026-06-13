import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/user_profile.dart';
import '../models/world_cup_match.dart';
import '../utils/match_viewing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.matches,
    required this.teams,
    required this.teamById,
    required this.profile,
    required this.savedPredictions,
    required this.onSaveProfile,
    required this.onOpenFixtures,
    required this.onOpenProfile,
    super.key,
  });

  final List<WorldCupMatch> matches;
  final List<Team> teams;
  final Team Function(String id) teamById;
  final UserProfile? profile;
  final List<SavedPrediction> savedPredictions;
  final Future<void> Function(UserProfile profile) onSaveProfile;
  final VoidCallback onOpenFixtures;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final activeProfile = profile;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (activeProfile == null)
          _SetupCard(
            teams: teams,
            onSaveProfile: onSaveProfile,
            onOpenProfile: onOpenProfile,
          )
        else
          _PersonalizedHeader(profile: activeProfile),
        const SizedBox(height: 16),
        if (activeProfile != null) ...[
          _FavoriteTeamCard(
            profile: activeProfile,
            teams: teams,
            matches: matches,
            teamById: teamById,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _TodayNearYouSection(
            profile: activeProfile,
            matches: matches,
            teamById: teamById,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _SavedSummaryCard(
            savedPredictions: savedPredictions,
            onOpenProfile: onOpenProfile,
          ),
        ] else
          _SnapshotCard(matches: matches, onOpenFixtures: onOpenFixtures),
      ],
    );
  }
}

class _SetupCard extends StatelessWidget {
  const _SetupCard({
    required this.teams,
    required this.onSaveProfile,
    required this.onOpenProfile,
  });

  final List<Team> teams;
  final Future<void> Function(UserProfile profile) onSaveProfile;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final defaultTeam = _preferredTeam(teams);

    return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBubble(icon: LucideIcons.sparkles),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Set up your World Cup',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ProfileFact(
                  icon: LucideIcons.globe,
                  label: 'Country',
                  value: countryLabel('US'),
                ),
                const SizedBox(height: 10),
                _ProfileFact(
                  icon: LucideIcons.clock,
                  label: 'Time zone',
                  value: timezoneLabel('America/Chicago'),
                ),
                const SizedBox(height: 10),
                _ProfileFact(
                  icon: LucideIcons.star,
                  label: 'Favorite team',
                  value: defaultTeam.name,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async {
                          final now = DateTime.now();
                          await onSaveProfile(
                            UserProfile(
                              displayName: 'World Cup fan',
                              countryCode: 'US',
                              timezone: 'America/Chicago',
                              favoriteTeamId: defaultTeam.id,
                              createdAt: now,
                              updatedAt: now,
                            ),
                          );
                        },
                        icon: const Icon(LucideIcons.save),
                        label: const Text('Use these settings'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: onOpenProfile,
                  icon: const Icon(LucideIcons.settings),
                  label: const Text('Edit setup'),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 260.ms)
        .slideY(begin: 0.03, end: 0, duration: 260.ms);
  }
}

class _PersonalizedHeader extends StatelessWidget {
  const _PersonalizedHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your World Cup',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: LucideIcons.globe,
                  label: countryLabel(profile.countryCode),
                ),
                _InfoChip(
                  icon: LucideIcons.clock,
                  label: timezoneLabel(profile.timezone),
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 220.ms)
        .slideY(begin: 0.02, end: 0, duration: 220.ms);
  }
}

class _FavoriteTeamCard extends StatelessWidget {
  const _FavoriteTeamCard({
    required this.profile,
    required this.teams,
    required this.matches,
    required this.teamById,
    required this.onOpenFixtures,
  });

  final UserProfile profile;
  final List<Team> teams;
  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    final favorite = _teamByIdOrFallback(teams, profile.favoriteTeamId);
    final favoriteMatches = matches.where(
      (match) =>
          match.homeTeamId == favorite.id || match.awayTeamId == favorite.id,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(icon: LucideIcons.star, title: 'Favorite team'),
            const SizedBox(height: 14),
            Row(
              children: [
                _TeamBadge(team: favorite),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(favorite.formSummary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (favoriteMatches.isEmpty)
              Text('No ${favorite.name} match in today\'s snapshot.')
            else
              for (final match in favoriteMatches)
                Text(
                  viewingLine(match, profile.countryCode, profile.timezone),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onOpenFixtures,
                icon: const Icon(LucideIcons.calendarDays),
                label: const Text('Fixtures'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayNearYouSection extends StatelessWidget {
  const _TodayNearYouSection({
    required this.profile,
    required this.matches,
    required this.teamById,
    required this.onOpenFixtures,
  });

  final UserProfile profile;
  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    final visibleMatches = matches.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SectionTitle(
                icon: LucideIcons.tv,
                title: 'Today near you',
              ),
            ),
            TextButton(onPressed: onOpenFixtures, child: const Text('All')),
          ],
        ),
        const SizedBox(height: 8),
        for (final match in visibleMatches)
          _CompactMatchCard(
            match: match,
            home: teamById(match.homeTeamId),
            away: teamById(match.awayTeamId),
            profile: profile,
          ),
      ],
    );
  }
}

class _CompactMatchCard extends StatelessWidget {
  const _CompactMatchCard({
    required this.match,
    required this.home,
    required this.away,
    required this.profile,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                Text(
                  match.stage,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(viewingLine(match, profile.countryCode, profile.timezone)),
            const SizedBox(height: 4),
            Text(match.venue, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _SavedSummaryCard extends StatelessWidget {
  const _SavedSummaryCard({
    required this.savedPredictions,
    required this.onOpenProfile,
  });

  final List<SavedPrediction> savedPredictions;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _IconBubble(icon: LucideIcons.bookmark),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved predictions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${savedPredictions.length} saved'),
                ],
              ),
            ),
            IconButton(
              onPressed: onOpenProfile,
              icon: const Icon(LucideIcons.chevronRight),
              tooltip: 'Open profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({required this.matches, required this.onOpenFixtures});

  final List<WorldCupMatch> matches;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _IconBubble(icon: LucideIcons.calendarDays),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fixture snapshot',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${matches.length} matches loaded'),
                ],
              ),
            ),
            TextButton(onPressed: onOpenFixtures, child: const Text('Open')),
          ],
        ),
      ),
    );
  }
}

class _ProfileFact extends StatelessWidget {
  const _ProfileFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  const _TeamBadge({required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Text(
        team.code,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

Team _preferredTeam(List<Team> teams) {
  return _teamByIdOrFallback(teams, 'por');
}

Team _teamByIdOrFallback(List<Team> teams, String id) {
  return teams.firstWhere((team) => team.id == id, orElse: () => teams.first);
}
