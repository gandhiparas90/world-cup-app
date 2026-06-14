import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/user_profile.dart';
import '../models/world_cup_match.dart';
import '../utils/match_timing.dart';
import '../utils/match_viewing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.matches,
    required this.teams,
    required this.teamById,
    required this.profile,
    required this.savedPredictions,
    this.nowUtc,
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
  final DateTime? nowUtc;
  final Future<void> Function(UserProfile profile) onSaveProfile;
  final VoidCallback onOpenFixtures;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final activeProfile = profile;
    final effectiveNowUtc = (nowUtc ?? DateTime.now().toUtc()).toUtc();
    final countryCode = activeProfile?.countryCode ?? 'US';
    final timezone = activeProfile?.timezone ?? 'America/Chicago';

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
            nowUtc: effectiveNowUtc,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _NextUpSection(
            countryCode: countryCode,
            timezone: timezone,
            matches: matches,
            teamById: teamById,
            nowUtc: effectiveNowUtc,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _RecentResultsSection(
            countryCode: countryCode,
            timezone: timezone,
            matches: matches,
            teamById: teamById,
            nowUtc: effectiveNowUtc,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _SavedSummaryCard(
            savedPredictions: savedPredictions,
            onOpenProfile: onOpenProfile,
          ),
        ] else ...[
          _RecentResultsSection(
            countryCode: countryCode,
            timezone: timezone,
            matches: matches,
            teamById: teamById,
            nowUtc: effectiveNowUtc,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _NextUpSection(
            countryCode: countryCode,
            timezone: timezone,
            matches: matches,
            teamById: teamById,
            nowUtc: effectiveNowUtc,
            onOpenFixtures: onOpenFixtures,
          ),
          const SizedBox(height: 16),
          _SnapshotCard(
            matches: matches,
            nowUtc: effectiveNowUtc,
            onOpenFixtures: onOpenFixtures,
          ),
        ],
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
    required this.nowUtc,
    required this.onOpenFixtures,
  });

  final UserProfile profile;
  final List<Team> teams;
  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final DateTime nowUtc;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    final favorite = _teamByIdOrFallback(teams, profile.favoriteTeamId);
    final favoriteMatches = matches
        .where(
          (match) =>
              match.homeTeamId == favorite.id ||
              match.awayTeamId == favorite.id,
        )
        .toList();
    final nextFavorite = nextUpcomingMatches(
      favoriteMatches,
      nowUtc: nowUtc,
      limit: 1,
    );
    final latestFavorite = recentResultMatches(
      favoriteMatches,
      nowUtc: nowUtc,
      limit: 1,
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
            if (favoriteMatches.isEmpty) ...[
              Text('No ${favorite.name} match in the local catalog.'),
            ] else ...[
              if (nextFavorite.isNotEmpty)
                _FavoriteMatchLine(
                  label: 'Next',
                  match: nextFavorite.first,
                  teamById: teamById,
                  countryCode: profile.countryCode,
                  timezone: profile.timezone,
                  nowUtc: nowUtc,
                ),
              if (latestFavorite.isNotEmpty)
                _FavoriteMatchLine(
                  label: 'Latest',
                  match: latestFavorite.first,
                  teamById: teamById,
                  countryCode: profile.countryCode,
                  timezone: profile.timezone,
                  nowUtc: nowUtc,
                ),
            ],
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

class _FavoriteMatchLine extends StatelessWidget {
  const _FavoriteMatchLine({
    required this.label,
    required this.match,
    required this.teamById,
    required this.countryCode,
    required this.timezone,
    required this.nowUtc,
  });

  final String label;
  final WorldCupMatch match;
  final Team Function(String id) teamById;
  final String countryCode;
  final String timezone;
  final DateTime nowUtc;

  @override
  Widget build(BuildContext context) {
    final home = teamById(match.homeTeamId);
    final away = teamById(match.awayTeamId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${_matchLabel(match, teamById)}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 3),
          Text(
            _matchStatusLine(match, home, away, countryCode, timezone, nowUtc),
          ),
        ],
      ),
    );
  }
}

class _NextUpSection extends StatelessWidget {
  const _NextUpSection({
    required this.countryCode,
    required this.timezone,
    required this.matches,
    required this.teamById,
    required this.nowUtc,
    required this.onOpenFixtures,
  });

