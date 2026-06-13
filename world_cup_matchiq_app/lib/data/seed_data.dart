import '../models/player.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';

class SeedData {
  const SeedData._();

  static const scheduleSourceLabel = 'Guardian World Cup guide';
  static const scheduleSourceUrl =
      'https://www.theguardian.com/football/2026/jun/13/how-to-watch-world-cup-brazil-morocco-haiti-scotland';
  static const dataUpdatedLabel = 'Updated Jun 13, 2026';

  static const teams = <Team>[
    Team(
      id: 'qat',
      name: 'Qatar',
      code: 'QAT',
      flagLabel: 'QAT',
      group: 'Group B',
      manager: 'Julen Lopetegui',
      style: 'Compact block, patient possession, quick wide outlets',
      formSummary: 'Two-time Asian champions looking to improve on 2022.',
      teamNews:
          'The tournament guide frames this as a chance to reset after a poor 2022 home World Cup.',
      attackRating: 70,
      defenseRating: 68,
      formPoints: 7,
      avgGoalsFor: 1.2,
      avgGoalsAgainst: 1.4,
    ),
    Team(
      id: 'sui',
      name: 'Switzerland',
      code: 'SUI',
      flagLabel: 'SUI',
      group: 'Group B',
      manager: 'Murat Yakin',
      style: 'Organized mid-block, direct winger carries, veteran midfield',
      formSummary: 'Consistent tournament team with an experienced core.',
      teamNews:
          'Dan Ndoye is highlighted as a form winger and player to watch.',
      attackRating: 78,
      defenseRating: 80,
      formPoints: 10,
      avgGoalsFor: 1.6,
      avgGoalsAgainst: 1.0,
    ),
    Team(
      id: 'bra',
      name: 'Brazil',
      code: 'BRA',
      flagLabel: 'BRA',
      group: 'Group C',
      manager: 'Carlo Ancelotti',
      style: 'Wide isolation, fast combinations, aggressive counter-pressing',
      formSummary:
          'Five-time champions, but entering the tournament after uneven qualifying form.',
      teamNews:
          'Brazil open against Morocco under Ancelotti with pressure on the attack to settle quickly.',
      attackRating: 84,
      defenseRating: 77,
      formPoints: 8,
      avgGoalsFor: 1.7,
      avgGoalsAgainst: 1.1,
    ),
    Team(
      id: 'mar',
      name: 'Morocco',
      code: 'MAR',
      flagLabel: 'MAR',
      group: 'Group C',
      manager: 'Walid Regragui',
      style: 'Compact defending, fast counters, full-back driven width',
      formSummary:
          'African champions and 2022 World Cup semi-finalists with upset potential.',
      teamNews:
          'The matchup is framed as a serious upset threat because of Morocco speed in transition.',
      attackRating: 80,
      defenseRating: 82,
      formPoints: 11,
      avgGoalsFor: 1.8,
      avgGoalsAgainst: 0.8,
    ),
    Team(
      id: 'hai',
      name: 'Haiti',
      code: 'HAI',
      flagLabel: 'HAI',
      group: 'Group C',
      manager: 'Sebastien Migne',
      style: 'Vertical breaks, direct running, physical midfield duels',
      formSummary:
          'Returning to the World Cup after a long absence and carrying tune-up momentum.',
      teamNews:
          'Haiti drew attention after a 4-0 tune-up win over New Zealand.',
      attackRating: 67,
      defenseRating: 64,
      formPoints: 7,
      avgGoalsFor: 1.1,
      avgGoalsAgainst: 1.5,
    ),
    Team(
      id: 'sco',
      name: 'Scotland',
      code: 'SCO',
      flagLabel: 'SCO',
      group: 'Group C',
      manager: 'Steve Clarke',
      style: 'Set-piece pressure, late midfield runs, compact back line',
      formSummary:
          'First World Cup appearance since 1998 with strong late qualifying momentum.',
      teamNews:
          'Scotland are noted for scoring eight goals across their final two warm-up matches.',
      attackRating: 74,
      defenseRating: 73,
      formPoints: 10,
      avgGoalsFor: 1.7,
      avgGoalsAgainst: 1.1,
    ),
    Team(
      id: 'aus',
      name: 'Australia',
      code: 'AUS',
      flagLabel: 'AUS',
      group: 'Group D',
      manager: 'Tony Popovic',
      style: 'Hard pressing, aerial contests, direct transition attacks',
      formSummary:
          'Competitive underdog with younger attacking energy under Popovic.',
      teamNews:
          'Australia are described as less naturally gifted than Turkey but difficult to dismiss.',
      attackRating: 69,
      defenseRating: 70,
      formPoints: 7,
      avgGoalsFor: 1.2,
      avgGoalsAgainst: 1.2,
    ),
    Team(
      id: 'tur',
      name: 'Turkey',
      code: 'TUR',
      flagLabel: 'TUR',
      group: 'Group D',
      manager: 'Vincenzo Montella',
      style: 'Creative midfield rotations, left-footed playmaking, quick shots',
      formSummary:
          'Back at the World Cup with a technically strong attacking group.',
      teamNews:
          'Arda Guler is highlighted as the player to watch and a central creative threat.',
      attackRating: 79,
      defenseRating: 72,
      formPoints: 9,
      avgGoalsFor: 1.8,
      avgGoalsAgainst: 1.3,
    ),
  ];

