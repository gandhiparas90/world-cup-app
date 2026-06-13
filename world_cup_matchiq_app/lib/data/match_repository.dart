import '../models/player.dart';
import '../models/team.dart';
import '../models/world_cup_match.dart';
import 'seed_data.dart';

class MatchRepository {
  const MatchRepository.seeded();

  List<Team> get teams => SeedData.teams;

  List<WorldCupMatch> get matches => SeedData.matches;

  Team teamById(String id) {
    return SeedData.teamById(id);
  }

  WorldCupMatch matchById(String id) {
    return SeedData.matchById(id);
  }

  List<Player> playersForTeam(String teamId) {
    return SeedData.playersForTeam(teamId);
  }

  List<Player> playersForMatch(String matchId) {
    return SeedData.playersForMatch(matchId);
  }
}