  final String countryCode;
  final String timezone;
  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final DateTime nowUtc;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    final visibleMatches = nextUpcomingMatches(
      matches,
      nowUtc: nowUtc,
      limit: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SectionTitle(icon: LucideIcons.tv, title: 'Next up'),
            ),
            TextButton(onPressed: onOpenFixtures, child: const Text('All')),
          ],
        ),
        const SizedBox(height: 8),
        if (visibleMatches.isEmpty)
          const Text('No upcoming fixtures in the local catalog.')
        else
          for (final match in visibleMatches)
            _CompactMatchCard(
              match: match,
              home: teamById(match.homeTeamId),
              away: teamById(match.awayTeamId),
              countryCode: countryCode,
              timezone: timezone,
              nowUtc: nowUtc,
            ),
      ],
    );
  }
}

class _RecentResultsSection extends StatelessWidget {
  const _RecentResultsSection({
    required this.countryCode,
    required this.timezone,
    required this.matches,
    required this.teamById,
    required this.nowUtc,
    required this.onOpenFixtures,
  });

  final String countryCode;
  final String timezone;
  final List<WorldCupMatch> matches;
  final Team Function(String id) teamById;
  final DateTime nowUtc;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    final visibleMatches = recentResultMatches(
      matches,
      nowUtc: nowUtc,
      limit: 3,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SectionTitle(
                icon: LucideIcons.trophy,
                title: 'Recent results',
              ),
            ),
            TextButton(onPressed: onOpenFixtures, child: const Text('All')),
          ],
        ),
        const SizedBox(height: 8),
        if (visibleMatches.isEmpty)
          const Text('No completed fixtures in the local catalog yet.')
        else
          for (final match in visibleMatches)
            _CompactMatchCard(
              match: match,
              home: teamById(match.homeTeamId),
              away: teamById(match.awayTeamId),
              countryCode: countryCode,
              timezone: timezone,
              nowUtc: nowUtc,
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
    required this.countryCode,
    required this.timezone,
    required this.nowUtc,
  });

  final WorldCupMatch match;
  final Team home;
  final Team away;
  final String countryCode;
  final String timezone;
  final DateTime nowUtc;

  @override
  Widget build(BuildContext context) {
    final statusLabel = timingLabel(match, nowUtc: nowUtc);

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
                _StatusPill(label: statusLabel, match: match, nowUtc: nowUtc),
                const SizedBox(width: 8),
                Text(
                  match.stage,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _matchStatusLine(
                match,
                home,
                away,
                countryCode,
                timezone,
                nowUtc,
              ),
            ),
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
  const _SnapshotCard({
    required this.matches,
    required this.nowUtc,
    required this.onOpenFixtures,
  });

  final List<WorldCupMatch> matches;
  final DateTime nowUtc;
  final VoidCallback onOpenFixtures;

  @override
  Widget build(BuildContext context) {
    final finalCount = matches
        .where(
          (match) =>
              matchTiming(match, nowUtc: nowUtc).state ==
              MatchTimingState.completed,
        )
        .length;
    final upcomingCount = matches
        .where(
          (match) =>
              matchTiming(match, nowUtc: nowUtc).state ==
              MatchTimingState.upcoming,
        )
        .length;
    final pendingCount = matches.length - finalCount - upcomingCount;

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
                  Text(
                    '$finalCount finals, $upcomingCount upcoming, $pendingCount pending/live',
                  ),
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.match,
    required this.nowUtc,
  });

  final String label;
  final WorldCupMatch match;
  final DateTime nowUtc;

  @override
  Widget build(BuildContext context) {
    final state = matchTiming(match, nowUtc: nowUtc).state;
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

Team _preferredTeam(List<Team> teams) {
  return _teamByIdOrFallback(teams, 'por');
}

Team _teamByIdOrFallback(List<Team> teams, String id) {
  return teams.firstWhere((team) => team.id == id, orElse: () => teams.first);
}

String _matchLabel(WorldCupMatch match, Team Function(String id) teamById) {
  final home = teamById(match.homeTeamId);
  final away = teamById(match.awayTeamId);
  return '${home.name} vs ${away.name}';
}

String _matchStatusLine(
  WorldCupMatch match,
  Team home,
  Team away,
  String countryCode,
  String timezone,
  DateTime nowUtc,
) {
  final timing = matchTiming(match, nowUtc: nowUtc);
  if (timing.state == MatchTimingState.completed &&
      match.homeScore != null &&
      match.awayScore != null) {
    return 'Final: ${home.code} ${match.homeScore} - ${match.awayScore} ${away.code}';
  }

  final line = viewingLine(match, countryCode, timezone);
  if (timing.state == MatchTimingState.live) {
    return 'Live window - $line';
  }
  if (timing.state == MatchTimingState.awaitingResult) {
    return 'Result pending - $line';
  }
  return line;
}