  static const players = <Player>[
    Player(
      id: 'afif',
      teamId: 'qat',
      name: 'Akram Afif',
      position: 'Forward',
      news: 'Primary creative outlet for Qatar in transition.',
      goalThreatRating: 76,
      recentGoals: 3,
      recentAssists: 3,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'ali',
      teamId: 'qat',
      name: 'Almoez Ali',
      position: 'Forward',
      news: 'Penalty-box reference point and late-run target.',
      goalThreatRating: 70,
      recentGoals: 2,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 0.95,
    ),
    Player(
      id: 'ndoye',
      teamId: 'sui',
      name: 'Dan Ndoye',
      position: 'Winger',
      news:
          'Named as Switzerland player to watch after strong recent scoring form.',
      goalThreatRating: 79,
      recentGoals: 5,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'xhaka',
      teamId: 'sui',
      name: 'Granit Xhaka',
      position: 'Midfielder',
      news: 'Veteran midfield organizer for Switzerland tournament control.',
      goalThreatRating: 60,
      recentGoals: 1,
      recentAssists: 3,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'vinicius',
      teamId: 'bra',
      name: 'Vinicius Junior',
      position: 'Forward',
      news: 'Brazil headline attacker for a high-pressure opener.',
      goalThreatRating: 88,
      recentGoals: 4,
      recentAssists: 3,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'neymar',
      teamId: 'bra',
      name: 'Neymar',
      position: 'Forward',
      news: 'Reported as unavailable for the Morocco opener.',
      goalThreatRating: 82,
      recentGoals: 2,
      recentAssists: 2,
      likelyStarter: false,
      availabilityFactor: 0.15,
    ),
    Player(
      id: 'hakimi',
      teamId: 'mar',
      name: 'Achraf Hakimi',
      position: 'Full-back',
      news: 'Player to watch; his forward runs are a key Morocco threat.',
      goalThreatRating: 74,
      recentGoals: 2,
      recentAssists: 4,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'en-nesyri',
      teamId: 'mar',
      name: 'Youssef En-Nesyri',
      position: 'Forward',
      news: 'Primary central finisher for Morocco counter-attacks.',
      goalThreatRating: 78,
      recentGoals: 4,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 0.98,
    ),
    Player(
      id: 'bellegarde',
      teamId: 'hai',
      name: 'Jean-Ricner Bellegarde',
      position: 'Midfielder',
      news: 'Premier League quality in Haiti midfield progression.',
      goalThreatRating: 66,
      recentGoals: 1,
      recentAssists: 3,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'nazon',
      teamId: 'hai',
      name: 'Duckens Nazon',
      position: 'Forward',
      news: 'Direct striker profile for Haiti breakaway chances.',
      goalThreatRating: 70,
      recentGoals: 3,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 0.95,
    ),
    Player(
      id: 'mctominay',
      teamId: 'sco',
      name: 'Scott McTominay',
      position: 'Midfielder',
      news: 'Player to watch and Scotland major box-arrival scoring threat.',
      goalThreatRating: 80,
      recentGoals: 4,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'shankland',
      teamId: 'sco',
      name: 'Lawrence Shankland',
      position: 'Forward',
      news: 'Central scoring option if Scotland sustain pressure.',
      goalThreatRating: 72,
      recentGoals: 3,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 0.9,
    ),
    Player(
      id: 'duke',
      teamId: 'aus',
      name: 'Mitchell Duke',
      position: 'Forward',
      news: 'Aerial focal point for Australia direct attacks.',
      goalThreatRating: 68,
      recentGoals: 2,
      recentAssists: 1,
      likelyStarter: true,
      availabilityFactor: 0.95,
    ),
    Player(
      id: 'irankunda',
      teamId: 'aus',
      name: 'Nestory Irankunda',
      position: 'Winger',
      news: 'Young pace option who can change the match state late.',
      goalThreatRating: 65,
      recentGoals: 2,
      recentAssists: 2,
      likelyStarter: false,
      availabilityFactor: 0.8,
    ),
    Player(
      id: 'guler',
      teamId: 'tur',
      name: 'Arda Guler',
      position: 'Attacking midfielder',
      news: 'Player to watch; central creator and long-shot threat.',
      goalThreatRating: 82,
      recentGoals: 3,
      recentAssists: 4,
      likelyStarter: true,
      availabilityFactor: 1.0,
    ),
    Player(
      id: 'yildiz',
      teamId: 'tur',
      name: 'Kenan Yildiz',
      position: 'Forward',
      news: 'Secondary creator who benefits from Guler service.',
      goalThreatRating: 75,
      recentGoals: 3,
      recentAssists: 2,
      likelyStarter: true,
      availabilityFactor: 0.95,
    ),
  ];

