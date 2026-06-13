import '../models/player.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';

class SeedData {
  const SeedData._();

  static const teams = <Team>[
    Team(
      id: 'arg',
      name: 'Argentina',
      code: 'ARG',
      flagLabel: 'ARG',
      manager: 'Lionel Scaloni',
      style: 'Compact midfield, quick combinations, late runs into the box',
      attackRating: 88,
      defenseRating: 82,
      formPoints: 13,
      avgGoalsFor: 2.1,
      avgGoalsAgainst: 0.8,
    ),
    Team(
      id: 'fra',
      name: 'France',
      code: 'FRA',
      flagLabel: 'FRA',
      manager: 'Didier Deschamps',
      style: 'Explosive transitions, direct wing play, elite recovery pace',
      attackRating: 90,
      defenseRating: 84,
      formPoints: 12,
      avgGoalsFor: 2.3,
      avgGoalsAgainst: 0.9,
    ),
    Team(
      id: 'bra',
      name: 'Brazil',
      code: 'BRA',
      flagLabel: 'BRA',
      manager: 'Dorival Junior',
      style: 'Wide overloads, flair in isolation, aggressive counter-pressing',
      attackRating: 87,
      defenseRating: 80,
      formPoints: 10,
      avgGoalsFor: 1.9,
      avgGoalsAgainst: 1.0,
    ),
    Team(
      id: 'eng',
      name: 'England',
      code: 'ENG',
      flagLabel: 'ENG',
      manager: 'Gareth Southgate',
      style: 'Structured possession, set-piece threat, controlled tempo',
      attackRating: 86,
      defenseRating: 83,
      formPoints: 11,
      avgGoalsFor: 2.0,
      avgGoalsAgainst: 0.9,
    ),
    Team(
      id: 'usa',
      name: 'United States',
      code: 'USA',
      flagLabel: 'USA',
      manager: 'Mauricio Pochettino',
      style: 'High energy pressing, vertical carries, fast wide attacks',
      attackRating: 78,
      defenseRating: 76,
      formPoints: 8,
      avgGoalsFor: 1.5,
      avgGoalsAgainst: 1.2,
    ),
    Team(
      id: 'por',
      name: 'Portugal',
      code: 'POR',
      flagLabel: 'POR',
      manager: 'Roberto Martinez',
      style: 'Patient build-up, creative midfield rotations, strong crossing',
      attackRating: 85,
      defenseRating: 79,
      formPoints: 10,
      avgGoalsFor: 2.0,
      avgGoalsAgainst: 1.1,
    ),
  ];

  static const players = <Player>[
    Player(
      id: 'messi',
      teamId: 'arg',
      name: 'L. Messi',
      position: 'Forward',
      recentGoals: 4,
      recentAssists: 3,
      likelyStarter: true,
    ),
    Player(
      id: 'alvarez',
      teamId: 'arg',
      name: 'J. Alvarez',
      position: 'Forward',
      recentGoals: 3,
      recentAssists: 2,
      likelyStarter: true,
    ),
    Player(
      id: 'mbappe',
      teamId: 'fra',
      name: 'K. Mbappe',
      position: 'Forward',
      recentGoals: 6,
      recentAssists: 2,
      likelyStarter: true,
    ),
    Player(
      id: 'griezmann',
      teamId: 'fra',
      name: 'A. Griezmann',
      position: 'Midfielder',
      recentGoals: 2,
      recentAssists: 4,
      likelyStarter: true,
    ),
    Player(
      id: 'vinicius',
      teamId: 'bra',
      name: 'V. Junior',
      position: 'Forward',
      recentGoals: 4,
      recentAssists: 3,
      likelyStarter: true,
    ),
    Player(
      id: 'rodrygo',
      teamId: 'bra',
      name: 'Rodrygo',
      position: 'Forward',
      recentGoals: 3,
      recentAssists: 2,
      likelyStarter: true,
    ),
    Player(
      id: 'kane',
      teamId: 'eng',
      name: 'H. Kane',
      position: 'Forward',
      recentGoals: 5,
      recentAssists: 2,
      likelyStarter: true,
    ),
    Player(
      id: 'bellingham',
      teamId: 'eng',
      name: 'J. Bellingham',
      position: 'Midfielder',
      recentGoals: 3,
      recentAssists: 3,
      likelyStarter: true,
    ),
    Player(
      id: 'pulisic',
      teamId: 'usa',
      name: 'C. Pulisic',
      position: 'Forward',
      recentGoals: 3,
      recentAssists: 3,
      likelyStarter: true,
    ),
    Player(
      id: 'balogun',
      teamId: 'usa',
      name: 'F. Balogun',
      position: 'Forward',
      recentGoals: 2,
      recentAssists: 1,
      likelyStarter: true,
    ),
    Player(
      id: 'ronaldo',
      teamId: 'por',
      name: 'C. Ronaldo',
      position: 'Forward',
      recentGoals: 4,
      recentAssists: 1,
      likelyStarter: true,
    ),
    Player(
      id: 'leao',
      teamId: 'por',
      name: 'R. Leao',
      position: 'Forward',
      recentGoals: 3,
      recentAssists: 2,
      likelyStarter: true,
    ),
  ];

  static const matches = <WorldCupMatch>[
    WorldCupMatch(
      id: 'arg-fra',
      homeTeamId: 'arg',
      awayTeamId: 'fra',
      stage: 'Group Stage',
      kickoffLabel: 'Sat 7:00 PM',
      venue: 'MetLife Stadium',
      storyline:
          'A heavyweight rematch built around control versus transition speed.',
    ),
    WorldCupMatch(
      id: 'bra-eng',
      homeTeamId: 'bra',
      awayTeamId: 'eng',
      stage: 'Round of 16',
      kickoffLabel: 'Sun 4:00 PM',
      venue: 'AT&T Stadium',
      storyline: 'Brazilian wing creation meets England set-piece structure.',
    ),
    WorldCupMatch(
      id: 'usa-por',
      homeTeamId: 'usa',
      awayTeamId: 'por',
      stage: 'Group Stage',
      kickoffLabel: 'Tue 8:00 PM',
      venue: 'SoFi Stadium',
      storyline:
          'The hosts test their pressing game against Portugal possession.',
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