  static const matches = <WorldCupMatch>[
    WorldCupMatch(
      id: 'qat-sui',
      homeTeamId: 'qat',
      awayTeamId: 'sui',
      stage: 'Group B',
      kickoffLabel: 'Sat 3:00 PM ET',
      venue: 'San Francisco Bay Area Stadium',
      storyline:
          'Qatar need a cleaner tournament start against a Switzerland side built on continuity and winger threat.',
      sourceLabel: scheduleSourceLabel,
      sourceUrl: scheduleSourceUrl,
      dataUpdatedLabel: dataUpdatedLabel,
    ),
    WorldCupMatch(
      id: 'bra-mar',
      homeTeamId: 'bra',
      awayTeamId: 'mar',
      stage: 'Group C',
      kickoffLabel: 'Sat 6:00 PM ET',
      venue: 'New York New Jersey Stadium',
      storyline:
          'Brazil bring star power and pressure; Morocco bring defensive structure and a credible upset path.',
      sourceLabel: scheduleSourceLabel,
      sourceUrl: scheduleSourceUrl,
      dataUpdatedLabel: dataUpdatedLabel,
    ),
    WorldCupMatch(
      id: 'hai-sco',
      homeTeamId: 'hai',
      awayTeamId: 'sco',
      stage: 'Group C',
      kickoffLabel: 'Sat 9:00 PM ET',
      venue: 'Boston Stadium',
      storyline:
          'Haiti return with direct attacking warning signs while Scotland carry their first World Cup moment since 1998.',
      sourceLabel: scheduleSourceLabel,
      sourceUrl: scheduleSourceUrl,
      dataUpdatedLabel: dataUpdatedLabel,
    ),
    WorldCupMatch(
      id: 'aus-tur',
      homeTeamId: 'aus',
      awayTeamId: 'tur',
      stage: 'Group D',
      kickoffLabel: 'Sun 12:00 AM ET',
      venue: 'BC Place Vancouver',
      storyline:
          'Australia test Turkey physicality, but Turkey have the higher-ceiling creator in Arda Guler.',
      sourceLabel: scheduleSourceLabel,
      sourceUrl: scheduleSourceUrl,
      dataUpdatedLabel: dataUpdatedLabel,
    ),
  ];

  static Team teamById(String id) {
    return teams.firstWhere((team) => team.id == id);
  }

  static WorldCupMatch matchById(String id) {
    return matches.firstWhere((match) => match.id == id);
  }

  static List<Player> playersForTeam(String teamId) {
    return players.where((player) => player.teamId == teamId).toList();
  }

  static List<Player> playersForMatch(String matchId) {
    final match = matchById(matchId);
    final matchTeamIds = {match.homeTeamId, match.awayTeamId};
    return players
        .where((player) => matchTeamIds.contains(player.teamId))
        .toList();
  }
}
